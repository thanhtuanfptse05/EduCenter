# Tasks: System Hardening & Complete Stabilization (feat-project-completion)

**Plan**: [plan.md](plan.md) | **Spec**: [spec.md](spec.md)  
**Status**: Completed (100%) - All Tests Passed (151/151)

---

## Task Group 1: Academic Logic Hardening & Unit Test Isolation (B01, B02, B03, B04, B05, B09, B12)

- [x] **Task 1.1**: Chuẩn hóa tiêm `EntityManager` trong `AttendanceServiceImpl` và cập nhật `AttendanceServiceTest` để 5 test chạy pass cô lập.
- [x] **Task 1.2**: Sửa `AssessmentServiceImpl.saveScores` để kiểm tra học viên thuộc lớp (B01), xử lý xóa điểm khi ô nhập liệu rỗng (B03), và chặn sửa trực tiếp bài thi đã công bố (B12).
- [x] **Task 1.3**: Bổ sung ghi `AuditLog` nghiệp vụ trong `AssessmentServiceImpl.reopenAssessment` và `publishAssessment` (B12).
- [x] **Task 1.4**: Sửa `PortalServiceImpl.buildStudentSummary` để chuẩn hóa điểm về thang 10 và tính điểm trung bình theo trọng số (B02).
- [x] **Task 1.5**: Sửa `AttendanceServiceImpl.saveAttendance` kiểm tra học viên có Enrollment hiệu lực vào ngày buổi học (B01).
- [x] **Task 1.6**: Cập nhật `AttendanceRepository.findRosterForSession` bảo tồn học viên đã từng có điểm danh hoặc có ghi danh hiệu lực tại ngày của buổi học (B05).
- [x] **Task 1.7**: Sửa `ClassTimetableServiceImpl.generateRecurringSessions` giới hạn sinh lịch không vượt quá `endDate` và kiểm tra sức chứa phòng học `room.capacity >= eduClass.capacity` (B09).

---

## Task Group 2: Admission, Enrollment & CRM Hardening (B07, B08, B10, B13)

- [x] **Task 2.1**: Sửa `EnrollmentServiceImpl.enrollStudent` để kiểm tra sĩ số và khóa cập nhật trong transaction; kiểm tra Course status và Student status (B07).
- [x] **Task 2.2**: Đọc cấu hình `TUITION_DUE_DAYS` trong `EnrollmentServiceImpl` khi sinh hóa đơn ban đầu thay vì hardcode 10 ngày (B13).
- [x] **Task 2.3**: Sửa `EnrollmentServiceImpl.resumeEnrollment` kiểm tra lại xung đột thời khóa biểu (`hasScheduleConflict`) (B08).
- [x] **Task 2.4**: Sửa `EnrollmentServiceImpl.transferClass` loại trừ lớp cũ khi kiểm tra xung đột lịch và kiểm tra trùng lặp ở lớp đích (B08).
- [x] **Task 2.5**: Bổ sung phương thức kiểm tra lịch loại trừ lớp cũ trong `EnrollmentRepository`.
- [x] **Task 2.6**: Cập nhật `LeadServiceImpl` và `LeadController` để phân quyền STAFF theo `assignedTo`, và cấm chuyển trạng thái sang `ENROLLED` thủ công (B10).
- [x] **Task 2.7**: Kiểm tra cờ `SYSTEM_ADMISSIONS_OPEN` trong form tư vấn và ghi danh mới (B13).

---

## Task Group 3: Finance & Reporting Fixes (B06, B11, B12)

- [x] **Task 3.1**: Sửa công thức tính công nợ trong `ReportRepository.getDashboardData` lấy `finalAmount - paidAmount` của các hóa đơn chưa trả hết (B06).
- [x] **Task 3.2**: Sửa tỷ lệ chuyên cần trong `ReportRepository.getDashboardData` tính cả `LATE` và không gán mặc định 100% khi chưa có buổi học (B04).
- [x] **Task 3.3**: Sửa `PaymentServiceImpl.recordManualPayment` bắt buộc có `transactionRef` khi thanh toán `BANK_TRANSFER`, kiểm tra trùng lặp mã giao dịch, và lưu `AuditLog` (B11, B12).
- [x] **Task 3.4**: Bổ sung hàm kiểm tra trùng `transactionRef` trong `PaymentRepository`.

