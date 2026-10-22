# CLAUDE.md — Project Memory & Context for Coding Agents
# Refer to AGENTS.md and .sdd/constitution.md for full project context.

## MANUAL MEMORY (Architectural Decisions & Lessons)
### Architecture Decisions (ADR)
* **ADR-001 (JPA Over Raw JDBC):** Đề thi Assignment PRJ301 bắt buộc dùng JPA và nghiêm cấm JDBC thuần. Sử dụng Hibernate ORM làm provider để ánh xạ 30 entity và EntityManager cho mọi thao tác CSDL.
* **ADR-002 (Tomcat 10.1 & Jakarta EE 10):** Chạy trên Tomcat 10.1 nên toàn bộ import phải dùng `jakarta.servlet.*`, `jakarta.servlet.http.*`, `jakarta.persistence.*`, `jakarta.tags.core`. Tuyệt đối không dùng `javax.*`.
* **ADR-003 (View Protection):** Toàn bộ JSP đặt dưới `web/WEB-INF/views/` để tránh người dùng gõ trực tiếp URL truy cập file JSP mà không qua Servlet và Filter.
* **ADR-004 (Financial Precision):** Sử dụng `java.math.BigDecimal` cho toàn bộ các trường tiền tệ (học phí, thanh toán, công nợ).

### Lessons Learned
* **LESSON-001:** Tránh `LazyInitializationException` khi render JSP bằng cách viết câu truy vấn JPQL sử dụng `JOIN FETCH` đối với các thuộc tính quan hệ cần hiển thị trên view.
* **LESSON-002:** Trong Tomcat 10.1, thẻ JSTL `c:url` và `c:out` phải sử dụng URI `jakarta.tags.core` thay cho URI cũ `http://java.sun.com/jsp/jstl/core`.

### Current Sprint Focus (10-Week Roadmap - Sprint 1)
* **Tuần 1-2:** Chốt SRS, ERD 30 bảng, thiết lập khung thư mục SDD, cấu hình `persistence.xml`, tạo các Entity JPA cơ bản và cấu trúc MVC.
