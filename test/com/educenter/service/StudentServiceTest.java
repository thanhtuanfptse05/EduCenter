package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.GuardianRepository;
import com.educenter.repository.StudentRepository;
import com.educenter.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("StudentService — Student & Guardian Profile, Linkage & Verification (UC13, UC14, BR15)")
public class StudentServiceTest {

    private StudentService studentService;
    private MockStudentRepository mockStudentRepo;
    private MockGuardianRepository mockGuardianRepo;
    private MockUserRepository mockUserRepo;
    private MockAuditLogRepository mockAuditLogRepo;

    static class MockStudentRepository extends StudentRepository {
        Map<Long, Student> students = new HashMap<>();
        long nextId = 1L;

        @Override
        public Optional<Student> findById(EntityManager em, Long id) {
            return Optional.ofNullable(students.get(id));
        }

        @Override
        public boolean existsByUserId(EntityManager em, Long userId, Long excludeId) {
            for (Student s : students.values()) {
                if (excludeId != null && excludeId.equals(s.getId())) continue;
                if (s.getUser() != null && userId.equals(s.getUser().getId())) return true;
            }
            return false;
        }

        @Override
        public List<Student> searchStudents(EntityManager em, StudentFilterDTO filter) {
            return new ArrayList<>(students.values());
        }

        @Override
        public long countStudents(EntityManager em, StudentFilterDTO filter) {
            return students.size();
        }

        @Override
        public StudentStatsDTO getStudentStats(EntityManager em) {
            long total = students.size();
            long studying = students.values().stream().filter(s -> "STUDYING".equalsIgnoreCase(s.getStatus())).count();
            long reserved = students.values().stream().filter(s -> "RESERVED".equalsIgnoreCase(s.getStatus())).count();
            long graduated = students.values().stream().filter(s -> "GRADUATED".equalsIgnoreCase(s.getStatus())).count();
            long dropped = students.values().stream().filter(s -> "DROPPED".equalsIgnoreCase(s.getStatus())).count();
            return new StudentStatsDTO(total, studying, reserved, graduated, dropped);
        }

        @Override
        public long countGuardiansByStudentId(EntityManager em, Long studentId) {
            return 1L;
        }

        @Override
        public Student save(EntityManager em, Student student) {
            if (student.getId() == null) {
                student.setId(nextId++);
            }
            students.put(student.getId(), student);
            return student;
        }

        @Override
        public Student update(EntityManager em, Student student) {
            students.put(student.getId(), student);
            return student;
        }
    }

    static class MockGuardianRepository extends GuardianRepository {
        Map<Long, Guardian> guardians = new HashMap<>();
        Map<Long, StudentGuardian> links = new HashMap<>();
        long nextGuardianId = 1L;
        long nextLinkId = 1L;

        @Override
        public Optional<Guardian> findById(EntityManager em, Long id) {
            return Optional.ofNullable(guardians.get(id));
        }

        @Override
        public boolean existsByUserId(EntityManager em, Long userId, Long excludeId) {
            for (Guardian g : guardians.values()) {
                if (excludeId != null && excludeId.equals(g.getId())) continue;
                if (g.getUser() != null && userId.equals(g.getUser().getId())) return true;
            }
            return false;
        }

        @Override
        public List<Guardian> searchGuardians(EntityManager em, GuardianFilterDTO filter) {
            return new ArrayList<>(guardians.values());
        }

        @Override
        public long countGuardians(EntityManager em, GuardianFilterDTO filter) {
            return guardians.size();
        }

        @Override
        public Guardian save(EntityManager em, Guardian guardian) {
            if (guardian.getId() == null) {
                guardian.setId(nextGuardianId++);
            }
            guardians.put(guardian.getId(), guardian);
            return guardian;
        }

        @Override
        public Guardian update(EntityManager em, Guardian guardian) {
            guardians.put(guardian.getId(), guardian);
            return guardian;
        }

