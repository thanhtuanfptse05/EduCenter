# Feature: Role Access Restriction for Consultation and Registration Cart (BR-ROLE-CART)
**Status:** Approved / Locked  
**Version:** 1.0.0 | **Author:** Member 02 (Admission) & AI Pair | **Date:** 2026-10-24  
**Module:** Admission (`.sdd/specs/modules/admission/module.md`)  
**Inherits From:**  
- Layer 1: `.sdd/constitution.md`  
- Layer 2: `.sdd/specs/modules/admission/module.md`  

---

## 1. Business Context & Goal
* **Why:** Trong hệ thống ERP Trung tâm Gia sư EduCenter, các nghiệp vụ tư vấn tuyển sinh và chọn mua khóa học chỉ thuộc về khách hàng mục tiêu là **Học sinh (STUDENT)** hoặc **Phụ huynh (PARENT)**. Các vai trò nội bộ của trung tâm (Giáo viên - TEACHER, Nhân viên học vụ/tuyển sinh - STAFF, Quản trị viên - ADMIN, Kế toán/Tài vụ - FINANCE) không được phép tự đóng vai học viên để thêm giỏ hàng hay gửi đơn tư vấn bằng tài khoản nội bộ.
* **Impact:** 
  - Đảm bảo tính toàn vẹn dữ liệu tuyển sinh CRM (Leads, RegistrationCartItem).
  - Phân tách rành mạch vai trò nội bộ và cổng khách hàng/học viên.
  - Cho phép khách vãng lai tự do khám phá, chọn khóa học vào giỏ và gửi yêu cầu tư vấn, nhưng bắt buộc xác thực tài khoản Học sinh/Phụ huynh ở bước chốt thanh toán/xác nhận đăng ký (`/registration/confirm`).

---

## 2. User Personas & Roles
* **Khách vãng lai (Guest):** Chưa đăng nhập. Được gửi yêu cầu tư vấn trên Landing page, được thêm khóa học vào giỏ hàng phiên khách. Khi bấm "Tiếp tục đăng ký" / Chốt thanh toán, hệ thống yêu cầu đăng nhập tài khoản Học sinh hoặc Phụ huynh.
* **Học sinh (STUDENT) & Phụ huynh (PARENT):** Tài khoản đã đăng nhập. Được toàn quyền gửi form đăng ký tư vấn, thêm/xóa/sửa giỏ hàng, đồng bộ giỏ hàng vào CSDL và thực hiện xác nhận đăng ký / chốt thanh toán.
* **Vai trò nội bộ (TEACHER, STAFF, ADMIN, FINANCE):** Tài khoản nội bộ trung tâm. Bị chặn khi cố gắng gửi form đăng ký tư vấn hoặc thêm giỏ hàng / xác nhận thanh toán; hiển thị thông báo rõ ràng: *"Tính năng này chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."*

---

## 3. User Stories
* **Story 1 (Guest Consultation & Cart Browsing):** Là một khách chưa đăng nhập, tôi có thể điền form gửi tư vấn và bấm thêm các khóa học vào danh sách quan tâm để thuận tiện tham khảo. Khi đến bước xác nhận đăng ký (`/registration/confirm`), hệ thống sẽ yêu cầu tôi đăng nhập hoặc đăng ký tài khoản Học sinh/Phụ huynh.
* **Story 2 (Student/Parent Seamless Checkout):** Là một Học sinh hoặc Phụ huynh đã đăng nhập, tôi có thể gửi tư vấn, thêm các khóa học vào giỏ hàng và chuyển sang màn hình chốt đăng ký (`/registration/confirm`) với các thông tin cá nhân đã được điền sẵn từ tài khoản.
* **Story 3 (Internal Role Blocked with Friendly Notice):** Là một Quản trị viên / Giáo viên / Nhân viên, khi tôi truy cập trang khóa học hoặc landing page và vô tình bấm "Gửi tư vấn", "Thêm vào giỏ" hoặc truy cập bước xác nhận đăng ký, hệ thống sẽ ngăn chặn thao tác và thông báo: *"Tính năng này chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."*

---

## 4. Acceptance Criteria (EARS Notation)

### AC-01: Gửi yêu cầu tư vấn (Consultation Request)
* **[UBIQUITOUS]** `THE SYSTEM SHALL` chỉ cho phép khách vãng lai (Guest) hoặc tài khoản có vai trò `STUDENT` hoặc `PARENT` gửi đơn tư vấn qua `POST /dang-ky-tu-van` (hoặc `POST /`, `POST /index`).
* **[UNWANTED]** `IF` người dùng đang đăng nhập với vai trò không phải `STUDENT` và không phải `PARENT` (ADMIN, TEACHER, STAFF, FINANCE) gửi form tư vấn, `THEN THE SYSTEM SHALL` chặn việc tạo Lead, lưu lại draft và chuyển hướng về form tư vấn với thông báo lỗi: *"Tính năng đăng ký tư vấn chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."*

