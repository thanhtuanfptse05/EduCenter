package com.educenter.service;

import com.educenter.dto.SettingItemViewDTO;
import com.educenter.dto.SystemSettingsGroupedDTO;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Role;
import com.educenter.entity.SystemSetting;
import com.educenter.entity.User;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.SystemSettingRepository;
import com.educenter.repository.UserRepository;
import com.educenter.util.JPAUtil;
import com.educenter.util.ValidationUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.time.LocalDateTime;
import java.util.*;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Implementation of SystemSettingService enforcing allowlists, type validations,
 * role authorization, and atomic audit trails (BR18, M12).
 */
public class SystemSettingServiceImpl implements SystemSettingService {

    private static final Logger LOGGER = Logger.getLogger(SystemSettingServiceImpl.class.getName());

    public static final String KEY_CENTER_NAME = "CENTER_NAME";
    public static final String KEY_CENTER_HOTLINE = "CENTER_HOTLINE";
    public static final String KEY_CENTER_EMAIL = "CENTER_EMAIL";
    public static final String KEY_CENTER_ADDRESS = "CENTER_ADDRESS";
    public static final String KEY_MAX_CAPACITY = "MAX_CLASS_CAPACITY_DEFAULT";
    public static final String KEY_TUITION_DUE_DAYS = "TUITION_DUE_DAYS";
    public static final String KEY_ADMISSIONS_OPEN = "SYSTEM_ADMISSIONS_OPEN";

    public static final Set<String> ALLOWLIST_KEYS = Set.of(
            KEY_CENTER_NAME,
            KEY_CENTER_HOTLINE,
            KEY_CENTER_EMAIL,
            KEY_CENTER_ADDRESS,
            KEY_MAX_CAPACITY,
            KEY_TUITION_DUE_DAYS,
            KEY_ADMISSIONS_OPEN
    );

    private final SystemSettingRepository settingRepository;
    private final AuditLogRepository auditLogRepository;
    private final UserRepository userRepository;
    private final Supplier<EntityManager> entityManagerSupplier;

    public SystemSettingServiceImpl() {
        this(new SystemSettingRepository(), new AuditLogRepository(), new UserRepository(), JPAUtil::getEntityManager);
    }

    public SystemSettingServiceImpl(SystemSettingRepository settingRepository,
                                    AuditLogRepository auditLogRepository,
                                    UserRepository userRepository,
                                    Supplier<EntityManager> entityManagerSupplier) {
        this.settingRepository = settingRepository;
        this.auditLogRepository = auditLogRepository;
        this.userRepository = userRepository;
        this.entityManagerSupplier = (entityManagerSupplier != null) ? entityManagerSupplier : JPAUtil::getEntityManager;
    }

    @Override
    public SystemSettingsGroupedDTO getGroupedSettings() {
        EntityManager em = entityManagerSupplier.get();
        try {
            List<SystemSetting> allSettings = settingRepository.findAll(em);
            Map<String, SystemSetting> map = new HashMap<>();
            for (SystemSetting s : allSettings) {
                map.put(s.getSettingKey(), s);
            }

            SystemSettingsGroupedDTO grouped = new SystemSettingsGroupedDTO();

            // 1. Center info
            grouped.getCenterInfo().add(createItem(KEY_CENTER_NAME, map, "Tên trung tâm",
                    "Tên thương hiệu chính thức xuất hiện trên văn bản và website", "CENTER", "text", null,
                    "EduCenter - Trung Tâm Bồi Dưỡng Văn Hóa & Luyện Thi"));
            grouped.getCenterInfo().add(createItem(KEY_CENTER_HOTLINE, map, "Hotline tư vấn",
                    "Số điện thoại tiếp nhận tư vấn phụ huynh và học viên", "CENTER", "tel", null,
                    "0988.123.456"));
            grouped.getCenterInfo().add(createItem(KEY_CENTER_EMAIL, map, "Email liên hệ",
                    "Hòm thư tiếp nhận thông tin phản hồi và hỗ trợ", "CENTER", "email", null,
                    "contact@educenter.vn"));
            grouped.getCenterInfo().add(createItem(KEY_CENTER_ADDRESS, map, "Địa chỉ trụ sở",
                    "Địa chỉ cơ sở đào tạo chính", "CENTER", "text", null,
                    "Số 123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội"));

            // 2. Academic rules
            grouped.getAcademicRules().add(createItem(KEY_MAX_CAPACITY, map, "Sĩ số lớp nhóm mặc định",
                    "Giới hạn học viên tối đa mặc định khi tạo lớp học nhóm mới", "ACADEMIC", "number", "học viên",
                    "15"));

            // 3. Finance rules
            grouped.getFinanceRules().add(createItem(KEY_TUITION_DUE_DAYS, map, "Kỳ hạn nộp học phí",
                    "Số ngày học viên cần hoàn tất học phí kể từ khi phát hành hóa đơn", "FINANCE", "number", "ngày",
                    "7"));

            // 4. Admission status
            SystemSetting admSetting = map.get(KEY_ADMISSIONS_OPEN);
            boolean open = admSetting == null || "true".equalsIgnoreCase(admSetting.getSettingValue().trim());
            grouped.setAdmissionsOpen(open);

            return grouped;
        } finally {
            em.close();
        }
    }

