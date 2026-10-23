# HTTP API & Web Contract: feat-teacher-management

**Feature:** `feat-teacher-management` | **Module:** Academic (M04 / M05 / M12) | **Use Case:** UC12, ADM-09

---

## 1. Endpoints Overview

| Method | Path | Role Required | Mô tả chức năng | Quy tắc PRG / Forward |
|---|---|---|---|---|
| `GET` | `/admin/teachers` | `ADMIN` | Danh sách hồ sơ giáo viên (ADM-09) kèm KPI và bộ lọc | Forward tới `admin/teacher-list.jsp` |
| `GET` | `/admin/teachers/form` | `ADMIN` | Form tạo mới hoặc chỉnh sửa hồ sơ giáo viên | Forward tới `admin/teacher-form.jsp` |
| `POST` | `/admin/teachers/save` | `ADMIN` | Lưu hồ sơ giáo viên (tạo mới hoặc cập nhật) | Redirect `/admin/teachers` kèm flash message |
| `POST` | `/admin/teachers/status` | `ADMIN` | Cập nhật nhanh trạng thái (`ACTIVE`, `ON_LEAVE`, `INACTIVE`) | Redirect `/admin/teachers` kèm flash message |

---

## 2. Request & Response Details

### 2.1. GET `/admin/teachers`
- **Query Parameters:**
  - `q`: String (từ khóa tìm theo tên, email, phone, chuyên môn)
  - `status`: String (`ALL`, `ACTIVE`, `ON_LEAVE`, `INACTIVE`, mặc định `ALL`)
  - `sort`: String (`newest`, `name_asc`, `classes_desc`)
  - `page`: Integer (1-based, mặc định 1)
- **Request Attributes:**
  - `teachers`: `List<TeacherAdminViewDTO>`
  - `stats`: `TeacherAdminStatsDTO`
  - `currentPage`: int
  - `totalPages`: int
  - `totalItems`: long
  - `pageSize`: int
  - `filterQ`, `filterStatus`, `filterSort`: duy trì trạng thái bộ lọc

### 2.2. GET `/admin/teachers/form`
- **Query Parameters:**
  - `id`: Long (tùy chọn, nếu có là chế độ sửa; nếu thiếu là chế độ tạo mới)
- **Request Attributes:**
  - `teacherForm`: `TeacherFormDTO`
  - `availableUsers`: `List<AvailableTeacherUserDTO>` (chỉ cần khi tạo mới)
  - `isEdit`: boolean

### 2.3. POST `/admin/teachers/save`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (tùy chọn)
  - `userId`: Long (bắt buộc khi tạo mới)
  - `fullName`: String (bắt buộc, 2–150 ký tự)
  - `phone`: String (tùy chọn)
  - `email`: String (tùy chọn)
  - `specialization`: String (tùy chọn)
  - `degree`: String (tùy chọn)
  - `hourlyRate`: BigDecimal (tùy chọn, >= 0)
  - `bio`: String (tùy chọn)
  - `status`: String (`ACTIVE`, `ON_LEAVE`, `INACTIVE`)
- **Success:** Redirect `/admin/teachers` với flash toast thông báo thành công.
- **Error:** Redirect về form kèm flash toast lỗi.

### 2.4. POST `/admin/teachers/status`
- **Form Data:**
  - `csrfToken`: String (bắt buộc)
  - `id`: Long (bắt buộc)
  - `status`: String (`ACTIVE`, `ON_LEAVE`, `INACTIVE`)
- **Business Rule Check (FR-005):** Nếu chuyển sang `ON_LEAVE` hoặc `INACTIVE`, kiểm tra xem giáo viên có buổi học tương lai nào chưa bàn giao hay không. Nếu có, từ chối và thông báo rõ ràng cho quản trị viên.
