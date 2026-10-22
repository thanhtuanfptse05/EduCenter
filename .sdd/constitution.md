# EDUCENTER PROJECT CONSTITUTION
**Version:** 1.1.0 | **Status:** LOCKED  
**Ratified:** 2026-10-22 | **Domain:** Education ERP (Tutoring & Exam Preparation)  
**Rule:** Any change to this document requires unanimous team approval (3 members).

---

## ARTICLE 1: TECH STACK & PLATFORM (IMMUTABLE)
* **JDK:** OpenJDK 17 (LTS)
* **IDE:** NetBeans IDE 17
* **Web Server / Servlet Container:** Apache Tomcat 10.1 (Jakarta Servlet 6.0, namespace `jakarta.servlet.*`)
* **Architecture Pattern:** Phân tầng MVC truyền thống:
  `Client Browser -> Filter -> Jakarta Servlet Controller -> Service -> JPA Repository (EntityManager) -> Hibernate ORM -> SQL Server`
* **View Layer:** JSP + JSTL (Jakarta Tags: `jakarta.tags.core`, `jakarta.tags.fmt`) + Expression Language (EL). JSP nằm dưới `WEB-INF/views/`. Tuyệt đối KHÔNG dùng Java Scriptlet (`<% %>`) trong JSP.
* **UI/UX Design System (IMMUTABLE):** Bắt buộc tuân thủ 100% tài liệu [`design.md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design.md) (tức [`design (1).md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design%20(1).md)) làm Single Source of Truth cho toàn bộ giao diện. Default Light Mode; cấm dùng emoji làm icon; dùng icon outline SVG (Lucide 18–20px); tuân thủ biến CSS Design Tokens (`--bg`, `--surface`, `--primary`, `--text`...) và responsive 3 cấp độ; cấm dùng Tailwind CDN.
* **ORM & Database:** JPA 3.1 + Hibernate ORM tương thích Jakarta Persistence. CSDL Microsoft SQL Server.
* **STRICT REQUIREMENT (ASM PRJ301):** Phải kết nối và thao tác dữ liệu qua JPA `EntityManager`, **TUYỆT ĐỐI KHÔNG DÙNG JDBC THUẦN** (`Connection`, `PreparedStatement`) cho logic nghiệp vụ.
* **Build System:** Ant (NetBeans Standard Web Application) kết hợp thư viện trong `allowedlib` hoặc Maven nếu cả nhóm đồng thuận chuyển đổi.

---

## ARTICLE 2: HARD RULES & SECURITY CONSTRAINTS (NON-NEGOTIABLE)

### SEC-01: Password Security
* **THE SYSTEM SHALL** mã hóa mật khẩu người dùng bằng thuật toán băm an toàn (BCrypt với cost >= 10).
* **FORBIDDEN:** Tuyệt đối không lưu mật khẩu dạng plaintext hoặc MD5 trong database hay log.

### SEC-02: Role-Based Access Control (RBAC) & Data Isolation
* **THE SYSTEM SHALL** áp dụng Servlet Filter và kiểm tra quyền tại tầng Service trên từng request và từng bản ghi dữ liệu.
* Chỉ cho phép 6 vai trò: `System Admin`, `Center Manager`, `Academic/Admission Staff`, `Tutor/Teacher`, `Student`, `Parent/Guardian`.
* **THE SYSTEM SHALL** cô lập dữ liệu phụ huynh: Phụ huynh CHỈ được xem thông tin học viên đã xác thực liên kết hợp lệ (`StudentGuardians`).

### SEC-03: Financial & Attendance Integrity
* **THE SYSTEM SHALL** sử dụng kiểu số chính xác (`DECIMAL(18,2)` trong SQL Server, `java.math.BigDecimal` trong Java) cho toàn bộ học phí, thanh toán, công nợ.
* **THE SYSTEM SHALL** lưu giao dịch tài chính theo nguyên tắc bất biến (Append-only). Không xóa vật lý (`DELETE`) các hóa đơn, biên lai đã phát sinh giao dịch. Mọi điều chỉnh phải qua quy trình có ghi nhận và Audit Log.

### SEC-04: Concurrency & Transaction Management
* Các thao tác: Ghi danh (`Enrollment`), Xác nhận thanh toán (`Payment`), Xếp lịch (`ClassSession`) **BẮT BUỘC** chạy trong JPA Transaction (`EntityTransaction`).
* Phải kiểm soát đồng thời (Concurrency Control / Optimistic Locking hoặc Pessimistic Locking) để đảm bảo không vượt quá sĩ số lớp (`Classes.capacity`) khi nhiều nhân viên ghi danh cùng lúc.

---

