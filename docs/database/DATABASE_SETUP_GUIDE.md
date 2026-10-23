# Hướng Dẫn Cài Đặt & Khởi Tạo Cơ Sở Dữ Liệu EduCenter (Dành Cho Người Mới)

Tài liệu này hướng dẫn chi tiết cách cài đặt, khởi tạo cấu trúc bảng và nạp dữ liệu mẫu (Seed Data) cho hệ thống **EduCenter ERP** trên hệ quản trị cơ sở dữ liệu **Microsoft SQL Server**.

---

## 1. Cấu Trúc Thư Mục Dữ Liệu

Toàn bộ script khởi tạo và dữ liệu được module hóa rõ ràng trong thư mục `docs/database/`:

```
docs/database/
├── DATABASE_SETUP_GUIDE.md      <-- Bạn đang đọc tài liệu này
├── run_all_seeds.bat            <-- File kích hoạt nạp tự động bằng 1 cú click chuột (Windows)
├── run_all_seeds.ps1            <-- Script PowerShell tự động hóa với đầy đủ tham số
└── seeds/
    ├── 01_schema_baseline.sql   <-- Bước 1: Tạo DB EduCenterDB & 30 bảng chuẩn JPA
    ├── 02_roles_and_settings.sql<-- Bước 2: 5 Vai trò hệ thống & tham số cấu hình trung tâm
    ├── 03_subjects_and_courses.sql <-- Bước 3: 6 Môn học & 15 Khóa học THCS - THPT
    ├── 04_users_teachers_staff_students.sql <-- Bước 4: 30+ Tài khoản, Giáo viên, Nhân viên, Học sinh, Phụ huynh
    ├── 05_rooms_and_classes.sql <-- Bước 5: 7 Phòng học & 14 Lớp học chuyên đề / luyện thi
    ├── 06_timetables_and_sessions.sql <-- Bước 6: Lịch học tuần & 50+ Buổi học chi tiết
    ├── 07_enrollments_invoices_payments.sql <-- Bước 7: 22 Ghi danh, Hóa đơn học phí & Biên lai thu tiền
    └── 08_attendance_assessments_leads.sql <-- Bước 8: Điểm danh, Điểm thi/kiểm tra, CRM Leads & Audit Logs
```

### Tại sao dữ liệu lại được chia thành 8 bước?
Trong cơ sở dữ liệu quan hệ (RDBMS), các bảng có mối quan hệ **Khóa ngoại (Foreign Key)** chặt chẽ với nhau:
- Không thể tạo Lớp học nếu chưa có Khóa học và Giáo viên.
- Không thể tạo Giáo viên hay Học viên nếu chưa có tài khoản Người dùng (`Users`).
- Không thể tạo Điểm danh hay Bảng điểm nếu chưa có Buổi học và Đơn ghi danh.
Việc chia nhỏ thành 8 file có đánh số thứ tự từ `01` đến `08` giúp bảo đảm tính toàn vẹn dữ liệu, dễ theo dõi và tránh hoàn toàn lỗi vi phạm ràng buộc khóa ngoại.

---

## 2. Cách 1: Nạp Tự Động 1-Click (Khuyên Dùng)

### 2.1. Sử dụng File Batch (`.bat`)
Nếu bạn sử dụng tài khoản `sa` với mật khẩu mặc định `123`:
1. Mở thư mục `docs/database/`.
2. Nhấp đúp chuột (Double click) vào file **`run_all_seeds.bat`**.
3. Cửa sổ Command Prompt sẽ tự động mở lên, thực thi tuần tự 8 file SQL và hiển thị kết quả màu xanh lá báo thành công.

### 2.2. Sử dụng PowerShell (`.ps1`)
Nếu SQL Server của bạn sử dụng mật khẩu khác hoặc sử dụng Windows Authentication:

* **Trường hợp 1: Dùng SQL Authentication (Tùy biến tài khoản/mật khẩu)**
  Mở PowerShell tại thư mục dự án và chạy:
  ```powershell
  .\docs\database\run_all_seeds.ps1 -Server "localhost" -User "sa" -Password "mat_khau_cua_ban"
  ```

* **Trường hợp 2: Dùng Windows Authentication (Không cần mật khẩu sa)**
  ```powershell
  .\docs\database\run_all_seeds.ps1 -Server "localhost" -UseWindowsAuth
  ```

