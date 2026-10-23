# Data Model: feat-teacher-management

**Feature:** `feat-teacher-management` | **Module:** Academic (M04 / M05 / M12) | **Use Case:** UC12, ADM-09

---

## 1. Entity Overview (`Teachers` Table)

| Field | Type | Constraints | Description |
|---|---|---|---|
| `id` | `Long` | Primary Key, Identity | Mã định danh giáo viên |
| `user_id` | `Long` (`User`) | Foreign Key, Not Null, Unique | Tài khoản đăng nhập hệ thống (vai trò TEACHER) |
| `full_name` | `String(150)` | Not Null | Họ và tên giáo viên |
| `phone` | `String(20)` | Nullable | Số điện thoại liên hệ |
| `email` | `String(255)` | Nullable | Email liên hệ công việc |
| `specialization` | `String(255)` | Nullable | Chuyên môn giảng dạy (ví dụ: "Toán THCS & THPT", "Vật lý Chuyên") |
| `degree` | `String(100)` | Nullable | Học vị / Bằng cấp cao nhất (ví dụ: "Thạc sĩ Sư phạm Toán", "Cử nhân Sư phạm Vật lý") |
| `bio` | `String` | Nullable, NVARCHAR(MAX) | Giới thiệu tóm tắt kinh nghiệm và phương pháp giảng dạy |
| `hourly_rate` | `BigDecimal(18,2)` | Not Null, Default 0 | Thù lao giảng dạy định mức (tham chiếu nội bộ) |
| `status` | `String(20)` | Not Null, Default 'ACTIVE' | Trạng thái: `ACTIVE`, `ON_LEAVE`, `INACTIVE` |
| `created_at` | `LocalDateTime` | Not Null | Thời điểm tạo hồ sơ |
| `updated_at` | `LocalDateTime` | Not Null | Thời điểm cập nhật hồ sơ gần nhất |

---

## 2. Data Transfer Objects (DTOs)

### 2.1. `TeacherAdminViewDTO`
Dùng hiển thị danh sách giáo viên tại màn hình ADM-09:
- `id`: Long
- `userId`: Long
- `userEmail`: String (email tài khoản đăng nhập)
- `fullName`: String
- `phone`: String
- `email`: String
- `avatarUrl`: String
- `specialization`: String
- `degree`: String
- `hourlyRate`: BigDecimal
- `formattedHourlyRate`: String (`#,### đ/h`)
- `status`: String (`ACTIVE`, `ON_LEAVE`, `INACTIVE`)
- `activeClassesCount`: long (số lớp đang phụ trách có status 'OPEN')
- `totalClassesCount`: long (tổng số lớp từng dạy)
- `createdAt`: LocalDateTime

### 2.2. `TeacherAdminStatsDTO`
Chứa các chỉ số KPI trên dashboard quản lý giáo viên:
- `totalTeachers`: long
- `activeTeachers`: long
- `onLeaveTeachers`: long
- `inactiveTeachers`: long
- `totalActiveClasses`: long

### 2.3. `TeacherFormDTO`
Dùng để nhận dữ liệu submit form tạo/sửa hồ sơ giáo viên:
- `id`: Long (null khi tạo mới)
- `userId`: Long (bắt buộc khi tạo mới)
- `fullName`: String (bắt buộc, 2–150 ký tự)
- `phone`: String (tùy chọn, đúng định dạng SĐT Việt Nam nếu có)
- `email`: String (tùy chọn, đúng định dạng email nếu có)
- `specialization`: String (tối đa 255 ký tự)
- `degree`: String (tối đa 100 ký tự)
- `bio`: String (tối đa 4000 ký tự)
- `hourlyRate`: BigDecimal (>= 0)
- `status`: String (`ACTIVE`, `ON_LEAVE`, `INACTIVE`)

### 2.4. `AvailableTeacherUserDTO`
Danh sách tài khoản User có role `TEACHER` và chưa liên kết với hồ sơ giáo viên nào:
- `userId`: Long
- `email`: String
- `fullName`: String
- `phone`: String

### 2.5. `TeacherFilterDTO`
Chứa điều kiện tìm kiếm và phân trang:
- `keyword`: String (tìm theo tên, email, phone, specialization)
- `specialization`: String
- `status`: String (`ALL`, `ACTIVE`, `ON_LEAVE`, `INACTIVE`)
- `page`: int (1-based)
- `pageSize`: int (mặc định 10)
- `sort`: String (`name_asc`, `newest`, `classes_desc`)
