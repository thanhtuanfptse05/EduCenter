package com.educenter.service;

import com.educenter.dto.RegisterRequestDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.Role;
import com.educenter.entity.User;
import com.educenter.repository.PasswordResetRepository;
import com.educenter.repository.RoleRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.PasswordUtil;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("AuthService — Authentication & Registration Business Logic Tests")
public class AuthServiceTest {

    private AuthService authService;
    private MockUserRepository mockUserRepo;
    private MockRoleRepository mockRoleRepo;
    private MockStudentRepository mockStudentRepo;
    private MockGuardianRepository mockGuardianRepo;
    private MockAuditLogRepository mockAuditLogRepo;

    static class MockUserRepository extends UserRepository {
        User existingUser;
        boolean emailExists = false;

        @Override
        public Optional<User> findByEmail(EntityManager em, String email) {
            if (existingUser != null && existingUser.getEmail().equalsIgnoreCase(email)) {
                return Optional.of(existingUser);
            }
            return Optional.empty();
        }

        @Override
        public boolean existsByEmail(EntityManager em, String email) {
            return emailExists;
        }

        @Override
        public void save(EntityManager em, User user) {
            user.setId(99L);
            this.existingUser = user;
        }
    }

    static class MockRoleRepository extends RoleRepository {
        @Override
        public Optional<Role> findByCode(EntityManager em, String code) {
            Role r = new Role(code, "Role " + code, "Description");
            r.setId(1);
            return Optional.of(r);
        }
    }

    static class MockStudentRepository extends com.educenter.repository.StudentRepository {
        com.educenter.entity.Student existingStudent;

        @Override
        public Optional<com.educenter.entity.Student> findByEmail(EntityManager em, String email) {
            if (existingStudent != null && (
                    (existingStudent.getEmail() != null && existingStudent.getEmail().equalsIgnoreCase(email)) ||
                    (existingStudent.getUser() != null && existingStudent.getUser().getEmail().equalsIgnoreCase(email))
            )) {
                return Optional.of(existingStudent);
            }
            return Optional.empty();
        }

        @Override
        public long countGuardiansByStudentId(EntityManager em, Long studentId) {
            return 0L;
        }

        @Override
        public com.educenter.entity.Student update(EntityManager em, com.educenter.entity.Student student) {
            this.existingStudent = student;
            return student;
        }
    }

    static class MockGuardianRepository extends com.educenter.repository.GuardianRepository {
        com.educenter.entity.Guardian existingGuardian;
        com.educenter.entity.StudentGuardian savedLink;

        @Override
        public Optional<com.educenter.entity.Guardian> findByUserId(EntityManager em, Long userId) {
            return Optional.ofNullable(existingGuardian);
        }

        @Override
        public com.educenter.entity.Guardian save(EntityManager em, com.educenter.entity.Guardian guardian) {
            guardian.setId(101L);
            this.existingGuardian = guardian;
            return guardian;
        }

        @Override
        public Optional<com.educenter.entity.StudentGuardian> findLinkByStudentAndGuardian(EntityManager em, Long studentId, Long guardianId) {
            return Optional.ofNullable(savedLink);
        }

        @Override
        public com.educenter.entity.StudentGuardian saveLink(EntityManager em, com.educenter.entity.StudentGuardian link) {
            link.setId(201L);
            this.savedLink = link;
            return link;
        }
    }

    static class MockAuditLogRepository extends com.educenter.repository.AuditLogRepository {
        int logCount = 0;

        @Override
        public void save(EntityManager em, com.educenter.entity.AuditLog log) {
            logCount++;
        }
    }

