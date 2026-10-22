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
5. **BẮT BUỘC TUÂN THỦ DESIGN SYSTEM (DESIGN.MD):**
   * Mọi giao diện người dùng (JSP, CSS, JavaScript, bố cục layout, typography, màu sắc, components) **BẮT BUỘC** tuân thủ tuyệt đối theo đặc tả trong [`design.md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design.md) (tức [`design (1).md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design%20(1).md)).
   * **Default Light Mode:** Lần đầu truy cập luôn luôn là giao diện sáng (Light mode), bất kể hệ điều hành đang dùng Dark mode. Chỉ chuyển Dark mode khi người dùng chủ động chọn và lưu vào `localStorage`.
   * **Icon chuẩn hóa:** Tuyệt đối KHÔNG dùng emoji làm icon giao diện, không dùng icon 3D hay hoạt hình. Bắt buộc dùng bộ icon outline SVG đồng nhất (khuyến nghị Lucide SVG 18–20px).
   * **Design Tokens & Local CSS:** Bắt buộc dùng biến CSS token (`--bg`, `--surface`, `--primary`, `--text`...), typography chuẩn `Inter`, khoảng cách (spacing scale), bo góc (radius). Không dùng Tailwind CDN hay các framework ngoài quy định.
6. **CẤM HARDCODE DỮ LIỆU TRÊN GIAO DIỆN (CHUẨN DỰ ÁN THỰC TẾ):**
   * Mọi dữ liệu hiển thị (bảng danh sách, thẻ thống kê KPI, biểu đồ, dropdown bộ lọc, chi tiết đối tượng...) **BẮT BUỘC** phải truy vấn thực tế từ CSDL qua tầng Repository -> Service -> Controller -> JSP (`request.setAttribute`).
   * Sử dụng JSTL (`<c:forEach>`, `<c:if>`, `<c:choose>`) và EL `${...}` để render dữ liệu động.
   * Xử lý triệt để trạng thái rỗng (Empty State) bằng component thông báo chuyên nghiệp khi chưa có dữ liệu từ DB, tuyệt đối không được hardcode rows/cards HTML tĩnh để lấp chỗ trống.
   * Tuyệt đối không để tài khoản demo, gợi ý đăng nhập thử nghiệm, bảng test guide, hay autofill mock trên giao diện. Toàn bộ phải hoạt động như sản phẩm thương mại thật (production-grade ERP).

---

## 5. FORBIDDEN PATTERNS (CẤM TUYỆT ĐỐI)
* **NEVER use raw JDBC:** CẤM dùng `java.sql.Connection`, `java.sql.PreparedStatement`, `java.sql.Statement` cho nghiệp vụ. Bắt buộc dùng JPA theo yêu cầu đề Assignment PRJ301.
* **NEVER store plain-text passwords:** Mật khẩu phải được băm bằng BCrypt (cost >= 10).
* **NEVER hard delete financial records:** Không xóa vật lý dữ liệu trong `Invoices`, `Payments`, `Enrollments`. Phải dùng soft delete.
* **NEVER bypass authorization checks:** Luôn kiểm tra phân quyền cả ở Filter và tầng Service.
* **NEVER violate Design System (design.md):** Cấm tự ý sửa đổi token màu sắc, typography, tự chế icon emoji, tự động bật Dark mode, hoặc đưa CDN ngoài/Tailwind vào làm lệch chuẩn `design.md`.
* **NEVER hardcode UI mock data or demo helpers:** CẤM tuyệt đối việc hardcode danh sách dữ liệu giả, thẻ KPI tĩnh, rows bảng tĩnh, hoặc tài khoản demo/autofill trên JSP. Toàn bộ phải là luồng dữ liệu động từ backend và CSDL.

---

## 6. DEFINITION OF DONE (PER TASK)
* [ ] Spec tương ứng trong `.sdd/specs/` đã được cập nhật và khóa (Locked).
* [ ] Giao diện tuân thủ 100% Design System trong `design.md` (Default Light mode, outline SVG, Design Tokens, Responsive 3 cấp độ).
* [ ] 100% dữ liệu hiển thị là dữ liệu động từ Backend/CSDL (có xử lý Empty State chuyên nghiệp), không còn bất kỳ dữ liệu fake hay tài khoản demo hardcode nào.
* [ ] Code tuân thủ Java 17 và Jakarta EE 10 namespace.
* [ ] Không có cảnh báo lọt kết nối: `EntityManager` được quản lý đóng mở an toàn.
* [ ] Kiểm tra lỗi nghiệp vụ (Validation, Business Rules) đầy đủ trước khi thực hiện giao dịch.
* [ ] Màn hình có thông báo lỗi / thành công rõ ràng cho người dùng.
* [ ] Code hoàn thành được commit và push lên nhánh `main`.
