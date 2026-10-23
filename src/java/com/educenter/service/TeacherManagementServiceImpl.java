package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Role;
import com.educenter.entity.Teacher;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.TeacherRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TeacherManagementServiceImpl implements TeacherManagementService {

    private static final Logger LOGGER = Logger.getLogger(TeacherManagementServiceImpl.class.getName());

    private static final Set<String> ALLOWED_STATUSES = Set.of("ACTIVE", "ON_LEAVE", "INACTIVE");

    private final TeacherRepository teacherRepository;
    private final UserRepository userRepository;
    private final AuditLogRepository auditLogRepository;
    private final Supplier<EntityManager> emSupplier;

    public TeacherManagementServiceImpl() {
        this(new TeacherRepository(), new UserRepository(), new AuditLogRepository(), JPAUtil::getEntityManager);
    }

    public TeacherManagementServiceImpl(TeacherRepository teacherRepository,
                                        UserRepository userRepository,
                                        AuditLogRepository auditLogRepository,
                                        Supplier<EntityManager> emSupplier) {
        this.teacherRepository = Objects.requireNonNull(teacherRepository, "teacherRepository must not be null");
        this.userRepository = Objects.requireNonNull(userRepository, "userRepository must not be null");
        this.auditLogRepository = Objects.requireNonNull(auditLogRepository, "auditLogRepository must not be null");
        this.emSupplier = Objects.requireNonNull(emSupplier, "emSupplier must not be null");
    }

    @Override
    public TeacherAdminStatsDTO getAdminStats() {
        EntityManager em = emSupplier.get();
        try {
            return teacherRepository.getAdminStats(em);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<TeacherAdminViewDTO> getTeachers(TeacherFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            List<Teacher> teachers = teacherRepository.findAdminTeachers(em, filter);
            List<TeacherAdminViewDTO> dtos = new ArrayList<>();
            for (Teacher t : teachers) {
                TeacherAdminViewDTO dto = new TeacherAdminViewDTO();
                dto.setId(t.getId());
                if (t.getUser() != null) {
                    dto.setUserId(t.getUser().getId());
                    dto.setUserEmail(t.getUser().getEmail());
                    dto.setAvatarUrl(t.getUser().getAvatarUrl());
                }
                dto.setFullName(t.getFullName());
                dto.setPhone(t.getPhone());
                dto.setEmail(t.getEmail());
                dto.setSpecialization(t.getSpecialization());
                dto.setDegree(t.getDegree());
                dto.setHourlyRate(t.getHourlyRate());
                dto.setStatus(t.getStatus());
                dto.setCreatedAt(t.getCreatedAt());

                dto.setActiveClassesCount(teacherRepository.countActiveClassesByTeacher(em, t.getId()));
                dto.setTotalClassesCount(teacherRepository.countTotalClassesByTeacher(em, t.getId()));
                dtos.add(dto);
            }
            return dtos;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public long countTeachers(TeacherFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            return teacherRepository.countAdminTeachers(em, filter);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<AvailableTeacherUserDTO> getAvailableTeacherUsers() {
        EntityManager em = emSupplier.get();
        try {
            return teacherRepository.findAvailableTeacherUsers(em);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public TeacherFormDTO getTeacherForEdit(Long id) {
        if (id == null) {
            throw new ValidationException("Mã giáo viên không được rỗng");
        }
        EntityManager em = emSupplier.get();
        try {
            Teacher t = teacherRepository.findById(em, id)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy giáo viên với mã ID: " + id));

            TeacherFormDTO form = new TeacherFormDTO();
            form.setId(t.getId());
            if (t.getUser() != null) {
                form.setUserId(t.getUser().getId());
            }
            form.setFullName(t.getFullName());
            form.setPhone(t.getPhone());
            form.setEmail(t.getEmail());
            form.setSpecialization(t.getSpecialization());
            form.setDegree(t.getDegree());
            form.setHourlyRate(t.getHourlyRate());
            form.setBio(t.getBio());
            form.setStatus(t.getStatus());
            return form;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public Teacher saveTeacher(TeacherFormDTO form, Long actorId, String ipAddress) {
        validateForm(form);

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Teacher teacher;
            if (form.getId() == null) {
                // CREATE
                if (form.getUserId() == null) {
                    throw new ValidationException("Vui lòng chọn tài khoản người dùng liên kết");
                }
                if (teacherRepository.existsByUserId(em, form.getUserId(), null)) {
                    throw new ValidationException("Tài khoản người dùng này đã được liên kết với một hồ sơ giáo viên khác");
                }
                User user = userRepository.findById(em, form.getUserId())
                        .orElseThrow(() -> new ValidationException("Tài khoản người dùng liên kết không tồn tại"));

                boolean hasTeacherRole = user.getRoles().stream()
                        .anyMatch(r -> "TEACHER".equalsIgnoreCase(r.getCode()));
                if (!hasTeacherRole || !"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                    throw new ValidationException("Tài khoản liên kết phải có vai trò TEACHER và trạng thái ACTIVE");
                }

                teacher = new Teacher();
                teacher.setUser(user);
                teacher.setFullName(form.getFullName().trim());
                teacher.setPhone(isNotBlank(form.getPhone()) ? form.getPhone().trim() : user.getPhone());
                teacher.setEmail(isNotBlank(form.getEmail()) ? form.getEmail().trim() : user.getEmail());
                teacher.setSpecialization(form.getSpecialization() != null ? form.getSpecialization().trim() : null);
                teacher.setDegree(form.getDegree() != null ? form.getDegree().trim() : null);
                teacher.setHourlyRate(form.getHourlyRate() != null ? form.getHourlyRate() : BigDecimal.ZERO);
                teacher.setBio(form.getBio() != null ? form.getBio().trim() : null);
                teacher.setStatus(form.getStatus() != null ? form.getStatus().toUpperCase() : "ACTIVE");
                teacher.setCreatedAt(LocalDateTime.now());
                teacher.setUpdatedAt(LocalDateTime.now());

                teacher = teacherRepository.save(em, teacher);

                // AuditLog
                AuditLog log = new AuditLog(actorId, "CREATE_TEACHER", "Teacher", teacher.getId(),
                        null, buildTeacherSummaryJson(teacher), ipAddress);
                auditLogRepository.save(em, log);

            } else {
                // UPDATE
                teacher = teacherRepository.findById(em, form.getId())
                        .orElseThrow(() -> new ValidationException("Không tìm thấy giáo viên với ID: " + form.getId()));

                String oldStatus = teacher.getStatus();
                String newStatus = form.getStatus() != null ? form.getStatus().toUpperCase() : oldStatus;

                // BR05 / FR-005: Chặn chuyển sang ON_LEAVE hoặc INACTIVE nếu còn lịch dạy tương lai
                if (!"ACTIVE".equalsIgnoreCase(newStatus) && "ACTIVE".equalsIgnoreCase(oldStatus)) {
                    long futureSessions = teacherRepository.countFutureScheduledSessions(em, teacher.getId());
                    if (futureSessions > 0) {
                        throw new ValidationException("Không thể chuyển giáo viên sang trạng thái " + newStatus +
                                " vì còn " + futureSessions + " buổi học tương lai chưa hoàn thành hoặc chưa bàn giao (BR05).");
                    }
                }

                String oldJson = buildTeacherSummaryJson(teacher);

                teacher.setFullName(form.getFullName().trim());
                if (isNotBlank(form.getPhone())) {
                    teacher.setPhone(form.getPhone().trim());
                }
                if (isNotBlank(form.getEmail())) {
                    teacher.setEmail(form.getEmail().trim());
                }
                teacher.setSpecialization(form.getSpecialization() != null ? form.getSpecialization().trim() : null);
                teacher.setDegree(form.getDegree() != null ? form.getDegree().trim() : null);
                if (form.getHourlyRate() != null) {
                    teacher.setHourlyRate(form.getHourlyRate());
                }
                teacher.setBio(form.getBio() != null ? form.getBio().trim() : null);
                teacher.setStatus(newStatus);
                teacher.setUpdatedAt(LocalDateTime.now());

                teacher = teacherRepository.update(em, teacher);

                // AuditLog
                AuditLog log = new AuditLog(actorId, "UPDATE_TEACHER", "Teacher", teacher.getId(),
                        oldJson, buildTeacherSummaryJson(teacher), ipAddress);
                auditLogRepository.save(em, log);
            }

            tx.commit();
            return teacher;
        } catch (ValidationException e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu hồ sơ giáo viên", e);
            throw new RuntimeException("Lỗi hệ thống khi lưu hồ sơ giáo viên: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void updateStatus(Long teacherId, String newStatus, Long actorId, String ipAddress) {
        if (teacherId == null) {
            throw new ValidationException("Mã giáo viên không được rỗng");
        }
        if (newStatus == null || !ALLOWED_STATUSES.contains(newStatus.toUpperCase())) {
            throw new ValidationException("Trạng thái không hợp lệ: " + newStatus);
        }
        String targetStatus = newStatus.toUpperCase();

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Teacher teacher = teacherRepository.findById(em, teacherId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy giáo viên với ID: " + teacherId));

            String oldStatus = teacher.getStatus();
            if (targetStatus.equalsIgnoreCase(oldStatus)) {
                tx.rollback();
                return;
            }

            // BR05 / FR-005 check
            if (!"ACTIVE".equalsIgnoreCase(targetStatus) && "ACTIVE".equalsIgnoreCase(oldStatus)) {
                long futureSessions = teacherRepository.countFutureScheduledSessions(em, teacherId);
                if (futureSessions > 0) {
                    throw new ValidationException("Không thể chuyển giáo viên sang trạng thái " + targetStatus +
                            " vì còn " + futureSessions + " buổi học tương lai chưa hoàn thành hoặc chưa bàn giao (BR05).");
                }
            }

            teacher.setStatus(targetStatus);
            teacher.setUpdatedAt(LocalDateTime.now());
            teacherRepository.update(em, teacher);

            // AuditLog
            AuditLog log = new AuditLog(actorId, "UPDATE_TEACHER_STATUS", "Teacher", teacherId,
                    "{\"status\":\"" + oldStatus + "\"}",
                    "{\"status\":\"" + targetStatus + "\"}",
                    ipAddress);
            auditLogRepository.save(em, log);

            tx.commit();
        } catch (ValidationException e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái giáo viên", e);
            throw new RuntimeException("Lỗi hệ thống khi cập nhật trạng thái giáo viên: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    private void validateForm(TeacherFormDTO form) {
        if (form == null) {
            throw new ValidationException("Dữ liệu biểu mẫu không được để trống");
        }
        if (form.getFullName() == null || form.getFullName().trim().length() < 2 || form.getFullName().trim().length() > 150) {
            throw new ValidationException("Họ và tên giáo viên phải từ 2 đến 150 ký tự");
        }
        if (form.getHourlyRate() != null && form.getHourlyRate().compareTo(BigDecimal.ZERO) < 0) {
            throw new ValidationException("Đơn giá thù lao không được nhỏ hơn 0");
        }
        if (form.getStatus() != null && !ALLOWED_STATUSES.contains(form.getStatus().toUpperCase())) {
            throw new ValidationException("Trạng thái hồ sơ không hợp lệ: " + form.getStatus());
        }
    }

    private boolean isNotBlank(String str) {
        return str != null && !str.trim().isEmpty();
    }

    private String buildTeacherSummaryJson(Teacher t) {
        return String.format(
                "{\"fullName\":\"%s\",\"phone\":\"%s\",\"email\":\"%s\",\"specialization\":\"%s\",\"degree\":\"%s\",\"hourlyRate\":%s,\"status\":\"%s\"}",
                escapeJson(t.getFullName()),
                escapeJson(t.getPhone() != null ? t.getPhone() : ""),
                escapeJson(t.getEmail() != null ? t.getEmail() : ""),
                escapeJson(t.getSpecialization() != null ? t.getSpecialization() : ""),
                escapeJson(t.getDegree() != null ? t.getDegree() : ""),
                t.getHourlyRate() != null ? t.getHourlyRate().toString() : "0",
                escapeJson(t.getStatus() != null ? t.getStatus() : "")
        );
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\"", "\\\"");
    }
}
