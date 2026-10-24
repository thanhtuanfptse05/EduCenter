# Tasks: Điểm danh và Nhật ký Giảng dạy (feat-attendance-journal)

## Phase 1: JPA Entity & Persistence Configuration
- [x] Task 1.1: Tạo entity `TeachingJournal.java` trong `com.educenter.entity` ánh xạ bảng `dbo.TeachingJournals`.
- [x] Task 1.2: Đăng ký `TeachingJournal` vào `src/java/META-INF/persistence.xml`.

## Phase 2: DTOs & Repository Layer
- [x] Task 2.1: Tạo `AttendanceRosterItemDTO.java` trong `com.educenter.dto`.
- [x] Task 2.2: Tạo `AttendanceSessionViewDTO.java` trong `com.educenter.dto`.
- [x] Task 2.3: Tạo `TeachingJournalDTO.java` trong `com.educenter.dto`.
- [x] Task 2.4: Tạo `AttendanceRepository.java` trong `com.educenter.repository`.

## Phase 3: Service Layer & Business Rules
- [x] Task 3.1: Định nghĩa interface `AttendanceService.java` trong `com.educenter.service`.
- [x] Task 3.2: Triển khai `AttendanceServiceImpl.java` trong `com.educenter.service`.

## Phase 4: Unit Testing
- [x] Task 4.1: Viết `AttendanceServiceTest.java` (JUnit 5) kiểm tra điểm danh, hoàn tất và bảo mật quyền giáo viên.

## Phase 5: Controller & RBAC Filter (TCH-03, TCH-04)
- [x] Task 5.1: Tạo `TeacherAttendanceServlet.java` map `/teacher/attendance*` và `/teacher/journal*`.

## Phase 6: JSP Views (Chuẩn Design System design.md)
- [x] Task 6.1: Tạo `web/WEB-INF/views/teacher/attendance.jsp` (TCH-03).
- [x] Task 6.2: Tạo `web/WEB-INF/views/teacher/journal.jsp` (TCH-04).
- [x] Task 6.3: Cập nhật `sidebar.jspf` kích hoạt menu cho Giáo viên.

## Phase 7: Verification & Push to Main
- [x] Task 7.1: Chạy `scripts\verify.ps1` và `validate_specs.py`.
- [x] Task 7.2: Commit và push lên nhánh `main`.

## Phase 8: Teacher Attendance Bug Fixes & Robustness
- [x] Task 8.1: Sửa hàm `setAllAttendance` trong `attendance.jsp` để tránh nuốt tham số bởi JSP EL; cập nhật giao diện visual label và metrics.
- [x] Task 8.2: Chuyển thẻ input hidden `studentIds` vào trong `<td>` của dòng học viên để chuẩn hóa cấu trúc DOM bảng.
- [x] Task 8.3: Cập nhật `confirmCompleteAttendance()` và `TeacherAttendanceServlet` để chốt ca học gửi kèm toàn bộ dữ liệu điểm danh và lưu trước khi chuyển sang `COMPLETED`.
- [x] Task 8.4: Nâng cấp check constraint `CK_ClassSessions_Status` trong SQL Server để hỗ trợ `IN_PROGRESS` và bảo vệ giao dịch `saveAttendance`.
- [x] Task 8.5: Khử trùng lặp `studentId` và fallback `actor` an toàn trong `AttendanceServiceImpl.java`.
- [x] Task 8.6: Kiểm thử tự động và xác minh luồng người dùng thực tế.