---

## Task Group 4: UI Hardening, Policy Pages & CSS Tokens Sync

- [x] **Task 4.1**: Tạo `PolicyServlet.java` điều hướng các route `/terms`, `/privacy`, `/refund-policy`, `/support`.
- [x] **Task 4.2**: Tạo 4 view JSP chính sách: `policy-terms.jsp`, `policy-privacy.jsp`, `policy-refund.jsp`, `policy-support.jsp` chuẩn `design.md`.
- [x] **Task 4.3**: Cập nhật liên kết chân trang `public-footer.jspf` và trang đăng ký `register.jsp` trỏ về các trang chính sách thay vì `/#`.
- [x] **Task 4.4**: Bổ sung các token CSS còn thiếu (`--info`, `--info-subtle`, `--info-border`, `--bg-alt`, `--radius-xs`) trong `web/assets/css/tokens.css`.
- [x] **Task 4.5**: Thay thế các chuỗi chèn trực tiếp vào `onclick` trong `student-list.jsp`, `guardian-list.jsp`, `enrollment-list.jsp`, `student-detail.jsp` bằng thuộc tính an toàn `data-*`.

---

## Task Group 5: Dedicated Teacher Dashboard

- [x] **Task 5.1**: Tạo `TeacherDashboardServlet.java` phục vụ route `/teacher/dashboard`.
- [x] **Task 5.2**: Xây dựng giao diện `web/WEB-INF/views/teacher/dashboard.jsp` hiển thị lịch dạy hôm nay, danh sách lớp phụ trách, thống kê số học viên và các lối tắt nhanh (Điểm danh, Nhập điểm, Nhật ký).
- [x] **Task 5.3**: Cập nhật `LandingServlet.java` loại bỏ route `/teacher/dashboard` để nhường quyền cho servlet chuyên dụng.

---

## Task Group 6: Modular Database Seeds & Easy Setup Runner

- [x] **Task 6.1**: Tạo thư mục `docs/database/seeds/` và phân chia 8 script SQL modular:
  - `01_schema_baseline.sql`
  - `02_roles_and_settings.sql`
  - `03_subjects_and_courses.sql`
  - `04_users_teachers_staff_students.sql`
  - `05_rooms_and_classes.sql`
  - `06_timetables_and_sessions.sql`
  - `07_enrollments_invoices_payments.sql`
  - `08_attendance_assessments_leads.sql`
- [x] **Task 6.2**: Viết script `docs/database/run_all_seeds.bat` và `docs/database/run_all_seeds.ps1` tự động chạy tuần tự toàn bộ các file seed với báo cáo tiến độ và màu sắc rõ ràng.
- [x] **Task 6.3**: Viết tài liệu hướng dẫn cực kỳ thân thiện cho người mới `docs/database/DATABASE_SETUP_GUIDE.md`.

---

## Task Group 7: Compilation, Test Verification & Git Commit

- [x] **Task 7.1**: Chạy biên dịch toàn bộ mã Java và kiểm tra 149 Unit Test.
- [x] **Task 7.2**: Chạy kiểm tra xác minh JSP và HTTP bằng scripts sẵn có.
- [x] **Task 7.3**: Thực hiện Git Commit và Push lên `main` theo quy tắc dự án.

---

## Task Group 8: Dashboard Layout Fix & Lazy Initialization Resolution (FR-COMP-021, FR-COMP-022)

