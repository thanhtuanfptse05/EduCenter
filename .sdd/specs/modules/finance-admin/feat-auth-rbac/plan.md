# Implementation Plan: Authentication & Role-Based Access Control (feat-auth-rbac)

> **Artifact baseline: historical v1.** N?i dung/checkbox d??i ??y thu?c phi?n b?n tr??c; spec v2 hi?n h?nh l? [spec.md](spec.md). Ph?i c?p nh?t plan/tasks v? c?c h?p ??ng t??ng ?ng tr??c khi code v2; kh?ng d?ng tr?ng th?i Completed ho?c chi ti?t m?u thu?n ? ??y l?m b?ng ch?ng ?? ??t v2. H?p ??ng chung t?i [integration.md](../../../integration.md) v? th? t? tri?n khai t?i [implementation-order.md](../../../implementation-order.md).

**Status:** Approved / Locked | **Version:** 1.1.0 | **Feature Spec:** `spec.md`  
**Target Module:** `MOD-FINANCE-ADMIN` | **Owner:** Member 03  
**Architecture Pattern:** MVC (Jakarta Servlet + JPA 3.1 Hibernate + JSP/JSTL + SQL Server)  

---

## 1. Technical Context & Platform Alignment

| Yếu Tố | Đặc Tả Kỹ Thuật | Tuân Thủ Hiến Chương & Đề PRJ301 |
|---|---|---|
| **JDK** | OpenJDK 17 (Java 17) | Article 1 (LTS) |
| **Servlet Namespace** | `jakarta.servlet.*`, `jakarta.servlet.http.*` | Tomcat 10.1 (Jakarta EE 10) |
| **JPA / ORM** | `jakarta.persistence.*`, Hibernate ORM 6.x | Không dùng JDBC thuần (ASM PRJ301) |
| **Database** | Microsoft SQL Server (`EduCenterDB`) | Bảng `Users`, `Roles`, `UserRoles`, `AuditLogs` |
| **Mã Hóa Mật Khẩu** | BCrypt (`jBCrypt` / `org.mindrot.jbcrypt`, cost = 10) | SEC-01 (Cấm tuyệt đối plaintext / MD5) |
| **View Template** | JSP + JSTL (`jakarta.tags.core`) + EL `${...}` | Tuyệt đối không dùng Java Scriptlet `<% %>` |
| **Design System** | `design.md` (Default Light mode, Inter, Lucide SVG, Tokens) | Không dùng CDN Tailwind |

---

## 2. Component Architecture & Class Responsibilities

```text
HTTP Request
     │
     ▼
[com.educenter.filter.EncodingFilter]         (UTF-8 Encoding)
     │
     ▼
[com.educenter.filter.AuthenticationFilter]   (Bảo vệ URL nội bộ, kiểm tra session)
     │
     ▼
[com.educenter.filter.RoleFilter]             (Kiểm tra quyền RBAC theo tiền tố /admin, /staff, ...)
     │
     ▼
[com.educenter.controller.AuthServlet]        (Xử lý GET/POST /login, /register, /logout, /profile)
[com.educenter.controller.UserManagementServlet] (Quản lý User & Role cho Admin)
     │
     ▼
[com.educenter.service.AuthService]           (Nghiệp vụ: authenticate, register, changePassword)
[com.educenter.service.UserService]           (Nghiệp vụ: list, lock, updateRoles, auditLog)
     │
     ▼
[com.educenter.repository.UserRepository]     (JPA EntityManager, JPQL)
[com.educenter.repository.RoleRepository]     (JPA EntityManager, JPQL)
     │
     ▼
[Microsoft SQL Server: EduCenterDB]           (Tables: Users, Roles, UserRoles, AuditLogs)
```

