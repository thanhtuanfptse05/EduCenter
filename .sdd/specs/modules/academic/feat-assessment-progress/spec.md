# Feature Specification: Bài kiểm tra, công bố điểm và tiến bộ

**Feature:** `feat-assessment-progress` | **Module SRS:** M08 | **Owner:** Member 01
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M08, WF-03, V UC22/23/24/33, VIII TCH-05/06; **Use cases:** UC22, UC23, UC24, UC33.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Điểm hợp lệ và công bố có kiểm soát giúp người học xem tiến bộ thật theo thời gian, không lộ nháp hoặc so sánh sai thang.

**Trong phạm vi:** Tạo/sửa bài theo lớp, bốn loại kiểm tra, thang/trọng số, nhập điểm/nhận xét, công bố/correction, dữ liệu tiến bộ và thống kê lớp.

**Ngoài phạm vi:** Thi online, ngân hàng câu hỏi, AI chấm, tự đưa kết quả CRM vào điểm học tập và tự điền 0 cho thiếu điểm.

**Actors & Permissions:** TEACHER được giao lớp hoặc ADMIN ghi/chốt điểm; STAFF đọc nghiệp vụ; Student/Parent chỉ đọc PUBLISHED trong phạm vi.

## User Scenarios & Testing

### User Story 1 — Tạo bài và nhập điểm (Priority: P0)

Là TEACHER, tôi muốn tạo bài và nhập đúng thang để đánh giá chính xác.

**Giá trị/ưu tiên:** Đầu vào công bố/báo cáo.

**Independent Test:** Tạo max_score=20, thử 0, 20, 20.01 và lưu nháp.

**Acceptance Scenarios:**
1. Given DRAFT và đúng quyền, When nhập 0/20, Then lưu; 20.01 bị từ chối.
2. Given chưa công bố, When Student/Parent đọc URL/payload, Then không nhận điểm/nhận xét nháp.

### User Story 2 — Công bố và tiến bộ (Priority: P0)

Là Student/Parent, tôi muốn xem điểm công bố và xu hướng để theo dõi kết quả.

**Giá trị/ưu tiên:** Hoàn tất WF-03/05.

**Independent Test:** Công bố bài hai thang, so sánh tại hai portal.

**Acceptance Scenarios:**
1. Given điểm trên thang 10/20, When công bố, Then chart chuẩn hóa và vẫn hiển thị thang gốc.
2. Given PUBLISHED cần sửa, When ADMIN mở correction, Then có lý do/audit và chỉ hiển thị lại sau công bố lại.

### Edge Cases