        @Override
        public List<StudentGuardian> findLinksByStudentId(EntityManager em, Long studentId) {
            List<StudentGuardian> res = new ArrayList<>();
            for (StudentGuardian sg : links.values()) {
                if (sg.getStudent() != null && studentId.equals(sg.getStudent().getId())) {
                    res.add(sg);
                }
            }
            return res;
        }

        @Override
        public List<StudentGuardian> findLinksByGuardianId(EntityManager em, Long guardianId) {
            List<StudentGuardian> res = new ArrayList<>();
            for (StudentGuardian sg : links.values()) {
                if (sg.getGuardian() != null && guardianId.equals(sg.getGuardian().getId())) {
                    res.add(sg);
                }
            }
            return res;
        }

        @Override
        public Optional<StudentGuardian> findLinkById(EntityManager em, Long linkId) {
            return Optional.ofNullable(links.get(linkId));
        }

        @Override
        public Optional<StudentGuardian> findLinkByStudentAndGuardian(EntityManager em, Long studentId, Long guardianId) {
            for (StudentGuardian sg : links.values()) {
                if (sg.getStudent() != null && sg.getGuardian() != null
                        && studentId.equals(sg.getStudent().getId())
                        && guardianId.equals(sg.getGuardian().getId())) {
                    return Optional.of(sg);
                }
            }
            return Optional.empty();
        }

        @Override
        public StudentGuardian saveLink(EntityManager em, StudentGuardian link) {
            if (link.getId() == null) {
                link.setId(nextLinkId++);
            }
            links.put(link.getId(), link);
            return link;
        }

        @Override
        public void deleteLink(EntityManager em, StudentGuardian link) {
            if (link != null) {
                links.remove(link.getId());
            }
        }

        @Override
        public void clearPrimaryForStudent(EntityManager em, Long studentId) {
            for (StudentGuardian sg : links.values()) {
                if (sg.getStudent() != null && studentId.equals(sg.getStudent().getId())) {
                    sg.setIsPrimary(false);
                }
            }
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
        mockStudentRepo = new MockStudentRepository();
        mockGuardianRepo = new MockGuardianRepository();
        mockUserRepo = new MockUserRepository();
        mockAuditLogRepo = new MockAuditLogRepository();

        studentService = new StudentServiceImpl(
                mockStudentRepo,
                mockGuardianRepo,
                mockUserRepo,
                mockAuditLogRepo,
                StudentServiceTest::createMockEntityManager
        );
    }

