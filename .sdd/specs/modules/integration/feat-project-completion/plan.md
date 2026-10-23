# Implementation Plan: System Hardening & Complete Stabilization (feat-project-completion)

**Branch**: `main` | **Date**: 2026-10-24 | **Spec**: [spec.md](spec.md)  
**Input**: Specification for addressing 13 business gaps (B01–B13), UI hardening (policies, safe handlers, CSS tokens), dedicated Teacher Dashboard, isolated unit tests, and comprehensive database seeds.

---

## 1. Summary

Kế hoạch triển khai tập trung khắc phục triệt để các lỗ hổng nghiệp vụ và hoàn thiện chất lượng sản phẩm chuẩn ERP cho EduCenter:
1. **Academic**: Kiểm tra danh sách học viên hợp lệ và ngày hiệu lực ghi danh khi lưu điểm và điểm danh (B01); chuẩn hóa thang điểm 10 và tính trung bình theo trọng số (B02); xử lý xóa điểm thành công khi xóa trắng ô điểm (B03); tính đúng chuyên cần theo số buổi hợp lệ và bảo tồn lịch sử học viên (B04, B05); Audit Log khi mở lại bài kiểm tra và khóa sửa điểm công bố (B12); giới hạn sinh lịch trong kỳ và kiểm tra sức chứa phòng học (B09); xây dựng Teacher Dashboard chuyên dụng.
2. **Admission & CRM**: Khóa kiểm tra sĩ số ghi danh trong transaction (B07); kiểm tra lại xung đột lịch khi phục hồi bảo lưu và loại trừ lớp cũ khi chuyển lớp (B08); siết quyền tư vấn Lead theo STAFF và chặn chuyển trạng thái `ENROLLED` tùy tiện (B10); áp dụng cờ kiểm tra đóng tuyển sinh `SYSTEM_ADMISSIONS_OPEN` (B13).
3. **Finance & Administration**: Tính công nợ chính xác bằng `finalAmount - paidAmount` trên báo cáo & dashboard (B06); bắt buộc mã tham chiếu duy nhất khi chuyển khoản và chống gửi lặp phiếu thu (B11); Audit Log khi ghi nhận thanh toán (B12); đọc thời hạn thanh toán từ cấu hình `TUITION_DUE_DAYS` (B13).
4. **UI & Presentation**: Bổ sung các trang chính sách pháp lý `/terms`, `/privacy`, `/refund-policy`, `/support`; thay thế `onclick` chuỗi bằng thuộc tính `data-*` an toàn; đồng bộ biến CSS tokens (`--info`, `--bg-alt`, `--radius-xs`) cho Light & Dark mode.
5. **Quality & Tooling**: Cô lập `AttendanceServiceImpl` bằng `Supplier<EntityManager>` để 149/149 test pass cô lập; tổ chức bộ script CSDL từ `01` đến `08` với tài liệu hướng dẫn chi tiết.

---

## 2. Technical Context

- **Language/Version**: Java 17 (OpenJDK 17 LTS)
- **Servlet Container**: Apache Tomcat 10.1 (Namespace `jakarta.servlet.*`, `jakarta.servlet.http.*`)
- **Persistence**: JPA (Jakarta Persistence 3.1) + Hibernate ORM 6.x (Namespace `jakarta.persistence.*`)
- **Database**: Microsoft SQL Server (Transact-SQL)
- **View**: JSP + JSTL (Jakarta Tags: `jakarta.tags.core`, `jakarta.tags.fmt`) + EL `${...}`
- **Build Tool**: Ant (NetBeans Standard Web Application)
- **Testing**: JUnit 5 (JUnit Jupiter)
- **UI Design System**: Vanilla CSS, Design Tokens (`tokens.css`), Inter font, Lucide outline SVG icons, Default Light Mode.

---

## 3. Constitution & Architecture Check

