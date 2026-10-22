# MODULE SPEC: ACADEMIC & LEARNING SUBSYSTEM
**Module ID:** MOD-ACADEMIC | **Owner:** Member 01  
**Version:** 1.0.0 | **Inherits From:** `.sdd/constitution.md`  

---

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
