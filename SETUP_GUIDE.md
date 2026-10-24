# 📘 Hướng Dẫn Cài Đặt & Khởi Chạy Dự Án EduCenter (Từ A – Z)

> **Dành cho:** Thành viên mới, người review mã nguồn, giảng viên và sinh viên bắt đầu tiếp cận dự án **EduCenter ERP**.  
> **Phiên bản tài liệu:** v1.2.0 | **Cập nhật:** 2026-10-25  
> **Mã nguồn:** [GitHub Repository](https://github.com/thanhtuanfptse05/EduCenter.git)

---

## 📑 Mục Lục
1. [Yêu Cầu Môi Trường Bắt Buộc (Prerequisites)](#1-yêu-cầu-môi-trường-bắt-buộc-prerequisites)
2. [Bước 1: Tải Mã Nguồn Về Máy (Clone Repository)](#bước-1-tải-mã-nguồn-về-máy-clone-repository)
3. [Bước 2: Cài Đặt & Nạp Cơ Sở Dữ Liệu SQL Server](#bước-2-cài-đặt--nạp-cơ-sở-dữ-liệu-sql-server)
4. [Bước 3: Cấu Hình Kết Nối CSDL Trong Mã Nguồn](#bước-3-cấu-hình-kết-nối-csdl-trong-mã-nguồn)
5. [Bước 4: Cấu Hình & Chạy Dự Án Trên NetBeans IDE 17](#bước-4-cấu-hình--chạy-dự-án-trên-netbeans-ide-17)
6. [Bước 5: Đăng Nhập & Trải Nghiệm Các Phân Quyền (Roles)](#bước-5-đăng-nhập--trải-nghiệm-các-phân-quyền-roles)
7. [Khắc Phục Các Lỗi Thường Gặp (Troubleshooting / FAQ)](#7-khắc-phục-các-lỗi-thường-gặp-troubleshooting--faq)

---

## 1. Yêu Cầu Môi Trường Bắt Buộc (Prerequisites)

Dự án EduCenter được phát triển theo chuẩn **Jakarta EE 10 / Servlet 6.0 / JPA 3.1**, do đó **BẮT BUỘC** bạn phải cài đặt đúng các phiên bản phần mềm sau (không dùng bản thấp hơn):

| STT | Phần mềm / Công cụ | Phiên bản yêu cầu | Mục đích | Link tải chính thức |
|:---:|---|:---:|---|---|
| 1 | **Java Development Kit (JDK)** | **OpenJDK 17** (hoặc Temurin / Oracle 17) | Môi trường biên dịch & chạy Java 17 | [Eclipse Temurin JDK 17](https://adoptium.net/temurin/releases/?version=17) |
| 2 | **Web Server / Servlet Container** | **Apache Tomcat 10.1.x** *(BẮT BUỘC 10.1)* | Chạy ứng dụng web Jakarta EE 10 | [Tomcat 10.1 Downloads](https://tomcat.apache.org/download-10.cgi) |
| 3 | **Integrated Development Environment** | **NetBeans IDE 17+** (Khuyên dùng) | IDE chuẩn phát triển Java Web Ant | [Apache NetBeans Releases](https://netbeans.apache.org/front/main/download/) |
| 4 | **Database Management System** | **Microsoft SQL Server 2019 / 2022** | Hệ quản trị CSDL quan hệ chính thức | [SQL Server Downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) |
| 5 | **Công cụ quản trị CSDL** | **SQL Server Management Studio (SSMS)** | Giao diện chạy script và xem bảng | [Tải SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) |
| 6 | **Version Control** | **Git** | Tải và đồng bộ mã nguồn | [Git SCM](https://git-scm.com/) |

> ⚠️ **LƯU Ý CỰC KỲ QUAN TRỌNG VỀ TOMCAT:**  
> Tuyệt đối **KHÔNG dùng Tomcat 9 trở xuống** (Tomcat 9 dùng namespace cũ `javax.servlet.*`). Dự án EduCenter dùng **Tomcat 10.1+** với namespace chuẩn mới `jakarta.servlet.*` và `jakarta.persistence.*`.

---

## Bước 1: Tải Mã Nguồn Về Máy (Clone Repository)

Mở **Terminal** (macOS/Linux) hoặc **Command Prompt / PowerShell** (Windows) và chạy lệnh:

```bash
git clone https://github.com/thanhtuanfptse05/EduCenter.git
cd EduCenter
```

> **Gợi ý:** Toàn bộ các thư viện `.jar` cần thiết (Hibernate 6.4, Jakarta Persistence, SQL Server JDBC driver, BCrypt, JSTL 3.0...) đã được đóng gói sẵn trong thư mục `web/WEB-INF/lib/` và `allowedlib/`. Bạn **không cần tải thêm bất kỳ file JAR ngoài nào**.

---

## Bước 2: Cài Đặt & Nạp Cơ Sở Dữ Liệu SQL Server

EduCenter có sẵn bộ dữ liệu mẫu chuẩn nghiệp vụ gồm 30 bảng, 15+ khóa học, 14 lớp học, phòng học, lịch học và hơn 30 tài khoản thử nghiệm. Bạn có thể chọn **1 trong 3 cách** nạp dữ liệu dưới đây:

### 🚀 Cách 1: Nạp Tự Động 1-Click Bằng File Batch (Khuyên Dùng — 5 Giây Xong)
Nếu SQL Server của bạn có tài khoản `sa` với mật khẩu mặc định là `123`:
1. Mở thư mục dự án: `EduCenter\docs\database\`.
2. Nhấp đúp chuột (Double-click) vào file **`run_all_seeds.bat`**.
3. Cửa sổ Command Prompt sẽ chạy tự động 8 bước từ tạo CSDL `EduCenterDB` đến nạp toàn bộ dữ liệu. Kết thúc hiện thông báo màu xanh lá báo thành công!

---

### 💻 Cách 2: Nạp Bằng PowerShell (Tùy biến tài khoản / Instance)
Nếu bạn đặt mật khẩu `sa` khác hoặc dùng bản **SQL Server Express** / **Windows Authentication**:

* **Trường hợp A: Dùng tài khoản `sa` với mật khẩu riêng của bạn:**
  ```powershell
  .\docs\database\run_all_seeds.ps1 -Server "localhost" -User "sa" -Password "MatKhauCuaBan"
  ```

* **Trường hợp B: Dùng Windows Authentication (Không cần mật khẩu sa):**
  ```powershell
  .\docs\database\run_all_seeds.ps1 -Server "localhost" -UseWindowsAuth
  ```

* **Trường hợp C: Dùng SQL Server Express (`localhost\SQLEXPRESS`):**
  ```powershell
  .\docs\database\run_all_seeds.ps1 -Server "localhost\SQLEXPRESS" -UseWindowsAuth
  ```

---

### 🖥️ Cách 3: Nạp Thủ Công Bằng SQL Server Management Studio (SSMS)
Nếu bạn muốn theo dõi trực quan từng bước:
1. Mở **SSMS** và kết nối vào SQL Server của bạn (`.` hoặc `localhost` hoặc `localhost\SQLEXPRESS`).
2. Vào menu `File` -> `Open` -> `File...` (hoặc `Ctrl + O`), điều hướng tới `docs\database\seeds\`.
3. Mở và nhấn **F5** (hoặc nút **Execute**) lần lượt theo đúng thứ tự 8 file sau:
   - `01_schema_baseline.sql` *(Tạo database EduCenterDB và 30 bảng)*
   - `02_roles_and_settings.sql` *(Tạo 5 vai trò và tham số cấu hình)*
   - `03_subjects_and_courses.sql` *(Tạo bộ môn và khóa học)*
   - `04_users_teachers_staff_students.sql` *(Tạo tài khoản Giáo viên, Nhân viên, Học sinh, Phụ huynh)*
   - `05_rooms_and_classes.sql` *(Tạo phòng học và lớp học)*
   - `06_timetables_and_sessions.sql` *(Tạo lịch học tuần và các ca học)*
   - `07_enrollments_invoices_payments.sql` *(Tạo đơn ghi danh, hóa đơn, biên lai)*
   - `08_attendance_assessments_leads.sql` *(Tạo điểm danh, điểm thi, CRM Leads)*

> ⛔ **Lưu ý:** Bắt buộc chạy đúng thứ tự từ 01 đến 08 để không bị lỗi vi phạm ràng buộc khóa ngoại (Foreign Key).

---

## Bước 3: Cấu Hình Kết Nối CSDL Trong Mã Nguồn

Kiểm tra thông tin đăng nhập SQL Server trong file cấu hình JPA của dự án:
- Vị trí: `src/conf/META-INF/persistence.xml` (và `src/java/META-INF/persistence.xml`)

Mở file và kiểm tra các dòng sau:

```xml
<!-- Cấu hình kết nối Microsoft SQL Server -->
<properties>
    <property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver"/>
    <property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://localhost:1433;databaseName=EduCenterDB;encrypt=false;trustServerCertificate=true;"/>
    <property name="jakarta.persistence.jdbc.user" value="sa"/>
    <property name="jakarta.persistence.jdbc.password" value="123"/>
    
    <property name="hibernate.dialect" value="org.hibernate.dialect.SQLServerDialect"/>
    <property name="hibernate.show_sql" value="true"/>
    <property name="hibernate.format_sql" value="true"/>
    <property name="hibernate.hbm2ddl.auto" value="none"/>
</properties>
```

👉 **Điều chỉnh cần thiết nếu máy bạn khác mặc định:**
* Nếu mật khẩu `sa` máy bạn khác `123`: Hãy đổi giá trị thẻ `<property name="jakarta.persistence.jdbc.password" value="Mật_Khẩu_Mới"/>`.
* Nếu dùng SQL Server Express cổng động: Hãy đổi URL thành:  
  `jdbc:sqlserver://localhost;instanceName=SQLEXPRESS;databaseName=EduCenterDB;encrypt=false;trustServerCertificate=true;`

---

## Bước 4: Cấu Hình & Chạy Dự Án Trên NetBeans IDE 17

### 4.1. Mở dự án trong NetBeans
1. Khởi động **Apache NetBeans IDE 17**.
2. Chọn menu `File` -> `Open Project...` (hoặc nhấn `Ctrl + Shift + O`).
3. Điều hướng đến thư mục vừa clone `EduCenter` -> Nhấn nút **Open Project**.

---

### 4.2. Thêm Tomcat 10.1 vào NetBeans (Nếu chưa có)
1. Trong NetBeans, mở thẻ **Services** (thường nằm cạnh thẻ Projects bên trái màn hình).  
   *(Nếu không thấy, vào menu `Window` -> `Services` hoặc `Ctrl + 5`)*.
2. Mở rộng mục **Servers** -> Nhấp chuột phải vào **Servers** -> Chọn **Add Server...**.
3. Chọn **Apache Tomcat or TomEE** -> Nhấn **Next**.
4. Tại ô **Server Location**, bấm **Browse...** và chọn thư mục giải nén của **Tomcat 10.1** (Ví dụ: `C:\Program Files\Apache Software Foundation\Tomcat 10.1`).
5. Đặt username/password quản trị cho Tomcat (ví dụ: `admin` / `admin`) -> Bấm **Finish**.

---

### 4.3. Gán Tomcat 10.1 và JDK 17 cho Dự Án
1. Tại thẻ **Projects**, nhấp chuột phải vào dự án **EduCenter** -> Chọn **Properties**.
2. Chọn mục **Run** ở cột bên trái:
   - **Server:** Chọn **Apache Tomcat 10.1**.
   - **Java EE Version:** Đảm bảo hiển thị `Jakarta EE 10 Web` (hoặc `10-web`).
   - **Context Path:** `/EduCenter`.
3. Chọn mục **Libraries**:
   - **Java Platform:** Đảm bảo chọn **JDK 17** (nếu chưa có, bấm *Manage Platforms...* để trỏ tới thư mục cài đặt JDK 17).
4. Nhấn **OK** để lưu cấu hình.

---

### 4.4. Biên dịch và Khởi chạy ứng dụng
1. Nhấp chuột phải vào tên dự án **EduCenter** -> Chọn **Clean and Build** *(phím tắt `Shift + F11`)*.  
   *Chờ thanh trạng thái hiển thị: `BUILD SUCCESSFUL`*.
2. Nhấp chuột phải vào **EduCenter** -> Chọn **Run** *(phím tắt `F6`)*.
3. NetBeans sẽ tự động bật Tomcat 10.1, deploy ứng dụng và mở trình duyệt tại địa chỉ:
   ```
   http://localhost:8080/EduCenter/
   ```

---

## Bước 5: Đăng Nhập & Trải Nghiệm Các Phân Quyền (Roles)

Hệ thống EduCenter được thiết kế phân quyền chặt chẽ với **5 vai trò chính thức**.  
Tất cả các tài khoản mẫu đều dùng chung mật khẩu mặc định: **`123456`**.

### 🔑 Bảng Tài Khoản Đăng Nhập Mẫu

| Phân quyền | Email đăng nhập | Mật khẩu | Chức năng nổi bật | URL Bắt Đầu |
|---|---|:---:|---|---|
| **Quản trị viên (ADMIN)** | `admin@educenter.vn` | `123456` | Toàn quyền quản trị trung tâm, tài khoản, khóa học, giáo viên, phòng học, thời khóa biểu, KPI doanh thu | `/admin/dashboard` |
| **Nhân viên Tuyển sinh (STAFF)** | `staff@educenter.vn` | `123456` | Tiếp nhận CRM Leads, lập giỏ đăng ký khóa học, ghi danh học viên, tạo hóa đơn thu học phí | `/staff/dashboard` |
| **Giáo viên (TEACHER)** | `teacher.hung@educenter.vn` | `123456` | Xem lịch giảng dạy tuần, điểm danh từng ca học, nhập điểm thi & nhật ký buổi học | `/teacher/dashboard` |
| **Học sinh (STUDENT)** | `student.nam@educenter.vn` | `123456` | Xem thời khóa biểu cá nhân, tiến độ học tập, bảng điểm, đăng ký khóa học bổ trợ | `/student/dashboard` |
| **Phụ huynh (PARENT)** | `parent.tuan@educenter.vn` | `123456` | Theo dõi chuyên cần, kết quả thi, lịch học và hóa đơn học phí của con em | `/parent/dashboard` |

> 💡 **Mẹo:** Bạn có thể đăng xuất bất kỳ lúc nào bằng nút **Đăng xuất** ở góc trên bên phải header hoặc truy cập thẳng `http://localhost:8080/EduCenter/logout`.

---

## 7. Khắc Phục Các Lỗi Thường Gặp (Troubleshooting / FAQ)

### ❓ Lỗi 1: `jakarta.servlet.ServletException: ClassNotFoundException` hoặc lỗi 404 / 500 khi vừa khởi động
* **Nguyên nhân:** Bạn đang chạy trên Tomcat 9, Tomcat 8 hoặc TomEE cũ (vốn dùng namespace `javax.*`).
* **Khắc phục:** Tải và cấu hình đúng **Apache Tomcat 10.1.x** trong NetBeans (xem lại [Bước 4.2](#42-thêm-tomcat-101-vào-netbeans-nếu-chưa-có)).

---

### ❓ Lỗi 2: `Cannot open database "EduCenterDB" requested by the login`
* **Nguyên nhân:** Cơ sở dữ liệu `EduCenterDB` chưa được tạo trong SQL Server.
* **Khắc phục:** Mở thư mục `docs/database/` và chạy file `run_all_seeds.bat` (hoặc mở SSMS chạy file `01_schema_baseline.sql`).

---

### ❓ Lỗi 3: Lỗi kết nối SSL `The driver could not establish a secure connection using TLS/SSL encryption`
* **Nguyên nhân:** Driver Microsoft JDBC yêu cầu xác thực chứng chỉ SSL mặc định trên SQL Server 2019/2022.
* **Khắc phục:** Trong chuỗi URL `persistence.xml` đã được cấu hình sẵn `encrypt=false;trustServerCertificate=true;`. Hãy đảm bảo bạn không xóa 2 tham số này.

---

### ❓ Lỗi 4: Lỗi tài khoản `sa` bị vô hiệu hóa hoặc sai mật khẩu (`Login failed for user 'sa'`)
* **Nguyên nhân:** SQL Server chưa bật chế độ chứng thực kép (Mixed Mode Authentication) hoặc mật khẩu `sa` trên máy bạn khác `123`.
* **Khắc phục:**
  1. Mở SSMS, đăng nhập bằng Windows Authentication.
  2. Chuột phải vào tên Server -> Chọn **Properties** -> Tab **Security** -> Chọn **SQL Server and Windows Authentication mode** -> Nhấn OK.
  3. Mở rộng thư mục `Security` -> `Logins` -> Chuột phải vào user `sa` -> Chọn **Properties**:
     - Đặt lại mật khẩu thành `123` (hoặc mật khẩu bạn muốn).
     - Tab **Status**: Chọn **Login: Enabled**.
  4. Khởi động lại dịch vụ SQL Server (Restart SQL Server Service).

---

### ❓ Lỗi 5: Lỗi không kết nối được cổng 1433 (`Connection refused` hoặc TCP/IP bị tắt)
* **Nguyên nhân:** Dịch vụ TCP/IP của SQL Server mặc định thường bị tắt khi cài đặt bản SQL Server Express.
* **Khắc phục:**
  1. Nhấn `Windows + R`, gõ `SQLServerManager16.msc` (hoặc tìm **SQL Server Configuration Manager** trong Start Menu).
  2. Mở mục **SQL Server Network Configuration** -> Chọn **Protocols for MSSQLSERVER** (hoặc SQLEXPRESS).
  3. Nhấp đúp vào **TCP/IP** -> Chuyển **Enabled** thành **Yes**.
  4. Sang tab **IP Addresses** -> Kéo xuống dưới cùng mục **IPAll** -> Đặt **TCP Port** là `1433`.
  5. Chọn mục **SQL Server Services** ở cột trái -> Chuột phải vào **SQL Server** -> Chọn **Restart**.

---

### ❓ Lỗi 6: Xung đột cổng 8080 (`Port 8080 already in use`)
* **Nguyên nhân:** Cổng 8080 đang bị ứng dụng khác chiếm giữ (Oracle XE, Spring Boot, Jenkins, một phiên bản Tomcat chạy nền...).
* **Khắc phục:**
  - *Cách 1 (Tắt tiến trình chiếm cổng):* Mở PowerShell với quyền Admin và chạy:
    ```powershell
    Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess | Stop-Process -Force
    ```
  - *Cách 2 (Đổi cổng Tomcat):* Mở file `conf/server.xml` trong thư mục cài đặt Tomcat 10.1, tìm dòng `<Connector port="8080" protocol="HTTP/1.1"` và đổi thành `port="8088"` hoặc `port="8888"`.

---

### ❓ Lỗi 7: NetBeans báo lỗi phiên bản Java `Source level 17 does not match platform...`
* **Nguyên nhân:** NetBeans đang trỏ mặc định tới JDK 8, 11 hoặc phiên bản khác 17.
* **Khắc phục:** Vào NetBeans -> menu `Tools` -> `Java Platforms` -> Kiểm tra đã có **JDK 17** chưa. Nếu chưa, bấm **Add Platform...** và trỏ đến thư mục cài đặt JDK 17 (Ví dụ: `C:\Program Files\Eclipse Adoptium\jdk-17...`).

---

## 📞 Hỗ Trợ & Đóng Góp

Nếu bạn gặp bất kỳ vấn đề nào ngoài danh sách trên trong quá trình cài đặt:
1. Mở issue trên GitHub: [EduCenter Issues](https://github.com/thanhtuanfptse05/EduCenter/issues)
2. Liên hệ nhóm phát triển EduCenter:
   - **Thành viên 01 (Academic Module):** Quản lý Đào tạo, Khóa học, Giáo viên, Lịch học.
   - **Thành viên 02 (Admission Module):** Tuyển sinh, Giỏ hàng, Tư vấn, Học viên, Phụ huynh.
   - **Thành viên 03 (Finance & Admin Module):** Tài chính, Thu học phí, Người dùng, Cấu hình hệ thống.

---
*Chúc bạn cài đặt thành công và có trải nghiệm tuyệt vời cùng hệ thống EduCenter!* 🎉
