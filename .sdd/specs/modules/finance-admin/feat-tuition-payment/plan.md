# Implementation Plan: Quản lý Học phí, Thu tiền Hóa đơn & Biên lai (feat-tuition-payment)

## 1. Architecture & Design Approach
- Tuân thủ kiến trúc phân tầng MVC của dự án:
  - **Entity:** `Invoice`, `InvoiceItem`, `Payment`, `Enrollment`, `Student`, `EduClass`, `User`.
  - **Repository:** `PaymentRepository` truy vấn danh sách hóa đơn phân trang, tính tổng tiền đã thu, dư nợ còn lại, lưu phiếu thu `Payment`, truy vấn biên lai thu tiền theo `paymentId`.
  - **Service:** `PaymentService` & `PaymentServiceImpl` xử lý quy tắc nghiệp vụ:
    * Tính toán công nợ: `debt = invoice.finalAmount - totalPaid`.
    * Thu tiền duyệt tay thủ công (CASH / BANK_TRANSFER): Kiểm tra `amount > 0 && amount <= debt`, tạo `Payment` `CONFIRMED`, cập nhật trạng thái hóa đơn (`PARTIALLY_PAID` hoặc `PAID`) trong một `EntityTransaction`.
    * Khóa bất biến: Không xóa vật lý hóa đơn và phiếu thu đã xác nhận (BR16).
    * Hỗ trợ in biên lai thu tiền chuẩn mẫu nội bộ.
  - **Controller:** `TuitionPaymentServlet` xử lý ADM-14 (`/staff/invoices`), ADM-15 (`/staff/invoices/detail`, `/staff/invoices/payment`, `/staff/invoices/receipt`).
  - **View:** 
    * `web/WEB-INF/views/staff/invoice-list.jsp` (ADM-14).
    * `web/WEB-INF/views/staff/invoice-detail.jsp` (ADM-15) kèm modal ghi nhận thu tiền thủ công.
    * `web/WEB-INF/views/staff/receipt.jsp` (Biên lai thu tiền có layout in ấn).
    * Tuân thủ Design System `design.md`, 100% dữ liệu động từ backend, Lucide SVG icons.

## 2. Business Rules & Integrity Constraints
1. **BR12 & BR20 (Nghĩa vụ học phí và công nợ):**
   - Hóa đơn phản ánh nghĩa vụ học phí trọn khóa (`finalAmount`).
   - Tổng đã thu = tổng các khoản `Payment` có trạng thái `CONFIRMED`.
   - Dư nợ = `finalAmount - totalPaid`. Quá hạn khi `dueDate < today` và `dư nợ > 0`.
2. **BR13 & BR14 (Duyệt tay thu tiền & Chống thu thừa):**
   - Tuyệt đối không tích hợp cổng tự động; nhân viên/kế toán/admin kiểm tra tiền mặt hoặc sao kê ngân hàng rồi nhập duyệt tay.
   - Phương thức chỉ chấp nhận `CASH` hoặc `BANK_TRANSFER`.
   - Số tiền thu đợt này `amount` phải > 0 và không được vượt quá số dư nợ còn lại (`amount <= debt`).
   - Mã phiếu thu `paymentCode` sinh duy nhất theo định dạng `PAY-YYYYMMDD-XXXXX`.
3. **BR16 (Bất biến tài chính):**
   - Không được hard delete bản ghi `Invoices` hoặc `Payments`.

## 3. Implementation Phases
- **Phase 1: JPA Entity & Persistence Configuration**
  - Xây dựng Entity `Payment.java` (bảng `dbo.Payments`).
  - Đăng ký `Payment` vào `src/java/META-INF/persistence.xml`.
- **Phase 2: DTOs & Repository Layer**
  - Tạo `InvoiceViewDTO.java`, `InvoiceDetailDTO.java`, `PaymentRecordDTO.java`, `PaymentFormDTO.java`, `InvoicePageDTO.java`.
  - Xây dựng `PaymentRepository.java`:
    - Tìm kiếm hóa đơn phân trang, lọc theo học viên/lớp/trạng thái.
    - Tìm chi tiết hóa đơn kèm items và lịch sử payments.
    - Tính tổng đã thu của hóa đơn.
    - Lưu phiếu thu và cập nhật trạng thái hóa đơn trong giao dịch JPA.
- **Phase 3: Service Layer & Business Rules**
  - Xây dựng `PaymentService.java` và `PaymentServiceImpl.java`.
  - Triển khai:
    - `getInvoicesPaged(...)`
    - `getInvoiceDetail(invoiceId)`
    - `recordManualPayment(PaymentFormDTO, actorUserId)`
    - `getPaymentReceipt(paymentId)`
- **Phase 4: Unit Testing**
  - Viết `PaymentServiceTest.java` (JUnit 5) kiểm tra:
    - Thu một phần tiền -> trạng thái `PARTIALLY_PAID`.
    - Thu đủ tiền -> trạng thái `PAID`.
    - Chặn thu vượt quá số dư nợ còn lại.
    - Chặn thu tiền khi hóa đơn đã `PAID` hoặc `CANCELLED`.
- **Phase 5: Controller & RBAC Filter (ADM-14, ADM-15)**
  - Xây dựng `TuitionPaymentServlet.java` map `/staff/invoices*`.
- **Phase 6: JSP Views (Chuẩn Design System design.md)**
  - Xây dựng `web/WEB-INF/views/staff/invoice-list.jsp` (ADM-14).
  - Xây dựng `web/WEB-INF/views/staff/invoice-detail.jsp` (ADM-15).
  - Xây dựng `web/WEB-INF/views/staff/receipt.jsp` (Biên lai in).
  - Cập nhật `sidebar.jspf` kích hoạt menu "Hóa đơn & Học phí" cho Staff/Admin.
- **Phase 7: Verification & Push to Main**
  - Chạy `verify.ps1`, `validate_specs.py`, commit và push lên `main`.
