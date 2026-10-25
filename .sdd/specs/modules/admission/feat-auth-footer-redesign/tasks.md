# Tasks: Cải tiến Giao diện Xác thực & Footer Dùng chung (feat-auth-footer-redesign)

> **Artifact baseline: historical v1.** N?i dung/checkbox d??i ??y thu?c phi?n b?n tr??c; spec v2 hi?n h?nh l? [spec.md](spec.md). Ph?i c?p nh?t plan/tasks v? c?c h?p ??ng t??ng ?ng tr??c khi code v2; kh?ng d?ng tr?ng th?i Completed ho?c chi ti?t m?u thu?n ? ??y l?m b?ng ch?ng ?? ??t v2. H?p ??ng chung t?i [integration.md](../../../integration.md) v? th? t? tri?n khai t?i [implementation-order.md](../../../implementation-order.md).

## Task List

- [x] **Task 1: Cập nhật Resource & Stylesheet Foundation**
  - [x] 1.1 Thêm `<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">` vào `web/WEB-INF/views/common/head.jspf`.
  - [x] 1.2 Rà soát và bổ sung các CSS rules cần thiết trong `web/assets/css/auth.css` và `web/assets/css/public-shell.css` cho footer và auth views.
  - [x] 1.3 Kiểm tra và hoàn thiện `web/assets/js/auth.js` cho password visibility toggle, 4-bar strength meter, role switcher (`STUDENT` / `PARENT`), password matching, countdown timer.

- [x] **Task 2: Thiết kế lại Footer Dùng chung (`public-footer.jspf`)**
  - [x] 2.1 Viết lại `web/WEB-INF/views/common/public-footer.jspf` với cấu trúc Enterprise Footer 4 cột (Chương trình học, Học viên & Phụ huynh, Tổ chức & Giảng dạy, Hỗ trợ & Pháp lý).
  - [x] 2.2 Tích hợp khối thông tin thương hiệu, chuẩn ISO/IEC 27001 & GDPT 2018, thông tin hotline `1900 6886` và các chi nhánh.
  - [x] 2.3 Thêm thanh đáy bản quyền, trạng thái máy chủ (99.98% Uptime), và liên kết điều khoản bảo mật.

- [x] **Task 3: Thiết kế lại Trang Đăng nhập (`login.jsp`)**
  - [x] 3.1 Chuyển đổi `web/WEB-INF/views/auth/login.jsp` sang cấu trúc Split-Screen 2 cột (Cột trái: Form đăng nhập, Cột phải: Academic & Security Showcase).
  - [x] 3.2 Tích hợp chuẩn CSRF token, alert flash messages, khôi phục email đã nhập khi đăng nhập lỗi (`preserved_email`).
  - [x] 3.3 Đảm bảo **loại trừ tuyệt đối** các nút demo switcher hay Google SSO không có trong backend.

- [x] **Task 4: Thiết kế lại Trang Đăng ký (`register.jsp`)**
  - [x] 4.1 Chuyển đổi `web/WEB-INF/views/auth/register.jsp` sang cấu trúc 2 cột với stepper bar và showcase quyền lợi bên phải.
  - [x] 4.2 Thiết kế Segmented Role Selector chuẩn 2 vai trò: Học sinh (`STUDENT`) và Phụ huynh (`PARENT`).
  - [x] 4.3 Form 2 cột gồm đầy đủ họ tên, điện thoại, email, khối lớp, mật khẩu (thanh đo 4 vạch & checklist) và xác nhận mật khẩu.
  - [x] 4.4 Tích hợp CSRF token, checkbox điều khoản, và flash messages.

- [x] **Task 5: Thiết kế lại Trang Quên & Đặt Lại Mật Khẩu (`forgot-password.jsp` & `reset-password.jsp`)**
  - [x] 5.1 Viết lại `web/WEB-INF/views/auth/forgot-password.jsp` dạng Centered Card với kiểm tra email hợp lệ, báo lỗi rõ nếu không tìm thấy email, và tạo thẻ hành động mở liên kết đổi mật khẩu trực tiếp (`reset_link`) cho người dùng.
  - [x] 5.2 Viết lại `web/WEB-INF/views/auth/reset-password.jsp` với thanh đếm ngược hiệu lực token (15 phút), kiểm tra độ mạnh mật khẩu mới, xác nhận khớp, và banner token hết hạn.

- [x] **Task 6: Kiểm thử & Triển khai hoàn tất**
  - [x] 6.1 Chạy Ant `verify` để kiểm tra compile và chạy toàn bộ 50+ test cases JUnit 5.
  - [x] 6.2 Kiểm tra trực quan các trang đảm bảo không phát sinh lỗi giao diện.
  - [x] 6.3 Commit với thông điệp `feat(auth): redesign login register reset pages and shared enterprise footer` và push lên nhánh `main`.