| Tiêu chí | Đánh giá | Giải pháp tuân thủ |
|---|---|---|
| Phân tầng MVC | ĐẠT | Controller nhận request -> Service xử lý nghiệp vụ & transaction -> Repository thao tác JPA -> View JSP nhận DTO |
| Không dùng JDBC trần | ĐẠT | 100% truy vấn dữ liệu thông qua JPA `EntityManager`, JPQL và Criteria API |
| Quy tắc PRG | ĐẠT | Toàn bộ POST chuyển hướng `response.sendRedirect` kèm `FlashMessageUtil` |
| Quản lý kết nối JPA | ĐẠT | Mọi `EntityManager` được mở/đóng trong khối `try-finally` an toàn |
| Bảo mật & Phân quyền | ĐẠT | Kiểm tra role và ownership ở tầng Filter lẫn tầng Service |
| Design System | ĐẠT | Default Light mode, không dùng Tailwind CDN, dùng token CSS chuẩn hóa |
| Cấm Hardcode UI | ĐẠT | Dữ liệu hiển thị 100% động từ CSDL kèm Empty State chuyên nghiệp |

---

## 4. Phase 0: Research & Solution Design

### B01: Kiểm tra học viên thuộc lớp khi nhập điểm và điểm danh
- **Hiện trạng**: `AssessmentServiceImpl.saveScores` và `AttendanceServiceImpl.saveAttendance` duyệt qua `StudentScoreItemDTO` / `AttendanceRosterItemDTO`, chỉ `find(Student.class, studentId)` mà không kiểm tra student có thuộc `eduClass` hay không.
- **Giải pháp**:
  - Với điểm: Truy vấn danh sách `validStudentIds` trong lớp qua `enrollmentRepository.findActiveStudentIdsByClassId(em, classId)` (hoặc kiểm tra `Enrollment` có `status IN ('ACTIVE', 'COMPLETED')`). Nếu `studentId` gửi lên không thuộc danh sách -> ném `ValidationException("Học viên không thuộc danh sách lớp học!")`.
  - Với điểm danh: Tương tự, kiểm tra học viên có Enrollment hiệu lực tại ngày của buổi học (`startDate <= sessionDate AND (endDate IS NULL OR endDate >= sessionDate)`).

### B02: Điểm trung bình Portal tính theo thang điểm và trọng số
- **Hiện trạng**: `PortalServiceImpl.java:191` cộng dồn `s.getScore()` rồi chia cho số lượng bài thi (`totalScore.divide(count)`), bỏ qua `maxScore` (ví dụ 80/100) và `weight`.
- **Giải pháp**:
  - Chuẩn hóa từng điểm về thang 10: `normScore = score / maxScore * 10`.
  - Tính trung bình có trọng số: `sum(normScore * weight) / sum(weight)`.
  - Trả về điểm trung bình chính xác đến 2 chữ số thập phân (`RoundingMode.HALF_UP`).

### B03: Xóa điểm ô input vẫn giữ điểm cũ
- **Hiện trạng**: Vòng lặp chỉ xử lý `if (item.getScore() != null)`. Khi người dùng xóa trắng điểm, `item.getScore()` là `null`, hệ thống bỏ qua không làm gì, dẫn tới điểm cũ trong CSDL được giữ nguyên.
- **Giải pháp**:
  - Nếu `item.getScore() == null`: kiểm tra nếu đã có điểm `existingScore` trong CSDL cho học viên này tại bài kiểm tra -> gọi `em.remove(existingScore)` hoặc `assessmentRepository.deleteScore(em, existingScore)`.

### B04 & B05: Chuyên cần và lịch sử điểm danh
- **Hiện trạng**:
  - `ReportRepository.java` đếm số bản ghi trong bảng `Attendance`, chỉ đếm `PRESENT`, chia cho tổng bản ghi, nếu rỗng thì gán mặc định 100%.
  - `AttendanceRepository.findRosterForSession` lọc `e.status IN ('ACTIVE', 'COMPLETED')`, khiến học sinh chuyển lớp/bảo lưu bị mất khỏi danh sách buổi cũ.
- **Giải pháp**:
  - Mẫu số chuyên cần là tổng số lượt điểm danh hợp lệ của các buổi `COMPLETED`.
  - Tử số có mặt = số lượt `PRESENT` + số lượt `LATE`.
  - Nếu tổng số lượt = 0 -> Tỷ lệ = 0.0% (hiển thị trạng thái "Chưa có dữ liệu" trên giao diện).
  - Danh sách điểm danh của một buổi học bao gồm: Tất cả học viên đã có bản ghi `Attendance` trong buổi đó (bất kể trạng thái ghi danh hiện tại) + các học viên có `Enrollment` hiệu lực vào ngày diễn ra buổi học.

