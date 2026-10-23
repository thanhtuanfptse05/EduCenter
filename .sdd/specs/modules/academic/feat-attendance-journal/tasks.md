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
