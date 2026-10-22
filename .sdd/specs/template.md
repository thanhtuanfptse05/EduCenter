# Feature: [FEATURE_NAME] — SPECIFICATION
**Status:** Draft | Review | Approved | Locked  
**Version:** 1.0.0 | **Author:** [NAME] | **Reviewer:** [NAME] | **Date:** [YYYY-MM-DD]  
**Inherits From:**  
- Layer 1: `.sdd/constitution.md`  
- Layer 2: `.sdd/specs/modules/[MODULE_NAME]/module.md`  

---

## 1. Business Context & Goal
* **Why:** [Giải thích tại sao tính năng này cần tồn tại và mang lại giá trị gì cho trung tâm/học viên/phụ huynh]
* **Impact:** [Ảnh hưởng tới các quy trình nào: Tuyển sinh, Đào tạo hay Tài chính]

## 2. User Personas & Roles
* **Primary Actor:** [Guest / Student / Parent / Teacher / Staff / Manager / Admin]
* **Secondary Actors:** [Người liên quan gián tiếp]

## 3. User Stories
* **Story 1 (Happy Path):** Là một [vai trò], tôi muốn [hành động] để [lợi ích].
* **Story 2 (Edge / Error Path):** Là một [vai trò], khi [điều kiện lỗi], tôi muốn nhận [thông báo rõ ràng].

## 4. Acceptance Criteria (EARS Notation)
* **Ubiquitous (Luôn luôn):**  
  `THE SYSTEM SHALL [hành vi bắt buộc].`
* **Event-Driven (Khi có sự kiện):**  
  `WHEN [người dùng bấm nút/gửi form với dữ liệu hợp lệ], THE SYSTEM SHALL [xử lý logic] AND [chuyển trang/trả về kết quả].`
* **State-Driven (Khi ở trạng thái):**  
  `WHILE [lớp học đang đầy sĩ số / hóa đơn đã thanh toán xong], THE SYSTEM SHALL [ngăn thao tác và hiển thị trạng thái].`
* **Unwanted Behavior (Xử lý lỗi / ngoại lệ):**  
  `IF [dữ liệu không hợp lệ / trùng lịch / không đủ quyền], THEN THE SYSTEM SHALL [thông báo lỗi chi tiết mà không crash ứng dụng].`
* **Optional Feature (Tùy chọn):**  
  `WHERE [có áp dụng mã giảm giá], THE SYSTEM SHALL [tính lại tổng học phí tự động].`

## 5. UI/UX & Navigation Mapping
* **Screen ID:** [vd: ADM-12, PUB-02]
* **URL:** `[GET/POST] /path`
* **Controller:** `[Name]Servlet`
* **JSP View:** `/WEB-INF/views/[portal]/[name].jsp`
* **Components / Form Fields:** [Các trường nhập liệu, nút bấm, validation client-side]

## 6. Data Model & JPA Entity Changes
* **Entities involved:** [Liệt kê các entity và quan hệ liên quan]
* **JPA Query / Method:** [Ví dụ: `findAvailableClasses(subjectId, gradeLevel)`]
* **Transaction Requirements:** [Yêu cầu transaction `REQUIRED`, concurrency lock]

## 7. Business Constraints & Edge Cases
* **Constraints liên quan:** [Tham chiếu BR01 - BR20 từ `.sdd/constraints/business.md`]
* **Edge Cases:** [Xung đột đồng thời, mạng đứt giữa chừng, tài khoản bị khóa]

## 8. Definition of Done (DoD)
* [ ] Đã viết JPA Repository method với JPQL chuẩn (KHÔNG JDBC thuần).
* [ ] Đã viết Service xử lý transaction và business rules.
* [ ] Đã viết Servlet Controller theo PRG pattern.
* [ ] Đã tạo JSP View hiển thị đúng bằng JSTL/EL trong `WEB-INF/views/`.
* [ ] Đã viết Unit Test cho Service và kiểm thử thủ công qua Servlet Filter.
