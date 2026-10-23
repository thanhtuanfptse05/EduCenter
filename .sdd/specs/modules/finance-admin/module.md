# MODULE SPEC: FINANCE & ADMINISTRATION SUBSYSTEM
**Module ID:** MOD-FINANCE-ADMIN | **Owner:** Member 03  
**Version:** 1.0.0 | **Inherits From:** `.sdd/constitution.md`  

---


## Baseline đặc tả đầy đủ — 2026-10-23

[Danh mục chung](../../README.md), [hợp đồng dữ liệu](../../data-contract.md), [tích hợp/quyền](../../integration.md), [screen-map chuẩn](../../screen-map.md) và [thứ tự code](../../implementation-order.md) áp dụng cho mọi feature bên dưới. Các tên Controller trong tài liệu module là hợp đồng logic đề xuất, cần đối chiếu code hiện hữu khi plan; không tạo Controller/route trùng. Danh sách này mô tả phạm vi, không chứng nhận đã implement.

| Feature | Spec | UC liên quan |
|---|---|---|
| feat-tuition-payment | [Học phí, hóa đơn, thanh toán và công nợ](feat-tuition-payment/spec.md) | UC25, UC26, UC27 |
| feat-dashboard-reporting | [Dashboard và báo cáo đối soát toàn trung tâm](feat-dashboard-reporting/spec.md) | UC31, UC32, UC33 |
| feat-system-administration | [Cấu hình, danh mục và nhật ký hệ thống](feat-system-administration/spec.md) | UC05, UC34, UC35 |
| feat-auth-rbac | [Xác thực, hồ sơ và quản lý tài khoản](feat-auth-rbac/spec.md) | UC01, UC02, UC03, UC04, UC05 |

ADMIN gộp System Admin/Center Manager trong MVP; các nghiệp vụ Manager vẫn được bao phủ. Room do class-timetable sở hữu CRUD; tài khoản/role do auth-rbac sở hữu; system-administration chỉ điều hướng các nghiệp vụ đó.

## 1. PHẠM VI NGHIỆP VỤ (SCOPE)
* **M02 – Authentication & Account Management:** Đăng ký, đăng nhập, đăng xuất, quên mật khẩu, đổi mật khẩu, hồ sơ cá nhân; RBAC 5 mã MVP (`ADMIN`, `STAFF`, `TEACHER`, `STUDENT`, `PARENT`) bao phủ 6 trách nhiệm SRS vì ADMIN gộp System Admin và Center Manager theo quyết định D01.
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
