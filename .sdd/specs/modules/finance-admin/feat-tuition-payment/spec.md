# Feature Specification: Học phí, hóa đơn, thanh toán và công nợ

**Feature:** `feat-tuition-payment` | **Module SRS:** M09 | **Owner:** Member 03
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M09, WF-04, V UC25/26/27, VI BR12–14/16/18/20, VIII ADM-14/15, STD-04, PAR-03; **Use cases:** UC25, UC26, UC27.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Nghĩa vụ học phí, tiền đã thu và công nợ phải đối soát được đến chứng từ nguồn; thu từng đợt và sửa sai không được làm mất lịch sử.

**Trong phạm vi:** Hóa đơn/items từ ghi danh, ưu đãi nội bộ được duyệt, thanh toán thủ công CASH/BANK_TRANSFER, biên lai, trả một phần, công nợ, hủy thu/điều chỉnh/hoàn có duyệt và xem phí theo quyền.

**Ngoài phạm vi:** Cổng ngân hàng thật, thẻ, VNPAY/MOMO integration, trả trước, coupon/combo public, hóa đơn điện tử thuế hoặc tự tính hoàn theo số buổi.

**Actors & Permissions:** STAFF/ADMIN lập/đọc hóa đơn và ghi nhận thu; ADMIN duyệt ưu đãi, điều chỉnh/hủy/hoàn. STUDENT chỉ phí của mình; PARENT chỉ con verified; Teacher không có quyền học phí.

## User Scenarios & Testing

### User Story 1 — Phát hành và thu từng đợt (Priority: P0)

Là STAFF, tôi muốn lập hóa đơn từ ghi danh và thu nhiều đợt để theo dõi số dư chính xác.

**Giá trị/ưu tiên:** Luồng WF-04.

**Independent Test:** Ghi danh phí 1.000.000, thu 400.000 rồi 600.000.

**Acceptance Scenarios:**
1. Given hóa đơn 1.000.000, When thu 400.000, Then PARTIALLY_PAID, đã thu 400.000, còn nợ 600.000.
2. Given còn nợ 600.000, When thu đủ, Then PAID; 600.001 bị từ chối.

### User Story 2 — Chống thu trùng và hoàn một phần (Priority: P0)

Là ADMIN, tôi muốn sửa sai bằng bút toán bù có dấu vết để sổ thu vẫn đối chiếu được.

**Giá trị/ưu tiên:** Toàn vẹn tài chính là điều kiện nghiệm thu.

**Independent Test:** Hai người cùng thu số dư; sau đó điều chỉnh giảm và hoàn một phần.

**Acceptance Scenarios:**
1. Given cùng số dư, When hai request thu đồng thời, Then không tổng thu vượt nghĩa vụ.
2. Given đã thu đủ 1.000.000, When ADMIN giảm nghĩa vụ 200.000 và hoàn 200.000 cùng quyết định, Then thu ròng/nghĩa vụ còn 800.000, dư nợ 0, khoản thu gốc không bị sửa.

### User Story 3 — Xem học phí liên quan (Priority: P0)

Là Parent, tôi muốn xem hóa đơn/biên lai của con để kiểm tra đã đóng và còn nợ.

**Giá trị/ưu tiên:** Cần cho WF-05.

**Independent Test:** Parent hai con xem từng con và thử invoiceId con khác.

**Acceptance Scenarios:**
1. Given quan hệ verified, When xem hóa đơn con, Then tổng/chi tiết/lịch sử khớp nguồn.
2. Given quan hệ bị thu hồi, When mở link biên lai cũ, Then không đọc được.

### Edge Cases

