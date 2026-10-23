# Tasks: Lớp học, Phòng học và Lịch giảng dạy (feat-class-timetable)

## Phase 1: Entities, DTOs & Persistence
- [x] Task 1.1: Tạo entity `Room.java` trong `com.educenter.entity`.
- [x] Task 1.2: Bổ sung quan hệ `@ManyToOne Room room` vào `EduClass.java`.
- [x] Task 1.3: Tạo entity `ClassSession.java` trong `com.educenter.entity`.
- [x] Task 1.4: Đăng ký `Room` và `ClassSession` vào `src/java/META-INF/persistence.xml`.
- [x] Task 1.5: Tạo các DTOs trong `com.educenter.dto`: `ClassAdminViewDTO`, `ClassAdminStatsDTO`, `ClassFormDTO`, `ClassFilterDTO`, `ClassDetailDTO`, `ClassSessionDTO`, `ScheduleGeneratorDTO`, `RoomDTO`, `RoomFormDTO`, `TimetableGridDTO`.

## Phase 2: Repository Layer
- [x] Task 2.1: Tạo `RoomRepository.java` (CRUD, findAvailable, findByCode, count).
- [x] Task 2.2: Tạo `EduClassRepository.java` (findClasses phân trang & tìm kiếm, countClasses, getStats, findById, existsByCode).
- [x] Task 2.3: Tạo `ClassSessionRepository.java` (findSessionsByClass, checkTeacherConflict, checkRoomConflict, saveSessionsBatch, updateStatus).

## Phase 3: Service Layer & Unit Testing
- [x] Task 3.1: Định nghĩa interface `ClassTimetableService.java`.
- [x] Task 3.2: Triển khai `ClassTimetableServiceImpl.java`:
  - Nghiệp vụ tạo/sửa lớp học, kiểm tra điều kiện mở lớp BR04.
  - Thuật toán sinh lịch tự động định kỳ (FR-004), kiểm tra xung đột phòng và giáo viên (BR05, BR06).
  - Quản lý trạng thái lớp học (BR19).
  - Quản lý danh mục phòng học (FR-002).
  - Lấy ma trận thời khóa biểu tuần (FR-010).
- [x] Task 3.3: Viết unit tests `ClassTimetableServiceTest.java` (JUnit 5) kiểm thử các kịch bản xung đột phòng/giáo viên, capacity, và sinh lịch tự động.

## Phase 4: Controllers, Views & Navigation
- [x] Task 4.1: Cấu hình phân quyền trong `AuthFilter.java` cho các route `/admin/classes*`, `/admin/rooms*`, `/admin/timetable`, `/staff/classes*`, `/staff/timetable`.
- [x] Task 4.2: Tạo `ClassManagementServlet.java` (`/admin/classes*`).
- [x] Task 4.3: Tạo `RoomManagementServlet.java` (`/admin/rooms*`).
- [x] Task 4.4: Tạo `TimetableServlet.java` (`/admin/timetable`, `/staff/timetable`).
- [x] Task 4.5: Tạo `StaffClassInquiryServlet.java` (`/staff/classes*` view-only cho tư vấn tuyển sinh).
- [x] Task 4.6: Xây dựng các view JSP chuẩn `design.md`:
  - `web/WEB-INF/views/admin/class-list.jsp`
  - `web/WEB-INF/views/admin/class-form.jsp`
  - `web/WEB-INF/views/admin/class-detail.jsp`
  - `web/WEB-INF/views/admin/room-list.jsp`
  - `web/WEB-INF/views/admin/timetable.jsp`
  - `web/WEB-INF/views/staff/class-inquiry.jsp`
- [x] Task 4.7: Cập nhật menu sidebar trong `web/WEB-INF/views/common/sidebar.jspf` cho cả Admin và Staff.

## Phase 5: Verification & Push to Main
- [x] Task 5.1: Chạy toàn bộ unit tests và build script `verify.ps1`.
- [x] Task 5.2: Kiểm tra đồng bộ `build/web/`.
- [x] Task 5.3: Commit và push lên nhánh `main`.