- 0 khác chưa có điểm; thay thang khi đã nhập; bài rỗng.
- Học viên chuyển/nghỉ sau ngày thi; dạy thay một buổi không có quyền chấm cả lớp.
- Công bố/sửa đồng thời; nháp không được lọt qua chart/export/notification.
- Thiếu ENTRANCE, nhiều thang/trọng số, HTML trong tên/nhận xét.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | WHEN tạo bài, THE SYSTEM SHALL yêu cầu lớp thuộc phân công, tên, ENTRANCE/MID_TERM/FINAL/PERIODIC, ngày, max_score>0 và weight>0. | UC22; M08; BR09 | Tạo đủ bốn loại; chặn max_score/weight=0 và lớp ngoài quyền. |
| FR-002 | THE SYSTEM SHALL tạo/đọc/sửa/ngừng dùng bài DRAFT; không xóa bài có điểm hoặc đổi thang làm điểm đang có mất hợp lệ. | UC22; BR10; BR16 | Thay thang phải xử lý lại toàn bộ điểm trong correction nguyên tử. |
| FR-003 | WHEN nhập điểm, THE SYSTEM SHALL xét roster ngày kiểm tra, 0≤score≤max_score, một score/assessment/student, nhận xét, actor/time. | UC23; BR09; BR10 | Chặn âm/vượt thang/ngoài roster; không nhân bản điểm. |
| FR-004 | WHILE DRAFT, THE SYSTEM SHALL cho lưu một phần, giữ thiếu là chưa nhập, không suy thành 0. | UC23; M08 | 3/5 điểm hiển thị 2 thiếu, AVG không tính hai người thiếu. |
| FR-005 | WHEN công bố, THE SYSTEM SHALL kiểm tra lại quyền/thang/phiên bản, yêu cầu ít nhất một điểm, ghi người/thời điểm/audit và chuyển PUBLISHED nguyên tử. | UC23; BR11; BR18 | Bài rỗng không công bố; lỗi audit rollback; chỉ điểm đã nhập hiển thị. |
| FR-006 | WHILE chưa PUBLISHED, THE SYSTEM SHALL không trả điểm/nhận xét nháp cho Student/Parent ở trang, chart, báo cáo hoặc endpoint dữ liệu. | BR11; UC24 | Sửa ID/URL và đọc payload không lấy được nháp. |
| FR-007 | WHEN sửa PUBLISHED, THE SYSTEM SHALL yêu cầu ADMIN mở DRAFT có lý do/audit; ẩn trong correction và công bố lại trước hiển thị. | UC23; BR18 | Không sửa ngầm; giữ before/after và tác giả công bố lại. |
| FR-008 | THE SYSTEM SHALL trả điểm gốc/thang/ngày/nhận xét và tiến bộ D12; thiếu đầu vào không có mức tăng giả. | UC24; M08; D12 | 10/20=5/10 chuẩn hóa; thiếu ENTRANCE báo chưa có mốc. |
| FR-009 | THE SYSTEM SHALL tính AVG trọng số, MIN/MAX từ PUBLISHED đã nhập, đúng phạm vi lớp/người/giai đoạn. | UC33; M11; ASM 3.5 | Đối soát tay khớp; Teacher không đọc lớp khác qua báo cáo. |
| FR-010 | IF bài/điểm đã đổi phiên bản, THE SYSTEM SHALL từ chối lưu/công bố snapshot cũ. | UC23; QG06 | Hai request không mất điểm hoặc công bố dữ liệu sai phiên bản. |

### Key Entities

- Assessment: bài của lớp, loại/ngày/thang/trọng số/trạng thái.
- AssessmentScore: điểm/nhận xét một Student, duy nhất theo bài.
- Published progress: góc nhìn điểm đã công bố, không lưu thành tích mẫu.
- TrialAssessment: đầu vào CRM riêng, chỉ chuyển sang học tập bằng thao tác có roster/thang/công bố.

### State & Business Rules

DRAFT/PUBLISHED; PUBLISHED→DRAFT chỉ ADMIN correction có audit. Không thêm APPROVED trái schema. Quyền chấm theo phân công lớp có hiệu lực.

**Business rules:** BR02, BR09, BR10, BR11, BR15, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** TCH-05, TCH-06. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. TCH-05 tạo/tra cứu bài và thống kê lớp; TCH-06 phân biệt chưa nhập/nháp/công bố. Trang đọc STD-03/PAR-02 thuộc portal.

## Success Criteria

- **SC-001:** 100% điểm hợp lệ trong thang; 0 điểm DRAFT trả Student/Parent.
- **SC-002:** Chuẩn hóa/AVG/MIN/MAX khớp dữ liệu nhiều thang/trọng số đến 2 số lẻ.
- **SC-003:** Mọi công bố/correction có actor/time/reason và không công bố một phần.

## Assumptions

- Điểm tối đa 2 số lẻ, chuẩn hóa về 10.
- Roster theo ngày kiểm tra và lịch sử Enrollment, không roster hiện tại.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Cần lớp/phân công/enrollment-history/auth; cung cấp dữ liệu lọc công bố cho portal/reporting. Chart JS không tự định nghĩa công thức khác.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