* **Trường hợp 3: Dùng SQL Express (Tên instance là `SQLEXPRESS`)**
  ```powershell
  .\docs\database\run_all_seeds.ps1 -Server "localhost\SQLEXPRESS" -UseWindowsAuth
  ```

---

## 3. Cách 2: Nạp Thủ Công Bằng SQL Server Management Studio (SSMS)

Dành cho người mới muốn quan sát trực tiếp từng bảng và dữ liệu trong công cụ trực quan:

1. Mở **SQL Server Management Studio (SSMS)** và kết nối tới máy chủ SQL Server của bạn.
2. Nhấn `Ctrl + O` (hoặc vào menu `File -> Open -> File...`), chuyển tới thư mục `docs/database/seeds/`.
3. Mở và nhấn **F5** (hoặc nút **Execute**) lần lượt theo đúng thứ tự sau:
   - **Bước 1:** Mở `01_schema_baseline.sql` -> Nhấn **F5** (Tạo CSDL `EduCenterDB` và 30 bảng).
   - **Bước 2:** Mở `02_roles_and_settings.sql` -> Nhấn **F5** (Nạp roles và settings).
   - **Bước 3:** Mở `03_subjects_and_courses.sql` -> Nhấn **F5** (Nạp môn học và khóa học).
   - **Bước 4:** Mở `04_users_teachers_staff_students.sql` -> Nhấn **F5** (Nạp người dùng và hồ sơ).
   - **Bước 5:** Mở `05_rooms_and_classes.sql` -> Nhấn **F5** (Nạp phòng học và lớp).
   - **Bước 6:** Mở `06_timetables_and_sessions.sql` -> Nhấn **F5** (Nạp lịch học và buổi học).
   - **Bước 7:** Mở `07_enrollments_invoices_payments.sql` -> Nhấn **F5** (Nạp ghi danh và thanh toán).
   - **Bước 8:** Mở `08_attendance_assessments_leads.sql` -> Nhấn **F5** (Nạp điểm danh, điểm thi, CRM).

> **Lưu ý:** Tuyệt đối không nhảy cóc thứ tự để tránh lỗi ràng buộc khóa ngoại (Foreign Key Constraint Violation).

---

## 4. Danh Sách Tài Khoản Thử Nghiệm

Tất cả các tài khoản mẫu dưới đây đều đã được băm mật khẩu chuẩn **BCrypt** an toàn.  
**Mật khẩu đăng nhập cho tất cả tài khoản mẫu là:** `123456`

| Vai trò | Email đăng nhập | Họ và tên | Chức vụ / Ghi chú |
|---|---|---|---|
| **ADMIN** | `admin@educenter.edu.vn` | Hoàng Văn Quản | Quản trị viên toàn quyền hệ thống |
| **ACADEMIC** | `academic@educenter.edu.vn` | Lê Thị Học Vụ | Trưởng phòng Đào tạo & Khảo thí |
| **TEACHER** | `thanh.nv@educenter.edu.vn` | Nguyễn Văn Thành | Thạc sĩ Toán học - Giáo viên chuyên đề |
| **TEACHER** | `minh.tran@educenter.edu.vn` | Trần Thị Minh | Thạc sĩ Vật lý - Chuyên gia luyện thi ĐH |
| **TEACHER** | `hoa.pham@educenter.edu.vn` | Phạm Thu Hòa | Cử nhân Tiếng Anh (IELTS 8.5) |
| **STAFF** | `staff1@educenter.edu.vn` | Vũ Thị Tư Vấn | Chuyên viên tuyển sinh & CRM |
| **STAFF** | `staff2@educenter.edu.vn` | Đỗ Văn Chăm Sóc | Chuyên viên tư vấn khóa học |
| **STUDENT** | `nam.nguyen@student.edu.vn` | Nguyễn Nhật Nam | Học sinh Lớp 12 - Luyện thi THPT |
| **STUDENT** | `mai.le@student.edu.vn` | Lê Phương Mai | Học sinh Lớp 10 - Chuyên Toán |
| **PARENT** | `ph.namnguyen@gmail.com` | Nguyễn Văn Hùng | Phụ huynh học sinh Nguyễn Nhật Nam |
| **PARENT** | `ph.mai@gmail.com` | Trần Thị Lan | Phụ huynh học sinh Lê Phương Mai |

---

## 5. Cấu Hình Kết Nối Ứng Dụng (Trong Mã Nguồn)

