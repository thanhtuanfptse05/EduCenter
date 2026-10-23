# Research & Technical Decisions: feat-student-guardian

## Decision 1: Student Code & Identifier Strategy
- **Decision:** Format `HV` + zero-padded 4 digits (e.g., `HV0001`, `HV0012`). In the DB table `Students`, the primary key is `id` (bigint identity). A helper method `getCode()` formats `HV` + String.format("%04d", id).
- **Rationale:** Ensures clean, predictable, and unique identifier display across UIs, matching project conventions (`GV001` for teachers, `KH001` for courses).
- **Alternatives Considered:** Adding a separate unique varchar column `code` in the database; however, table `Students` in DB already exists without a `code` column, so computing `HV` + zero-padded `id` maintains 100% database schema compatibility without requiring DDL alterations.

## Decision 2: User Account Linkage & Isolation (BR01, BR02, BR15)
- **Decision:**
  - `Student.user_id` is nullable. A student profile can exist independently of any system user account (representing students enrolled offline).
  - When linking a user account to a Student:
    1. The target User must exist, be ACTIVE, and have the `STUDENT` role.
    2. The User cannot be already linked to another Student record.
  - `Guardian.user_id` is NOT NULL (or must point to a valid User with the `PARENT` role). One User can be linked to at most one Guardian profile.
- **Rationale:** Aligns with SRS M02/M06 and FR-001/FR-002: Portal access requires explicit user credentials, but enrollment and tutoring management start in the ERP without forcing pre-created logins.

## Decision 3: Verification & Revocation of Guardianship (BR15, WF-05)
- **Decision:**
  - The `StudentGuardians` table contains `verified_at` (timestamp) and `verified_by` (Staff/Admin user ID).
  - A relationship is considered **VERIFIED** if and only if `verified_at != null`.
  - When verified: STAFF/ADMIN provides a note/basis, system records `verified_at = LocalDateTime.now()`, `verified_by = actorId`, and logs `AuditLog(action="VERIFY_GUARDIAN_LINK")`.
  - When revoked: `verified_at` and `verified_by` are set to `null`, and system logs `AuditLog(action="REVOKE_GUARDIAN_LINK", reason=...)`.
  - Only relationships that are VERIFIED grant Parents access to view children data in Parent Portal.

## Decision 4: Architecture & UI Conventions
- **Decision:**
  - Standard MVC layered architecture: `Student` & `Guardian` & `StudentGuardian` entities -> `StudentRepository` & `GuardianRepository` -> `StudentService` -> `StudentManagementServlet` & `GuardianManagementServlet` -> JSP views in `web/WEB-INF/views/staff/`.
  - UI strictly follows `design.md`: Light mode default, Lucide SVG outline icons (18-20px), Inter typography, responsive tables with clear status badges, empty states, and KPI cards with dynamic counts.
