# Feature: Ghi Danh Học Viên Vào Lớp (Enrollment Management) — SPEC.md
**Status:** Approved  
**Version:** 1.0.0 | **Use Case ID:** UC17 | **Priority:** P0 (Core MVP)  
**Author:** Member 02 | **Reviewer:** Team EduCenter  
**Inherits From:**  
- Layer 1: `.sdd/constitution.md`  
- Layer 2: `.sdd/specs/modules/admission/module.md`  

---

## 1. Business Context & Goal
* **Mục tiêu:** Cho phép nhân viên tuyển sinh/học vụ (`Admission Staff`) ghi danh một học viên (`Student`) vào một lớp học cụ thể (`Class`), đồng thời tự động kích hoạt tạo hóa đơn học phí (`Invoice`) để đảm bảo quy trình tuyển sinh kết nối liền mạch sang tài chính.
* **Giá trị mang lại:** Tự động hóa quá trình ghi danh, loại bỏ tình trạng xếp lớp vượt sĩ số, ngăn ngừa ghi danh trùng lặp, đảm bảo tính nhất quán dữ liệu qua Transaction.

## 2. Actors & Permissions
* **Primary Actor:** `Academic / Admission Staff`, `Center Manager`, `System Admin`.
* **Access Rule:** Chỉ nhân viên đã đăng nhập và có quyền ghi danh mới được truy cập URL `/staff/enrollments`.

## 3. User Stories
* **Story 1 (Happy Path):** Là nhân viên tuyển sinh, tôi muốn chọn học viên và lớp học còn chỗ để ghi danh, để học viên có tên trong danh sách lớp và nhận lịch học.
* **Story 2 (Edge Case - Lớp đầy):** Là nhân viên tuyển sinh, khi tôi cố gắng ghi danh học viên vào lớp đã đủ sĩ số tối đa, tôi muốn hệ thống từ chối và hiển thị thông báo "Lớp học đã đủ sĩ số, vui lòng chọn lớp khác".

## 4. Acceptance Criteria (EARS Notation)
* **Ubiquitous (Luôn luôn):**  
  `THE SYSTEM SHALL thực hiện việc tạo Enrollment và Invoice trong cùng một JPA Transaction duy nhất.`
* **Event-Driven (Khi ghi danh thành công):**  
  `WHEN nhân viên gửi form ghi danh hợp lệ (chọn học viên hợp lệ, lớp học đang ACTIVE và còn chỗ), THE SYSTEM SHALL tạo bản ghi Enrollment mới với trạng thái ACTIVE, tạo Invoice học phí tương ứng, trừ đi sĩ số trống của lớp, và chuyển hướng (redirect) về trang chi tiết hóa đơn kèm thông báo thành công.`
* **Unwanted Behavior (Lớp đã đầy sĩ số - BR04):**  
  `IF số lượng học viên ACTIVE của lớp đã đạt bằng Classes.capacity, THEN THE SYSTEM SHALL hủy giao dịch (rollback), giữ nguyên dữ liệu form và trả về thông báo lỗi: "Lớp học đã đạt sĩ số tối đa".`
* **Unwanted Behavior (Ghi danh trùng - BR03):**  
  `IF học viên đã có bản ghi Enrollment ở trạng thái ACTIVE trong lớp học này, THEN THE SYSTEM SHALL từ chối ghi danh và trả về thông báo: "Học viên này đã ghi danh vào lớp trước đó".`
* **State-Driven (Lớp đã kết thúc - BR19):**  
  `WHILE trạng thái của lớp là CLOSED, THE SYSTEM SHALL vô hiệu hóa nút ghi danh và từ chối mọi yêu cầu ghi danh gửi lên.`

## 5. UI/UX Mapping
* **Screen ID:** `ADM-12` (Màn hình ghi danh học viên)
* **URL:**  
  * `GET /staff/enrollments`: Hiển thị form chọn học viên, chọn khóa học, chọn lớp còn chỗ.
  * `POST /staff/enrollments/save`: Xử lý submit ghi danh (Post/Redirect/Get pattern).
* **JSP View:** `/WEB-INF/views/staff/enrollment-form.jsp`

## 6. Technical & Database Implementation
* **Involved Entities:** `Enrollment`, `Class`, `Student`, `Invoice`, `InvoiceItem`, `Course`.
* **Repository Method:**  
  * `EnrollmentRepository.existsActiveEnrollment(studentId, classId)`
  * `ClassRepository.countActiveEnrollments(classId)`
* **Concurrency Control:** Sử dụng khóa đồng thời hoặc kiểm tra điều kiện sĩ số `active_count < capacity` ngay trong JPA Transaction để bảo vệ thao tác đồng thời khi 2 nhân viên ghi danh vào slot cuối cùng.

## 7. Definition of Done (DoD)
* [ ] Kiểm tra EARS compliance hoàn tất.
* [ ] Unit test cho logic kiểm tra sĩ số và trùng lặp pass 100%.
* [ ] JPA Transaction đảm bảo: nếu tạo Invoice lỗi thì Enrollment tự động rollback.
* [ ] Giao diện có validation phía client và server.
