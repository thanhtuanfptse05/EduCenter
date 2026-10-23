# Quickstart & Verification Guide: feat-teacher-management

**Feature:** `feat-teacher-management` | **Module:** Academic (M04 / M05 / M12) | **Use Case:** UC12, ADM-09

---

## 1. Prerequisites
- Đảm bảo database `EduCenterDB` đang hoạt động.
- Tài khoản thực hiện: `staff@educenter.vn` (Trần Thu Hà) hoặc `admin@educenter.vn`.
- Cần có ít nhất một tài khoản `User` có role `TEACHER` chưa gắn với `Teacher` profile (hoặc tạo qua màn hình Quản lý người dùng `/admin/users`).

---

## 2. Test Scenarios

### Kịch bản 1: Xem danh sách giáo viên & Thống kê KPI (`/staff/teachers`)
1. Đăng nhập bằng tài khoản STAFF hoặc ADMIN.
2. Truy cập `/staff/teachers` từ thanh điều hướng sidebar.
3. Kiểm tra các thẻ KPI: Tổng số giáo viên, Đang công tác, Nghỉ phép, Ngừng hoạt động, Tổng lớp phụ trách.
4. Kiểm tra danh sách giáo viên có hiển thị thông tin: Họ tên, email, số điện thoại, học vị, chuyên môn, trạng thái.

### Kịch bản 2: Lập hồ sơ giáo viên mới (`/staff/teachers/form`)
1. Bấm nút "Thêm giáo viên mới".
2. Hệ thống hiển thị form tạo mới, dropdown "Tài khoản liên kết" liệt kê các User có role TEACHER đang active mà chưa liên kết hồ sơ.
3. Nhập thông tin:
   - Tài khoản: chọn user có sẵn
   - Họ và tên: `ThS. Nguyễn Văn A`
   - Chuyên môn: `Toán THPT & Luyện thi đại học`
   - Bằng cấp/Học vị: `Thạc sĩ Sư phạm Toán học - ĐH Sư Phạm Hà Nội`
   - Thù lao tham khảo: `250.000` đ/h
   - Trạng thái: `ACTIVE`
4. Bấm "Lưu hồ sơ". Hệ thống redirect về danh sách và báo thành công.
5. Kiểm tra CSDL bảng `AuditLogs` có sinh 1 bản ghi `CREATE_TEACHER`.

### Kịch bản 3: Chỉnh sửa hồ sơ giáo viên
1. Bấm nút "Sửa" tại dòng giáo viên vừa tạo.
2. Dropdown tài khoản User bị khóa (read-only) để đảm bảo toàn vẹn.
3. Cập nhật chuyên môn hoặc học vị.
4. Bấm "Lưu hồ sơ". Kiểm tra thông tin cập nhật thành công và ghi AuditLog.

### Kịch bản 4: Cập nhật trạng thái & Chặn ngừng hoạt động (BR05 / FR-005)
1. Thử chuyển trạng thái giáo viên sang `ON_LEAVE` hoặc `INACTIVE`.
2. Nếu giáo viên đang có buổi học tương lai `SCHEDULED`: Hệ thống phải từ chối và hiển thị thông báo lỗi yêu cầu bàn giao người dạy thay trước.
3. Nếu giáo viên không có lịch tương lai: Hệ thống cập nhật thành công sang `ON_LEAVE` hoặc `INACTIVE`.
