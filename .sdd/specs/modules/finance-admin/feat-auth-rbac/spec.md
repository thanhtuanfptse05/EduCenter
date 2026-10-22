# Feature: Authentication & Role-Based Access Control (feat-auth-rbac) — SPECIFICATION
**Status:** Approved | **Version:** 1.0.0 | **Date:** 2026-10-22  
**Module ID:** `MOD-FINANCE-ADMIN` (M02 – Authentication & Account Management, M12 – User Administration)  
**Author / Owner:** Member 03 (Finance & Infrastructure)  
**Inherits From:**  
- Layer 1: `.sdd/constitution.md` (Article 1, Article 2 SEC-01, SEC-02)
- Layer 2: `.sdd/specs/modules/finance-admin/module.md`
- Constraints: `.sdd/constraints/global.md`, `.sdd/constraints/safety.md`, `.sdd/constraints/business.md` (BR01, BR02, BR18)
- UI/UX Standard: `design.md` (Default Light mode, Design Tokens, Lucide SVG outline icons, No Tailwind CDN)

---

## 1. Business Context & Goal

* **Why:** Mọi hoạt động trong EduCenter (tiếp nhận Lead, tư vấn, xếp lớp, điểm danh, nhập điểm, thanh toán học phí) đều gắn liền với danh tính và vai trò của người thực hiện. Tính năng này thiết lập hạ tầng định danh, bảo mật phiên làm việc và phân quyền đa cấp bậc.
* **Mục tiêu Assignment PRJ301:** Đáp ứng trọn vẹn **Mục 3.1 – Xác thực người dùng (1,0 điểm)** với đầy đủ 5 chức năng bắt buộc:
  1. Đăng ký tài khoản (`/register`)
  2. Đăng nhập / Đăng xuất (`/login`, `/logout`)
  3. Quên / Đặt lại mật khẩu (`/forgot-password`, `/reset-password`)
  4. Cập nhật hồ sơ tài khoản và đổi mật khẩu (`/profile`)
  5. Quản lý vai trò và phân quyền theo 6 vai trò chuẩn (`/admin/users`)
* **Impact:** Tác động trực tiếp lên toàn bộ 12 module của hệ thống. Kiểm soát toàn bộ lưu lượng truy cập qua bộ lọc `AuthenticationFilter` và `RoleFilter`.

---

## 2. User Personas & Roles

| Vai trò (Role) | Mã Code | Quyền hạn & Không gian truy cập |
|---|---|---|
| **Guest** | `GUEST` | Xem danh mục khóa học public, gửi yêu cầu tư vấn, đăng ký tài khoản, đăng nhập, quên mật khẩu. |
| **System Admin** | `ADMIN` | Toàn quyền cấu hình hệ thống, quản lý tài khoản, cấp/thu hồi vai trò, khóa/mở tài khoản, xem Audit Logs. |
| **Center Manager** | `MANAGER` | Xem báo cáo tài chính, học vụ, điều hành lớp học, phê duyệt khóa học/kết quả. |
| **Admission Staff** | `STAFF` | Quản lý Leads, tư vấn, hồ sơ học viên/phụ huynh, ghi danh, xếp lịch, lập hóa đơn, thu học phí. |
| **Teacher / Tutor** | `TEACHER` | Xem lịch giảng dạy, buổi học được phân công, điểm danh, viết nhật ký dạy, tạo bài kiểm tra, nhập điểm. |
| **Student** | `STUDENT` | Xem lịch học cá nhân, kết quả học tập công bố, chuyên cần, tra cứu học phí, gửi câu hỏi Q&A. |
| **Parent / Guardian**| `PARENT` | Theo dõi chuyên cần, điểm số, học phí của con (chỉ học sinh đã được xác thực liên kết giám hộ). |

---

## 3. User Stories

