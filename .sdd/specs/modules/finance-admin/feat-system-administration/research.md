# Research: System Administration & Audit Logs (feat-system-administration)

**Date:** 2026-10-23 | **Status:** Completed  
**Domain:** Administrative parameters, allowlist validation, admissions toggle, transaction-bound audit logs (BR18, M12).

---

## 1. Key Decisions & Rationales

### Decision 1: Strict Allowlist for SystemSettings Keys
* **Decision:** Only predefined keys in an immutable allowlist can be read/written by the service. Any unknown key submitted via form or API is rejected with `ValidationException`.
* **Allowlist Definition:**
  1. `CENTER_NAME`: Name of tutoring center (String, 2–200 chars).
  2. `CENTER_HOTLINE`: Public phone/hotline (String, 9–20 chars, VN phone format).
  3. `CENTER_EMAIL`: Public contact email (String, valid email).
  4. `CENTER_ADDRESS`: Physical campus address (String, 5–255 chars).
  5. `MAX_CLASS_CAPACITY_DEFAULT`: Default class room capacity for groups (Integer, 1–100).
  6. `TUITION_DUE_DAYS`: Days before tuition payment due date (Integer, 1–365).
  7. `SYSTEM_ADMISSIONS_OPEN`: Admission intake gate flag (`"true"` or `"false"`).
* **Rationale:** FR-001 & FR-005 mandate that administrators cannot inject arbitrary configuration keys, execute dynamic script eval, or expose DB/SMTP secrets through settings.

### Decision 2: Transaction-Bound Audit Logging (BR18)
* **Decision:** Audit logging must occur within the exact same `EntityTransaction` as the mutating action. If the audit log fails to persist, the entire transaction rolls back.
* **Mechanism:**
  `AuditLogRepository.save(EntityManager em, AuditLog log)` is passed the current active `EntityManager`. The service persists the setting mutation and the `AuditLog` row together before `tx.commit()`.
* **Rationale:** FR-002, FR-006, and SEC-03 require that mutation records never become decoupled from their audit trails.

### Decision 3: Admission Status Toggle (FR-010)
* **Decision:** The key `SYSTEM_ADMISSIONS_OPEN` controls whether new leads and registrations are accepted. When `"false"`, public consultation and enrollment endpoints reject submissions with an informative message. Existing data, admin portal, and viewing courses remain fully functional.
* **Rationale:** FR-010 specifies that toggling admission status must be audited and enforced across services without disrupting administrative operations.

### Decision 4: No Direct Deletion / Update of Audit Logs
* **Decision:** `AuditLogs` is strictly append-only. There is no controller route, repository method, or UI button allowing edit or deletion of audit logs (FR-008).
* **Rationale:** SEC-03 and FR-008 ensure compliance with ERP immutability and financial/administrative audit standards.

### Decision 5: Separation of Concerns with Rooms and Accounts
* **Decision:** System Administration UI (`ADM-19`) provides direct navigation cards/links to User Management (`ADM-18` at `/admin/users`) and Room Management (`ADM-13` at `/staff/classes` / rooms). It does not duplicate user or room CRUD logic.
* **Rationale:** FR-009 enforces single-ownership per screen and entity.
