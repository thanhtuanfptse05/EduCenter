# 🎓 EduCenter — Tutoring & Exam Preparation ERP System

[![Java](https://img.shields.io/badge/Java-17%20(LTS)-orange?style=flat-square&logo=openjdk&logoColor=white)](https://openjdk.org/)
[![Jakarta EE](https://img.shields.io/badge/Jakarta%20EE-10.0-blue?style=flat-square&logo=eclipseide&logoColor=white)](https://jakarta.ee/)
[![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-10.1.x-yellow?style=flat-square&logo=apachetomcat&logoColor=white)](https://tomcat.apache.org/)
[![JPA](https://img.shields.io/badge/JPA%203.1-Hibernate%206.4-59666C?style=flat-square&logo=hibernate&logoColor=white)](https://hibernate.org/)
[![Database](https://img.shields.io/badge/SQL%20Server-2019%20%2F%202022-CC292B?style=flat-square&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)
[![Tests](https://img.shields.io/badge/Unit%20Tests-166%20Passed%20(100%25)-brightgreen?style=flat-square&logo=junit5&logoColor=white)](test/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20MVC%20%2B%20SDD-blueviolet?style=flat-square)]()
[![Design System](https://img.shields.io/badge/Design%20System-Tokens%20%7C%20Lucide%20SVG-0284c7?style=flat-square)](design.md)

**EduCenter** là hệ thống hoạch định tài nguyên trung tâm giáo dục (ERP) chuyên biệt dành cho mô hình **Gia sư, Bổ trợ kiến thức và Luyện thi lớp 6–12**. Hệ thống kết nối toàn diện 5 chủ thể (**Quản trị viên, Tư vấn tuyển sinh, Giáo viên, Học sinh, Phụ huynh**), tối ưu hóa quy trình từ lúc tiếp nhận khách hàng (Lead), sắp xếp lớp học, điểm danh, ghi nhận tiến bộ đến thanh toán học phí và báo cáo tài chính.

> 🚀 **Bắt đầu nhanh?** Xem cẩm nang cài đặt chi tiết từng bước từ A – Z tại **[SETUP_GUIDE.md](SETUP_GUIDE.md)**.

---

## 📑 Mục Lục
1. [Điểm Nổi Bật Của Hệ Thống](#-điểm-nổi-bật-của-hệ-thống)
2. [Nguyên Tắc Kiến Trúc & Công Nghệ](#-nguyên-tắc-kiến-trúc--công-nghệ)
3. [Phân Hệ Chức Năng (12 Modules / 35 Use Cases)](#-phân-hệ-chức-năng-12-modules--35-use-cases)
4. [Sơ Đồ Phân Quyền & Luồng Nghiệp Vụ Chính](#-sơ-đồ-phân-quyền--luồng-nghiệp-vụ-chính)
5. [Cấu Trúc Thư Mục Dự Án](#-cấu-trúc-thư-mục-dự-án)
6. [Hướng Dẫn Cài Đặt & Khởi Chạy](#-hướng-dẫn-cài-đặt--khởi-chạy)
7. [Tài Khoản Thử Nghiệm Chuẩn](#-tài-khoản-thử-nghiệm-chuẩn)
8. [Kiểm Thử & Đảm Bảo Chất Lượng (Quality Assurance)](#-kiểm-thử--đảm-bảo-chất-lượng-quality-assurance)
9. [Đặc Tả Nghiệp Vụ & Quy Chuẩn Phát Triển](#-đặc-tả-nghiệp-vụ--quy-chuẩn-phát-triển)

---

## 🌟 Điểm Nổi Bật Của Hệ Thống

* **100% Dữ liệu động thực tế (Production-grade):** Tuyệt đối không hardcode mock rows, bảng tĩnh hay số liệu KPI giả định. Mọi chỉ số thống kê, danh sách học viên, công nợ và lịch học đều được truy vấn động qua JPA/Hibernate từ SQL Server với cơ chế xử lý Empty State chuyên nghiệp.
* **Quy trình Ghi danh & Thu phí chuẩn chỉnh (BR11, BR12, BR16):** Học viên bắt buộc phải hoàn tất nghĩa vụ học phí trước khi ghi danh. Giao dịch ghi danh tự động tạo hợp đồng đào tạo `ACTIVE`, hóa đơn `PAID` và phiếu thu `CONFIRMED` đồng bộ trong cùng một transaction; tự động kiểm tra sĩ số (BR04) và chặn xung đột thời khóa biểu (BR07).
* **Tuân thủ Design System (design.md):** 
  * Mặc định giao diện sáng (Default Light Mode), hỗ trợ chuyển đổi Dark Mode lưu trữ `localStorage`.
  * Bộ icon đồng nhất chuẩn Outline SVG (Lucide Icon 18–20px), không sử dụng emoji, icon 3D hay sticker.
  * Hệ thống biến CSS Tokens cục bộ (`--primary`, `--surface`, `--text`, typography `Inter`), không phụ thuộc vào CDN bên ngoài hay Tailwind framework.
* **Bảo mật đa lớp:**
  * Băm mật khẩu bằng thuật toán **BCrypt** (cost factor >= 10).
  * Bộ lọc phân quyền 5 vai trò theo URL và tác vụ (`RoleFilter`, `AuthenticationFilter`).
  * Phòng chống tấn công giả mạo yêu cầu (**CSRF Token Verification**) trên toàn bộ biểu mẫu POST.
  * Khóa lạc quan (**Optimistic Locking** với `@Version`) bảo vệ giao dịch hóa đơn tài chính.

---

## 🏗 Nguyên Tắc Kiến Trúc & Công Nghệ

Hệ thống được xây dựng theo kiến trúc phân tầng chuẩn **MVC (Model - View - Controller)** kết hợp **Service Layer** và **Repository Pattern**:

```
                       [ Trình duyệt Web (Client) ]
                                    │
                                    ▼
       ┌────────────────────────────────────────────────────────┐
       │                 TẦNG BỘ LỌC (FILTER CHAIN)              │
       │   EncodingFilter ──► CsrfFilter ──► AuthFilter ──► ...  │
       └────────────────────────────┬───────────────────────────┘
                                    │
                                    ▼
       ┌────────────────────────────────────────────────────────┐
       │                TẦNG ĐIỀU KHIỂN (CONTROLLERS)            │
       │     Jakarta Servlets (kế thừa HttpServlet)             │
       └────────────────────────────┬───────────────────────────┘
                                    │
                                    ▼
       ┌────────────────────────────────────────────────────────┐
       │                 TẦNG NGHIỆP VỤ (SERVICE LAYER)          │
       │     Xử lý 20 Business Rules (BR01 - BR20)              │
       │     Quản lý EntityTransaction, Rollback khi lỗi        │
       └────────────────────────────┬───────────────────────────┘
                                    │
                                    ▼
       ┌────────────────────────────────────────────────────────┐
       │                TẦNG DỮ LIỆU (REPOSITORY LAYER)          │
       │     JPA EntityManager, Typed JPQL, Criteria API        │
       └────────────────────────────┬───────────────────────────┘
                                    │
                                    ▼
       ┌────────────────────────────────────────────────────────┐
       │               CƠ SỞ DỮ LIỆU (DATABASE LAYER)           │
       │     Microsoft SQL Server (30 Bảng quan hệ)             │
       └────────────────────────────────────────────────────────┘
```

### Bảng Công Nghệ Sử Dụng

| Hạng mục | Công nghệ | Phiên bản / Namespace | Ghi chú |
|---|---|---|---|
| **Ngôn ngữ** | Java (OpenJDK) | Java 17 LTS | Khai thác cú pháp hiện đại, Pattern Matching, Records, Text Blocks |
| **Servlet Container** | Apache Tomcat | 10.1.x | Namespace chuẩn `jakarta.servlet.*`, `jakarta.servlet.http.*` |
| **Tầng Persistence** | JPA 3.1 + Hibernate ORM | 6.4.10.Final | Namespace `jakarta.persistence.*`, JPQL, Optimistic Locking |
| **Cơ sở dữ liệu** | Microsoft SQL Server | 2019 / 2022 | Kết nối qua `mssql-jdbc-12.6.1.jre11` |
| **Giao diện View** | JSP + JSTL (Jakarta Tags) | JSTL 3.0.0 | Taglib `jakarta.tags.core`, `jakarta.tags.fmt`, biểu thức EL `${...}` |
| **Công cụ Build** | Apache Ant | NetBeans Web Standard | Script tự động biên dịch, chạy unit test và đóng gói `.war` |
| **Kiểm thử** | JUnit 5 | 5.10.x | 166 Unit tests độc lập bao phủ toàn bộ tầng nghiệp vụ |

---

## 📦 Phân Hệ Chức Năng (12 Modules / 35 Use Cases)

Hệ thống bao phủ đầy đủ 12 module cốt lõi theo đặc tả **SRS v1.1**:

```
EduCenter ERP
├── 🎓 Khối Học Vụ (Academic)
│   ├── M04: Quản lý Bộ môn, Chương trình học & Khóa học (Course Catalog)
│   ├── M05: Quản lý Phòng học, Lớp học & Xếp thời khóa biểu (Timetable Scheduling)
│   ├── M07: Điểm danh buổi học & Nhật ký giảng dạy (Attendance Journal)
│   └── M08: Quản lý Bài kiểm tra, Nhập điểm & Báo cáo tiến bộ (Assessments & Grading)
│
├── 🎯 Khối Tuyển Sinh & Khách Hàng (Admissions & CRM)
│   ├── M01: Cổng thông tin công khai, giới thiệu & biểu mẫu tư vấn
│   ├── M03: Tiếp nhận Lead, Tư vấn lộ trình & Kiểm tra đầu vào (Admission CRM)
│   ├── M06: Hồ sơ Học viên, Phụ huynh & Cổng tra cứu cá nhân (Portal)
│   └── M10: Thông báo hệ thống & Hỏi đáp tư vấn kiểm duyệt
│
└── 💼 Khối Tài Chính & Quản Trị Hệ Thống (Finance & Admin)
    ├── M02: Xác thực tài khoản, Hồ sơ người dùng & Phân quyền RBAC
    ├── M09: Quản lý Học phí, Phát hành hóa đơn, Thu tiền & Công nợ (Tuition & Invoicing)
    ├── M11: Dashboard trực quan & Báo cáo đối soát toàn trung tâm (KPI Reporting)
    └── M12: Cấu hình tham số trung tâm, Quản trị tài khoản & Nhật ký kiểm toán (Audit Logs)
```

---

## 👥 Sơ Đồ Phân Quyền & Luồng Nghiệp Vụ Chính

| Vai trò | Mã quyền | Phạm vi truy cập & Trách nhiệm chính |
|---|:---:|---|
| **Quản trị viên** | `ADMIN` | Toàn quyền kiểm soát hệ thống: Cấu hình trung tâm, quản lý tài khoản/phân quyền, xem KPI doanh thu/học vụ, can thiệp xử lý ngoại lệ ghi danh và nhật ký Audit Log. |
| **Nhân viên Tuyển sinh** | `STAFF` | Quản lý Lead tư vấn, tạo học viên mới, ghi danh & xếp lớp, theo dõi công nợ học phí, lập phiếu thu tiền mặt/chuyển khoản và in biên lai. |
| **Giáo viên** | `TEACHER` | Xem lịch dạy hàng tuần, thực hiện điểm danh buổi học theo ca, ghi nhật ký bài học, tạo bài kiểm tra, nhập điểm và nhận xét học viên. |
| **Học sinh** | `STUDENT` | Tra cứu thời khóa biểu cá nhân, xem kết quả điểm danh, theo dõi điểm số các bài kiểm tra, tiến độ học tập và lịch sử đóng học phí. |
| **Phụ huynh** | `PARENT` | Quản lý và theo dõi thông tin học tập của các con liên kết: Lịch học, tỷ lệ chuyên cần, bảng điểm định kỳ và tra cứu biên lai học phí. |

---

## 📂 Cấu Trúc Thư Mục Dự Án

```
EduCenter/
├── .sdd/                         # Bộ đặc tả Spec-Driven Development (Specs, Plans, Tasks)
│   └── specs/modules/            # Đặc tả chi tiết từng module (academic, admission, finance)
├── docs/
│   └── database/seeds/           # Scripts SQL khởi tạo CSDL EduCenterDB (01 -> 08)
├── src/
│   ├── conf/META-INF/            # persistence.xml chính thức cho JPA Hibernate
│   └── java/com/educenter/
│       ├── controller/           # Jakarta Servlets (Academic, Admission, Finance, Portal...)
│       ├── dto/                  # Data Transfer Objects (View models, Form submissions)
│       ├── entity/               # 30 JPA Entities mapping các bảng CSDL
│       ├── filter/               # Bộ lọc: Authentication, Role, CSRF, Encoding, ErrorBoundary
│       ├── repository/           # Tầng truy xuất CSDL (EntityManager, JPQL queries)
│       ├── service/              # Tầng nghiệp vụ xử lý BR01-BR20 & EntityTransaction
│       └── util/                 # JPAUtil, PasswordUtil (BCrypt), DateUtil, CsrfUtil
├── test/com/educenter/           # 166 Unit Tests độc lập kiểm thử dịch vụ & tích hợp
├── web/
│   ├── assets/                   # CSS cục bộ (admin, portal, public), JS, Icon SVG
│   └── WEB-INF/
│       ├── lib/                  # Thư viện JAR đóng gói sẵn (Hibernate, MSSQL, JSTL...)
│       └── views/                # JSP Views được bảo vệ tuyệt đối (admin, staff, teacher, student...)
├── build.xml                     # Ant build script tiêu chuẩn NetBeans
├── design.md                     # Tài liệu quy chuẩn Design System bắt buộc
└── README.md                     # Tài liệu tổng quan dự án
```

---

## 🚀 Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Yêu cầu môi trường
* **Java:** OpenJDK 17 LTS (hoặc Oracle / Temurin JDK 17).
* **IDE:** NetBeans IDE 17+.
* **Web Server:** Apache Tomcat 10.1.x *(Bắt buộc 10.1+; không dùng Tomcat 9 do khác biệt namespace)*.
* **CSDL:** Microsoft SQL Server 2019 hoặc 2022.

### 2. Thiết lập Cơ sở dữ liệu
1. Mở **SQL Server Management Studio (SSMS)** và kết nối vào SQL Server cục bộ.
2. Mở thư mục `docs/database/seeds/` và chạy lần lượt các script theo đúng thứ tự:
   * `01_schema_baseline.sql` — Tạo database `EduCenterDB` và 30 bảng.
   * `02_roles_and_settings.sql` — Nạp 5 vai trò và cấu hình hệ thống.
   * `03_subjects_and_courses.sql` — Nạp bộ môn và khóa học mẫu.
   * `04_users_teachers_staff_students.sql` — Nạp người dùng thử nghiệm.
   * `05_rooms_and_classes.sql` — Nạp phòng học và lớp học.
   * `06_timetables_and_sessions.sql` — Nạp thời khóa biểu và ca học.
   * `07_enrollments_invoices_payments.sql` — Nạp ghi danh, hóa đơn và phiếu thu.
   * `08_assessments_and_attendance.sql` — Nạp bài kiểm tra và dữ liệu điểm danh.

### 3. Cấu hình kết nối CSDL
Mở tệp [`src/conf/META-INF/persistence.xml`](src/conf/META-INF/persistence.xml) và kiểm tra thông số kết nối:
```xml
<property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://localhost:1433;databaseName=EduCenterDB;encrypt=false;trustServerCertificate=true;"/>
<property name="jakarta.persistence.jdbc.user" value="sa"/>
<property name="jakarta.persistence.jdbc.password" value="123"/>
```
*(Bạn cũng có thể ghi đè qua các biến môi trường `EDUCENTER_DB_URL`, `EDUCENTER_DB_USER`, `EDUCENTER_DB_PASSWORD`)*.

### 4. Chạy ứng dụng trên NetBeans
1. Mở NetBeans IDE, chọn **File** -> **Open Project** -> Trỏ tới thư mục `EduCenter`.
2. Chuột phải vào project `EduCenter` -> Chọn **Properties** -> Mục **Run** -> Chọn Server là **Apache Tomcat 10.1**.
3. Nhấp chuột phải vào project và chọn **Clean and Build**.
4. Chọn **Run** (hoặc nhấn `F6`). Trình duyệt sẽ mở tại địa chỉ:
   ```
   http://localhost:8080/EduCenter/
   ```

---

## 🔑 Tài Khoản Thử Nghiệm Chuẩn

Mật khẩu mặc định cho toàn bộ tài khoản thử nghiệm là: **`123456`**

| Vai trò | Email đăng nhập | Tên người dùng | Quyền hạn tiêu biểu |
|:---:|---|---|---|
| **Admin** | `admin@educenter.vn` | Quản trị viên EduCenter | Quản trị toàn hệ thống, cấu hình tham số, giám sát KPI |
| **Staff** | `staff@educenter.vn` | Trần Thu Hà | Tư vấn tuyển sinh, ghi danh & xếp lớp, quản lý thu học phí |
| **Staff** | `accountant@educenter.vn` | Lê Thị Mai | Thu ngân & Kế toán học vụ, xuất biên lai thu tiền |
| **Teacher** | `teacher@educenter.vn` | Thầy Nguyễn Văn Nam | Điểm danh lớp học, nhập điểm kiểm tra, quản lý ca dạy |
| **Student** | `student@educenter.vn` | Nguyễn Minh Quân | Xem TKB cá nhân, bảng điểm, chuyên cần, tra cứu học phí |
| **Parent** | `parent@educenter.vn` | Nguyễn Văn Bình | Theo dõi quá trình học tập và biên lai học phí của con |

---

## 🧪 Kiểm Thử & Đảm Bảo Chất Lượng (Quality Assurance)

Dự án áp dụng quy trình kiểm thử tự động nghiêm ngặt bằng Ant & JUnit 5:

```powershell
# Chạy bộ kiểm thử tự động (166 Unit Tests) và đóng gói WAR
& "C:\Program Files\NetBeans-17\netbeans\extide\ant\bin\ant.bat" -f build.xml verify
```

Kết quả thực tế:
```
[       166 tests found           ]
[         0 tests skipped         ]
[       166 tests started         ]
[         0 tests aborted         ]
[       166 tests successful      ]
[         0 tests failed          ]
BUILD SUCCESSFUL
```

Ngoài ra, hệ thống cung cấp các kịch bản kiểm thử độc lập:
* `.\scripts\verify.ps1`: Tự động biên dịch, chạy unit tests và kiểm thử tích hợp Transaction.
* `python scripts/browser-check.py`: Kiểm thử hiển thị giao diện qua Chromium headless tại 4 mốc responsive (360px, 768px, 1024px, 1440px).

---

## 📜 Đặc Tả Nghiệp Vụ & Quy Chuẩn Phát Triển

Dự án được xây dựng theo phương pháp luận **Spec-Driven Development (SDD)**:
* Toàn bộ các quy tắc kinh doanh (Business Rules `BR01` - `BR20`), ràng buộc dữ liệu và thiết kế màn hình được quy định tại thư mục [`.sdd/specs/`](.sdd/specs/README.md).
* Mọi cập nhật chức năng phải tuân thủ nghiêm ngặt nguyên tắc **Spec-First**: Cập nhật và khóa đặc tả trước khi chỉnh sửa mã nguồn.
* Mọi thay đổi giao diện bắt buộc tuân theo [Design System (`design.md`)](design.md).

---

**© 2026 EduCenter Development Team — Tutoring & Exam Preparation Management System.**  
*Xây dựng theo chuẩn môn học PRJ301 — Đại học FPT.*