### B06: Tính công nợ dashboard và báo cáo
- **Hiện trạng**: `ReportRepository.java:38` truy vấn `SELECT SUM(i.finalAmount) FROM Invoice i WHERE i.status IN ('UNPAID', 'PARTIALLY_PAID')`, không trừ đi khoản tiền đã thu của hóa đơn `PARTIALLY_PAID`.
- **Giải pháp**:
  - Dư nợ = `SUM(i.finalAmount) - (SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.invoice.id = i.id AND p.status = 'CONFIRMED')`.
  - Hoặc tính trực tiếp qua subquery / JPQL: lấy tổng `finalAmount` trừ tổng `Payment` đã xác nhận của các hóa đơn chưa trả hết.

### B07 & B08: Ghi danh, khôi phục bảo lưu, chuyển lớp
- **Hiện trạng**:
  - `enrollStudent`: Kiểm tra sĩ số `countActiveByClassId` trước `tx.begin()`, không khóa lớp học để bảo vệ chỗ cuối. Thiếu kiểm tra `eduClass.getCourse().getStatus()`.
  - `resumeEnrollment`: Không kiểm tra xung đột lịch (`hasScheduleConflict`).
  - `transferClass`: Gọi `hasScheduleConflict` với toàn bộ lịch học của học sinh, dẫn tới bị xung đột với chính lớp cũ mà học sinh chuẩn bị rời đi; chưa kiểm tra học sinh đã có ghi danh ở lớp đích hay chưa.
- **Giải pháp**:
  - `enrollStudent`: Thực hiện kiểm tra sĩ số bên trong `tx.begin()`, kiểm tra `eduClass.getCourse().getStatus().equalsIgnoreCase("OPEN")`.
  - `resumeEnrollment`: Bổ sung kiểm tra `hasScheduleConflict(em, studentId, classId)`.
  - `transferClass`: Kiểm tra học sinh chưa ghi danh lớp mới (`isStudentActiveOrReservedInClass(em, studentId, newClassId)`); kiểm tra xung đột lịch với lớp mới nhưng loại trừ các buổi học của lớp cũ (`oldClassId`).

### B09: Giới hạn sinh lịch học và kiểm tra sức chứa phòng
- **Hiện trạng**: `ClassTimetableServiceImpl.java:502` cho phép sinh lịch đến `maxDate.plusMonths(3)`; khi chọn phòng học không kiểm tra `room.getCapacity() >= eduClass.getCapacity()`.
- **Giải pháp**:
  - Chặn sinh lịch vượt quá `maxDate` (`!currentDate.isAfter(maxDate)`).
  - Kiểm tra `room.getCapacity() < eduClass.getCapacity()` -> ném `ValidationException` cảnh báo phòng không đủ sức chứa cho lớp.

### B10: Phân quyền Lead CRM và siết trạng thái ENROLLED
- **Hiện trạng**: STAFF xem và sửa được mọi Lead; có thể cập nhật trạng thái trực tiếp sang `ENROLLED`.
- **Giải pháp**:
  - Lọc danh sách Lead: STAFF chỉ xem các Lead có `assignedTo.id = currentUserId` hoặc `assignedTo IS NULL`; ADMIN xem toàn bộ.
  - Sửa Lead: STAFF chỉ được cập nhật Lead được phân công cho mình.
  - Cấm chuyển trạng thái sang `ENROLLED` thủ công: Trạng thái `ENROLLED` chỉ được thiết lập tự động khi giao dịch ghi danh (`enrollStudent`) hoàn tất thành công.

### B11 & B12: Thu tiền, chống gửi lặp và Audit Log nghiệp vụ
- **Hiện trạng**: Thu tiền không bắt buộc mã giao dịch khi chuyển khoản, không kiểm tra trùng mã tham chiếu; mở lại điểm và ghi thu không lưu bản ghi `AuditLog`.
- **Giải pháp**:
  - Khi phương thức là `BANK_TRANSFER`: Bắt buộc nhập `transactionRef`, kiểm tra mã tham chiếu chưa từng được sử dụng trong bảng `Payments`.
  - Lưu bản ghi `AuditLog` cho các hành động: `RECORD_PAYMENT`, `PUBLISH_ASSESSMENT`, `REOPEN_ASSESSMENT`.
  - Cấm Admin sửa trực tiếp điểm thi đã công bố mà không thông qua quy trình mở lại `reopenAssessment` kèm lý do.

