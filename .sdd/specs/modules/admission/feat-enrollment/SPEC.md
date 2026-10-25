# Feature Specification: Ghi danh, chuyển lớp, bảo lưu và lịch sử học

**Feature:** `feat-enrollment` | **Module SRS:** M03, M05, M06, M09 | **Owner:** Member 02; Member 03 lập hóa đơn trong giao dịch chung
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 WF-01, V UC17/18, VI BR03/04/07/19, VIII ADM-12; **Use cases:** UC17, UC18.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Ghi danh là điểm nối tuyển sinh, học vụ và tài chính: chỉ một thao tác hợp lệ mới tạo chỗ học, hóa đơn và lịch sử nhất quán.

**Trong phạm vi:** Ghi danh P0, xử lý lớp đầy/trùng/lịch và tranh chấp, chuyển Lead đúng một lần; chuyển lớp/bảo lưu/quay lại/nghỉ/kết thúc UC18 P1.

**Ngoài phạm vi:** Student/Parent tự ghi danh, giữ chỗ qua cart, thu tiền online, tự hoàn/chuyển phí theo số buổi chưa có chính sách.

**Actors & Permissions:** STAFF/ADMIN ghi danh/quản lý; ADMIN duyệt ngoại lệ lịch học viên và điều chỉnh tài chính. Student/Parent chỉ gửi nhu cầu và xem kết quả.

## User Scenarios & Testing

### User Story 1 — Ghi danh và hóa đơn (Priority: P0)

Là STAFF, tôi muốn ghi danh học viên đủ điều kiện để hệ thống lập hóa đơn đồng bộ.

**Giá trị/ưu tiên:** Luồng cốt lõi WF-01.

**Independent Test:** Ghi danh một học viên, tra Enrollment/Invoice rồi gây lỗi lúc lập hóa đơn.

**Acceptance Scenarios:**
1. Given Student hợp lệ và lớp OPEN còn chỗ/lịch phù hợp, When ghi danh, Then có một ACTIVE Enrollment và một hóa đơn ban đầu.
2. Given lỗi tạo Invoice, When transaction kết thúc, Then không Enrollment mới, không tăng sĩ số và không chuyển Lead ENROLLED.

### User Story 2 — Tranh chỗ cuối và submit lặp (Priority: P0)

Là STAFF, tôi muốn thao tác lặp hoặc đồng thời không vượt sĩ số/thu hai lần.

**Giá trị/ưu tiên:** Bảo vệ BR03/04.

**Independent Test:** Hai người ghi hai học viên vào chỗ cuối, sau đó replay cùng request.

**Acceptance Scenarios:**
1. Given còn một chỗ, When hai request đồng thời, Then chỉ một ghi danh thành công.
2. Given request đã thành công, When gửi lại cùng khóa, Then trả lại Enrollment/Invoice cũ.

### User Story 3 — Chuyển và bảo lưu (Priority: P1)

Là STAFF, tôi muốn quản lý chuyển/bảo lưu giữ lịch sử để không mất dữ liệu học phí/học tập.

**Giá trị/ưu tiên:** Đặc tả đủ UC18 sau P0.

**Independent Test:** Chuyển lớp, bảo lưu, lấp chỗ cũ và thử quay lại.

**Acceptance Scenarios:**
1. Given lớp đích hợp lệ, When chuyển được duyệt, Then Enrollment cũ TRANSFERRED, đích ACTIVE, lịch sử và điều chỉnh phí được giữ.
2. Given RESERVED không giữ chỗ, When lớp đã đầy và quay lại, Then từ chối, không lấy chỗ của học viên khác.

### Edge Cases

