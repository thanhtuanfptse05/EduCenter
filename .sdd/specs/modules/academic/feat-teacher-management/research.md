# Research & Technical Decisions: feat-teacher-management

**Feature:** `feat-teacher-management` | **Module:** Academic (M04 / M05 / M12) | **Use Case:** UC12, ADM-09

---

## 1. Architectural Decisions

### Decision 1: 1-to-1 Association Between Teacher Profile & User Account
- **Context:** FR-002 yêu cầu mỗi hồ sơ giáo viên (`Teacher`) phải gắn liền với một tài khoản người dùng (`User`) đang `ACTIVE` và có vai trò `TEACHER` (`r.code = 'TEACHER'`). Một User không được gắn nhiều hơn 1 Teacher profile (`UQ_Teachers_User`).
- **Decision:**
  - Khi tạo mới giáo viên, hệ thống cung cấp danh sách các User có role `TEACHER`, status `ACTIVE` mà **chưa được liên kết** với bất kỳ hồ sơ Teacher nào (`SELECT u FROM User u JOIN u.roles r WHERE r.code = 'TEACHER' AND u.status = 'ACTIVE' AND u.id NOT IN (SELECT t.user.id FROM Teacher t)`).
  - Khóa chặt mối quan hệ: Khi chỉnh sửa, không cho phép đổi `userId` sang tài khoản khác nhằm bảo toàn toàn vẹn nhật ký phân công và điểm danh lịch sử.

### Decision 2: Status Management & Scheduled Sessions Guard (BR05, FR-005)
- **Context:** Giáo viên có 3 trạng thái: `ACTIVE` (đang giảng dạy), `ON_LEAVE` (nghỉ phép/tạm nghỉ), `INACTIVE` (ngừng hợp tác). FR-005 yêu cầu khi chuyển trạng thái sang `ON_LEAVE` hoặc `INACTIVE`, nếu giáo viên vẫn còn lịch dạy tương lai (`ClassSessions` có `status = 'SCHEDULED'` và `session_date >= CURRENT_DATE`), hệ thống phải cảnh báo số buổi học chưa có người dạy thay và hướng dẫn bàn giao trước.
- **Decision:**
  - Trước khi cập nhật trạng thái sang `ON_LEAVE` hoặc `INACTIVE`, gọi hàm kiểm tra `countFutureScheduledSessions(em, teacherId)`.
  - Nếu > 0, ném `ValidationException` thông báo rõ ràng cho nhân viên: *"Không thể ngừng hoạt động giáo viên đang có X buổi học tương lai chưa bàn giao. Vui lòng phân công giáo viên dạy thay trước!"*.

### Decision 3: Hourly Rate Reference & Security Isolation (FR-006, BR02)
- **Context:** Bảng `Teachers` có trường `hourly_rate` (đơn giá thù lao/giờ). FR-006 quy định thù lao này chỉ phục vụ tham chiếu nội bộ trong phân hệ quản trị, tuyệt đối không xuất bản ra ngoài catalog công khai cho học sinh/khách.
- **Decision:**
  - `hourly_rate` chỉ xuất hiện trên `TeacherAdminViewDTO` và `TeacherFormDTO` thuộc phân hệ `/staff/teachers` (được bảo vệ bởi `RoleFilter`: chỉ `STAFF` và `ADMIN`).
  - DTO công khai (`TeacherCardDTO` hoặc `FacultyTeacherDTO`) tuyệt đối không map trường này.

### Decision 4: Audit Trail Immutability (BR18)
- **Context:** Mọi thay đổi liên quan đến hồ sơ giáo viên (tạo mới, đổi chuyên môn, thay đổi thù lao, đổi trạng thái) phải được ghi nhận vào `AuditLogs` trong cùng `EntityTransaction`.
- **Decision:**
  - Tích hợp `AuditLogRepository.save(em, auditLog)` với action tương ứng: `CREATE_TEACHER`, `UPDATE_TEACHER`, `TOGGLE_TEACHER_STATUS`.

### Decision 5: UI & Design System Alignment (design.md)
- **Context:** Màn hình ADM-09 quản lý giáo viên phải đạt tiêu chuẩn ERP chuyên nghiệp.
- **Decision:**
  - Default Light mode, font Inter, màu token CSS (`--bg: #f8fafc`, `--surface: #ffffff`, `--primary: #0284c7`, `--border: #e2e8f0`...).
  - Bộ icon Lucide SVG chuẩn 18–20px (không dùng emoji).
  - KPI Cards: Tổng số giáo viên, Đang giảng dạy (`ACTIVE`), Nghỉ phép (`ON_LEAVE`), Ngừng hoạt động (`INACTIVE`), Tổng số lớp đang phụ trách.
  - Bộ lọc đa chiều: Tìm kiếm theo họ tên/email/phone, lọc theo môn chuyên môn, lọc theo trạng thái hoạt động.
  - Empty State chuyên nghiệp khi chưa có dữ liệu hoặc kết quả lọc rỗng.
