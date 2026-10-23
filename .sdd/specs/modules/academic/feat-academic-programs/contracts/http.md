# HTTP API & Web Contract: feat-academic-programs

**Feature:** `feat-academic-programs` | **Module:** Academic (M04) | **Use Case:** UC11, ADM-04, ADM-05

---

## 1. Endpoints Overview

| Method | Path | Role Required | Mô tả chức năng | Quy tắc PRG / Forward |
|---|---|---|---|---|
| `GET` | `/admin/courses` | `ADMIN` | Màn hình danh sách khóa học (ADM-04) kèm KPI và bộ lọc | Forward tới `admin/course-list.jsp` |
| `GET` | `/admin/courses/form` | `ADMIN` | Form thêm mới hoặc sửa khóa học (ADM-05) | Forward tới `admin/course-form.jsp` |
| `POST` | `/admin/courses/save` | `ADMIN` | Lưu khóa học (tạo mới hoặc cập nhật) | Redirect `/admin/courses` hoặc `/admin/courses/form?id={id}` kèm flash message |
| `POST` | `/admin/courses/status` | `ADMIN` | Cập nhật nhanh trạng thái (`OPEN`, `CLOSED`, `ARCHIVED`) | Redirect `/admin/courses` kèm flash message |
| `GET` | `/admin/subjects` | `ADMIN` | Màn hình quản lý danh mục môn học (ADM-05) | Forward tới `admin/subject-list.jsp` |
| `POST` | `/admin/subjects/save` | `ADMIN` | Thêm mới hoặc cập nhật môn học | Redirect `/admin/subjects` kèm flash message |
| `POST` | `/admin/subjects/status` | `ADMIN` | Chuyển đổi trạng thái môn học `ACTIVE`/`INACTIVE` | Redirect `/admin/subjects` kèm flash message |

---

## 2. Request / Response Contracts

### 2.1. GET `/admin/courses`
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

### 2.2. GET `/admin/courses/form`
- **Query Parameters:**
  - `id`: Long (tùy chọn; nếu có thì là chế độ chỉnh sửa; nếu thiếu thì là tạo mới)
- **Request Attributes:**
  - `courseForm`: `CourseFormDTO`
  - `subjects`: `List<Subject>` (danh sách môn học active để chọn)
  - `isEdit`: boolean

### 2.3. POST `/admin/courses/save`
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
- **Success:** Redirect `/admin/courses` với session flash message: `toastMessage = "Lưu khóa học thành công!"`, `toastType = "success"`.

### 2.4. POST `/admin/courses/status`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (bắt buộc)
  - `newStatus`: String (`OPEN`, `CLOSED`, `ARCHIVED`)
- **Success:** Redirect `/admin/courses` kèm flash toast.

### 2.5. GET `/admin/subjects`
- **Request Attributes:**
  - `subjects`: `List<SubjectAdminViewDTO>`
  - `stats`: Map/DTO thống kê số môn active, inactive, tổng khóa học

### 2.6. POST `/admin/subjects/save`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (tùy chọn)
  - `code`: String (bắt buộc)
  - `name`: String (bắt buộc)
  - `description`: String (tùy chọn)
  - `status`: String (`ACTIVE`, `INACTIVE`)
- **Success:** Redirect `/admin/subjects` với flash toast.

### 2.7. POST `/admin/subjects/status`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (bắt buộc)
  - `status`: String (`ACTIVE`, `INACTIVE`)
- **Business Rule Check (FR-006):** Nếu chuyển sang `INACTIVE` mà môn đang có khóa học `OPEN`, báo lỗi: `toastMessage = "Không thể ngừng môn học đang có khóa học mở tuyển sinh. Vui lòng đóng hoặc chuyển lưu trữ các khóa học trước!"`, `toastType = "error"`.