Sau khi nạp CSDL thành công, hãy kiểm tra file cấu hình JPA của dự án tại:  
`src/java/META-INF/persistence.xml`

Đảm bảo các thông số kết nối khớp với môi trường máy của bạn:

```xml
<property name="jakarta.persistence.jdbc.driver" value="com.microsoft.sqlserver.jdbc.SQLServerDriver"/>
<property name="jakarta.persistence.jdbc.url" value="jdbc:sqlserver://localhost:1433;databaseName=EduCenterDB;encrypt=false;trustServerCertificate=true;"/>
<property name="jakarta.persistence.jdbc.user" value="sa"/>
<property name="jakarta.persistence.jdbc.password" value="123"/>
```

*Nếu mật khẩu tài khoản `sa` của bạn khác `123`, hãy sửa lại giá trị tại thuộc tính `jakarta.persistence.jdbc.password`.*

---

## 6. Kiểm Tra Dữ Liệu Sau Khi Cài Đặt (Verification Query)

Bạn có thể mở một cửa sổ truy vấn mới (New Query) trong SSMS và chạy câu lệnh sau để kiểm tra nhanh tổng số lượng bản ghi của toàn bộ hệ thống:

```sql
USE EduCenterDB;
GO

SELECT 
    'Roles' AS TableName, COUNT(*) AS TotalRows FROM dbo.Roles UNION ALL
SELECT 'Users', COUNT(*) FROM dbo.Users UNION ALL
SELECT 'Teachers', COUNT(*) FROM dbo.Teachers UNION ALL
SELECT 'Students', COUNT(*) FROM dbo.Students UNION ALL
SELECT 'Guardians', COUNT(*) FROM dbo.Guardians UNION ALL
SELECT 'Subjects', COUNT(*) FROM dbo.Subjects UNION ALL
SELECT 'Courses', COUNT(*) FROM dbo.Courses UNION ALL
SELECT 'Rooms', COUNT(*) FROM dbo.Rooms UNION ALL
SELECT 'Classes', COUNT(*) FROM dbo.Classes UNION ALL
SELECT 'ClassSessions', COUNT(*) FROM dbo.ClassSessions UNION ALL
SELECT 'Enrollments', COUNT(*) FROM dbo.Enrollments UNION ALL
SELECT 'Invoices', COUNT(*) FROM dbo.Invoices UNION ALL
SELECT 'Payments', COUNT(*) FROM dbo.Payments UNION ALL
SELECT 'Assessments', COUNT(*) FROM dbo.Assessments UNION ALL
SELECT 'AssessmentScores', COUNT(*) FROM dbo.AssessmentScores UNION ALL
SELECT 'Attendances', COUNT(*) FROM dbo.Attendances UNION ALL
SELECT 'TeachingJournals', COUNT(*) FROM dbo.TeachingJournals UNION ALL
SELECT 'Leads', COUNT(*) FROM dbo.Leads;
GO
```

**Kết quả mong đợi:** Tất cả các bảng trên đều có số lượng bản ghi lớn hơn 0, không có bảng nào bị rỗng.

---

## 7. Xử Lý Các Lỗi Thường Gặp

1. **Lỗi `Login failed for user 'sa'`:**
   - Kiểm tra xem SQL Server đã bật chế độ xác thực kết hợp (*SQL Server and Windows Authentication mode*) chưa. Trong SSMS: Click chuột phải vào Server -> `Properties` -> `Security` -> Chọn `SQL Server and Windows Authentication mode`.
   - Kiểm tra xem tài khoản `sa` đã được `Enable` và đặt đúng mật khẩu chưa.

2. **Lỗi `The TCP/IP connection to the host localhost, port 1433 has failed`:**
   - Mở ứng dụng **SQL Server Configuration Manager**.
   - Vào `SQL Server Network Configuration` -> `Protocols for MSSQLSERVER` (hoặc `Protocols for SQLEXPRESS`).
   - Đảm bảo giao thức **TCP/IP** đang ở trạng thái **Enabled**.
   - Vào tab `IP Addresses`, kéo xuống mục `IPAll` và điền `TCP Port` là `1433`.
   - Khởi động lại (Restart) dịch vụ **SQL Server**.

3. **Lỗi `Cannot create file ... because it already exists`:**
   - File `01_schema_baseline.sql` đã được thiết kế sẵn logic xóa bảng cũ theo đúng thứ tự an toàn, không cần xóa thủ công database trước khi chạy.
