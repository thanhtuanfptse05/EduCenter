# Feature: Cải tiến Giao diện Xác thực & Footer Dùng chung (feat-auth-footer-redesign) — SPECIFICATION
**Status:** Approved / Locked | **Version:** 1.0.0 | **Date:** 2026-10-23  
**Module ID:** `MOD-ADMISSION` (M01 – Public Website & Authentication Portal)  
**Author / Owner:** Member 02 (Admission & Public Portal)  
**Inherits From:**  
- Layer 1: `.sdd/constitution.md` (Article 1, Article 2 SEC-01..05)  
- Layer 2: `.sdd/specs/modules/admission/module.md`  
- UI/UX Standard: `design.md` (Default Light mode, Design Tokens, Lucide SVG outline icons, Local CSS)  
- PRJ301 Standard: Mục 3.1 & 3.2 (Bảo mật tài khoản, MVC, PRG pattern, CSRF, BCrypt)  

---

## 1. Business Context & Goal

* **Why:**  
  Các trang xác thực người dùng (`/login`, `/register`, `/forgot-password`, `/reset-password`) và Footer của cổng thông tin công cộng hiện đang ở dạng tối giản (minimal skeleton). Cần nâng cấp toàn diện giao diện theo phong cách Enterprise Educational ERP hiện đại, lấy cảm hứng từ cấu trúc thiết kế tham khảo nhưng **tuyệt đối chỉ tích hợp các tính năng nghiệp vụ có thực của dự án EduCenter**.
* **Strict Exclusions (Loại trừ triệt để theo yêu cầu dự án):**
  1. **KHÔNG** đưa vào bảng chuyển đổi tài khoản demo nhanh (`RBAC Demo Switcher Panel`, `fillDemo(...)`).
  2. **KHÔNG** đưa vào banner sandbox kiểm thử bỏ qua SMTP hoặc đường link demo bypass token (`?token=demo_sec...`).
  3. **KHÔNG** đưa vào nút Google Workspace SSO (vì backend hiện tại chưa tích hợp OAuth2 Google).
  4. **KHÔNG** đưa vào nút mô phỏng token hết hạn của developer.
  5. **KHÔNG** cho phép tự đăng ký vai trò Gia sư/Giáo viên trên form đăng ký (`register.jsp`), bởi vì hệ thống quy định chỉ `STUDENT` (Học sinh) và `PARENT` (Phụ huynh) được phép tự đăng ký (Giáo viên và Staff do Admin cấp phát nội bộ per BR01/FR-001).
* **Mục tiêu:**
  1. **Đăng nhập (`/login`):** Bố cục Split-Screen SaaS 2 cột (Cột trái: Form đăng nhập chuẩn MVC + PRG, hiển thị thông báo flash, nhớ email đã nhập; Cột phải: Khối Academic Showcase giới thiệu thành tựu THPT Quốc Gia, mã hóa AES-256, RBAC).
  2. **Đăng ký (`/register`):** Bố cục 2 cột (Cột trái: Stepper, Role Segmented Selector `STUDENT` hoặc `PARENT`, form 2 cột với Họ tên, SĐT, Email, Khối lớp quan tâm, Mật khẩu có thanh đo độ mạnh 4 vạch và checklist quy tắc trực quan, Xác nhận mật khẩu kèm chỉ báo khớp; Cột phải: Thẻ thành tựu học thuật, Bento quyền lợi và Hotline hỗ trợ).
  3. **Quên mật khẩu (`/forgot-password`):** Thẻ bảo mật căn giữa (Centered Card max-w 480px), thanh gradient thương hiệu, huy hiệu ổ khóa bảo mật, ô nhập email xác thực, hộp Sentinel Guard bảo mật và gửi token đặt lại qua luồng nghiệp vụ chuẩn.
  4. **Đặt lại mật khẩu (`/reset-password`):** Hiển thị thanh đếm ngược thời gian hiệu lực token (15 phút), kiểm tra độ mạnh mật khẩu mới, kiểm tra khớp mật khẩu, tùy chọn hủy phiên đăng nhập cũ, và xử lý rõ ràng khi token hết hạn.
  5. **Footer dùng chung hiện đại (`public-footer.jspf`):** Chuẩn hóa toàn bộ hệ thống footer trên tất cả màn hình (Trang chủ, Khóa học, Giỏ đăng ký, Xác nhận, Các trang Auth, Lỗi 404/500). Gồm Logo E, Giới thiệu trung tâm, Tiêu chuẩn ISO/IEC 27001 & GDPT 2018, 4 cột điều hướng chi tiết (Chương trình học, Học viên & Phụ huynh, Tổ chức & Giảng dạy, Hỗ trợ & Pháp lý), kèm thanh bản quyền, trạng thái máy chủ và liên hệ hotline 1900 6886.

