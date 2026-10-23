package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Role;
import com.educenter.entity.Teacher;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.TeacherRepository;
import com.educenter.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("TeacherManagementService — Profiles, Status & Business Rules (UC12, BR05, BR18)")
public class TeacherManagementServiceTest {

    private TeacherManagementService teacherService;
    private MockTeacherRepository mockTeacherRepo;
    private MockUserRepository mockUserRepo;
    private MockAuditLogRepository mockAuditLogRepo;

    static class MockTeacherRepository extends TeacherRepository {
        Map<Long, Teacher> teachers = new HashMap<>();
        long nextId = 1L;
        long futureSessionsCount = 0L;

        @Override
        public Optional<Teacher> findById(EntityManager em, Long id) {
            return Optional.ofNullable(teachers.get(id));
        }

        @Override
        public boolean existsByUserId(EntityManager em, Long userId, Long excludeId) {
            for (Teacher t : teachers.values()) {
                if (excludeId != null && excludeId.equals(t.getId())) continue;
                if (t.getUser() != null && userId.equals(t.getUser().getId())) return true;
            }
            return false;
        }

        @Override
        public List<Teacher> findAdminTeachers(EntityManager em, TeacherFilterDTO filter) {
            return new ArrayList<>(teachers.values());
        }

        @Override
        public long countAdminTeachers(EntityManager em, TeacherFilterDTO filter) {
            return teachers.size();
        }

        @Override
        public TeacherAdminStatsDTO getAdminStats(EntityManager em) {
            long total = teachers.size();
            long active = teachers.values().stream().filter(t -> "ACTIVE".equalsIgnoreCase(t.getStatus())).count();
            long onLeave = teachers.values().stream().filter(t -> "ON_LEAVE".equalsIgnoreCase(t.getStatus())).count();
            long inactive = teachers.values().stream().filter(t -> "INACTIVE".equalsIgnoreCase(t.getStatus())).count();
            return new TeacherAdminStatsDTO(total, active, onLeave, inactive, 2L);
        }

        @Override
        public List<AvailableTeacherUserDTO> findAvailableTeacherUsers(EntityManager em) {
            return Collections.emptyList();
        }

        @Override
        public long countActiveClassesByTeacher(EntityManager em, Long teacherId) {
            return 2L;
        }

        @Override
        public long countTotalClassesByTeacher(EntityManager em, Long teacherId) {
            return 5L;
        }

        @Override
        public long countFutureScheduledSessions(EntityManager em, Long teacherId) {
            return futureSessionsCount;
        }

        @Override
        public Teacher save(EntityManager em, Teacher teacher) {
            if (teacher.getId() == null) {
                teacher.setId(nextId++);
            }
            teachers.put(teacher.getId(), teacher);
            return teacher;
        }

        @Override
        public Teacher update(EntityManager em, Teacher teacher) {
            teachers.put(teacher.getId(), teacher);
            return teacher;
        }
    }

    static class MockUserRepository extends UserRepository {
        Map<Long, User> users = new HashMap<>();

        @Override
        public Optional<User> findById(EntityManager em, Long id) {
            return Optional.ofNullable(users.get(id));
        }
    }

    static class MockAuditLogRepository extends AuditLogRepository {
        List<AuditLog> logs = new ArrayList<>();

        @Override
        public void save(EntityManager em, AuditLog log) {
            logs.add(log);
        }
    }

