# Implementation Plan: Hồ sơ học viên, phụ huynh và xác thực giám hộ

**Branch**: `feat-student-guardian` | **Date**: 2026-10-23 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `.sdd/specs/modules/admission/feat-student-guardian/spec.md`

## Summary
Triển khai phân hệ quản lý hồ sơ Học viên (Student), Phụ huynh (Guardian) và quan hệ giám hộ nhiều-nhiều đã xác thực (StudentGuardian) theo chuẩn kiến trúc MVC + JPA + JSP (Jakarta EE 10, Java 17). Đảm bảo kiểm soát cô lập dữ liệu theo BR15 (xác thực/thu hồi quyền xem con), tuân thủ 100% Design System `design.md` và truy vấn dữ liệu động từ CSDL `EduCenterDB`.

## Technical Context
- **Language/Version**: Java 17 (OpenJDK 17)
- **Primary Dependencies**: Jakarta Servlet 6.0, Jakarta Persistence 3.1, Hibernate ORM 6.x, JSTL (jakarta.tags.core, jakarta.tags.fmt)
- **Storage**: Microsoft SQL Server (`EduCenterDB`, tables: `Students`, `Guardians`, `StudentGuardians`, `Users`, `AuditLogs`)
- **Testing**: JUnit 5, Mockito
- **Target Platform**: Apache Tomcat 10.1 on Windows / Linux
- **Project Type**: Java Web Application (MVC, Ant build)
- **Security & RBAC**: `RoleFilter` cho phép `STAFF` và `ADMIN`, `CsrfFilter` cho mọi yêu cầu POST
- **UI Guidelines**: Default Light Mode, Lucide SVG outline icons, Design tokens từ `design.md`, 0 hardcode rows

## Constitution Check
- [x] Java 17 & Jakarta namespace (`jakarta.servlet.*`, `jakarta.persistence.*`)
- [x] JPA qua EntityManager, không dùng JDBC thô
- [x] Password BCrypt khi tạo tài khoản
- [x] Mọi JSP nằm trong `web/WEB-INF/views/`
- [x] Không scriptlet Java `<% %>`, dùng JSTL & EL
- [x] PRG pattern cho mọi POST request kèm Flash Messages
- [x] Tuân thủ 100% Design System `design.md` (Light mode mặc định, outline SVG, không Tailwind CDN)
- [x] Dữ liệu động 100% từ DB kèm Empty State chuyên nghiệp

## Project Structure
```text
src/java/com/educenter/
├── entity/
│   ├── Student.java
│   ├── Guardian.java
│   └── StudentGuardian.java
├── dto/
│   ├── StudentFilterDTO.java
│   ├── StudentAdminViewDTO.java
│   ├── StudentDetailDTO.java
│   ├── StudentFormDTO.java
│   ├── GuardianFilterDTO.java
│   ├── GuardianAdminViewDTO.java
│   ├── GuardianFormDTO.java
│   └── StudentGuardianLinkDTO.java
├── repository/
│   ├── StudentRepository.java
│   └── GuardianRepository.java
├── service/
│   ├── StudentService.java
│   └── StudentServiceImpl.java
└── controller/
    ├── StudentManagementServlet.java
    └── GuardianManagementServlet.java

web/WEB-INF/views/
├── staff/
│   ├── student-list.jsp        # ADM-06
│   ├── student-detail.jsp      # ADM-07
│   └── guardian-list.jsp       # ADM-08
```
