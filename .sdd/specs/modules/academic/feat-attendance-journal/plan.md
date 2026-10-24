# Implementation Plan: Điểm danh và Nhật ký Giảng dạy (feat-attendance-journal)

## 1. Architecture & Design Approach
- Tuân thủ kiến trúc phân tầng MVC của dự án:
  - **Entity:** `ClassSession`, `Attendance`, `TeachingJournal`, `Enrollment`, `Student`, `EduClass`, `Teacher`, `User`.
  - **Repository:** `AttendanceRepository` xử lý truy vấn danh sách học viên trong lớp theo buổi học (roster), lưu/cập nhật điểm danh, tính thống kê tỷ lệ chuyên cần, lưu và truy vấn nhật ký buổi học.
  - **Service:** `AttendanceService` & `AttendanceServiceImpl` kiểm tra quyền của giáo viên thực dạy (`session.teacher`), ràng buộc buổi học (`SCHEDULED` -> `IN_PROGRESS` -> `COMPLETED`), lưu điểm danh nhiều học viên trong một transaction, khóa chỉnh sửa khi đã `COMPLETED` (chỉ ADMIN được hiệu chỉnh có lý do), lưu nhật ký buổi học.
  - **Controller:** `TeacherAttendanceServlet` xử lý TCH-03 (`/teacher/attendance`, `/teacher/attendance/save`, `/teacher/attendance/complete`) và TCH-04 (`/teacher/journal`, `/teacher/journal/save`).
  - **View:** `web/WEB-INF/views/teacher/attendance.jsp` (TCH-03) và `web/WEB-INF/views/teacher/journal.jsp` (TCH-04) tuân thủ Design System `design.md`, 100% dữ liệu động, Lucide SVG icons.

## 2. Business Rules & Integrity Constraints
1. **BR02 & BR08 (Roster & Giáo viên thực dạy):**
   - Roster điểm danh được lấy từ danh sách học viên có `Enrollment` `ACTIVE` tại thời điểm diễn ra buổi học.
   - Chỉ Giáo viên thực dạy được phân công trong `ClassSession.teacher` (hoặc ADMIN) mới có quyền mở sổ và ghi nhận điểm danh/nhật ký.
2. **BR08 (Trạng thái điểm danh hợp lệ):**
   - Chỉ chấp nhận 4 trạng thái: `PRESENT` (Có mặt), `LATE` (Đi muộn), `ABSENT_EXCUSED` (Nghỉ có phép), `ABSENT_UNEXCUSED` (Nghỉ không phép).
3. **WF-02 & FR-004, FR-005 (Vòng đời buổi học & Khóa sửa):**
   - Khi hoàn tất điểm danh (`COMPLETED`), buổi học chuyển trạng thái sang `COMPLETED`, khóa sửa đổi đối với Giáo viên.
   - Chỉ ADMIN mới có quyền hiệu chỉnh lại điểm danh của buổi `COMPLETED` kèm lý do giải trình.
4. **TCH-04 (Nhật ký giảng dạy & Bài tập):**
   - Mỗi buổi học có tối đa 1 bản ghi `TeachingJournal` lưu nội dung bài học, bài tập về nhà và nhận xét chung.

## 3. Implementation Phases
- **Phase 1: JPA Entity & Persistence Configuration**
  - Xây dựng Entity `TeachingJournal.java` (bảng `dbo.TeachingJournals`).
  - Đăng ký `TeachingJournal` vào `src/java/META-INF/persistence.xml`.
- **Phase 2: DTOs & Repository Layer**
  - Tạo `AttendanceRosterItemDTO.java` (studentId, studentCode, studentName, status, remarks).
  - Tạo `AttendanceSessionViewDTO.java` (sessionId, classCode, className, subjectName, teacherName, sessionDate, startTime, endTime, status, totalStudents, attendedCount, lateCount, excusedCount, unexcusedCount).
  - Tạo `TeachingJournalDTO.java` (sessionId, content, homework, teacherRemarks, updatedAt).
  - Xây dựng `AttendanceRepository.java`:
    - Tìm ca học theo ID kèm quyền giáo viên.
    - Lấy danh sách ca học giáo viên phụ trách.
    - Lấy danh sách học viên điểm danh của buổi học.
    - Lưu danh sách điểm danh hàng loạt nguyên tử.
    - Lưu/cập nhật nhật ký buổi học.
- **Phase 3: Service Layer & Business Rules**
  - Xây dựng `AttendanceService.java` và `AttendanceServiceImpl.java`.
  - Triển khai:
    - `getTeacherSessions(userId, date)`
    - `getSessionAttendance(sessionId, userId, isAdmin)`
    - `saveAttendance(sessionId, List<AttendanceRosterItemDTO>, userId, isAdmin)`
    - `completeSessionAttendance(sessionId, userId, isAdmin)`
    - `getTeachingJournal(sessionId, userId, isAdmin)`
    - `saveTeachingJournal(TeachingJournalDTO, userId, isAdmin)`
- **Phase 4: Unit Testing**
  - Viết `AttendanceServiceTest.java` (JUnit 5) kiểm tra:
    - Giáo viên điểm danh buổi học hợp lệ.
    - Chặn giáo viên khác sửa điểm danh buổi dạy thay.
    - Chặn sửa buổi học khi đã `COMPLETED`.
    - Tính toán tỷ lệ chuyên cần chính xác.
- **Phase 5: Controller & RBAC Filter (TCH-03, TCH-04)**
  - Cập nhật cấu hình và xây dựng `TeacherAttendanceServlet.java` map `/teacher/attendance*` và `/teacher/journal*`.
- **Phase 6: JSP Views (Chuẩn Design System design.md)**
  - Xây dựng `web/WEB-INF/views/teacher/attendance.jsp` (TCH-03).
  - Xây dựng `web/WEB-INF/views/teacher/journal.jsp` (TCH-04).
  - Bổ sung menu điều hướng cho TEACHER trong `sidebar.jspf`.
- **Phase 7: Verification & Push to Main**
  - Chạy `verify.ps1`, `validate_specs.py`, commit và push lên `main`.
- **Phase 8: Teacher Attendance Bug Fixes & Robustness**
  - Khắc phục `setAllAttendance` trong `attendance.jsp`: Loại bỏ xung đột JSP EL `${status}` bằng phép nối chuỗi JavaScript an toàn; đồng bộ visual label classes và metrics.
  - Tích hợp luồng Chốt hoàn tất ca học nguyên tử: Gửi kèm dữ liệu điểm danh từ form chính với cờ `completeAfterSave=true`, xử lý lưu điểm danh trước rồi chuyển `COMPLETED` trong cùng một request.
  - Sắp xếp DOM hợp lệ: Đặt input hidden `studentIds` vào trong thẻ `<td>` của hàng học viên, tránh lỗi foster-parenting của trình duyệt.
  - Cập nhật ràng buộc CSDL: Đảm bảo bảng `ClassSessions` hỗ trợ đầy đủ trạng thái `IN_PROGRESS` trong check constraint `CK_ClassSessions_Status`, tránh rollback transaction khi lưu điểm danh.
  - Kiểm soát giao dịch Backend: Khử trùng lặp studentId trước khi persist, fallback `actor` an toàn để không vi phạm NOT NULL trên `recorded_by`.