- Hóa đơn 0 đồng, giảm giá vượt tổng, ưu đãi hết hạn, chỉnh phí Course sau khi phát hành.
- Replay cùng key, trùng chứng từ chuyển khoản, số tiền 0/âm/nhiều hơn 2 số lẻ, hai thu đồng thời.
- Hoàn một phần/toàn bộ; hủy thu không có tiền ra; không ghi cả VOID và REFUND trên cùng phần tiền.
- Hóa đơn hủy còn tiền; Student chuyển/bảo lưu; báo cáo kỳ có thu và hoàn khác ngày.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | WHEN enrollment được tạo, THE SYSTEM SHALL phát hành duy nhất một hóa đơn ban đầu cùng transaction với items/snapshot phí và ngày đến hạn. | UC25; WF-01; M09 | Lặp gọi không nhân Invoice; lỗi Invoice rollback Enrollment. |
| FR-002 | THE SYSTEM SHALL tính gross=sum(items), discount theo chính sách đã duyệt và final=gross-discount; tiền VND chính xác, final≥0. | UC25; BR12; D06 | Đối soát đến 2 số lẻ; khóa miễn phí final=0 có PAID với collected=0. |
| FR-003 | WHEN dùng ưu đãi, THE SYSTEM SHALL chỉ cho STAFF chọn Discount ACTIVE trong ngày/hạn mức đã ADMIN duyệt; lưu snapshot điều kiện và mức giảm. | M09; Discounts; D03 | PERCENTAGE trong (0,100], FIXED_AMOUNT không vượt gross; không có coupon ở public. |
| FR-004 | THE SYSTEM SHALL tìm/lọc/page hóa đơn theo học viên/lớp/trạng thái/ngày đến hạn và phân biệt quá hạn là thuộc tính tính toán. | UC25; UC27 | Không tự thêm OVERDUE vào enum schema; quá hạn khi due_date<today và debt>0. |
| FR-005 | WHEN ghi thu, THE SYSTEM SHALL yêu cầu invoice còn hiệu lực, amount>0 và≤debt, CASH/BANK_TRANSFER, paid_at, confirmed_by/time và tham chiếu chuyển khoản. | UC26; BR13; BR14 | Chặn tiền sai, Teacher và chứng từ thiếu; cash có mã biên lai hệ thống duy nhất. |
| FR-006 | THE SYSTEM SHALL khóa Invoice trước tính số dư/ghi Payment, chống lặp theo khóa yêu cầu và tham chiếu ngân hàng đã dùng. | UC26; QG06; BR14 | Hai người thu số dư cuối chỉ một thành công; replay trả biên lai cũ, khác payload cùng key báo lỗi. |
| FR-007 | WHEN thu thành công, THE SYSTEM SHALL tạo Payment, mã biên lai và cập nhật trạng thái dẫn xuất/audit trong cùng transaction. | UC26; WF-04; BR18 | Lỗi audit/state rollback; không có biên lai thành công không có Payment. |
| FR-008 | THE SYSTEM SHALL tính nghĩa vụ/thu ròng/dư nợ theo công thức chung tại data-contract, không cộng tiền hủy/hoàn hai lần. | UC27; BR12; BR20 | UNPAID/PARTIALLY_PAID/PAID và tổng khớp mọi case điều chỉnh/hoàn. |
| FR-009 | WHILE hóa đơn đã phát hành, THE SYSTEM SHALL giữ bất biến snapshot/items/Payment gốc, không xóa vật lý. | M09; BR16 | Đổi Course fee hoặc thao tác hủy/hoàn không sửa/xóa số tiền lịch sử. |
| FR-010 | WHEN điều chỉnh nghĩa vụ hoặc hủy thu, THE SYSTEM SHALL yêu cầu ADMIN duyệt actor/time/reason, tham chiếu gốc và bút toán bù append-only. | WF-04; BR18; D15 | Tổng điều chỉnh đối chiếu được; không sửa Payment.status để xóa dấu vết giao dịch. |
| FR-011 | WHEN hoàn tiền, THE SYSTEM SHALL giới hạn tổng hoàn/hủy≤phần khoản thu chưa bù, lưu chứng từ chi và không để dư nợ âm; nếu cần giảm nghĩa vụ thì cùng quyết định/giao dịch. | WF-04; BR12; BR14; D15 | Hoàn một phần giữ thu gốc; hoàn lặp/vượt mức bị từ chối. |
| FR-012 | WHEN hủy hóa đơn, THE SYSTEM SHALL yêu cầu ADMIN, lý do, thu ròng=0 và đóng nghĩa vụ bằng bút toán hợp lệ; không xóa lịch sử. | BR16; UC25 | Hóa đơn còn thu ròng không hủy; Invoice CANCELLED không còn nợ hoạt động. |
| FR-013 | THE SYSTEM SHALL cho Staff xem toàn bộ theo nghiệp vụ, Student xem mình và Parent xem con verified; kiểm tra cả biên lai/print/link chi tiết. | UC27; BR02; BR15 | Sửa invoiceId/paymentId/childId không lộ dữ liệu khác. |
| FR-014 | THE SYSTEM SHALL tách tổng niêm yết/nghĩa vụ sau ưu đãi/điều chỉnh, tổng thu, hoàn/hủy thu, thu ròng và còn nợ. | M09; BR20 | Báo cáo/portal không gọi nghĩa vụ là tiền thu hoặc che khoản hoàn. |
| FR-015 | THE SYSTEM SHALL cung cấp biên lai nội bộ từ Payment thật, ghi rõ không phải xác nhận ngân hàng/hóa đơn thuế. | UC26; M09 | In lại không tạo Payment mới; không hiển thị tài khoản ngân hàng/certification giả. |