    static EntityManager createMockEntityManager() {
        EntityTransaction mockTx = (EntityTransaction) Proxy.newProxyInstance(
                EntityTransaction.class.getClassLoader(),
                new Class<?>[]{EntityTransaction.class},
                (proxy, method, args) -> {
                    if ("isActive".equals(method.getName())) return false;
                    return null;
                }
        );
        return (EntityManager) Proxy.newProxyInstance(
                EntityManager.class.getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("getTransaction".equals(method.getName())) return mockTx;
                    if ("isOpen".equals(method.getName())) return true;
                    if ("close".equals(method.getName())) return null;
                    return null;
                }
        );
    }

    @BeforeEach
    void setUp() {
        mockTeacherRepo = new MockTeacherRepository();
        mockUserRepo = new MockUserRepository();
        mockAuditLogRepo = new MockAuditLogRepository();

        // Seed teacher user
        User u1 = new User("teacher1@educenter.vn", "hash", "Nguyễn Văn Thầy", User.STATUS_ACTIVE);
        u1.setId(10L);
        u1.setPhone("0987654321");
        u1.getRoles().add(new Role("TEACHER", "Giáo viên", ""));
        mockUserRepo.users.put(10L, u1);

        // Seed regular user (not teacher)
        User u2 = new User("student1@educenter.vn", "hash", "Trần Học Sinh", User.STATUS_ACTIVE);
        u2.setId(20L);
        u2.getRoles().add(new Role("STUDENT", "Học viên", ""));
        mockUserRepo.users.put(20L, u2);

        teacherService = new TeacherManagementServiceImpl(
                mockTeacherRepo,
                mockUserRepo,
                mockAuditLogRepo,
                TeacherManagementServiceTest::createMockEntityManager
        );
    }

    @Test
    @DisplayName("Tạo mới giáo viên hợp lệ — lưu CSDL và ghi nhận AuditLog (BR18)")
    void saveTeacher_validCreate_shouldPersistAndAudit() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setUserId(10L);
        form.setFullName("Thầy Nguyễn Văn A");
        form.setSpecialization("Toán THPT, Luyện thi đại học");
        form.setDegree("Thạc sĩ Toán ứng dụng");
        form.setHourlyRate(new BigDecimal("350000"));
        form.setStatus("ACTIVE");

        Teacher created = teacherService.saveTeacher(form, 1L, "127.0.0.1");

        assertNotNull(created);
        assertNotNull(created.getId());
        assertEquals("Thầy Nguyễn Văn A", created.getFullName());
        assertEquals(new BigDecimal("350000"), created.getHourlyRate());
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("CREATE_TEACHER", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Tạo mới thiếu userId — báo lỗi ValidationException")
    void saveTeacher_missingUserId_shouldThrowValidationException() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setFullName("Thầy B");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                teacherService.saveTeacher(form, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("chọn tài khoản"));
    }

    @Test
    @DisplayName("Tạo mới với user không có quyền TEACHER — báo lỗi ValidationException")
    void saveTeacher_userNotTeacherRole_shouldThrowValidationException() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setUserId(20L);
        form.setFullName("Trần Học Sinh");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                teacherService.saveTeacher(form, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("vai trò TEACHER"));
    }

    @Test
    @DisplayName("Tạo mới với user đã liên kết hồ sơ giáo viên — báo lỗi trùng lặp")
    void saveTeacher_userAlreadyLinked_shouldThrowValidationException() {
        // Tạo hồ sơ đầu tiên
        TeacherFormDTO form1 = new TeacherFormDTO();
        form1.setUserId(10L);
        form1.setFullName("Thầy Một");
        teacherService.saveTeacher(form1, 1L, "127.0.0.1");

        // Tạo hồ sơ thứ hai cùng userId
        TeacherFormDTO form2 = new TeacherFormDTO();
        form2.setUserId(10L);
        form2.setFullName("Thầy Hai");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                teacherService.saveTeacher(form2, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("đã được liên kết"));
    }

    @Test
    @DisplayName("Thù lao âm — từ chối lưu")
    void saveTeacher_negativeHourlyRate_shouldThrowValidationException() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setUserId(10L);
        form.setFullName("Thầy Âm Tiền");
        form.setHourlyRate(new BigDecimal("-10000"));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                teacherService.saveTeacher(form, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("không được nhỏ hơn 0"));
    }

    @Test
    @DisplayName("Chuyển sang ON_LEAVE khi còn lịch dạy tương lai — CHẶN theo quy tắc BR05 / FR-005")
    void updateStatus_toOnLeave_withFutureSessions_shouldThrowValidationException_BR05() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setUserId(10L);
        form.setFullName("Thầy Đang Dạy");
        form.setStatus("ACTIVE");
        Teacher t = teacherService.saveTeacher(form, 1L, "127.0.0.1");

        // Giả lập còn 3 buổi học tương lai chưa hoàn thành
        mockTeacherRepo.futureSessionsCount = 3L;

        ValidationException ex = assertThrows(ValidationException.class, () ->
                teacherService.updateStatus(t.getId(), "ON_LEAVE", 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("buổi học tương lai"));
        assertTrue(ex.getMessage().contains("BR05"));
    }

    @Test
    @DisplayName("Chuyển sang ON_LEAVE khi không còn lịch dạy tương lai — thành công và ghi AuditLog")
    void updateStatus_toOnLeave_noFutureSessions_shouldSucceed() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setUserId(10L);
        form.setFullName("Thầy Chuẩn Bị Nghỉ Phép");
        form.setStatus("ACTIVE");
        Teacher t = teacherService.saveTeacher(form, 1L, "127.0.0.1");

        mockTeacherRepo.futureSessionsCount = 0L;

        assertDoesNotThrow(() ->
                teacherService.updateStatus(t.getId(), "ON_LEAVE", 1L, "127.0.0.1")
        );

        Teacher updated = mockTeacherRepo.findById(null, t.getId()).orElseThrow();
        assertEquals("ON_LEAVE", updated.getStatus());
        assertTrue(mockAuditLogRepo.logs.stream().anyMatch(l -> "UPDATE_TEACHER_STATUS".equals(l.getAction())));
    }

    @Test
    @DisplayName("Lấy dữ liệu chỉnh sửa form giáo viên thành công")
    void getTeacherForEdit_found_shouldReturnFormDTO() {
        TeacherFormDTO form = new TeacherFormDTO();
        form.setUserId(10L);
        form.setFullName("Thầy Dạy Toán");
        form.setDegree("Tiến sĩ");
        Teacher t = teacherService.saveTeacher(form, 1L, "127.0.0.1");

        TeacherFormDTO editDto = teacherService.getTeacherForEdit(t.getId());
        assertNotNull(editDto);
        assertEquals("Thầy Dạy Toán", editDto.getFullName());
        assertEquals("Tiến sĩ", editDto.getDegree());
    }

    @Test
    @DisplayName("Lấy dữ liệu giáo viên không tồn tại — báo lỗi")
    void getTeacherForEdit_notFound_shouldThrowValidationException() {
        assertThrows(ValidationException.class, () ->
                teacherService.getTeacherForEdit(999L)
        );
    }
}
