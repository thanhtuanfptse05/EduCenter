# Data Model: feat-academic-programs

**Feature:** `feat-academic-programs` | **Module:** Academic (M04) | **Use Case:** UC11, ADM-04, ADM-05

---

## 1. Entities Overview

### 1.1. Subject Entity (`Subjects` Table)
| Field | Type | Constraints | Description |
|---|---|---|---|
| `id` | `Long` | Primary Key, Identity | Mã định danh môn học |
| `code` | `String(50)` | Not Null, Unique, Trimmed | Mã môn học (ví dụ: `MATH`, `PHYS`, `CHEM`, `ENG`) |
| `name` | `String(100)` | Not Null | Tên hiển thị môn học (ví dụ: "Toán học", "Vật lý") |
| `description` | `String(500)` | Nullable | Mô tả chi tiết mục tiêu môn học |
| `status` | `String(20)` | Not Null, Default 'ACTIVE' | Trạng thái môn (`ACTIVE`, `INACTIVE`) |
| `createdAt` | `LocalDateTime` | Not Null | Thời điểm tạo bản ghi |

### 1.2. Course Entity (`Courses` Table)
| Field | Type | Constraints | Description |
|---|---|---|---|
| `id` | `Long` | Primary Key, Identity | Mã định danh khóa học |
| `subject` | `Subject` | ManyToOne, Not Null | Môn học trực thuộc |
| `code` | `String(50)` | Not Null, Unique, Trimmed | Mã khóa học duy nhất (ví dụ: `MATH-10-PREP`) |
| `name` | `String(200)` | Not Null | Tên khóa học đầy đủ |
| `gradeLevel` | `Integer` | Not Null, 6–12 | Khối lớp (6 đến 12) |
| `targetExam` | `String(100)` | Nullable | Mục tiêu đào tạo / Kỳ thi hướng tới |
| `fee` | `BigDecimal(18,2)` | Not Null, >= 0 | Học phí niêm yết (VND) |
| `durationWeeks` | `Integer` | Not Null, > 0 | Thời lượng khóa học tính theo tuần (mặc định 12) |
| `totalSessions` | `Integer` | Not Null, > 0 | Tổng số buổi học trong khóa (mặc định 24) |
| `maxCapacity` | `Integer` | Not Null, > 0 | Sĩ số học sinh tối đa khuyến nghị mỗi lớp (mặc định 15) |
| `description` | `String` | Nullable, NVARCHAR(MAX) | Đề cương, mục tiêu và mô tả chi tiết khóa học |
| `imageUrl` | `String(500)` | Nullable | Đường dẫn ảnh đại diện khóa học |
| `isFeatured` | `Boolean` | Not Null, Default false | Đánh dấu khóa học nổi bật trên trang chủ/catalog |
| `status` | `String(20)` | Not Null, Default 'OPEN' | Trạng thái tuyển sinh (`OPEN`, `CLOSED`, `ARCHIVED`) |
| `createdAt` | `LocalDateTime` | Not Null | Thời điểm tạo |
| `updatedAt` | `LocalDateTime` | Not Null | Thời điểm cập nhật gần nhất |

---

## 2. Data Transfer Objects (DTOs)

### 2.1. `CourseAdminViewDTO`
Hiển thị danh sách khóa học tại màn hình ADM-04:
- `id`: Long
- `code`: String
- `name`: String
- `subjectId`: Long
- `subjectName`: String
- `subjectCode`: String
- `gradeLevel`: Integer
- `targetExam`: String
- `fee`: BigDecimal
- `formattedFee`: String (định dạng VND: `3.500.000 đ`)
- `durationWeeks`: Integer
- `totalSessions`: Integer
- `maxCapacity`: Integer
- `isFeatured`: Boolean
- `status`: String (`OPEN`, `CLOSED`, `ARCHIVED`)
- `openClassCount`: Long (số lớp đang mở của khóa)
- `totalClassCount`: Long (tổng số lớp đã lập)
- `createdAt`: LocalDateTime
- `updatedAt`: LocalDateTime

### 2.2. `CourseAdminStatsDTO`
Chứa số liệu thống kê KPI tại dashboard ADM-04:
- `totalCourses`: long
- `openCourses`: long
- `closedCourses`: long
- `archivedCourses`: long
- `totalSubjects`: long
- `activeSubjects`: long

### 2.3. `CourseFormDTO`
Dùng để nhận dữ liệu từ form thêm/sửa khóa học và validate:
- `id`: Long (null khi tạo mới)
- `subjectId`: Long (bắt buộc)
- `code`: String (bắt buộc, 3–50 ký tự, chữ hoa số và gạch ngang)
- `name`: String (bắt buộc, 5–200 ký tự)
- `gradeLevel`: Integer (bắt buộc, từ 6 đến 12)
- `targetExam`: String (tối đa 100 ký tự)
- `fee`: BigDecimal (bắt buộc, >= 0)
- `durationWeeks`: Integer (bắt buộc, 1–52)
- `totalSessions`: Integer (bắt buộc, 1–150)
- `maxCapacity`: Integer (bắt buộc, 5–50)
- `description`: String (tối đa 4000 ký tự)
- `imageUrl`: String (URL ảnh hợp lệ hoặc để trống)
- `isFeatured`: boolean
- `status`: String (`OPEN`, `CLOSED`, `ARCHIVED`)

### 2.4. `SubjectAdminViewDTO`
Hiển thị danh sách môn học tại màn hình ADM-05:
- `id`: Long
- `code`: String
- `name`: String
- `description`: String
- `status`: String (`ACTIVE`, `INACTIVE`)
- `totalCourses`: long (tổng số khóa học thuộc môn)
- `openCourses`: long (số khóa học đang OPEN)
- `createdAt`: LocalDateTime

### 2.5. `SubjectFormDTO`
Dùng để nhận dữ liệu từ form thêm/sửa môn học:
- `id`: Long (null khi tạo mới)
- `code`: String (bắt buộc, 2–20 ký tự, viết hoa)
- `name`: String (bắt buộc, 2–100 ký tự)
- `description`: String (tối đa 500 ký tự)
- `status`: String (`ACTIVE`, `INACTIVE`)

---

## 3. Database Schema Constraints & Business Rules Validation
1. **Mã môn học duy nhất:** `UPPER(TRIM(Subject.code))` là duy nhất trên toàn hệ thống.
2. **Mã khóa học duy nhất:** `UPPER(TRIM(Course.code))` là duy nhất trên toàn hệ thống.
3. **Môn học phải ACTIVE khi gán cho khóa học:** Khi tạo hoặc mở khóa học, môn học tương ứng bắt buộc phải có `status = 'ACTIVE'`.
4. **Bảo toàn khóa học khi khóa môn học:** Khi chuyển trạng thái môn học sang `INACTIVE`, nếu có ít nhất 1 khóa học đang ở trạng thái `OPEN`, hệ thống từ chối và yêu cầu đóng các khóa học trước (BR16).
5. **Ghi nhật ký thay đổi học phí (BR18):** Khi sửa học phí (`fee`) của khóa học đã tồn tại, tự động ghi 1 dòng `AuditLog` với `action = 'UPDATE_COURSE_FEE'`.
