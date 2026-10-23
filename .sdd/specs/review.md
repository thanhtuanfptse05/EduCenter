# Rà soát độ phủ và tính nhất quán đặc tả

**Ngày:** 2026-10-23 | **Phạm vi:** SRS v1.1 và baseline đặc tả mới. **Không phải audit toàn bộ implementation**.

## 1. Kết quả rà soát ngữ nghĩa

| Vấn đề phát hiện | Cách thống nhất trong baseline | Giới hạn còn phải giữ rõ |
|---|---|---|
| SRS6 trách nhiệm, code/constitution5 mã, module Finance cũ ghi6 mã | D01 ánh xạ Admin+Manager→ADMIN, giữ6 trách nhiệm và5 mã; mọi bảng quyền theo integration | Muốn tách MANAGER là thay đổi role/schema/filters/spec riêng, không giả vờ đã có |
| “35 use cases P0” trong constitution cũ | Giữ đúng SRS V:31P0+4P1 (UC18/21/28/35); không sửa constitution đã khóa chỉ để thay câu đếm | Đây là cách đọc theo danh sách UC nguồn; không tự xác nhận31P0 đã implement |
| Chỉ có auth/catalog/enrollment spec, còn module chung chưa đủ |15 spec lõi,2 UI hỗ trợ; mỗi FR có nguồn/kết quả nghiệm thu;55 ý module,35UC,20BR,30bảng,49screen được truy vết | Plan/tasks mới chưa được sinh cho toàn ERP; phải làm theo từng feature trước code |
| Mã màn hình/route design trùng hoặc khác SRS | screen-map giữ49 ID chuẩn, bảng alias prototype; một core owner/screen | Tên view/controller là hợp đồng đích, cần đối chiếu controller hiện hữu bằng CodeGraph khi plan |
| Lớp ACTIVE/CLOSED được dùng không nhất quán | Class chỉ PLANNING/OPEN/ONGOING/CLOSED/CANCELLED; ghi danh OPEN/ONGOING, Course OPEN; ACTIVE là Enrollment | Không thêm enum ngoài CHECK schema nếu không có migration đã đặc tả |
| Ưu đãi SRS vs bỏ coupon/combo | D03:public chỉ phí niêm yết; Finance có Discount nội bộ được ADMIN duyệt/snapshot | Không khôi phục coupon trên giỏ; không xóa lịch sử/schema để bỏ UI |
| Spec auth cũ có logout GET, reset15phút/lộ link, đoạn clarification khác | Auth v2 thống nhất POST logout, token30phút/hash-only/single-use/SMTP, response chung, revoke sessions | Code hiện tại còn ngoại lệ cũ; v2 là yêu cầu sửa, không lời khẳng định đã xong |
| Landing/footer v1 đòi3D/emoji, badge/uptime/chứng nhận/tiến độ giả |2 spec UI v2 theo design tokens/SVG/dữ liệu thật; legacy repair ghi rõ chỉ là lịch sử | Không sửa lại verification cũ thành đã nghiệm thu production mới |
| Dữ liệu StudentGuardian chỉ verified, thiếu thu hồi | verified+revoked và request scope chung cho portal/finance/notifications | Cần migration cột thu hồi; không tự xác thực từ đăng ký/email/phone |
| Roster theo trạng thái hiện tại gây mất lịch sử sau bảo lưu/chuyển | EnrollmentHistory theo khoảng hiệu lực; nguồn attendance/assessment/report dùng chung | Dữ liệu trước baseline thiếu lịch sử cần đối soát, không tự tái dựng bằng giả định |
| count ACTIVE trước INSERT hoặc @Version không chạm Class | Khóa Student/Class ổn định và unique DB, dùng chung với giảm capacity/đổi lịch | Cần SQL Server integration đồng thời thật; unit mocks không đủ |
| TrialAssessment và ClassSession có thể xếp trùng xuyên bảng | Cùng Teacher/Room resource locks và query cả hai nguồn; không hai hệ lịch riêng | Trial booking cần thêm thời gian/phân công/status vào schema |
| Invoice/Enrollment giao dịch riêng có thể ghi dở | Invoice factory nhận transaction ngoài; Enrollment/History/Invoice/Lead/audit/idempotency commit một lần | Chưa code tính năng nên chưa có bằng chứng rollback này đạt |
| Hoàn một phần bằng Payment.REFUNDED làm mất cả khoản thu | FinancialAdjustments append-only; công thức nghĩa vụ/thu ròng/nợ và migration legacy có đối soát | Không trừ hoàn hai lần; metadata thiếu không được bịa |
| AVG/tiến bộ so điểm khác thang hoặc tính nháp/thiếu thành0 | normalized về10, weighted AVG chỉ PUBLISHED đã nhập, thiếu mốc nêu rõ | Trial CRM không tự công bố thành điểm học tập |
| Q&A chỉ kiểm status con hoặc tự duyệt | Question+Answer đều APPROVED, PUBLIC, moderator khác tác giả; sửa về PENDING | Nội dung cá nhân chuyển PRIVATE có scope nguồn; không lộ qua search |
| Báo cáo JOIN nhân tổng hoặc trộn kỳ thu/phải thu | Aggregate riêng nguồn, snapshot, cohort Lead, cashflow theo ngày, balances as-of | Lịch sử trước baseline thiếu trạng thái phải ghi giới hạn |
| Chu trình phụ thuộc Enrollment↔Finance | implementation-order tách Invoice factory trước ghi danh, thu tiền sau | Không đánh dấu toàn UC25 xong khi mới có factory |