---

## 2. User Personas & Actors

| Vai trò (Actor) | Thao tác tại Module Xác thực & Footer |
|---|---|
| **Guest (Khách vãng lai)** | Đăng ký tài khoản mới với vai trò Học sinh hoặc Phụ huynh; yêu cầu cấp lại mật khẩu qua email; duyệt điều hướng footer. |
| **Student / Parent** | Đăng nhập vào không gian học tập; đặt lại mật khẩu an toàn khi quên; đối soát thông tin qua footer. |
| **Staff / Admin / Tutor** | Đăng nhập tài khoản tác nghiệp vào hệ thống ERP qua cùng form chuẩn; chuyển hướng dashboard theo phân quyền. |

---

## 3. Functional Requirements (FR)

### FR-01: Giao diện Đăng nhập Chuẩn Enterprise (`/login`)
- **FR-01.1:** Bố cục 2 cột (Desktop 1.25fr : 1fr, Mobile xếp dọc 1 cột).
- **FR-01.2:** Cột trái chứa Form đăng nhập:
  - Trường Email (`name="email"`, type="email", required, autocomplete="username", tự động nạp lại giá trị từ `sessionScope.preserved_email` nếu đăng nhập thất bại).
  - Trường Mật khẩu (`name="password"`, type="password", required, autocomplete="current-password").
  - Nút ẩn/hiện mật khẩu (toggle eye icon).
  - Checkbox duy trì phiên làm việc ("Duy trì phiên đăng nhập theo quy chế bảo mật").
  - Liên kết "Quên mật khẩu?" trỏ đến `${pageContext.request.contextPath}/forgot-password`.
  - Nút Submit "Đăng nhập vào hệ thống" với icon mũi tên.
  - Liên kết chuyển sang trang Đăng ký: `${pageContext.request.contextPath}/register`.
  - Token bảo vệ CSRF: `<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>`.
  - Tham số chuyển hướng an toàn: `<input type="hidden" name="redirect_url" value="<c:out value='${param.redirect_url}'/>"/>`.
  - Hệ thống thông báo Flash Alert từ `alert.jsp` (hiển thị lỗi sai tài khoản/mật khẩu, thông báo vừa đăng xuất).
- **FR-01.3:** Cột phải chứa Academic Showcase:
  - Huy hiệu đào tạo: `M02 - Tuyển Sinh & Đào Tạo` / `THPT Quốc Gia`.
  - Thẻ chỉ số: Tỷ lệ đỗ NV1 98.4%, thanh tiến độ đa khối (A00/A01, B00/D01, Khối khác), điểm trung bình môn Toán/Lý/Hóa.
  - 2 khối điểm nhấn kiến trúc: Quyền hạn tác nghiệp nghiêm ngặt (RBAC) & Mã hóa dữ liệu học tập chuẩn AES-256.
  - Hộp trích dẫn từ Hội đồng Chuyên môn EduCenter.
  - Thông số kiểm toán hạ tầng: Cụm máy chủ Hà Nội (HN-01), Độ trễ thấp.

