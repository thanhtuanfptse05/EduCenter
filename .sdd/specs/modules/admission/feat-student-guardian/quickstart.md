# Quickstart Validation Guide: feat-student-guardian

## Prerequisites
1. Database `EduCenterDB` running on SQL Server with tables `Students`, `Guardians`, `StudentGuardians`, `Users`.
2. Admin account (`admin@educenter.edu.vn`) or Staff account (`tuvan@educenter.edu.vn`) logged in.

## Validation Scenarios

### Scenario 1: Tạo hồ sơ học viên mới
1. Đăng nhập bằng tài khoản Staff hoặc Admin.
2. Truy cập `/EduCenter/staff/students`.
3. Bấm **+ Thêm học viên mới**, điền:
   - Họ và tên: "Nguyễn Văn An"
   - Ngày sinh: 15/08/2008 (hợp lệ trong quá khứ)
   - Giới tính: Nam
   - Khối lớp: Khối 11
   - Trường: THPT Cầu Giấy
   - Mục tiêu: Chinh phục điểm 8.5+ THPTQG Khối A
   - Số điện thoại: 0987654321
4. Bấm Lưu -> Hệ thống chuyển hướng lại danh sách với thông báo flash thành công. Học viên xuất hiện trong bảng với mã `HV0001` (hoặc tương ứng với ID).

### Scenario 2: Xem chi tiết hồ sơ & Gắn tài khoản User
1. Trên danh sách học viên, bấm biểu tượng con mắt / nút **Xem chi tiết**.
2. Trang `/staff/students/detail?id=...` mở ra với các tab:
   - Thông tin cá nhân & Liên hệ
   - Danh sách Phụ huynh / Người giám hộ liên kết
   - Lịch sử lớp học & Điểm số
3. Gắn tài khoản User `STUDENT` vào học viên.

### Scenario 3: Thiết lập liên kết Phụ huynh & Xác thực giám hộ (BR15)
1. Truy cập `/EduCenter/staff/guardians`.
2. Bấm **+ Thêm hồ sơ phụ huynh** -> chọn User có vai trò `PARENT`, điền thông tin phụ huynh.
3. Bấm **Liên kết học sinh** -> chọn Phụ huynh và chọn Học sinh (Nguyễn Văn An), quan hệ: "Bố", đánh dấu là người nhận thông báo chính (`is_primary = true`).
4. Ban đầu liên kết hiển thị trạng thái `CHỜ XÁC THỰC` (Chưa duyệt).
5. Nhân viên bấm **Xác thực** -> nhập lý do/căn cứ -> Liên kết chuyển sang `ĐÃ XÁC THỰC (VERIFIED)` kèm thông tin người duyệt và thời điểm duyệt.
6. Nhân viên thử bấm **Thu hồi** -> Liên kết chuyển sang `ĐÃ THU HỒI` và ngắt quyền xem dữ liệu của phụ huynh ngay lập tức.
