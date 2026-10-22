# EDUCENTER BUSINESS CONSTRAINTS (BR01 - BR20)
**Source:** EduCenter SRS v1.1 (Mục VI)  
**Scope:** Áp dụng trên toàn bộ tầng Service và JPA validation.

---

| Mã Rule | Tên Quy Tắc | Đặc Tả Chi Tiết (EARS Specification) |
|---|---|---|
| **BR01** | Unique Login Email | **THE SYSTEM SHALL** đảm bảo địa chỉ email đăng nhập của người dùng là duy nhất trên toàn hệ thống. Chuẩn hóa email về chữ thường trước khi kiểm tra và lưu trữ. |
| **BR02** | Strict RBAC | **THE SYSTEM SHALL** ngăn chặn mọi truy cập dữ liệu hoặc gọi thao tác nằm ngoài vai trò và quyền hạn được cấp. Kiểm tra cả ở Filter và tầng Service. |
| **BR03** | No Duplicate Active Enrollment | **THE SYSTEM SHALL** ngăn chặn học viên ghi danh trùng vào cùng một lớp học khi bản ghi ghi danh trước đó vẫn đang ở trạng thái hiệu lực (`ACTIVE`). |
| **BR04** | Class Capacity Limit | **WHILE** một lớp học đang mở ghi danh, **THE SYSTEM SHALL** đảm bảo số lượng học viên đang học (`ACTIVE`) không vượt quá sĩ số tối đa (`Classes.capacity`). Bắt buộc dùng transaction & kiểm soát đồng thời. |
| **BR05** | No Teacher Time Conflict | **THE SYSTEM SHALL** ngăn chặn một giáo viên có hai buổi dạy trùng hoặc chồng lấn thời gian. Điều kiện chồng lấn: `newStart < existingEnd AND newEnd > existingStart`. |
| **BR06** | No Room Time Conflict | **THE SYSTEM SHALL** ngăn chặn một phòng học có hai buổi học trùng hoặc chồng lấn thời gian (`newStart < existingEnd AND newEnd > existingStart`). |
| **BR07** | No Student Schedule Conflict | **THE SYSTEM SHALL** cảnh báo hoặc ngăn chặn học viên có hai lớp học trùng thời gian, trừ trường hợp được người quản lý duyệt ngoại lệ. |
| **BR08** | Single Attendance per Session | **THE SYSTEM SHALL** đảm bảo mỗi học viên trong một buổi học cụ thể chỉ có tối đa một bản ghi điểm danh (`Attendances(session_id, student_id)` là UNIQUE). |
| **BR09** | Authorized Grading Only | **THE SYSTEM SHALL** chỉ cho phép giáo viên được phân công giảng dạy lớp đó hoặc quản trị viên có thẩm quyền thực hiện nhập và chỉnh sửa điểm số. |
| **BR10** | Valid Score Range | **THE SYSTEM SHALL** đảm bảo điểm số nhập vào phải nằm trong thang điểm hợp lệ (`0 <= score <= max_score`, thường là thang 10). |
| **BR11** | Unpublished Score Privacy | **WHILE** bài kiểm tra hoặc điểm số chưa được công bố (`status != 'PUBLISHED'`), **THE SYSTEM SHALL** ẩn điểm đối với cổng học viên (`Student`) và phụ huynh (`Parent`). |
| **BR12** | Debt Calculation Rule | **THE SYSTEM SHALL** tính toán công nợ theo công thức: `Công nợ = Tổng số tiền phải thu (Invoices) - Tổng số tiền thanh toán hợp lệ (Payments)`. |
| **BR13** | Payment Verification Integrity | **THE SYSTEM SHALL** yêu cầu mọi giao dịch thanh toán phải ghi nhận nhân viên xác nhận (`confirmed_by`), thời điểm thanh toán (`paid_at`) và phương thức/mã tham chiếu. |
| **BR14** | No Overpayment | **WHEN** ghi nhận thanh toán, **THE SYSTEM SHALL** từ chối số tiền thanh toán vượt quá số dư còn nợ của hóa đơn (trừ khi có quy trình nạp tiền trả trước được phê duyệt). |
| **BR15** | Verified Guardian Linking | **THE SYSTEM SHALL** chỉ cho phép tài khoản phụ huynh xem thông tin, chuyên cần, điểm số và học phí của học viên đã được nhân viên xác thực mối quan hệ giám hộ (`StudentGuardians`). |
| **BR16** | Soft Delete for Financial Entities | **THE SYSTEM SHALL** cấm xóa vật lý (`HARD DELETE`) các bản ghi đã phát sinh quan hệ giao dịch (hóa đơn, thanh toán, ghi danh, điểm danh). Chỉ cho phép chuyển trạng thái (`DEACTIVATED` / `CANCELLED`). |
| **BR17** | Q&A Moderation | **WHILE** câu hỏi hoặc câu trả lời Q&A chưa được nhân viên/quản trị viên phê duyệt (`APPROVED`), **THE SYSTEM SHALL** không hiển thị công khai trên diễn đàn cộng đồng. |
| **BR18** | Mandatory Audit Logging | **WHEN** có thao tác điều chỉnh học phí, công bố điểm, xóa mềm bản ghi hoặc phân quyền tài khoản, **THE SYSTEM SHALL** tự động ghi nhận vào bảng `AuditLogs` (Ai làm, Lúc nào, Thao tác gì, Giá trị trước/sau). |
| **BR19** | Closed Class Restrictions | **WHILE** một lớp học đã có trạng thái kết thúc (`CLOSED`), **THE SYSTEM SHALL** không cho phép tạo thêm buổi học thông thường hoặc ghi danh mới vào lớp đó. |
| **BR20** | Segregated Financial Reporting | **THE SYSTEM SHALL** tách biệt rõ ràng giữa tiền thực tế đã thu (`Total Collected`) và các khoản còn phải thu (`Outstanding Debt`) trong toàn bộ báo cáo doanh thu và thống kê tài chính. |