### Story 1 (Happy Path - Đăng nhập phân luồng):
> Là một **Người dùng đã có tài khoản**,  
> Tôi muốn nhập email và mật khẩu tại trang `/login` để đăng nhập vào hệ thống,  
> Để hệ thống xác thực, lưu thông tin vào Session và tự động chuyển hướng tôi về Dashboard tương ứng với vai trò của tôi (Admin -> `/admin/dashboard`, Staff -> `/staff/leads`, Teacher -> `/teacher/dashboard`, Student -> `/student/dashboard`, Parent -> `/parent/dashboard`).

### Story 2 (Happy Path - Đăng ký tài khoản):
> Là một **Khách ghé thăm (Guest)**,  
> Tôi muốn điền form đăng ký gồm Họ tên, Email, Số điện thoại và Mật khẩu tại `/register`,  
> Để tạo tài khoản mới với vai trò mặc định là `STUDENT` (hoặc `PARENT` theo lựa chọn) và được chuyển đến trang đăng nhập với thông báo thành công.

### Story 3 (Edge/Error Path - Sai mật khẩu hoặc tài khoản bị khóa):
> Là một **Người dùng đăng nhập không hợp lệ**,  
> Khi tôi nhập sai mật khẩu hoặc tài khoản của tôi đang ở trạng thái `LOCKED`,  
> Tôi muốn nhận được thông báo lỗi rõ ràng trên giao diện, giữ lại email đã nhập và không bị chuyển trang vô cớ.

### Story 4 (Happy Path - Cập nhật hồ sơ & Đổi mật khẩu):
> Là một **Người dùng đã đăng nhập**,  
> Tôi muốn vào trang `/profile` để cập nhật họ tên, số điện thoại, ảnh đại diện và đổi mật khẩu mới (yêu cầu xác thực mật khẩu cũ),  
> Để thông tin cá nhân của tôi luôn chính xác và tài khoản được bảo mật an toàn.

### Story 5 (Happy Path - Quản trị viên phân quyền & Khóa tài khoản):
> Là một **System Admin**,  
> Tôi muốn xem danh sách tài khoản tại `/admin/users`, thực hiện tìm kiếm, lọc theo vai trò/trạng thái, gán/hủy vai trò và chuyển trạng thái `ACTIVE` <-> `LOCKED`,  
> Để quản lý nhân sự trung tâm và bảo vệ hệ thống trước các tài khoản vi phạm.

### Story 6 (Security Path - Truy cập trái phép bị chặn):
> Là một **Học viên cố tình gõ URL quản trị** (ví dụ `/admin/users` hoặc `/staff/invoices`),  
> Tôi muốn hệ thống chặn lại và chuyển hướng về trang `/errors/403` (Forbidden) với thông báo từ chối truy cập rõ ràng.

---

## 4. Acceptance Criteria (EARS Notation)

### 4.1 Ubiquitous Requirements (Yêu cầu phổ quát hệ thống)
* **THE SYSTEM SHALL** băm toàn bộ mật khẩu người dùng bằng thuật toán **BCrypt** với work factor/cost >= 10 trước khi lưu trữ vào CSDL (**SEC-01**).
* **THE SYSTEM SHALL** chuẩn hóa địa chỉ email về chữ thường (`email.trim().toLowerCase()`) trước khi kiểm tra tồn tại hoặc lưu vào bảng `Users` (**BR01**).
* **THE SYSTEM SHALL** mã hóa toàn bộ dữ liệu request/response bằng bảng mã **UTF-8** thông qua `EncodingFilter`.
* **THE SYSTEM SHALL** duy trì phiên làm việc người dùng qua `HttpSession` với timeout mặc định là 30 phút.

### 4.2 Event-Driven Requirements (Yêu cầu xử lý sự kiện)
* **WHEN** người dùng gửi form đăng ký tại `/register` với email chưa từng tồn tại và mật khẩu hợp lệ (tối thiểu 6 ký tự):
  * **THE SYSTEM SHALL** tạo bản ghi trong `Users` (trạng thái `ACTIVE`), băm mật khẩu, gán vai trò được chọn vào `UserRoles`, lưu flash message thành công vào session và chuyển hướng (`redirect`) sang `/login`.
