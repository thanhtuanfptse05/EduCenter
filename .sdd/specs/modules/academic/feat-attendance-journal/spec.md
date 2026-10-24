# Feature Specification: Điểm danh và nhật ký giảng dạy

**Feature:** `feat-attendance-journal` | **Module SRS:** M07 | **Owner:** Member 01
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M07, WF-02, V UC20/21, VIII TCH-03/04; **Use cases:** UC20, UC21.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Mỗi buổi cần chuyên cần có nguồn gốc và nhật ký nội dung/bài tập để học viên, phụ huynh theo dõi đúng.

**Trong phạm vi:** Điểm danh/hoàn tất buổi/chuyên cần P0; nhật ký nội dung dạy, bài tập, nhận xét UC21 P1.

**Ngoài phạm vi:** Chấm công lương, điểm danh khuôn mặt/QR, nộp bài online và thông báo ngoài app.

**Actors & Permissions:** Giáo viên thực dạy ghi nhận; ADMIN correction có lý do; STAFF đọc nghiệp vụ; Student/Parent đọc bản thân/con xác thực qua portal. Giáo viên chính không mặc nhiên sửa buổi dạy thay.

## User Scenarios & Testing

### User Story 1 — Điểm danh và hoàn tất (Priority: P0)

Là TEACHER được giao, tôi muốn điểm danh đúng roster ngày học để chuyên cần đáng tin.

**Giá trị/ưu tiên:** Cần trước khi tính tỷ lệ.

**Independent Test:** Ghi đủ bốn trạng thái và hoàn tất buổi.

**Acceptance Scenarios:**
1. Given buổi được giao và roster hợp lệ, When lưu, Then mỗi học viên/buổi có tối đa một trạng thái.
2. Given roster chưa đủ điểm danh, When hoàn tất, Then liệt kê dòng thiếu, không tự đánh có mặt.

### User Story 2 — Nhật ký và correction (Priority: P1)

Là TEACHER, tôi muốn lưu nội dung và bài tập để học viên biết đã học gì.

**Giá trị/ưu tiên:** UC21 P1, không cản điểm danh P0.

**Independent Test:** Lưu journal, hoàn tất và sửa bằng ADMIN.

**Acceptance Scenarios:**
1. Given buổi được giao, When lưu nhật ký và hoàn tất, Then portal thấy nội dung thật.
2. Given COMPLETED, When ADMIN sửa chuyên cần với lý do, Then có audit before/after và tỷ lệ cập nhật; Giáo viên thực dạy của buổi cũng được sửa chuyên cần buổi đã chốt (v1.1), mọi lần sửa đều có audit.

### Edge Cases

