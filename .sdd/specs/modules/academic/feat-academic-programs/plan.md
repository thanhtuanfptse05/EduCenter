# Implementation Plan: Quản lý môn học và chương trình/khóa học (Academic Programs)

**Branch**: `feat-academic-programs` | **Date**: 2026-10-23 | **Spec**: [spec.md](spec.md)  
**Feature**: `feat-academic-programs` | **Module**: Academic (M04) | **Owner**: Member 01  

---

## 1. Summary
Triển khai phân hệ quản lý học thuật nội bộ (ADM-04, ADM-05) dành cho STAFF và ADMIN theo chuẩn SRS M04, UC11:
- Quản lý danh mục Môn học (`Subjects`): CRUD, kiểm tra mã duy nhất (case-insensitive), trạng thái `ACTIVE`/`INACTIVE`, chặn chuyển `INACTIVE` khi còn khóa học đang `OPEN` (BR16).
- Quản lý Khóa học (`Courses`): CRUD theo khối lớp 6–12, liên kết môn học, mục tiêu đào tạo, học phí niêm yết, thời lượng tuần, số buổi, sĩ số tối đa, trạng thái `OPEN`/`CLOSED`/`ARCHIVED`.
- Ràng buộc nghiệp vụ: Báo lỗi mã trùng; ghi `AuditLog` atomic khi đổi học phí hoặc cập nhật trạng thái (BR18); bảo toàn snapshot học phí cũ trên các hóa đơn/phiếu ghi danh đã phát hành.
- Giao diện người dùng: ADM-04 (danh sách khóa học, KPI cards, bộ lọc đa năng, phân trang) và ADM-05 (form thêm/sửa khóa học, quản lý môn học) tuân thủ 100% `design.md` (Default Light mode, outline Lucide SVG, token CSS, responsive 3 cấp độ, không hardcode mock data, Empty State chuẩn).

---

## 2. Technical Context
- **JDK/Servlet Container:** OpenJDK 17 + Apache Tomcat 10.1 (`jakarta.servlet.*`, `jakarta.servlet.http.*`).
- **Persistence:** JPA 3.1 + Hibernate ORM (`jakarta.persistence.*`) trên Microsoft SQL Server.
- **Architecture:** Phân tầng MVC chuẩn: Controller (`CourseManagementServlet`, `SubjectManagementServlet`) -> Service (`AcademicProgramService`) -> Repository (`CourseRepository`, `SubjectRepository`, `AuditLogRepository`) -> Entity (`Course`, `Subject`, `AuditLog`).
- **View:** JSP + JSTL (Jakarta Tags) + Expression Language `${...}` trong `web/WEB-INF/views/staff/`.
- **Security:** CSRF Protection qua `CsrfUtil`, RoleFilter (`STAFF`, `ADMIN`), UTF-8 EncodingFilter, PRG (Post/Redirect/Get) với Flash Toast.
- **Testing:** JUnit 5 Unit Tests cho `AcademicProgramService`.

---

## 3. Constitution Check & Mandatory Rules
- [x] **Spec-First:** Toàn bộ đặc tả tại `spec.md`, `research.md`, `data-model.md`, `contracts/http.md`, `quickstart.md`, `plan.md` được tạo và kiểm chứng trước khi sinh mã nguồn.
- [x] **No Raw JDBC:** Chỉ sử dụng JPA `EntityManager` và JPQL/Criteria API.
- [x] **Design System (design.md):** Default Light mode, outline Lucide SVG (18–20px), không emoji icon, không CDN lạ/Tailwind, CSS token chuẩn.
- [x] **No Hardcoded Mock Data:** 100% dữ liệu lấy động từ CSDL qua JPA. Có Empty State chuyên nghiệp khi dữ liệu rỗng.
- [x] **Push to Main:** Hoàn thành kiểm thử và DoD thì commit + push lên `main`.

---

## 4. Project Structure Changes

```text
src/java/com/educenter/
├── dto/
│   ├── CourseAdminViewDTO.java        # View DTO cho danh sách khóa học ADM-04
│   ├── CourseAdminStatsDTO.java       # DTO KPI cards trên dashboard khóa học
│   ├── CourseFormDTO.java             # Form submit & validate khóa học
│   ├── SubjectAdminViewDTO.java       # View DTO cho danh mục môn học ADM-05
│   └── SubjectFormDTO.java            # Form submit & validate môn học
├── repository/
│   ├── CourseRepository.java          # Bổ sung save, update, existsByCode, findAdminCourses, countAdminCourses
│   └── SubjectRepository.java         # Bổ sung save, update, existsByCode, findAllWithStats
├── service/
│   ├── AcademicProgramService.java    # Service interface quản trị học thuật M04
│   └── AcademicProgramServiceImpl.java# Nghiệp vụ BR02, BR16, BR18, Transaction, AuditLog
└── controller/
    ├── CourseManagementServlet.java   # Controller cho /staff/courses, /staff/courses/form, /staff/courses/status
    └── SubjectManagementServlet.java  # Controller cho /staff/subjects, /staff/subjects/save, /staff/subjects/status

web/WEB-INF/views/
├── staff/
│   ├── course-list.jsp                # Màn hình ADM-04: Danh sách khóa học & bộ lọc
│   ├── course-form.jsp                # Màn hình ADM-05: Form thêm/sửa khóa học
│   └── subject-list.jsp               # Màn hình ADM-05: Danh mục môn học & modal tạo/sửa
└── common/
    └── sidebar.jspf                   # Cập nhật menu Môn học & Khóa học cho STAFF/ADMIN

test/com/educenter/service/
└── AcademicProgramServiceTest.java    # Unit test các ca thành công và biên/lỗi nghiệp vụ
```

---

## 5. Verification Plan
- Unit tests: Kiểm tra logic tạo môn, trùng mã môn, tạo khóa học, trùng mã khóa học, khối lớp không hợp lệ, học phí âm, chuyển môn sang INACTIVE khi còn khóa OPEN (chặn), cập nhật học phí và kiểm tra ghi AuditLog.
- Build test: `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`.
- Manual verification: Theo kịch bản `quickstart.md`.
