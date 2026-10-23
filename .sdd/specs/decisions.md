# Quyết định thống nhất đặc tả EduCenter

**Baseline:** 2026-10-23 | **Nguồn:** SRS v1.1, AGENTS.md, constitution và design.md.

Các quyết định dưới đây cụ thể hóa chỗ SRS còn để mở để có thể viết và kiểm thử spec. Đây là giả định triển khai của baseline nội bộ do chủ dự án yêu cầu, không phải xác nhận của khách hàng hay giảng viên. Thay đổi chính sách phải cập nhật quyết định, spec liên quan và truy vết trước khi sửa code.

| ID | Vấn đề | Quyết định và lý do | Ảnh hưởng |
|---|---|---|---|
| D01 | 6 vai trò nghiệp vụ / 5 mã trong dự án | Giữ đủ System Admin, Center Manager, Staff, Teacher, Student, Parent về trách nhiệm. MVP gộp hai trách nhiệm đầu vào `ADMIN`, như SRS II cho phép và constitution SEC-02 đã khóa; 5 mã là ADMIN, STAFF, TEACHER, STUDENT, PARENT. Không tạo MANAGER riêng trong baseline này. | M02, M11, M12; ma trận quyền dùng 5 mã, mọi quyền Manager trong SRS ánh xạ ADMIN. |
| D02 | P0 và P1 | Đặc tả đủ 35 UC: **31 P0 + 4 P1**. P1 là UC18, UC21, UC28, UC35; giữ nguyên phân loại tại SRS V. Không coi câu “35 use cases P0” trong tài liệu cũ là phân loại. | Release MVP bắt buộc 31 UC P0; P1 vẫn có spec và kiểm thử riêng. |
| D03 | Coupon đã bị bỏ nhưng SRS có Discounts | Giỏ công khai chỉ cộng phí niêm yết, mỗi khóa một lựa chọn. Không coupon/combo/giá gốc giả. Finance giữ Discounts để ADMIN duyệt ưu đãi khi lập hóa đơn; STAFF chỉ áp dụng ưu đãi đã được duyệt, không tự đặt mức giảm. | M01, M09; không xóa schema hoặc lịch sử tài chính. |
| D04 | Thông tin minh họa và link reset trong đợt sửa cũ | Ba ngoại lệ trong feat-portal-cart-repair chỉ là phạm vi nghiệm thu lịch sử của đợt sửa đó. Baseline sản phẩm mới tuân thủ AGENTS.md hiện tại: không số liệu giả, demo helpers, tự nhận đã có 2FA, link reset hiển thị trực tiếp hoặc chứng nhận chưa có. Không triển khai 2FA/device management vì SRS chưa yêu cầu; ẩn chức năng chưa có. | M01, M02; viết spec mới không tự sửa UI đang chạy. |
| D05 | Khóa/chương trình học | `Subjects` là môn; `Courses` là một chương trình/khóa có khối, trình độ, mục tiêu, thời lượng và phí. Không tự thêm bảng Programs chỉ vì hai cách gọi. Một Course có nhiều Classes; Class là đợt tổ chức cụ thể. | M01, M04, M05. |
| D06 | Mô hình và học phí | Một cơ sở; lớp GROUP hoặc ONE_TO_ONE (capacity=1). MVP tính phí trọn khóa, VND, chính xác 2 chữ số thập phân; cho trả nhiều đợt. Theo tháng/theo buổi, trả trước, payroll và ngân hàng thật nằm ngoài MVP. | M05, M09; chính sách phí được chụp tại thời điểm phát hành hóa đơn. |
| D07 | Giỏ và người thụ hưởng | Quantity luôn bằng 1; cập nhật ghi chú/nhu cầu thay cho tăng số lượng, đáp ứng chức năng tương đương ASM 3.6. Guest dùng session, tài khoản dùng DB; đăng nhập hợp nhất một lần. Parent gửi nhu cầu nhiều con qua các yêu cầu riêng, mỗi ghi danh chỉ cho một Student. | UC08, UC09, UC17; gửi yêu cầu không tự cấp quyền giám hộ/ghi danh. |
| D08 | Lịch và xung đột | Múi giờ nghiệp vụ Asia/Ho_Chi_Minh; buổi học không qua nửa đêm. Hai buổi tiếp giáp được phép; chồng lấn khi cùng ngày và newStart < existingEnd AND newEnd > existingStart. Chặn xung đột giáo viên/phòng tuyệt đối. Chỉ ADMIN được duyệt ngoại lệ trùng lịch học viên cho các cặp buổi cụ thể, có lý do và audit; đổi lịch phải xét lại. | BR05–BR07; không có nút “bỏ qua tất cả”. |
| D09 | Lớp nhận ghi danh | Chỉ Classes OPEN hoặc ONGOING, Courses OPEN và hồ sơ hoạt động mới nhận ghi danh. PLANNING chưa nhận; CLOSED/CANCELLED không nhận. Sĩ số lấy từ Enrollments ACTIVE, không có bộ đếm trừ chỗ độc lập. | UC15–UC18, BR03, BR04, BR19. |
| D10 | Bảo lưu/chuyển lớp | RESERVED không giữ chỗ; quay lại phải kiểm tra lại chỗ/lịch. Chuyển lớp tạo Enrollment đích, giữ Enrollment cũ TRANSFERRED và liên kết lịch sử. Không chuyển/hoàn học phí ngầm; điều chỉnh được ADMIN duyệt và ghi sổ cùng giao dịch chuyển nếu có. | UC18 P1, M09. |
| D11 | Chuyên cần | Với một giai đoạn, mẫu số là các buổi COMPLETED mà Student có Enrollment ACTIVE tại thời điểm buổi diễn ra. PRESENT và LATE được tính có mặt; thiếu điểm danh tính chưa có mặt và hiển thị số thiếu riêng. ABSENT_EXCUSED vẫn là vắng. Không có buổi hợp lệ: tỷ lệ “Chưa có dữ liệu”, không chia 0. | M07, portal, M11; cần lịch sử hiệu lực Enrollment. |
| D12 | Điểm và tiến bộ | Điểm được chuẩn hóa score/max_score*10 trước khi so sánh giữa thang. Điểm trung bình có trọng số, chỉ dùng bài PUBLISHED và điểm đã nhập; không biến thiếu điểm thành 0. Đầu vào là bài ENTRANCE đã công bố sớm nhất của học viên trong khóa; TrialAssessment CRM không tự trở thành điểm công bố. | M03, M08, M11. |
| D13 | Thông báo | P1 là thông báo trong ứng dụng, gửi thủ công hoặc sinh từ sự kiện đã commit; không gửi email/SMS/Zalo tự động ở MVP. Email khôi phục mật khẩu là kênh bảo mật riêng, cần SMTP cấu hình thật. | UC28, M02; sự cố thông báo không làm mất giao dịch nghiệp vụ. |
| D14 | Q&A | Guest chỉ đọc nội dung công khai APPROVED; Student/Parent đặt câu hỏi. Teacher chỉ trả lời nội dung khóa/lớp được giao; STAFF/ADMIN trả lời và duyệt. Không tự duyệt nội dung mình viết; cần người duyệt khác. Nội dung tài chính/hồ sơ cá nhân gửi riêng, không công khai. | UC29, UC30, BR02, BR15, BR17. |
| D15 | Chốt dữ liệu tài chính | Chỉ CASH/BANK_TRANSFER ghi nhận thủ công. Payments gốc không sửa/xóa; điều chỉnh, hủy thu và hoàn tiền là bút toán bù có người duyệt, lý do, tham chiếu. Không dùng trạng thái REFUNDED để làm mất cả khoản thu khi chỉ hoàn một phần. | M09; xem data-contract.md và integration.md. |
| D16 | SRS là đề xuất; schema chưa đủ | SRS có 30 bảng nghiệp vụ đề xuất; schema hiện có thêm PasswordResetTokens. Tên bảng cũ được giữ, các trường/bảng hỗ trợ thiếu được nêu rõ là yêu cầu migration, không tuyên bố đã tồn tại. Không chạy migration trong đợt viết spec. | Toàn dự án; data-contract.md phân biệt hiện tại/đích. |
| D17 | Bằng chứng hoàn thành | Locked nghĩa là baseline đặc tả nội bộ đã cố định để lập kế hoạch; không có nghĩa code đã xong, khách hàng đã ký hoặc giảng viên đã duyệt. Checklist triển khai cũ chỉ áp dụng phiên bản lúc đó. | README, future-work, các task/plan lịch sử. |
| D18 | Tự động liên kết Phụ huynh - Học sinh qua Email | Khi phụ huynh đăng ký tài khoản (role PARENT) kèm email học sinh, nếu email khớp với học sinh đã tồn tại trong hệ thống thì tự động tạo hồ sơ Guardian và thiết lập liên kết verified trong StudentGuardians; giúp phụ huynh theo dõi con ngay lập tức mà không cần chờ duyệt thủ công. Nếu cung cấp email học sinh không tồn tại, hệ thống báo lỗi rõ ràng; nếu để trống, tài khoản phụ huynh vẫn được tạo và liên kết sau qua nhân viên. | M02, M06; tối ưu trải nghiệm đăng ký phụ huynh dựa trên định danh email học sinh. |
| D19 | Loại bỏ tính năng Diễn đàn Hỏi đáp Q&A (feat-notifications-qa) | Theo yêu cầu của Product Owner (2026-10-24): Loại bỏ hoàn toàn tính năng Diễn đàn Hỏi đáp Q&A (UC29, UC30; màn hình COM-01, COM-02, ADM-17; luồng FLOW-07) ra khỏi phạm vi dự án để tinh gọn hệ thống và tập trung tuyệt đối vào học vụ, CRM và tài chính. Bảng CSDL hiện có giữ nguyên để đảm bảo tương thích schema, không triển khai controller/view và không đưa vào checklist nghiệm thu. | UC29, UC30, COM-01, COM-02, ADM-17 được chuyển sang trạng thái CANCELLED / OUT OF SCOPE. |

