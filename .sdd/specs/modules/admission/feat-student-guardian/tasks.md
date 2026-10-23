# Tasks: Hồ sơ học viên, phụ huynh và xác thực giám hộ (feat-student-guardian)

**Branch**: `feat-student-guardian` | **Spec**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

## Phase 1: Setup & JPA Entities
- [x] T001 Create JPA Entity `Student.java` in `src/java/com/educenter/entity/Student.java` mapped to `Students` table
- [x] T002 Create JPA Entity `Guardian.java` in `src/java/com/educenter/entity/Guardian.java` mapped to `Guardians` table
- [x] T003 Create JPA Entity `StudentGuardian.java` in `src/java/com/educenter/entity/StudentGuardian.java` mapped to `StudentGuardians` table
- [x] T004 Register `Student`, `Guardian`, `StudentGuardian` entities in `src/java/META-INF/persistence.xml`

## Phase 2: DTOs & Repositories
- [x] T005 Create DTOs `StudentFilterDTO`, `StudentAdminViewDTO`, `StudentDetailDTO`, `StudentFormDTO`, `StudentStatsDTO` in `src/java/com/educenter/dto/`
- [x] T006 Create DTOs `GuardianFilterDTO`, `GuardianAdminViewDTO`, `GuardianFormDTO`, `StudentGuardianLinkDTO` in `src/java/com/educenter/dto/`
- [x] T007 Create `StudentRepository.java` in `src/java/com/educenter/repository/StudentRepository.java`
- [x] T008 Create `GuardianRepository.java` in `src/java/com/educenter/repository/GuardianRepository.java`

## Phase 3: Service Layer & Business Rules
- [x] T009 Create interface `StudentService.java` in `src/java/com/educenter/service/StudentService.java`
- [x] T010 Implement `StudentServiceImpl.java` in `src/java/com/educenter/service/StudentServiceImpl.java` with validation (BR01, BR02, BR15, BR16)
  - Student CRUD & status transitions (STUDYING, RESERVED, DROPPED, GRADUATED)
  - User STUDENT account linkage
  - Guardian CRUD with PARENT role check
  - Student-Guardian many-to-many relationship linking
  - Verification & Revocation of guardianship with AuditLog

## Phase 4: Controllers & Servlets
- [x] T011 Create `StudentManagementServlet.java` in `src/java/com/educenter/controller/StudentManagementServlet.java` (`/staff/students`, `/staff/students/detail`, `/staff/students/save`, `/staff/students/status`, `/staff/students/user-link`)
- [x] T012 Create `GuardianManagementServlet.java` in `src/java/com/educenter/controller/GuardianManagementServlet.java` (`/staff/guardians`, `/staff/guardians/save`, `/staff/guardians/link`, `/staff/guardians/verify`, `/staff/guardians/revoke`)
- [x] T013 Update navigation links in `web/WEB-INF/views/common/sidebar.jspf` for Students and Guardians

## Phase 5: JSP Views (Design System, 100% Dynamic Data)
- [x] T014 Create `web/WEB-INF/views/staff/student-list.jsp` (ADM-06: KPI summary, filters, table with status badges, pagination, add/edit modal)
- [x] T015 Create `web/WEB-INF/views/staff/student-detail.jsp` (ADM-07: Tabbed profile, personal info, linked guardians with verification status, class history)
- [x] T016 Create `web/WEB-INF/views/staff/guardian-list.jsp` (ADM-08: Guardian list, child links, verify/revoke actions with notes)

## Phase 6: Verification & Git Commit
- [x] T017 Create unit tests in `test/com/educenter/service/StudentServiceTest.java`
- [x] T018 Check & seed initial sample data in `EduCenterDB` for demonstration
- [x] T019 Run `verify.ps1`, verify build & all unit tests pass, hot deploy to `build/web/`
- [x] T020 Commit & push to `main` with message `feat(admission): implement student and guardian management with verified guardianship`
