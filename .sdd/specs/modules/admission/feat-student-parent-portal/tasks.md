# Tasks: Cổng thông tin Học sinh và Phụ huynh (feat-student-parent-portal)

## Phase 1: DTOs & Data Contracts
- [x] Task 1.1: Tạo `ChildGuardianViewDTO.java` trong `com.educenter.dto` (id, fullName, code, gradeLevel, school, isPrimary, verified).
- [x] Task 1.2: Tạo `PortalScheduleItemDTO.java` trong `com.educenter.dto` (sessionId, classCode, className, subjectName, teacherName, roomName, sessionDate, startTime, endTime, status, notes).
- [x] Task 1.3: Tạo `PortalScoreItemDTO.java` trong `com.educenter.dto` (assessmentId, assessmentTitle, subjectName, classCode, assessmentDate, score, maxScore, weight, remark, isPassed).
- [x] Task 1.4: Tạo `PortalAttendanceSummaryDTO.java` trong `com.educenter.dto` (totalSessions, attendedSessions, lateSessions, excusedSessions, unexcusedSessions, attendanceRate).
- [x] Task 1.5: Tạo `StudentDashboardSummaryDTO.java` trong `com.educenter.dto` (studentId, studentName, studentCode, gradeLevel, enrolledClassCount, attendanceRate, recentScores, upcomingSessions).
- [x] Task 1.6: Tạo `ParentDashboardSummaryDTO.java` trong `com.educenter.dto` (guardianId, guardianName, children, selectedChildId, selectedChildSummary).

## Phase 2: Repository Layer
- [x] Task 2.1: Tạo `PortalRepository.java` trong `com.educenter.repository`:
  - `findStudentByUserId(em, userId)`
  - `findVerifiedChildrenByGuardianUserId(em, guardianUserId)`
  - `isGuardianOfStudent(em, guardianUserId, studentId)`
  - `findUpcomingSessionsByStudentId(em, studentId, limit)`
  - `findScheduleByStudentId(em, studentId, fromDate, toDate)`
  - `findPublishedScoresByStudentId(em, studentId)`
  - `getAttendanceStatsByStudentId(em, studentId)`
  - `findEnrolledClassesByStudentId(em, studentId)`

## Phase 3: Service Layer & Unit Tests
- [x] Task 3.1: Định nghĩa interface `PortalService.java` trong `com.educenter.service`.
- [x] Task 3.2: Triển khai `PortalServiceImpl.java` trong `com.educenter.service`:
  - `getStudentDashboard(Long userId)`
  - `getStudentSchedule(Long userId, LocalDate fromDate, LocalDate toDate)`
  - `getStudentProgress(Long userId)`
  - `getParentDashboard(Long guardianUserId, Long selectedChildId)`
  - `getChildDetail(Long guardianUserId, Long childStudentId)`
- [x] Task 3.3: Viết unit tests `PortalServiceTest.java` (JUnit 5) kiểm tra:
  - Sinh viên truy cập dashboard & lịch của mình.
  - Phụ huynh truy cập dashboard con hợp lệ.
  - Phụ huynh bị từ chối (ValidationException / SecurityException) khi truy cập học sinh không thuộc quyền giám hộ.
  - Trạng thái rỗng khi chưa có lớp hoặc chưa có điểm.

## Phase 4: Controllers & Filter RBAC
- [x] Task 4.1: Kiểm tra cấu hình RBAC trong `AuthFilter.java` đảm bảo sinh viên truy cập `/student/*` và phụ huynh truy cập `/parent/*`.
- [x] Task 4.2: Tạo `StudentPortalServlet.java` map `/student/dashboard`, `/student/schedule`, `/student/progress`.
- [x] Task 4.3: Tạo `ParentPortalServlet.java` map `/parent/dashboard`, `/parent/children/detail`.

## Phase 5: JSP Views (Chuẩn Design System design.md)
- [x] Task 5.1: Xây dựng `web/WEB-INF/views/student/dashboard.jsp` (STD-01).
- [x] Task 5.2: Xây dựng `web/WEB-INF/views/student/schedule.jsp` (STD-02).
- [x] Task 5.3: Xây dựng `web/WEB-INF/views/student/progress.jsp` (STD-03).
- [x] Task 5.4: Xây dựng `web/WEB-INF/views/parent/dashboard.jsp` (PAR-01) kèm Child Selector.
- [x] Task 5.5: Xây dựng `web/WEB-INF/views/parent/child-detail.jsp` (PAR-02).

## Phase 6: Verification, Spec Validation & Push to Main
- [x] Task 6.1: Chạy `scripts\verify.ps1` đảm bảo 100% tests pass và WAR build thành công.
- [x] Task 6.2: Chạy `validate_specs.py` đảm bảo cấu trúc spec đồng bộ.
- [x] Task 6.3: Commit và push lên nhánh `main`.

