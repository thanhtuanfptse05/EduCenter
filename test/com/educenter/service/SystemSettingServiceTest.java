package com.educenter.service;

import com.educenter.dto.SystemSettingsGroupedDTO;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Role;
import com.educenter.entity.SystemSetting;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.SystemSettingRepository;
import com.educenter.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("SystemSettingService — Configuration & Audit Trail Tests (M12, BR18)")
public class SystemSettingServiceTest {

    private SystemSettingService settingService;
    private MockSettingRepository mockSettingRepo;
    private MockAuditLogRepository mockAuditLogRepo;
    private MockUserRepository mockUserRepo;

    static class MockSettingRepository extends SystemSettingRepository {
        Map<String, SystemSetting> storage = new HashMap<>();

        @Override
        public Optional<SystemSetting> findByKey(EntityManager em, String key) {
            return Optional.ofNullable(storage.get(key));
        }

        @Override
        public List<SystemSetting> findAll(EntityManager em) {
            return new ArrayList<>(storage.values());
        }

        @Override
        public void save(EntityManager em, SystemSetting setting) {
            storage.put(setting.getSettingKey(), setting);
        }

        @Override
        public SystemSetting update(EntityManager em, SystemSetting setting) {
            storage.put(setting.getSettingKey(), setting);
            return setting;
        }
    }

    static class MockAuditLogRepository extends AuditLogRepository {
        List<AuditLog> logs = new ArrayList<>();

        @Override
        public void save(EntityManager em, AuditLog log) {
            logs.add(log);
        }

        @Override
        public List<AuditLog> findRecentLogs(EntityManager em, int limit) {
            return new ArrayList<>(logs);
        }
    }

    static class MockUserRepository extends UserRepository {
        Map<Long, User> users = new HashMap<>();

        @Override
        public Optional<User> findById(EntityManager em, Long id) {
            return Optional.ofNullable(users.get(id));
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
        mockSettingRepo = new MockSettingRepository();
        mockAuditLogRepo = new MockAuditLogRepository();
        mockUserRepo = new MockUserRepository();

        // Seed Admin user
        User admin = new User("admin@educenter.vn", "hash", "Super Admin", User.STATUS_ACTIVE);
        admin.setId(1L);
        Role adminRole = new Role("ADMIN", "Quản trị viên", "");
        admin.getRoles().add(adminRole);
        mockUserRepo.users.put(1L, admin);

        // Seed Staff user (Not admin)
        User staff = new User("staff@educenter.vn", "hash", "Staff Member", User.STATUS_ACTIVE);
        staff.setId(2L);
        Role staffRole = new Role("STAFF", "Nhân viên", "");
        staff.getRoles().add(staffRole);
        mockUserRepo.users.put(2L, staff);

        // Seed default settings
        mockSettingRepo.save(null, new SystemSetting(SystemSettingServiceImpl.KEY_CENTER_NAME,
                "EduCenter Hà Nội", "Tên trung tâm", 1L));
        mockSettingRepo.save(null, new SystemSetting(SystemSettingServiceImpl.KEY_CENTER_HOTLINE,
                "0988.123.456", "Hotline", 1L));
        mockSettingRepo.save(null, new SystemSetting(SystemSettingServiceImpl.KEY_ADMISSIONS_OPEN,
                "true", "Cờ tuyển sinh", 1L));

        settingService = new SystemSettingServiceImpl(
                mockSettingRepo,
                mockAuditLogRepo,
                mockUserRepo,
                SystemSettingServiceTest::createMockEntityManager
        );
    }