* **WHEN** người dùng đăng nhập tại `/login` với thông tin chính xác và trạng thái `ACTIVE`:
  * **THE SYSTEM SHALL** lưu đối tượng `UserPrincipalDTO` (chứa `userId`, `fullName`, `email`, `roleCodes`) vào `session.setAttribute("currentUser", principal)`, đồng thời chuyển hướng (`redirect`) đến Dashboard của vai trò có quyền cao nhất.
* **WHEN** người dùng bấm nút Đăng xuất (`POST /logout` hoặc `GET /logout`):
  * **THE SYSTEM SHALL** hủy `HttpSession` hiện tại (`session.invalidate()`) và chuyển hướng về `/login?loggedOut=true`.
* **WHEN** người dùng yêu cầu đổi mật khẩu tại `/profile`:
  * **THE SYSTEM SHALL** kiểm tra mật khẩu hiện tại bằng `BCrypt.checkpw()`. Nếu trùng khớp, băm mật khẩu mới và lưu vào CSDL; nếu không khớp, trả về thông báo lỗi "Mật khẩu hiện tại không đúng".
* **WHEN** Quản trị viên thay đổi trạng thái hoặc vai trò người dùng tại `/admin/users`:
  * **THE SYSTEM SHALL** thực thi trong Transaction, cập nhật `UserRoles` / `Users.status`, và tự động ghi một bản ghi vào `AuditLogs` với hành động `CHANGE_ROLE` hoặc `UPDATE_USER_STATUS` (**BR18**).

### 4.3 State-Driven Requirements (Yêu cầu theo trạng thái)
* **WHILE** tài khoản người dùng đang ở trạng thái `LOCKED`:
  * **THE SYSTEM SHALL** từ chối mọi yêu cầu đăng nhập và thông báo: *"Tài khoản của bạn đã bị tạm khóa. Vui lòng liên hệ ban quản trị để được hỗ trợ."*
* **WHILE** một request gửi tới các route bảo vệ (`/admin/*`, `/staff/*`, `/teacher/*`, `/student/*`, `/parent/*`) mà không có `currentUser` trong session:
  * **THE SYSTEM SHALL** chặn request và chuyển hướng về `/login` kèm tham số `redirect_url` để chuyển tiếp lại sau khi đăng nhập thành công.

### 4.4 Unwanted Behavior & Exception Handling (Xử lý ngoại lệ)
* **IF** người dùng gửi form đăng ký với email đã tồn tại trong hệ thống:
  * **THEN THE SYSTEM SHALL** hiển thị thông báo lỗi: *"Địa chỉ email này đã được đăng ký trong hệ thống."*, giữ lại các trường đã nhập (ngoại trừ mật khẩu) và không sinh bản ghi lỗi trong CSDL.
* **IF** người dùng đã đăng nhập nhưng không có vai trò phù hợp để truy cập đường dẫn yêu cầu (ví dụ: `STUDENT` truy cập `/admin/*`):
  * **THEN THE SYSTEM SHALL** chuyển tiếp sang trang `/errors/403` với thông báo *"Bạn không có quyền truy cập vào chức năng này."* mà không để lộ stacktrace máy chủ.
* **IF** người dùng cố gắng tự khóa hoặc tước quyền `ADMIN` của chính mình khi là quản trị viên duy nhất:
  * **THEN THE SYSTEM SHALL** từ chối thao tác và báo lỗi: *"Không thể vô hiệu hóa tài khoản quản trị viên tối cao đang đăng nhập."*

---

## 5. UI/UX & Navigation Mapping (Tuân Thủ 100% design.md)

### 5.1 Bảng Danh Sách Màn Hình & URL

