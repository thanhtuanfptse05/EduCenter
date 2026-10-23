# Implementation Plan: Dashboard & Báo cáo Thống kê Điều hành (feat-dashboard-reporting)

**Feature:** `feat-dashboard-reporting` | **Module:** M11 Reporting & Analytics | **Screen IDs:** ADM-01, ADM-16  
**Status:** In Progress | **Owner:** Member 03  

---

## 1. Mục tiêu & Phạm vi
- Màn hình `/admin/dashboard` (ADM-01): Dashboard điều hành trung tâm dành cho Ban Giám đốc và Quản trị viên. Thẻ KPI tài chính (doanh thu, công nợ), học vụ (học viên đang học, lớp đang mở, tỷ lệ chuyên cần) và tuyển sinh (leads, tỷ lệ chuyển đổi). Biểu đồ trực quan doanh thu 6 tháng và nguồn tuyển sinh. Bảng giao dịch & ghi danh gần đây.
- Màn hình `/admin/reports` (ADM-16): Báo cáo thống kê chuyên sâu với bộ lọc khoảng thời gian tùy chọn. Tổng hợp 3 phân hệ: Tài chính học phí, Phễu tuyển sinh & Nguồn lead, Thống kê chuyên cần & Học vụ. Áp dụng đầy đủ 5 hàm thống kê SQL chuẩn: `SUM`, `COUNT`, `AVG`, `MIN`, `MAX`.
- Tuân thủ 100% Design System: Default Light mode, 100% Lucide SVG outline icons, biểu đồ SVG/Canvas Vanilla JS nội bộ (không CDN ngoài), không hardcode mock data.

---

## 2. Thiết kế Kiến trúc & Phân tầng

### 2.1 DTOs Layer
- `AdminDashboardDTO.java`: KPI tổng quan, biểu đồ doanh thu tháng, phân bố nguồn lead, danh sách thanh toán & ghi danh gần đây.
- `MonthlyRevenueItemDTO.java`: Doanh thu từng tháng (tháng, năm, tổng thu, số giao dịch).
- `LeadSourceStatDTO.java`: Thống kê lead theo nguồn (nguồn, tổng lead, đã ghi danh, tỷ lệ chuyển đổi).
- `ReportFilterDTO.java`: Khoảng thời gian lọc (`startDate`, `endDate`), loại báo cáo.
- `DetailedReportDTO.java`:
  - Tài chính: Tổng thu, tổng nợ, min/max/avg học phí khóa học, danh thu theo phương thức thanh toán.
  - Tuyển sinh: Phễu chuyển đổi lead, tỷ lệ thành công.
  - Học vụ: Tỷ lệ chuyên cần (có mặt, muộn, vắng phép, không phép), sĩ số min/max/avg các lớp học, phổ điểm thi.

### 2.2 Repository Layer
- `ReportRepository.java`:
  - `getDashboardKPIs(EntityManager)`: Tính các chỉ số chính xác từ DB.
  - `getMonthlyRevenue(EntityManager, int months)`: Lấy doanh thu theo từng tháng.
  - `getLeadSourceStats(EntityManager)`: Thống kê nguồn khách hàng.
  - `getRecentPayments(EntityManager, int limit)`: 5 giao dịch thanh toán mới nhất.
  - `getRecentEnrollments(EntityManager, int limit)`: 5 lượt ghi danh mới nhất.
  - `getDetailedReport(EntityManager, LocalDate fromDate, LocalDate toDate)`: Tính toán tổng hợp đầy đủ các aggregates SUM, COUNT, AVG, MIN, MAX trong kỳ báo cáo.

### 2.3 Service Layer
- `ReportService.java` & `ReportServiceImpl.java`:
  - `getAdminDashboardData()`: Tổng hợp dữ liệu cho ADM-01.
  - `getDetailedReport(ReportFilterDTO filter)`: Tính toán báo cáo chi tiết cho ADM-16.

### 2.4 Unit Testing
- `ReportServiceTest.java` (JUnit 5): Kiểm tra tính toán KPI, doanh thu, tỷ lệ chuyên cần, xử lý trường hợp chưa có dữ liệu (không crash hoặc chia cho 0).

### 2.5 Controller Layer
- `AdminDashboardServlet.java`:
  - Map urlPatterns: `{"/admin/dashboard", "/admin/reports"}`.
  - Phân quyền: ADMIN only.
- Tách bỏ `"/admin/dashboard"` khỏi `LandingServlet.java`.

### 2.6 View Layer (JSP)
- `web/WEB-INF/views/admin/dashboard.jsp` (ADM-01).
- `web/WEB-INF/views/admin/reports.jsp` (ADM-16).
- Biểu đồ trực quan SVG/Canvas Vanilla JS sắc nét, tương thích Light/Dark mode.
