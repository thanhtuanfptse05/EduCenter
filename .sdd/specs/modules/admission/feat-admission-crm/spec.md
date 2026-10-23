# Feature Specification: Lead, tư vấn và kiểm tra đầu vào

**Feature:** `feat-admission-crm` | **Module SRS:** M03 | **Owner:** Member 02
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M03, WF-01, V UC09/10, VIII ADM-02/03, FLOW-01/02; **Use cases:** UC09, UC10.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Lead từ website hoặc nhân viên phải được theo dõi xuyên suốt tư vấn đến ghi danh, không mất lịch sử và không nhầm gửi nhu cầu với đã trở thành học viên.

**Trong phạm vi:** Tiếp nhận Lead, nguồn, phân công tư vấn, lịch sử liên hệ/hẹn, học thử/đầu vào, trạng thái và bàn giao chuyển đổi.

**Ngoài phạm vi:** CRM marketing tự động, SMS/Zalo, tuyển sinh nhiều cơ sở, tự ghi danh hoặc tự liên kết giám hộ từ form public.

**Actors & Permissions:** Guest gửi nhu cầu qua catalog; STAFF xử lý Lead được giao, ADMIN xem/phân công toàn bộ. Teacher chỉ xem lịch thử được giao và nhập kết quả phần mình. Người gửi không tra cứu mọi Lead bằng mã đoán được.

## User Scenarios & Testing

### User Story 1 — Phân công và tư vấn (Priority: P0)

Là STAFF, tôi muốn xử lý Lead và ghi lịch sử liên hệ để không bỏ sót nhu cầu.

**Giá trị/ưu tiên:** Nối website và vận hành.

**Independent Test:** Gửi form public, ADMIN phân công, STAFF liên hệ.

**Acceptance Scenarios:**
1. Given yêu cầu hợp lệ, When tiếp nhận, Then một Lead NEW có mã thật, nguồn và khóa quan tâm.
2. Given STAFF ngoài phân công, When đọc/sửa Lead, Then từ chối cả URL và form giả.

### User Story 2 — Học thử và chuyển đổi (Priority: P0)

Là STAFF, tôi muốn đặt thử/đầu vào rồi chuyển đúng hồ sơ để ghi danh.

**Giá trị/ưu tiên:** Giữ đầy đủ WF-01.

**Independent Test:** Đặt lịch thử, ghi kết quả, chọn hồ sơ và ghi danh.

**Acceptance Scenarios:**
1. Given lịch thử hợp lệ, When người được giao lưu kết quả, Then có ngày/môn/điểm/nhận xét và lịch sử.
2. Given Lead CONSULTING, When enrollment cùng invoice commit, Then Lead ENROLLED liên kết Student/Enrollment; lỗi hóa đơn giữ Lead chưa chuyển.

### Edge Cases

