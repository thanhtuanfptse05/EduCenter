# Implementation Plan: Quản lý Bài kiểm tra & Nhập điểm cho Giáo viên (feat-assessment-progress)

## 1. Mục tiêu & Phạm vi (TCH-05, TCH-06)
- **TCH-05 (Bài kiểm tra):** Giáo viên xem danh sách các bài kiểm tra của các lớp mình phụ trách, tạo bài kiểm tra mới (loại kiểm tra: 15_MIN, 1_PERIOD, MID_TERM, FINAL, ENTRANCE, TRIAL; thang điểm max_score, trọng số weight, ngày thi test_date).
- **TCH-06 (Bảng nhập & Công bố điểm):** Giáo viên mở bảng danh sách học sinh trong lớp để nhập điểm (0 ≤ score ≤ max_score) và lời nhận xét. Hỗ trợ lưu nháp (DRAFT) và bấm "Công bố điểm" (PUBLISHED) để học sinh/phụ huynh xem được trên Portal.
- **Ràng buộc nghiệp vụ:**
  - BR09: 0 ≤ score ≤ max_score, thang điểm và trọng số > 0.
  - BR10: Mỗi học viên chỉ có tối đa 1 điểm cho 1 bài kiểm tra.
  - BR11: Điểm DRAFT không được hiển thị cho học sinh và phụ huynh. Chỉ bài kiểm tra có ít nhất 1 điểm hợp lệ mới được công bố (PUBLISHED).
  - BR18: Giáo viên chỉ được tạo và chấm điểm cho các lớp mình được phân công giảng dạy (hoặc Admin có toàn quyền).

## 2. Thiết kế tầng DTOs & Entity
- Entities có sẵn: `Assessment`, `AssessmentScore` (đã đăng ký trong `persistence.xml`).
- DTOs:
  - `AssessmentListItemDTO`: hiển thị bảng danh sách bài kiểm tra kèm thống kê sĩ số đã chấm, điểm TB.
  - `AssessmentFormDTO`: form tạo bài kiểm tra.
  - `StudentScoreItemDTO`: dòng điểm và nhận xét của từng học sinh.
  - `AssessmentGradeViewDTO`: dữ liệu nạp cho màn hình nhập điểm TCH-06.
  - `GradeSubmissionDTO`: dữ liệu submit lưu điểm hoặc công bố.

## 3. Thiết kế Repository & Service
- `AssessmentRepository`:
  - `findAssessments(EntityManager em, Long teacherUserId, Long classId, String status)`
  - `findAssessmentById(EntityManager em, Long id)`
  - `findScoresByAssessmentId(EntityManager em, Long assessmentId)`
  - `findRosterByClassId(EntityManager em, Long classId)`
  - `saveAssessment(EntityManager em, Assessment a)`
  - `updateAssessment(EntityManager em, Assessment a)`
  - `saveOrUpdateScore(EntityManager em, AssessmentScore s)`
- `AssessmentService` & `AssessmentServiceImpl`:
  - `getAssessments(Long teacherUserId, Long classId, String status)`
  - `createAssessment(AssessmentFormDTO form, Long teacherUserId)`
  - `getGradeView(Long assessmentId, Long teacherUserId)`
  - `saveScores(Long assessmentId, List<StudentScoreItemDTO> scores, Long teacherUserId)`
  - `publishAssessment(Long assessmentId, Long teacherUserId)`
  - `reopenAssessment(Long assessmentId, Long actorUserId, String reason)`
  - `getTeacherClasses(Long teacherUserId)`

## 4. Giao diện (JSP Views - Chuẩn design.md)
- `web/WEB-INF/views/teacher/assessment-list.jsp` (TCH-05):
  - Bộ lọc theo lớp học và trạng thái (Tất cả, Bản nháp DRAFT, Đã công bố PUBLISHED).
  - Modal tạo bài kiểm tra mới (tiêu đề, loại bài kiểm tra, thang điểm, hệ số, ngày kiểm tra).
  - Bảng danh sách bài kiểm tra, badge trạng thái, tiến độ chấm điểm, nút "Nhập điểm" / "Xem bảng điểm".
- `web/WEB-INF/views/teacher/scores.jsp` (TCH-06):
  - Thẻ thông tin bài kiểm tra: Tên bài, lớp, ngày kiểm tra, thang điểm tối đa, trọng số.
  - Bảng học sinh trong lớp: Mã HV, Tên, Số điện thoại, Ô nhập điểm (validate 0 <= score <= maxScore), Ô nhập nhận xét.
  - Nút "Lưu bảng điểm (DRAFT)" và Nút "Công bố điểm cho học viên (PUBLISH)".
  - Cảnh báo khi bài đã PUBLISHED: chỉ Admin mới có quyền mở lại để sửa điểm (BR18).