### 2.1 Package `com.educenter.util`
* **`JPAUtil.java`**: Quản lý singleton `EntityManagerFactory` từ persistence unit `"EduCenterPU"`. Cung cấp phương thức `getEntityManager()` và đóng factory khi shutdown.
* **`PasswordUtil.java`**:
  * `String hashPassword(String plainPassword)`: Sử dụng BCrypt băm mật khẩu với salt cost = 10.
  * `boolean verifyPassword(String plainPassword, String hashedPassword)`: Kiểm tra khớp mật khẩu an toàn chống timing attack.
* **`FlashMessageUtil.java`**: Hỗ trợ lưu thông báo `SUCCESS` / `ERROR` vào `session` và dọn dẹp sau khi render (mô hình Post/Redirect/Get).

### 2.2 Package `com.educenter.entity`
* **`User.java`**: Ánh xạ bảng `dbo.Users`.
  * Thuộc tính: `id`, `email`, `passwordHash`, `fullName`, `phone`, `avatarUrl`, `status`, `createdAt`, `updatedAt`.
  * Quan hệ: `@ManyToMany` với `Role` qua `UserRoles`.
* **`Role.java`**: Ánh xạ bảng `dbo.Roles`.
  * Thuộc tính: `id`, `code`, `name`, `description`, `createdAt`.
* **`AuditLog.java`**: Ánh xạ bảng `dbo.AuditLogs`.
  * Ghi nhật ký thao tác `CHANGE_ROLE`, `LOCK_USER`, `UNLOCK_USER`.

### 2.3 Package `com.educenter.dto`
* **`UserPrincipalDTO.java`**: DTO gọn nhẹ lưu trong `session.getAttribute("currentUser")`.
* **`LoginRequestDTO.java`**: Form submit đăng nhập.
* **`RegisterRequestDTO.java`**: Form submit đăng ký.
* **`ProfileUpdateDTO.java`**: Form cập nhật hồ sơ và đổi mật khẩu.

### 2.4 Package `com.educenter.repository`
* **`UserRepository.java`**:
  * `Optional<User> findByEmail(String email)`: JPQL tìm theo email (chữ thường).
  * `boolean existsByEmail(String email)`: JPQL kiểm tra email tồn tại.
  * `List<User> searchUsers(String keyword, String roleCode, String status, int offset, int limit)`
  * `long countUsers(String keyword, String roleCode, String status)`
  * `void save(User user)`, `void update(User user)`
* **`RoleRepository.java`**:
  * `Optional<Role> findByCode(String code)`: JPQL tìm vai trò theo mã.
  * `List<Role> findAll()`

### 2.5 Package `com.educenter.service`
* **`AuthService.java`**:
  * `UserPrincipalDTO login(String email, String password)`: Xác thực email + pass, kiểm tra trạng thái `ACTIVE`, trả về Principal hoặc ném Exception (`BadCredentialsException`, `AccountLockedException`).
  * `User register(RegisterRequestDTO dto)`: Validate email chưa tồn tại (**BR01**), băm mật khẩu, gán vai trò `STUDENT`/`PARENT`, lưu vào CSDL trong transaction.
  * `void changePassword(Long userId, String oldPassword, String newPassword)`: Xác thực mật khẩu cũ, băm và cập nhật mật khẩu mới.
* **`UserService.java`**:
  * `User updateUserProfile(Long userId, ProfileUpdateDTO dto)`: Cập nhật họ tên, phone, avatar.
  * `void toggleUserStatus(Long adminId, Long targetUserId, String newStatus)`: Khóa hoặc mở khóa tài khoản, ghi `AuditLogs` (**BR18**).
  * `void assignRoles(Long adminId, Long targetUserId, Set<String> roleCodes)`: Cập nhật vai trò, ghi `AuditLogs` (**BR18**).

