# Feature Specification: Cổng học viên và phụ huynh với dữ liệu thật

**Feature:** `feat-student-parent-portal` | **Module SRS:** M06, M07, M08, M09, M10 | **Owner:** Member 02; Member 01/03 cung cấp dữ liệu
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 II, WF-05, V UC19/24/27, VIII STD-01/02/03, PAR-01/02, FLOW-05; **Use cases:** UC19, UC24, UC27.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Student và Parent cần xem cùng nguồn dữ liệu lịch, chuyên cần, kết quả và phí mà không thấy dữ liệu người khác hoặc thông tin minh họa.

**Trong phạm vi:** Dashboard cá nhân, chọn con đã xác thực, lớp/lịch, điểm công bố/tiến bộ/chuyên cần/nhật ký, tóm tắt học phí và link Q&A/thông báo.

**Ngoài phạm vi:** Tự ghi danh, trả phí online, sửa điểm/điểm danh, 2FA/device demo, số liệu home showcase tĩnh.

**Actors & Permissions:** STUDENT chỉ hồ sơ User liên kết; PARENT chỉ con verified chưa revoked. ADMIN được đọc quản trị có audit theo nghiệp vụ, không giả đăng nhập người khác. Teacher/Staff dùng màn hình riêng.

## User Scenarios & Testing

### User Story 1 — Học viên xem tiến độ (Priority: P0)

Là Student, tôi muốn xem lịch và kết quả thật để theo dõi việc học.

**Giá trị/ưu tiên:** Hoàn tất trải nghiệm sau ghi danh.

**Independent Test:** Ghi danh, hoàn tất buổi và công bố điểm, đọc Student portal.

**Acceptance Scenarios:**
1. Given hồ sơ đã liên kết, When mở dashboard/lịch, Then chỉ thấy lớp theo hiệu lực và lịch mới nhất.
2. Given một điểm DRAFT và một PUBLISHED, When mở tiến bộ/chart, Then chỉ điểm công bố xuất hiện.

### User Story 2 — Phụ huynh chọn con (Priority: P0)

Là Parent, tôi muốn chuyển giữa các con đã xác thực để theo dõi đúng từng học viên.

**Giá trị/ưu tiên:** Cô lập dữ liệu theo con.

**Independent Test:** Liên kết hai con và thu hồi một quan hệ khi portal đang mở.

**Acceptance Scenarios:**
1. Given hai con verified, When chọn một con, Then mọi lịch/điểm/phí đều thuộc con đó.
2. Given liên kết bị thu hồi, When đọc lại URL con, Then bị chặn và không dùng cache cũ.

### Edge Cases

