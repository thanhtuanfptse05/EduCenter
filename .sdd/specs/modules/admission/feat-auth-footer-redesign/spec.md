# Feature Specification: UI xác thực và footer công khai dùng chung

**Feature:** `feat-auth-footer-redesign` | **Module SRS:** M01, M02 | **Owner:** Member 02 UI; Member 03 auth
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 VIII AUTH-01–05 và design.md; UI hỗ trợ auth/catalog v2; **Use cases:** UC01, UC02, UC03, UC04.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Màn hình xác thực và footer cần đồng nhất, giúp hoàn tất tác vụ an toàn mà không đưa chi tiết kỹ thuật hoặc khẳng định bảo mật chưa có vào trải nghiệm.

**Trong phạm vi:** Layout auth, label/validation, role selector Student/Parent, reset status thực, shared footer và responsive.

**Ngoài phạm vi:** Thay policy auth/role/token, 2FA, demo helpers/reset link, 256-bit SSL/ISO/TLS/uptime chưa được xác minh hoặc chi nhánh giả.

**Actors & Permissions:** Guest dùng auth; User dùng profile; thông tin trung tâm chỉ từ settings công khai, không lộ secrets.

## User Scenarios & Testing

### User Story 1 — Hoàn tất tác vụ xác thực (Priority: P0)

Là người dùng, tôi muốn form rõ ràng và lỗi dễ hiểu để đăng ký/đăng nhập/khôi phục.

**Giá trị/ưu tiên:** Hỗ trợ UC01–04.

**Independent Test:** Thử form hợp lệ/sai và quay lại sau redirect.

**Acceptance Scenarios:**
1. Given form sai, When gửi, Then lỗi đúng trường và giữ input an toàn, không password.
2. Given token hết hạn, When mở reset, Then trạng thái thật và link xin lại, không đếm ngược15phút giả.

### Edge Cases

- Email/name dài, thông báo validation dài, SMTP lỗi, localStorage bị chặn.
- Footer thiếu thông tin liên hệ/chính sách, ảnh showcase không có nguồn, nhập Unicode password.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL dựng login với label/focus/password toggle/validation và navigation chung; không hứa nhớ30ngày hoặc bảo mật chưa có. | UC02; design.md | Login dùng đúng policy/session của auth, không đoạn giới thiệu nội dung giả. |
| FR-002 | THE SYSTEM SHALL đăng ký chỉ Student/Parent với hướng dẫn password đúng policy, không badge BR01/SRS/SSL kỹ thuật ở flow người dùng. | UC01; BR01; QG09 | Role nội bộ không xuất hiện; lỗi rõ ràng, không autofill/demo account. |
| FR-003 | THE SYSTEM SHALL trình bày quên mật khẩu bằng phản hồi chung từ auth, không hiện link reset hoặc hướng dẫn chấm thử. | UC03; D04 | Email tồn tại/không có cùng response; SMTP lỗi không lộ token. |
| FR-004 | THE SYSTEM SHALL lấy token validity/expiry thật từ backend ở reset và hiển thị đúng thời gian còn lại nếu có countdown; không giữ hardcode15phút. | UC03; auth FR-004 | Token30phút còn10phút hiển thị10; hết hạn/reuse không có form đổi hợp lệ. |
| FR-005 | THE SYSTEM SHALL dùng footer chung từ center settings thật, một cơ sở, link chính sách có trang thật; không ISO/TLS/uptime/hotline giả. | M01; M12; QG03 | Thiếu trường không điền mẫu; auth/public/errors có cùng navigation ở4 độ rộng. |

### Key Entities

- Auth form view state: dữ liệu an toàn và reset expiry, không password/token trong flash.
- SystemSettings public: tên/liên hệ/nội dung footer hợp lệ.

### State & Business Rules

Không định nghĩa lại trạng thái auth. Policy token/session/role do feat-auth-rbac v2 quyết định; layout không làm phát sinh quyền.

**Business rules:** BR01, BR02. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** AUTH-01, AUTH-02, AUTH-03, AUTH-04, AUTH-05. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. AUTH-01–05 vẫn do auth sở hữu; supporting spec chi tiết UI. Dùng Inter/tokens/local CSS/outline SVG, Light mặc định và label lỗi đọc được bằng bàn phím.

## Success Criteria

- **SC-001:** 100% trang auth/public/errors dùng cùng footer/navigation và hoạt động ở4 độ rộng.
- **SC-002:** 0 hardcoded thời hạn/reset link/demo helpers/chứng nhận hoặc thông tin cơ sở giả.

## Assumptions

- FR-01..05 bản cũ ánh xạ FR-001..005 theo chủ đề; không giữ ràng buộc gradient/giả chứng nhận.
- Trang chính sách chưa có thì không render link; không tạo href=#.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Kế thừa auth/catalog/sysadmin v2; không thay controller/policy từ UI. Plan/tasks lịch sử phải cập nhật trước code.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