| Screen ID | Tên Màn Hình | URL (HTTP Method) | JSP View Path | Vai Trò Cho Phép |
|---|---|---|---|---|
| **AUTH-01** | Đăng nhập | `GET /login`<br>`POST /login` | `/WEB-INF/views/auth/login.jsp` | Guest / All |
| **AUTH-02** | Đăng ký tài khoản | `GET /register`<br>`POST /register` | `/WEB-INF/views/auth/register.jsp` | Guest |
| **AUTH-03** | Quên mật khẩu | `GET /forgot-password`<br>`POST /forgot-password` | `/WEB-INF/views/auth/forgot-password.jsp` | Guest |
| **AUTH-04** | Đặt lại mật khẩu | `GET /reset-password`<br>`POST /reset-password` | `/WEB-INF/views/auth/reset-password.jsp` | Guest |
| **AUTH-05** | Hồ sơ cá nhân | `GET /profile`<br>`POST /profile` | `/WEB-INF/views/auth/profile.jsp` | Đã đăng nhập (All) |
| **ADM-18** | Quản lý người dùng | `GET /admin/users`<br>`POST /admin/users` | `/WEB-INF/views/admin/user-list.jsp` | Admin |
| **SYS-01** | Lỗi 403 Forbidden | `GET /errors/403` | `/WEB-INF/views/common/403.jsp` | All |

### 5.2 Quy Chuẩn Giao Diện Chi Tiết Theo design.md
* **Default Light Mode:** Toàn bộ màn hình Auth (Card căn giữa 420–480px) và màn hình Quản trị Users (Bảng quản trị) áp dụng giao diện nền sáng `--bg: #F8FAFC`, card `--surface: #FFFFFF` với bo góc `border-radius: 10px`, đường viền `1px solid var(--border)`.
* **Typography & Tokens:** Font chữ chuẩn `Inter`, cỡ chữ 14px cho input/label, tiêu đề màn hình 24px semi-bold (`weight: 650`).
* **Icons:** Bộ icon Lucide outline SVG nhúng inline (SVG `stroke="currentColor"`, kích thước 18px), tuyệt đối không dùng emoji:
  * Icon Mail (hộp thư): trường nhập email
  * Icon Lock (khóa): trường nhập mật khẩu
  * Icon User (người dùng): trường nhập họ tên
  * Icon Phone (điện thoại): trường số điện thoại
  * Icon Shield-Check (khiên bảo mật): huy hiệu vai trò
* **Flash Message & Feedback:** Hiển thị thông báo qua component alert (`alert-success`, `alert-danger`) đặt ngay trên đầu form, tự động xóa flash message khỏi session sau khi render.

---

## 6. Data Model & JPA Entity Design

### 6.1 Entity Quan Hệ
* **`User` (`Users`):**
  * `id`: `Long` (`@Id @GeneratedValue(strategy = GenerationType.IDENTITY)`)
  * `email`: `String` (unique, lowercase, length 255)
  * `passwordHash`: `String` (length 255)
  * `fullName`: `String` (Nationalized, length 150)
  * `phone`: `String` (length 20)
  * `avatarUrl`: `String` (length 500)
  * `status`: `String` (`ACTIVE`, `INACTIVE`, `LOCKED`)
  * `createdAt`, `updatedAt`: `LocalDateTime`
  * `roles`: `@ManyToMany` thông qua bảng liên kết `UserRoles`
* **`Role` (`Roles`):**
  * `id`: `Integer` (`@Id @GeneratedValue(strategy = GenerationType.IDENTITY)`)
  * `code`: `String` (unique, uppercase: `ADMIN`, `MANAGER`, `STAFF`, `TEACHER`, `STUDENT`, `PARENT`)
  * `name`: `String` (Nationalized, length 100)
  * `description`: `String`
* **`AuditLog` (`AuditLogs`):**
  * Lưu vết khi đổi trạng thái hoặc vai trò tài khoản (**BR18**).

