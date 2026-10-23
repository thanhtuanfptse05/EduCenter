package com.educenter.service;

import com.educenter.dto.SystemSettingsGroupedDTO;
import com.educenter.entity.AuditLog;
import java.util.List;
import java.util.Map;

/**
 * Service interface for managing system configuration and auditing (M12, BR18, FR-001, FR-002, FR-010).
 */
public interface SystemSettingService {

    /**
     * Retrieve categorized settings for the administration interface.
     */
    SystemSettingsGroupedDTO getGroupedSettings();

    /**
     * Retrieve a setting value by key with a fallback default.
     */
    String getSettingValue(String key, String defaultValue);

    /**
     * Check if admission intake is currently active.
     */
    boolean isAdmissionsOpen();

    /**
     * Atomically update allowlisted settings and persist an audit trail in the same transaction.
     *
     * @param adminId User ID of the admin performing the update.
     * @param newValues Map of setting keys and their updated values.
     * @param ipAddress IP address of the client request.
     * @throws ValidationException if keys or values fail validation.
     * @throws AuthorizationException if actor is not an authorized administrator.
     */
    void updateSettings(Long adminId, Map<String, String> newValues, String ipAddress);

    /**
     * Toggle admission intake status with audit logging.
     */
    void setAdmissionsOpen(Long adminId, boolean open, String ipAddress);

    /**
     * Retrieve recent system audit logs for administrative monitoring.
     */
    List<AuditLog> getRecentAuditLogs(int limit);
}
