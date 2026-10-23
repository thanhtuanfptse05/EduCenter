# Feature Specification: Hỏi đáp kiểm duyệt và thông báo trong ứng dụng

**Feature:** `feat-notifications-qa` | **Module SRS:** M10 | **Owner:** Member 02
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M10, V UC28/29/30, VI BR17, VIII COM-01/02/03, ADM-17, XVII 3.8; **Use cases:** UC28, UC29, UC30.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Cộng đồng hỏi đáp cần nội dung được duyệt và kênh thông báo cá nhân đúng người để liên hệ trung tâm mà không công khai dữ liệu riêng.

**Trong phạm vi:** Đặt câu hỏi, trả lời, tìm/đọc công khai, duyệt/từ chối/ẩn P0; tạo/nhận/đánh dấu đọc thông báo trong app UC28 P1.

**Ngoài phạm vi:** Chat realtime, email/SMS/Zalo tự động, public thông tin học phí/điểm/hồ sơ riêng, nội dung rich HTML không kiểm soát.

**Actors & Permissions:** Guest đọc Q&A APPROVED công khai; Student/Parent hỏi và theo dõi bài mình; Teacher trả lời khóa/lớp được giao; STAFF/ADMIN trả lời và kiểm duyệt, không tự duyệt bài mình; mọi User ACTIVE đọc thông báo của chính mình.

## User Scenarios & Testing

### User Story 1 — Đặt và duyệt câu hỏi (Priority: P0)

Là Student/Parent, tôi muốn hỏi về khóa/lịch và biết trạng thái xử lý.

**Giá trị/ưu tiên:** Đáp ứng ASM 3.8.

**Independent Test:** Gửi câu hỏi, thử đọc Guest trước/sau duyệt.

**Acceptance Scenarios:**
1. Given câu hỏi mới, When gửi hợp lệ, Then PENDING và chỉ tác giả/người xử lý thấy.
2. Given đã được người khác có quyền duyệt, When Guest đọc, Then câu hỏi APPROVED xuất hiện; HIDDEN/REJECTED không công khai.

### User Story 2 — Trả lời theo phạm vi (Priority: P0)

Là Teacher/STAFF, tôi muốn trả lời để hỗ trợ người học đúng quyền.

**Giá trị/ưu tiên:** Hoàn chỉnh chu kỳ Q&A.

**Independent Test:** Teacher trả lời khóa được giao, người khác duyệt rồi ẩn câu hỏi.

**Acceptance Scenarios:**
1. Given Teacher đúng khóa, When trả lời, Then Answer PENDING chờ moderator khác.
2. Given Question bị ẩn, When đọc URL Answer đã APPROVED, Then không công khai nội dung con.

### User Story 3 — Thông báo cá nhân (Priority: P1)

Là người dùng, tôi muốn nhận và đánh dấu thông báo để theo dõi thay đổi liên quan.

**Giá trị/ưu tiên:** UC28 P1, không cản Q&A P0.

**Independent Test:** STAFF gửi thông báo chọn người nhận, mỗi người đánh dấu đọc.

**Acceptance Scenarios:**
1. Given thông báo cho A, When B mở ID của A, Then bị chặn.
2. Given A đánh dấu đã đọc hai lần, Then cùng read_at ban đầu, không ảnh hưởng B.

### Edge Cases