## Các câu hỏi SRS XV được cụ thể hóa

| Câu | Giả định baseline / ranh giới |
|---|---|
| 1 | Cả GROUP và ONE_TO_ONE, một cơ sở (D06). |
| 2 | Phí trọn khóa, trả nhiều đợt (D06). |
| 3 | Có học thử/đầu vào ở CRM; học bù ở lịch; bảo lưu UC18 P1 (D10). |
| 4 | Giáo viên có thể dạy nhiều môn/lớp, không trùng lịch. |
| 5 | Parent chỉ gửi nhu cầu và xem phí; STAFF ghi danh/ghi nhận thanh toán. |
| 6 | Một STAFF chung, chưa tách tư vấn/học vụ/kế toán; quyền phê duyệt thuộc ADMIN. |
| 7 | WAR chạy Tomcat 10.1 với SQL Server; địa chỉ máy chủ/certificates là cấu hình bàn giao, không giả định đã online. |
| 8 | Không import Excel ở MVP; có script khởi tạo và dữ liệu kiểm thử riêng. |
| 9 | Thông báo trong app; không tích hợp SMS/Zalo; SMTP chỉ dùng reset (D13). |
| 10 | Điều chỉnh/hoàn thủ công theo phê duyệt, không tự tính chính sách hoàn theo số buổi (D10, D15). |

## Ngoài phạm vi

Nhiều chi nhánh, video learning, AI chấm bài, payroll, native mobile, cổng thanh toán thật, 2FA, quản lý thiết bị, import Excel và CRM nâng cao. Các nội dung giai đoạn 2 trong SRS XVI được lưu ở đây để không bị hiểu là bị bỏ sót hoặc đã thuộc MVP.
