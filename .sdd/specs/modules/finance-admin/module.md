# MODULE SPEC: FINANCE & ADMINISTRATION SUBSYSTEM
**Module ID:** MOD-FINANCE-ADMIN | **Owner:** Member 03  
**Version:** 1.0.0 | **Inherits From:** `.sdd/constitution.md`  

---

## 1. PHẠM VI NGHIỆP VỤ (SCOPE)
* **M02 – Authentication & Account Management:** Đăng ký, đăng nhập, đăng xuất, quên mật khẩu, đổi mật khẩu, quản lý hồ sơ cá nhân, phân quyền 6 vai trò (`RBAC`).
* **M09 – Tuition & Payment:** Tạo hóa đơn từ ghi danh (`Invoices`, `InvoiceItems`), áp dụng ưu đãi (`Discounts`), ghi nhận thanh toán (`Payments`), theo dõi số tiền đã thu, còn nợ và công nợ (BR12, BR13, BR14).
* **M11 – Dashboard & Reporting:** Báo cáo tổng thể điều hành, doanh thu, tuyển sinh, chuyên cần sử dụng đầy đủ các hàm thống kê theo tiêu chí đề thi: `MAX`, `MIN`, `AVG`, `SUM`, `COUNT`.
* **M12 – System Administration & Audit Logs:** Quản lý tài khoản, vai trò, danh mục phòng học, thiết lập tham số hệ thống (`SystemSettings`), theo dõi nhật ký thao tác (`AuditLogs`) cho các hành động trọng yếu (BR18).

## 2. API & CONTROLLER CONTRACT
* `AuthServlet` (`/login`, `/register`, `/logout`, `/forgot-password`, `/reset-password`, `/profile`)
* `InvoiceServlet` (`/staff/invoices`, `/staff/invoices/detail`, `/staff/invoices/payment`)
* `StudentTuitionServlet` (`/student/tuition`)
* `ParentTuitionServlet` (`/parent/tuition`)
* `DashboardServlet` (`/admin/dashboard`)
* `ReportServlet` (`/admin/reports`)
* `UserManagementServlet` (`/admin/users`)
* `SystemSettingServlet` (`/admin/settings`)
* `Filter`: `AuthenticationFilter`, `RoleFilter`, `CSRFFilter`, `EncodingFilter`

## 3. DATABASE ENTITIES (JPA)
* `Users`, `Roles`, `UserRoles`, `Invoices`, `InvoiceItems`, `Payments`, `Discounts`, `AuditLogs`, `SystemSettings`.

## 4. MODULE-LEVEL CONSTRAINTS
* Mật khẩu bắt buộc băm bằng BCrypt (SEC-01).
* Mọi giao dịch tài chính dùng `BigDecimal` / `DECIMAL(18,2)` và lưu vết không xóa vật lý (SEC-03, BR16).
* Báo cáo tách biệt rõ ràng tiền đã thu và số tiền còn phải thu (BR20).
