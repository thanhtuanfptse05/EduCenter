# Implementation Plan: Hồ sơ giáo viên và quyền phân công (Teacher Management)

**Branch**: `feat-teacher-management` | **Date**: 2026-10-23 | **Spec**: [spec.md](spec.md)  
**Feature**: `feat-teacher-management` | **Module**: Academic (M04 / M05 / M12) | **Owner**: Member 01  

---

## 1. Summary
Triển khai phân hệ quản lý hồ sơ giáo viên nội bộ (ADM-09) dành cho STAFF và ADMIN theo chuẩn SRS UC12:
- Quản lý hồ sơ giáo viên (`Teachers`): liên kết chặt chẽ 1-1 với tài khoản `User` (vai trò `TEACHER`), thông tin bằng cấp, học vị, chuyên môn giảng dạy, thù lao tham khảo (`hourly_rate`), trạng thái (`ACTIVE`, `ON_LEAVE`, `INACTIVE`).
- Ràng buộc nghiệp vụ: Một tài khoản chỉ gắn 1 Teacher profile; chặn ngừng hoạt động (`ON_LEAVE`, `INACTIVE`) khi còn lịch dạy tương lai chưa bàn giao (BR05 / FR-005); bảo vệ thông tin thù lao (FR-006); ghi nhật ký kiểm toán `AuditLog` atomic trong cùng `EntityTransaction` (BR18).
- Giao diện người dùng: ADM-09 (danh sách giáo viên, KPI cards, bộ lọc đa năng, phân trang) và form thêm/sửa giáo viên tuân thủ 100% `design.md` (Default Light mode, outline Lucide SVG, CSS token, responsive, không hardcode mock data, Empty State chuẩn).

---

## 2. Technical Context
- **JDK/Servlet Container:** OpenJDK 17 + Apache Tomcat 10.1 (`jakarta.servlet.*`).
- **Persistence:** JPA 3.1 + Hibernate ORM trên Microsoft SQL Server.
- **Architecture:** Phân tầng MVC chuẩn: Controller (`TeacherManagementServlet`) -> Service (`TeacherManagementService`) -> Repository (`TeacherRepository`, `UserRepository`, `AuditLogRepository`) -> Entity (`Teacher`, `User`, `AuditLog`).
- **Security:** CSRF Protection, RoleFilter (`STAFF`, `ADMIN`), PRG pattern.
- **Testing:** JUnit 5 Unit Tests cho `TeacherManagementService`.

---

## 3. Project Structure Changes

```text
src/java/com/educenter/
├── dto/
│   ├── TeacherAdminViewDTO.java        # View DTO cho danh sách giáo viên ADM-09
│   ├── TeacherAdminStatsDTO.java       # DTO KPI cards trên dashboard giáo viên
│   ├── TeacherFormDTO.java             # Form submit & validate giáo viên
│   ├── AvailableTeacherUserDTO.java    # Danh sách User có role TEACHER chưa liên kết
│   └── TeacherFilterDTO.java           # Filter & phân trang giáo viên
├── repository/
│   └── TeacherRepository.java          # Tầng truy cập CSDL cho entity Teacher
├── service/
│   ├── TeacherManagementService.java   # Service interface quản lý hồ sơ giáo viên
│   └── TeacherManagementServiceImpl.java# Nghiệp vụ BR02, BR05, BR16, BR18, Transaction, AuditLog
└── controller/
    └── TeacherManagementServlet.java   # Controller cho /staff/teachers, /staff/teachers/form, /staff/teachers/status

web/WEB-INF/views/
├── staff/
│   ├── teacher-list.jsp                # Màn hình ADM-09: Danh sách giáo viên & bộ lọc
│   └── teacher-form.jsp                # Màn hình ADM-09: Form thêm/sửa giáo viên
└── common/
    └── sidebar.jspf                    # Cập nhật menu Đội ngũ giáo viên cho STAFF/ADMIN

test/com/educenter/service/
└── TeacherManagementServiceTest.java   # Unit test các ca thành công và biên/lỗi nghiệp vụ
```

---

## 4. Verification Plan
- Unit tests: Kiểm tra logic tạo giáo viên, chặn liên kết tài khoản đã có profile, chặn tài khoản không phải TEACHER, chặn ngừng hoạt động khi còn lịch dạy tương lai, cập nhật thù lao và thông tin, ghi AuditLog.
- Build test: `powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1`.
- Manual verification: Theo kịch bản `quickstart.md`.
