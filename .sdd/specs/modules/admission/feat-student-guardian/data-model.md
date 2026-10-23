# Data Model: feat-student-guardian

## 1. Entities & Mapping

### Entity: Student (`com.educenter.entity.Student`)
Table: `Students`

| Field | Column | Type | Nullable | Description |
|---|---|---|---|---|
| `id` | `id` | Long | No | Identity PK |
| `user` | `user_id` | User | Yes | ManyToOne (nullable, optional STUDENT account) |
| `fullName` | `full_name` | String (150) | No | Họ và tên học viên |
| `dob` | `dob` | LocalDate | Yes | Ngày sinh (phải trong quá khứ) |
| `gender` | `gender` | String (10) | Yes | 'NAM', 'NU', 'KHAC' |
| `phone` | `phone` | String (20) | Yes | Số điện thoại liên hệ |
| `email` | `email` | String (255) | Yes | Email học viên |
| `school` | `school` | String (255) | Yes | Trường đang theo học (THCS/THPT) |
| `gradeLevel` | `grade_level` | Integer | No | Khối lớp (6 - 12) |
| `targetGoal` | `target_goal` | String (500) | Yes | Mục tiêu thi cử / bổ trợ kiến thức |
| `status` | `status` | String (20) | No | 'STUDYING', 'RESERVED', 'DROPPED', 'GRADUATED' |
| `createdAt` | `created_at` | LocalDateTime | No | Thời điểm tạo |
| `updatedAt` | `updated_at` | LocalDateTime | No | Thời điểm cập nhật cuối |

### Entity: Guardian (`com.educenter.entity.Guardian`)
Table: `Guardians`

| Field | Column | Type | Nullable | Description |
|---|---|---|---|---|
| `id` | `id` | Long | No | Identity PK |
| `user` | `user_id` | User | No | ManyToOne (bắt buộc role PARENT) |
| `fullName` | `full_name` | String (150) | No | Họ và tên phụ huynh / giám hộ |
| `phone` | `phone` | String (20) | No | Số điện thoại chính |
| `email` | `email` | String (255) | Yes | Email liên hệ |
| `occupation` | `occupation` | String (150) | Yes | Nghề nghiệp |
| `address` | `address` | String (255) | Yes | Địa chỉ cư trú |
| `status` | `status` | String (20) | No | 'ACTIVE', 'INACTIVE' |
| `createdAt` | `created_at` | LocalDateTime | No | Thời điểm tạo |
| `updatedAt` | `updated_at` | LocalDateTime | No | Thời điểm cập nhật cuối |

### Entity: StudentGuardian (`com.educenter.entity.StudentGuardian`)
Table: `StudentGuardians`

| Field | Column | Type | Nullable | Description |
|---|---|---|---|---|
| `id` | `id` | Long | No | Identity PK |
| `student` | `student_id` | Student | No | ManyToOne |
| `guardian` | `guardian_id` | Guardian | No | ManyToOne |
| `relationship` | `relationship` | String (50) | No | 'Bố', 'Mẹ', 'Ông', 'Bà', 'Người giám hộ' |
| `isPrimary` | `is_primary` | Boolean | No | Người nhận thông báo chính (default false) |
| `verifiedAt` | `verified_at` | LocalDateTime | Yes | Thời điểm xác thực |
| `verifiedBy` | `verified_by` | Long | Yes | User ID của Staff/Admin xác nhận |

## 2. Validation & Business Rules
- **BR01:** Email và số điện thoại phải hợp lệ theo `ValidationUtil`.
- **BR02:** Cấp quyền và xác thực phụ huynh ghi nhật ký kiểm toán `AuditLog`.
- **BR15:** Phụ huynh chỉ xem được dữ liệu con cái khi cặp quan hệ có `verified_at != null`. Thu hồi xác thực (`verified_at = null`, `verified_by = null`) lập tức ngắt quyền truy cập.
- **BR16:** Không hard-delete học viên hoặc phụ huynh; chỉ soft-delete / đổi trạng thái sang `DROPPED` / `INACTIVE`.
