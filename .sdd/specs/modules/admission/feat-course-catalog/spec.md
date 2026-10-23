# Feature Specification: Website công khai, catalog và danh sách đăng ký

**Feature:** `feat-course-catalog` | **Module SRS:** M01 | **Owner:** Member 02
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Có code catalog/cart/tiếp nhận Lead; v2 cần nghiệm thu dữ liệu thật và hợp đồng CRM hiện hành, không xác nhận toàn M01 hoàn tất.
**Nguồn:** SRS v1.1 III M01, V UC06–09, WF-01, VIII PUB-01–07, XVII 3.2/3.6; **Use cases:** UC06, UC07, UC08, UC09.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Người quan tâm cần tìm đúng khóa và gửi nhu cầu với thông tin/giá thật; yêu cầu tư vấn đi vào CRM, không tự thành ghi danh hoặc thanh toán.

**Trong phạm vi:** Home nội dung trung tâm/giáo viên/khóa thật, tìm/lọc/sort/page, chi tiết/liên quan, giỏ Guest/tài khoản, ghi chú, tổng phí dự kiến, tư vấn/xác nhận và biên nhận thật.

**Ngoài phạm vi:** Giữ chỗ, tự ghi danh, ngân hàng thật, coupon/combo/giá gốc giả, dữ liệu showcase học tập hardcode.

**Actors & Permissions:** Guest/All đọc public; Guest/Student/Parent chọn khóa và gửi nhu cầu. STAFF/ADMIN xem public như người dùng; mọi truy cập giỏ tài khoản cần actor ACTIVE.

## User Scenarios & Testing

### User Story 1 — Tìm và chọn khóa (Priority: P0)

Là người quan tâm, tôi muốn lọc và xem khóa phù hợp để lựa chọn.

**Giá trị/ưu tiên:** Bao phủ UC06/07 và ASM 3.2.

**Independent Test:** Lọc môn/khối/phí, sort/page, mở chi tiết và khóa liên quan.

**Acceptance Scenarios:**
1. Given khóa OPEN trong DB, When lọc, Then list/count/page đúng và giữ bộ lọc.
2. Given chi tiết có dữ liệu thiếu, When xem, Then báo chưa cập nhật, không tự điền giáo viên/lịch/sĩ số.

### User Story 2 — Giỏ và gửi nhu cầu (Priority: P0)

Là Guest/Student/Parent, tôi muốn chỉnh danh sách và tổng phí trước khi gửi.

**Giá trị/ưu tiên:** Bao phủ UC08 và ASM 3.6 chức năng tương đương.

**Independent Test:** Guest thêm khóa, login, sửa ghi chú, xóa, xác nhận và replay.

**Acceptance Scenarios:**
1. Given cart Guest và tài khoản có khóa trùng, When login, Then hợp nhất một lần, không mất khóa/ghi chú.
2. Given form hợp lệ, When xác nhận, Then một Lead NEW, giỏ chỉ xóa sau commit và receipt có dữ liệu lưu thật.

### User Story 3 — Đăng ký tư vấn trực tiếp (Priority: P0)

Là Guest, tôi muốn gửi nhu cầu không cần tạo tài khoản để được tư vấn.

**Giá trị/ưu tiên:** Bao phủ UC09 và PUB-06.

**Independent Test:** Gửi form rỗng/sai/đúng rồi xem mã yêu cầu.

**Acceptance Scenarios:**
1. Given liên hệ hợp lệ, When gửi tư vấn, Then Lead NEW nguồn WEBSITE và mã receipt thật.
2. Given mã receipt tự đoán hoặc session khác, When đọc success, Then không dựng thông báo thành công giả.

### Edge Cases