### 2.6 Package `com.educenter.filter`
* **`EncodingFilter.java`**: Áp dụng cho mọi URL (`/*`), set `request.setCharacterEncoding("UTF-8")` và `response.setCharacterEncoding("UTF-8")`.
* **`AuthenticationFilter.java`**: Kiểm tra các URL yêu cầu đăng nhập (`/admin/*`, `/staff/*`, `/teacher/*`, `/student/*`, `/parent/*`, `/profile`). Chuyển hướng `/login` nếu chưa đăng nhập.
* **`RoleFilter.java`**: Kiểm tra vai trò trong `UserPrincipalDTO`:
  * Route `/admin/*`: yêu cầu role `ADMIN` (Quản trị viên kiêm Quản lý trung tâm).
  * Route `/staff/*`: yêu cầu role `STAFF` hoặc `ADMIN`.
  * Route `/teacher/*`: yêu cầu role `TEACHER` hoặc `ADMIN`.
  * Route `/student/*`: yêu cầu role `STUDENT` hoặc `ADMIN`.
  * Route `/parent/*`: yêu cầu role `PARENT` hoặc `ADMIN`.
  * Sai quyền: chuyển tiếp về `/errors/403`.

### 2.7 Package `com.educenter.controller`
* **`AuthServlet.java`**:
  * `GET /login`: Render `login.jsp`.
  * `POST /login`: Xử lý submit đăng nhập, chuyển hướng Dashboard theo vai trò.
  * `GET /register`: Render `register.jsp`.
  * `POST /register`: Xử lý đăng ký, chuyển hướng `/login` kèm flash message.
  * `GET /logout`: Invalidate session, chuyển hướng `/login`.
  * `GET /profile`: Render `profile.jsp`.
  * `POST /profile`: Cập nhật thông tin/mật khẩu, chuyển hướng `/profile` kèm flash message.
  * `GET /forgot-password`: Render `forgot-password.jsp`.
* **`UserManagementServlet.java`**:
  * `GET /admin/users`: Tìm kiếm, phân trang người dùng, render `user-list.jsp`.
  * `POST /admin/users/status`: Khóa / mở khóa người dùng.
  * `POST /admin/users/roles`: Cập nhật vai trò người dùng.

---

## 3. View & UI Design Implementation (Tuân Thủ design.md)

### 3.1 Cấu Trúc File Giao Diện
```text
web/
├── assets/
│   ├── css/
│   │   ├── tokens.css       (Biến CSS Design Tokens: --bg, --surface, --primary, ...)
│   │   ├── auth.css         (Giao diện đăng nhập, đăng ký dạng Card 440px)
│   │   └── admin.css        (Bảng danh sách người dùng, badges, modal phân quyền)
│   └── js/
│       ├── theme.js         (Default Light mode, localStorage 'educenter-theme')
│       └── auth.js          (Validation form client-side, toggle hiện/ẩn mật khẩu)
└── WEB-INF/views/
    ├── common/
    │   ├── alert.jsp        (Component thông báo lỗi/thành công)
    │   └── 403.jsp          (Trang thông báo từ chối truy cập)
    ├── auth/
    │   ├── login.jsp        (AUTH-01: Giao diện đăng nhập)
    │   ├── register.jsp     (AUTH-02: Giao diện đăng ký tài khoản)
    │   ├── forgot-password.jsp (AUTH-03: Giao diện quên mật khẩu)
    │   └── profile.jsp      (AUTH-05: Hồ sơ cá nhân & đổi mật khẩu)
    └── admin/
        └── user-list.jsp    (ADM-18: Bảng quản trị người dùng & vai trò)
```

### 3.2 Quy Chuẩn Giao Diện Bắt Buộc:
* **Theme Light Mặc Định:** File `tokens.css` định nghĩa các biến sáng; script nạp trong `<head>` trước CSS:
  ```html
  <script>
    (function () {
      var theme = 'light';
      try { if (localStorage.getItem('educenter-theme') === 'dark') theme = 'dark'; } catch (e) {}
      document.documentElement.setAttribute('data-theme', theme);
    })();
  </script>
  ```
