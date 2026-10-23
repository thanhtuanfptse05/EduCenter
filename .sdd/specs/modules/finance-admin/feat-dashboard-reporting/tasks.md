# Tasks: Dashboard & Báo cáo Thống kê Điều hành (feat-dashboard-reporting)

## Phase 1: DTOs & Data Contracts
- [x] Task 1.1: Tạo `MonthlyRevenueItemDTO`, `LeadSourceStatDTO`, `AdminDashboardDTO`.
- [x] Task 1.2: Tạo `ReportFilterDTO`, `DetailedReportDTO`.

## Phase 2: Repository Layer
- [x] Task 2.1: Tạo `ReportRepository.java` trong `com.educenter.repository` thực thi các truy vấn aggregation (SUM, COUNT, AVG, MIN, MAX).

## Phase 3: Service Layer & Business Logic
- [x] Task 3.1: Định nghĩa interface `ReportService.java`.
- [x] Task 3.2: Triển khai `ReportServiceImpl.java` trong `com.educenter.service`.

## Phase 4: Unit Testing
- [x] Task 4.1: Viết `ReportServiceTest.java` (JUnit 5) kiểm tra toàn bộ chỉ số KPI, aggregates, và xử lý dữ liệu trống.

## Phase 5: Controller & Refactoring
- [x] Task 5.1: Loại bỏ mapping `"/admin/dashboard"` khỏi `LandingServlet.java`.
- [x] Task 5.2: Tạo `AdminDashboardServlet.java` map `{"/admin/dashboard", "/admin/reports"}`.

## Phase 6: JSP Views (Chuẩn Design System design.md)
- [x] Task 6.1: Tạo `web/WEB-INF/views/admin/dashboard.jsp` (ADM-01) với biểu đồ trực quan.
- [x] Task 6.2: Tạo `web/WEB-INF/views/admin/reports.jsp` (ADM-16) với bộ lọc thời gian và bảng tổng hợp.
- [x] Task 6.3: Cập nhật sidebar `sidebar.jspf` kích hoạt menu Báo cáo.

## Phase 7: Verification & Push to Main
- [x] Task 7.1: Chạy `scripts\verify.ps1` kiểm tra compile và pass 100% test suites.
- [x] Task 7.2: Commit và push lên nhánh `main`.
