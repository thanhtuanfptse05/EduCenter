# EduCenter — Tutoring & Exam Preparation Management System

[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://openjdk.org/)
[![Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow.svg)](https://tomcat.apache.org/)
[![Persistence](https://img.shields.io/badge/JPA-3.1-blue.svg)](https://jakarta.ee/specifications/persistence/3.1/)
[![Database](https://img.shields.io/badge/Database-SQL_Server-red.svg)](https://www.microsoft.com/sql-server)
[![Methodology](https://img.shields.io/badge/Methodology-SDD%2FADD_Hybrid-green.svg)](#methodology)

Hệ thống quản lý trung tâm gia sư, bổ trợ kiến thức và luyện thi vào lớp 10, tốt nghiệp THPT (Lớp 6–12). Dự án được xây dựng theo mô hình **Spec-Driven Development (SDD)** kết hợp **Agent-Driven Development (ADD)**.

---

## 📌 Tổng Quan Dự Án
* **Tên dự án:** EduCenter – Education Management ERP
* **Môn học:** PRJ301 (Java Web Application)
* **Quy mô:** 3 thành viên | 10 tuần triển khai
* **Nhóm người dùng (6 vai trò):**
  1. `System Admin`: Quản trị hệ thống, phân quyền, cấu hình phòng học & tham số, kiểm tra Audit Log.
  2. `Center Manager`: Giám sát điều hành, xem KPI, thống kê doanh thu và báo cáo chuyên sâu.
  3. `Academic / Admission Staff`: Tiếp nhận tư vấn (CRM Lead), quản lý học viên/phụ huynh, tạo lớp & xếp lịch, ghi danh học viên, tạo hóa đơn học phí.
  4. `Tutor / Teacher`: Xem lịch dạy, mở buổi học điểm danh, ghi nhật ký giảng dạy & bài tập, nhập và công bố điểm số.
  5. `Student`: Xem thời khóa biểu, lịch học, kết quả học tập & chuyên cần, hóa đơn học phí, đặt câu hỏi Q&A.
  6. `Parent / Guardian`: Theo dõi tiến độ học tập, chuyên cần, điểm số, học phí của con (chỉ học viên được xác thực liên kết).

---

## 🛠️ Công Nghệ & Nền Tảng (Tech Stack)
* **Ngôn ngữ:** Java 17 (OpenJDK 17 LTS)
* **Web Server / Servlet Container:** Apache Tomcat 10.1 (Jakarta Servlet 6.0, namespace `jakarta.servlet.*`)
* **Kiến trúc:** Phân tầng MVC chuẩn:
  * `Controller`: Jakarta Servlets kế thừa `HttpServlet`
  * `Filter`: Authentication, Role-based Authorization (RBAC), UTF-8 Encoding, CSRF
  * `Service`: Xử lý toàn bộ nghiệp vụ (20 Business Rules BR01 - BR20), điều phối `EntityTransaction`
  * `Repository`: Truy cập CSDL qua JPA `EntityManager` (**TUYỆT ĐỐI KHÔNG DÙNG JDBC THUẦN**)
  * `Entity`: 30 Jakarta Persistence Entities ánh xạ CSDL
  * `View`: JSP + JSTL (Jakarta Tags `jakarta.tags.core`, `jakarta.tags.fmt`) + EL `${...}`
* **Cơ sở dữ liệu:** Microsoft SQL Server
* **Build Tool:** Ant (NetBeans 17 Web Application)
* **Testing:** JUnit 5

---

## 👥 Phân Công Nhóm 3 Thành Viên
| Thành viên | Phân hệ phụ trách | Modules & Nghiệp vụ chính | Nhánh Git |
|---|---|---|---|
| **Member 01** | **Academic & Learning** (~35%) | M04 (Khóa học), M05 (Lớp & Lịch học), M07 (Điểm danh & Nhật ký dạy), M08 (Kiểm tra & Điểm số), Teacher Portal. | `feature/academic` |
| **Member 02** | **Admission & Student** (~35%) | M01 (Website công khai, Tìm kiếm, Giỏ khóa học), M03 (CRM Lead & Tư vấn), M06 (Học viên & Phụ huynh), Ghi danh (UC17), M10 (Q&A & Thông báo), Student/Parent Portal. | `feature/admission` |
| **Member 03** | **Finance & Administration** (~30%) | M02 (Auth & RBAC), M09 (Học phí, Hóa đơn, Thanh toán, Công nợ), M11 (Dashboard & Báo cáo), M12 (Cấu hình hệ thống, Audit Logs), Admin Portal. | `feature/finance` |

---

## 📂 Cấu Trúc Dự Án (SDD Hybrid Architecture)
```text
EduCenter/
├── .sdd/                      # Não bộ dự án SDD (Constitution, 20 Business Rules, Specs, Module Contracts)
│   ├── constitution.md        # Hiến pháp dự án (Hard rules bất biến)
│   ├── shared_context.md      # Đồng bộ ngữ cảnh giữa 3 thành viên
│   ├── constraints/           # Ràng buộc toàn cục, an toàn và 20 Business Rules
│   └── specs/                 # Hệ thống đặc tả tính năng phân cấp (Layer 1 -> 2 -> 3)
├── .agents/                   # Cấu hình AI Coding Agents & bộ skills GitHub Spec Kit
├── .specify/                  # Cấu hình Spec Kit CLI
├── .codegraph/                # Semantic code intelligence graph (CodeGraph)
├── src/java/com/educenter/    # Mã nguồn Java (Controller, Filter, Service, Repository, Entity, DTO, Util)
├── src/conf/META-INF/         # persistence.xml (Cấu hình Hibernate + SQL Server)
├── web/                       # Giao diện web (assets, WEB-INF/views/ theo 6 role portals, web.xml)
├── allowedlib/                # Thư viện JAR phụ trợ (JSTL, SQL Server JDBC Driver)
├── docs/                      # Tài liệu kiến trúc, SRS, CSDL
└── tests/                     # Test suites (Unit, Integration, E2E)
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Dự Án
1. **Yêu cầu môi trường:**
   * JDK 17
   * NetBeans IDE 17
   * Apache Tomcat 10.1
   * Microsoft SQL Server (tạo database `EduCenterDB`)
2. **Cấu hình CSDL:**
   * Mở file `src/conf/META-INF/persistence.xml`.
   * Cập nhật thông tin `user` và `password` tài khoản SQL Server của bạn.
3. **Mở dự án trên NetBeans:**
   * Chọn `File` -> `Open Project` -> Trỏ tới thư mục `EduCenter`.
   * Chuột phải vào dự án -> `Clean and Build`.
   * Chuột phải -> `Run` (chọn server Apache Tomcat 10.1).

---

## 📜 Giấy Phép & Bản Quyền
Dự án được phát triển phục vụ học tập môn PRJ301. Mọi quyền được bảo lưu bởi nhóm phát triển EduCenter.
