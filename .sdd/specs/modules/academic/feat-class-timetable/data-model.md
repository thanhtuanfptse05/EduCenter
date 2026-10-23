# Data Model: Lớp học, Phòng học và Lịch học (feat-class-timetable)

## 1. Entities & Schema Mapping

### 1.1. Room (`dbo.Rooms`)
* **Table:** `dbo.Rooms`
* **JPA Entity:** `com.educenter.entity.Room`
* **Fields:**
  * `id` (BIGINT, PK, Identity)
  * `code` (VARCHAR(50), Unique, Not Null) — Mã phòng (VD: `P101`, `LAB02`, `ONLINE-01`)
  * `name` (NVARCHAR(100), Not Null) — Tên phòng học (VD: `Phòng học Lý thuyết 101`)
  * `capacity` (INT, Not Null, > 0) — Sức chứa tối đa của phòng học
  * `status` (VARCHAR(20), Not Null) — Enum: `AVAILABLE`, `MAINTENANCE`
  * `createdAt` (DATETIME2(0), Not Null)

### 1.2. EduClass (`dbo.Classes`)
* **Table:** `dbo.Classes`
* **JPA Entity:** `com.educenter.entity.EduClass`
* **Fields:**
  * `id` (BIGINT, PK, Identity)
  * `course` (Course, FK `course_id`, Not Null) — Khóa học liên kết (khóa học phải ở trạng thái `OPEN`)
  * `teacher` (Teacher, FK `teacher_id`, Not Null) — Giáo viên phụ trách chính
  * `room` (Room, FK `room_id`, Nullable) — Phòng học mặc định của lớp
  * `code` (VARCHAR(50), Unique, Not Null) — Mã lớp duy nhất (VD: `MAT12-2026-01`)
  * `name` (NVARCHAR(200), Not Null) — Tên lớp học (VD: `Toán 12 - Luyện đề nâng cao T2-T4-T6`)
  * `capacity` (INT, Not Null, > 0) — Sĩ số tối đa của lớp (phải <= `room.capacity` nếu có gán phòng)
  * `startDate` (DATE, Not Null) — Ngày khai giảng
  * `endDate` (DATE, Not Null) — Ngày kết thúc (phải >= `startDate`)
  * `status` (VARCHAR(20), Not Null) — Trạng thái lớp: `PLANNING`, `OPEN`, `ONGOING`, `CLOSED`, `CANCELLED`
  * `version` (BIGINT, Not Null, Optimistic Locking `@Version`)
  * `createdAt` (DATETIME2(0), Not Null)
  * `updatedAt` (DATETIME2(0), Not Null)

### 1.3. ClassSession (`dbo.ClassSessions`)
* **Table:** `dbo.ClassSessions`
* **JPA Entity:** `com.educenter.entity.ClassSession`
* **Fields:**
  * `id` (BIGINT, PK, Identity)
  * `eduClass` (EduClass, FK `class_id`, Not Null) — Lớp học
  * `room` (Room, FK `room_id`, Not Null) — Phòng học cụ thể của buổi này
  * `teacher` (Teacher, FK `teacher_id`, Not Null) — Giáo viên thực dạy buổi này (hỗ trợ dạy thay)
  * `sessionDate` (DATE, Not Null) — Ngày diễn ra buổi học
  * `startAt` (TIME, Not Null) — Giờ bắt đầu (VD: 18:00)
  * `endAt` (TIME, Not Null) — Giờ kết thúc (VD: 20:00, phải > `startAt`)
  * `title` (NVARCHAR(255), Nullable) — Chủ đề / Tiêu đề buổi học (VD: `Buổi 1: Ôn tập Hàm số lũy thừa`)
  * `status` (VARCHAR(20), Not Null) — Trạng thái buổi học: `SCHEDULED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`, `RESCHEDULED`
  * `createdAt` (DATETIME2(0), Not Null)
  * `updatedAt` (DATETIME2(0), Not Null)

---

## 2. Business Rules & Validations

| Mã luật | Tên quy tắc | Mô tả chi tiết |
|---|---|---|
| **BR04** | Ràng buộc tạo lớp | Khóa học liên kết phải ở trạng thái `OPEN`. Sĩ số `capacity > 0`. Nếu có gán phòng thì `capacity <= room.capacity`. `endDate >= startDate`. Mã lớp không trùng. |
| **BR05** | Chặn trùng lịch giáo viên | Trong cùng ngày `sessionDate`, một giáo viên không thể dạy 2 buổi có khoảng thời gian `[startAt, endAt]` giao nhau. (Tiếp giáp `endAt == startAt` được phép). Chỉ xét các buổi ở trạng thái `SCHEDULED`, `IN_PROGRESS`, `COMPLETED`. |
| **BR06** | Chặn trùng lịch phòng học | Trong cùng ngày `sessionDate`, một phòng học không thể xếp 2 buổi học có khoảng thời gian `[startAt, endAt]` giao nhau. Chỉ xét các buổi ở trạng thái `SCHEDULED`, `IN_PROGRESS`, `COMPLETED`. Phòng ở trạng thái `MAINTENANCE` không được xếp buổi mới. |
| **BR19** | Đóng/Hủy lớp học an toàn | Khi lớp chuyển sang `CLOSED` hoặc `CANCELLED`, không được phép tạo/thêm buổi học mới và không nhận thêm ghi danh học viên. Lịch sử điểm danh và hóa đơn được giữ nguyên vẹn. |

---

## 3. Data Transfer Objects (DTOs)

1. `ClassAdminViewDTO`: Hiển thị danh sách lớp học quản trị (id, code, name, courseName, teacherName, roomName, capacity, enrolledCount, startDate, endDate, status).
2. `ClassAdminStatsDTO`: Thống kê KPI lớp học (tổng số lớp, đang mở tuyển sinh, đang diễn ra, đã kết thúc, tổng số phòng, phòng khả dụng).
3. `ClassFormDTO`: Dữ liệu submit form tạo/sửa lớp học.
4. `ClassFilterDTO`: Dữ liệu lọc và tìm kiếm lớp (keyword, courseId, status, page, pageSize).
5. `ClassDetailDTO`: Chi tiết lớp học, bao gồm danh sách các buổi học (`List<ClassSessionDTO>`), giáo viên, phòng, thông tin khóa học.
6. `ClassSessionDTO`: Dữ liệu buổi học cụ thể.
7. `ScheduleGeneratorDTO`: Tham số cấu hình sinh lịch tự động (classId, roomId, teacherId, daysOfWeek: [2,4,6], startTime, endTime, startDate, endDate hoặc totalSessions, excludeDates).
8. `RoomDTO` & `RoomFormDTO`: Quản lý danh mục phòng học.
9. `TimetableGridDTO`: Dữ liệu ma trận thời khóa biểu tuần theo ngày/giờ/phòng/lớp để hiển thị lịch trực quan.
