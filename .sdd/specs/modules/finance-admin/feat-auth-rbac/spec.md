# Feature Specification: Xác thực, hồ sơ và quản lý tài khoản

**Feature:** `feat-auth-rbac` | **Module SRS:** M02, M12 | **Owner:** Member 03
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Có code nền auth/RBAC; phiên bản 2.0 cần plan/tasks và nghiệm thu lại các thay đổi, không coi checklist cũ là bằng chứng đạt.
**Nguồn:** SRS v1.1 II, III M02/M12, V UC01–05, VI BR01/02/18, VIII AUTH-01–05, ADM-18; **Use cases:** UC01, UC02, UC03, UC04, UC05.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Định danh, phân quyền và hồ sơ là nền tảng bảo vệ toàn hệ thống. Spec này hợp nhất nội dung cũ và các clarification, thay thế các đoạn mâu thuẫn trước đó.

**Trong phạm vi:** Đăng ký Student/Parent, login/logout, khôi phục/đổi mật khẩu, hồ sơ, ADMIN tạo/quản lý User/role/status, phiên/CSRF và lỗi truy cập.

**Ngoài phạm vi:** OAuth, 2FA, remember-me dài ngày, quản lý thiết bị giả, tự đăng ký Teacher/Staff/Admin hoặc tự nhận quan hệ giám hộ.

**Actors & Permissions:** Guest đăng ký/khôi phục; User ACTIVE thao tác cá nhân; ADMIN quản trị tài khoản. D01 ánh xạ 6 trách nhiệm SRS thành 5 mã role MVP, không bỏ trách nhiệm Manager.

## User Scenarios & Testing

### User Story 1 — Đăng ký và đăng nhập (Priority: P0)

Là Guest, tôi muốn đăng ký đúng vai trò và đăng nhập để sử dụng cổng cá nhân.

**Giá trị/ưu tiên:** Tiền đề mọi UC bảo vệ.

**Independent Test:** Đăng ký Student/Parent, login/logout rồi kiểm tra tài khoản bị khóa.

**Acceptance Scenarios:**
1. Given email mới và mật khẩu hợp lệ, When đăng ký, Then một User ACTIVE chỉ có STUDENT/PARENT đã chọn.
2. Given login hợp lệ, When xác thực xong, Then đổi session ID, vào dashboard đúng role; POST logout hủy phiên.

### User Story 2 — Khôi phục và hồ sơ (Priority: P0)

Là User, tôi muốn đổi hồ sơ/mật khẩu hoặc khôi phục an toàn để giữ quyền truy cập.

**Giá trị/ưu tiên:** Đủ UC03/04, không công khai token.

**Independent Test:** Xin reset qua SMTP, dùng token, thử dùng lại và thử phiên cũ.

**Acceptance Scenarios:**
1. Given email có/không/khóa, When xin reset, Then cùng thông báo công khai, không hiện reset link.
2. Given token hợp lệ chưa dùng trong 30 phút, When đổi mật khẩu, Then token bị tiêu thụ, phiên cũ vô hiệu và replay bị từ chối.

### User Story 3 — Quản trị và cô lập quyền (Priority: P0)

Là ADMIN, tôi muốn cấp/thu hồi tài khoản nội bộ để bảo vệ trung tâm.

**Giá trị/ưu tiên:** Đủ UC05 và BR02/18.

**Independent Test:** Tạo Teacher nội bộ, đổi role/status rồi thử tước ADMIN cuối cùng.

**Acceptance Scenarios:**
1. Given ADMIN có quyền, When đổi role/status, Then audit có before/after và phiên đích được kiểm tra lại request kế tiếp.
2. Given chỉ còn một ACTIVE ADMIN, When hai request cùng khóa/tước quyền, Then luôn còn ít nhất một ACTIVE ADMIN.

### Edge Cases

