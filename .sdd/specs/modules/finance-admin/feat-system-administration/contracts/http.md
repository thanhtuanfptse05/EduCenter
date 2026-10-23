# HTTP Contracts: System Administration (ADM-19)

**Screen:** ADM-19 | **URL Pattern:** `/admin/settings`  
**Authorization:** Required Role `ADMIN` | **CSRF:** Required on all POSTs

---

## 1. GET /admin/settings

* **Description:** Render the system administration configuration dashboard and audit logs summary.
* **Request Headers:** Cookie session with active `ADMIN` principal.
* **Query Parameters:**
  * `tab`: Optional (`"config"` | `"audit"`, default `"config"`).
* **Response:**
  * Status `200 OK`
  * Forward to `/WEB-INF/views/admin/settings.jsp`
  * Attributes provided to request:
    * `settingsGroup`: Categorized map of `SettingItemViewDTO`
    * `admissionsOpen`: Boolean status flag
    * `recentAuditLogs`: List of recent `AuditLog` entries for display
    * `csrfToken`: String CSRF token
    * `pageTitle`: "Cấu hình hệ thống & Quản trị — EduCenter ERP"
  * Error handling:
    * Not authenticated → Redirect `/login`
    * Role is not ADMIN → `403 Forbidden`

---

## 2. POST /admin/settings

* **Description:** Update one or more allowlisted system configuration parameters.
* **Form Parameters:**
  * `_csrf`: CSRF token (validated)
  * `action`: `"save_settings"` | `"toggle_admissions"`
  * When `action=save_settings`:
    * `CENTER_NAME`: String
    * `CENTER_HOTLINE`: String
    * `CENTER_EMAIL`: String
    * `CENTER_ADDRESS`: String
    * `MAX_CLASS_CAPACITY_DEFAULT`: Integer string
    * `TUITION_DUE_DAYS`: Integer string
  * When `action=toggle_admissions`:
    * `admissionsOpen`: `"true"` | `"false"`
* **Processing:**
  * Validate CSRF.
  * Check current session user is active `ADMIN`.
  * Validate each key against allowlist constraints.
  * Start transaction: update/insert `SystemSettings` rows, write `AuditLog` entry. Commit transaction.
* **Response (PRG Pattern):**
  * On Success: `302 Found` → Redirect to `${contextPath}/admin/settings` with flash message "Cập nhật cấu hình hệ thống thành công."
  * On Validation Error: `302 Found` → Redirect to `${contextPath}/admin/settings` with flash error message detailing invalid field.