    static EntityManager createMockEntityManager() {
        jakarta.persistence.EntityTransaction mockTx = (jakarta.persistence.EntityTransaction) java.lang.reflect.Proxy.newProxyInstance(
                jakarta.persistence.EntityTransaction.class.getClassLoader(),
                new Class<?>[]{jakarta.persistence.EntityTransaction.class},
                (proxy, method, args) -> {
                    if ("isActive".equals(method.getName())) return false;
                    return null;
                }
        );
        return (EntityManager) java.lang.reflect.Proxy.newProxyInstance(
                EntityManager.class.getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("getTransaction".equals(method.getName())) return mockTx;
                    if ("close".equals(method.getName())) return null;
                    return null;
                }
        );
    }

    @BeforeEach
    public void setUp() {
        mockUserRepo = new MockUserRepository();
        mockRoleRepo = new MockRoleRepository();
        mockStudentRepo = new MockStudentRepository();
        mockGuardianRepo = new MockGuardianRepository();
        mockAuditLogRepo = new MockAuditLogRepository();
        authService = new AuthServiceImpl(mockUserRepo, mockRoleRepo, new PasswordResetRepository(),
                mockStudentRepo, mockGuardianRepo, mockAuditLogRepo,
                AuthServiceTest::createMockEntityManager);
    }

    @Test
    @DisplayName("Login with valid credentials returns active principal")
    public void testLoginSuccess() {
        User user = new User("active@educenter.vn", PasswordUtil.hashPassword("123456"), "Nguyen Van An", "0912345678");
        user.setId(10L);
        user.setStatus(User.STATUS_ACTIVE);
        Role studentRole = new Role("STUDENT", "Hoc vien", "");
        user.addRole(studentRole);
        mockUserRepo.existingUser = user;

        UserPrincipalDTO principal = authService.login("ACTIVE@educenter.vn", "123456");
        assertNotNull(principal);
        assertEquals(10L, principal.getUserId());
        assertEquals("active@educenter.vn", principal.getEmail());
        assertTrue(principal.isStudent());
        assertEquals("STUDENT", principal.getPrimaryRole());
        assertEquals("/student/dashboard", principal.getDefaultDashboardUrl());
    }

    @Test
    @DisplayName("Login with incorrect password throws ValidationException")
    public void testLoginWrongPassword() {
        User user = new User("user@educenter.vn", PasswordUtil.hashPassword("CorrectPass"), "User", null);
        user.setStatus(User.STATUS_ACTIVE);
        mockUserRepo.existingUser = user;

        ValidationException ex = assertThrows(ValidationException.class, () ->
                authService.login("user@educenter.vn", "WrongPassword"));
        assertTrue(ex.getMessage().contains("không chính xác"));
    }

    @Test
    @DisplayName("Login with locked account throws account locked message")
    public void testLoginLockedAccount() {
        User user = new User("locked@educenter.vn", PasswordUtil.hashPassword("123456"), "Locked User", null);
        user.setStatus(User.STATUS_LOCKED);
        mockUserRepo.existingUser = user;

        ValidationException ex = assertThrows(ValidationException.class, () ->
                authService.login("locked@educenter.vn", "123456"));
        assertTrue(ex.getMessage().contains("tạm khóa"));
    }

    @Test
    @DisplayName("Register validation rejects duplicate email (BR01)")
    public void testRegisterDuplicateEmail() {
        mockUserRepo.emailExists = true;
        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Nguyen Van B", "duplicate@educenter.vn", "0987654321", "STUDENT", "123456", "123456");

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.register(dto));
        assertTrue(ex.getMessage().contains("đã được đăng ký"));
    }

    @Test
    @DisplayName("Register validation rejects mismatched password confirmation")
    public void testRegisterPasswordMismatch() {
        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Nguyen Van C", "c@educenter.vn", "0987654321", "STUDENT", "123456", "654321");

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.register(dto));
        assertTrue(ex.getMessage().contains("không khớp"));
    }

    @Test
    @DisplayName("Register rejects unauthorized role codes (e.g. ADMIN)")
    public void testRegisterUnauthorizedRole() {
        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Hacker", "hacker@evil.com", "0987654321", "ADMIN", "123456", "123456");

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.register(dto));
        assertTrue(ex.getMessage().contains("Chỉ cho phép đăng ký tài khoản Học viên"));
    }

    @Test
    @DisplayName("Register PARENT without student email throws ValidationException")
    public void testRegisterParentWithoutStudentEmail_ThrowsException() {
        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Phu Huynh A", "parent@gmail.com", "0912345678", "PARENT", null, "123456", "123456");

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.register(dto));
        assertTrue(ex.getMessage().contains("email của học sinh (con)"));
    }

    @Test
    @DisplayName("Register PARENT with non-existent student email throws ValidationException")
    public void testRegisterParentStudentNotFound_ThrowsException() {
        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Phu Huynh A", "parent@gmail.com", "0912345678", "PARENT", "nonexistent@student.vn", "123456", "123456");

        ValidationException ex = assertThrows(ValidationException.class, () -> authService.register(dto));
        assertTrue(ex.getMessage().contains("Không tìm thấy học sinh với email"));
    }

    @Test
    @DisplayName("Register PARENT with valid student email auto-links and verifies StudentGuardian (FR-001/D18)")
    public void testRegisterParentSuccess_AutoLinksGuardian() {
        com.educenter.entity.Student mockStudent = new com.educenter.entity.Student();
        mockStudent.setId(50L);
        mockStudent.setFullName("Nguyen Van Con");
        mockStudent.setEmail("con@student.vn");
        mockStudentRepo.existingStudent = mockStudent;

        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Phu Huynh B", "parentb@gmail.com", "0912345678", "PARENT", "con@student.vn", "123456", "123456");

        User registered = authService.register(dto);
        assertNotNull(registered);
        assertNotNull(mockGuardianRepo.existingGuardian);
        assertEquals("Phu Huynh B", mockGuardianRepo.existingGuardian.getFullName());
        assertEquals("parentb@gmail.com", mockGuardianRepo.existingGuardian.getEmail());

        assertNotNull(mockGuardianRepo.savedLink);
        assertEquals(mockStudent, mockGuardianRepo.savedLink.getStudent());
        assertEquals("Phụ huynh", mockGuardianRepo.savedLink.getRelationship());
        assertTrue(mockGuardianRepo.savedLink.getIsPrimary());
        assertTrue(mockGuardianRepo.savedLink.isVerified());
        assertNotNull(mockGuardianRepo.savedLink.getVerifiedAt());
        assertEquals(registered.getId(), mockGuardianRepo.savedLink.getVerifiedBy());
        assertTrue(mockAuditLogRepo.logCount > 0);
    }

    @Test
    @DisplayName("Register STUDENT auto-links User to existing Student profile if email matches")
    public void testRegisterStudentSuccess_AutoLinksExistingStudentProfile() {
        com.educenter.entity.Student mockStudent = new com.educenter.entity.Student();
        mockStudent.setId(60L);
        mockStudent.setFullName("Nguyen Thi Hoa");
        mockStudent.setEmail("hoa@student.vn");
        mockStudent.setUser(null);
        mockStudentRepo.existingStudent = mockStudent;

        RegisterRequestDTO dto = new RegisterRequestDTO(
                "Nguyen Thi Hoa", "hoa@student.vn", "0912345678", "STUDENT", null, "123456", "123456");

        User registered = authService.register(dto);
        assertNotNull(registered);
        assertNotNull(mockStudentRepo.existingStudent.getUser());
        assertEquals(registered, mockStudentRepo.existingStudent.getUser());
        assertTrue(mockAuditLogRepo.logCount > 0);
    }
}