    @Test
    @DisplayName("Lưu học viên hợp lệ thành công & sinh mã định danh HVxxxx")
    void testSaveStudent_Success() {
        StudentFormDTO form = new StudentFormDTO();
        form.setFullName("Nguyễn Văn An");
        form.setGradeLevel(10);
        form.setGender("NAM");
        form.setDob(LocalDate.of(2008, 5, 20));
        form.setSchool("THPT Chu Văn An");
        form.setTargetGoal("Luyện thi THPTQG");
        form.setStatus("STUDYING");

        Student saved = studentService.saveStudent(form, 1L, "127.0.0.1");

        assertNotNull(saved);
        assertNotNull(saved.getId());
        assertEquals("HV0001", saved.getCode());
        assertEquals("Nguyễn Văn An", saved.getFullName());
        assertEquals(10, saved.getGradeLevel());
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("STUDENT_CREATE", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Lưu học viên với họ tên rỗng -> ném lỗi ValidationException")
    void testSaveStudent_InvalidFullName_ThrowsValidationException() {
        StudentFormDTO form = new StudentFormDTO();
        form.setFullName(" ");
        form.setGradeLevel(10);

        ValidationException ex = assertThrows(ValidationException.class, () ->
                studentService.saveStudent(form, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("từ 2 đến 150 ký tự"));
    }

    @Test
    @DisplayName("Lưu học viên với khối lớp ngoài 6-12 -> ném lỗi ValidationException")
    void testSaveStudent_InvalidGradeLevel_ThrowsValidationException() {
        StudentFormDTO form = new StudentFormDTO();
        form.setFullName("Lê Minh");
        form.setGradeLevel(5);

        ValidationException ex = assertThrows(ValidationException.class, () ->
                studentService.saveStudent(form, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("từ 6 đến 12"));
    }

    @Test
    @DisplayName("Lưu học viên với ngày sinh ở tương lai -> ném lỗi ValidationException")
    void testSaveStudent_FutureDob_ThrowsValidationException() {
        StudentFormDTO form = new StudentFormDTO();
        form.setFullName("Trần Đức");
        form.setGradeLevel(11);
        form.setDob(LocalDate.now().plusDays(5));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                studentService.saveStudent(form, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("không thể ở thời điểm tương lai"));
    }

    @Test
    @DisplayName("Cập nhật trạng thái học viên sang RESERVED thành công & ghi AuditLog")
    void testUpdateStudentStatus_Success() {
        Student s = new Student();
        s.setFullName("Vũ Quỳnh");
        s.setGradeLevel(12);
        s.setStatus("STUDYING");
        mockStudentRepo.save(null, s);

        studentService.updateStudentStatus(s.getId(), "RESERVED", 1L, "127.0.0.1");

        Student updated = mockStudentRepo.students.get(s.getId());
        assertEquals("RESERVED", updated.getStatus());
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("STUDENT_STATUS_CHANGE", mockAuditLogRepo.logs.get(0).getAction());
        assertEquals("STUDYING", mockAuditLogRepo.logs.get(0).getOldValues());
        assertEquals("RESERVED", mockAuditLogRepo.logs.get(0).getNewValues());
    }

    @Test
    @DisplayName("Liên kết tài khoản User vai trò STUDENT thành công")
    void testLinkStudentUser_Success() {
        Student s = new Student();
        s.setFullName("Hoàng Mai");
        s.setGradeLevel(9);
        mockStudentRepo.save(null, s);

        User studentUser = new User("student1@gmail.com", "hash", "Hoàng Mai", "0912345678");
        studentUser.setId(10L);
        Role r = new Role("STUDENT", "Học viên", "Học viên");
        studentUser.setRoles(Set.of(r));
        mockUserRepo.users.put(10L, studentUser);

        studentService.linkStudentUser(s.getId(), 10L, 1L, "127.0.0.1");

        Student updated = mockStudentRepo.students.get(s.getId());
        assertNotNull(updated.getUser());
        assertEquals(10L, updated.getUser().getId());
    }

    @Test
    @DisplayName("Liên kết tài khoản User không có vai trò STUDENT -> ném lỗi ValidationException")
    void testLinkStudentUser_InvalidRole_ThrowsValidationException() {
        Student s = new Student();
        s.setFullName("Hoàng Mai");
        s.setGradeLevel(9);
        mockStudentRepo.save(null, s);

        User parentUser = new User("parent@gmail.com", "hash", "Nguyễn Phụ Huynh", "0912345678");
        parentUser.setId(20L);
        Role r = new Role("PARENT", "Phụ huynh", "Phụ huynh");
        parentUser.setRoles(Set.of(r));
        mockUserRepo.users.put(20L, parentUser);

        ValidationException ex = assertThrows(ValidationException.class, () ->
                studentService.linkStudentUser(s.getId(), 20L, 1L, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("không có vai trò Học viên (STUDENT)"));
    }

    @Test
    @DisplayName("Lưu hồ sơ phụ huynh thành công với User PARENT")
    void testSaveGuardian_Success() {
        User parentUser = new User("parent1@gmail.com", "hash", "Trần Văn Nam", "0987654321");
        parentUser.setId(30L);
        Role r = new Role("PARENT", "Phụ huynh", "Phụ huynh");
        parentUser.setRoles(Set.of(r));
        mockUserRepo.users.put(30L, parentUser);

        GuardianFormDTO form = new GuardianFormDTO();
        form.setUserId(30L);
        form.setFullName("Trần Văn Nam");
        form.setPhone("0987654321");
        form.setEmail("parent1@gmail.com");
        form.setOccupation("Bác sĩ");
        form.setStatus("ACTIVE");

        Guardian saved = studentService.saveGuardian(form, 1L, "127.0.0.1");

        assertNotNull(saved);
        assertNotNull(saved.getId());
        assertEquals("PH0001", saved.getCode());
        assertEquals("Trần Văn Nam", saved.getFullName());
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("GUARDIAN_CREATE", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Thiết lập liên kết phụ huynh - học viên thành công (mặc định chưa xác thực)")
    void testLinkGuardianToStudent_Success() {
        Student s = new Student();
        s.setFullName("Trần Bé");
        s.setGradeLevel(7);
        mockStudentRepo.save(null, s);

        Guardian g = new Guardian();
        g.setFullName("Trần Lớn");
        g.setPhone("0988776655");
        mockGuardianRepo.save(null, g);

        studentService.linkGuardianToStudent(s.getId(), g.getId(), "Bố", true, 1L, "127.0.0.1");

        List<StudentGuardian> links = mockGuardianRepo.findLinksByStudentId(null, s.getId());
        assertEquals(1, links.size());
        StudentGuardian link = links.get(0);
        assertEquals("Bố", link.getRelationship());
        assertTrue(link.getIsPrimary());
        assertFalse(link.isVerified()); // Chờ duyệt xác thực theo BR15
    }

    @Test
    @DisplayName("Duyệt xác thực quan hệ giám hộ BR15 -> thành công & ghi nhận người duyệt")
    void testVerifyGuardianLink_BR15_Success() {
        Student s = new Student();
        mockStudentRepo.save(null, s);
        Guardian g = new Guardian();
        mockGuardianRepo.save(null, g);

        StudentGuardian link = new StudentGuardian();
        link.setStudent(s);
        link.setGuardian(g);
        link.setRelationship("Mẹ");
        mockGuardianRepo.saveLink(null, link);

        studentService.verifyGuardianLink(link.getId(), "Hồ sơ giấy tờ hợp lệ", 5L, "127.0.0.1");

        StudentGuardian verifiedLink = mockGuardianRepo.links.get(link.getId());
        assertTrue(verifiedLink.isVerified());
        assertNotNull(verifiedLink.getVerifiedAt());
        assertEquals(5L, verifiedLink.getVerifiedBy());

        // Kiểm tra AuditLog
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("GUARDIAN_VERIFY", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Thu hồi quyền giám hộ BR15 -> thành công, ngắt quyền truy cập & ghi lý do")
    void testRevokeGuardianLink_BR15_Success() {
        Student s = new Student();
        mockStudentRepo.save(null, s);
        Guardian g = new Guardian();
        mockGuardianRepo.save(null, g);

        StudentGuardian link = new StudentGuardian();
        link.setStudent(s);
        link.setGuardian(g);
        link.setRelationship("Mẹ");
        link.setVerifiedAt(java.time.LocalDateTime.now());
        link.setVerifiedBy(5L);
        mockGuardianRepo.saveLink(null, link);

        studentService.revokeGuardianLink(link.getId(), "Hết quyền giám hộ theo bản án", 5L, "127.0.0.1");

        StudentGuardian revokedLink = mockGuardianRepo.links.get(link.getId());
        assertFalse(revokedLink.isVerified());
        assertNull(revokedLink.getVerifiedAt());
        assertNull(revokedLink.getVerifiedBy());

        // Kiểm tra AuditLog
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("GUARDIAN_REVOKE", mockAuditLogRepo.logs.get(0).getAction());
        assertTrue(mockAuditLogRepo.logs.get(0).getNewValues().contains("Hết quyền giám hộ theo bản án"));
    }
}
