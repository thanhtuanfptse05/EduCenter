# HTTP API / Servlet Contracts: feat-class-timetable

## 1. Endpoints Overview

| Method | Path | Role | Description |
|---|---|---|---|
| **GET** | `/admin/classes` | `ADMIN` | Danh sách lớp học, bộ lọc, phân trang, thống kê KPI |
| **GET** | `/admin/classes/create` | `ADMIN` | Form tạo mới lớp học (nạp sẵn danh sách Course, Teacher, Room) |
| **POST** | `/admin/classes/create` | `ADMIN` | Xử lý tạo mới lớp học (PRG, validation BR04) |
| **GET** | `/admin/classes/edit?id={id}` | `ADMIN` | Form chỉnh sửa lớp học |
| **POST** | `/admin/classes/edit` | `ADMIN` | Cập nhật thông tin lớp học |
| **GET** | `/admin/classes/detail?id={id}` | `ADMIN` | Màn hình chi tiết lớp học, danh sách buổi học, panel sinh lịch |
| **POST** | `/admin/classes/generate-schedule` | `ADMIN` | Sinh lịch tự động cho lớp học (kiểm tra xung đột BR05, BR06) |
| **POST** | `/admin/classes/status` | `ADMIN` | Thay đổi trạng thái lớp (`OPEN`, `ONGOING`, `CLOSED`, `CANCELLED` - BR19) |
| **GET** | `/admin/rooms` | `ADMIN` | Quản lý danh mục phòng học |
| **POST** | `/admin/rooms/create` | `ADMIN` | Thêm mới phòng học |
| **POST** | `/admin/rooms/edit` | `ADMIN` | Cập nhật thông tin / trạng thái phòng học (`AVAILABLE` / `MAINTENANCE`) |
| **GET** | `/admin/timetable` | `ADMIN` | Ma trận thời khóa biểu tuần trực quan theo phòng/lớp/giáo viên |
| **GET** | `/staff/classes` | `STAFF` | Tra cứu lớp học & sĩ số tuyển sinh (View-only) |
| **GET** | `/staff/classes/detail?id={id}` | `STAFF` | Xem chi tiết lớp học & lịch học (View-only) |
| **GET** | `/staff/timetable` | `STAFF` | Tra cứu thời khóa biểu tuần tuyển sinh (View-only) |

---

## 2. Request / Response Details

### 2.1. GET `/admin/classes`
- **Query Params:**
  - `keyword` (string, optional): Tìm kiếm theo mã hoặc tên lớp
  - `courseId` (long, optional): Lọc theo khóa học
  - `status` (string, optional): `ALL`, `PLANNING`, `OPEN`, `ONGOING`, `CLOSED`, `CANCELLED`
  - `page` (int, default 1)
- **Model Attributes:**
  - `classes`: `List<ClassAdminViewDTO>`
  - `stats`: `ClassAdminStatsDTO`
  - `courses`: `List<Course>` (cho dropdown lọc)
  - `currentPage`, `totalPages`, `totalItems`

### 2.2. POST `/admin/classes/generate-schedule`
- **Parameters:**
  - `classId` (long, required)
  - `roomId` (long, required)
  - `teacherId` (long, required)
  - `daysOfWeek` (string[], required, e.g. `["2", "4", "6"]` cho T2, T4, T6)
  - `startAt` (string, required, format `HH:mm`)
  - `endAt` (string, required, format `HH:mm`)
  - `totalSessions` (int, optional, lấy từ Course hoặc nhập tùy chọn)
  - `csrf_token` (string, required)
- **Outcome:**
  - Nếu thành công: Flash message `success: "Đã sinh thành công {n} buổi học cho lớp học!"`, chuyển hướng về `/admin/classes/detail?id={classId}`.
  - Nếu xung đột (BR05/BR06): Flash message `error: "Phát hiện xung đột lịch: [chi tiết xung đột]"`, chuyển hướng về form sinh lịch.

### 2.3. GET `/staff/classes` (Dành riêng cho Tư vấn tuyển sinh)
- **Chức năng:** Tra cứu lớp học để tư vấn học viên, kiểm tra lớp nào còn chỗ (`enrolled < capacity`), lịch học nào phù hợp với học sinh.
- **Model Attributes:**
  - `classes`: `List<ClassAdminViewDTO>` (chứa `capacity`, `enrolledCount`, `remainingSlots`)
  - `courses`: Danh mục khóa học để lọc
  - Hoàn toàn KHÔNG hiển thị các action sửa, xóa, đóng lớp, sinh lịch.
