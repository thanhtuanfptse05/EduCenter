# AGENTS.md — Project Context for AI Coding Agents
**Version:** 1.1.0 | **Updated:** 2026-10-22 | **Project:** EduCenter (Tutoring & Exam Prep ERP)  
**IDE & Environment:** NetBeans IDE 17 | Apache Tomcat 10.1 | Java 17 | SQL Server  

---

## 1. PROJECT OVERVIEW
* **Name:** EduCenter – Tutoring & Exam Preparation Management System
* **Type:** Java Web Application (Jakarta Servlet + JSP + JPA + SQL Server)
* **Team:** 3 Members (Member 01: Academic, Member 02: Admission, Member 03: Finance & Admin)
* **Domain:** Trung tâm gia sư, bổ trợ kiến thức và luyện thi lớp 6–12
* **Methodology:** Spec-Driven Development (SDD) & Agent-Driven Development (ADD)

---

## 2. TECH STACK (STRICT — DO NOT DEVIATE)
* **JDK:** OpenJDK 17 (Java 17)
* **Servlet Container:** Apache Tomcat 10.1 (Namespace `jakarta.servlet.*`, `jakarta.servlet.http.*`)
* **Persistence:** JPA (Jakarta Persistence 3.1) + Hibernate ORM (Namespace `jakarta.persistence.*`)
* **Database:** Microsoft SQL Server
* **View:** JSP + JSTL (Jakarta Tags: `jakarta.tags.core`, `jakarta.tags.fmt`) + EL `${...}`
* **Build Tool:** Ant (NetBeans Standard Web Application)
* **Testing:** JUnit 5

---

## 3. ARCHITECTURE PRINCIPLES
1. **Phân tầng chuẩn MVC:**
   * `com.educenter.controller`: Jakarta Servlets kế thừa `HttpServlet`.
   * `com.educenter.filter`: Xác thực đăng nhập, phân quyền 6 vai trò, mã hóa UTF-8, CSRF.
   * `com.educenter.service`: Nơi duy nhất chứa nghiệp vụ, xử lý 20 Business Rules (BR01 - BR20), quản lý `EntityTransaction`.
   * `com.educenter.repository`: Tầng truy cập CSDL bằng JPA `EntityManager`, JPQL, Criteria API.
   * `com.educenter.entity`: JPA Entities tương ứng 30 bảng CSDL.
   * `com.educenter.dto`: Data Transfer Objects cho form submit và view dữ liệu.
   * `com.educenter.util`: `JPAUtil` (quản lý `EntityManagerFactory`), `PasswordUtil` (BCrypt).
2. **Quy tắc View:**
   * Mọi file JSP nằm trong thư mục bảo vệ `web/WEB-INF/views/`.
   * Tuyệt đối không gọi truy vấn DB hoặc viết mã nghiệp vụ trong JSP.
   * Không dùng Scriptlet Java `<% %>`. Chỉ dùng JSTL và Expression Language `${...}`.
3. **Quy tắc PRG (Post/Redirect/Get):**
   * GET: Forward tới JSP view.
   * POST: Xử lý xong phải Redirect (`response.sendRedirect(...)`) kèm flash message trong session.

---

## 4. MANDATORY AGENT WORKFLOW RULES (BẮT BUỘC TUÂN THỦ)
1. **BẮT BUỘC DÙNG SPECKIT VIẾT SPEC:**
   * Mọi tính năng mới hoặc cập nhật nghiệp vụ phải dùng bộ skill Spec Kit (`/speckit-specify`, `/speckit-plan`, `/speckit-tasks`, `/speckit-implement`, `/speckit-converge`).
   * Không được tự ý sinh mã khi chưa có đặc tả trong `.sdd/specs/`.
2. **BẮT BUỘC DÙNG CODEGRAPH ĐỌC CODE:**
   * Khi tìm hiểu cấu trúc, tìm kiếm class/servlet/service/repository, call paths hoặc phân tích ảnh hưởng: **BẮT BUỘC** dùng công cụ MCP `codegraph_explore` (hoặc `codegraph explore`) trước tiên. Tuyệt đối không dùng vòng lặp grep/find đọc từng file gây tốn token và làm chậm tốc độ.
3. **NGUYÊN TẮC "SPEC-FIRST" (SỬA SPEC RỒI MỚI SỬA CODE):**
   * Khi có thay đổi yêu cầu hoặc refactor logic, **PHẢI CẬP NHẬT SPEC TRƯỚC** (`SPEC.md` / `PLAN.md`), giải quyết hết mơ hồ, sau đó mới được sửa mã nguồn trong `src/` hoặc `web/`.
   * Cấm tuyệt đối: Code trước rồi bổ sung spec sau (Spec-Code Drift).
4. **CODE XONG TÍNH NĂNG PHẢI ĐẨY LÊN MAIN:**
   * Ngay sau khi một tính năng hoàn tất kiểm thử và thỏa mãn Definition of Done, **BẮT BUỘC** commit và push lên nhánh `main` (hoặc merge vào `main`) với thông điệp `feat([scope]): [description]`. Nhánh `main` luôn luôn ở trạng thái chạy được và sẵn sàng demo.

---

## 5. FORBIDDEN PATTERNS (CẤM TUYỆT ĐỐI)
* **NEVER use raw JDBC:** CẤM dùng `java.sql.Connection`, `java.sql.PreparedStatement`, `java.sql.Statement` cho nghiệp vụ. Bắt buộc dùng JPA theo yêu cầu đề Assignment PRJ301.
* **NEVER store plain-text passwords:** Mật khẩu phải được băm bằng BCrypt (cost >= 10).
* **NEVER hard delete financial records:** Không xóa vật lý dữ liệu trong `Invoices`, `Payments`, `Enrollments`. Phải dùng soft delete.
* **NEVER bypass authorization checks:** Luôn kiểm tra phân quyền cả ở Filter và tầng Service.

---

## 6. DEFINITION OF DONE (PER TASK)
* [ ] Spec tương ứng trong `.sdd/specs/` đã được cập nhật và khóa (Locked).
* [ ] Code tuân thủ Java 17 và Jakarta EE 10 namespace.
* [ ] Không có cảnh báo lọt kết nối: `EntityManager` được quản lý đóng mở an toàn.
* [ ] Kiểm tra lỗi nghiệp vụ (Validation, Business Rules) đầy đủ trước khi thực hiện giao dịch.
* [ ] Màn hình có thông báo lỗi / thành công rõ ràng cho người dùng.
* [ ] Code hoàn thành được commit và push lên nhánh `main`.
