# Tasks: Ghi danh, Xếp lớp, Chuyển lớp & Bảo lưu (feat-enrollment)

## Phase 1: JPA Entities & Persistence Configuration
- [x] Task 1.1: Tạo entity `Invoice.java` trong `com.educenter.entity` ánh xạ bảng `dbo.Invoices` (invoiceCode, enrollment, student, totalAmount, discountAmount, finalAmount, status, dueDate, notes, version, createdAt, updatedAt).
- [x] Task 1.2: Tạo entity `InvoiceItem.java` trong `com.educenter.entity` ánh xạ bảng `dbo.InvoiceItems` (invoice, description, unitPrice, quantity, amount, createdAt).
- [x] Task 1.3: Đăng ký `Invoice` và `InvoiceItem` vào `src/java/META-INF/persistence.xml`.

## Phase 2: DTOs & Repository Layer
- [x] Task 2.1: Tạo `EnrollmentViewDTO.java` trong `com.educenter.dto` (enrollmentId, studentId, studentCode, studentName, studentPhone, classId, classCode, className, subjectName, courseFee, status, enrolledAt, startDate, endDate, invoiceId, invoiceCode, invoiceStatus, notes).
- [x] Task 2.2: Tạo `EnrollmentFormDTO.java` trong `com.educenter.dto` (studentId, classId, startDate, notes).
- [x] Task 2.3: Tạo `ClassEnrollmentOptionDTO.java` trong `com.educenter.dto` (classId, classCode, className, courseName, currentEnrolled, capacity, fee, startDate, endDate, status).
- [x] Task 2.4: Tạo `EnrollmentRepository.java` trong `com.educenter.repository`:
  - `findAll(em, classId, status, keyword, page, size)`
  - `countAll(em, classId, status, keyword)`
  - `findById(em, id)`
  - `findByStudentAndClass(em, studentId, classId)`
  - `countActiveByClassId(em, classId)`
  - `hasScheduleConflict(em, studentId, classId)`
  - `findClassOptions(em)`
  - `findActiveStudents(em)`
  - `save(em, enrollment)`
  - `saveInvoice(em, invoice, items)`

## Phase 3: Service Layer
- [x] Task 3.1: Định nghĩa interface `EnrollmentService.java` trong `com.educenter.service`.
- [x] Task 3.2: Triển khai `EnrollmentServiceImpl.java` trong `com.educenter.service`:
  - `getEnrollmentsPaged(...)`
  - `enrollStudent(studentId, classId, startDate, notes, actorId)` (BR02, BR03, BR04, BR07, BR12, FR-005)
  - `transferClass(enrollmentId, newClassId, transferDate, notes, actorId)` (UC18 P1)
  - `reserveEnrollment(enrollmentId, reason, actorId)` (UC18 P1)
  - `resumeEnrollment(enrollmentId, actorId)` (UC18 P1)
  - `updateEnrollmentStatus(enrollmentId, newStatus, reason, actorId)`
  - `getEnrollmentFormData()`

## Phase 4: Unit Testing
- [x] Task 4.1: Viết unit tests `EnrollmentServiceTest.java` (JUnit 5) kiểm tra:
  - Ghi danh thành công, sinh hóa đơn ban đầu đúng học phí khóa học.
  - Chặn ghi danh khi lớp đã đầy sĩ số (`capacity`).
  - Chặn ghi danh trùng lặp học sinh trong lớp (ACTIVE).
  - Chặn ghi danh lớp ở trạng thái không cho phép (`PLANNING`, `CLOSED`, `CANCELLED`).
  - Chuyển lớp hợp lệ và bảo lưu chuyển sang RESERVED.

## Phase 5: Controllers & Filter RBAC (ADM-12)
- [x] Task 5.1: Cập nhật `AuthFilter.java` đảm bảo vai trò `STAFF` và `ADMIN` được truy cập `/staff/enrollments*`.
- [x] Task 5.2: Tạo `EnrollmentServlet.java` trong `com.educenter.controller` xử lý GET danh sách và các action POST tuân thủ mô hình PRG.

## Phase 6: JSP Views (Chuẩn Design System design.md)
- [x] Task 6.1: Tạo `web/WEB-INF/views/staff/enrollment-list.jsp` (ADM-12) chuẩn Design System, 100% dữ liệu động từ backend, KPI cards, bộ lọc thông minh, bảng phân trang, modal ghi danh mới có xem trước sĩ số/học phí, modal chuyển lớp, modal bảo lưu.
- [x] Task 6.2: Cập nhật `sidebar.jspf` kích hoạt menu "Ghi danh & Xếp lớp" cho `STAFF` và `ADMIN`.