- Email hoa/thường/khoảng trắng, trùng đồng thời; mật khẩu Unicode vượt 72 UTF-8 bytes.
- Token sai/hết hạn/đã dùng/yêu cầu mới thay cũ; SMTP chưa cấu hình hoặc gửi lỗi.
- CSRF sai, session fixation, open redirect, User bị khóa/role đổi sau login.
- Hai ADMIN cùng thu hồi quyền; form profile gửi role/email/status ngoài phạm vi.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL chỉ cho tự đăng ký STUDENT/PARENT, chuẩn hóa email trim/lowercase theo Locale.ROOT duy nhất; mật khẩu≥6 ký tự,≤72 UTF-8 bytes, xác nhận trùng, BCrypt cost≥10. | UC01; BR01; SEC-01 | Email trùng đồng thời chỉ một User; gửi role ADMIN/STAFF/TEACHER bị từ chối; không lưu/log mật khẩu thô. |
| FR-002 | WHEN login thành công, THE SYSTEM SHALL đổi session ID, timeout 30 phút, cookie HttpOnly/cookie-only, CSRF cho mọi POST; chỉ POST /logout hủy phiên và chuyển hướng về trang chủ landing page (`/?loggedOut=true`) kèm thông báo đăng xuất thành công (không chuyển hướng về /login hoặc /register); các trang động phải gắn Cache-Control ngăn rò rỉ phiên qua nút Back (bfcache); sai mật khẩu phải hiển thị thông báo lỗi trên form và xóa thông tin phiên cũ, không chuyển hướng 403. | UC02; QG02 | GET /logout chỉ form xác nhận; POST /logout chuyển hướng về trang chủ (/); Session cookie Secure khi HTTPS; nhấn Back sau logout không hiển thị trạng thái đăng nhập; CSRF token lệch/hết hạn trên /login, /register, /forgot-password được làm mới và chuyển hướng về form kèm thông báo thay vì trả lỗi 403. |
| FR-003 | THE SYSTEM SHALL đọc lại status/roles/credential version trên mỗi request bảo vệ; đổi/reset mật khẩu làm vô hiệu các phiên cũ; redirect_url chỉ local và được phép. | UC02; BR02 | Khóa/thu quyền có hiệu lực request kế tiếp; external/path ngoài quyền không được redirect. |
| FR-004 | WHEN khôi phục, THE SYSTEM SHALL trả cùng thông báo cho email tồn tại/không/khóa; token random 32 bytes dùng một lần/30 phút, chỉ lưu SHA-256 hash, gửi SMTP cấu hình, yêu cầu mới vô hiệu token cũ và rate-limit. | UC03; SEC-01; D04 | Không hiển thị/log token/link; thiếu SMTP fail safely với mã sự cố; hết hạn/replay không đổi password. |
| FR-005 | WHEN cập nhật profile/password, THE SYSTEM SHALL chỉ cung cấp 2 khối thao tác thực tế: (1) Cập nhật họ tên, SĐT, đường dẫn avatar linh hoạt (hỗ trợ dán liên kết ảnh bất kỳ, tự động chuẩn hóa giao thức, xem trước trực tiếp, có ảnh mẫu chọn nhanh và fallback chữ cái an toàn), xem email/vai trò/trạng thái chỉ đọc; (2) Đổi mật khẩu kiểm tra mật khẩu hiện tại, chính sách mật khẩu mới và xác nhận trùng khớp; không sửa email/role/status qua profile. | UC03; UC04; BR02 | Password không vào flash/session; lỗi giữ input không nhạy cảm; update nguyên tử; cho phép dán bất kỳ link ảnh hợp lệ và xem trước ngay lập tức; loại bỏ hoàn toàn các tab 2FA, ma trận quyền RBAC giả, và lịch sử thiết bị đăng nhập giả khỏi giao diện profile. |
| FR-006 | WHEN ADMIN đổi role/status, THE SYSTEM SHALL kiểm quyền trong transaction, audit và khóa hàng ADMIN cùng target theo thứ tự; không để mất ACTIVE ADMIN cuối cùng. | UC05; BR18 | Thu quyền hai ADMIN đồng thời không khóa cả hệ thống; lỗi audit rollback. |
| FR-007 | THE SYSTEM SHALL tìm/lọc/page User bằng truy vấn bind, role/status allowlist và giữ bộ lọc; gán ít nhất một trong 5 mã canonical. | UC05; BR02 | Role lạ/tập rỗng bị chặn; actionStatus khác tham số filter status. |
| FR-008 | THE SYSTEM SHALL hiển thị auth/profile/admin/errors theo shell/design chung, escape output, empty/error state thật; trên thanh điều hướng công khai, hiển thị chip tài khoản người dùng chuyên nghiệp (avatar tròn, tên đầy đủ, huy hiệu vai trò, menu dropdown tùy chọn Bảng điều khiển / Hồ sơ / Đăng xuất) và nút điều hướng không gian làm việc cân đối, đồng bộ chiều cao và chuẩn Design System; dashboard role chưa có nguồn chỉ hiện điều hướng rõ. | UC01–05; QG03/04/09 | Không demo account, 2FA/device/history giả, link reset, chip Tier-4 hoặc KPI mẫu; home vẫn public sau login; thanh điều hướng hiển thị chip tài khoản chuẩn UI executive; màn hình profile AUTH-05 loại bỏ hoàn toàn các tab "Mật khẩu & Bảo mật 2FA", "Quyền hạn & Vai trò RBAC", "Lịch sử đăng nhập & Thiết bị (2)". |
| FR-009 | WHEN ADMIN tạo tài khoản nội bộ, THE SYSTEM SHALL kiểm email/policy, lưu hash, gán role được phép trong cùng transaction và audit; không cho STAFF tự cấp quyền. | UC05; M12 | Tạo/đọc/sửa/khóa tài khoản; password không trả lại sau save hoặc gửi qua URL. |
| FR-010 | THE SYSTEM SHALL bảo vệ function và từng record bằng Filter+Service, trả 403 trái quyền/404 đối tượng không có, không lộ stacktrace và sinh mã sự cố cho lỗi hệ thống. | BR02; SYS-01/02 | STUDENT không đọc /admin, Teacher không phí, Parent chưa verified không đọc con. |

