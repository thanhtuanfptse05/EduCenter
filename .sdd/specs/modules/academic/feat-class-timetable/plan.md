# Implementation Plan: Lớp học, Phòng học và Lịch giảng dạy (feat-class-timetable)

## 1. Architecture & Design Approach
- Tuân thủ tuyệt đối mô hình chuẩn MVC của dự án:
  - **Entity:** `Room`, `EduClass` (bổ sung liên kết `Room`), `ClassSession`.
  - **Repository:** `RoomRepository`, `EduClassRepository`, `ClassSessionRepository`.
  - **Service:** `ClassTimetableService` & `ClassTimetableServiceImpl` xử lý trọn vẹn nghiệp vụ (BR04, BR05, BR06, BR19), quản lý transaction và audit logs.
  - **Controller (Servlets):** `ClassManagementServlet` (`/admin/classes*`), `RoomManagementServlet` (`/admin/rooms*`), `TimetableServlet` (`/admin/timetable`, `/staff/timetable`), `StaffClassInquiryServlet` (`/staff/classes*`).
  - **View:** JSP/JSTL tuân thủ `design.md`, 100% dữ liệu động, Lucide SVG outline icons, responsive, light mode mặc định.

## 2. Phases & Milestones
- **Phase 1: Entities, DTOs & Persistence Configuration**
  - Tạo `Room.java` trong `com.educenter.entity`.
  - Bổ sung quan hệ `Room room` vào `EduClass.java`.
  - Tạo `ClassSession.java` trong `com.educenter.entity`.
  - Đăng ký `Room` và `ClassSession` vào `src/java/META-INF/persistence.xml`.
  - Tạo bộ DTO: `ClassAdminViewDTO`, `ClassAdminStatsDTO`, `ClassFormDTO`, `ClassFilterDTO`, `ClassDetailDTO`, `ClassSessionDTO`, `ScheduleGeneratorDTO`, `RoomDTO`, `RoomFormDTO`, `TimetableGridDTO`.
- **Phase 2: Repositories**
  - Xây dựng `RoomRepository` (CRUD, findAvailable, count).
  - Xây dựng `EduClassRepository` (tìm kiếm phân trang, lọc theo khóa, đếm theo trạng thái, kiểm tra mã).
  - Xây dựng `ClassSessionRepository` (tìm theo lớp, kiểm tra xung đột phòng và giáo viên theo ngày và khung giờ).
- **Phase 3: Service Layer & Unit Tests**
  - Triển khai `ClassTimetableService`:
    - Tạo/sửa lớp học, kiểm tra điều kiện mở lớp BR04.
    - Thuật toán sinh lịch tự động định kỳ (FR-004), kiểm tra xung đột phòng và giáo viên (BR05, BR06).
    - Quản lý trạng thái lớp học (BR19).
    - Quản lý danh mục phòng học (FR-002).
    - Lấy ma trận thời khóa biểu tuần (FR-010).
  - Viết `ClassTimetableServiceTest` kiểm thử đầy đủ các kịch bản và business rules.
- **Phase 4: Controllers & View Layers (JSP + design.md)**
  - Viết các Servlet: `ClassManagementServlet`, `RoomManagementServlet`, `TimetableServlet`, `StaffClassInquiryServlet`.
  - Cập nhật phân quyền trong `AuthFilter.java` và navigation `sidebar.jspf`.
  - Xây dựng các trang JSP:
    - `web/WEB-INF/views/admin/class-list.jsp`: Danh sách lớp học, thẻ KPI, bộ lọc, pagination, badge trạng thái.
    - `web/WEB-INF/views/admin/class-form.jsp`: Form thêm/sửa lớp học chuẩn 2 cột với selector Khóa học, Giáo viên, Phòng học.
    - `web/WEB-INF/views/admin/class-detail.jsp`: Chi tiết lớp, danh sách các buổi học, modal sinh lịch tự động trực quan.
    - `web/WEB-INF/views/admin/room-list.jsp`: Quản lý danh mục phòng học (sức chứa, trạng thái).
    - `web/WEB-INF/views/admin/timetable.jsp`: Thời khóa biểu trực quan theo tuần.
    - `web/WEB-INF/views/staff/class-inquiry.jsp`: Màn hình tra cứu lớp học & sĩ số tuyển sinh cho Staff.
- **Phase 5: Verification, Quality Gates & Git Push**
  - Chạy `verify.ps1`, pass 100% tests.
  - Push lên nhánh `main`.
