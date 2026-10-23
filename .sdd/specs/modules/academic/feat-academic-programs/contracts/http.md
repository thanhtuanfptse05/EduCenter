# HTTP API & Web Contract: feat-academic-programs

**Feature:** `feat-academic-programs` | **Module:** Academic (M04) | **Use Case:** UC11, ADM-04, ADM-05

---

## 1. Endpoints Overview

| Method | Path | Role Required | Mô tả chức năng | Quy tắc PRG / Forward |
|---|---|---|---|---|
| `GET` | `/staff/courses` | `STAFF`, `ADMIN` | Màn hình danh sách khóa học (ADM-04) kèm KPI và bộ lọc | Forward tới `staff/course-list.jsp` |
| `GET` | `/staff/courses/form` | `STAFF`, `ADMIN` | Form thêm mới hoặc sửa khóa học (ADM-05) | Forward tới `staff/course-form.jsp` |
| `POST` | `/staff/courses/save` | `STAFF`, `ADMIN` | Lưu khóa học (tạo mới hoặc cập nhật) | Redirect `/staff/courses` hoặc `/staff/courses/form?id={id}` kèm flash message |
| `POST` | `/staff/courses/status` | `STAFF`, `ADMIN` | Cập nhật nhanh trạng thái (`OPEN`, `CLOSED`, `ARCHIVED`) | Redirect `/staff/courses` kèm flash message |
| `GET` | `/staff/subjects` | `STAFF`, `ADMIN` | Màn hình quản lý danh mục môn học (ADM-05) | Forward tới `staff/subject-list.jsp` |
| `POST` | `/staff/subjects/save` | `STAFF`, `ADMIN` | Thêm mới hoặc cập nhật môn học | Redirect `/staff/subjects` kèm flash message |
| `POST` | `/staff/subjects/status` | `STAFF`, `ADMIN` | Chuyển đổi trạng thái môn học `ACTIVE`/`INACTIVE` | Redirect `/staff/subjects` kèm flash message |

---

## 2. Request / Response Contracts

### 2.1. GET `/staff/courses`
- **Query Parameters:**
  - `q`: String (từ khóa tìm theo mã hoặc tên khóa học)
  - `subjectId`: Long (lọc theo môn học)
  - `grade`: Integer (lọc theo khối 6–12)
  - `status`: String (`ALL`, `OPEN`, `CLOSED`, `ARCHIVED`, mặc định `ALL`)
  - `sort`: String (`newest`, `fee_asc`, `fee_desc`, `name_asc`)
  - `page`: Integer (trang hiện tại, 1-based, mặc định 1)
- **Request Attributes cung cấp cho JSP:**
  - `courses`: `List<CourseAdminViewDTO>`
  - `stats`: `CourseAdminStatsDTO` (KPI tổng số, đang mở, tạm đóng, lưu trữ, số môn)
  - `subjects`: `List<Subject>` (danh sách môn học để populate dropdown filter)
  - `currentPage`: int
  - `totalPages`: int
  - `totalItems`: long
  - `pageSize`: int
  - `filterQ`, `filterSubjectId`, `filterGrade`, `filterStatus`, `filterSort`: giữ trạng thái bộ lọc

### 2.2. GET `/staff/courses/form`
- **Query Parameters:**
  - `id`: Long (tùy chọn; nếu có thì là chế độ chỉnh sửa; nếu thiếu thì là tạo mới)
- **Request Attributes:**
  - `courseForm`: `CourseFormDTO`
  - `subjects`: `List<Subject>` (danh sách môn học active để chọn)
  - `isEdit`: boolean

### 2.3. POST `/staff/courses/save`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (tùy chọn)
  - `subjectId`: Long (bắt buộc)
  - `code`: String (bắt buộc)
  - `name`: String (bắt buộc)
  - `gradeLevel`: int (bắt buộc, 6–12)
  - `targetExam`: String (tùy chọn)
  - `fee`: BigDecimal (bắt buộc, >= 0)
  - `durationWeeks`: int (bắt buộc, > 0)
  - `totalSessions`: int (bắt buộc, > 0)
  - `maxCapacity`: int (bắt buộc, > 0)
  - `description`: String (tùy chọn)
  - `imageUrl`: String (tùy chọn)
  - `isFeatured`: boolean ("on" hoặc "true")
  - `status`: String (`OPEN`, `CLOSED`, `ARCHIVED`)
- **Validation Failure:** Lưu `courseForm` và `fieldErrors` vào session hoặc forward lại form với HTTP 200, hiển thị lỗi inline.
- **Success:** Redirect `/staff/courses` với session flash message: `toastMessage = "Lưu khóa học thành công!"`, `toastType = "success"`.

### 2.4. POST `/staff/courses/status`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (bắt buộc)
  - `newStatus`: String (`OPEN`, `CLOSED`, `ARCHIVED`)
- **Success:** Redirect `/staff/courses` kèm flash toast.

### 2.5. GET `/staff/subjects`
- **Request Attributes:**
  - `subjects`: `List<SubjectAdminViewDTO>`
  - `stats`: Map/DTO thống kê số môn active, inactive, tổng khóa học

### 2.6. POST `/staff/subjects/save`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (tùy chọn)
  - `code`: String (bắt buộc)
  - `name`: String (bắt buộc)
  - `description`: String (tùy chọn)
  - `status`: String (`ACTIVE`, `INACTIVE`)
- **Success:** Redirect `/staff/subjects` với flash toast.

### 2.7. POST `/staff/subjects/status`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (bắt buộc)
  - `status`: String (`ACTIVE`, `INACTIVE`)
- **Business Rule Check (FR-006):** Nếu chuyển sang `INACTIVE` mà môn đang có khóa học `OPEN`, báo lỗi: `toastMessage = "Không thể ngừng môn học đang có khóa học mở tuyển sinh. Vui lòng đóng hoặc chuyển lưu trữ các khóa học trước!"`, `toastType = "error"`.
