# Feature Specification: Hồ sơ giáo viên và quyền phân công

**Feature:** `feat-teacher-management` | **Module SRS:** M04, M05, M12 | **Owner:** Member 01; Member 03 cấp tài khoản
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 II, V UC12, VII Teachers, VIII ADM-09, X; **Use cases:** UC12.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Hồ sơ giáo viên liên kết tài khoản nội bộ để xếp lớp, xác định quyền điểm danh/nhập điểm và giới thiệu đội ngũ đúng thực tế.

**Trong phạm vi:** CRUD hồ sơ, nhiều môn chuyên môn, bằng cấp/mô tả xác thực, trạng thái và xem phân công.

**Ngoài phạm vi:** Tự đăng ký Teacher, payroll, xác minh bằng cấp tự động hoặc hợp đồng lao động.

**Actors & Permissions:** STAFF/ADMIN quản lý hồ sơ; ADMIN cấp tài khoản/role; TEACHER xem hồ sơ và phân công mình; public chỉ nhận trường được xuất bản.

## User Scenarios & Testing

### User Story 1 — Lập hồ sơ giáo viên (Priority: P0)

Là STAFF, tôi muốn liên kết giáo viên với tài khoản TEACHER hợp lệ để phân công.

**Giá trị/ưu tiên:** Không để hồ sơ và quyền đăng nhập tách rời.

**Independent Test:** ADMIN tạo tài khoản rồi STAFF lập hồ sơ.

**Acceptance Scenarios:**
1. Given User ACTIVE có TEACHER chưa liên kết, When lưu, Then tạo đúng một Teacher.
2. Given User đã có Teacher, When tạo thêm, Then từ chối trùng.

### User Story 2 — Ngừng phân công (Priority: P0)

Là STAFF, tôi muốn chuyển giáo viên sang nghỉ để giải quyết lịch tương lai.

**Giá trị/ưu tiên:** Tránh buổi học mất người phụ trách.

**Independent Test:** Đặt ON_LEAVE khi còn buổi SCHEDULED.

**Acceptance Scenarios:**
1. Given còn buổi tương lai, When xin ngừng hoạt động, Then cần bàn giao trước.
2. Given Teacher INACTIVE, When phân công mới, Then bị chặn và lịch sử vẫn giữ.

### Edge Cases

- User bị khóa/thu hồi TEACHER; email liên hệ khác email đăng nhập.
- Nhiều môn/lớp; thay giáo viên chính không đổi người thực dạy lịch sử.
- Thiếu bằng cấp, nội dung HTML, ngừng hồ sơ đã chấm điểm.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL tạo/đọc/sửa/ngừng hồ sơ với họ tên, liên hệ, chuyên môn, bằng cấp và mô tả tùy chọn. | UC12; ASM 3.3 | Đủ vòng CRUD bằng trạng thái; thiếu bằng cấp không sinh thông tin giả. |
| FR-002 | WHEN liên kết, THE SYSTEM SHALL yêu cầu User ACTIVE có TEACHER và duy nhất một Teacher/User. | M02; UC12 | User STUDENT hoặc đã liên kết bị từ chối. |
| FR-003 | THE SYSTEM SHALL khai báo nhiều môn chuyên môn, tìm theo tên/môn/trạng thái và xem lịch thực tế. | M04; M05; UC12 | Tìm thấy ở từng môn, không nhân đôi hồ sơ. |
| FR-004 | IF Teacher không ACTIVE hoặc User không hợp lệ, THE SYSTEM SHALL chặn phân công mới. | BR02; BR05 | POST phân công ON_LEAVE/INACTIVE bị từ chối. |
| FR-005 | WHEN ngừng hồ sơ còn buổi tương lai, THE SYSTEM SHALL yêu cầu bàn giao/dạy thay trước; không sửa buổi COMPLETED. | UC12; M05 | Không bỏ buổi tương lai chưa xử lý; lịch sử giữ người dạy. |
| FR-006 | THE SYSTEM SHALL public chỉ tên, mô tả/ảnh/chuyên môn/bằng cấp được duyệt; không lộ thù lao/liên hệ riêng/học viên. | M01; BR02 | DTO public không có trường nội bộ hoặc verified giả. |
| FR-007 | THE SYSTEM SHALL audit thay liên kết/trạng thái và không hard delete Teacher đã có dữ liệu liên quan. | BR16; BR18 | Giữ audit và tham chiếu lớp/buổi/điểm. |
| FR-008 | THE SYSTEM SHALL chặn STAFF tự gán role qua form giáo viên. | UC05; UC12; BR02 | Payload roleCodes không thay UserRoles. |

### Key Entities

- Teacher: hồ sơ giảng dạy gắn một User.
- Subject: nhiều môn chuyên môn, quan hệ định danh.
- Class/ClassSession: phân công chính/người thực dạy.
- User: định danh và quyền do M02 quản lý.

### State & Business Rules

Teacher ACTIVE/ON_LEAVE/INACTIVE. ClassSession.teacher quyết định người thực dạy; không suy quyền toàn trung tâm từ tài khoản Teacher.

**Business rules:** BR02, BR05, BR09, BR16, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-09. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-09 có list/form/chi tiết; xem phân công mở ADM-13 theo bộ lọc và quyền.

## Success Criteria

- **SC-001:** Mỗi tài khoản có tối đa một Teacher; lịch hiển thị khớp phân công.
- **SC-002:** Không ngừng giáo viên khi còn lịch tương lai chưa bàn giao.
- **SC-003:** Không lộ thù lao/liên hệ riêng qua public.

## Assumptions

- hourly_rate tham khảo không kích hoạt tính lương.
- TeacherSubjects là quan hệ bổ trợ cần migration; không parse specialization để phân quyền.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Auth cấp tài khoản; academic-programs cấp môn; class-timetable xét lịch. Catalog chỉ đọc thông tin được xuất bản.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
