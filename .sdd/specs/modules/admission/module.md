# MODULE SPEC: ADMISSION & STUDENT SUBSYSTEM
**Module ID:** MOD-ADMISSION | **Owner:** Member 02  
**Version:** 1.0.0 | **Inherits From:** `.sdd/constitution.md`  

---


## Baseline đặc tả đầy đủ — 2026-10-23

[Danh mục chung](../../README.md), [hợp đồng dữ liệu](../../data-contract.md), [tích hợp/quyền](../../integration.md), [screen-map chuẩn](../../screen-map.md) và [thứ tự code](../../implementation-order.md) áp dụng cho mọi feature bên dưới. Các tên Controller trong tài liệu module là hợp đồng logic đề xuất, cần đối chiếu code hiện hữu khi plan; không tạo Controller/route trùng. Danh sách này mô tả phạm vi, không chứng nhận đã implement.

| Feature | Spec | UC liên quan |
|---|---|---|
| feat-admission-crm | [Lead, tư vấn và kiểm tra đầu vào](feat-admission-crm/spec.md) | UC09, UC10 |
| feat-student-guardian | [Hồ sơ học viên, phụ huynh và xác thực giám hộ](feat-student-guardian/spec.md) | UC13, UC14 |
| feat-student-parent-portal | [Cổng học viên và phụ huynh với dữ liệu thật](feat-student-parent-portal/spec.md) | UC19, UC24, UC27 |
| feat-enrollment | [Ghi danh, chuyển lớp, bảo lưu và lịch sử học](feat-enrollment/SPEC.md) | UC17, UC18 |
| feat-notifications-qa | [Hỏi đáp kiểm duyệt và thông báo trong ứng dụng](feat-notifications-qa/spec.md) | UC28, UC29, UC30 |
| feat-course-catalog | [Website công khai, catalog và danh sách đăng ký](feat-course-catalog/spec.md) | UC06, UC07, UC08, UC09 |

Không tự định nghĩa lại công thức, trạng thái, quyền hoặc transaction khác hợp đồng chung. P1 được ghi rõ trong feature, không bỏ qua khi viết spec.

## 1. PHẠM VI NGHIỆP VỤ (SCOPE)
* **M01 – Public Website & Course Catalog:** Trang chủ (`/`), danh sách khóa học có tìm kiếm/lọc/sắp xếp/phân trang (`/courses`), chi tiết khóa học và khóa học liên quan (`/courses/detail`), giỏ đăng ký khóa học (`/registration-cart`), form gửi yêu cầu tư vấn (`/consultation`).
* **M03 – Admission & CRM:** Quản lý khách hàng tiềm năng (`Leads`), lịch sử tư vấn (`Consultations`), đặt lịch kiểm tra đầu vào (`TrialAssessments`), quản lý trạng thái (`NEW -> CONTACTED -> ASSESSED -> CONSULTING -> ENROLLED`, nhánh `LOST`).
* **M06 – Student & Guardian Management:** Hồ sơ học sinh (`Students`), phụ huynh (`Guardians`), liên kết giám hộ (`StudentGuardians`), lịch sử học tập.
* **M10 – Notifications & Q&A Community:** Diễn đàn hỏi đáp khóa học/lịch học (`Questions`, `Answers`), kiểm duyệt nội dung công khai, thông báo cá nhân (`Notifications`).
* **Ghi danh học viên (UC17):** Luồng chuyển đổi từ Lead sang Student, chọn lớp, kiểm tra sĩ số, tạo `Enrollment` và gọi sinh `Invoice`.

## 2. API & CONTROLLER CONTRACT
* `PublicHomeServlet` (`/`)
* `PublicCourseServlet` (`/courses`, `/courses/detail`)
* `RegistrationCartServlet` (`/registration-cart`)
* `ConsultationServlet` (`/consultation`, `/consultation/success`)
* `LeadServlet` (`/staff/leads`, `/staff/leads/detail`)
* `StudentServlet` (`/staff/students`, `/staff/students/detail`)
* `GuardianServlet` (`/staff/guardians`)
* `EnrollmentServlet` (`/staff/enrollments`, `/staff/enrollments/save`)
* `StudentPortalServlet` (`/student/dashboard`, `/student/schedule`, `/student/progress`)
* `ParentPortalServlet` (`/parent/dashboard`, `/parent/children/detail`)
* `QuestionServlet` (`/questions`, `/questions/detail`, `/staff/questions`)

## 3. DATABASE ENTITIES (JPA)
* `Leads`, `Consultations`, `TrialAssessments`, `Students`, `Guardians`, `StudentGuardians`, `Enrollments`, `RegistrationCartItems`, `Questions`, `Answers`, `Notifications`.

## 4. MODULE-LEVEL CONSTRAINTS
* Không được ghi danh trùng vào lớp học còn hiệu lực (BR03).
* Kiểm soát sĩ số nghiêm ngặt, không vượt capacity của lớp (BR04).
* Phụ huynh chỉ xem được dữ liệu của con đã được nhân viên xác nhận liên kết (BR15).
* Q&A hiển thị công khai phải có trạng thái đã duyệt (BR17).
