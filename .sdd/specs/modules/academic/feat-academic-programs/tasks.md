# Implementation Tasks: feat-academic-programs

**Feature:** `feat-academic-programs` | **Module:** Academic (M04) | **Spec:** [spec.md](spec.md) | **Plan:** [plan.md](plan.md)

---

## Phase 1: Setup & Data Transfer Objects (DTOs)
- [x] T001 [P] Tạo `SubjectFormDTO.java` và `SubjectAdminViewDTO.java` trong `com.educenter.dto`.
- [x] T002 [P] Tạo `CourseFormDTO.java`, `CourseAdminViewDTO.java`, và `CourseAdminStatsDTO.java` trong `com.educenter.dto`.

---

## Phase 2: Repositories & Data Access Layer
- [x] T003 Cập nhật `SubjectRepository.java`: bổ sung `findAllAdmin()`, `existsByCode(String code, Long excludeId)`, `save(Subject s)`, `update(Subject s)`.
- [x] T004 Cập nhật `CourseRepository.java`: bổ sung `findAdminCourses(CourseFilterDTO filter)`, `countAdminCourses(CourseFilterDTO filter)`, `getAdminStats()`, `existsByCode(String code, Long excludeId)`, `save(Course c)`, `update(Course c)`.

---

## Phase 3: User Story 1 (P0) — Quản lý Danh mục Môn học (Subjects)
- [x] T005 Triển khai `AcademicProgramService.java` và `AcademicProgramServiceImpl.java` xử lý nghiệp vụ Môn học: `getSubjectAdminList()`, `getSubjectById(Long id)`, `saveSubject(SubjectFormDTO dto, Long actorId, String actorEmail, String ipAddress)`, `toggleSubjectStatus(Long subjectId, Long actorId, String actorEmail, String ipAddress)` kèm kiểm tra ràng buộc BR16 (chặn INACTIVE khi còn khóa OPEN).
- [x] T006 Xây dựng `SubjectManagementServlet.java` quản lý routes `/staff/subjects`, `/staff/subjects/save`, `/staff/subjects/status` (PRG pattern, CSRF token, quyền STAFF/ADMIN, flash toast).
- [x] T007 Xây dựng view `web/WEB-INF/views/staff/subject-list.jsp` đạt chuẩn `design.md` (Default Light mode, outline Lucide SVG, modal thêm/sửa môn học, badge trạng thái, Empty State).

---

## Phase 4: User Story 2 (P0) — Quản lý Khóa học & Bảo toàn Học phí / Audit Log (Courses)
- [x] T008 Mở rộng `AcademicProgramService` và `AcademicProgramServiceImpl` với nghiệp vụ Khóa học: `getCourseAdminList(CourseFilterDTO filter)`, `getCourseAdminStats()`, `getCourseForm(Long id)`, `saveCourse(CourseFormDTO dto, Long actorId, String actorEmail, String ipAddress)` (validate grade 6–12, fee >= 0, code unique, subject active; ghi AuditLog atomic khi đổi phí hoặc tạo mới), `updateCourseStatus(Long courseId, String newStatus, Long actorId, String actorEmail, String ipAddress)`.
- [x] T009 Xây dựng `CourseManagementServlet.java` quản lý routes `/staff/courses`, `/staff/courses/form`, `/staff/courses/save`, `/staff/courses/status` (PRG pattern, CSRF token, flash toast).
- [x] T010 Xây dựng view danh sách khóa học `web/WEB-INF/views/staff/course-list.jsp` (KPI cards, tìm kiếm, lọc môn, khối 6–12, trạng thái, phân trang, đổi trạng thái nhanh, empty state chuyên nghiệp).
- [x] T011 Xây dựng view form thêm/sửa khóa học `web/WEB-INF/views/staff/course-form.jsp` (layout card 2 cột, dropdown môn học active, format tiền VND, validation realtime, breadcrumb).

---

## Phase 5: Integration, Navigation & Verification
- [x] T012 Cập nhật `web/WEB-INF/views/common/sidebar.jspf` bổ sung liên kết điều hướng "Khóa học" (`/staff/courses`) và "Môn học" (`/staff/subjects`) cho vai trò `STAFF` và `ADMIN`.
- [x] T013 Viết bộ kiểm thử JUnit 5 `test/com/educenter/service/AcademicProgramServiceTest.java` phủ kín các kịch bản thành công và lỗi nghiệp vụ (mã trùng, khối ngoài 6–12, học phí âm, chuyển môn inactive khi còn khóa open, ghi auditlog đổi phí).
- [x] T014 Chạy `.\scripts\verify.ps1`, đảm bảo 100% tests pass và WAR build thành công.