- Cart rỗng, duplicate khóa, ID sai, phí thay/khóa đóng sau khi chọn.
- Guest login đổi session; logout/login tài khoản khác; add/update và checkout đồng thời.
- Từ khóa HTML/SQL, range phí đảo, grade5/13, page rất lớn.
- DB rỗng/lỗi, không giáo viên/khóa tương tự, retry sau mất mạng.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL dựng Home từ dữ liệu trung tâm/khóa nổi bật/mới, môn/khối và giáo viên được phép công bố trong DB. | M01; PUB-01; ASM 3.2 | Không hardcode KPI/thành tích/chứng nhận/showcase; thiếu dữ liệu dùng empty state. |
| FR-002 | THE SYSTEM SHALL tìm keyword theo tên/mô tả, lọc môn/khối6–12/mục tiêu thi/minFee/maxFee, sort newest/fee_asc/fee_desc/name_asc, phân trang 9 khóa/trang; giao diện thẻ khóa học hiển thị chuẩn thiết kế hiện đại (ảnh thumbnail 16:9 kèm huy hiệu môn/khối nổi, thông tin buổi/tuần/mục tiêu, học phí niêm yết rõ ràng và nút hành động cân đối). | UC06; ASM 3.2 | Bind tham số/allowlist sort; list/count cùng predicate, giữ toàn bộ bộ lọc; thẻ khóa học chuẩn Design System. |
| FR-003 | THE SYSTEM SHALL trả chi tiết mục tiêu/nội dung/trình độ/số buổi/thời lượng/phí/sĩ số/lịch dự kiến thật và tối đa 3 khóa OPEN liên quan cùng môn hoặc khối, không gồm chính nó. | UC07; M01 | Thứ tự liên quan ổn định; chưa có lớp/lịch báo rõ; không hiển thị giá trị mặc định giả. |
| FR-004 | WHEN thêm giỏ, THE SYSTEM SHALL tải Course hiện hành, chỉ nhận OPEN và duy nhất một khóa/session hoặc tài khoản, quantity=1. | UC08; ASM 3.6; D07 | Thêm trùng không thêm dòng/nhân phí; khóa đóng bị từ chối. |
| FR-005 | THE SYSTEM SHALL hiển thị giao diện giỏ đăng ký khóa học hiện đại và minh bạch (thanh tiến trình 3 bước, thẻ khóa học có ảnh đại diện/mã/môn/khối/số buổi/giáo viên, ô ghi chú nguyện vọng tiện lợi, nút xóa tinh tế, khối tóm tắt đăng ký chi tiết kèm cam kết tư vấn); cho cập nhật ghi chú/nhu cầu, xóa một khóa hoặc clear giỏ; tính tổng=sum phí niêm yết hiện tại các lựa chọn hợp lệ. | UC08; D03/D07 | Không coupon/combo; cập nhật thay cho tăng số lượng, empty cart không xác nhận; giao diện trực quan, rõ ràng thông tin theo design.md. |
| FR-006 | WHEN Guest đăng nhập, THE SYSTEM SHALL bảo toàn cart qua đổi session ID, merge một lần với cart DB và chỉ xóa cart Guest sau persist thành công. | UC08; QG06 | Lỗi DB giữ lựa chọn; logout không lộ cart tài khoản trước cho người sau. |
| FR-007 | WHEN xác nhận, THE SYSTEM SHALL tải lại phí/trạng thái, hiển thị thay đổi cần người dùng xác nhận lại và kiểm liên hệ/khối/khóa chọn ở server. | UC08; WF-01 | Khóa mất/đóng không submit; giá thay không âm thầm chốt tổng cũ. |
| FR-008 | WHEN submit hợp lệ, THE SYSTEM SHALL tạo Lead NEW/WEBSITE với snapshot khóa/ghi chú/phí dự kiến và clear cart nguyên tử, idempotent theo nonce. | UC08; M03; QG06 | Retry không tạo Lead thứ hai; lỗi giữ cart/form; không tạo Enrollment/Invoice. |
| FR-009 | THE SYSTEM SHALL cấp receipt từ submission đã persist thuộc session hiện hành; mã/giá trị URL không tự tạo success. | PUB-07; UC09 | Session khác hoặc code đoán không đọc được liên hệ/khóa/total. |
| FR-010 | WHEN gửi tư vấn không cart, THE SYSTEM SHALL nhận tên/điện thoại, email tùy chọn, khối/nhu cầu/khóa quan tâm, loại yêu cầu CONSULTATION/TRIAL/ENTRANCE và thời gian mong muốn, tạo Lead NEW và receipt theo cùng quy tắc idempotency. | UC09; PUB-06; M03 | Không buộc tạo User; form lỗi không tạo Lead hoặc mất input an toàn. |
| FR-011 | THE SYSTEM SHALL dùng cùng navbar/footer cho public/auth/errors, home public sau login; các filter option và dữ liệu hiển thị là nguồn backend thật. | M01; QG03/04; D04 | Giữ navigation ở 4 độ rộng; keyword là tham số chuẩn, q chỉ alias tương thích. |
| FR-012 | IF không có dữ liệu hoặc nguồn lỗi, THE SYSTEM SHALL phân biệt empty/unavailable; detail thiếu không dựng course giả, POST luôn CSRF/PRG. | UC06–09; QG02/03/11 | Không thành công giả/KPI=0 do lỗi; khóa CLOSED/ARCHIVED không thêm dù POST tay. |

### Key Entities

- Course/Subject/Class/Teacher: nội dung catalog có thật.
- RegistrationCartItem: lựa chọn duy nhất, quantity1, notes; Guest ở session.
- Lead/LeadCourse: yêu cầu và snapshot lựa chọn, chưa là ghi danh.
- SubmissionReceipt: góc nhìn persisted Lead có session-scoped access.

### State & Business Rules

Course OPEN/CLOSED/ARCHIVED. Class OPEN/ONGOING có thể nhận ghi danh; PLANNING chỉ hiển thị lịch dự kiến rõ chưa nhận, không tính chỗ tuyển sinh thật. Cart không giữ chỗ, không bảo đảm phí tới khi phát hành hóa đơn.

**Business rules:** BR02, BR16. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** PUB-01, PUB-02, PUB-03, PUB-04, PUB-05, PUB-06, PUB-07. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. PUB-01–07 có shared public shell. Chi tiết/related có link thật; CTA/receipt rõ là yêu cầu tư vấn/nhu cầu, không ghi “thanh toán thành công”.

## Success Criteria

- **SC-001:** 100% tìm/lọc/sort/page/detail/related khớp DB, không dữ liệu hiển thị giả.
- **SC-002:** Guest→login→merge→sửa/xóa→confirm giữ đủ lựa chọn hợp lệ; replay tạo đúng một Lead.
- **SC-003:** 100% tổng giỏ khớp phí niêm yết; không coupon/combo, khóa đóng hoặc receipt tự dựng.

## Assumptions

- Cart chỉ là danh sách khóa duy nhất cho một nhu cầu; Parent gửi yêu cầu riêng cho từng con.
- Home có thể nhấn THPT nhưng backend hỗ trợ đủ khối6–12.
- Landing/auth UI spec là đặc tả hỗ trợ; dữ liệu/giá/quyền do spec này và auth quyết định.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Đọc academic-programs/teacher-management; auth bảo toàn Guest cart; CRM nhận Lead/khóa quan tâm theo integration. Baseline mới thay ngoại lệ dữ liệu minh họa lịch sử theo D04.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