## Phase 7: Verification, Spec Validation & Push to Main
- [x] Task 7.1: Chạy `scripts\verify.ps1` đảm bảo 100% tests pass và WAR build thành công.
- [x] Task 7.2: Chạy `validate_specs.py` đảm bảo cấu trúc spec đồng bộ.
- [x] Task 7.3: Commit và push lên nhánh `main`.

## Phase 8: Lọc lớp theo khóa đăng ký, cảnh báo lịch/chỗ trống, bắt buộc nộp tiền & Admin routing (FR-013, FR-014, FR-015)
- [x] Task 8.1: Cập nhật `EnrollmentServlet.java` hỗ trợ urlPatterns `/admin/enrollments*` và thêm endpoint lấy danh sách khóa học đăng ký / lớp học khả dụng theo học sinh.
- [x] Task 8.2: Mở rộng `ClassEnrollmentOptionDTO` và `EnrollmentRepository` hỗ trợ `courseId`, kiểm tra sức chứa và xung đột lịch theo học sinh.
- [x] Task 8.3: Bổ sung xác nhận nộp tiền học phí (`paymentConfirmed`, `paymentMethod`, `transactionRef`) vào `EnrollmentFormDTO` và kiểm tra bắt buộc nộp tiền trong `EnrollmentServiceImpl.enrollStudent`, sinh `PAID` invoice và `Payment`.
- [x] Task 8.4: Nâng cấp `web/WEB-INF/views/staff/enrollment-list.jsp` hiển thị khóa học đăng ký của học sinh, lọc lớp tự động, cảnh báo khi không có lớp trống (kèm link tạo lớp `/admin/classes`), và giao diện thu tiền học phí bắt buộc.
- [x] Task 8.5: Cập nhật unit test `EnrollmentServiceTest.java` kiểm tra quy tắc bắt buộc nộp tiền và lọc lớp.

## Phase 9: Liên kết thanh toán từ Ghi danh và điều hướng quay lại sau thanh toán (FR-016)
- [x] Task 9.1: Bổ sung liên kết trực tiếp "Đến mục thanh toán" trong thẻ cảnh báo chưa nộp tiền trên modal ghi danh (`enrollment-list.jsp`), truyền động mã/tên học viên sang module Hóa đơn & Thu phí.
- [x] Task 9.2: Hỗ trợ tự động tick xác nhận nộp tiền (`paid=1`) và hiển thị thông báo đã nộp tiền (`#paidNotice`) khi quay lại từ luồng thanh toán.
- [x] Task 9.3: Bổ sung nút hành động "Quay lại Ghi danh & Xếp lớp" trên danh sách hóa đơn (`invoice-list.jsp`), chi tiết hóa đơn (`invoice-detail.jsp`) và phiếu thu (`receipt.jsp`).
- [x] Task 9.4: Cập nhật `TuitionPaymentServlet.java` và `EnrollmentServlet.java` duy trì ngữ cảnh `fromEnrollment`, `studentId`, `leadId`, `paid`.

## Phase 10: Khắc phục lỗi trang Chi tiết hóa đơn và Đồng bộ hóa trạng thái công nợ khi ghi danh (FR-017)
- [x] Task 10.1: Sửa lỗi EL PropertyNotFoundException trong `web/WEB-INF/views/staff/invoice-detail.jsp` (thay `invoice.student.id` bằng `invoice.studentId`).
- [x] Task 10.2: Truyền tham số ngữ cảnh `fromEnrollment`, `studentId`, `leadId` trong các liên kết "Chi tiết" tại `web/WEB-INF/views/staff/invoice-list.jsp`.
- [x] Task 10.3: Rà soát và hoàn thiện ràng buộc bắt buộc nộp tiền khi ghi danh và đồng bộ trạng thái công nợ (`EnrollmentServlet.java`, `EnrollmentServiceImpl.java`, `enrollment-list.jsp`).
- [x] Task 10.4: Chạy kiểm thử toàn bộ `ant verify` (166+ tests) và đồng bộ class vào Tomcat, sau đó commit và push lên nhánh `main`.

