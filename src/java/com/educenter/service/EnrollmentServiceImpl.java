package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.EnrollmentRepository;
import com.educenter.repository.SystemSettingRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EnrollmentServiceImpl implements EnrollmentService {

    private static final Logger LOGGER = Logger.getLogger(EnrollmentServiceImpl.class.getName());

    private final EnrollmentRepository enrollmentRepository;
    private final SystemSettingRepository systemSettingRepository;

    public EnrollmentServiceImpl() {
        this.enrollmentRepository = new EnrollmentRepository();
        this.systemSettingRepository = new SystemSettingRepository();
    }

    public EnrollmentServiceImpl(EnrollmentRepository repository) {
        this.enrollmentRepository = repository;
        this.systemSettingRepository = new SystemSettingRepository();
    }

    @Override
    public EnrollmentPageDTO getEnrollmentsPaged(Long classId, String status, String keyword, int page, int pageSize) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            int validPage = Math.max(1, page);
            int validPageSize = (pageSize <= 0) ? 10 : pageSize;

            List<EnrollmentViewDTO> items = enrollmentRepository.findEnrollments(em, classId, status, keyword, validPage, validPageSize);
            long total = enrollmentRepository.countEnrollments(em, classId, status, keyword);

            EnrollmentPageDTO pageDTO = new EnrollmentPageDTO(items, total, validPage, validPageSize, classId, status, keyword);

            // KPI stats
            pageDTO.setTotalActive(enrollmentRepository.countEnrollments(em, null, "ACTIVE", null));
            pageDTO.setTotalReserved(enrollmentRepository.countEnrollments(em, null, "RESERVED", null));
            pageDTO.setTotalTransferred(enrollmentRepository.countEnrollments(em, null, "TRANSFERRED", null));
            pageDTO.setTotalDropped(enrollmentRepository.countEnrollments(em, null, "DROPPED", null));

            // Dropdown options
            pageDTO.setClassOptions(enrollmentRepository.findOpenClassOptions(em));
            pageDTO.setStudentOptions(enrollmentRepository.findActiveStudents(em));
            pageDTO.setCourseOptions(getOpenCoursesInternal(em));

            return pageDTO;
        } finally {
            em.close();
        }
    }

    @Override
    public EnrollmentViewDTO enrollStudent(EnrollmentFormDTO form, Long actorId) {
        if (form == null || form.getStudentId() == null || form.getClassId() == null) {
            throw new ValidationException("Học sinh và Lớp học không được để trống!");
        }
        if (form.getStartDate() == null) {
            throw new ValidationException("Ngày bắt đầu học không được để trống!");
        }

        // FR-014: Kiểm tra bắt buộc nộp tiền học phí trước khi ghi danh
        if (form.getPaymentConfirmed() == null || !Boolean.TRUE.equals(form.getPaymentConfirmed())) {
            throw new ValidationException("Học viên chưa nộp tiền học phí! Theo quy định, bắt buộc phải hoàn tất nộp tiền học phí trước khi ghi danh chính thức vào lớp học.");
        }

        String paymentMethod = form.getPaymentMethod();
        if (paymentMethod == null || (!"CASH".equalsIgnoreCase(paymentMethod.trim()) && !"BANK_TRANSFER".equalsIgnoreCase(paymentMethod.trim()))) {
            throw new ValidationException("Vui lòng chọn hình thức nộp tiền học phí hợp lệ: Tiền mặt (CASH) hoặc Chuyển khoản (BANK_TRANSFER).");
        }
        paymentMethod = paymentMethod.trim().toUpperCase();

        if ("BANK_TRANSFER".equals(paymentMethod)) {
            if (form.getTransactionRef() == null || form.getTransactionRef().trim().isEmpty()) {
                throw new ValidationException("Phương thức nộp tiền chuyển khoản ngân hàng bắt buộc phải nhập mã tham chiếu giao dịch!");
            }
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            // B13: Kiểm tra cờ đóng mở tuyển sinh của trung tâm
            String admissionsOpen = systemSettingRepository.getValueByKey(em, SystemSettingServiceImpl.KEY_ADMISSIONS_OPEN);
            if ("false".equalsIgnoreCase(admissionsOpen)) {
                throw new ValidationException("Hệ thống hiện đang tạm đóng tiếp nhận tuyển sinh và ghi danh mới!");
            }

            Student student = em.find(Student.class, form.getStudentId());
            if (student == null) {
                throw new ValidationException("Học sinh không tồn tại trên hệ thống!");
            }
            if (student.getStatus() != null && ("DROPPED".equalsIgnoreCase(student.getStatus()) || "INACTIVE".equalsIgnoreCase(student.getStatus()))) {
                throw new ValidationException("Hồ sơ học sinh không ở trạng thái hoạt động (" + student.getStatus() + "), không thể ghi danh!");
            }

            EduClass eduClass = em.find(EduClass.class, form.getClassId());
            if (eduClass == null) {
                throw new ValidationException("Lớp học không tồn tại!");
            }

            // FR-013: Kiểm tra lớp học phải phù hợp với khóa học đăng ký của học sinh
            if (form.getCourseId() != null && form.getCourseId() > 0) {
                if (eduClass.getCourse() == null || !form.getCourseId().equals(eduClass.getCourse().getId())) {
                    throw new ValidationException("Lớp học đã chọn (" + eduClass.getCode() + ") không thuộc khóa học đăng ký của học sinh!");
                }
            }

            // B07: Kiểm tra trạng thái khóa học
            if (eduClass.getCourse() == null || !"OPEN".equalsIgnoreCase(eduClass.getCourse().getStatus())) {
                throw new ValidationException("Khóa học của lớp đang không ở trạng thái mở tiếp nhận tuyển sinh!");
            }

            // BR02, BR19: Kiểm tra trạng thái lớp học
            String classStatus = eduClass.getStatus();
            if (!"OPEN".equalsIgnoreCase(classStatus) && !"ONGOING".equalsIgnoreCase(classStatus)) {
                throw new ValidationException("Lớp học đang ở trạng thái '" + classStatus + "', không thể tiếp nhận ghi danh mới!");
            }

            // Kiểm tra ngày bắt đầu trong kỳ lớp
            if (form.getStartDate().isBefore(eduClass.getStartDate()) || form.getStartDate().isAfter(eduClass.getEndDate())) {
                throw new ValidationException("Ngày bắt đầu học (" + form.getStartDate() + ") phải nằm trong thời gian lớp học ("
                        + eduClass.getStartDate() + " đến " + eduClass.getEndDate() + ")!");
            }

            // BR03: Chặn ghi danh trùng học sinh/lớp
            if (enrollmentRepository.isStudentActiveOrReservedInClass(em, student.getId(), eduClass.getId())) {
                throw new ValidationException("Học sinh này đã có ghi danh đang theo học hoặc đang bảo lưu trong lớp " + eduClass.getName() + "!");
            }

            // BR07: Kiểm tra xung đột thời khóa biểu
            if (enrollmentRepository.hasScheduleConflict(em, student.getId(), eduClass.getId())) {
                throw new ValidationException("Lớp học " + eduClass.getCode() + " bị xung đột lịch học với lớp khác học sinh đang theo học!");
            }

            tx.begin();

            // B07: Khóa kiểm tra sĩ số bên trong transaction để bảo vệ chỗ cuối
            long currentActive = enrollmentRepository.countActiveByClassId(em, eduClass.getId());
            if (currentActive >= eduClass.getCapacity()) {
                throw new ValidationException("Lớp học " + eduClass.getCode() + " đã đạt sĩ số tối đa (" + eduClass.getCapacity() + " học viên). Không còn chỗ trống để ghi danh!");
            }

            // 1. Tạo Enrollment ACTIVE
            Enrollment enrollment = new Enrollment();
            enrollment.setStudent(student);
            enrollment.setEduClass(eduClass);
            enrollment.setStatus("ACTIVE");
            enrollment.setEnrolledAt(LocalDateTime.now());
            enrollment.setStartDate(form.getStartDate());
            enrollment.setNotes(form.getNotes());
            enrollment.setCreatedAt(LocalDateTime.now());
            enrollment.setUpdatedAt(LocalDateTime.now());

            enrollmentRepository.save(em, enrollment);
            em.flush(); // Lấy ID của enrollment

            // 2. Tạo Hóa đơn PAID đồng bộ do đã nộp tiền (FR-014, BR12)
            BigDecimal courseFee = eduClass.getCourse().getFee() != null ? eduClass.getCourse().getFee() : BigDecimal.ZERO;
            Invoice invoice = new Invoice();
            String codeSuffix = String.format("%05d", (System.currentTimeMillis() % 100000));
            invoice.setInvoiceCode("INV-" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" + codeSuffix);
            invoice.setEnrollment(enrollment);
            invoice.setStudent(student);
            invoice.setTotalAmount(courseFee);
            invoice.setDiscountAmount(BigDecimal.ZERO);
            invoice.setFinalAmount(courseFee);
            invoice.setStatus("PAID"); // Đã thanh toán đầy đủ khi ghi danh
            invoice.setDueDate(LocalDate.now());
            invoice.setNotes("Hóa đơn đã thu đủ học phí khi ghi danh vào lớp " + eduClass.getName() + " (" + ("CASH".equals(paymentMethod) ? "Tiền mặt" : "Chuyển khoản") + ")");
            invoice.setCreatedAt(LocalDateTime.now());
            invoice.setUpdatedAt(LocalDateTime.now());

            InvoiceItem item = new InvoiceItem();
            item.setDescription("Học phí khóa: " + eduClass.getCourse().getName() + " (Lớp: " + eduClass.getCode() + ")");
            item.setUnitPrice(courseFee);
            item.setQuantity(1);
            item.setAmount(courseFee);
            item.setCreatedAt(LocalDateTime.now());
            invoice.addItem(item);

            enrollmentRepository.saveInvoice(em, invoice);
            em.flush();

            // 3. Tạo bản ghi Thanh toán (Payment) tương ứng
            String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            String suffix = UUID.randomUUID().toString().substring(0, 5).toUpperCase();
            String paymentCode = "PAY-" + datePart + "-" + suffix;

            Payment payment = new Payment();
            payment.setPaymentCode(paymentCode);
            payment.setInvoice(invoice);
            payment.setAmount(courseFee);
            payment.setPaymentMethod(paymentMethod);
            payment.setTransactionRef("BANK_TRANSFER".equals(paymentMethod) && form.getTransactionRef() != null ? form.getTransactionRef().trim() : null);
            payment.setPaidAt(LocalDateTime.now());
            User confirmedActor = null;
            if (actorId != null) {
                confirmedActor = em.find(User.class, actorId);
            }
            if (confirmedActor == null) {
                List<User> staffUsers = em.createQuery("SELECT u FROM User u WHERE u.status = 'ACTIVE' ORDER BY u.id ASC", User.class)
                        .setMaxResults(1).getResultList();
                if (!staffUsers.isEmpty()) {
                    confirmedActor = staffUsers.get(0);
                }
            }
            payment.setConfirmedBy(confirmedActor);
            payment.setNotes("Thu tiền học phí khi hoàn tất ghi danh vào lớp " + eduClass.getCode());
            payment.setStatus("CONFIRMED");
            payment.setCreatedAt(LocalDateTime.now());
            em.persist(payment);

            tx.commit();
            LOGGER.info("Ghi danh thành công học sinh " + student.getFullName() + " vào lớp " + eduClass.getCode() + ", Đã thu học phí: " + courseFee + ", Hóa đơn: " + invoice.getInvoiceCode());

            EnrollmentViewDTO dto = new EnrollmentViewDTO();
            dto.setEnrollmentId(enrollment.getId());
            dto.setStudentId(student.getId());
            dto.setStudentCode(student.getCode());
            dto.setStudentName(student.getFullName());
            dto.setStudentPhone(student.getPhone());
            dto.setClassId(eduClass.getId());
            dto.setClassCode(eduClass.getCode());
            dto.setClassName(eduClass.getName());
            dto.setSubjectName(eduClass.getCourse().getSubject().getName());
            dto.setCourseFee(courseFee);
            dto.setStatus(enrollment.getStatus());
            dto.setEnrolledAt(enrollment.getEnrolledAt());
            dto.setStartDate(enrollment.getStartDate());
            dto.setInvoiceId(invoice.getId());
            dto.setInvoiceCode(invoice.getInvoiceCode());
            dto.setInvoiceStatus(invoice.getStatus());
            dto.setNotes(enrollment.getNotes());
            return dto;

        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi ghi danh học sinh: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi hệ thống khi xử lý ghi danh: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void transferClass(Long enrollmentId, Long newClassId, LocalDate transferDate, String notes, Long actorId) {
        if (enrollmentId == null || newClassId == null) {
            throw new ValidationException("Thông tin ghi danh và lớp mới không được để trống!");
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Enrollment oldEnrollment = em.find(Enrollment.class, enrollmentId);
            if (oldEnrollment == null) {
                throw new ValidationException("Bản ghi ghi danh không tồn tại!");
            }
            if (!"ACTIVE".equalsIgnoreCase(oldEnrollment.getStatus())) {
                throw new ValidationException("Chỉ có thể chuyển lớp cho học viên đang ở trạng thái ACTIVE!");
            }

            if (oldEnrollment.getEduClass().getId().equals(newClassId)) {
                throw new ValidationException("Lớp học mới phải khác lớp học hiện tại!");
            }

            EduClass newClass = em.find(EduClass.class, newClassId);
            if (newClass == null) {
                throw new ValidationException("Lớp học chuyển đến không tồn tại!");
            }
            if (!"OPEN".equalsIgnoreCase(newClass.getStatus()) && !"ONGOING".equalsIgnoreCase(newClass.getStatus())) {
                throw new ValidationException("Lớp học chuyển đến không ở trạng thái mở tiếp nhận!");
            }

            // Kiểm tra sĩ số lớp mới
            long currentActive = enrollmentRepository.countActiveByClassId(em, newClass.getId());
            if (currentActive >= newClass.getCapacity()) {
                throw new ValidationException("Lớp học chuyển đến (" + newClass.getName() + ") đã đầy sĩ số!");
            }

            // B08: Chặn ghi danh trùng ở lớp đích
            if (enrollmentRepository.isStudentActiveOrReservedInClass(em, oldEnrollment.getStudent().getId(), newClass.getId())) {
                throw new ValidationException("Học sinh này đã có ghi danh đang theo học hoặc bảo lưu trong lớp đích " + newClass.getName() + "!");
            }

            // B08: Kiểm tra xung đột lịch học lớp mới (loại trừ các buổi của lớp cũ đang chuyển đi)
            if (enrollmentRepository.hasScheduleConflictExcludingClass(em, oldEnrollment.getStudent().getId(), newClass.getId(), oldEnrollment.getEduClass().getId())) {
                throw new ValidationException("Học sinh bị xung đột lịch học với lớp chuyển đến!");
            }

            tx.begin();

            LocalDate effDate = (transferDate != null) ? transferDate : LocalDate.now();

            // 1. Kết thúc enrollment cũ
            oldEnrollment.setStatus("TRANSFERRED");
            oldEnrollment.setEndDate(effDate);
            String oldNote = oldEnrollment.getNotes() != null ? oldEnrollment.getNotes() : "";
            oldEnrollment.setNotes(oldNote + " | [Đã chuyển sang lớp " + newClass.getCode() + "]");
            oldEnrollment.setUpdatedAt(LocalDateTime.now());
            enrollmentRepository.save(em, oldEnrollment);

            // 2. Tạo enrollment mới ở lớp đích
            Enrollment newEnrollment = new Enrollment();
            newEnrollment.setStudent(oldEnrollment.getStudent());
            newEnrollment.setEduClass(newClass);
            newEnrollment.setStatus("ACTIVE");
            newEnrollment.setEnrolledAt(LocalDateTime.now());
            newEnrollment.setStartDate(effDate);
            newEnrollment.setNotes("Chuyển từ lớp " + oldEnrollment.getEduClass().getCode() + (notes != null && !notes.isBlank() ? " | " + notes : ""));
            newEnrollment.setCreatedAt(LocalDateTime.now());
            newEnrollment.setUpdatedAt(LocalDateTime.now());
            enrollmentRepository.save(em, newEnrollment);

            tx.commit();
            LOGGER.info("Chuyển lớp thành công cho học sinh " + oldEnrollment.getStudent().getFullName() + " từ " + oldEnrollment.getEduClass().getCode() + " sang " + newClass.getCode());

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi chuyển lớp: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi chuyển lớp: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void reserveEnrollment(Long enrollmentId, String reason, Long actorId) {
        if (enrollmentId == null) {
            throw new ValidationException("Mã ghi danh không hợp lệ!");
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Enrollment enrollment = em.find(Enrollment.class, enrollmentId);
            if (enrollment == null) {
                throw new ValidationException("Bản ghi ghi danh không tồn tại!");
            }
            if (!"ACTIVE".equalsIgnoreCase(enrollment.getStatus())) {
                throw new ValidationException("Chỉ có thể bảo lưu khi học viên đang ACTIVE!");
            }

            tx.begin();
            enrollment.setStatus("RESERVED");
            String oldNote = enrollment.getNotes() != null ? enrollment.getNotes() : "";
            enrollment.setNotes(oldNote + " | [Bảo lưu: " + (reason != null ? reason : "Theo yêu cầu") + "]");
            enrollment.setUpdatedAt(LocalDateTime.now());
            enrollmentRepository.save(em, enrollment);
            tx.commit();

            LOGGER.info("Bảo lưu thành công cho ghi danh ID: " + enrollmentId);
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi bảo lưu: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi bảo lưu: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void resumeEnrollment(Long enrollmentId, Long actorId) {
        if (enrollmentId == null) {
            throw new ValidationException("Mã ghi danh không hợp lệ!");
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Enrollment enrollment = em.find(Enrollment.class, enrollmentId);
            if (enrollment == null) {
                throw new ValidationException("Bản ghi ghi danh không tồn tại!");
            }
            if (!"RESERVED".equalsIgnoreCase(enrollment.getStatus())) {
                throw new ValidationException("Chỉ có thể phục hồi học tập cho bản ghi đang ở trạng thái RESERVED!");
            }

            EduClass eduClass = enrollment.getEduClass();
            if (!"OPEN".equalsIgnoreCase(eduClass.getStatus()) && !"ONGOING".equalsIgnoreCase(eduClass.getStatus())) {
                throw new ValidationException("Lớp học hiện tại không ở trạng thái mở để quay lại học!");
            }

            // Kiểm tra sĩ số lớp hiện tại
            long activeCount = enrollmentRepository.countActiveByClassId(em, eduClass.getId());
            if (activeCount >= eduClass.getCapacity()) {
                throw new ValidationException("Lớp học đã đầy sĩ số (" + eduClass.getCapacity() + " học viên). Không thể phục hồi vào lớp này!");
            }

            // B08: Khôi phục sau bảo lưu phải kiểm tra lại xung đột thời khóa biểu
            if (enrollmentRepository.hasScheduleConflict(em, enrollment.getStudent().getId(), eduClass.getId())) {
                throw new ValidationException("Học sinh bị xung đột lịch học giữa lớp " + eduClass.getCode() + " và lớp học khác đang tham gia!");
            }

            tx.begin();
            enrollment.setStatus("ACTIVE");
            enrollment.setUpdatedAt(LocalDateTime.now());
            enrollmentRepository.save(em, enrollment);
            tx.commit();

            LOGGER.info("Phục hồi học tập thành công cho ghi danh ID: " + enrollmentId);
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi phục hồi học tập: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi phục hồi học tập: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void updateEnrollmentStatus(Long enrollmentId, String newStatus, String reason, Long actorId) {
        if (enrollmentId == null || newStatus == null || newStatus.isBlank()) {
            throw new ValidationException("Mã ghi danh và trạng thái mới không được để trống!");
        }
        String upperStatus = newStatus.trim().toUpperCase();
        if (!"DROPPED".equals(upperStatus) && !"COMPLETED".equals(upperStatus)) {
            throw new ValidationException("Trạng thái cập nhật không hợp lệ (chỉ cho phép DROPPED hoặc COMPLETED)!");
        }

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Enrollment enrollment = em.find(Enrollment.class, enrollmentId);
            if (enrollment == null) {
                throw new ValidationException("Bản ghi ghi danh không tồn tại!");
            }

            tx.begin();
            enrollment.setStatus(upperStatus);
            enrollment.setEndDate(LocalDate.now());
            String oldNote = enrollment.getNotes() != null ? enrollment.getNotes() : "";
            enrollment.setNotes(oldNote + " | [" + upperStatus + ": " + (reason != null ? reason : "") + "]");
            enrollment.setUpdatedAt(LocalDateTime.now());
            enrollmentRepository.save(em, enrollment);
            tx.commit();

            LOGGER.info("Cập nhật trạng thái " + upperStatus + " thành công cho ghi danh ID: " + enrollmentId);
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi cập nhật trạng thái: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<EnrollmentViewDTO> getEnrollmentById(Long id) {
        if (id == null) return Optional.empty();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Optional<Enrollment> opt = enrollmentRepository.findById(em, id);
            if (opt.isEmpty()) return Optional.empty();

            Enrollment e = opt.get();
            EnrollmentViewDTO dto = new EnrollmentViewDTO();
            dto.setEnrollmentId(e.getId());
            dto.setStudentId(e.getStudent().getId());
            dto.setStudentCode(e.getStudent().getCode());
            dto.setStudentName(e.getStudent().getFullName());
            dto.setStudentPhone(e.getStudent().getPhone());

            dto.setClassId(e.getEduClass().getId());
            dto.setClassCode(e.getEduClass().getCode());
            dto.setClassName(e.getEduClass().getName());
            dto.setSubjectName(e.getEduClass().getCourse().getSubject().getName());
            dto.setCourseFee(e.getEduClass().getCourse().getFee());

            dto.setStatus(e.getStatus());
            dto.setEnrolledAt(e.getEnrolledAt());
            dto.setStartDate(e.getStartDate());
            dto.setEndDate(e.getEndDate());
            dto.setNotes(e.getNotes());

            Optional<Invoice> invOpt = enrollmentRepository.findInvoiceByEnrollmentId(em, e.getId());
            if (invOpt.isPresent()) {
                dto.setInvoiceId(invOpt.get().getId());
                dto.setInvoiceCode(invOpt.get().getInvoiceCode());
                dto.setInvoiceStatus(invOpt.get().getStatus());
            }

            return Optional.of(dto);
        } finally {
            em.close();
        }
    }

    @Override
    public List<ClassEnrollmentOptionDTO> getOpenClassOptions() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return enrollmentRepository.findOpenClassOptions(em);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Student> getActiveStudents() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return enrollmentRepository.findActiveStudents(em);
        } finally {
            em.close();
        }
    }

    @Override
    public Student getOrCreateStudentFromLead(Long leadId) {
        if (leadId == null) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            Lead lead = em.find(Lead.class, leadId);
            if (lead == null) {
                return null;
            }

            String phone = (lead.getPhone() != null) ? lead.getPhone().trim() : "";
            if (!phone.isEmpty()) {
                List<Student> existingByPhone = em.createQuery(
                        "SELECT s FROM Student s WHERE s.phone = :phone", Student.class)
                        .setParameter("phone", phone)
                        .getResultList();

                if (!existingByPhone.isEmpty()) {
                    return existingByPhone.get(0);
                }
            }

            String email = (lead.getEmail() != null) ? lead.getEmail().trim() : "";
            if (!email.isEmpty()) {
                List<Student> existingByEmail = em.createQuery(
                        "SELECT s FROM Student s WHERE s.email = :email", Student.class)
                        .setParameter("email", email)
                        .getResultList();
                if (!existingByEmail.isEmpty()) {
                    return existingByEmail.get(0);
                }
            }

            tx.begin();
            Student newStudent = new Student();
            newStudent.setFullName(lead.getName());
            newStudent.setPhone(phone.isEmpty() ? null : phone);
            newStudent.setEmail(email.isEmpty() ? null : email);
            newStudent.setGradeLevel(lead.getGradeLevel() != null ? lead.getGradeLevel() : 10);
            newStudent.setStatus("STUDYING");
            newStudent.setCreatedAt(LocalDateTime.now());
            newStudent.setUpdatedAt(LocalDateTime.now());

            em.persist(newStudent);
            tx.commit();
            return newStudent;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy hoặc tạo học sinh từ Lead: " + e.getMessage(), e);
            throw new RuntimeException("Không thể khởi tạo hồ sơ học viên từ thông tin tư vấn: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void markLeadAsEnrolled(Long leadId) {
        if (leadId == null) return;
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Lead lead = em.find(Lead.class, leadId);
            if (lead != null) {
                lead.setStatus("ENROLLED");
                lead.setUpdatedAt(LocalDateTime.now());
                em.merge(lead);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            LOGGER.log(Level.WARNING, "Không thể cập nhật trạng thái Lead sang ENROLLED: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Long> getStudentRegisteredCourseIds(Long studentId) {
        if (studentId == null || studentId <= 0) return List.of();
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return enrollmentRepository.findStudentRegisteredCourseIds(em, studentId);
        } finally {
            em.close();
        }
    }

    @Override
    public List<ClassEnrollmentOptionDTO> getOpenClassOptionsForStudent(Long studentId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return enrollmentRepository.findOpenClassOptionsForStudent(em, studentId);
        } finally {
            em.close();
        }
    }

    @Override
    public List<CourseAdminViewDTO> getOpenCourses() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return getOpenCoursesInternal(em);
        } finally {
            em.close();
        }
    }

    private List<CourseAdminViewDTO> getOpenCoursesInternal(EntityManager em) {
        jakarta.persistence.TypedQuery<Course> q = em.createQuery(
                "SELECT c FROM Course c JOIN FETCH c.subject s WHERE c.status = 'OPEN' ORDER BY c.gradeLevel ASC, c.name ASC",
                Course.class
        );
        List<Course> list = q.getResultList();
        List<CourseAdminViewDTO> dtos = new java.util.ArrayList<>();
        for (Course c : list) {
            CourseAdminViewDTO dto = new CourseAdminViewDTO();
            dto.setId(c.getId());
            dto.setCode(c.getCode());
            dto.setName(c.getName());
            dto.setGradeLevel(c.getGradeLevel());
            dto.setFee(c.getFee());
            dto.setSubjectName(c.getSubject() != null ? c.getSubject().getName() : "");
            dto.setTotalSessions(c.getTotalSessions());
            dto.setMaxCapacity(c.getMaxCapacity());
            dto.setStatus(c.getStatus());
            dtos.add(dto);
        }
        return dtos;
    }

    @Override
    public Long getCourseIdFromLead(Long leadId) {
        if (leadId == null || leadId <= 0) return null;
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Lead lead = em.find(Lead.class, leadId);
            if (lead == null || lead.getNotes() == null) return null;
            List<Course> allCourses = em.createQuery("SELECT c FROM Course c WHERE c.status = 'OPEN'", Course.class).getResultList();
            for (Course c : allCourses) {
                if (lead.getNotes().contains("[" + c.getCode() + "]") || lead.getNotes().contains(c.getName())) {
                    return c.getId();
                }
            }
            return null;
        } finally {
            em.close();
        }
    }
}
