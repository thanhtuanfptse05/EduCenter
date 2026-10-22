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
        authService = new AuthServiceImpl(mockUserRepo, mockRoleRepo, new PasswordResetRepository(),
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
}