- Student chưa có hồ sơ, Parent chưa có con; không có lớp/điểm/hóa đơn.
- Con chuyển/bảo lưu/nghỉ; buổi dời/hủy; zero denominator chuyên cần.
- Sửa childId/studentId/invoiceId trên URL; mất quyền giữa request; dữ liệu nguồn tải lỗi.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL dựng dashboard Student từ hồ sơ User liên kết, lớp/lịch/kết quả thực tế; không tự tạo hồ sơ hoặc KPI mặc định. | M06; STD-01; QG03 | Chưa có hồ sơ hiện hướng dẫn liên hệ trung tâm, không dữ liệu mẫu. |
| FR-002 | THE SYSTEM SHALL cho Parent chọn chỉ Student có liên kết verified chưa revoked và kiểm tra lại từng request. | WF-05; BR15; PAR-01 | childId đoán hoặc liên kết cũ không đọc được dashboard/detail/chart. |
| FR-003 | THE SYSTEM SHALL đọc lịch từ ClassSessions theo roster hiệu lực, phản ánh dời/hủy/dạy thay và giữ lịch sử lớp. | UC19; M05 | Giờ/phòng/người dạy khớp staff/teacher; buổi hủy hiển thị trạng thái. |
| FR-004 | THE SYSTEM SHALL hiển thị chuyên cần sau COMPLETED theo D11 cùng số buổi, mẫu số và thông tin thiếu. | M07; UC24 | Tỷ lệ khớp nguồn; không dữ liệu không hiển thị 0% giả. |
| FR-005 | THE SYSTEM SHALL chỉ hiển thị PUBLISHED scores, thang/ngày/nhận xét và tiến bộ D12, kể cả dữ liệu chart. | UC24; BR11 | Không lộ nháp trong HTML/JSON; thiếu mốc không tạo mức tăng. |
| FR-006 | THE SYSTEM SHALL hiển thị nhật ký/bài tập sau COMPLETED nếu P1 journal đã có; nếu chưa có thì báo chưa cập nhật. | UC21; M07 | Không dựng bài tập/thành tích mẫu; Student/Parent không sửa journal. |
| FR-007 | THE SYSTEM SHALL dùng cùng số phải thu/đã thu/còn nợ của finance, link đến tuition trong phạm vi người học đã chọn. | UC27; BR12; BR20 | Tóm tắt bằng tổng chi tiết; không cộng hóa đơn con khác. |
| FR-008 | THE SYSTEM SHALL giữ bộ lọc lớp/giai đoạn/con an toàn khi điều hướng và xóa lựa chọn con đã mất quyền. | WF-05; QG01 | Không dùng stale selection để truy cập nguồn. |
| FR-009 | THE SYSTEM SHALL cung cấp link Q&A/notifications đúng quyền, không lộ nội dung cá nhân qua câu hỏi công khai. | M10; BR02; BR15 | ID đối tượng ở link được tái kiểm tra; chức năng P1 chưa bật không có nút chết. |
| FR-010 | IF nguồn dữ liệu lỗi, THE SYSTEM SHALL phân biệt lỗi với empty; không tính tổng một phần như tổng toàn bộ. | QG03; QG12 | Phần lỗi hiện unavailable và không báo 0 hoặc “đã thanh toán đủ” sai. |

### Key Entities

- Student/Guardian/StudentGuardian: chủ thể và phạm vi hiện hành.
- Enrollment/ClassSession: lớp và lịch theo lịch sử.
- Attendance/TeachingJournal/PublishedScore: kết quả nguồn học vụ.
- Invoice/Payment/FinancialAdjustment: tóm tắt phí đọc từ finance, không tự tính khác.

### State & Business Rules

Portal chỉ đọc. Quyền giám hộ xét hiện hành dù dữ liệu học tập thuộc quá khứ. Không lấy trạng thái menu hoặc lựa chọn ở localStorage làm căn cứ phân quyền.

**Business rules:** BR02, BR11, BR12, BR15, BR20. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** STD-01, STD-02, STD-03, PAR-01, PAR-02. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. STD-01/02/03 và PAR-01/02 dùng shell theo vai trò, bộ chọn con rõ ràng, empty state cho từng phân khu, chart có bảng số liệu thay thế. STD-04/PAR-03 thuộc finance, COM-03 thuộc communication.

## Success Criteria

- **SC-001:** 0 dữ liệu nháp hoặc học viên ngoài liên kết xuất hiện qua trang/chart/link trực tiếp.
- **SC-002:** 100% lịch, chuyên cần, điểm và phí khớp nguồn trên bộ dữ liệu có đổi lịch/chuyển lớp/hoàn tiền.
- **SC-003:** Chưa có hồ sơ/con hoặc dữ liệu rỗng vẫn điều hướng được, không cần tài khoản/demo helpers.

## Assumptions

- Portal không có bảng nguồn thống kê riêng; dùng view DTO đã phân quyền.
- Không nhận mẫu HTML marketing làm dữ liệu học tập thật.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Phụ thuộc auth và student-guardian; đọc enrollment, lịch, attendance, assessment, finance; notifications là P1. Từng phân khu cần nguồn thật trước nghiệm thu, không mock để hoàn thành portal.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