- Chuyển/bảo lưu sau buổi không làm mất roster lịch sử; bắt đầu học sau ngày buổi không được điểm danh.
- Giáo viên cũ gửi form sau dạy thay, lưu đồng thời, buổi CANCELLED/RESCHEDULED.
- Roster rỗng; HTML trong journal; không có buổi hợp lệ để chia tỷ lệ.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | WHEN mở điểm danh, THE SYSTEM SHALL lấy roster theo hiệu lực Enrollment tại thời điểm buổi và kiểm tra giáo viên thực dạy. | UC20; BR02; BR08 | Chặn Student ngoài lớp và Teacher ngoài phân công. |
| FR-002 | THE SYSTEM SHALL chỉ nhận PRESENT, ABSENT_EXCUSED, ABSENT_UNEXCUSED, LATE, với ghi chú tùy chọn, actor/time. Thao tác chọn hàng loạt (đánh dấu tất cả có mặt/đặt lại) trên giao diện phải hoạt động tin cậy, đồng bộ trạng thái radio, nhãn visual (.is-active) và bảng chỉ số metrics, không bị triệt tiêu bởi JSP Expression Language. | M07; UC20 | Status sai bị chặn; dòng chưa chọn không tự là PRESENT; nút chọn hàng loạt cập nhật tức thì mọi học viên. |
| FR-003 | THE SYSTEM SHALL có tối đa một Attendance/session/student; lặp request không nhân bản, sửa phiên bản cũ báo xung đột. | BR08; QG06 | Double-click không trùng; hai người sửa không mất thay đổi nhau; loại trừ trùng lặp studentId trước khi persist. |
| FR-004 | WHEN bắt đầu/hoàn tất, THE SYSTEM SHALL kiểm tra ngày/trạng thái buổi; chỉ hoàn tất khi đủ roster; không ghi buổi CANCELLED/RESCHEDULED. Hành động chốt hoàn tất ca học phải gửi kèm toàn bộ dữ liệu điểm danh hiện hành trên form để lưu và chuyển COMPLETED nguyên tử trong một luồng giao dịch, chặn gửi khi còn học viên chưa điểm danh. | WF-02; UC20 | Buổi tương lai không COMPLETED; roster còn học viên chưa chọn bị chặn ngay tại client; chốt hoàn tất tự động lưu điểm danh và đóng ca thành công. |
| FR-005 | WHILE COMPLETED, THE SYSTEM SHALL cho phép ADMIN và giáo viên thực dạy của buổi đó sửa chuyên cần/nhật ký; mọi lần sửa ghi audit. Giáo viên khác vẫn bị chặn. | BR16; BR18; UC20 | Teacher thực dạy sửa được buổi COMPLETED; teacher không phụ trách bị chặn; có lịch sử audit. |
| FR-006 | WHEN lưu journal (P1), THE SYSTEM SHALL có tối đa một journal/buổi, lưu nội dung, bài tập, nhận xét và tác giả theo quyền. | UC21; M07 | Tra cứu lại đúng nội dung; chưa có journal báo chưa cập nhật. |
| FR-007 | THE SYSTEM SHALL tính chuyên cần theo D11, hiển thị số có mặt/vắng/thiếu và mẫu số bên cạnh tỷ lệ. | M07; M11; D11 | PRESENT+LATE chia COMPLETED đủ điều kiện; mẫu số 0 báo chưa có dữ liệu. |
| FR-008 | THE SYSTEM SHALL chỉ công bố chuyên cần/journal cho người học sau COMPLETED và áp dụng liên kết giám hộ hiện hành. | WF-02; BR15 | Parent khác không đọc được; buổi IN_PROGRESS không lộ bản ghi dở. |
| FR-009 | IF lưu nhiều dòng/journal lỗi, THE SYSTEM SHALL rollback cả lần lưu và không hoàn tất buổi một phần. | UC20; QG06 | Không có COMPLETED với roster thiếu do lỗi giữa giao dịch. |

### Key Entities

- Attendance: trạng thái Student trong một buổi.
- TeachingJournal: nội dung/bài tập/nhận xét buổi.
- ClassSession: người thực dạy và hoàn tất.
- EnrollmentHistory: nguồn roster theo ngày, không suy từ trạng thái hiện tại.

### State & Business Rules

SCHEDULED→IN_PROGRESS→COMPLETED; CANCELLED/RESCHEDULED không nhận điểm danh. Chỉnh bản chốt là correction có audit, không hard delete. D11 là công thức chung.

**Business rules:** BR02, BR08, BR15, BR16, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** TCH-03, TCH-04. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. Bảng roster có mã/tên và bốn trạng thái; lưu và hoàn tất riêng biệt; journal phân biệt nháp/đã công bố.

## Success Criteria

- **SC-001:** 0 Attendance trùng trong 20 lần gửi lặp/đồng thời cùng cặp.
- **SC-002:** 100% tỷ lệ đối soát được với roster lịch sử và buổi COMPLETED.
- **SC-003:** 0 bản ghi ngoài quyền lọt sang Teacher/Student/Parent khác.

## Assumptions

- Mở buổi từ ngày diễn ra, không tự đặt cửa sổ 15/30 phút chưa được SRS yêu cầu.
- Journal là văn bản; không upload/nộp bài.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Cần class-timetable và enrollment-history; portal/reporting đọc cùng công thức. P1 notifications không là điều kiện commit điểm danh P0.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
