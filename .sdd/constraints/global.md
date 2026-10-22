# EDUCENTER GLOBAL TECHNICAL CONSTRAINTS
**Version:** 1.0.0 | **Layer:** Architecture & Code Conventions

---

## 1. MAPPING URL & SERVLET CONVENTIONS
* Mọi URL controller phải tuân thủ chuẩn kebab-case và REST-like:
  * Public: `/courses`, `/courses/detail`, `/consultation`, `/registration-cart`
  * Auth: `/login`, `/register`, `/forgot-password`, `/reset-password`, `/profile`
  * Staff: `/staff/leads`, `/staff/courses`, `/staff/students`, `/staff/classes`, `/staff/enrollments`, `/staff/invoices`
  * Teacher: `/teacher/dashboard`, `/teacher/classes`, `/teacher/attendance`, `/teacher/scores`
  * Student: `/student/dashboard`, `/student/schedule`, `/student/progress`, `/student/tuition`
  * Parent: `/parent/dashboard`, `/parent/children/detail`, `/parent/tuition`
  * Admin: `/admin/dashboard`, `/admin/users`, `/admin/reports`, `/admin/settings`

## 2. SERVLET - VIEW INTERACTION
* Servlet nhận request, lấy input parameters, kiểm tra hợp lệ sơ bộ.
* Gọi tầng Service để thực thi nghiệp vụ (không viết nghiệp vụ hay query DB trong Servlet).
* Đặt kết quả vào `request.setAttribute("attributeName", data)`.
* Forward tới view JSP nằm trong thư mục bảo vệ: `request.getRequestDispatcher("/WEB-INF/views/...").forward(request, response)`.
* Sau các thao tác `POST` (create, update, delete): Sử dụng Post/Redirect/Get (`response.sendRedirect(request.getContextPath() + "...")`) kết hợp Flash Message trong `session` để thông báo thành công hoặc lỗi.

## 3. PERSISTENCE & DATA CONVENTIONS
* CSDL: Microsoft SQL Server, kết nối qua file cấu hình `src/conf/META-INF/persistence.xml`.
* Persistence Unit name: `EduCenterPU`.
* Quản lý `EntityManagerFactory` tập trung qua class `com.educenter.util.JPAUtil`.
* Mọi entity ánh xạ JPA:
  * `@Entity`, `@Table(name = "...")`
  * `@Id`, `@GeneratedValue(strategy = GenerationType.IDENTITY)`
  * Kiểu dữ liệu tiền tệ: `@Column(name = "...", precision = 18, scale = 2) private BigDecimal fee;`
  * Quan hệ: `@ManyToOne`, `@OneToMany`, `@JoinColumn`. Tránh lazy loading exception bằng cách dùng JOIN FETCH trong JPQL khi cần load dữ liệu liên quan cho view.
