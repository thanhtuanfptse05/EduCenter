# HTTP Interface Contract: feat-student-guardian

## 1. Student Management Endpoints (`/staff/students`)

| Method | Endpoint | Allowed Roles | Description | Parameters |
|---|---|---|---|---|
| GET | `/staff/students` | STAFF, ADMIN | Danh sách học viên, lọc, phân trang, KPI | `q`, `grade`, `status`, `page` |
| GET | `/staff/students/detail` | STAFF, ADMIN | Chi tiết hồ sơ học viên, người giám hộ, lịch sử | `id` |
| POST | `/staff/students/save` | STAFF, ADMIN | Tạo mới hoặc cập nhật hồ sơ học viên | `id` (opt), `fullName`, `dob`, `gender`, `phone`, `email`, `school`, `gradeLevel`, `targetGoal`, `status`, `userId` (opt), `csrfToken` |
| POST | `/staff/students/status` | STAFF, ADMIN | Thay đổi trạng thái học viên (STUDYING, RESERVED, DROPPED, GRADUATED) | `id`, `status`, `csrfToken` |
| POST | `/staff/students/user-link` | STAFF, ADMIN | Gắn hoặc hủy tài khoản User STUDENT cho học viên | `studentId`, `userId`, `csrfToken` |

## 2. Guardian & Linkage Endpoints (`/staff/guardians`)

| Method | Endpoint | Allowed Roles | Description | Parameters |
|---|---|---|---|---|
| GET | `/staff/guardians` | STAFF, ADMIN | Danh sách phụ huynh, tra cứu con cái liên kết | `q`, `status`, `verification`, `page` |
| POST | `/staff/guardians/save` | STAFF, ADMIN | Tạo mới hoặc cập nhật hồ sơ phụ huynh | `id` (opt), `userId`, `fullName`, `phone`, `email`, `occupation`, `address`, `status`, `csrfToken` |
| POST | `/staff/guardians/link` | STAFF, ADMIN | Tạo liên kết giữa phụ huynh và học sinh | `studentId`, `guardianId`, `relationship`, `isPrimary`, `csrfToken` |
| POST | `/staff/guardians/verify` | STAFF, ADMIN | Xác thực liên kết giám hộ (cấp quyền xem con) | `linkId`, `notes`, `csrfToken` |
| POST | `/staff/guardians/revoke` | STAFF, ADMIN | Thu hồi xác thực liên kết giám hộ | `linkId`, `reason`, `csrfToken` |
