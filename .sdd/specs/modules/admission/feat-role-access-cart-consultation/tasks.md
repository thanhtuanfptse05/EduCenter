# Tasks: Role Access Restriction for Consultation and Registration Cart

- [x] **Task 1: Cập nhật kiểm tra phân quyền tại `LandingServlet`**
  - Chặn tài khoản nội bộ (Admin, Teacher, Staff, Finance) gửi form tư vấn.
  - Cho phép Khách vãng lai và Học sinh/Phụ huynh.
  - Thông báo lỗi/cảnh báo rõ ràng và redirect an toàn.

- [x] **Task 2: Cập nhật kiểm tra phân quyền tại `RegistrationCartServlet`**
  - Thêm helper kiểm tra vai trò khách hàng (`isStudent` hoặc `isParent`).
  - Chặn các tài khoản nội bộ thực hiện thêm/sửa/xóa/làm trống giỏ hàng.
  - Tại `/registration/confirm` (cả GET và POST): Khách vãng lai bắt buộc chuyển hướng tới `/login?redirect_url=/registration/confirm`. Tài khoản nội bộ bị từ chối với thông báo thích hợp.

- [x] **Task 3: Cập nhật logic đăng nhập tại `AuthServlet`**
  - Chỉ gọi `mergeGuestCart` nếu tài khoản đăng nhập là Học sinh hoặc Phụ huynh.

- [x] **Task 4: Thích ứng giao diện người dùng (Adaptive UI) trên các trang JSP**
  - Cập nhật `landing.jsp`: Hiển thị cảnh báo và vô hiệu hóa submit nếu đăng nhập tài khoản nội bộ.
  - Cập nhật `course-list.jsp` và `course-detail.jsp`: Cảnh báo/vô hiệu hóa nút thêm giỏ hàng đối với tài khoản nội bộ.
  - Cập nhật `registration-cart.jsp`: Hiển thị cảnh báo nếu tài khoản nội bộ xem giỏ hàng; gợi ý đăng nhập cho khách vãng lai.

- [x] **Task 5: Biên dịch, kiểm thử tự động và kiểm tra luồng hoạt động**
  - Chạy `verify.ps1` và viết test `RoleAccessCartConsultationTest.java`.
  - 158/158 tests passed 100%.

- [x] **Task 6: Commit và Push lên nhánh `main`**
  - Tạo commit chuẩn `feat(admission): restrict consultation and cart operations to student and parent roles`.
  - Push lên nhánh `main`.