### B13: Cấu hình hạn nộp hóa đơn và cờ đóng tuyển sinh
- **Hiện trạng**: Hạn nộp hóa đơn cố định `plusDays(10)`; chưa kiểm tra cờ `SYSTEM_ADMISSIONS_OPEN` khi nộp form tư vấn / ghi danh.
- **Giải pháp**:
  - Đọc setting `TUITION_DUE_DAYS` (mặc định 10 ngày nếu chưa cấu hình) để cộng vào ngày phát hành.
  - Khi `SYSTEM_ADMISSIONS_OPEN` là `false`: Từ chối tiếp nhận đăng ký tư vấn và ghi danh mới, hiển thị thông báo trung tâm đang tạm đóng tiếp nhận học viên đợt mới.

---

## 5. Phase 1: Execution Details

### File Modifying & Creating Map

1. **Academic**:
   - `src/java/com/educenter/service/AssessmentServiceImpl.java` (B01, B03, B12)
   - `src/java/com/educenter/service/AttendanceServiceImpl.java` (B01, B04, B05, cô lập Unit Test)
   - `src/java/com/educenter/repository/AttendanceRepository.java` (B04, B05)
   - `src/java/com/educenter/service/PortalServiceImpl.java` (B02)
   - `src/java/com/educenter/service/ClassTimetableServiceImpl.java` (B09)
   - `src/java/com/educenter/controller/TeacherDashboardServlet.java` (Mới: Teacher Dashboard)
   - `web/WEB-INF/views/teacher/dashboard.jsp` (Mới: Giao diện Teacher Dashboard chuẩn `design.md`)

2. **Admission & CRM**:
   - `src/java/com/educenter/service/EnrollmentServiceImpl.java` (B07, B08, B13)
   - `src/java/com/educenter/repository/EnrollmentRepository.java` (B08)
   - `src/java/com/educenter/service/LeadServiceImpl.java` (B10, B13)
   - `src/java/com/educenter/controller/LeadController.java` (B10)
   - `src/java/com/educenter/controller/ConsultationController.java` / `LandingServlet.java` (B13)

3. **Finance & System**:
   - `src/java/com/educenter/repository/ReportRepository.java` (B04, B06)
   - `src/java/com/educenter/service/PaymentServiceImpl.java` (B11, B12)
   - `src/java/com/educenter/repository/PaymentRepository.java` (B11)

4. **UI & Presentation**:
   - `src/java/com/educenter/controller/PolicyServlet.java` (Mới: Phục vụ `/terms`, `/privacy`, `/refund-policy`, `/support`)
   - `web/WEB-INF/views/public/policy-terms.jsp`
   - `web/WEB-INF/views/public/policy-privacy.jsp`
   - `web/WEB-INF/views/public/policy-refund.jsp`
   - `web/WEB-INF/views/public/policy-support.jsp`
   - `web/WEB-INF/views/common/public-footer.jspf` (Cập nhật liên kết chính sách chuẩn)
   - `web/WEB-INF/views/auth/register.jsp` (Cập nhật liên kết điều khoản chuẩn)
   - `web/WEB-INF/views/staff/student-list.jsp`, `guardian-list.jsp`, `enrollment-list.jsp`, `student-detail.jsp` (Sửa các nút `onclick` sang `data-*` an toàn)
   - `web/assets/css/tokens.css` (Đồng bộ tokens `--info`, `--bg-alt`, `--radius-xs`)

5. **Testing**:
   - `test/com/educenter/service/AttendanceServiceTest.java` (Sửa mock để 5 test pass độc lập)

6. **Database Seed Data**:
   - `docs/database/seeds/01_schema_baseline.sql`
   - `docs/database/seeds/02_roles_and_settings.sql`
   - `docs/database/seeds/03_subjects_and_courses.sql`
   - `docs/database/seeds/04_rooms_and_classes.sql`
   - `docs/database/seeds/05_users_teachers_staff_students.sql`
   - `docs/database/seeds/06_timetables_and_sessions.sql`
   - `docs/database/seeds/07_enrollments_invoices_payments.sql`
   - `docs/database/seeds/08_attendance_assessments_leads.sql`
   - `docs/database/run_all_seeds.bat` & `docs/database/run_all_seeds.ps1`
   - `docs/database/DATABASE_SETUP_GUIDE.md`
