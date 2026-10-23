# Quickstart & Verification Guide: feat-academic-programs

**Feature:** `feat-academic-programs` | **Module:** Academic (M04) | **Use Case:** UC11, ADM-04, ADM-05

---

## 1. Prerequisites
- Đảm bảo SQL Server đang hoạt động và database `EduCenterDB` đã có sẵn schema.
- Tài khoản đăng nhập kiểm thử:
  - Tài khoản STAFF hoặc ADMIN (có quyền truy cập `/staff/*`).

---

## 2. Verification Scenarios

### Kịch bản 1: Quản lý danh mục môn học (`/staff/subjects`)
1. Truy cập `/staff/subjects` bằng tài khoản STAFF/ADMIN.
2. Kiểm tra danh sách môn học hiển thị đầy đủ (Toán, Lý, Hóa, Sinh, Anh...), có số lượng khóa học trực thuộc.
3. Thêm một môn học mới (ví dụ: Code: `INF`, Tên: `Tin học và Lập trình`, Mô tả: `Lập trình cơ bản cho THCS - THPT`).
4. Bấm "Lưu môn học". Kiểm tra hệ thống lưu vào DB và hiển thị thông báo thành công.
5. Kiểm tra ràng buộc mã trùng: Thêm tiếp môn học với Code `inf` (chữ thường). Hệ thống phải từ chối và báo lỗi mã môn đã tồn tại.
6. Thử tắt trạng thái môn học đang có khóa `OPEN`: Chuyển môn Toán sang `INACTIVE`. Hệ thống phải chặn và cảnh báo FR-006.

### Kịch bản 2: Quản lý khóa học & Bộ lọc nâng cao (`/staff/courses`)
1. Truy cập `/staff/courses`.
2. Kiểm tra các thẻ KPI đầu trang: Tổng số khóa học, Đang mở (`OPEN`), Tạm đóng (`CLOSED`), Đã lưu trữ (`ARCHIVED`), Tổng số môn học. Các con số phải khớp với CSDL.
3. Thử nghiệm bộ lọc:
   - Lọc theo Môn học (ví dụ: Toán học).
   - Lọc theo Khối lớp (ví dụ: Khối 10).
   - Lọc theo Trạng thái (ví dụ: `OPEN`).
   - Tìm kiếm theo từ khóa (mã hoặc tên khóa học).
   - Đổi sắp xếp: Theo học phí tăng/giảm, theo tên A-Z, mới nhất.
4. Kiểm tra Empty State: Nhập từ khóa không tồn tại như `XYZ99999`. Hệ thống phải hiển thị Empty State chuyên nghiệp với icon Lucide SVG và nút làm mới bộ lọc.

### Kịch bản 3: Tạo và Sửa khóa học (`/staff/courses/form`)
1. Bấm nút "Thêm khóa học mới".
2. Nhập thông tin hợp lệ:
   - Môn học: `Toán học`
   - Mã khóa: `MATH-10-TEST`
   - Tên khóa: `Luyện thi Toán vào 10 chuyên sâu`
   - Khối lớp: `10`
   - Mục tiêu: `Kỳ thi tuyển sinh vào 10`
   - Học phí: `3.200.000`
   - Số tuần: `12`, Tổng số buổi: `24`, Sĩ số tối đa: `15`
3. Bấm "Lưu khóa học". Hệ thống redirect về danh sách và báo thành công.
4. Sửa học phí của khóa vừa tạo từ `3.200.000` lên `3.500.000`:
   - Mở form sửa khóa học.
   - Thay đổi học phí thành `3.500.000`.
   - Bấm lưu.
   - Kiểm tra CSDL bảng `AuditLogs` có sinh 1 bản ghi `UPDATE_COURSE_FEE` với `oldValue` và `newValue` tương ứng.

### Kịch bản 4: Cập nhật trạng thái khóa học
1. Tại danh sách khóa học, đổi trạng thái khóa `MATH-10-TEST` từ `OPEN` sang `CLOSED`.
2. Khóa học chuyển sang nhãn `Tạm đóng` (badge màu cảnh báo vàng/hổ phách).
3. Thử tìm trên catalog học sinh/khách vãng lai: Khóa học đã `CLOSED` không cho phép bấm ghi danh mới.