- [x] **Task 8.1**: Cập nhật `AssessmentRepository.findClassesByTeacher` dùng `JOIN FETCH c.course cr LEFT JOIN FETCH cr.subject LEFT JOIN FETCH c.room` để triệt tiêu lỗi `LazyInitializationException` gây trắng trang `/teacher/dashboard`.
- [x] **Task 8.2**: Bổ sung selector fallback `.dashboard-container`, `.dashboard-main`, `.dashboard-content` trong `web/assets/css/admin.css`.
- [x] **Task 8.3**: Chuẩn hóa `web/WEB-INF/views/admin/dashboard.jsp` và `web/WEB-INF/views/admin/reports.jsp` sang cấu trúc chuẩn `<div class="admin-layout">`, `<div class="admin-main">`, `<main class="admin-content">` và đặt `internalShell=true`.
- [x] **Task 8.4**: Chuẩn hóa `web/WEB-INF/views/staff/lead-list.jsp` và `web/WEB-INF/views/staff/lead-detail.jsp` sang cấu trúc chuẩn `<div class="admin-layout">`, `<div class="admin-main">`, `<main class="admin-content">` và đặt `internalShell=true`.
- [x] **Task 8.5**: Kiểm thử trực tiếp bằng HTTP request tới các endpoint `/admin/dashboard`, `/teacher/dashboard`, `/student/dashboard`, `/parent/dashboard`, `/staff/leads` bảo đảm trả về Status 200 và giao diện hoàn chỉnh.

---

## Task Group 9: Comprehensive Real Data Seeding, Menu Deduplication & UI Fixes (FR-COMP-023 to FR-COMP-027)

- [x] **Task 9.1**: Sửa toàn bộ lỗi cú pháp trong các file seed CSDL (`04`, `06`, `07`, `08`) và script `run_all_seeds.ps1`:
  - `04`: Sửa lỗi cột `notes` và `created_at` trong `dbo.StudentGuardians`.
  - `06`: Đánh dấu các ca học quá khứ (đến 23/10/2026) là `COMPLETED`.
  - `07`: Thêm `SET QUOTED_IDENTIFIER ON; SET ANSI_NULLS ON;` cho bảng có computed columns; đảm bảo `student.nam` có ghi danh và học phí.
  - `08`: Sửa tên cột `dbo.TeachingJournals`, cú pháp `max_score` trong `dbo.Assessments`, chuẩn hóa trạng thái `Leads` (`CONSULTING`, `NEW`, `ENROLLED`).
  - `run_all_seeds.ps1`: Sửa lỗi encoding UTF-8 / cú pháp ngoặc nhọn để chạy mượt mà 100%.
- [x] **Task 9.2**: Chạy nạp lại dữ liệu toàn bộ CSDL và kiểm tra số lượng bản ghi (15 học viên, 22 ghi danh, đầy đủ điểm danh, bài kiểm tra, phễu lead phong phú).
- [x] **Task 9.3**: Xây dựng `StaffDashboardServlet.java` (`/staff/dashboard`) và `web/WEB-INF/views/staff/dashboard.jsp` cung cấp Dashboard Tuyển sinh & Vận hành chuyên dụng cho nhân viên; cập nhật `UserPrincipalDTO.getDefaultDashboardUrl()`.
- [x] **Task 9.4**: Bổ sung route `/parent/progress` trong `ParentPortalServlet.java` hiển thị chi tiết tiến độ học tập của con; tối ưu `sidebar.jspf` loại bỏ 100% mục menu trùng lặp URL với Bảng điều khiển (trên cả 4 role Staff, Parent, Student, Teacher).
- [x] **Task 9.5**: Cập nhật logic hiển thị trạng thái ca học trong `admin/timetable.jsp` và `student/schedule.jsp` theo mốc thời gian thực (ca quá khứ không hiển thị "Sắp diễn ra").
- [x] **Task 9.6**: Khắc phục lỗi tràn và khuất cột trong `web/WEB-INF/views/staff/student-list.jsp`: cấu hình `overflow-x: auto` trên `.table-responsive` và min-width cho `.data-table`.
- [x] **Task 9.7**: Bổ sung nút / luồng "Nhận phụ trách" (Self-assign) và hiển thị phụ trách rõ ràng trên `lead-list.jsp`.
- [x] **Task 9.8**: Biên dịch, kiểm tra HTTP và xác minh không mở trình duyệt, commit và push lên `main`.