- Cùng Student/lớp lặp request; một ACTIVE hoặc RESERVED đã có; lớp PLANNING/CLOSED/CANCELLED.
- Hai lớp nhận cùng Student gây xung đột; hai request nhận chỗ cuối; khóa đóng giữa kiểm tra và commit.
- Phí đổi trước phát hành, ưu đãi chưa duyệt, ngày bắt đầu sai; Student không User.
- Chuyển khác Course, đang có công nợ, lịch sử điểm danh/điểm trước chuyển; lỗi điều chỉnh phí.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | WHEN ghi danh, THE SYSTEM SHALL kiểm tra actor, Student đủ điều kiện, Course OPEN, Class OPEN/ONGOING và ngày bắt đầu trong kỳ lớp. | UC17; WF-01; BR02; BR19 | Chặn lớp PLANNING/CLOSED/CANCELLED, Student không hợp lệ và ngày sai. |
| FR-002 | THE SYSTEM SHALL chặn Enrollment trùng Student/Class khi cũ ACTIVE hoặc RESERVED, kể cả request đồng thời. | UC17; BR03 | Không thêm bản hiệu lực mới; thông báo và link bản ghi hiện có trong quyền. |
| FR-003 | THE SYSTEM SHALL đếm ACTIVE dưới khóa Class ổn định và không vượt capacity; Student cũng được khóa khi kiểm tra lịch/ghi danh. | UC17; BR04; BR07 | Hai học viên tranh một chỗ: đúng một thành công; hai lớp trùng cho cùng Student không cùng lọt. |
| FR-004 | THE SYSTEM SHALL kiểm tra toàn bộ buổi tương lai theo hiệu lực và chặn xung đột Student chưa có ngoại lệ ADMIN cho cặp buổi cụ thể. | UC17; BR07; D08 | Không chỉ kiểm tra buổi đầu; không có bypass do STAFF gửi allowConflict. |
| FR-005 | WHEN commit ghi danh, THE SYSTEM SHALL tạo ACTIVE Enrollment, lịch sử hiệu lực và hóa đơn ban đầu có items/snapshot phí trong một giao dịch; nếu từ Lead thì cập nhật liên kết/chuyển ENROLLED cùng giao dịch. | UC17; WF-01; M09 | Lỗi ở bất kỳ bước/audit nào rollback toàn bộ; không nested commit finance. |
| FR-006 | THE SYSTEM SHALL dùng khóa yêu cầu gắn actor/phạm vi để replay trả cùng kết quả; request khác cùng Student/Class vẫn chịu kiểm tra trùng. | UC17; QG06 | Double-click/retry không nhân Invoice; cùng key khác payload bị từ chối. |
| FR-007 | WHEN bảo lưu (P1), THE SYSTEM SHALL lưu lý do/ngày hiệu lực, chuyển RESERVED, không giữ chỗ và giữ toàn bộ lịch sử/học phí. | UC18; D10; BR16 | Roster tương lai không có học viên bảo lưu; buổi đã học vẫn có. |
| FR-008 | WHEN quay lại (P1), THE SYSTEM SHALL kiểm tra chỗ/lịch/trạng thái lớp như ghi danh mới trước chuyển RESERVED→ACTIVE. | UC18; BR04; BR07 | Lớp đầy không quay lại được; không tạo hóa đơn ban đầu thứ hai. |
| FR-009 | WHEN chuyển lớp (P1), THE SYSTEM SHALL khóa Student và hai Class theo thứ tự ổn định, kiểm tra đích, tạo Enrollment đích, kết thúc bản cũ TRANSFERRED và liên kết lịch sử nguyên tử. | UC18; BR03; BR04; BR16 | Lỗi đích hoặc tài chính giữ nguyên lớp cũ; không khoảng hiệu lực chồng sai. |
| FR-010 | WHEN chuyển/bảo lưu có thay đổi phí (P1), THE SYSTEM SHALL yêu cầu ADMIN duyệt số tiền/lý do và ghi bút toán bù cùng transaction; không tự xóa/nạp lại Invoice/Payment. | UC18; M09; BR12; BR18 | Không sinh khoản thu/chênh lệch ngầm; nghĩa vụ phí khớp quyết định được duyệt. |
| FR-011 | THE SYSTEM SHALL ghi DROPPED/COMPLETED cùng ngày hiệu lực/lý do khi nghỉ/kết thúc và không xóa Enrollment; roster/tiến bộ vẫn truy lịch sử. | M06; UC18; BR16 | Không mất điểm/buổi cũ; dư nợ không tự biến mất. |
| FR-012 | WHEN Student có User liên kết hợp lệ, THE SYSTEM SHALL cho truy lớp vừa ghi danh theo quyền hiện có; không tự liên kết Guardian hoặc gán role quản trị. | WF-01; BR02; BR15 | Student không User vẫn ghi danh; Parent chưa verified không được xem. |
| FR-013 | WHEN chọn học viên ghi danh, THE SYSTEM SHALL hiển thị đúng khóa học học viên đăng ký và chỉ lọc danh sách các lớp học thuộc khóa học đó còn chỗ trống (`currentEnrolled < capacity`) và có lịch trống không xung đột. Nếu khóa học không có lớp học nào thỏa mãn, THE SYSTEM SHALL hiển thị thông báo rõ ràng cho nhân viên/admin biết để tạo lớp học mới kèm đường dẫn nhanh tới trang quản lý lớp. | UC17; BR04; BR07 | Lớp hiển thị đúng khóa học đăng ký; không có lớp trống thì báo lỗi/hướng dẫn tạo lớp. |
| FR-014 | WHEN thực hiện ghi danh, THE SYSTEM SHALL bắt buộc kiểm tra điều kiện nộp tiền học phí. Nếu học viên chưa nộp tiền (hoặc chưa xác nhận thu đủ học phí), THE SYSTEM SHALL chặn ghi danh và hiển thị thông báo bắt buộc nộp tiền. Khi xác nhận thu tiền (tiền mặt hoặc chuyển khoản có mã tham chiếu), hệ thống tạo Enrollment ACTIVE, hóa đơn PAID và bản ghi Payment đồng thời trong cùng một transaction. | UC17; BR11; BR12 | Chưa nộp tiền: chặn ghi danh và báo lỗi; Đã nộp tiền: tạo Enrollment, Invoice PAID và Payment thành công. |
| FR-015 | THE SYSTEM SHALL hỗ trợ cả nhân viên (`STAFF`) và quản trị viên (`ADMIN`) truy cập toàn diện tính năng ghi danh và xếp lớp tại các route `/staff/enrollments*` và `/admin/enrollments*`. | UC17; ADM-12 | Cả Admin và Staff đều có quyền ghi danh, xem danh sách và nhận phản hồi đồng bộ. |

