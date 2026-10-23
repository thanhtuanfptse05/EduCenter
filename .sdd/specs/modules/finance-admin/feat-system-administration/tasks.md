# Tasks: System Administration & Audit Logs (feat-system-administration)

**Version:** 2.0.0 | **Branch:** `main` | **Target Module:** `MOD-FINANCE-ADMIN` (M12)  
**Spec Reference:** [spec.md](spec.md) | **Plan Reference:** [plan.md](plan.md)  
**Screens:** ADM-19 (`/admin/settings`)

---

## Phase 1: Setup & Data Model

**Purpose**: Define entity, DTOs, and persistence configuration.

- [x] T001 [P] Create JPA Entity `SystemSetting.java` mapping `dbo.SystemSettings` with fields `id`, `settingKey`, `settingValue`, `description`, `updatedBy`, `updatedAt` in `src/java/com/educenter/entity/SystemSetting.java`.
- [x] T002 Register `com.educenter.entity.SystemSetting` in `src/conf/META-INF/persistence.xml`.
- [x] T003 [P] Create DTOs `SettingItemViewDTO.java`, `SystemSettingsFormDTO.java`, and `SystemSettingsGroupedDTO.java` in `src/java/com/educenter/dto/`.

---

## Phase 2: Foundational Repositories

**Purpose**: Persistence operations for SystemSettings and AuditLogs.

- [x] T004 [P] Create `SystemSettingRepository.java` in `src/java/com/educenter/repository/SystemSettingRepository.java` with methods:
  - `Optional<SystemSetting> findByKey(EntityManager em, String key)`
  - `List<SystemSetting> findAll(EntityManager em)`
  - `void save(EntityManager em, SystemSetting setting)`
  - `void update(EntityManager em, SystemSetting setting)`
- [x] T005 [P] Enhance `AuditLogRepository.java` in `src/java/com/educenter/repository/AuditLogRepository.java` to support querying recent audit logs for the admin dashboard:
  - `List<AuditLog> findRecentLogs(EntityManager em, int limit)`
  - `long countLogs(EntityManager em)`

---

## Phase 3: User Story 1 (P0) — System Configuration & Transactional Audit (FR-001, FR-002, FR-005, BR18)

**Goal**: Admins can update allowlisted system parameters; all mutations and diffs are atomically logged to `AuditLogs` in the same transaction.

**Independent Test**: Update `CENTER_NAME` and `TUITION_DUE_DAYS`. Verify CSDL updates and corresponding `AuditLog` row exists with `UPDATE_SETTINGS`. Invalid key rejects.

- [x] T006 [P] [US1] Create unit test `SystemSettingServiceTest.java` in `test/com/educenter/service/SystemSettingServiceTest.java` asserting:
  - Allowlist enforcement: unknown key throws `ValidationException`.
  - Type & range constraints: `MAX_CLASS_CAPACITY_DEFAULT` must be 1..100; `TUITION_DUE_DAYS` must be 1..365; `CENTER_HOTLINE` must be valid VN phone.
  - Transactional audit log persistence: audit entry created with actor and diffs.
  - Secret protection: attempts to save sensitive keys are rejected.
- [x] T007 [US1] Create interface `SystemSettingService.java` in `src/java/com/educenter/service/SystemSettingService.java`.
- [x] T008 [US1] Implement `SystemSettingServiceImpl.java` in `src/java/com/educenter/service/SystemSettingServiceImpl.java`:
  - Define static immutable `ALLOWLIST_KEYS` and validation rules.
  - Implement `getGroupedSettings()` returning typed settings grouped into Center Info, Class Rules, Finance Rules, and Admissions.
  - Implement `getSettingValue(String key, String defaultValue)`.
  - Implement `updateSettings(Long adminId, Map<String, String> newValues, String ipAddress)` running in an `EntityTransaction` that updates/inserts settings and saves `AuditLog` atomically before commit.

---

## Phase 4: User Story 2 (P0) — Admission Intake Gatekeeper (FR-010)

**Goal**: Admin toggles `SYSTEM_ADMISSIONS_OPEN`. When false, consultation and intake forms notify guests and refuse new records without breaking admin operations.

**Independent Test**: Toggle flag to `false`. Public consultation returns admission closed notification. Toggle to `true`, normal flow resumes.

- [x] T009 [US2] Add `isAdmissionsOpen()` and `setAdmissionsOpen(Long adminId, boolean open, String ipAddress)` in `SystemSettingService.java` and `SystemSettingServiceImpl.java`.
- [x] T010 [US2] Wire admission gatekeeper check into `PublicCourseServlet.java` or `RegistrationCartServlet.java` to block consultation/cart checkout when admissions are closed.

---

## Phase 5: Controller & Professional UI (ADM-19)

**Goal**: Provide executive SaaS admin screen `/admin/settings` strictly adhering to `design.md`.

- [x] T011 [US1] Create `SystemSettingServlet.java` in `src/java/com/educenter/controller/SystemSettingServlet.java`:
  - Route: `/admin/settings` (and `/admin/settings/save`).
  - Strict `ADMIN` role check and CSRF validation.
  - GET: Load grouped settings and recent audit log preview, forward to `settings.jsp`.
  - POST: Process form updates, call `SystemSettingService.updateSettings()`, set flash message via `FlashMessageUtil`, redirect via PRG.
- [x] T012 [US1] Create `web/WEB-INF/views/admin/settings.jsp`:
  - Default Light Mode, executive SaaS aesthetic per `design.md`.
  - Lucide outline SVG icons (no emoji).
  - Categorized card layout:
    - Card 1: Thông tin trung tâm (Tên trung tâm, Hotline, Email, Trụ sở).
    - Card 2: Quy tắc tuyển sinh & Lớp học (Cờ mở tuyển sinh toggle switch, Sĩ số tối đa mặc định).
    - Card 3: Quy tắc tài chính (Hạn hoàn thành học phí).
    - Card 4: Nhật ký thao tác quản trị gần đây (Recent Audit Logs table with action badges, actor, timestamp, diffs modal/view).
  - Navigation links to User Management (`/admin/users`) and Course Management (`/staff/courses`).
  - Professional empty state if no audit logs exist.

---

## Phase 6: Polish, Testing & Deployment

- [x] T013 Run JUnit tests in `SystemSettingServiceTest.java` and full project verification via `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`.
- [x] T014 Perform end-to-end check in browser (Light mode styling, toggle switch, save settings, audit logs display).
- [x] T015 Commit and push clean feature to `main` with `feat(system-admin): implement system settings and audit logging P0`.