### Key Entities

- Invoice/InvoiceItem: nghĩa vụ trọn khóa tại thời điểm phát hành, tham chiếu Enrollment/Student.
- Discount: chính sách nội bộ có ngày/giới hạn và người duyệt.
- Payment: khoản thu gốc dương, xác nhận, phương thức/chứng từ.
- FinancialAdjustment: bút toán CHARGE/CREDIT/VOID_PAYMENT/REFUND có duyệt, tham chiếu hóa đơn/khoản thu.
- StudentGuardian: phạm vi đọc học phí hiện hành.

### State & Business Rules

Invoice UNPAID/PARTIALLY_PAID/PAID/CANCELLED; số dư và điều chỉnh quyết định trạng thái dẫn xuất. Payment gốc CONFIRMED giữ nguyên; CANCELLED/REFUNDED legacy phải được ánh xạ khi migration, không vừa loại khỏi tổng vừa trừ bút toán. Quy tắc chi tiết data-contract.

**Business rules:** BR02, BR12, BR13, BR14, BR15, BR16, BR18, BR20. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-14, ADM-15, STD-04, PAR-03. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-14 list công nợ, ADM-15 chi tiết/thu/biên lai/điều chỉnh; STD-04/PAR-03 chỉ đọc phí liên quan và liên kết thông báo. Bắt buộc xác nhận số tiền và đối tượng trước thao tác.

## Success Criteria

- **SC-001:** 100% bộ dữ liệu thu từng phần/đủ/miễn phí/hoàn/hủy/điều chỉnh đối soát chính xác đến 0,01 VND.
- **SC-002:** 0 lần vượt số dư hoặc Payment trùng trong 20 cặp request thu cạnh tranh/replay.
- **SC-003:** 0 Payment/Invoice gốc bị mất hoặc thay số tiền sau điều chỉnh; mọi bút toán có actor/time/reason.

## Assumptions

- Phí trọn khóa và ưu đãi không cộng dồn: tối đa một Discount/hóa đơn; thay chính sách sau phát hành dùng correction.
- Ngày đến hạn mặc định enrollment.start_date; ADMIN có thể cấu hình số ngày gia hạn cho lần phát hành mới.
- FinancialAdjustment/approval/idempotency là yêu cầu migration chưa có trong schema hiện tại.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Auth và Student/Guardian kiểm quyền; Enrollment truyền transaction ngoài. Portal/reporting dùng số dư do finance cung cấp. Chuyển lớp gọi finance adjustment cùng giao dịch, không commit lồng.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