### Key Entities

- Enrollment: một Student trong một Class với trạng thái, ngày hiệu lực và nguồn Lead.
- EnrollmentHistory: các khoảng học thật phục vụ roster lịch sử.
- Invoice/InvoiceItem: nghĩa vụ phí ban đầu do finance lập cùng transaction.
- Transfer link và FinancialAdjustment: giữ nguồn/đích và quyết định phí có duyệt.

### State & Business Rules

ACTIVE→RESERVED/TRANSFERRED/DROPPED/COMPLETED; RESERVED→ACTIVE sau kiểm tra hoặc DROPPED. TRANSFERRED/DROPPED/COMPLETED là lịch sử đóng; đăng ký đợt mới tạo bản mới có kiểm tra. ACTIVE mới chiếm chỗ; RESERVED vẫn chặn bản hiệu lực trùng cùng lớp. Chi tiết D09/D10.

**Business rules:** BR02, BR03, BR04, BR07, BR12, BR15, BR16, BR18, BR19. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-12. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-12 lọc Student/Course/Class từ DB, hiển thị chỗ hiện tại/phí dự kiến và lỗi xung đột; sau thành công tới ADM-15. Chuyển/bảo lưu gắn nhãn P1 và chỉ bật khi đã triển khai.

## Success Criteria

- **SC-001:** 0 lần vượt capacity hoặc trùng Enrollment hiệu lực trong 20 cặp request cạnh tranh.
- **SC-002:** Mỗi ghi danh mới thành công có đúng một hóa đơn ban đầu; mọi lỗi giữa giao dịch để lại 0 bản ghi dở.
- **SC-003:** 100% roster lịch sử và công nợ giữ đúng sau chuyển/bảo lưu/nghỉ.

## Assumptions

- Phí trọn khóa, không tự chia theo buổi; ưu đãi finance cần duyệt.
- Không dùng cập nhật counter Class làm nguồn sĩ số duy nhất.
- Chuyển khác khóa dùng phí/số chênh được ADMIN duyệt tường minh, không kế thừa coupon giỏ.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Cần auth, Student/Guardian, khóa/lớp/lịch. Finance cung cấp hàm lập hóa đơn dùng EntityManager/transaction của luồng ngoài; không commit riêng. Lịch sử/khóa chống tranh chấp tại integration.md.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
