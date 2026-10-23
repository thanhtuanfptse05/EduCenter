package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Course;
import com.educenter.entity.Subject;
import com.educenter.service.ValidationException;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.SubjectRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AcademicProgramServiceImpl implements AcademicProgramService {

    private static final Logger LOGGER = Logger.getLogger(AcademicProgramServiceImpl.class.getName());

    private final SubjectRepository subjectRepository;
    private final CourseRepository courseRepository;
    private final AuditLogRepository auditLogRepository;
    private final Supplier<EntityManager> entityManagerSupplier;

    public AcademicProgramServiceImpl() {
        this(new SubjectRepository(), new CourseRepository(), new AuditLogRepository(), JPAUtil::getEntityManager);
    }

    public AcademicProgramServiceImpl(SubjectRepository subjectRepository,
                                      CourseRepository courseRepository,
                                      AuditLogRepository auditLogRepository,
                                      Supplier<EntityManager> entityManagerSupplier) {
        this.subjectRepository = subjectRepository;
        this.courseRepository = courseRepository;
        this.auditLogRepository = auditLogRepository;
        this.entityManagerSupplier = entityManagerSupplier;
    }

    // ==========================================
    // 1. SUBJECT MANAGEMENT
    // ==========================================

    @Override
    public List<SubjectAdminViewDTO> getSubjectAdminList() {
        EntityManager em = entityManagerSupplier.get();
        try {
            List<Subject> subjects = subjectRepository.findAllAdmin(em);
            List<SubjectAdminViewDTO> result = new ArrayList<>();
            for (Subject s : subjects) {
                SubjectAdminViewDTO dto = new SubjectAdminViewDTO();
                dto.setId(s.getId());
                dto.setCode(s.getCode());
                dto.setName(s.getName());
                dto.setDescription(s.getDescription());
                dto.setStatus(s.getStatus());
                dto.setCreatedAt(s.getCreatedAt());
                dto.setTotalCourses(subjectRepository.countCoursesBySubject(em, s.getId()));
                dto.setOpenCourses(subjectRepository.countOpenCoursesBySubject(em, s.getId()));
                result.add(dto);
            }
            return result;
        } finally {
            em.close();
        }
    }

    @Override
    public SubjectFormDTO getSubjectForm(Long id) {
        if (id == null) {
            return new SubjectFormDTO();
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Subject s = subjectRepository.findById(em, id)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy môn học có ID: " + id));
            return new SubjectFormDTO(s.getId(), s.getCode(), s.getName(), s.getDescription(), s.getStatus());
        } finally {
            em.close();
        }
    }

    @Override
    public void saveSubject(SubjectFormDTO dto, Long actorId, String actorEmail, String ipAddress) {
        if (dto == null) {
            throw new ValidationException("Dữ liệu môn học không hợp lệ.");
        }

        String code = (dto.getCode() != null) ? dto.getCode().trim().toUpperCase() : "";
        String name = (dto.getName() != null) ? dto.getName().trim() : "";
        String description = (dto.getDescription() != null) ? dto.getDescription().trim() : "";
        String status = ("INACTIVE".equalsIgnoreCase(dto.getStatus())) ? "INACTIVE" : "ACTIVE";

        if (code.length() < 2 || code.length() > 20) {
            throw new ValidationException("Mã môn học phải từ 2 đến 20 ký tự.");
        }
        if (name.length() < 2 || name.length() > 100) {
            throw new ValidationException("Tên môn học phải từ 2 đến 100 ký tự.");
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            if (subjectRepository.existsByCode(em, code, dto.getId())) {
                throw new ValidationException("Mã môn học '" + code + "' đã tồn tại trên hệ thống.");
            }

            if (dto.getId() == null) {
                // Tạo mới
                Subject subject = new Subject();
                subject.setCode(code);
                subject.setName(name);
                subject.setDescription(description);
                subject.setStatus(status);
                subject.setCreatedAt(LocalDateTime.now());
                subjectRepository.save(em, subject);

                AuditLog log = new AuditLog(
                        actorId,
                        "CREATE_SUBJECT",
                        "Subjects",
                        subject.getId(),
                        null,
                        "Code: " + code + ", Name: " + name + ", Status: " + status,
                        ipAddress
                );
                auditLogRepository.save(em, log);
            } else {
                // Cập nhật
                Subject subject = subjectRepository.findById(em, dto.getId())
                        .orElseThrow(() -> new ValidationException("Không tìm thấy môn học để cập nhật."));

                // BR16: Không cho phép ngừng môn khi còn khóa OPEN
                if ("ACTIVE".equalsIgnoreCase(subject.getStatus()) && "INACTIVE".equals(status)) {
                    long openCount = subjectRepository.countOpenCoursesBySubject(em, subject.getId());
                    if (openCount > 0) {
                        throw new ValidationException("Không thể ngừng môn học đang có " + openCount + " khóa học mở tuyển sinh. Vui lòng đóng hoặc lưu trữ các khóa học trước!");
                    }
                }

                String oldData = "Code: " + subject.getCode() + ", Name: " + subject.getName() + ", Status: " + subject.getStatus();
                subject.setCode(code);
                subject.setName(name);
                subject.setDescription(description);
                subject.setStatus(status);
                subjectRepository.update(em, subject);

                String newData = "Code: " + code + ", Name: " + name + ", Status: " + status;
                AuditLog log = new AuditLog(
                        actorId,
                        "UPDATE_SUBJECT",
                        "Subjects",
                        subject.getId(),
                        oldData,
                        newData,
                        ipAddress
                );
                auditLogRepository.save(em, log);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw e;
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu môn học: " + e.getMessage(), e);
            throw new ValidationException("Lỗi hệ thống khi lưu môn học: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public void toggleSubjectStatus(Long subjectId, Long actorId, String actorEmail, String ipAddress) {
        if (subjectId == null) {
            throw new ValidationException("ID môn học không hợp lệ.");
        }
        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Subject subject = subjectRepository.findById(em, subjectId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy môn học có ID: " + subjectId));

            String oldStatus = subject.getStatus();
            String newStatus = "ACTIVE".equalsIgnoreCase(oldStatus) ? "INACTIVE" : "ACTIVE";

            // BR16: Nếu muốn tắt thành INACTIVE, kiểm tra khóa OPEN
            if ("INACTIVE".equals(newStatus)) {
                long openCount = subjectRepository.countOpenCoursesBySubject(em, subjectId);
                if (openCount > 0) {
                    throw new ValidationException("Không thể ngừng môn học đang có " + openCount + " khóa học mở tuyển sinh. Vui lòng đóng hoặc lưu trữ các khóa học trước!");
                }
            }

            subject.setStatus(newStatus);
            subjectRepository.update(em, subject);

            AuditLog log = new AuditLog(
                    actorId,
                    "TOGGLE_SUBJECT_STATUS",
                    "Subjects",
                    subject.getId(),
                    "Status: " + oldStatus,
                    "Status: " + newStatus,
                    ipAddress
            );
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw e;
            LOGGER.log(Level.SEVERE, "Lỗi khi đổi trạng thái môn học: " + e.getMessage(), e);
            throw new ValidationException("Lỗi hệ thống khi đổi trạng thái môn học: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public List<Subject> getActiveSubjects() {
        EntityManager em = entityManagerSupplier.get();
        try {
            return subjectRepository.findAllActive(em);
        } finally {
            em.close();
        }
    }

    // ==========================================
    // 2. COURSE MANAGEMENT
    // ==========================================

    @Override
    public List<CourseAdminViewDTO> getCourseAdminList(CourseFilterDTO filter) {
        if (filter == null) {
            filter = new CourseFilterDTO();
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            List<Course> courses = courseRepository.findAdminCourses(em, filter);
            List<CourseAdminViewDTO> result = new ArrayList<>();
            for (Course c : courses) {
                CourseAdminViewDTO dto = new CourseAdminViewDTO();
                dto.setId(c.getId());
                dto.setCode(c.getCode());
                dto.setName(c.getName());
                if (c.getSubject() != null) {
                    dto.setSubjectId(c.getSubject().getId());
                    dto.setSubjectName(c.getSubject().getName());
                    dto.setSubjectCode(c.getSubject().getCode());
                }
                dto.setGradeLevel(c.getGradeLevel());
                dto.setTargetExam(c.getTargetExam());
                dto.setFee(c.getFee());
                dto.setDurationWeeks(c.getDurationWeeks());
                dto.setTotalSessions(c.getTotalSessions());
                dto.setMaxCapacity(c.getMaxCapacity());
                dto.setIsFeatured(c.getIsFeatured());
                dto.setStatus(c.getStatus());
                dto.setCreatedAt(c.getCreatedAt());
                dto.setUpdatedAt(c.getUpdatedAt());
                dto.setOpenClassCount(courseRepository.countOpenClassesByCourse(em, c.getId()));
                dto.setTotalClassCount(courseRepository.countClassesByCourse(em, c.getId()));
                result.add(dto);
            }
            return result;
        } finally {
            em.close();
        }
    }

    @Override
    public long countCourseAdminList(CourseFilterDTO filter) {
        if (filter == null) {
            filter = new CourseFilterDTO();
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            return courseRepository.countAdminCourses(em, filter);
        } finally {
            em.close();
        }
    }

    @Override
    public CourseAdminStatsDTO getCourseAdminStats() {
        EntityManager em = entityManagerSupplier.get();
        try {
            return courseRepository.getAdminStats(em);
        } finally {
            em.close();
        }
    }

    @Override
    public CourseFormDTO getCourseForm(Long id) {
        if (id == null) {
            return new CourseFormDTO();
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Course c = courseRepository.findById(em, id)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy khóa học có ID: " + id));

            CourseFormDTO form = new CourseFormDTO();
            form.setId(c.getId());
            form.setSubjectId(c.getSubject() != null ? c.getSubject().getId() : null);
            form.setCode(c.getCode());
            form.setName(c.getName());
            form.setGradeLevel(c.getGradeLevel());
            form.setTargetExam(c.getTargetExam());
            form.setFee(c.getFee());
            form.setDurationWeeks(c.getDurationWeeks());
            form.setTotalSessions(c.getTotalSessions());
            form.setMaxCapacity(c.getMaxCapacity());
            form.setDescription(c.getDescription());
            form.setImageUrl(c.getImageUrl());
            form.setIsFeatured(c.getIsFeatured());
            form.setStatus(c.getStatus());
            return form;
        } finally {
            em.close();
        }
    }

    @Override
    public void saveCourse(CourseFormDTO dto, Long actorId, String actorEmail, String ipAddress) {
        if (dto == null) {
            throw new ValidationException("Dữ liệu khóa học không hợp lệ.");
        }

        String code = (dto.getCode() != null) ? dto.getCode().trim().toUpperCase() : "";
        String name = (dto.getName() != null) ? dto.getName().trim() : "";
        Long subjectId = dto.getSubjectId();
        Integer grade = dto.getGradeLevel();
        BigDecimal fee = (dto.getFee() != null) ? dto.getFee() : BigDecimal.ZERO;
        Integer duration = (dto.getDurationWeeks() != null) ? dto.getDurationWeeks() : 12;
        Integer sessions = (dto.getTotalSessions() != null) ? dto.getTotalSessions() : 24;
        Integer capacity = (dto.getMaxCapacity() != null) ? dto.getMaxCapacity() : 15;
        String status = (dto.getStatus() != null && Set.of("OPEN", "CLOSED", "ARCHIVED").contains(dto.getStatus().toUpperCase()))
                ? dto.getStatus().toUpperCase() : "OPEN";

        // Validate
        if (code.length() < 3 || code.length() > 50) {
            throw new ValidationException("Mã khóa học phải từ 3 đến 50 ký tự.");
        }
        if (name.length() < 5 || name.length() > 200) {
            throw new ValidationException("Tên khóa học phải từ 5 đến 200 ký tự.");
        }
        if (subjectId == null) {
            throw new ValidationException("Vui lòng chọn môn học trực thuộc.");
        }
        if (grade == null || grade < 6 || grade > 12) {
            throw new ValidationException("Khối lớp phải nằm trong khoảng từ 6 đến 12.");
        }
        if (fee.compareTo(BigDecimal.ZERO) < 0) {
            throw new ValidationException("Học phí niêm yết không được là số âm.");
        }
        if (duration <= 0 || duration > 52) {
            throw new ValidationException("Thời lượng khóa học phải từ 1 đến 52 tuần.");
        }
        if (sessions <= 0 || sessions > 150) {
            throw new ValidationException("Tổng số buổi học phải từ 1 đến 150 buổi.");
        }
        if (capacity <= 0 || capacity > 100) {
            throw new ValidationException("Sĩ số khuyến nghị phải từ 1 đến 100 học viên.");
        }

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            if (courseRepository.existsByCode(em, code, dto.getId())) {
                throw new ValidationException("Mã khóa học '" + code + "' đã tồn tại trên hệ thống.");
            }

            Subject subject = subjectRepository.findById(em, subjectId)
                    .orElseThrow(() -> new ValidationException("Môn học không tồn tại."));

            if ("OPEN".equals(status) && !"ACTIVE".equalsIgnoreCase(subject.getStatus())) {
                throw new ValidationException("Không thể mở tuyển sinh khóa học cho môn học đang ngừng hoạt động.");
            }

            if (dto.getId() == null) {
                // Tạo mới
                Course course = new Course();
                course.setSubject(subject);
                course.setCode(code);
                course.setName(name);
                course.setGradeLevel(grade);
                course.setTargetExam(dto.getTargetExam());
                course.setFee(fee);
                course.setDurationWeeks(duration);
                course.setTotalSessions(sessions);
                course.setMaxCapacity(capacity);
                course.setDescription(dto.getDescription());
                course.setImageUrl(dto.getImageUrl());
                course.setIsFeatured(Boolean.TRUE.equals(dto.getIsFeatured()));
                course.setStatus(status);
                course.setCreatedAt(LocalDateTime.now());
                course.setUpdatedAt(LocalDateTime.now());

                courseRepository.save(em, course);

                AuditLog log = new AuditLog(
                        actorId,
                        "CREATE_COURSE",
                        "Courses",
                        course.getId(),
                        null,
                        "Code: " + code + ", Name: " + name + ", Fee: " + fee + ", Status: " + status,
                        ipAddress
                );
                auditLogRepository.save(em, log);
            } else {
                // Cập nhật
                Course course = courseRepository.findById(em, dto.getId())
                        .orElseThrow(() -> new ValidationException("Không tìm thấy khóa học để cập nhật."));

                BigDecimal oldFee = course.getFee();
                boolean feeChanged = (oldFee != null && oldFee.compareTo(fee) != 0);

                course.setSubject(subject);
                course.setCode(code);
                course.setName(name);
                course.setGradeLevel(grade);
                course.setTargetExam(dto.getTargetExam());
                course.setFee(fee);
                course.setDurationWeeks(duration);
                course.setTotalSessions(sessions);
                course.setMaxCapacity(capacity);
                course.setDescription(dto.getDescription());
                course.setImageUrl(dto.getImageUrl());
                course.setIsFeatured(Boolean.TRUE.equals(dto.getIsFeatured()));
                course.setStatus(status);
                course.setUpdatedAt(LocalDateTime.now());

                courseRepository.update(em, course);

                // BR18: Audit fee changes specifically
                if (feeChanged) {
                    AuditLog feeAudit = new AuditLog(
                            actorId,
                            "UPDATE_COURSE_FEE",
                            "Courses",
                            course.getId(),
                            oldFee.toPlainString(),
                            fee.toPlainString(),
                            ipAddress
                    );
                    auditLogRepository.save(em, feeAudit);
                }

                AuditLog log = new AuditLog(
                        actorId,
                        "UPDATE_COURSE",
                        "Courses",
                        course.getId(),
                        "Code: " + course.getCode() + ", Fee: " + oldFee,
                        "Code: " + code + ", Fee: " + fee + ", Status: " + status,
                        ipAddress
                );
                auditLogRepository.save(em, log);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw e;
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu khóa học: " + e.getMessage(), e);
            throw new ValidationException("Lỗi hệ thống khi lưu khóa học: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public void updateCourseStatus(Long courseId, String newStatus, Long actorId, String actorEmail, String ipAddress) {
        if (courseId == null) {
            throw new ValidationException("ID khóa học không hợp lệ.");
        }
        if (newStatus == null || !Set.of("OPEN", "CLOSED", "ARCHIVED").contains(newStatus.toUpperCase())) {
            throw new ValidationException("Trạng thái khóa học không hợp lệ.");
        }

        String targetStatus = newStatus.toUpperCase();

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Course course = courseRepository.findById(em, courseId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy khóa học có ID: " + courseId));

            if ("OPEN".equals(targetStatus)) {
                if (course.getSubject() != null && !"ACTIVE".equalsIgnoreCase(course.getSubject().getStatus())) {
                    throw new ValidationException("Không thể mở tuyển sinh khi môn học '" + course.getSubject().getName() + "' đang ngừng hoạt động.");
                }
            }

            String oldStatus = course.getStatus();
            course.setStatus(targetStatus);
            course.setUpdatedAt(LocalDateTime.now());
            courseRepository.update(em, course);

            AuditLog log = new AuditLog(
                    actorId,
                    "CHANGE_COURSE_STATUS",
                    "Courses",
                    course.getId(),
                    "Status: " + oldStatus,
                    "Status: " + targetStatus,
                    ipAddress
            );
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw e;
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái khóa học: " + e.getMessage(), e);
            throw new ValidationException("Lỗi hệ thống khi cập nhật trạng thái khóa học: " + e.getMessage());
        } finally {
            em.close();
        }
    }
}
