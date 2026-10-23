# Quickstart Validation: System Administration (feat-system-administration)

**Target Feature:** `feat-system-administration`  
**Baseline:** Java 17 / Jakarta EE 10 / SQL Server / JUnit 5

---

## 1. Automated Testing Commands

Execute system administration service unit tests:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

## 2. Manual Verification Scenarios (End-to-End)

### Scenario 1: Access Control Check (FR-002, SEC-02)
1. Log in with a `STUDENT`, `TEACHER`, or `STAFF` account.
2. Attempt to navigate directly to `http://localhost:8080/EduCenter/admin/settings`.
3. **Expected Result:** RoleFilter intercepts and returns HTTP `403 Forbidden` (`/errors/403`).

### Scenario 2: Admin Updates Allowlisted Settings (FR-001, FR-002, FR-003, BR18)
1. Log in as an `ADMIN` (`admin@educenter.vn`).
2. Navigate to `http://localhost:8080/EduCenter/admin/settings`.
3. Verify that default values are dynamically populated from CSDL (`SystemSettings`).
4. Modify Center Name to: `EduCenter Academy - Cơ sở Cầu Giấy`, Hotline to: `0912.345.678`.
5. Submit form.
6. **Expected Result:**
   * Browser redirects via PRG with flash success message.
   * New values persist in CSDL and render on reload.
   * An entry in `dbo.AuditLogs` is created with action `UPDATE_SETTINGS`, recording old values and new values.

### Scenario 3: Admission Gatekeeper Toggle (FR-010)
1. In `/admin/settings`, toggle `Trạng thái nhận đơn tuyển sinh` to `TẠM ĐÓNG` (`false`).
2. Verify audit log is recorded.
3. In an incognito window as a guest, submit a consultation form from `/courses` or registration cart.
4. **Expected Result:** System notifies that admissions are currently paused, rejecting new leads/registrations safely without throwing an unhandled 500 error.
5. Re-open admissions from `/admin/settings`. Submissions function normally again.

### Scenario 4: Injection & Disallowed Key Rejection (FR-001, FR-005)
1. Attempt to POST a setting key not in the allowlist (e.g., `DATABASE_PASSWORD`, `EVAL_SCRIPT`).
2. **Expected Result:** Service immediately throws `ValidationException`, transaction rolls back, and no database record or secret is modified.
