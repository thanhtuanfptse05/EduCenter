# Data Model: System Administration (feat-system-administration)

**Version:** 2.0.0 | **Status:** Locked  
**Target Entities:** `SystemSetting`, `AuditLog`

---

## 1. Entity: SystemSetting

Maps table `dbo.SystemSettings`:

| Field | Column | Type | Nullable | Validation / Constraints |
|---|---|---|---|---|
| `id` | `id` | `Long` (PK Identity) | No | Auto-generated identity |
| `settingKey` | `setting_key` | `String` (varchar 100) | No | Unique, immutable once created, must belong to allowlist |
| `settingValue` | `setting_value` | `String` (nvarchar max) | No | Typed validation per allowlist key |
| `description` | `description` | `String` (nvarchar 255) | Yes | Human-readable description |
| `updatedBy` | `updated_by` | `Long` (FK Users.id) | Yes | Admin user who performed update |
| `updatedAt` | `updated_at` | `LocalDateTime` | No | Auto-timestamp on change |

### Allowlist Specification & Types:

| Key | Java Type | Format / Range | Default Value | Description |
|---|---|---|---|---|
| `CENTER_NAME` | `String` | 2 – 200 chars | `"EduCenter - Trung Tâm Bồi Dưỡng Văn Hóa & Luyện Thi"` | Tên trung tâm |
| `CENTER_HOTLINE` | `String` | Regex VN phone | `"0988.123.456"` | Hotline tư vấn |
| `CENTER_EMAIL` | `String` | Valid email | `"contact@educenter.vn"` | Email liên hệ |
| `CENTER_ADDRESS` | `String` | 5 – 255 chars | `"Số 123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội"` | Địa chỉ trụ sở |
| `MAX_CLASS_CAPACITY_DEFAULT`| `Integer` | 1 <= n <= 100 | `"15"` | Sĩ số lớp nhóm mặc định |
| `TUITION_DUE_DAYS` | `Integer` | 1 <= n <= 365 | `"7"` | Kỳ hạn nộp học phí (ngày) |
| `SYSTEM_ADMISSIONS_OPEN` | `Boolean` | `"true"` / `"false"` | `"true"` | Cờ nhận đơn tuyển sinh |

---

## 2. Entity: AuditLog

Maps table `dbo.AuditLogs`:

| Field | Column | Type | Nullable | Description |
|---|---|---|---|---|
| `id` | `id` | `Long` (PK Identity) | No | Unique sequence ID |
| `actorId` | `actor_id` | `Long` (FK Users.id) | Yes | ID of User performing mutation |
| `action` | `action` | `String` (varchar 50) | No | Action code, e.g. `UPDATE_SETTINGS`, `TOGGLE_ADMISSION` |
| `entityType` | `entity_type` | `String` (varchar 50) | No | Entity modified, e.g. `SystemSetting`, `User`, `Course` |
| `entityId` | `entity_id` | `Long` | No | ID of entity, or `0` for bulk/global config |
| `oldValues` | `old_values` | `String` (nvarchar max) | Yes | JSON or formatted string of previous values (masked) |
| `newValues` | `new_values` | `String` (nvarchar max) | Yes | JSON or formatted string of new values (masked) |
| `ipAddress` | `ip_address` | `String` (varchar 45) | Yes | IPv4 / IPv6 of actor |
| `createdAt` | `created_at` | `LocalDateTime` | No | Timestamp of event |

---

## 3. Data Transfer Objects (DTOs)

* `SystemSettingsFormDTO`: Groups submitted settings from admin form with individual field getters.
* `SettingItemViewDTO`: Key, value, label, group, description, data type, options.
* `SystemSettingsGroupedDTO`: Grouped map for UI rendering (Thông tin trung tâm, Quy tắc đào tạo, Quy tắc tài chính, Trạng thái vận hành).
* `AuditLogEntryDTO`: DTO for displaying recent audit history on tab/preview.