- Sửa nội dung đã duyệt phải về PENDING; tác giả bị khóa; bài bị ẩn sau khi đã có answer.
- Teacher ngoài khóa; Parent đưa điểm/phí con vào câu hỏi công khai; title/content HTML.
- Tự duyệt bài, từ chối thiếu lý do, hai moderator xử lý đồng thời.
- Notification lặp từ cùng event, mất liên kết giám hộ sau khi đã nhận, buổi/điểm còn nháp.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | WHEN Student/Parent gửi câu hỏi, THE SYSTEM SHALL yêu cầu tiêu đề/nội dung hợp lệ, khóa liên quan nếu có và phạm vi PUBLIC/PRIVATE; lưu PENDING với tác giả/time. | UC29; M10; ASM 3.8 | Guest không gửi; không tự APPROVED từ payload. |
| FR-002 | THE SYSTEM SHALL cho tác giả xem trạng thái/lý do bài mình, STAFF/ADMIN xem hàng đợi và Guest chỉ xem PUBLIC APPROVED. | UC29; BR02; BR17 | ID đoán không đọc PENDING/PRIVATE của người khác. |
| FR-003 | WHEN trả lời, THE SYSTEM SHALL kiểm tra STAFF/ADMIN hoặc Teacher thuộc khóa/lớp, lưu Answer PENDING riêng. | UC30; M10 | Student/Parent không giả role để trả lời; Teacher ngoài khóa bị chặn. |
| FR-004 | WHEN duyệt/từ chối/ẩn, THE SYSTEM SHALL yêu cầu STAFF/ADMIN khác tác giả, trạng thái hợp lệ và lý do khi REJECTED/HIDDEN; ghi moderator/time/audit. | UC30; BR17; BR18 | Không tự duyệt; lịch sử quyết định giữ nguyên, stale moderation bị từ chối. |
| FR-005 | WHILE Question hoặc Answer chưa APPROVED, THE SYSTEM SHALL không hiển thị công khai; Answer công khai còn yêu cầu Question PUBLIC APPROVED. | UC30; BR17 | Ẩn Question kéo toàn bộ Answer khỏi public mà không xóa chúng. |
| FR-006 | WHEN sửa nội dung đã duyệt, THE SYSTEM SHALL giữ revision/audit và đưa bản mới PENDING; không thay nội dung công khai chưa duyệt. | UC29; UC30; BR17 | Không có đường sửa qua form để bỏ kiểm duyệt. |
| FR-007 | THE SYSTEM SHALL tìm/lọc/sort/page Q&A theo khóa/từ khóa và chỉ dùng nội dung công khai đã duyệt; khóa archive vẫn giữ câu hỏi lịch sử. | M10; UC30; BR16 | Kết quả/tổng số không tiết lộ bài PENDING/PRIVATE; không xóa lịch sử. |
| FR-008 | THE SYSTEM SHALL giữ thông tin học viên/lịch cá nhân/học phí riêng trong PRIVATE chỉ tác giả và người có thẩm quyền được xử lý; moderator không đưa PII đó sang PUBLIC. | BR02; BR15; M10 | Không công khai bảng điểm/công nợ/liên hệ con; quyền bản ghi nguồn vẫn được kiểm tra. |
| FR-009 | WHEN tạo thông báo (P1), THE SYSTEM SHALL yêu cầu STAFF/ADMIN, chọn người nhận từ phạm vi được phép, loại TIMETABLE/ATTENDANCE/GRADE/TUITION/GENERAL và đối tượng liên quan hợp lệ. | UC28; M10 | Không gửi thông tin con tới Parent chưa verified hoặc điểm DRAFT. |
| FR-010 | THE SYSTEM SHALL lưu một Notification/người nhận/sự kiện; thông báo từ nghiệp vụ chỉ sau commit hoặc trong cùng transaction; lỗi gửi không làm giả thành công nghiệp vụ. | UC28; QG06; D13 | Retry sự kiện không nhân bản; rollback nguồn không có thông báo sai. |
| FR-011 | THE SYSTEM SHALL cho người nhận tìm/xem/đánh dấu đọc thông báo chính mình; read_at lần đầu ổn định và đích link tái kiểm tra quyền. | UC28; BR02; BR15 | Đánh dấu lặp an toàn; mất quyền giám hộ không đọc payload riêng hoặc đối tượng đích. |
| FR-012 | THE SYSTEM SHALL cung cấp thông báo đổi lịch/nghỉ học/đến hạn/kết quả từ dữ liệu thật (P1), không cần SMS/email hoặc cổng thanh toán. | M10; UC28; D13 | Nội dung khớp buổi/Invoice/PUBLISHED score; không dùng mẫu số giả. |

### Key Entities

- Question/Answer: nội dung, tác giả, khóa liên quan, visibility, trạng thái và revision/kiểm duyệt.
- Notification: bản tin một người nhận, loại, đích, event key và read_at.
- StudentGuardian/Class assignment: phạm vi dữ liệu riêng/người nhận/Teacher.
- AuditLog: quyết định duyệt/từ chối/ẩn và sửa bài.

### State & Business Rules

Question/Answer PENDING→APPROVED/REJECTED; APPROVED→HIDDEN hoặc PENDING khi sửa; HIDDEN/REJECTED chỉ trở lại PENDING qua yêu cầu sửa. Notification unread/read; không hard delete để né audit.

**Business rules:** BR02, BR11, BR15, BR16, BR17, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** COM-01, COM-02, COM-03, ADM-17. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. COM-01 list công khai, COM-02 chi tiết/form hỏi/trả lời và trạng thái tác giả; ADM-17 hàng đợi moderation; COM-03 inbox P1. Tạo câu hỏi ở /questions/new là route bổ sung, không dùng ID giả cho form.

## Success Criteria

- **SC-001:** 0 nội dung PENDING/REJECTED/HIDDEN/PRIVATE lọt ra công khai hoặc kết quả tìm kiếm.
- **SC-002:** 100% hỏi–trả lời–duyệt/từ chối/ẩn có trạng thái/tác giả/moderator đúng và không tự duyệt.
- **SC-003:** 0 Notification/đích riêng của người khác truy cập được bằng ID đoán; replay không tạo bản tin trùng.

## Assumptions

- Nội dung văn bản được escape; không upload file/rich HTML.
- Không có scheduler ngoài app ở P0; P1 có gửi thủ công hoặc sự kiện commit trong app.
- Câu hỏi tài chính/hồ sơ riêng không đưa vào diễn đàn; thiếu moderator thứ hai thì bài chờ, không tự bypass.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Cần auth, khóa, phân công và liên kết giám hộ. Nhận sự kiện sau commit từ lịch/attendance/assessment/finance; không dựa notification để quyết định công bố điểm.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