## 2. Kiểm tra cấu trúc và độ phủ

Validator `.sdd/scripts/validate_specs.py` đọc trực tiếp SRS, so UC/title/priority,55 ý module theo đúng thứ tự,30 bảng,49screens,20BR,FR tồn tại/được map, mandatory sections/checklists và local links của tài liệu baseline. Kết quả chạy được ghi trong báo cáo hoàn tất; không tự chèn “PASS” vào lịch sử test ứng dụng.

Checklist chất lượng từng spec đã review; checklist chỉ xác nhận tài liệu đáp ứng phần bắt buộc, không xác nhận các UAT/JPA/HTTP/browser/SMTP đã pass. Không sử dụng speckit-analyze/converge để tuyên bố nhất quán spec–plan–tasks–code vì chưa có plan/tasks mới đã implement cho toàn bộ feature.

## 3. Những việc còn lại đúng phạm vi triển khai

- Khóa/chốt chính sách với chủ trung tâm hoặc giảng viên khi vận hành/đánh giá: D06 học phí trọn khóa, D10 chuyển/bảo lưu, D15 hoàn/điều chỉnh và các giả định SRS XV. Baseline hiện đã chọn rõ để lập kế hoạch, không còn chỗ trống để agent tự suy khác.
- Lập plan/tasks theo thứ tự code; đồng bộ migrations/Entity/DTO/query trước khi mở UI; schema SRS30 bảng không đủ các yêu cầu bảo mật/lịch sử hiện hành nếu không có phần mở rộng đã ghi.
- Thay các ngoại lệ demo/reset của code hiện tại theo auth/catalog v2; đủ dữ liệu nguồn thì mới nghiệm thu portal/reporting. Không dùng trang dashboard điều hướng làm bằng chứng KPI/ERP đã chạy.
- Chạy unit + SQL Server integration + HTTP/browser/UAT trên môi trường riêng; ghi rõ môi trường không chạy được, không nâng trạng thái chỉ nhờ kiểm tài liệu.
- Khi triển khai đầy đủ cập nhật ERD/schema docs/url mapping/trạng thái thực tế và main. Hiện trạng source không được đổi trong đợt đặc tả này.