### AC-02: Thao tác Giỏ hàng (Cart Operations)
* **[UBIQUITOUS]** `THE SYSTEM SHALL` chỉ cho phép khách vãng lai hoặc tài khoản `STUDENT` / `PARENT` thực hiện thêm khóa học (`POST /registration-cart/add`), sửa ghi chú (`POST /registration-cart/update`), xóa (`POST /registration-cart/remove`) hoặc làm trống (`POST /registration-cart/clear`).
* **[UNWANTED]** `IF` tài khoản có vai trò nội bộ (ADMIN, TEACHER, STAFF, FINANCE) gửi yêu cầu thêm vào giỏ hàng, `THEN THE SYSTEM SHALL` từ chối cập nhật giỏ hàng, hiển thị thông báo cảnh báo: *"Tính năng giỏ hàng và đăng ký khóa học chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."* và chuyển hướng an toàn về trang khóa học/giỏ hàng.

### AC-03: Chốt xác nhận đăng ký & Thanh toán (/registration/confirm)
* **[EVENT-DRIVEN]** `WHEN` người dùng truy cập `GET /registration/confirm` hoặc gửi `POST /registration/confirm`:
  1. `IF` người dùng chưa đăng nhập (`currentUser == null`), `THEN THE SYSTEM SHALL` chuyển hướng người dùng đến trang `/login?redirect_url=/registration/confirm` kèm thông báo: *"Vui lòng đăng nhập tài khoản Học sinh hoặc Phụ huynh để hoàn tất đăng ký khóa học."*
  2. `IF` người dùng đã đăng nhập nhưng vai trò không phải `STUDENT` và không phải `PARENT`, `THEN THE SYSTEM SHALL` chuyển hướng về `/registration-cart` kèm thông báo lỗi: *"Tính năng chốt đăng ký và thanh toán chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."*
  3. `IF` người dùng là `STUDENT` hoặc `PARENT`, `THEN THE SYSTEM SHALL` cho phép tiếp tục quy trình xác nhận đăng ký như bình thường.

### AC-04: Đồng bộ giỏ hàng khi đăng nhập (Cart Merge on Login)
* **[STATE-DRIVEN]** `WHILE` người dùng đăng nhập vào hệ thống:
  - `IF` người dùng có vai trò `STUDENT` hoặc `PARENT`, `THE SYSTEM SHALL` hợp nhất (merge) giỏ hàng từ session khách vào giỏ hàng CSDL của tài khoản.
  - `IF` người dùng có vai trò khác (ADMIN, TEACHER, STAFF, FINANCE), `THE SYSTEM SHALL NOT` hợp nhất giỏ hàng khách vào CSDL của tài khoản nội bộ.

### AC-05: Giao diện người dùng thích ứng (Adaptive UI)
* **[STATE-DRIVEN]** Trên `landing.jsp`, `course-list.jsp`, `course-detail.jsp`, `registration-cart.jsp`:
  - `IF` người dùng đang đăng nhập với vai trò nội bộ, `THE SYSTEM SHALL` hiển thị ghi chú/thông báo giải thích rõ ràng tại các khối đăng ký/giỏ hàng để người dùng hiểu rằng tài khoản nội bộ không tham gia đăng ký khóa học.

---

## 5. UI/UX & Navigation Mapping
* **Landing Page:** `GET /`, `POST /dang-ky-tu-van` -> `LandingServlet.java` -> `/WEB-INF/views/common/landing.jsp`.
* **Course Catalog:** `GET /courses`, `GET /courses/detail` -> `CourseListServlet.java`, `CourseDetailServlet.java` -> `/WEB-INF/views/public/course-list.jsp`, `course-detail.jsp`.
* **Cart View:** `GET /registration-cart` -> `RegistrationCartServlet.java` -> `/WEB-INF/views/public/registration-cart.jsp`.
* **Confirm / Checkout:** `GET/POST /registration/confirm` -> `RegistrationCartServlet.java` -> `/WEB-INF/views/public/registration-confirm.jsp`.

---

## 6. Definition of Done (DoD)
* [x] Đã cập nhật spec rõ ràng và khóa (Locked).
* [ ] Đã cập nhật logic kiểm tra quyền tại `LandingServlet` cho form tư vấn.
* [ ] Đã cập nhật logic kiểm tra quyền tại `RegistrationCartServlet` cho các thao tác add/remove/update/clear và confirm.
* [ ] Đã cập nhật `AuthServlet` để chỉ merge guest cart cho Student/Parent.
* [ ] Đã tinh chỉnh giao diện các file JSP (`landing.jsp`, `course-list.jsp`, `course-detail.jsp`, `registration-cart.jsp`) hiển thị thông báo thân thiện khi đăng nhập vai trò nội bộ.
* [ ] Kiểm thử thành công các kịch bản: Guest, Student, Parent, Teacher, Admin.
* [ ] Commit và push lên nhánh `main`.
