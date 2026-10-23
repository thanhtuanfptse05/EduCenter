# Feature Specification: Dashboard và báo cáo đối soát toàn trung tâm

**Feature:** `feat-dashboard-reporting` | **Module SRS:** M11 | **Owner:** Member 03
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M11, V UC31/32/33, VI BR20, VIII ADM-01/16, XVII 3.5; **Use cases:** UC31, UC32, UC33.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Quản lý cần thống kê lấy từ cùng dữ liệu vận hành để quyết định, không dùng KPI mẫu hoặc gộp tiền thu với nghĩa vụ chưa thu.

**Trong phạm vi:** KPI học viên/lớp/buổi, tuyển sinh, tài chính, chuyên cần/điểm, lớp đông/ít, khóa được đăng ký nhiều; MAX/MIN/AVG/SUM/COUNT và bộ lọc/thời điểm số liệu.

**Ngoài phạm vi:** Kho dữ liệu, dự báo AI, báo cáo thuế/lợi nhuận khi chưa có chi phí, KPI marketing bịa hoặc dữ liệu nhiều cơ sở.

**Actors & Permissions:** ADMIN (gồm trách nhiệm Manager) xem toàn trung tâm. STAFF đọc báo cáo nghiệp vụ được cấp qua màn hình staff; Teacher chỉ thống kê lớp mình ở TCH-05; Student/Parent xem portal riêng, không truy cập /admin/reports.

## User Scenarios & Testing

### User Story 1 — Thống kê tuyển sinh/học vụ (Priority: P0)

Là ADMIN, tôi muốn xem tuyển sinh và hoạt động lớp để đánh giá trung tâm.

**Giá trị/ưu tiên:** Bao phủ UC31/33 và ASM aggregates.

**Independent Test:** Tạo Lead đã/chưa chuyển, lớp có/không học viên, điểm nháp/công bố rồi lọc giai đoạn.

**Acceptance Scenarios:**
1. Given dữ liệu nguồn, When xem báo cáo, Then COUNT học viên/lớp và chuyển đổi khớp cohort.
2. Given lớp không có điểm, When tính AVG/MIN/MAX, Then hiện chưa có dữ liệu, không điểm giả 0.

### User Story 2 — Đối soát học phí (Priority: P0)

Là ADMIN, tôi muốn tách thu/phải thu/công nợ để biết số tiền thực tế.

**Giá trị/ưu tiên:** Bảo vệ BR20.

**Independent Test:** Dữ liệu hóa đơn, thu kỳ này, hoàn kỳ sau và báo cáo theo hai kỳ.

**Acceptance Scenarios:**
1. Given hóa đơn chưa thu, When xem dashboard, Then thuộc nghĩa vụ/nợ, không doanh thu đã thu.
2. Given hoàn kỳ sau, When xem tiền thu kỳ đó, Then trừ đúng hoàn theo ngày chi; báo cáo số dư đến kỳ không mất khoản thu gốc.

### Edge Cases

