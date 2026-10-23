# MODULE SPEC: ACADEMIC & LEARNING SUBSYSTEM
**Module ID:** MOD-ACADEMIC | **Owner:** Member 01  
**Version:** 1.0.0 | **Inherits From:** `.sdd/constitution.md`  

---


## Baseline đặc tả đầy đủ — 2026-10-23

[Danh mục chung](../../README.md), [hợp đồng dữ liệu](../../data-contract.md), [tích hợp/quyền](../../integration.md), [screen-map chuẩn](../../screen-map.md) và [thứ tự code](../../implementation-order.md) áp dụng cho mọi feature bên dưới. Các tên Controller trong tài liệu module là hợp đồng logic đề xuất, cần đối chiếu code hiện hữu khi plan; không tạo Controller/route trùng. Danh sách này mô tả phạm vi, không chứng nhận đã implement.

| Feature | Spec | UC liên quan |
|---|---|---|
| feat-academic-programs | [Quản lý môn học và chương trình/khóa học](feat-academic-programs/spec.md) | UC11 |
| feat-teacher-management | [Hồ sơ giáo viên và quyền phân công](feat-teacher-management/spec.md) | UC12 |
| feat-class-timetable | [Lớp học, phòng học và lịch giảng dạy](feat-class-timetable/spec.md) | UC15, UC16, UC19, UC34 |
| feat-attendance-journal | [Điểm danh và nhật ký giảng dạy](feat-attendance-journal/spec.md) | UC20, UC21 |
| feat-assessment-progress | [Bài kiểm tra, công bố điểm và tiến bộ](feat-assessment-progress/spec.md) | UC22, UC23, UC24, UC33 |

Không tự định nghĩa lại công thức, trạng thái, quyền hoặc transaction khác hợp đồng chung. P1 được ghi rõ trong feature, không bỏ qua khi viết spec.

## 1. PHẠM VI NGHIỆP VỤ (SCOPE)
* **M04 – Academic Programs & Courses:** Quản lý môn học (`Subjects`), khóa học (`Courses`), phân cấp khối 6-12, định mức học phí, số buổi học.
* **M05 – Class & Timetable Management:** Tạo và quản lý lớp học (`Classes`), xếp giáo viên chính, phân bổ phòng (`Rooms`), sinh lịch định kỳ thành các buổi học (`ClassSessions`). Kiểm tra xung đột lịch:
  `newStart < existingEnd AND newEnd > existingStart` (BR05, BR06).
* **M07 – Attendance & Teaching Journal:** Giáo viên mở buổi học, điểm danh 4 trạng thái (`PRESENT`, `ABSENT_EXCUSED`, `ABSENT_UNEXCUSED`, `LATE`), ghi nhật ký giảng dạy và bài tập về nhà (`TeachingJournals`).
* **M08 – Assessment & Learning Progress:** Tạo bài kiểm tra (`Assessments`), thang điểm, nhập điểm (`AssessmentScores`), công bố kết quả, tính toán tiến bộ theo thời gian.

## 2. API & CONTROLLER CONTRACT
* `CourseServlet` (`/staff/courses`, `/staff/courses/form`, `/staff/courses/save`)
* `ClassServlet` (`/staff/classes`, `/staff/classes/detail`, `/staff/classes/form`, `/staff/classes/save`)
* `TimetableServlet` (`/staff/timetable`)
* `AttendanceServlet` (`/teacher/attendance`)
* `JournalServlet` (`/teacher/journal`)
* `AssessmentServlet` (`/teacher/assessments`, `/teacher/scores`)

## 3. DATABASE ENTITIES (JPA)
* `Subjects`, `Courses`, `Classes`, `Rooms`, `ClassSessions`, `Teachers`, `Attendances`, `TeachingJournals`, `Assessments`, `AssessmentScores`.

## 4. MODULE-LEVEL CONSTRAINTS
* Không cho phép tạo buổi học có giáo viên hoặc phòng trùng giờ (BR05, BR06).
* Không cho phép nhập điểm ngoài thang điểm hợp lệ (BR10).
* Điểm chưa công bố (`status != 'PUBLISHED'`) thì cổng Student và Parent không được thấy (BR11).
