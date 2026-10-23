# Implementation Plan: Cổng thông tin Học sinh và Phụ huynh (feat-student-parent-portal)

## 1. Architecture & Design Approach
- Tuân thủ tuyệt đối mô hình chuẩn MVC của dự án:
  - **Entity:** `Student`, `Guardian`, `StudentGuardian`, `EduClass`, `ClassSession`, `Attendance`, `Assessment`, `AssessmentScore`, `Invoice`.
  - **Repository:** `StudentRepository`, `GuardianRepository`, `ClassSessionRepository`, `PortalRepository` (hoặc truy vấn trực tiếp JPA Criteria/JPQL bảo mật cách ly theo chủ thể).
  - **Service:** `PortalService` & `PortalServiceImpl` xử lý trọn vẹn nghiệp vụ (STD-01, STD-02, STD-03, PAR-01, PAR-02), kiểm tra ủy quyền nghiêm ngặt (STUDENT chỉ xem dữ liệu của chính mình, PARENT chỉ xem dữ liệu của con có liên kết `verifiedAt IS NOT NULL`).
  - **Controller (Servlets):**
    - `StudentPortalServlet` (`/student/dashboard`, `/student/schedule`, `/student/progress`).
    - `ParentPortalServlet` (`/parent/dashboard`, `/parent/children/detail`).
  - **View:** 5 màn hình JSP chuẩn `design.md`, 100% dữ liệu động từ backend, Lucide SVG outline icons, tokens CSS, Empty State chuyên nghiệp, Light mode mặc định.

## 2. Security & Data Isolation Principles
1. **Student Isolation:**
   - Học sinh chỉ được xem dữ liệu gắn với hồ sơ `Student` có `s.user.id = currentUser.userId`.
   - Nếu chưa có hồ sơ học sinh liên kết, hiển thị Empty State hướng dẫn liên hệ học vụ, không sinh dữ liệu giả.
2. **Parent Isolation & Strict Child Validation:**
   - Phụ huynh chỉ được xem dữ liệu của con cái có bản ghi `StudentGuardian` hợp lệ (`verifiedAt IS NOT NULL`).
   - Mọi truy vấn chi tiết (`/parent/children/detail?id=X` hoặc `/parent/dashboard?childId=X`) đều phải tái kiểm tra quan hệ giám hộ trong CSDL tại thời điểm xử lý request. Nếu phát hiện `childId` không thuộc quyền giám hộ, lập tức trả về lỗi từ chối truy cập (403/Forbidden) và xóa mọi cache/lựa chọn cũ.
3. **Data Filtering Rules:**
   - Điểm số: Chỉ hiển thị bài kiểm tra có trạng thái `PUBLISHED` (BR11), tuyệt đối không lộ bài kiểm tra nháp (`DRAFT`).
   - Lịch học: Chỉ hiển thị lịch học của các lớp học viên đang tham gia (`status = 'STUDYING'` / `'ENROLLED'`).
   - Không được phép hardcode mock rows hay thẻ KPI tĩnh trên giao diện.

## 3. Phases & Milestones
- **Phase 1: DTOs & Data Contracts**
  - Tạo các DTOs trong `com.educenter.dto`:
    - `StudentDashboardSummaryDTO`: Tóm tắt thông tin học sinh, số lớp đang học, chuyên cần %, điểm TB, lịch học sắp tới.
    - `ParentDashboardSummaryDTO`: Danh sách con đã xác minh, con đang được chọn, tóm tắt tình hình học tập của con.
    - `PortalScheduleItemDTO`: Chi tiết một ca học (ngày, giờ bắt đầu/kết thúc, phòng học, giáo viên, môn, trạng thái buổi học).
    - `PortalScoreItemDTO`: Chi tiết bài kiểm tra đã công bố (tên bài, môn, ngày kiểm tra, điểm số, điểm tối đa, nhận xét của giáo viên).
    - `PortalAttendanceSummaryDTO`: Tổng hợp số buổi có mặt, muộn, vắng có phép, vắng không phép và tỷ lệ % chuyên cần.
    - `ChildGuardianViewDTO`: Thông tin rút gọn của con phục vụ bộ chọn con (Child Selector).
- **Phase 2: Repository & Data Queries**
  - Xây dựng `PortalRepository.java`:
    - `findStudentByUserId(em, userId)`: Tìm học sinh liên kết với User.
    - `findVerifiedChildrenByGuardianUserId(em, guardianUserId)`: Danh sách con có xác minh.
    - `isGuardianOfStudent(em, guardianUserId, studentId)`: Kiểm tra quyền giám hộ hợp lệ tại thời điểm hiện tại.
    - `findUpcomingSessionsByStudentId(em, studentId, limit)`: Lấy các ca học sắp tới của học sinh.
    - `findScheduleByStudentId(em, studentId, fromDate, toDate)`: Lấy thời khóa biểu theo khoảng thời gian.
    - `findPublishedScoresByStudentId(em, studentId)`: Lấy các điểm số kiểm tra đã công bố.
    - `getAttendanceStatsByStudentId(em, studentId)`: Tính toán số liệu chuyên cần.
    - `findEnrolledClassesByStudentId(em, studentId)`: Lấy danh sách các lớp học viên đang tham gia.
- **Phase 3: Service Layer & Unit Tests**
  - Định nghĩa interface `PortalService.java` và triển khai `PortalServiceImpl.java`.
  - Viết unit tests `PortalServiceTest.java` (JUnit 5) kiểm tra tính đúng đắn và an toàn:
    - Học sinh xem dashboard của chính mình.
    - Phụ huynh xem dashboard của con đã verified.
    - Phụ huynh bị chặn khi truy cập ID học sinh không phải con mình hoặc chưa verified.
    - Xử lý mượt mà khi học sinh chưa có lớp hoặc chưa có điểm.
- **Phase 4: Controllers (Servlets) & Filter RBAC**
  - Cấu hình phân quyền trong `AuthFilter.java`:
    - Role `STUDENT` được truy cập `/student/*`.
    - Role `PARENT` được truy cập `/parent/*`.
  - Triển khai `StudentPortalServlet.java`:
    - GET `/student/dashboard` (STD-01).
    - GET `/student/schedule` (STD-02).
    - GET `/student/progress` (STD-03).
  - Triển khai `ParentPortalServlet.java`:
    - GET `/parent/dashboard` (PAR-01).
    - GET `/parent/children/detail` (PAR-02).
- **Phase 5: JSP Views (Tuân thủ Design System design.md)**
  - Xây dựng layout shell cho Student và Parent có navigation sidebar và header đồng bộ.
  - `web/WEB-INF/views/student/dashboard.jsp` (STD-01): Dashboard học sinh với thẻ KPI, lịch học tuần, thông báo.
  - `web/WEB-INF/views/student/schedule.jsp` (STD-02): Lịch học & thời khóa biểu trực quan.
  - `web/WEB-INF/views/student/progress.jsp` (STD-03): Bảng điểm và thống kê chuyên cần.
  - `web/WEB-INF/views/parent/dashboard.jsp` (PAR-01): Dashboard phụ huynh với Child Selector linh hoạt.
  - `web/WEB-INF/views/parent/child-detail.jsp` (PAR-02): Hồ sơ chi tiết học tập của con.
- **Phase 6: Verification, Spec Validation & Push to Main**
  - Chạy `verify.ps1`, pass 100% unit tests.
  - Chạy `validate_specs.py`, pass 100% specs.
  - Commit và push lên nhánh `main`.
