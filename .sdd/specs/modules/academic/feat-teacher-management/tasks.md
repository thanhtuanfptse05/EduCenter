# Implementation Tasks: feat-teacher-management

**Feature:** `feat-teacher-management` | **Module:** Academic (M04 / M05 / M12) | **Spec:** [spec.md](spec.md) | **Plan:** [plan.md](plan.md)

---

## Phase 1: Setup & Data Transfer Objects (DTOs)
- [x] T001 [P] Tạo `TeacherAdminViewDTO.java`, `TeacherAdminStatsDTO.java`, `TeacherFormDTO.java`, `AvailableTeacherUserDTO.java`, `TeacherFilterDTO.java` trong `com.educenter.dto`.

---

## Phase 2: Repository Layer
- [x] T002 Tạo `TeacherRepository.java` trong `com.educenter.repository` với các phương thức CRUD, thống kê KPI, kiểm tra liên kết 1-1 với User, và đếm lịch tương lai (BR05 / FR-005).

---

## Phase 3: Service Layer & Unit Tests
- [x] T003 Triển khai `TeacherManagementService.java` và `TeacherManagementServiceImpl.java` xử lý nghiệp vụ: liên kết User TEACHER hợp lệ, xác thực thù lao, chặn ngừng hoạt động khi còn buổi dạy tương lai (BR05 / FR-005), ghi nhật ký kiểm toán `AuditLog` atomic (BR18).
- [x] T004 Viết bộ kiểm thử JUnit 5 `test/com/educenter/service/TeacherManagementServiceTest.java` bao phủ các kịch bản thành công và ngoại lệ nghiệp vụ.

---

## Phase 4: Controller & UI Views (ADM-09)
- [x] T005 Xây dựng `TeacherManagementServlet.java` quản lý routes `/staff/teachers`, `/staff/teachers/form`, `/staff/teachers/save`, `/staff/teachers/status` (PRG pattern, CSRF token, quyền STAFF/ADMIN, flash toast).
- [x] T006 Xây dựng view danh sách giáo viên `web/WEB-INF/views/staff/teacher-list.jsp` đạt chuẩn `design.md` (Default Light mode, outline Lucide SVG, KPI cards, avatar, badge chuyên môn/bằng cấp, bộ lọc đa năng, phân trang, đổi trạng thái nhanh, empty state).
- [x] T007 Xây dựng view form giáo viên `web/WEB-INF/views/staff/teacher-form.jsp` (layout card 2 cột, dropdown chọn User TEACHER khả dụng, chuyên môn, bằng cấp, thù lao, bio).
- [x] T008 Cập nhật `web/WEB-INF/views/common/sidebar.jspf` bổ sung menu "Đội ngũ Giáo viên" (`/staff/teachers`).

---

## Phase 5: Verification & Push to Main
- [x] T009 Chạy `.\scripts\verify.ps1`, đảm bảo 100% tests pass và WAR build thành công.
- [x] T010 Đồng bộ `build/web` và commit + push lên nhánh `main` (`feat(academic): implement teacher profiles and management P0`).
