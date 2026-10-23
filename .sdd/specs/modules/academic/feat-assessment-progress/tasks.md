# Tasks: Quản lý Bài kiểm tra & Nhập điểm cho Giáo viên (feat-assessment-progress)

## Phase 1: DTOs & Repository Layer
- [x] Task 1.1: Tạo các DTOs: `AssessmentListItemDTO`, `AssessmentFormDTO`, `StudentScoreItemDTO`, `AssessmentGradeViewDTO`.
- [x] Task 1.2: Tạo `AssessmentRepository.java` trong `com.educenter.repository`.

## Phase 2: Service Layer & Business Rules
- [x] Task 2.1: Định nghĩa interface `AssessmentService.java` trong `com.educenter.service`.
- [x] Task 2.2: Triển khai `AssessmentServiceImpl.java` trong `com.educenter.service` (xử lý validation BR09, BR10, BR11, BR18, công bố và mở lại bài kiểm tra).

## Phase 3: Unit Testing
- [x] Task 3.1: Viết `AssessmentServiceTest.java` (JUnit 5) kiểm tra tạo bài, nhập điểm, chặn điểm vượt thang, công bố điểm.

## Phase 4: Controller & RBAC
- [x] Task 4.1: Tạo `TeacherAssessmentServlet.java` trong `com.educenter.controller` map `/teacher/assessments*`, `/teacher/scores*`.

## Phase 5: JSP Views (Chuẩn Design System design.md)
- [x] Task 5.1: Tạo `web/WEB-INF/views/teacher/assessment-list.jsp` (TCH-05).
- [x] Task 5.2: Tạo `web/WEB-INF/views/teacher/scores.jsp` (TCH-06).
- [x] Task 5.3: Cập nhật menu sidebar trong `sidebar.jspf` kích hoạt "Bài kiểm tra & Bảng điểm".

## Phase 6: Verification & Push to Main
- [x] Task 6.1: Chạy `scripts\verify.ps1` kiểm tra compile và 100% tests pass.
- [x] Task 6.2: Commit và push lên nhánh `main`.