### 6.2 DTOs (Data Transfer Objects)
* `LoginRequestDTO`: email, password, rememberMe.
* `RegisterRequestDTO`: fullName, email, phone, roleCode (`STUDENT` hoặc `PARENT`), password, confirmPassword.
* `ProfileUpdateDTO`: fullName, phone, avatarUrl, currentPassword, newPassword, confirmNewPassword.
* `UserPrincipalDTO`: userId, email, fullName, roleCodes (Set<String>), primaryRole.

### 6.3 Repository Methods (JPQL Chuẩn, Tuyệt Đối Không Dùng JDBC)
* `User findByEmail(String email)`: `SELECT u FROM User u LEFT JOIN FETCH u.roles WHERE LOWER(u.email) = LOWER(:email)`
* `boolean existsByEmail(String email)`: `SELECT COUNT(u) > 0 FROM User u WHERE LOWER(u.email) = LOWER(:email)`
* `List<User> searchUsers(String keyword, String roleCode, String status, int offset, int limit)`
* `long countUsers(String keyword, String roleCode, String status)`

---

## 7. Security Filters & Routing Matrix

### 7.1 Filter Pipeline (Cấu hình trong `web.xml`)
```text
Client Request 
  ──> [EncodingFilter] (Force UTF-8 Request/Response)
  ──> [AuthenticationFilter] (Kiểm tra session login cho các route nội bộ)
  ──> [RoleFilter] (Kiểm tra vai trò theo tiền tố URL)
  ──> [Target Servlet Controller]
```

### 7.2 Ma Trận Phân Quyền URL (Role Mapping)

| Tiền tố URL | Vai trò được phép truy cập | Xử lý khi vi phạm |
|---|---|---|
| `/admin/*` | `ADMIN` | Chuyển hướng `/errors/403` |
| `/staff/*` | `STAFF`, `MANAGER`, `ADMIN` | Chuyển hướng `/errors/403` |
| `/teacher/*` | `TEACHER`, `ADMIN` | Chuyển hướng `/errors/403` |
| `/student/*` | `STUDENT`, `ADMIN` | Chuyển hướng `/errors/403` |
| `/parent/*` | `PARENT`, `ADMIN` | Chuyển hướng `/errors/403` |
| `/profile` | Tất cả người dùng đã đăng nhập | Chuyển hướng `/login` |
| `/login`, `/register`, `/forgot-password`, `/courses`, `/` | Public (Ai cũng vào được; nếu đã đăng nhập thì tự chuyển về Dashboard) | Cho phép tiếp tục |

---

## 8. Definition of Done (DoD)

- [ ] Spec này được phê duyệt và khóa nội dung (`Status: Approved`).
- [ ] JPA Entities (`User`, `Role`, `AuditLog`) ánh xạ chính xác với SQL Server schema `EduCenterDB`.
- [ ] Lớp `UserRepository` và `RoleRepository` dùng 100% JPA `EntityManager` & JPQL, không có bất kỳ dòng JDBC thuần nào.
- [ ] `AuthService` triển khai đầy đủ validation, băm BCrypt cost 10, quản lý transaction.
- [ ] `EncodingFilter`, `AuthenticationFilter`, `RoleFilter` hoạt động chính xác theo ma trận phân quyền.
- [ ] Toàn bộ 5 màn hình (`login.jsp`, `register.jsp`, `forgot-password.jsp`, `profile.jsp`, `user-list.jsp`, `403.jsp`) tuân thủ 100% `design.md` (Default Light mode, icon outline SVG Lucide, biến Design Tokens, responsive).
- [ ] JUnit 5 tests cho `AuthService`: kiểm thử băm mật khẩu, đăng nhập thành công, đăng nhập sai pass, email trùng lặp, tài khoản bị khóa.
- [ ] Commit và push lên nhánh `main`.