    @Test
    @DisplayName("Cập nhật hợp lệ: Lưu dữ liệu và ghi AuditLog thành công")
    void testUpdateSettings_ValidInputs_PersistsAndAudits() {
        Map<String, String> updates = new HashMap<>();
        updates.put(SystemSettingServiceImpl.KEY_CENTER_NAME, "EduCenter Academy - Cơ sở Cầu Giấy");
        updates.put(SystemSettingServiceImpl.KEY_MAX_CAPACITY, "20");
        updates.put(SystemSettingServiceImpl.KEY_TUITION_DUE_DAYS, "10");

        settingService.updateSettings(1L, updates, "127.0.0.1");

        assertEquals("EduCenter Academy - Cơ sở Cầu Giấy",
                settingService.getSettingValue(SystemSettingServiceImpl.KEY_CENTER_NAME, ""));
        assertEquals("20",
                settingService.getSettingValue(SystemSettingServiceImpl.KEY_MAX_CAPACITY, ""));
        assertEquals("10",
                settingService.getSettingValue(SystemSettingServiceImpl.KEY_TUITION_DUE_DAYS, ""));

        // Verify AuditLog was recorded
        assertEquals(1, mockAuditLogRepo.logs.size());
        AuditLog log = mockAuditLogRepo.logs.get(0);
        assertEquals(1L, log.getActorId());
        assertEquals("UPDATE_SETTINGS", log.getAction());
        assertEquals("SystemSetting", log.getEntityType());
        assertTrue(log.getNewValues().contains("EduCenter Academy - Cơ sở Cầu Giấy"));
    }

    @Test
    @DisplayName("Từ chối key lạ ngoài allowlist (Bảo vệ an ninh hệ thống FR-001, FR-005)")
    void testUpdateSettings_DisallowedKey_ThrowsValidationException() {
        Map<String, String> updates = new HashMap<>();
        updates.put("DATABASE_PASSWORD", "secret123");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                settingService.updateSettings(1L, updates, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("không nằm trong danh mục cho phép"));
        assertTrue(mockAuditLogRepo.logs.isEmpty());
    }

    @Test
    @DisplayName("Từ chối số điện thoại hotline sai định dạng Việt Nam")
    void testUpdateSettings_InvalidHotline_ThrowsValidationException() {
        Map<String, String> updates = new HashMap<>();
        updates.put(SystemSettingServiceImpl.KEY_CENTER_HOTLINE, "12345");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                settingService.updateSettings(1L, updates, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("số điện thoại Việt Nam"));
    }

    @Test
    @DisplayName("Từ chối sĩ số lớp ngoài phạm vi (1 đến 100)")
    void testUpdateSettings_InvalidCapacity_ThrowsValidationException() {
        Map<String, String> updates = new HashMap<>();
        updates.put(SystemSettingServiceImpl.KEY_MAX_CAPACITY, "150");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                settingService.updateSettings(1L, updates, "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("từ 1 đến 100"));
    }

    @Test
    @DisplayName("Từ chối tài khoản không phải ADMIN sửa cấu hình")
    void testUpdateSettings_NonAdminActor_ThrowsAuthorizationException() {
        Map<String, String> updates = new HashMap<>();
        updates.put(SystemSettingServiceImpl.KEY_CENTER_NAME, "New Name");

        assertThrows(AuthorizationException.class, () ->
                settingService.updateSettings(2L, updates, "127.0.0.1") // User 2 is STAFF
        );
    }

    @Test
    @DisplayName("Cờ đóng/mở tuyển sinh: Bật/tắt thành công và phản ánh tức thì (FR-010)")
    void testSetAdmissionsOpen_TogglesCorrectlyAndAudits() {
        assertTrue(settingService.isAdmissionsOpen());

        // Toggle to false
        settingService.setAdmissionsOpen(1L, false, "192.168.1.1");
        assertFalse(settingService.isAdmissionsOpen());
        assertEquals("false", settingService.getSettingValue(SystemSettingServiceImpl.KEY_ADMISSIONS_OPEN, ""));

        // Toggle back to true
        settingService.setAdmissionsOpen(1L, true, "192.168.1.1");
        assertTrue(settingService.isAdmissionsOpen());
        assertEquals(2, mockAuditLogRepo.logs.size());
    }

    @Test
    @DisplayName("Lấy danh mục cấu hình theo nhóm (Grouped Settings) chuẩn bị cho giao diện")
    void testGetGroupedSettings_ReturnsCategorizedItems() {
        SystemSettingsGroupedDTO grouped = settingService.getGroupedSettings();
        assertNotNull(grouped);
        assertFalse(grouped.getCenterInfo().isEmpty());
        assertFalse(grouped.getAcademicRules().isEmpty());
        assertFalse(grouped.getFinanceRules().isEmpty());
        assertTrue(grouped.isAdmissionsOpen());
    }
}