### FR-02: Giao diện Đăng ký Thành viên Chuẩn Hóa (`/register`)
- **FR-02.1:** Bố cục 2 cột (Cột chính 1.5fr, Cột quyền lợi 1fr).
- **FR-02.2:** Thanh trạng thái quy trình (Stepper Bar): `01 · SRS AUTH-02 · Đăng ký thành viên hệ thống EduCenter` kèm huy hiệu bảo mật 256-bit SSL & BR01 Validated.
- **FR-02.3:** Segmented Role Selector:
  - Chọn 1 trong 2 vai trò hợp lệ: **Học sinh THPT (`STUDENT`)** hoặc **Phụ huynh (`PARENT`)**.
  - Tự động gán vào `<input type="hidden" id="roleCodeInput" name="roleCode" value="STUDENT"/>`.
  - Hỗ trợ khôi phục trạng thái vai trò từ `sessionScope.preserved_roleCode`.
- **FR-02.4:** Lưới form 2 cột gồm các trường:
  - Họ và tên (`name="fullName"`, minlength="2", maxlength="150", required).
  - Số điện thoại (`name="phone"`, pattern="[0-9]{10}", required).
  - Email cá nhân (`name="email"`, type="email", required).
  - Khối lớp quan tâm (`name="grade"` hoặc thông tin đào tạo phù hợp).
  - Mật khẩu (`name="password"`, required, minlength="6", toggle ẩn/hiện, thanh đo 4 vạch và checklist 4 tiêu chí: ≥ 6 ký tự, Chữ hoa, Chữ số, Ký tự đặc biệt).
  - Xác nhận mật khẩu (`name="confirmPassword"`, required, minlength="6", toggle ẩn/hiện, chỉ báo trùng khớp theo thời gian thực).
- **FR-02.5:** Checkbox đồng ý Điều khoản dịch vụ và Quy chế kiểm tra & đánh giá.
- **FR-02.6:** Cột phải hiển thị:
  - Thẻ hình ảnh & thành tựu đào tạo Niên khóa 2025 - 2026.
  - Bento Box 3 quyền lợi tài khoản (Test đầu vào miễn phí, Lịch học thông minh, Biểu đồ tiến độ).
  - Thẻ Hotline tư vấn tuyển sinh: `1900 6886`.

### FR-03: Giao diện Quên Mật Khẩu (`/forgot-password`)
- **FR-03.1:** Thẻ trung tâm (Centered Card) max-w 480px với thanh màu gradient thương hiệu trên đỉnh.
- **FR-03.2:** Huy hiệu bảo mật Security Emblem (vòng tròn ổ khóa outline + icon khiên bảo mật).
- **FR-03.3:** Tiêu đề và mô tả hướng dẫn nhập email định danh hệ thống.
- **FR-03.4:** Form yêu cầu đặt lại mật khẩu với CSRF token, trường Email (`name="email"`), và hộp Sentinel Guard.
- **FR-03.5:** Tích hợp hiển thị thông báo an toàn; nếu là môi trường chấm Assignment PRJ301 có `sessionScope.demo_reset_link`, hiển thị banner hướng dẫn đánh giá kèm link trực tiếp đặt lại mật khẩu.
- **FR-03.6:** Liên kết quay lại Đăng nhập và email hỗ trợ kỹ thuật `hotro@educenter.vn`.

### FR-04: Giao diện Đặt Lại Mật Khẩu Mới (`/reset-password`)
- **FR-04.1:** Thanh trạng thái token: `TOKEN VALID` kèm đồng hồ đếm ngược 15 phút (`#countdown-timer`).
- **FR-04.2:** Thẻ trung tâm max-w 500px, tiêu đề Thiết lập mật khẩu mới (AUTH-04).
- **FR-04.3:** Kiểm tra trạng thái token qua `resetState.valid`:
  - Nếu token hợp lệ: Form nhập Mật khẩu mới (`name="newPassword"`, minlength="6"), Xác nhận mật khẩu mới (`name="confirmNewPassword"`), thanh đo độ mạnh, chỉ báo khớp, checkbox đăng xuất các thiết bị khác, nút lưu mật khẩu.
  - Nếu token không hợp lệ hoặc đã hết hạn: Hiển thị Banner cảnh báo hết hạn phiên xác thực kèm nút "Yêu cầu liên kết mới" chuyển hướng về `/forgot-password`.