## ARTICLE 3: CODING STANDARDS & PROJECT CONVENTIONS
* **Package Base:** `com.educenter`
  * `com.educenter.controller`: Jakarta Servlets kế thừa `HttpServlet`.
  * `com.educenter.filter`: Servlet Filters xử lý Auth, RBAC, UTF-8, CSRF.
  * `com.educenter.service`: Chứa toàn bộ Business Rules (BR01 - BR20), điều phối transaction.
  * `com.educenter.repository`: Tầng truy cập dữ liệu sử dụng JPA `EntityManager`, JPQL, Criteria API.
  * `com.educenter.entity`: Jakarta Persistence Entities tương ứng 30 bảng CSDL.
  * `com.educenter.dto`: Data Transfer Objects cho form input và report view.
  * `com.educenter.util`: `JPAUtil`, `PasswordUtil`, `ValidationUtil`.
* **Controller - View Flow (PRG Pattern):**
  * Yêu cầu hiển thị (`GET`): Servlet đọc dữ liệu từ Service, đặt vào `request.setAttribute()`, sau đó `request.getRequestDispatcher("/WEB-INF/views/...").forward(request, response)`.
  * Yêu cầu thay đổi dữ liệu (`POST`): Servlet gọi Service xử lý, sau đó `response.sendRedirect(...)` (Post-Redirect-Get) để tránh submit form lặp lại.

---

## ARTICLE 4: TESTING REQUIREMENTS
* **Service Unit Tests:** Phải có JUnit 5 test cases cho các hàm nghiệp vụ trọng yếu: tính học phí, giảm giá, kiểm tra trùng lịch (Time conflict: `newStart < existingEnd AND newEnd > existingStart`), kiểm tra sĩ số.
* **Integration Tests:** Kiểm tra thao tác persistence của JPA Entity với SQL Server.
* **Acceptance Gate:** Mọi Use Case P0 (35 use cases) phải pass kiểm thử thủ công và kiểm thử tích hợp trước khi demo.

---

## ARTICLE 5: GIT WORKFLOW & INTEGRATION (MAIN BRANCH)
* `main`: Nhánh production-ready, luôn ở trạng thái build được, pass test và sẵn sàng demo.
* **QUY TẮC ĐẨY CODE LÊN MAIN:** Ngay khi một tính năng hoặc use case hoàn thành và đạt Definition of Done, **BẮT BUỘC** phải commit và đẩy code lên `main` (hoặc merge PR vào `main`). Không để code tính năng đã hoàn thiện tồn đọng cục bộ.

---

## ARTICLE 6: AI CODING AGENT MANDATORY RULES
1. **BẮT BUỘC DÙNG SPECKIT VIẾT SPEC:**
   * Mọi tính năng phải dùng skill của GitHub Spec Kit (`/speckit-specify`, `/speckit-plan`, `/speckit-tasks`, `/speckit-implement`, `/speckit-converge`).
   * Không sinh mã khi chưa có spec được duyệt.
2. **BẮT BUỘC DÙNG CODEGRAPH ĐỌC CODE:**
   * Khi tìm hiểu cấu trúc code, truy vết call paths, quan hệ class/servlet: **BẮT BUỘC** gọi `codegraph_explore` (hoặc `codegraph explore`) trước tiên để đọc code nhanh, chính xác và tiết kiệm token.
3. **NGUYÊN TẮC SPEC-FIRST (SỬA SPEC RỒI MỚI SỬA CODE):**
   * Mọi thay đổi về yêu cầu kỹ thuật/nghiệp vụ bắt buộc phải cập nhật và làm rõ trong `SPEC.md` / `PLAN.md` TRƯỚC, tránh tuyệt đối sự mơ hồ (Spec-Code Drift).
   * Chỉ tiến hành sửa code sau khi Spec đã được cập nhật xong.
4. **BẮT BUỘC TUÂN THỦ DESIGN SYSTEM (DESIGN.MD):**
   * Mọi màn hình JSP, CSS, JavaScript, bố cục layout, typography, màu sắc, components **BẮT BUỘC** tuân thủ tuyệt đối theo đặc tả trong [`design.md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design.md) (tức [`design (1).md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design%20(1).md)).
   * Default Light Mode; cấm dùng emoji làm icon; dùng icon outline SVG (Lucide 18–20px); dùng Design Tokens CSS cục bộ; không dùng Tailwind CDN hay framework frontend lạ.
5. **CẤM TUYỆT ĐỐI:**
   * Tự ý dùng thư viện ngoài stack (Spring Boot, MyBatis, JDBC thuần, Tailwind CDN).
   * Viết Java Scriptlet (`<% %>`) trực tiếp vào file JSP.
   * Vi phạm chuẩn giao diện trong `design.md` (dùng emoji, tự chế màu, auto dark mode khi chưa có lựa chọn của người dùng).
   * Bỏ qua kiểm tra phân quyền hoặc validate input.
