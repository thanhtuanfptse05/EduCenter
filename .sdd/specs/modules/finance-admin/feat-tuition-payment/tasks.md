# Tasks: Quản lý Học phí, Thu tiền Hóa đơn & Biên lai (feat-tuition-payment)

## Phase 1: JPA Entity & Persistence Configuration
- [x] Task 1.1: Tạo entity `Payment.java` trong `com.educenter.entity` ánh xạ bảng `dbo.Payments`.
- [x] Task 1.2: Đăng ký `Payment` vào `src/java/META-INF/persistence.xml`.

## Phase 2: DTOs & Repository Layer
- [x] Task 2.1: Tạo các DTOs: `InvoiceViewDTO`, `InvoiceDetailDTO`, `PaymentRecordDTO`, `PaymentFormDTO`, `InvoicePageDTO`, `ReceiptViewDTO`.
- [x] Task 2.2: Tạo `PaymentRepository.java` trong `com.educenter.repository`.

## Phase 3: Service Layer & Business Rules
- [x] Task 3.1: Định nghĩa interface `PaymentService.java` trong `com.educenter.service`.
- [x] Task 3.2: Triển khai `PaymentServiceImpl.java` trong `com.educenter.service` (Duyệt tay CASH / BANK_TRANSFER, BR13, BR14).

## Phase 4: Unit Testing
- [x] Task 4.1: Viết `PaymentServiceTest.java` (JUnit 5) kiểm tra thu tiền một phần, thu đủ, chặn thu vượt nợ, chặn thanh toán hóa đơn đã hủy/đã trả đủ.

## Phase 5: Controller & RBAC Filter (ADM-14, ADM-15)
- [x] Task 5.1: Tạo `TuitionPaymentServlet.java` map `/staff/invoices*`.

## Phase 6: JSP Views (Chuẩn Design System design.md)
- [x] Task 6.1: Tạo `web/WEB-INF/views/staff/invoice-list.jsp` (ADM-14).
- [x] Task 6.2: Tạo `web/WEB-INF/views/staff/invoice-detail.jsp` (ADM-15).
- [x] Task 6.3: Tạo `web/WEB-INF/views/staff/receipt.jsp` (Biên lai in).
- [x] Task 6.4: Cập nhật `sidebar.jspf` kích hoạt menu "Hóa đơn học phí".

## Phase 7: Verification & Push to Main
- [x] Task 7.1: Chạy `scripts\verify.ps1` và `validate_specs.py`.
- [x] Task 7.2: Commit và push lên nhánh `main`.