### FR-05: Nâng Cấp Footer Dùng Chung Toàn Hệ Thống (`public-footer.jspf`)
- **FR-05.1:** Thiết kế theo cấu trúc Enterprise Footer 4 cột chuyên nghiệp, hiển thị đồng nhất ở mọi trang công cộng và xác thực.
- **FR-05.2:** Khối Brand & Định vị: Logo vuông "E", tên EduCenter, khẩu hiệu đào tạo, chứng nhận ISO/IEC 27001, Chương trình GDPT 2018, bảo mật TLS 1.3.
- **FR-05.3:** Khối thông tin liên hệ: Cơ sở Hà Nội, Cơ sở TP.HCM, Hotline `1900 6886`, Email `hotro@educenter.vn`.
- **FR-05.4:** 4 Cột danh mục liên kết rõ ràng:
  - *Chương trình học*: Khóa học THPT Quốc Gia, Bổ trợ Toán - Lý - Hóa, Luyện thi ĐGNL ĐHQG, Tiếng Anh & IELTS.
  - *Dành cho Học viên & PH*: Danh sách khóa học, Giỏ đăng ký (`/registration-cart`), Tư vấn tuyển sinh, Đăng nhập tài khoản.
  - *Về EduCenter*: Đội ngũ giáo viên, Thành tựu học thuật, Lộ trình đào tạo, Quy chế đào tạo.
  - *Hỗ trợ & Pháp lý*: Quy trình đăng ký, Chính sách bảo mật dữ liệu, Điều khoản sử dụng, Hỗ trợ kỹ thuật.
- **FR-05.5:** Thanh đáy (Footer Bottom Bar): Bản quyền `&copy; ${currentYear} EduCenter ERP Platform`, trạng thái vận hành hệ thống `99.98% Uptime`, và liên kết chính sách.

---

## 4. Non-Functional Requirements (NFR)
- **NFR-01 (Design System):** Tuân thủ tuyệt đối `design.md`: Giao diện mặc định Light Mode, sử dụng CSS tokens (`--bg`, `--surface`, `--primary`, `--text`...), font Inter, bo góc chuẩn, không sử dụng Tailwind CDN hoặc icon emoji.
- **NFR-02 (Icons):** 100% sử dụng icon SVG outline chuẩn (Lucide SVG 16–20px).
- **NFR-03 (Performance & CSS):** Tận dụng và hoàn thiện `web/assets/css/auth.css` và `public-shell.css`, đảm bảo `auth.css` được nhúng đầy đủ trong các trang Auth.
- **NFR-04 (Responsive):** Thích ứng mượt mà trên cả 3 kích thước màn hình: Mobile (<768px), Tablet (768px - 1024px), Desktop (>1024px).
- **NFR-05 (Accessibility):** Tương thích đầu đọc màn hình, trường form có nhãn `<label for="...">`, thông báo lỗi rõ ràng.

---

## 5. Verification & Acceptance Criteria (DoD)
- [ ] Giao diện 4 trang `/login`, `/register`, `/forgot-password`, `/reset-password` đẹp hiện đại, chuẩn enterprise theo mẫu prototype đã lọc bỏ thành phần mock.
- [ ] Footer ở tất cả các trang dùng chung (`public-footer.jspf`) hiển thị đồng nhất, sang trọng, đầy đủ 4 cột và thông tin thực tế.
- [ ] Luồng đăng nhập, đăng ký, quên và đặt lại mật khẩu hoạt động trơn tru với backend JPA/Servlet hiện tại, không phát sinh lỗi validation hay CSRF.
- [ ] Build dự án bằng Ant `verify` thành công 100%, vượt qua toàn bộ 50+ test cases JUnit 5.
- [ ] Commit mã nguồn và push lên nhánh `main`.
