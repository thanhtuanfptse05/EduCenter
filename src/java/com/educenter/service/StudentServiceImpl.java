package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.GuardianRepository;
import com.educenter.repository.StudentRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.JPAUtil;
import com.educenter.util.PasswordUtil;
import com.educenter.util.ValidationUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StudentServiceImpl implements StudentService {

    private static final Logger LOGGER = Logger.getLogger(StudentServiceImpl.class.getName());
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private static final Set<String> ALLOWED_STUDENT_STATUSES = Set.of("STUDYING", "RESERVED", "DROPPED", "GRADUATED");
    private static final Set<String> ALLOWED_GUARDIAN_STATUSES = Set.of("ACTIVE", "INACTIVE");
    private static final Set<String> ALLOWED_RELATIONSHIPS = Set.of("Bố", "Mẹ", "Ông", "Bà", "Người giám hộ", "Anh/Chị");

    private final StudentRepository studentRepository;
    private final GuardianRepository guardianRepository;
    private final UserRepository userRepository;
    private final AuditLogRepository auditLogRepository;
    private final Supplier<EntityManager> emSupplier;

    public StudentServiceImpl() {
        this(new StudentRepository(), new GuardianRepository(), new UserRepository(), new AuditLogRepository(), JPAUtil::getEntityManager);
    }

    public StudentServiceImpl(StudentRepository studentRepository,
                              GuardianRepository guardianRepository,
                              UserRepository userRepository,
                              AuditLogRepository auditLogRepository,
                              Supplier<EntityManager> emSupplier) {
        this.studentRepository = Objects.requireNonNull(studentRepository, "studentRepository must not be null");
        this.guardianRepository = Objects.requireNonNull(guardianRepository, "guardianRepository must not be null");
        this.userRepository = Objects.requireNonNull(userRepository, "userRepository must not be null");
        this.auditLogRepository = Objects.requireNonNull(auditLogRepository, "auditLogRepository must not be null");
        this.emSupplier = Objects.requireNonNull(emSupplier, "emSupplier must not be null");
    }

    @Override
    public StudentStatsDTO getStudentStats() {
        EntityManager em = emSupplier.get();
        try {
            return studentRepository.getStudentStats(em);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<StudentAdminViewDTO> getStudents(StudentFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            List<Student> students = studentRepository.searchStudents(em, filter);
            List<StudentAdminViewDTO> result = new ArrayList<>();
            for (Student s : students) {
                StudentAdminViewDTO dto = mapToStudentAdminViewDTO(s);
                long guardianCount = studentRepository.countGuardiansByStudentId(em, s.getId());
                dto.setGuardiansCount(guardianCount);
                result.add(dto);
            }
            return result;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public long countStudents(StudentFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            return studentRepository.countStudents(em, filter);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public StudentDetailDTO getStudentDetail(Long studentId) {
        if (studentId == null) {
            throw new ValidationException("ID học viên không hợp lệ.");
        }
        EntityManager em = emSupplier.get();
        try {
            Student student = studentRepository.findById(em, studentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy học viên với ID: " + studentId));

            StudentAdminViewDTO studentDTO = mapToStudentAdminViewDTO(student);
            long guardianCount = studentRepository.countGuardiansByStudentId(em, student.getId());
            studentDTO.setGuardiansCount(guardianCount);

            List<StudentGuardian> links = guardianRepository.findLinksByStudentId(em, studentId);
            List<StudentGuardianLinkDTO> guardianDTOs = new ArrayList<>();
            for (StudentGuardian link : links) {
                StudentGuardianLinkDTO ldto = mapToStudentGuardianLinkDTO(link);
                if (link.getVerifiedBy() != null) {
                    userRepository.findById(em, link.getVerifiedBy())
                            .ifPresent(u -> ldto.setVerifierName(u.getFullName()));
                }
                guardianDTOs.add(ldto);
            }

            // Enrolled classes query safely
            List<ClassAdminViewDTO> enrolledClasses = new ArrayList<>();
            try {
                @SuppressWarnings("unchecked")
                List<Object[]> rows = em.createNativeQuery(
                        "SELECT c.id, c.code, c.name, cr.name as course_name, e.status as enroll_status, e.enrolled_at " +
                        "FROM Enrollments e " +
                        "JOIN Classes c ON e.class_id = c.id " +
                        "JOIN Courses cr ON c.course_id = cr.id " +
                        "WHERE e.student_id = ?1 " +
                        "ORDER BY e.enrolled_at DESC"
                ).setParameter(1, studentId).getResultList();

                for (Object[] row : rows) {
                    ClassAdminViewDTO cDto = new ClassAdminViewDTO();
                    if (row[0] != null) cDto.setId(((Number) row[0]).longValue());
                    if (row[1] != null) cDto.setCode((String) row[1]);
                    if (row[2] != null) cDto.setName((String) row[2]);
                    if (row[3] != null) cDto.setCourseName((String) row[3]);
                    if (row[4] != null) cDto.setStatus((String) row[4]);
                    enrolledClasses.add(cDto);
                }
            } catch (Exception ex) {
                // Ignore if Enrollments table doesn't have expected schema yet
                LOGGER.log(Level.FINE, "Enrollments query fallback", ex);
            }

            return new StudentDetailDTO(studentDTO, guardianDTOs, enrolledClasses);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public StudentFormDTO getStudentForEdit(Long studentId) {
        if (studentId == null) {
            throw new ValidationException("ID học viên không hợp lệ.");
        }
        EntityManager em = emSupplier.get();
        try {
            Student student = studentRepository.findById(em, studentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy học viên với ID: " + studentId));

            StudentFormDTO form = new StudentFormDTO();
            form.setId(student.getId());
            form.setFullName(student.getFullName());
            form.setDob(student.getDob());
            form.setGender(student.getGender());
            form.setPhone(student.getPhone());
            form.setEmail(student.getEmail());
            form.setSchool(student.getSchool());
            form.setGradeLevel(student.getGradeLevel());
            form.setTargetGoal(student.getTargetGoal());
            form.setStatus(student.getStatus());
            if (student.getUser() != null) {
                form.setUserId(student.getUser().getId());
            }
            return form;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public Student saveStudent(StudentFormDTO form, Long actorId, String ipAddress) {
        validateStudentForm(form);

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            User boundUser = null;
            if (form.getUserId() != null) {
                boundUser = userRepository.findById(em, form.getUserId())
                        .orElseThrow(() -> new ValidationException("Tài khoản người dùng liên kết không tồn tại."));
                boolean isStudentRole = boundUser.getRoles().stream()
                        .anyMatch(r -> "STUDENT".equalsIgnoreCase(r.getCode()));
                if (!isStudentRole) {
                    throw new ValidationException("Tài khoản được chọn không có vai trò Học viên (STUDENT).");
                }
                if (studentRepository.existsByUserId(em, form.getUserId(), form.getId())) {
                    throw new ValidationException("Tài khoản này đã được liên kết với một học viên khác.");
                }
            }

            Student student;
            boolean isNew = (form.getId() == null);
            if (isNew) {
                student = new Student();
                student.setCreatedAt(LocalDateTime.now());
            } else {
                student = studentRepository.findById(em, form.getId())
                        .orElseThrow(() -> new ValidationException("Không tìm thấy học viên cần cập nhật."));
            }

            student.setFullName(form.getFullName().trim());
            student.setDob(form.getDob());
            student.setGender(form.getGender() != null ? form.getGender().trim() : null);
            student.setPhone(form.getPhone() != null && !form.getPhone().trim().isEmpty() ? form.getPhone().trim() : null);
            student.setEmail(form.getEmail() != null && !form.getEmail().trim().isEmpty() ? ValidationUtil.normalizeEmail(form.getEmail()) : null);
            student.setSchool(form.getSchool() != null ? form.getSchool().trim() : null);
            student.setGradeLevel(form.getGradeLevel());
            student.setTargetGoal(form.getTargetGoal() != null ? form.getTargetGoal().trim() : null);
            student.setStatus(form.getStatus() != null ? form.getStatus().trim() : "STUDYING");
            student.setUser(boundUser);
            student.setUpdatedAt(LocalDateTime.now());

            Student saved = studentRepository.save(em, student);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction(isNew ? "STUDENT_CREATE" : "STUDENT_UPDATE");
            log.setEntityType("Student");
            log.setEntityId(saved.getId());
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            log.setNewValues("Name: " + saved.getFullName() + ", Grade: " + saved.getGradeLevel() + ", Status: " + saved.getStatus());
            auditLogRepository.save(em, log);

            tx.commit();
            return saved;
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu thông tin học viên", ex);
            throw new ValidationException("Có lỗi hệ thống khi lưu thông tin học viên: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void updateStudentStatus(Long studentId, String newStatus, Long actorId, String ipAddress) {
        if (studentId == null) {
            throw new ValidationException("ID học viên không hợp lệ.");
        }
        if (newStatus == null || !ALLOWED_STUDENT_STATUSES.contains(newStatus.toUpperCase())) {
            throw new ValidationException("Trạng thái học viên không hợp lệ. Phải là một trong: " + ALLOWED_STUDENT_STATUSES);
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Student student = studentRepository.findById(em, studentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy học viên với ID: " + studentId));

            String oldStatus = student.getStatus();
            student.setStatus(newStatus.toUpperCase());
            student.setUpdatedAt(LocalDateTime.now());
            studentRepository.update(em, student);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("STUDENT_STATUS_CHANGE");
            log.setEntityType("Student");
            log.setEntityId(student.getId());
            log.setOldValues(oldStatus);
            log.setNewValues(newStatus.toUpperCase());
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái học viên", ex);
            throw new ValidationException("Không thể cập nhật trạng thái học viên: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void linkStudentUser(Long studentId, Long userId, Long actorId, String ipAddress) {
        if (studentId == null || userId == null) {
            throw new ValidationException("ID học viên và người dùng không được để trống.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Student student = studentRepository.findById(em, studentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy học viên với ID: " + studentId));

            User user = userRepository.findById(em, userId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy người dùng với ID: " + userId));

            boolean isStudentRole = user.getRoles().stream()
                    .anyMatch(r -> "STUDENT".equalsIgnoreCase(r.getCode()));
            if (!isStudentRole) {
                throw new ValidationException("Tài khoản người dùng này không có vai trò Học viên (STUDENT).");
            }

            if (studentRepository.existsByUserId(em, userId, studentId)) {
                throw new ValidationException("Tài khoản này đã được liên kết với một học viên khác.");
            }

            student.setUser(user);
            student.setUpdatedAt(LocalDateTime.now());
            studentRepository.update(em, student);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("STUDENT_USER_LINK");
            log.setEntityType("Student");
            log.setEntityId(student.getId());
            log.setNewValues("Linked to User ID: " + userId + " (" + user.getEmail() + ")");
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi liên kết tài khoản học viên", ex);
            throw new ValidationException("Không thể liên kết tài khoản: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void unlinkStudentUser(Long studentId, Long actorId, String ipAddress) {
        if (studentId == null) {
            throw new ValidationException("ID học viên không hợp lệ.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Student student = studentRepository.findById(em, studentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy học viên với ID: " + studentId));

            Long oldUserId = student.getUser() != null ? student.getUser().getId() : null;
            student.setUser(null);
            student.setUpdatedAt(LocalDateTime.now());
            studentRepository.update(em, student);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("STUDENT_USER_UNLINK");
            log.setEntityType("Student");
            log.setEntityId(student.getId());
            log.setOldValues("Unlinked from User ID: " + oldUserId);
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi hủy liên kết tài khoản học viên", ex);
            throw new ValidationException("Không thể hủy liên kết tài khoản: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<User> getAvailableStudentUsers(Long currentStudentId) {
        EntityManager em = emSupplier.get();
        try {
            List<User> studentUsers = em.createQuery(
                    "SELECT u FROM User u JOIN u.roles r WHERE r.code = 'STUDENT' AND u.status = 'ACTIVE' ORDER BY u.fullName ASC",
                    User.class
            ).getResultList();

            List<User> available = new ArrayList<>();
            for (User u : studentUsers) {
                if (!studentRepository.existsByUserId(em, u.getId(), currentStudentId)) {
                    available.add(u);
                }
            }
            return available;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    // --- Guardian Operations ---

    @Override
    public List<GuardianAdminViewDTO> getGuardians(GuardianFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            List<Guardian> guardians = guardianRepository.searchGuardians(em, filter);
            List<GuardianAdminViewDTO> result = new ArrayList<>();
            for (Guardian g : guardians) {
                GuardianAdminViewDTO dto = mapToGuardianAdminViewDTO(g);
                List<StudentGuardian> links = guardianRepository.findLinksByGuardianId(em, g.getId());
                dto.setChildrenCount(links.size());
                long verifiedCount = links.stream().filter(StudentGuardian::isVerified).count();
                dto.setVerifiedChildrenCount(verifiedCount);

                List<StudentGuardianLinkDTO> childDTOs = new ArrayList<>();
                for (StudentGuardian sg : links) {
                    childDTOs.add(mapToStudentGuardianLinkDTO(sg));
                }
                dto.setChildren(childDTOs);
                result.add(dto);
            }
            return result;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public long countGuardians(GuardianFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            return guardianRepository.countGuardians(em, filter);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public GuardianFormDTO getGuardianForEdit(Long guardianId) {
        if (guardianId == null) {
            throw new ValidationException("ID phụ huynh không hợp lệ.");
        }
        EntityManager em = emSupplier.get();
        try {
            Guardian guardian = guardianRepository.findById(em, guardianId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy phụ huynh với ID: " + guardianId));

            GuardianFormDTO form = new GuardianFormDTO();
            form.setId(guardian.getId());
            form.setFullName(guardian.getFullName());
            form.setPhone(guardian.getPhone());
            form.setEmail(guardian.getEmail());
            form.setOccupation(guardian.getOccupation());
            form.setAddress(guardian.getAddress());
            form.setStatus(guardian.getStatus());
            if (guardian.getUser() != null) {
                form.setUserId(guardian.getUser().getId());
            }
            return form;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public Guardian saveGuardian(GuardianFormDTO form, Long actorId, String ipAddress) {
        validateGuardianForm(form);

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            User boundUser;
            if (form.getUserId() != null && form.getUserId() > 0) {
                boundUser = userRepository.findById(em, form.getUserId())
                        .orElseThrow(() -> new ValidationException("Tài khoản người dùng liên kết không tồn tại."));

                boolean isParentRole = boundUser.getRoles().stream()
                        .anyMatch(r -> "PARENT".equalsIgnoreCase(r.getCode()));
                if (!isParentRole) {
                    throw new ValidationException("Tài khoản người dùng được chọn không có vai trò Phụ huynh (PARENT).");
                }

                if (guardianRepository.existsByUserId(em, form.getUserId(), form.getId())) {
                    throw new ValidationException("Tài khoản người dùng này đã được gắn với một hồ sơ phụ huynh khác.");
                }
            } else {
                // Auto-provision or link parent user by email/phone
                String cleanPhone = form.getPhone().trim();
                String targetEmail = (form.getEmail() != null && !form.getEmail().trim().isEmpty())
                        ? ValidationUtil.normalizeEmail(form.getEmail())
                        : ("parent." + cleanPhone + "@educenter.vn");

                Optional<User> existingUserOpt = userRepository.findByEmail(em, targetEmail);
                if (existingUserOpt.isPresent()) {
                    User existingUser = existingUserOpt.get();
                    if (guardianRepository.existsByUserId(em, existingUser.getId(), form.getId())) {
                        String altEmail = "parent." + cleanPhone + "." + (System.currentTimeMillis() % 100000) + "@educenter.vn";
                        boundUser = createParentUser(em, form.getFullName().trim(), altEmail, cleanPhone);
                    } else {
                        boolean hasParentRole = existingUser.getRoles().stream()
                                .anyMatch(r -> "PARENT".equalsIgnoreCase(r.getCode()));
                        if (!hasParentRole) {
                            Role parentRole = getOrCreateParentRole(em);
                            existingUser.getRoles().add(parentRole);
                            existingUser.setUpdatedAt(LocalDateTime.now());
                            userRepository.update(em, existingUser);
                        }
                        boundUser = existingUser;
                    }
                } else {
                    boundUser = createParentUser(em, form.getFullName().trim(), targetEmail, cleanPhone);
                }
            }

            Guardian guardian;
            boolean isNew = (form.getId() == null);
            if (isNew) {
                guardian = new Guardian();
                guardian.setCreatedAt(LocalDateTime.now());
            } else {
                guardian = guardianRepository.findById(em, form.getId())
                        .orElseThrow(() -> new ValidationException("Không tìm thấy phụ huynh cần cập nhật."));
            }

            guardian.setUser(boundUser);
            guardian.setFullName(form.getFullName().trim());
            guardian.setPhone(form.getPhone().trim());
            guardian.setEmail(form.getEmail() != null && !form.getEmail().trim().isEmpty() ? ValidationUtil.normalizeEmail(form.getEmail()) : null);
            guardian.setOccupation(form.getOccupation() != null ? form.getOccupation().trim() : null);
            guardian.setAddress(form.getAddress() != null ? form.getAddress().trim() : null);
            guardian.setStatus(form.getStatus() != null ? form.getStatus().trim() : "ACTIVE");
            guardian.setUpdatedAt(LocalDateTime.now());

            Guardian saved = guardianRepository.save(em, guardian);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction(isNew ? "GUARDIAN_CREATE" : "GUARDIAN_UPDATE");
            log.setEntityType("Guardian");
            log.setEntityId(saved.getId());
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            log.setNewValues("Name: " + saved.getFullName() + ", Phone: " + saved.getPhone() + ", Status: " + saved.getStatus());
            auditLogRepository.save(em, log);

            tx.commit();
            return saved;
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu hồ sơ phụ huynh", ex);
            throw new ValidationException("Có lỗi hệ thống khi lưu phụ huynh: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void updateGuardianStatus(Long guardianId, String newStatus, Long actorId, String ipAddress) {
        if (guardianId == null) {
            throw new ValidationException("ID phụ huynh không hợp lệ.");
        }
        if (newStatus == null || !ALLOWED_GUARDIAN_STATUSES.contains(newStatus.toUpperCase())) {
            throw new ValidationException("Trạng thái phụ huynh không hợp lệ. Phải là một trong: " + ALLOWED_GUARDIAN_STATUSES);
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Guardian guardian = guardianRepository.findById(em, guardianId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy phụ huynh với ID: " + guardianId));

            String oldStatus = guardian.getStatus();
            guardian.setStatus(newStatus.toUpperCase());
            guardian.setUpdatedAt(LocalDateTime.now());
            guardianRepository.update(em, guardian);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("GUARDIAN_STATUS_CHANGE");
            log.setEntityType("Guardian");
            log.setEntityId(guardian.getId());
            log.setOldValues(oldStatus);
            log.setNewValues(newStatus.toUpperCase());
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái phụ huynh", ex);
            throw new ValidationException("Không thể cập nhật trạng thái phụ huynh: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<User> getAvailableParentUsers(Long currentGuardianId) {
        EntityManager em = emSupplier.get();
        try {
            List<User> parentUsers = em.createQuery(
                    "SELECT u FROM User u JOIN u.roles r WHERE r.code = 'PARENT' AND u.status = 'ACTIVE' ORDER BY u.fullName ASC",
                    User.class
            ).getResultList();

            List<User> available = new ArrayList<>();
            for (User u : parentUsers) {
                if (!guardianRepository.existsByUserId(em, u.getId(), currentGuardianId)) {
                    available.add(u);
                }
            }
            return available;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    // --- Linkage & Verification (BR15) ---

    @Override
    public void linkGuardianToStudent(Long studentId, Long guardianId, String relationship, boolean isPrimary, Long actorId, String ipAddress) {
        if (studentId == null || guardianId == null) {
            throw new ValidationException("Học viên và phụ huynh không được để trống.");
        }
        if (relationship == null || relationship.trim().isEmpty()) {
            throw new ValidationException("Mối quan hệ không được để trống.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Student student = studentRepository.findById(em, studentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy học viên với ID: " + studentId));

            Guardian guardian = guardianRepository.findById(em, guardianId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy phụ huynh với ID: " + guardianId));

            Optional<StudentGuardian> existingLink = guardianRepository.findLinkByStudentAndGuardian(em, studentId, guardianId);
            if (existingLink.isPresent()) {
                throw new ValidationException("Mối liên kết giữa học viên và phụ huynh này đã tồn tại.");
            }

            if (isPrimary) {
                guardianRepository.clearPrimaryForStudent(em, studentId);
            }

            StudentGuardian link = new StudentGuardian();
            link.setStudent(student);
            link.setGuardian(guardian);
            link.setRelationship(relationship.trim());
            link.setIsPrimary(isPrimary);
            // Default unverified upon creation until verified
            link.setVerifiedAt(null);
            link.setVerifiedBy(null);

            guardianRepository.saveLink(em, link);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("STUDENT_GUARDIAN_LINK");
            log.setEntityType("StudentGuardian");
            log.setEntityId(link.getId());
            log.setNewValues("Student: " + student.getFullName() + ", Guardian: " + guardian.getFullName() + ", Rel: " + relationship);
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi thiết lập liên kết giám hộ", ex);
            throw new ValidationException("Không thể thiết lập liên kết giám hộ: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void unlinkGuardianFromStudent(Long linkId, Long actorId, String ipAddress) {
        if (linkId == null) {
            throw new ValidationException("ID liên kết không hợp lệ.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudentGuardian link = guardianRepository.findLinkById(em, linkId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy liên kết giám hộ với ID: " + linkId));

            String detail = "Student: " + link.getStudent().getFullName() + ", Guardian: " + link.getGuardian().getFullName();
            guardianRepository.deleteLink(em, link);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("STUDENT_GUARDIAN_UNLINK");
            log.setEntityType("StudentGuardian");
            log.setEntityId(linkId);
            log.setOldValues(detail);
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi hủy liên kết giám hộ", ex);
            throw new ValidationException("Không thể hủy liên kết giám hộ: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void verifyGuardianLink(Long linkId, String notes, Long actorId, String ipAddress) {
        if (linkId == null) {
            throw new ValidationException("ID liên kết không hợp lệ.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudentGuardian link = guardianRepository.findLinkById(em, linkId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy liên kết giám hộ với ID: " + linkId));

            if (link.isVerified()) {
                throw new ValidationException("Liên kết này đã được xác thực trước đó.");
            }

            link.setVerifiedAt(LocalDateTime.now());
            link.setVerifiedBy(actorId);
            guardianRepository.saveLink(em, link);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("GUARDIAN_VERIFY");
            log.setEntityType("StudentGuardian");
            log.setEntityId(link.getId());
            log.setOldValues("UNVERIFIED");
            log.setNewValues("VERIFIED: " + (notes != null ? notes.trim() : "Xác nhận hồ sơ giấy tờ hợp lệ"));
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi xác thực quyền giám hộ", ex);
            throw new ValidationException("Không thể xác thực quyền giám hộ: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void revokeGuardianLink(Long linkId, String reason, Long actorId, String ipAddress) {
        if (linkId == null) {
            throw new ValidationException("ID liên kết không hợp lệ.");
        }
        if (reason == null || reason.trim().isEmpty()) {
            throw new ValidationException("Bắt buộc phải nhập lý do thu hồi quyền giám hộ.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            StudentGuardian link = guardianRepository.findLinkById(em, linkId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy liên kết giám hộ với ID: " + linkId));

            if (!link.isVerified()) {
                throw new ValidationException("Liên kết này hiện chưa được xác thực, không thể thu hồi.");
            }

            link.setVerifiedAt(null);
            link.setVerifiedBy(null);
            guardianRepository.saveLink(em, link);

            AuditLog log = new AuditLog();
            log.setActorId(actorId);
            log.setAction("GUARDIAN_REVOKE");
            log.setEntityType("StudentGuardian");
            log.setEntityId(link.getId());
            log.setOldValues("VERIFIED");
            log.setNewValues("REVOKED: " + reason.trim());
            log.setIpAddress(ipAddress);
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            if (ex instanceof ValidationException) throw (ValidationException) ex;
            LOGGER.log(Level.SEVERE, "Lỗi khi thu hồi quyền giám hộ", ex);
            throw new ValidationException("Không thể thu hồi quyền giám hộ: " + ex.getMessage());
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<Guardian> searchAvailableGuardiansForStudent(Long studentId, String keyword) {
        if (studentId == null) return List.of();
        EntityManager em = emSupplier.get();
        try {
            StringBuilder jpql = new StringBuilder(
                    "SELECT g FROM Guardian g LEFT JOIN FETCH g.user u " +
                    "WHERE g.status = 'ACTIVE' " +
                    "AND NOT EXISTS (SELECT 1 FROM StudentGuardian sg WHERE sg.student.id = :studentId AND sg.guardian.id = g.id) "
            );
            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql.append("AND (LOWER(g.fullName) LIKE :kw OR LOWER(g.phone) LIKE :kw OR LOWER(g.email) LIKE :kw) ");
            }
            jpql.append("ORDER BY g.fullName ASC");

            var query = em.createQuery(jpql.toString(), Guardian.class);
            query.setParameter("studentId", studentId);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
            }
            query.setMaxResults(20);
            return query.getResultList();
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    // --- Helpers & Mappings ---

    private StudentAdminViewDTO mapToStudentAdminViewDTO(Student s) {
        StudentAdminViewDTO dto = new StudentAdminViewDTO();
        dto.setId(s.getId());
        dto.setFullName(s.getFullName());
        dto.setDob(s.getDob());
        dto.setGender(s.getGender());
        dto.setPhone(s.getPhone());
        dto.setEmail(s.getEmail());
        dto.setSchool(s.getSchool());
        dto.setGradeLevel(s.getGradeLevel());
        dto.setTargetGoal(s.getTargetGoal());
        dto.setStatus(s.getStatus());
        dto.setCreatedAt(s.getCreatedAt());

        if (s.getUser() != null) {
            dto.setUserId(s.getUser().getId());
            dto.setUserEmail(s.getUser().getEmail());
            dto.setUserStatus(s.getUser().getStatus());
        }
        return dto;
    }

    private GuardianAdminViewDTO mapToGuardianAdminViewDTO(Guardian g) {
        GuardianAdminViewDTO dto = new GuardianAdminViewDTO();
        dto.setId(g.getId());
        dto.setFullName(g.getFullName());
        dto.setPhone(g.getPhone());
        dto.setEmail(g.getEmail());
        dto.setOccupation(g.getOccupation());
        dto.setAddress(g.getAddress());
        dto.setStatus(g.getStatus());
        dto.setCreatedAt(g.getCreatedAt());

        if (g.getUser() != null) {
            dto.setUserId(g.getUser().getId());
            dto.setUserEmail(g.getUser().getEmail());
            dto.setUserStatus(g.getUser().getStatus());
        }
        return dto;
    }

    private StudentGuardianLinkDTO mapToStudentGuardianLinkDTO(StudentGuardian sg) {
        StudentGuardianLinkDTO dto = new StudentGuardianLinkDTO();
        dto.setId(sg.getId());
        if (sg.getStudent() != null) {
            dto.setStudentId(sg.getStudent().getId());
            dto.setStudentName(sg.getStudent().getFullName());
            dto.setStudentGradeLevel(sg.getStudent().getGradeLevel());
        }
        if (sg.getGuardian() != null) {
            dto.setGuardianId(sg.getGuardian().getId());
            dto.setGuardianName(sg.getGuardian().getFullName());
            dto.setGuardianPhone(sg.getGuardian().getPhone());
            dto.setGuardianEmail(sg.getGuardian().getEmail());
            dto.setGuardianOccupation(sg.getGuardian().getOccupation());
        }
        dto.setRelationship(sg.getRelationship());
        dto.setIsPrimary(sg.getIsPrimary());
        dto.setVerifiedAt(sg.getVerifiedAt());
        dto.setVerifiedBy(sg.getVerifiedBy());
        return dto;
    }

    private void validateStudentForm(StudentFormDTO form) {
        if (form == null) {
            throw new ValidationException("Dữ liệu học viên không được để trống.");
        }
        if (!ValidationUtil.isValidFullName(form.getFullName())) {
            throw new ValidationException("Họ và tên học viên phải từ 2 đến 150 ký tự.");
        }
        if (form.getGradeLevel() == null || form.getGradeLevel() < 6 || form.getGradeLevel() > 12) {
            throw new ValidationException("Khối lớp học viên phải nằm trong khoảng từ 6 đến 12.");
        }
        if (form.getDob() != null && form.getDob().isAfter(LocalDate.now())) {
            throw new ValidationException("Ngày sinh không thể ở thời điểm tương lai.");
        }
        if (form.getPhone() != null && !form.getPhone().trim().isEmpty()) {
            if (!ValidationUtil.isValidPhone(form.getPhone(), false)) {
                throw new ValidationException("Số điện thoại không đúng định dạng số Việt Nam.");
            }
        }
        if (form.getEmail() != null && !form.getEmail().trim().isEmpty()) {
            if (!ValidationUtil.isValidEmail(form.getEmail())) {
                throw new ValidationException("Email học viên không đúng định dạng.");
            }
        }
        if (form.getStatus() != null && !ALLOWED_STUDENT_STATUSES.contains(form.getStatus().toUpperCase())) {
            throw new ValidationException("Trạng thái học viên không hợp lệ: " + form.getStatus());
        }
    }

    private User createParentUser(EntityManager em, String fullName, String email, String phone) {
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPasswordHash(PasswordUtil.hashPassword(phone));
        user.setStatus("ACTIVE");
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        Role parentRole = getOrCreateParentRole(em);
        user.setRoles(new HashSet<>(Collections.singletonList(parentRole)));

        userRepository.save(em, user);
        return user;
    }

    private Role getOrCreateParentRole(EntityManager em) {
        try {
            return em.createQuery("SELECT r FROM Role r WHERE UPPER(r.code) = 'PARENT'", Role.class)
                    .getSingleResult();
        } catch (Exception e) {
            Role r = new Role("PARENT", "Phụ huynh", "Vai trò phụ huynh học sinh");
            em.persist(r);
            return r;
        }
    }

    private void validateGuardianForm(GuardianFormDTO form) {
        if (form == null) {
            throw new ValidationException("Dữ liệu phụ huynh không được để trống.");
        }
        if (!ValidationUtil.isValidFullName(form.getFullName())) {
            throw new ValidationException("Họ và tên phụ huynh phải từ 2 đến 150 ký tự.");
        }
        if (!ValidationUtil.isValidPhone(form.getPhone(), true)) {
            throw new ValidationException("Số điện thoại phụ huynh bắt buộc và phải đúng định dạng số Việt Nam.");
        }
        if (form.getEmail() != null && !form.getEmail().trim().isEmpty()) {
            if (!ValidationUtil.isValidEmail(form.getEmail())) {
                throw new ValidationException("Email phụ huynh không đúng định dạng.");
            }
        }
        if (form.getStatus() != null && !ALLOWED_GUARDIAN_STATUSES.contains(form.getStatus().toUpperCase())) {
            throw new ValidationException("Trạng thái phụ huynh không hợp lệ: " + form.getStatus());
        }
    }
}