- Không Lead/học viên/buổi; lớp 0 học viên; AVG không có điểm.
- Một Invoice nhiều items/payments, nhiều Guardian, nhiều scores gây JOIN nhân tổng.
- Ngày đầu/cuối kỳ; thu và hoàn khác kỳ; thay trạng thái lịch sử.
- Teacher sửa classId báo cáo; nguồn lỗi giữa các card.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL cung cấp bộ lọc từ ngày/đến ngày, môn/khóa/lớp phù hợp và hiển thị phạm vi/thời điểm cập nhật cùng định nghĩa metric. | UC31–33; M11 | Đổi bộ lọc cập nhật bảng/card/chart đồng bộ; không gắn số liệu của kỳ khác. |
| FR-002 | THE SYSTEM SHALL COUNT học viên phân biệt, học viên mới theo created_at, lớp OPEN/ONGOING tại ngày chốt, buổi theo ngày/trạng thái. | M11; UC33; ASM 3.5 | Không nhân bản Student do nhiều Enrollment/Guardian; lớp 0 học viên vẫn có thể xuất hiện. |
| FR-003 | THE SYSTEM SHALL tính chuyển đổi theo cohort Lead tạo trong kỳ: số Lead cohort đã ENROLLED trước ngày chốt chia tổng Lead cohort; mẫu số 0 là chưa có dữ liệu. | UC31; M03 | Không dùng Enrollment trong kỳ chia Lead khác cohort; không đếm một Lead nhiều lần. |
| FR-004 | THE SYSTEM SHALL tách nghĩa vụ phát hành trong kỳ, tiền thu/hoàn/hủy theo ngày giao dịch và dư nợ tại ngày chốt theo finance contract. | UC32; BR12; BR20 | Hóa đơn chưa thu không vào collected; hoàn kỳ sau không sửa cashflow kỳ trước. |
| FR-005 | THE SYSTEM SHALL dùng SUM nghĩa vụ/thu/nợ; MAX/MIN/AVG phí khóa trong phạm vi chọn; MAX/MIN sĩ số lớp; COUNT Lead/Enrollment/Student. | M11; ASM 3.5 | Có bằng chứng đủ 5 hàm theo dữ liệu nguồn, không gắn nhãn aggregate lên số hardcode. |
| FR-006 | THE SYSTEM SHALL tính chuyên cần D11, điểm PUBLISHED theo D12 và chỉ trong phạm vi actor. | UC33; BR11 | Nháp không vào báo cáo; Teacher chỉ lớp được giao, kể cả data endpoint. |
| FR-007 | THE SYSTEM SHALL xếp hạng lớp đông/ít theo ACTIVE tại ngày chốt và khóa nhiều ghi danh theo Enrollment hợp lệ, có tie-break ID ổn định. | M11; UC31; UC33 | Cùng dữ liệu cho thứ tự ổn định; không trộn số lượt quan tâm cart với ghi danh. |
| FR-008 | THE SYSTEM SHALL tổng hợp từng tập nguồn trước khi JOIN và dùng snapshot nhất quán cho một lần xem; tổng có chi tiết đối soát. | UC31–33; QG12 | Invoice có 2 items/3 payments vẫn tính đúng, drill-down cộng bằng tổng. |
| FR-009 | IF nguồn lỗi, THE SYSTEM SHALL đánh dấu unavailable và không hiển thị tổng thiếu như tổng hoàn chỉnh; empty aggregate COUNT/SUM có thể là 0, MIN/MAX/AVG không có dữ liệu là chưa có dữ liệu. | M11; QG03 | Lỗi DB không hiện toàn bộ KPI=0; chart trống có bảng/nhãn phù hợp. |
| FR-010 | THE SYSTEM SHALL giới hạn báo cáo toàn trung tâm ở ADMIN, báo cáo Teacher ở lớp được giao; dữ liệu cá nhân tối thiểu và link chi tiết kiểm quyền lại. | UC31–33; BR02; BR15 | Teacher không lấy được tài chính hoặc lớp khác bằng query params. |

### Key Entities

- Reporting snapshot: kết quả tổng hợp có phạm vi và ngày chốt, không bản ghi KPI thủ công.
- Lead/Student/Enrollment/Class/Session: nguồn tuyển sinh và hoạt động.
- PublishedScore/Attendance: nguồn kết quả theo công thức chung.
- Invoice/Payment/FinancialAdjustment: nguồn tài chính tách nghĩa vụ và cashflow.

### State & Business Rules

Báo cáo chỉ đọc, dùng ngày hiệu lực/lịch sử để tính as-of. Không ghi giá trị tổng ở JSP/JS. Dữ liệu cũ thiếu lịch sử phải ghi giới hạn, không hứa tái dựng quá khứ chính xác.

**Business rules:** BR02, BR11, BR12, BR15, BR20. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-01, ADM-16. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-01 card/hoạt động thật, ADM-16 các tab và bảng chi tiết, chart có bảng số; liên kết theo metric dẫn đến danh sách đã lọc đúng quyền.

## Success Criteria

- **SC-001:** Đủ MAX/MIN/AVG/SUM/COUNT với 100% số liệu khớp bộ dữ liệu nguồn đối soát.
- **SC-002:** Không tổng nào bị nhân do JOIN nhiều items/payments/Guardian/score.
- **SC-003:** 0 dữ liệu nháp, tài chính hoặc lớp ngoài quyền lọt qua báo cáo/endpoint/drill-down.

## Assumptions

- Phân biệt báo cáo phát sinh trong kỳ và số dư đến ngày; không gọi cả hai là revenue.
- Mặc định tháng hiện tại theo Asia/Ho_Chi_Minh; khoảng ngày được tính trọn ngày cuối.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Cần nguồn hoàn chỉnh từ CRM, enrollment, lịch, attendance, assessment, finance. Không nghiệm thu dashboard chỉ bằng trang điều hướng hiện có. Teacher report được assessment cung cấp tại TCH-05.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
