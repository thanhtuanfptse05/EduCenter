package com.educenter.service;

import com.educenter.dto.ProfileUpdateDTO;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Role;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.RoleRepository;
import com.educenter.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("UserService — User Management & Administrative Rules Tests")
public class UserServiceTest {

    private UserService userService;
    private MockUserRepository mockUserRepo;
    private MockRoleRepository mockRoleRepo;
    private MockAuditLogRepository mockAuditLogRepo;

    static class MockUserRepository extends UserRepository {
        Map<Long, User> users = new HashMap<>();
        long activeAdminCount = 1;

        @Override
        public Optional<User> findById(EntityManager em, Long id) {
            return Optional.ofNullable(users.get(id));
        }

        @Override
        public Optional<User> findByIdWithLock(EntityManager em, Long id) {
            return Optional.ofNullable(users.get(id));
        }

        @Override
        public User update(EntityManager em, User user) {
            users.put(user.getId(), user);
            return user;
        }

        @Override
        public long countActiveAdmins(EntityManager em) {
            return activeAdminCount;
        }
    }

    static class MockRoleRepository extends RoleRepository {
        Map<String, Role> roleMap = new HashMap<>();

        public MockRoleRepository() {
            roleMap.put("ADMIN", new Role("ADMIN", "Quản trị viên", ""));
            roleMap.put("STAFF", new Role("STAFF", "Nhân viên", ""));
            roleMap.put("TEACHER", new Role("TEACHER", "Giáo viên", ""));
            roleMap.put("STUDENT", new Role("STUDENT", "Học sinh", ""));
            roleMap.put("PARENT", new Role("PARENT", "Phụ huynh", ""));
        }

