# Implementation Plan: Ghi danh, Xếp lớp, Chuyển lớp & Bảo lưu (feat-enrollment)

## 1. Architecture & Design Approach
- Tuân thủ kiến trúc phân tầng chuẩn Jakarta EE & JPA:
  - **Entity:** `Enrollment`, `Invoice`, `InvoiceItem`, `Student`, `EduClass`, `Course`, `User`.
  - **Repository:** `EnrollmentRepository` phụ trách các truy vấn thống kê sĩ số, kiểm tra trùng lặp (BR03), xung đột lịch học (BR07), phân trang danh sách ghi danh và lưu trữ hóa đơn liên kết.
  - **Service:** `EnrollmentService` & `EnrollmentServiceImpl` xử lý nghiệp vụ ghi danh nguyên tử (Enrollment + Invoice ban đầu trong 1 giao dịch), kiểm tra sức chứa lớp (BR04), chuyển lớp (UC18 P1), bảo lưu và quay lại học (UC18 P1).
  - **Controller:** `EnrollmentServlet` điều hướng tại `/staff/enrollments` (ADM-12) cùng các action POST `/staff/enrollments/save`, `/staff/enrollments/transfer`, `/staff/enrollments/reserve`, `/staff/enrollments/resume`, `/staff/enrollments/status`.
  - **View:** `web/WEB-INF/views/staff/enrollment-list.jsp` chuẩn Design System `design.md`, 100% dữ liệu động từ backend, hỗ trợ bộ lọc, bảng danh sách phân trang, modal ghi danh mới có hiển thị sĩ số/học phí real-time, modal chuyển lớp và bảo lưu.

## 2. Business Rules & Integrity Constraints
1. **BR02 & BR19 (Trạng thái lớp & ngày bắt đầu):**
   - Chỉ được ghi danh vào lớp có trạng thái `OPEN` hoặc `ONGOING`. Chặn tuyệt đối lớp `PLANNING`, `CLOSED`, `CANCELLED`.
   - Ngày bắt đầu ghi danh phải nằm trong khoảng thời gian diễn ra lớp học (`class.startDate` -> `class.endDate`).
2. **BR03 (Chặn ghi danh trùng lặp):**
   - Không cho phép một học sinh có nhiều hơn 1 Enrollment ở trạng thái `ACTIVE` hoặc `RESERVED` trong cùng một lớp học.
3. **BR04 (Kiểm soát sĩ số tối đa `capacity`):**
   - Sĩ số học viên `ACTIVE` hiện tại + 1 không được vượt quá `class.capacity`.
4. **BR07 (Kiểm tra xung đột lịch học):**
   - Rà soát các buổi học tương lai của lớp ghi danh với các lớp mà học sinh đang theo học (`ACTIVE`). Nếu có buổi học trùng ngày và thời gian, cảnh báo/chặn để đảm bảo quyền lợi học tập của học viên.
5. **BR12 & FR-005 (Hóa đơn học phí ban đầu đồng bộ):**
   - Khi commit ghi danh mới thành công, hệ thống tự động sinh 1 hóa đơn `Invoice` ở trạng thái `UNPAID` với số tiền bằng học phí niêm yết của khóa học (`course.fee`), kèm `InvoiceItem` chi tiết trong cùng một `EntityTransaction`. Nếu phát sinh lỗi ở bất kỳ bước nào, rollback toàn bộ.

## 3. Implementation Phases
- **Phase 1: JPA Entities & Persistence Configuration**
  - Xây dựng Entity `Invoice.java` (bảng `dbo.Invoices`).
  - Xây dựng Entity `InvoiceItem.java` (bảng `dbo.InvoiceItems`).
  - Đăng ký `Invoice` và `InvoiceItem` vào `persistence.xml`.
- **Phase 2: DTOs & Repository Layer**
  - Tạo các DTOs phục vụ hiển thị và form submit:
    - `EnrollmentViewDTO`: Thông tin hiển thị dòng ghi danh (mã học viên, tên học viên, lớp, khóa, học phí, trạng thái, mã hóa đơn, ngày ghi danh).
    - `EnrollmentFormDTO`: Dữ liệu submit form ghi danh mới.
    - `ClassEnrollmentOptionDTO`: Thông tin lớp học cho dropdown (mã lớp, tên lớp, sĩ số hiện tại/tối đa, học phí, ngày khai giảng).
  - Xây dựng `EnrollmentRepository.java`:
    - Đếm sĩ số active của lớp.
    - Kiểm tra enrollment tồn tại.
    - Kiểm tra xung đột lịch học buổi học.
    - Lấy danh sách ghi danh phân trang & bộ lọc.
    - Lưu enrollment và invoice trong giao dịch JPA.
- **Phase 3: Service Layer & Business Rules Implementation**
  - Xây dựng `EnrollmentService.java` và `EnrollmentServiceImpl.java`.
  - Triển khai đầy đủ các hàm:
    - `getEnrollmentsPaged(...)`: Tìm kiếm, lọc theo lớp/trạng thái/keyword, phân trang.
    - `enrollStudent(...)`: Kiểm tra BR02, BR03, BR04, BR07, tạo Enrollment + Invoice ban đầu nguyên tử.
    - `transferClass(...)`: Chuyển lớp học cho học viên (lớp cũ TRANSFERRED, lớp mới ACTIVE).
    - `reserveEnrollment(...)`: Bảo lưu học tập (chuyển RESERVED, giải phóng chỗ).
    - `resumeEnrollment(...)`: Quay lại học (kiểm tra sĩ số lớp trước khi phục hồi ACTIVE).
    - `updateEnrollmentStatus(...)`: Cập nhật trạng thái thôi học (DROPPED) hoặc hoàn thành (COMPLETED).
- **Phase 4: Unit Testing**
  - Viết `EnrollmentServiceTest.java` (JUnit 5) kiểm tra toàn diện:
    - Ghi danh thành công và sinh hóa đơn ban đầu.
    - Chặn ghi danh lớp đã đầy sĩ số (BR04).
    - Chặn ghi danh trùng học viên trong lớp (BR03).
    - Chặn ghi danh lớp đã đóng/hủy.
    - Chuyển lớp và bảo lưu hoạt động đúng.
- **Phase 5: Controller & Filter RBAC (ADM-12)**
  - Cập nhật `AuthFilter.java` đảm bảo vai trò `STAFF` và `ADMIN` có quyền truy cập `/staff/enrollments*`.
  - Xây dựng `EnrollmentServlet.java` xử lý GET danh sách và POST các hành động (save, transfer, reserve, resume, status) tuân thủ mô hình PRG.
- **Phase 6: JSP View (Chuẩn Design System design.md)**
  - Xây dựng `web/WEB-INF/views/staff/enrollment-list.jsp`.
  - Cập nhật `sidebar.jspf` kích hoạt menu "Ghi danh & Xếp lớp" cho STAFF và ADMIN.
- **Phase 7: Verification, Spec Validation & Push to Main**
  - Chạy `verify.ps1` kiểm tra tất cả tests và build WAR.
  - Chạy `validate_specs.py` kiểm tra tính toàn vẹn tài liệu spec.
  - Commit và push lên nhánh `main`.
