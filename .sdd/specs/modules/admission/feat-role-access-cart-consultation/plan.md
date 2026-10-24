# Implementation Plan: Role Access Restriction for Consultation and Registration Cart

## Architectural Overview
EduCenter sử dụng kiến trúc phân tầng MVC tiêu chuẩn Jakarta Servlet + JSP + JPA:
1. `LandingServlet`: Tiếp nhận đơn đăng ký tư vấn từ Landing page (`POST /dang-ky-tu-van`, `POST /index`, `POST /`).
2. `RegistrationCartServlet`: Điều phối các tác vụ giỏ hàng (`/registration-cart/*`) và chốt đơn đăng ký (`/registration/confirm`).
3. `AuthServlet`: Xử lý đăng nhập và sáp nhập giỏ hàng khách (`mergeGuestCart`).
4. `UserPrincipalDTO`: Chứa thông tin tài khoản hiện hành (`isStudent()`, `isParent()`, `isAdmin()`, `isStaff()`, `isTeacher()`).
5. Frontend JSP Views: `landing.jsp`, `course-list.jsp`, `course-detail.jsp`, `registration-cart.jsp`, `registration-confirm.jsp`.

## Proposed Changes

### 1. `src/java/com/educenter/controller/LandingServlet.java`
- Trong `handleConsultationSubmission(HttpServletRequest req, HttpServletResponse resp)`:
  - Lấy `currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;`
  - Nếu `currentUser != null && !currentUser.isStudent() && !currentUser.isParent()`:
    - Bị chặn.
    - Đặt `session.setAttribute("alertType", "warning")` (hoặc `"error"`).
    - Đặt `session.setAttribute("alertMessage", "Tính năng đăng ký tư vấn chỉ dành cho tài khoản Học sinh hoặc Phụ huynh.")`.
    - Redirect về `req.getContextPath() + "/#dang-ky-tu-van"`.
  - Khách vãng lai (`currentUser == null`) hoặc Học sinh/Phụ huynh (`currentUser.isStudent() || currentUser.isParent()`): Cho phép tiếp tục xử lý `registerLead(form)`.

### 2. `src/java/com/educenter/controller/RegistrationCartServlet.java`
- Tạo helper method:
  ```java
  private boolean isCustomerOrGuest(UserPrincipalDTO user) {
      return user == null || user.isStudent() || user.isParent();
  }
  private boolean isCustomerAccount(UserPrincipalDTO user) {
      return user != null && (user.isStudent() || user.isParent());
  }
  ```
- Trong `doGet`:
  - Tại `/registration/confirm`:
    - Nếu `currentUser == null`:
      - Chuyển hướng tới `/login?redirect_url=` + `/registration/confirm`.
      - Flash warning: `"Vui lòng đăng nhập bằng tài khoản Học sinh hoặc Phụ huynh để xác nhận đăng ký khóa học."`
    - Nếu `currentUser != null && !isCustomerAccount(currentUser)`:
      - Chuyển hướng về `/registration-cart`.
      - Flash error: `"Tính năng chốt đăng ký khóa học chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."`
- Trong `doPost`:
  - Tại `/registration-cart/add`:
    - Nếu `currentUser != null && !isCustomerAccount(currentUser)`:
      - Flash error: `"Tính năng thêm khóa học vào giỏ hàng chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."`
      - Redirect về trang `/courses` (hoặc Referer nếu hợp lệ).
  - Tại `/registration-cart/update`, `/registration-cart/remove`, `/registration-cart/clear`:
    - Nếu `currentUser != null && !isCustomerAccount(currentUser)`:
      - Flash error: `"Tính năng quản lý giỏ hàng chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."`
      - Redirect về `/registration-cart`.
  - Tại `/registration/confirm` (`handleConfirmRegistration`):
    - Nếu `currentUser == null`:
      - Chuyển hướng tới `/login?redirect_url=/registration/confirm`.
      - Flash warning: `"Vui lòng đăng nhập tài khoản Học sinh hoặc Phụ huynh để chốt đăng ký."`
    - Nếu `currentUser != null && !isCustomerAccount(currentUser)`:
      - Chặn và flash error: `"Tính năng chốt đăng ký khóa học chỉ dành cho tài khoản Phụ huynh hoặc Học sinh."`
      - Redirect về `/registration-cart`.

### 3. `src/java/com/educenter/controller/AuthServlet.java`
- Trong `handlePostLogin`:
  - Chỉ gọi `mergeGuestCart` nếu `principal.isStudent() || principal.isParent()`.
  - Nếu là tài khoản nội bộ (Admin, Teacher, Staff), không tự động merge giỏ hàng khách vào database của nhân sự nội bộ.

### 4. JSP Views Enhancements
- `web/WEB-INF/views/common/landing.jsp`:
  - Tại form `#dang-ky-tu-van`:
    - Nếu `sessionScope.currentUser != null and not sessionScope.currentUser.student and not sessionScope.currentUser.parent`:
      - Hiển thị banner cảnh báo: *"Bạn đang đăng nhập bằng tài khoản nội bộ (${sessionScope.currentUser.primaryRole}). Tính năng gửi yêu cầu tư vấn chỉ dành cho Học sinh hoặc Phụ huynh."*
      - Nút submit đổi sang trạng thái disabled hoặc thông báo rõ.
- `web/WEB-INF/views/public/course-list.jsp`:
  - Nút "Thêm vào danh sách": Nếu đăng nhập vai trò nội bộ, hiển thị trạng thái disabled hoặc thông báo rõ ràng "Dành cho Học sinh/Phụ huynh".
- `web/WEB-INF/views/public/course-detail.jsp`:
  - Tương tự, nếu vai trò nội bộ, hiển thị badge cảnh báo thân thiện và vô hiệu hóa nút submit thêm giỏ hàng.
- `web/WEB-INF/views/public/registration-cart.jsp`:
  - Nếu `sessionScope.currentUser != null and not sessionScope.currentUser.student and not sessionScope.currentUser.parent`:
    - Hiển thị alert cảnh báo: *"Tài khoản nội bộ không thể thực hiện đăng ký khóa học. Vui lòng đăng nhập bằng tài khoản Học sinh hoặc Phụ huynh."*
    - Nút "Tiếp tục đăng ký" bị vô hiệu hóa hoặc chuyển sang cảnh báo.
  - Nếu `empty sessionScope.currentUser`:
    - Nút "Tiếp tục đăng ký" trỏ tới link `/registration/confirm` (khi click sẽ được Servlet chuyển hướng đăng nhập kèm lưu lại redirect_url).