        @Override
        public Optional<Role> findByCode(EntityManager em, String code) {
            return Optional.ofNullable(roleMap.get(code));
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
                    if ("close".equals(method.getName())) return null;
                    return null;
                }
        );
    }

    @BeforeEach
    void setUp() {
        mockUserRepo = new MockUserRepository();
        mockRoleRepo = new MockRoleRepository();
        mockAuditLogRepo = new MockAuditLogRepository();

        // Admin 1
        User admin1 = new User("admin1@educenter.vn", "hashedpass", "Super Admin", User.STATUS_ACTIVE);
        admin1.setId(1L);
        admin1.getRoles().add(mockRoleRepo.roleMap.get("ADMIN"));
        mockUserRepo.users.put(1L, admin1);

        // Admin 2
        User admin2 = new User("admin2@educenter.vn", "hashedpass", "Second Admin", User.STATUS_ACTIVE);
        admin2.setId(2L);
        admin2.getRoles().add(mockRoleRepo.roleMap.get("ADMIN"));
        mockUserRepo.users.put(2L, admin2);

        // Student 10
        User student = new User("student@educenter.vn", "hashedpass", "Nguyen Van Hoc Sinh", User.STATUS_ACTIVE);
        student.setId(10L);
        student.getRoles().add(mockRoleRepo.roleMap.get("STUDENT"));
        mockUserRepo.users.put(10L, student);

        userService = new UserServiceImpl(mockUserRepo, mockRoleRepo, mockAuditLogRepo, UserServiceTest::createMockEntityManager);
    }

    @Test
    @DisplayName("Cập nhật hồ sơ thành công khi dữ liệu hợp lệ")
    void testUpdateProfile_Success() {
        ProfileUpdateDTO dto = new ProfileUpdateDTO("Nguyen Van Hoc Sinh Cap Nhat", "0912345678", "https://avatar.com/u10.png");
        User updated = userService.updateProfile(10L, dto);

        assertNotNull(updated);
        assertEquals("Nguyen Van Hoc Sinh Cap Nhat", updated.getFullName());
        assertEquals("0912345678", updated.getPhone());
        assertEquals("https://avatar.com/u10.png", updated.getAvatarUrl());
    }

    @Test
    @DisplayName("Cập nhật hồ sơ thất bại khi tên quá ngắn")
    void testUpdateProfile_InvalidName() {
        ProfileUpdateDTO dto = new ProfileUpdateDTO("A", "0912345678", "");
        assertThrows(ValidationException.class, () -> userService.updateProfile(10L, dto));
    }

    @Test
    @DisplayName("Cập nhật hồ sơ thất bại khi số điện thoại sai định dạng VN")
    void testUpdateProfile_InvalidPhone() {
        ProfileUpdateDTO dto = new ProfileUpdateDTO("Nguyen Van A", "123456", "");
        assertThrows(ValidationException.class, () -> userService.updateProfile(10L, dto));
    }

    @Test
    @DisplayName("Admin không thể tự khóa tài khoản của chính mình")
    void testToggleStatus_PreventSelfLock() {
        mockUserRepo.activeAdminCount = 2;
        ValidationException ex = assertThrows(ValidationException.class, () ->
                userService.toggleUserStatus(1L, 1L, User.STATUS_LOCKED, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("Không thể tự vô hiệu hóa"));
    }

    @Test
    @DisplayName("Không thể khóa tài khoản Admin tối cao duy nhất còn hoạt động")
    void testToggleStatus_PreventLastAdminLock() {
        mockUserRepo.activeAdminCount = 1; // Only 1 admin active
        ValidationException ex = assertThrows(ValidationException.class, () ->
                userService.toggleUserStatus(1L, 2L, User.STATUS_LOCKED, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("quản trị viên tối cao cuối cùng"));
    }

    @Test
    @DisplayName("Khóa tài khoản thành công khi có nhiều hơn 1 Admin và ghi Audit Log")
    void testToggleStatus_SuccessWithAuditLog() {
        mockUserRepo.activeAdminCount = 2;
        userService.toggleUserStatus(1L, 10L, User.STATUS_LOCKED, "127.0.0.1");

        User target = mockUserRepo.users.get(10L);
        assertEquals(User.STATUS_LOCKED, target.getStatus());
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("UPDATE_USER_STATUS", mockAuditLogRepo.logs.get(0).getAction());
        assertEquals(10L, mockAuditLogRepo.logs.get(0).getEntityId());
    }

    @Test
    @DisplayName("Người dùng không có quyền ADMIN không thể đổi trạng thái")
    void testToggleStatus_NonAdminUnauthorized() {
        assertThrows(AuthorizationException.class, () ->
                userService.toggleUserStatus(10L, 2L, User.STATUS_LOCKED, "127.0.0.1")
        );
    }

    @Test
    @DisplayName("Phân quyền thất bại khi danh sách vai trò rỗng")
    void testAssignRoles_EmptyRoles() {
        assertThrows(ValidationException.class, () ->
                userService.assignRoles(1L, 10L, Collections.emptySet(), "127.0.0.1")
        );
    }

    @Test
    @DisplayName("Phân quyền thất bại khi chứa vai trò không thuộc danh mục canonical")
    void testAssignRoles_InvalidRoleCode() {
        assertThrows(ValidationException.class, () ->
                userService.assignRoles(1L, 10L, Set.of("SUPER_ADMIN"), "127.0.0.1")
        );
    }

    @Test
    @DisplayName("Admin không thể tự gỡ vai trò ADMIN của chính mình")
    void testAssignRoles_PreventSelfAdminDemotion() {
        mockUserRepo.activeAdminCount = 2;
        ValidationException ex = assertThrows(ValidationException.class, () ->
                userService.assignRoles(1L, 1L, Set.of("STAFF"), "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("Không thể tự gỡ bỏ quyền ADMIN của chính mình"));
    }

    @Test
    @DisplayName("Không thể tước quyền ADMIN của Admin cuối cùng")
    void testAssignRoles_PreventLastAdminDemotion() {
        mockUserRepo.activeAdminCount = 1;
        ValidationException ex = assertThrows(ValidationException.class, () ->
                userService.assignRoles(1L, 2L, Set.of("TEACHER"), "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("quản trị viên tối cao cuối cùng"));
    }

    @Test
    @DisplayName("Phân vai trò hợp lệ thành công và ghi Audit Log")
    void testAssignRoles_Success() {
        mockUserRepo.activeAdminCount = 2;
        userService.assignRoles(1L, 10L, Set.of("STUDENT", "TEACHER"), "127.0.0.1");

        User target = mockUserRepo.users.get(10L);
        assertEquals(2, target.getRoles().size());
        assertTrue(target.hasRole("STUDENT"));
        assertTrue(target.hasRole("TEACHER"));

        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("CHANGE_ROLE", mockAuditLogRepo.logs.get(0).getAction());
    }
}
