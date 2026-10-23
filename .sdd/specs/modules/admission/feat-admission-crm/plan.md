# Implementation Plan: Quản lý Lead & CRM Tuyển sinh (feat-admission-crm)

**Feature:** `feat-admission-crm` | **Module:** M03 Admission & CRM | **Screen IDs:** ADM-02, ADM-03  
**Status:** In Progress | **Owner:** Member 02  

---

## 1. Mục tiêu & Phạm vi
- Màn hình `/staff/leads` (ADM-02): Quản lý tiếp nhận Lead từ Website, Hotline, Trực tiếp. Bộ lọc đa tiêu chí (keyword, trạng thái, nguồn, khối lớp, người phụ trách), KPI tổng quan, phân trang, giao diện chuẩn Design System `design.md`.
- Màn hình `/staff/leads/detail` (ADM-03): Xem chi tiết nhu cầu khách hàng, lịch sử trao đổi tư vấn (Consultations timeline), cập nhật tiến trình tư vấn (`NEW` -> `CONTACTED` -> `CONSULTING` -> `ENROLLED` / `LOST`), phân công nhân viên phụ trách, liên kết chuyển đổi sang học viên/ghi danh.

---

## 2. Thiết kế Kiến trúc & Phân tầng

### 2.1 Entity & Database
- `Lead.java`: Sử dụng bảng `dbo.Leads` hiện có.
- `Consultation.java`: Tạo JPA entity ánh xạ bảng `dbo.Consultations` (`lead_id`, `staff_id`, `notes`, `contacted_at`, `next_appointment`).
- Đăng ký `Consultation.java` vào `persistence.xml`.

### 2.2 Data Transfer Objects (DTOs)
- `LeadFilterDTO.java`: Tiêu chí lọc tìm kiếm, phân trang.
- `LeadListItemDTO.java`: Dữ liệu hiển thị từng dòng Lead trên bảng danh sách.
- `LeadDetailDTO.java`: Thông tin chi tiết Lead, danh sách lịch sử tư vấn (`ConsultationItemDTO`), danh sách staff để phân công.
- `LeadCreateFormDTO.java`: Form nhập Lead mới từ hotline/trực tiếp.
- `ConsultationFormDTO.java`: Form thêm ghi chú tư vấn, hẹn ngày liên hệ tiếp theo.

### 2.3 Repository Layer
- `LeadRepository.java`:
  - `findLeads(EntityManager, LeadFilterDTO)`: Truy vấn danh sách Lead theo bộ lọc & phân trang.
  - `countLeads(EntityManager, LeadFilterDTO)`: Đếm tổng số kết quả.
  - `getLeadStats(EntityManager)`: Thống kê số lượng theo từng nhóm trạng thái (Tất cả, Mới, Đang tư vấn, Đã ghi danh, Thất bại).
  - `findConsultationsByLeadId(EntityManager, Long leadId)`: Lấy timeline các lần tư vấn.
  - `saveConsultation(EntityManager, Consultation c)`: Lưu nhật ký tư vấn.
  - `findStaffUsers(EntityManager)`: Lấy danh sách nhân viên để gán phụ trách.

### 2.4 Service Layer & Business Rules
- `LeadService.java` & `LeadServiceImpl.java`:
  - `getLeadList(LeadFilterDTO)`: Xử lý dữ liệu hiển thị bảng & phân trang.
  - `getLeadDetail(Long leadId)`: Kiểm tra tồn tại và quyền truy cập (BR02).
  - `createLead(LeadCreateFormDTO, UserPrincipalDTO)`: Validate họ tên, định dạng SĐT Việt Nam (10 số).
  - `updateStatus(Long leadId, String newStatus, String notes, Long assignedToId, UserPrincipalDTO actor)`: Kiểm tra chuyển đổi trạng thái hợp lệ, cập nhật timestamp, audit log.
  - `addConsultationNote(ConsultationFormDTO, UserPrincipalDTO staff)`: Ghi nhận lịch sử tư vấn, tự động cập nhật trạng thái nếu đang `NEW`.

### 2.5 Unit Testing
- `LeadServiceTest.java` (JUnit 5): Kiểm tra tạo Lead, validation số điện thoại, cập nhật trạng thái, ghi chú tư vấn, phân công phụ trách.

### 2.6 Controller Layer (Servlet)
- `StaffLeadServlet.java`:
  - Map urlPatterns: `/staff/leads`, `/staff/leads/detail`, `/staff/leads/create`, `/staff/leads/status`, `/staff/leads/consultation`.
  - Phân quyền: STAFF và ADMIN.
- Tách bỏ pattern `"/staff/leads"` khỏi `LandingServlet.java` để tránh xung đột servlet mapping.

### 2.7 View Layer (JSP & Design System)
- `web/WEB-INF/views/staff/lead-list.jsp` (ADM-02): Thẻ KPI động, bộ lọc, bảng danh sách Lead, modal thêm Lead mới, phân trang, Empty state chuyên nghiệp.
- `web/WEB-INF/views/staff/lead-detail.jsp` (ADM-03): Card thông tin Lead, phân công tư vấn, cập nhật trạng thái, timeline tư vấn, form thêm ghi chú, nút chuyển đổi ghi danh.
- 100% Lucide SVG outline icons, biến CSS token (`--bg`, `--surface`, `--primary`, `--text`...), Default Light mode.