- Lead cùng số điện thoại chưa chắc cùng học sinh; submit lặp phải khác yêu cầu mới có chủ ý.
- Bỏ qua kiểm tra đầu vào cần lý do; lịch thử bị hủy/đổi; điểm chưa có khác 0.
- STAFF nghỉ/khóa sau khi được giao; hai người chuyển Lead; Lead LOST muốn mở lại.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL nhận Lead từ public và nhân viên với tên/điện thoại bắt buộc, email tùy chọn, khối 6–12, nhu cầu/khóa, loại yêu cầu tư vấn/học thử/đầu vào, nguồn hợp lệ. | M03; UC09; M01 | Không hardcode khóa/nguồn ở view; input sai không tạo Lead. |
| FR-002 | THE SYSTEM SHALL tìm/lọc/sort/page Lead theo từ khóa, nguồn, trạng thái, người xử lý, ngày tạo và lịch hẹn. | UC10; M03 | Tổng số và kết quả khớp, giữ bộ lọc sau cập nhật. |
| FR-003 | WHEN phân công, THE SYSTEM SHALL yêu cầu ADMIN và người nhận STAFF ACTIVE; STAFF chỉ xem/sửa Lead được giao. | UC10; BR02 | Đổi assigned_to qua POST trái quyền bị chặn; chuyển giao có audit. |
| FR-004 | WHEN thêm liên hệ, THE SYSTEM SHALL lưu nội dung/kết quả/ngày liên hệ/hẹn tiếp/tác giả theo lịch sử, không ghi đè lần cũ. | UC10; Consultations | Hai lần tư vấn vẫn đọc được riêng; sửa sai có audit. |
| FR-005 | THE SYSTEM SHALL quản lý NEW→CONTACTED→ASSESSED→CONSULTING→ENROLLED, nhánh LOST kèm lý do; bỏ qua ASSESSED chỉ ADMIN duyệt lý do. | M03; WF-01 | Không đổi status tự do; ENROLLED chỉ từ enrollment thành công; mở lại LOST có ADMIN/lý do. |
| FR-006 | WHEN đặt học thử/đầu vào, THE SYSTEM SHALL lưu loại, môn, ngày/giờ, giáo viên/phòng được giao, trạng thái và kiểm tra lịch tài nguyên cùng quy tắc M05. | M03; TrialAssessments; WF-01 | Teacher chỉ thấy lịch được giao; xung đột phòng/giáo viên bị chặn. |
| FR-007 | WHEN ghi kết quả đầu vào, THE SYSTEM SHALL chỉ nhận score 0–10 hoặc chưa nhập, nhận xét và evaluator có quyền. | M03; BR10 | Điểm 0 lưu được, 10.01 bị chặn; thiếu điểm không hiển thị thành 0. |
| FR-008 | WHEN chuyển đổi, THE SYSTEM SHALL cho chọn hồ sơ Student hiện có hoặc tạo hồ sơ mới sau kiểm tra trùng; chuyển qua enrollment, không tạo hóa đơn riêng ở CRM. | WF-01; UC10; UC17 | Lặp thao tác không nhân Student/Enrollment/Invoice; lỗi giữ nguyên trạng thái trước. |
| FR-009 | THE SYSTEM SHALL cảnh báo Lead có liên hệ tương tự nhưng không tự gộp theo điện thoại; gộp thủ công cần ADMIN/lý do và giữ lịch sử. | UC10; QG07 | Hai học sinh cùng phụ huynh không bị gộp nhầm. |
| FR-010 | THE SYSTEM SHALL ngừng/đóng Lead bằng LOST thay hard delete khi có lịch sử và audit chuyển đổi/đổi phân công/trạng thái. | BR16; BR18 | Không mất lịch thử/tư vấn; dữ liệu nhạy cảm không công khai. |

### Key Entities

- Lead: nhu cầu có nguồn, trạng thái, người xử lý, khóa quan tâm và liên kết chuyển đổi.
- Consultation: lần liên hệ và lịch hẹn.
- TrialAssessment: lịch thử/đầu vào, phân công và kết quả riêng CRM.
- Student/Enrollment/Invoice: kết quả chuyển đổi do luồng ghi danh tạo.

### State & Business Rules

Lead NEW/CONTACTED/ASSESSED/CONSULTING/ENROLLED/LOST. Trial SCHEDULED/COMPLETED/CANCELLED là trường bổ sung phải migrate; không suy đã làm kiểm tra từ test_date. Xem D07/D12.

**Business rules:** BR02, BR03, BR04, BR10, BR16, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-02, ADM-03. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-02 bảng Lead; ADM-03 timeline tư vấn/lịch thử, chuyển trạng thái và bàn giao ghi danh. Chưa có khách hàng phải có empty state, không mẫu giả.

## Success Criteria

- **SC-001:** 100% yêu cầu hợp lệ tra được một Lead và lịch sử nguồn/tư vấn tương ứng.
- **SC-002:** 0 trường hợp chuyển đổi lỗi để lại Lead ENROLLED thiếu Enrollment/Invoice.
- **SC-003:** 0 trường hợp STAFF/Teacher ngoài phân công đọc/sửa Lead hoặc kết quả đầu vào.

## Assumptions

- Danh sách chờ là Lead CONSULTING có nhu cầu lớp đầy; không giữ chỗ hoặc thu tiền trước.
- Lead tiếp nhận công khai và source được catalog sở hữu phần form; CRM sở hữu xử lý nội bộ.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Đọc khóa/giáo viên/phòng; dùng cùng khóa tài nguyên lịch với M05. Phối hợp student-guardian và enrollment; bổ sung LeadCourses/converted links ở data-contract.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