    private SettingItemViewDTO createItem(String key, Map<String, SystemSetting> map, String label,
                                          String desc, String group, String inputType, String unit, String defaultVal) {
        SystemSetting s = map.get(key);
        String val = (s != null && s.getSettingValue() != null) ? s.getSettingValue() : defaultVal;
        LocalDateTime updated = (s != null) ? s.getUpdatedAt() : LocalDateTime.now();
        Long updater = (s != null) ? s.getUpdatedBy() : null;
        return new SettingItemViewDTO(key, val, label, desc, group, inputType, unit, updated, updater);
    }

    @Override
    public String getSettingValue(String key, String defaultValue) {
        if (key == null) return defaultValue;
        EntityManager em = entityManagerSupplier.get();
        try {
            return settingRepository.findByKey(em, key.trim())
                    .map(SystemSetting::getSettingValue)
                    .orElse(defaultValue);
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isAdmissionsOpen() {
        String val = getSettingValue(KEY_ADMISSIONS_OPEN, "true");
        return "true".equalsIgnoreCase(val.trim());
    }

    @Override
    public void updateSettings(Long adminId, Map<String, String> newValues, String ipAddress) {
        if (adminId == null) {
            throw new AuthorizationException("Bạn cần đăng nhập với quyền Quản trị viên để thực hiện thao tác này.");
        }
        if (newValues == null || newValues.isEmpty()) {
            throw new ValidationException("Không có dữ liệu cấu hình nào được gửi lên.");
        }

        // Validate all keys against allowlist
        for (String key : newValues.keySet()) {
            if (!ALLOWLIST_KEYS.contains(key)) {
                throw new ValidationException("Tham số cấu hình '" + key + "' không nằm trong danh mục cho phép chỉnh sửa.");
            }
        }

        // Validate values
        validateSettingValues(newValues);

        EntityManager em = entityManagerSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // Authorize Admin
            User admin = userRepository.findById(em, adminId)
                    .orElseThrow(() -> new AuthorizationException("Không tìm thấy thông tin tài khoản người dùng."));

            boolean isAdmin = admin.getRoles().stream().map(Role::getCode).anyMatch("ADMIN"::equals);
            if (!isAdmin || !User.STATUS_ACTIVE.equals(admin.getStatus())) {
                throw new AuthorizationException("Chỉ tài khoản Quản trị viên đang hoạt động mới được phép sửa cấu hình hệ thống.");
            }

            Map<String, String> oldValuesMap = new HashMap<>();
            Map<String, String> updatedValuesMap = new HashMap<>();

            for (Map.Entry<String, String> entry : newValues.entrySet()) {
                String key = entry.getKey();
                String rawVal = entry.getValue();
                String cleanVal = (rawVal != null) ? rawVal.trim() : "";

                Optional<SystemSetting> opt = settingRepository.findByKey(em, key);
                if (opt.isPresent()) {
                    SystemSetting setting = opt.get();
                    if (!Objects.equals(setting.getSettingValue(), cleanVal)) {
                        oldValuesMap.put(key, setting.getSettingValue());
                        setting.setSettingValue(cleanVal);
                        setting.setUpdatedBy(adminId);
                        setting.setUpdatedAt(LocalDateTime.now());
                        settingRepository.update(em, setting);
                        updatedValuesMap.put(key, cleanVal);
                    }
                } else {
                    SystemSetting newSetting = new SystemSetting(key, cleanVal, "Cấu hình hệ thống", adminId);
                    settingRepository.save(em, newSetting);
                    oldValuesMap.put(key, "");
                    updatedValuesMap.put(key, cleanVal);
                }
            }

            if (!updatedValuesMap.isEmpty()) {
                String oldJson = mapToString(oldValuesMap);
                String newJson = mapToString(updatedValuesMap);

                AuditLog log = new AuditLog(
                        adminId,
                        "UPDATE_SETTINGS",
                        "SystemSetting",
                        0L,
                        oldJson,
                        newJson,
                        ipAddress
                );
                auditLogRepository.save(em, log);
                LOGGER.info("Admin " + adminId + " cập nhật cấu hình hệ thống: " + newJson);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException || e instanceof AuthorizationException) {
                throw e;
            }
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu cấu hình hệ thống: " + e.getMessage(), e);
            throw new ValidationException("Không thể lưu cấu hình hệ thống. Vui lòng thử lại sau.");
        } finally {
            em.close();
        }
    }

    @Override
    public void setAdmissionsOpen(Long adminId, boolean open, String ipAddress) {
        Map<String, String> map = new HashMap<>();
        map.put(KEY_ADMISSIONS_OPEN, open ? "true" : "false");
        updateSettings(adminId, map, ipAddress);
    }

    @Override
    public List<AuditLog> getRecentAuditLogs(int limit) {
        EntityManager em = entityManagerSupplier.get();
        try {
            return auditLogRepository.findRecentLogs(em, Math.max(1, Math.min(100, limit)));
        } finally {
            em.close();
        }
    }

    private void validateSettingValues(Map<String, String> values) {
        if (values.containsKey(KEY_CENTER_NAME)) {
            String name = values.get(KEY_CENTER_NAME);
            if (name == null || name.trim().length() < 2 || name.trim().length() > 200) {
                throw new ValidationException("Tên trung tâm phải từ 2 đến 200 ký tự.");
            }
        }
        if (values.containsKey(KEY_CENTER_HOTLINE)) {
            String phone = values.get(KEY_CENTER_HOTLINE);
            if (!ValidationUtil.isValidPhone(phone, true)) {
                throw new ValidationException("Hotline trung tâm không đúng định dạng số điện thoại Việt Nam.");
            }
        }
        if (values.containsKey(KEY_CENTER_EMAIL)) {
            String email = values.get(KEY_CENTER_EMAIL);
            if (!ValidationUtil.isValidEmail(email)) {
                throw new ValidationException("Email liên hệ của trung tâm không hợp lệ.");
            }
        }
        if (values.containsKey(KEY_CENTER_ADDRESS)) {
            String addr = values.get(KEY_CENTER_ADDRESS);
            if (addr == null || addr.trim().length() < 5 || addr.trim().length() > 255) {
                throw new ValidationException("Địa chỉ trụ sở phải từ 5 đến 255 ký tự.");
            }
        }
        if (values.containsKey(KEY_MAX_CAPACITY)) {
            String cap = values.get(KEY_MAX_CAPACITY);
            try {
                int c = Integer.parseInt(cap != null ? cap.trim() : "");
                if (c < 1 || c > 100) {
                    throw new ValidationException("Sĩ số lớp nhóm mặc định phải từ 1 đến 100 học viên.");
                }
            } catch (NumberFormatException e) {
                throw new ValidationException("Sĩ số lớp nhóm mặc định phải là số nguyên hợp lệ.");
            }
        }
        if (values.containsKey(KEY_TUITION_DUE_DAYS)) {
            String days = values.get(KEY_TUITION_DUE_DAYS);
            try {
                int d = Integer.parseInt(days != null ? days.trim() : "");
                if (d < 1 || d > 365) {
                    throw new ValidationException("Kỳ hạn nộp học phí phải từ 1 đến 365 ngày.");
                }
            } catch (NumberFormatException e) {
                throw new ValidationException("Kỳ hạn nộp học phí phải là số nguyên hợp lệ.");
            }
        }
        if (values.containsKey(KEY_ADMISSIONS_OPEN)) {
            String adm = values.get(KEY_ADMISSIONS_OPEN);
            if (!"true".equalsIgnoreCase(adm) && !"false".equalsIgnoreCase(adm)) {
                throw new ValidationException("Trạng thái nhận đơn tuyển sinh phải là true hoặc false.");
            }
        }
    }

    private String mapToString(Map<String, String> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        for (Map.Entry<String, String> e : map.entrySet()) {
            if (!first) sb.append(", ");
            sb.append("\"").append(e.getKey()).append("\": \"").append(e.getValue()).append("\"");
            first = false;
        }
        sb.append("}");
        return sb.toString();
    }
}
