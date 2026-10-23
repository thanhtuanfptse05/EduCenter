# Implementation Plan: Cấu hình, danh mục và nhật ký hệ thống (feat-system-administration)

**Branch**: `main` | **Date**: 2026-10-23 | **Spec**: [spec.md](spec.md)  
**Status**: Ready for Tasks & Implementation | **Owner**: Member 03  
**Target Module**: `MOD-FINANCE-ADMIN` (M12) | **Screen**: ADM-19 (`/admin/settings`)

---

## 1. Summary

Implement the System Administration and Configuration management subsystem (P0) for EduCenter:
1. JPA Entity `SystemSetting` mapping `dbo.SystemSettings` with typed validation against an immutable allowlist (`CENTER_NAME`, `CENTER_HOTLINE`, `CENTER_EMAIL`, `CENTER_ADDRESS`, `MAX_CLASS_CAPACITY_DEFAULT`, `TUITION_DUE_DAYS`, `SYSTEM_ADMISSIONS_OPEN`).
2. Service layer `SystemSettingService` managing transactional updates, allowlist validation, and atomic `AuditLog` generation in the same transaction (BR18, FR-002, FR-006).
3. Admission gatekeeper toggle (FR-010) controlling intake endpoints without locking admin tools.
4. Controller `SystemSettingServlet` (`/admin/settings`) protected by `RoleFilter` (`ADMIN` only) implementing Post/Redirect/Get with CSRF protection and flash messages.
5. Executive SaaS JSP view `settings.jsp` adhering 100% to [design.md](../../../../design.md) (Default Light mode, design tokens, Lucide SVG icons, responsive layout, no hardcoded rows, professional empty states).

---

## 2. Technical Context

* **Language/Version:** OpenJDK 17 (Java 17 LTS)
* **Primary Dependencies:** Jakarta Servlet 6.0, Jakarta Persistence (JPA 3.1), Hibernate ORM 6.x
* **Storage:** Microsoft SQL Server (`dbo.SystemSettings`, `dbo.AuditLogs`)
* **Testing:** JUnit 5, existing verify script (`verify.ps1`)
* **Target Platform:** Apache Tomcat 10.1 on Windows / Linux
* **Architecture Pattern:** Phân tầng MVC:
  `Client Browser -> Filter (RoleFilter, EncodingFilter) -> SystemSettingServlet -> SystemSettingService -> SystemSettingRepository & AuditLogRepository -> Hibernate -> SQL Server`
* **Constraints:** No raw JDBC; no secrets (DB/SMTP) in settings; default Light mode; no emoji icons; append-only audit trail; strictly zero mock data on UI.

---

## 3. Constitution Check

* [x] **ARTICLE 1 (Tech Stack):** Java 17, Tomcat 10.1, JPA 3.1, Hibernate, SQL Server, JSP+JSTL (no scriptlets), CSS Tokens from `design.md`, Lucide SVG icons.
* [x] **ARTICLE 2 (Hard Rules):**
  * `SEC-02` RBAC: Route `/admin/settings` strictly protected for role `ADMIN`.
  * `SEC-03` Financial & Audit: Audit logging is append-only; changes to settings record actor, time, and diffs.
  * `SEC-04` Transaction Management: Settings mutation and AuditLog creation execute atomically in one `EntityTransaction`.
* [x] **ARTICLE 3 (Conventions):** PRG pattern applied on `/admin/settings`. CSRF token verified on all POST requests.
* [x] **ARTICLE 4 (Testing):** JUnit 5 tests covering allowlist validation, unauthorized access denial, atomic transaction rollback, and admission status toggle.

---

## 4. Project Structure & Components

```text
src/java/com/educenter/
├── entity/
│   ├── SystemSetting.java            # [NEW] JPA Entity for dbo.SystemSettings
│   └── AuditLog.java                 # [EXISTING] JPA Entity for dbo.AuditLogs
├── repository/
│   ├── SystemSettingRepository.java  # [NEW] JPA queries for SystemSettings
│   └── AuditLogRepository.java       # [EXISTING/ENHANCED] Audit log queries & append
├── dto/
│   ├── SettingItemViewDTO.java       # [NEW] DTO for rendering setting cards
│   └── SystemSettingsFormDTO.java    # [NEW] Form backing object for updates
├── service/
│   ├── SystemSettingService.java     # [NEW] Business interface for settings & audit
│   └── SystemSettingServiceImpl.java # [NEW] Implementation with allowlist validation & transaction
└── controller/
    └── SystemSettingServlet.java     # [NEW] Admin controller for /admin/settings

web/
├── WEB-INF/views/admin/
│   └── settings.jsp                  # [NEW] ADM-19 screen following design.md
└── assets/css/
    └── screens.css                   # [ENHANCED] Admin settings layout styles if needed
```

---

## 5. Verification & Acceptance Criteria

* **FR-001 / SC-001:** Allowlist enforcement — invalid keys or values out of range throw `ValidationException`.
* **FR-002 / SC-002:** Transactional atomicity — updating settings persists diffs into `AuditLogs` in the same transaction.
* **FR-003:** Center name, phone, address dynamically retrieved from CSDL by public/landing layouts.
* **FR-005 / SC-003:** Zero passwords, SMTP secrets, or DB connection strings exposed.
* **FR-008:** Audit log cannot be deleted or modified via UI.
* **FR-010:** Admission toggle `SYSTEM_ADMISSIONS_OPEN` reflects instantly across admission intake checks.