### Key Entities

- User/Role/UserRole: định danh, 5 mã role MVP, trạng thái và quan hệ nhiều role.
- PasswordResetToken: hash, hết hạn, tiêu thụ, gắn User; không có link demo.
- Principal/credential version: định danh phiên phục vụ thu hồi quyền.
- AuditLog: tạo User, đổi role/status và hành vi trọng yếu.

### State & Business Rules

User ACTIVE/INACTIVE/LOCKED; chỉ ACTIVE đăng nhập. Role: ADMIN, STAFF, TEACHER, STUDENT, PARENT. Thứ tự dashboard khi nhiều role: ADMIN→STAFF→TEACHER→STUDENT→PARENT; redirect local hợp lệ có thể ưu tiên trước dashboard.

**Business rules:** BR01, BR02, BR15, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** AUTH-01, AUTH-02, AUTH-03, AUTH-04, AUTH-05, ADM-18, SYS-01, SYS-02. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. Auth và errors dùng public shell chung; profile dùng shell theo role. Đăng ký Student/Parent không tự cấp hồ sơ học viên/giám hộ; dữ liệu nghiệp vụ cần liên kết qua STAFF.

## Success Criteria

- **SC-001:** 100% đăng ký/login/logout/profile/reset hợp lệ hoàn tất và mọi ca token hết hạn/reuse/CSRF/redirect ngoài miền bị chặn.
- **SC-002:** Không thao tác role/status đồng thời nào làm mất ACTIVE ADMIN cuối cùng.
- **SC-003:** 0 password/token/reset link/demo helpers hoặc dữ liệu ngoài quyền xuất hiện ở UI/log công khai.

## Assumptions

- Giữ policy tối thiểu 6 ký tự theo baseline hiện tại, không đổi âm thầm lên policy khác.
- SMTP là cấu hình cần xác minh môi trường; không tuyên bố gửi mail đã hoạt động.
- Sẵn sàng triển khai cần thay/đồng bộ các ngoại lệ lịch sử của repair theo D04.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Tất cả feature phụ thuộc auth; student-guardian cấp liên kết dữ liệu riêng. Plan/tasks cũ phải cập nhật theo v2 trước code; FR-001–008 giữ chủ đề clarification cũ để giữ truy vết.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