* **Icon:** Toàn bộ SVG outline lấy từ bộ Lucide SVG inline:
  * Icon Mail: `<svg class="lucide-icon" ...><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>`
  * Icon Lock: `<svg class="lucide-icon" ...><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>`
* **Cấm Tailwind CDN:** Mọi style dùng CSS thuần viết trong `tokens.css` và `auth.css`.

---

## 4. Test Strategy & Verification Plan

### Implementation supplement (locked 2026-10-22)

- Keep NetBeans Ant import; add portable Ant targets `dependencies`, `verify`, `war` with pinned dependency manifest. Runtime libraries go to web/WEB-INF/lib; test libraries stay in build/tools. No Maven build migration.
- JPAUtil reads EDUCENTER_DB_URL/USER/PASSWORD (or corresponding system properties), disables automatic DDL and closes the factory at shutdown. Preserve existing SQL schema; add a non-destructive PasswordResetTokens migration.
- Add PasswordResetToken entity (user_id, token_hash unique, expires_at, consumed_at, created_at). Service owns every transaction; repositories receive its EntityManager and never close it.
- Inject EntityManager supplier and ResetMailSender for tests; SMTP uses Jakarta Mail/Angus with STARTTLS, configured public application URL, no Host-header-derived reset links. No automatic email during tests.
- CsrfFilter follows Encoding/Authentication/Role filters. On protected non-auth paths, denied requests forward to 403. On public auth endpoints (/login, /register, /forgot-password, /reset-password), CSRF mismatches or stale sessions are gracefully refreshed and redirected with a flash message instead of throwing HTTP 403. EncodingFilter injects Cache-Control no-cache/no-store to eliminate bfcache session leakage. Authentication refreshes principal and compares a session credential fingerprint against current password hash; changed passwords expire old sessions.
- Profile page (AUTH-05) is streamlined into 2 direct operational cards (Personal info update and Password change), eliminating dummy 2FA, fake RBAC matrix table, and mock device history list/counter.
- Admin changes lock the ADMIN role first, then actor/target to serialize last-admin checks. User/password/reset writes lock user before tokens to avoid inverse lock ordering. Audit uses exact SQL column mappings and nationalized text.
- Add reset-password JSP and controller paths; common head/header/footer/alerts; role landing servlet provides only actual account data and links implemented here.
- Test with JUnit 5 + H2 in MSSQLServer mode for isolated persistence tests, embedded Tomcat/Jasper for HTTP/JSP contract tests; SQL Server remains production and requires a separate integration gate. Browser QA is distinct from HTTP tests.
- Dependencies: Hibernate ORM 6.4.10.Final, Jakarta Persistence 3.1, Servlet 6, Tags 3, jBCrypt 0.4, SQL Server JDBC 12.6.1.jre11; exact transitives recorded in dependencies.json.


1. **Unit Testing (JUnit 5):**
   * `PasswordUtilTest`: Kiểm tra băm BCrypt, so khớp pass đúng/sai.
   * `AuthServiceTest`:
     * Đăng nhập thành công với tài khoản active.
     * Đăng nhập thất bại khi sai mật khẩu.
     * Đăng nhập thất bại khi tài khoản bị khóa (`LOCKED`).
     * Đăng ký thành công với email hợp lệ.
     * Đăng ký thất bại khi email đã tồn tại (**BR01**).
2. **Integration & Manual Testing:**
   * Truy cập trực tiếp `/admin/dashboard` khi chưa login -> Kỳ vọng chuyển về `/login`.
   * Đăng nhập tài khoản Student -> Cố tình gõ `/admin/users` -> Kỳ vọng hiển thị `/errors/403`.
   * Thử nghiệm toggle theme Light/Dark, kiểm tra refresh trang giữ nguyên theme.
   * Tạo tài khoản mới tại `/register`, đăng nhập thử và kiểm tra bản ghi trong bảng `Users` và `UserRoles` của SQL Server.
