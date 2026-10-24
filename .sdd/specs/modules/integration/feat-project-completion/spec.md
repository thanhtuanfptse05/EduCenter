# Feature Specification: Hệ Thống Hoàn Thiện & Ổn Định Toàn Diện EduCenter (feat-project-completion)

**Feature Directory**: `.sdd/specs/modules/integration/feat-project-completion`  
**Created**: 2026-10-24  
**Status**: Ready / Locked  
**Input**: Khắc phục 13 lỗi nghiệp vụ (B01–B13), hoàn thiện giao diện chính sách & an toàn ký tự, đồng bộ CSS tokens, xây dựng Teacher Dashboard chuyên dụng, cô lập kiểm thử Unit Test và bổ sung bộ dữ liệu mẫu CSDL phân tách rõ ràng.

---

## 1. Mục tiêu & Bối cảnh

EduCenter đã hoàn thành phần lớn chức năng đọc và hiển thị, vượt qua các kiểm tra biên dịch Java 17, 52 JSP và hơn 30 kịch bản HTTP. Tuy nhiên, qua đợt rà soát nghiệp vụ sâu (Deep Audit), hệ thống còn tồn tại 13 khoảng trống nghiệp vụ trọng yếu (B01–B13), một số điểm chưa hoàn thiện trên giao diện (link điều khoản `#`, ký tự đặc biệt trong nút `onclick`, thiếu token CSS) và 5 test điểm danh thất bại khi cô lập do gọi CSDL thật.

Đặc tả này chuẩn hóa toàn bộ các giải pháp xử lý, tuân thủ nguyên tắc Spec-First, Design System (`design.md`) và Constitution của dự án EduCenter.

---

## 2. User Scenarios & Testing (Ưu tiên theo hành trình)

### User Story 1 - Kiểm Soát Điểm Số & Điểm Danh Chặt Chẽ (B01, B03, B12) (Priority: P1)
Giáo viên và Admin thực hiện nhập điểm, xóa điểm, điểm danh và công bố điểm cho lớp học. Hệ thống chỉ cho phép nhập điểm và điểm danh cho những học viên có ghi danh hợp lệ tại thời điểm diễn ra buổi học/kỳ thi. Khi xóa trắng ô điểm, hệ thống ghi nhận xóa điểm thay vì giữ nguyên điểm cũ. Khi mở lại điểm đã công bố, bắt buộc ghi nhận Audit Log nghiệp vụ.

**Independent Test**:
- Nhập điểm cho học sinh không thuộc lớp -> Bị chặn với lỗi `ValidationException`.
- Xóa điểm ô input thành rỗng rồi lưu -> Điểm cũ bị xóa trong CSDL, không còn hiển thị điểm cũ.
- Admin mở lại bài kiểm tra DRAFT -> Bản ghi `AuditLogs` được tạo với lý do rõ ràng.

**Acceptance Scenarios**:
1. **Given** Lớp học Math10 có 2 học viên, **When** gửi danh sách điểm chứa học viên ngoài lớp, **Then** hệ thống từ chối lưu và báo lỗi không hợp lệ.
2. **Given** Học viên có điểm 9.0 trong bài kiểm tra DRAFT, **When** giáo viên xóa trắng ô điểm và bấm Lưu nháp, **Then** bản ghi điểm của học viên bị xóa, trạng thái trở thành chưa chấm.
3. **Given** Bài kiểm tra đã PUBLISHED, **When** Admin chọn Mở lại chỉnh sửa và nhập lý do "Phúc khảo bài thi", **Then** trạng thái chuyển về DRAFT và hệ thống ghi lại nhật ký AuditLog gồm actorId, action `REOPEN_ASSESSMENT`, lý do phúc khảo.

---

### User Story 2 - Chuẩn Hóa Điểm Trung Bình & Tỷ Lệ Chuyên Cần Động (B02, B04, B05) (Priority: P1)
Học viên và phụ huynh theo dõi tiến độ học tập trên Portal; Ban giám đốc xem báo cáo trên Dashboard. Điểm trung bình được tính theo trọng số và thang điểm 10 chuẩn hóa (thay vì cộng thô điểm 8/10 và 80/100). Chuyên cần tính đúng các buổi đã diễn ra hợp lệ, tính PRESENT và LATE là có mặt, và giữ nguyên lịch sử điểm danh của học viên kể cả khi trạng thái ghi danh hiện tại đã chuyển sang RESERVED/TRANSFERRED.

**Independent Test**:
- Kiểm tra học viên có điểm 8/10 (trọng số 1) và 80/100 (trọng số 1) -> Điểm TB đạt 8.0/10 thay vì 44.0.
- Kiểm tra lớp chưa diễn ra buổi nào -> Hiển thị Empty State hoặc tỷ lệ N/A thay vì mặc định 100%.
- Kiểm tra danh sách điểm danh buổi cũ của học viên đã chuyển lớp -> Vẫn hiển thị đầy đủ thông tin điểm danh quá khứ.

**Acceptance Scenarios**:
1. **Given** Học sinh có điểm bài 15 phút là 8.0/10 (hệ số 10%) và bài 1 tiết là 80/100 (hệ số 20%), **When** tính điểm trung bình Portal, **Then** hệ thống chuẩn hóa 80/100 thành 8.0/10 và tính điểm TB là 8.0/10.
2. **Given** Học viên có điểm danh PRESENT ở buổi học tuần trước, sau đó bảo lưu (RESERVED) tuần này, **When** giáo viên mở lại buổi học tuần trước, **Then** học viên vẫn hiển thị trên danh sách điểm danh với trạng thái PRESENT.
3. **Given** Một lớp chưa có buổi học nào COMPLETED, **When** xem thống kê chuyên cần, **Then** hệ thống hiển thị "Chưa có dữ liệu" hoặc số buổi hợp lệ = 0, không tự động gán 100%.

---

### User Story 3 - Tính Đúng Công Nợ & Bảo Vệ Giao Dịch Tài Chính (B06, B11, B13) (Priority: P1)
Nhân viên thu học phí ghi nhận tiền mặt hoặc chuyển khoản. Hệ thống tính công nợ chính xác bằng `finalAmount - sum(confirmed payments)`. Khi thu tiền chuyển khoản, bắt buộc nhập mã tham chiếu và chống trùng giao dịch. Giao dịch thu tiền ghi nhận Audit Log. Hạn nộp hóa đơn đọc từ cấu hình hệ thống `TUITION_DUE_DAYS`.

**Independent Test**:
- Hóa đơn 3.000.000đ đã trả 1.000.000đ -> Báo cáo công nợ hiển thị đúng 2.000.000đ.
- Thu tiền bằng BANK_TRANSFER với mã giao dịch rỗng hoặc trùng lặp -> Báo lỗi `ValidationException`.
- Tạo hóa đơn mới khi cấu hình `TUITION_DUE_DAYS = 15` -> Hạn nộp là ngày hiện tại + 15 ngày.

**Acceptance Scenarios**:
1. **Given** Hóa đơn 3.000.000đ có 1 phiếu thu 1.000.000đ, **When** báo cáo doanh thu & công nợ chạy, **Then** dư nợ được ghi nhận là 2.000.000đ.
2. **Given** Nhân viên thu tiền chuyển khoản, **When** bỏ trống mã tham chiếu giao dịch hoặc nhập mã tham chiếu đã tồn tại, **Then** hệ thống chặn lại và yêu cầu mã giao dịch duy nhất.
3. **Given** Nhân viên bấm ghi nhận thu tiền thành công, **When** kiểm tra CSDL, **Then** có bản ghi AuditLog ghi lại thông tin thu tiền.

---

### User Story 4 - Siết Chặt Ghi Danh, Chuyển Lớp & Phân Quyền CRM (B07, B08, B10) (Priority: P1)
Nhân viên tuyển sinh quản lý Lead và ghi danh học sinh. Nhân viên chỉ xem và tư vấn các Lead được phân công cho mình (Admin xem toàn bộ). Trạng thái Lead chỉ chuyển sang ENROLLED khi đã tạo ghi danh thật. Ghi danh kiểm tra sĩ số đồng thời trong transaction. Phục hồi học tập từ RESERVED kiểm tra lại trùng lịch; Chuyển lớp không tự xung đột với lớp cũ sắp rời đi.

**Independent Test**:
- Nhân viên A mở Lead được phân công cho Nhân viên B -> Bị từ chối truy cập.
- Trực tiếp chuyển trạng thái Lead sang ENROLLED mà không qua ghi danh -> Bị chặn.
- Học sinh bảo lưu có lịch trùng với lớp khác, khi bấm Phục hồi -> Bị chặn vì xung đột lịch.
- Chuyển lớp sang lớp mới cùng giờ học với lớp cũ -> Được phép vì lớp cũ sẽ kết thúc.

**Acceptance Scenarios**:
1. **Given** Staff 1 đăng nhập, **When** truy cập danh sách Lead, **Then** chỉ thấy các Lead được phân công cho Staff 1 hoặc chưa phân công.
2. **Given** Học sinh đang ở trạng thái RESERVED, **When** Staff thực hiện phục hồi nhưng thời khóa biểu lớp bị trùng với một lớp khác học sinh đang học, **Then** hệ thống báo lỗi xung đột thời khóa biểu (BR07).
3. **Given** Lớp học còn 1 chỗ trống, **When** có 2 yêu cầu ghi danh đồng thời, **Then** chỉ 1 yêu cầu thành công, yêu cầu còn lại bị báo lớp đầy sĩ số.

---

### User Story 5 - Sinh Lịch Học & Kiểm Soát Sức Chứa Phòng Học (B09) (Priority: P2)
Giáo vụ tạo lịch định kỳ cho lớp học. Lịch học sinh ra chỉ được nằm trong kỳ học của lớp (`startDate` đến `endDate`), không được vượt quá `endDate`. Phòng học chọn để sinh lịch bắt buộc phải có sức chứa (`capacity`) lớn hơn hoặc bằng sĩ số tối đa của lớp học.

**Acceptance Scenarios**:
1. **Given** Lớp học có sĩ số 25 học viên, **When** sinh lịch chọn phòng học có sức chứa 15 chỗ, **Then** hệ thống báo lỗi phòng không đủ chỗ cho lớp.
2. **Given** Lớp kết thúc vào 31/12/2026, **When** sinh lịch định kỳ, **Then** không có buổi học nào được tạo sau ngày 31/12/2026.

---

### User Story 6 - Hoàn Thiện Giao Diện, Chính Sách & Teacher Dashboard (Priority: P2)
Cung cấp các trang chính sách pháp lý thực tế: Điều khoản dịch vụ (`/terms`), Chính sách bảo mật (`/privacy`), Quy định hoàn phí (`/refund-policy`), Hỗ trợ kỹ thuật (`/support`). Thay thế các handler inline `onclick` bằng thuộc tính an toàn `data-*` để ngăn chặn lỗi ký tự đặc biệt. Đồng bộ toàn bộ CSS tokens (`--info`, `--bg-alt`, `--radius-xs`). Cung cấp màn hình Teacher Dashboard chuyên dụng với dữ liệu thật.

---

### User Story 7 - Cô Lập Unit Test & Xây Dựng Bộ Dữ Liệu CSDL Mẫu Chuẩn (Priority: P1)
Tách rời phụ thuộc CSDL thật trong `AttendanceServiceImpl` bằng cách hỗ trợ `Supplier<EntityManager>` hoặc Mock Injection để 100% test chạy pass trong môi trường cô lập. Xây dựng bộ file SQL Seed phong phú, chia tách rõ ràng từ `01` đến `08` kèm tài liệu hướng dẫn và script thực thi một chạm.

---

## 3. Functional Requirements (FR)

- **FR-COMP-001**: `AssessmentServiceImpl.saveScores` MUST xác thực mọi học viên trong danh sách có Enrollment hợp lệ tại lớp học tương ứng.
- **FR-COMP-002**: `AssessmentServiceImpl.saveScores` MUST phân biệt giá trị rỗng/null để xóa bản ghi điểm số khi người dùng xóa điểm trong ô nhập liệu.
- **FR-COMP-003**: `PortalServiceImpl.buildStudentSummary` MUST chuẩn hóa điểm về thang điểm 10 (`score / maxScore * 10`) và tính trung bình theo trọng số `weight`.
- **FR-COMP-004**: `AttendanceRepository` và `ReportRepository` MUST tính tỷ lệ chuyên cần trên mẫu số các buổi học đã diễn ra (`COMPLETED`), coi `PRESENT` và `LATE` là có mặt, không mặc định 100% khi chưa có buổi học nào.
- **FR-COMP-005**: `AttendanceRepository.findRosterForSession` MUST lấy đầy đủ học viên đã tham gia buổi học lịch sử ngay cả khi trạng thái Enrollment hiện tại đã đổi thành `TRANSFERRED`, `RESERVED`, `DROPPED`.
- **FR-COMP-006**: `ReportRepository.getDashboardData` MUST tính công nợ chưa thanh toán bằng `SUM(finalAmount - paidAmount)` thay vì chỉ lấy tổng `finalAmount`.
- **FR-COMP-007**: `EnrollmentServiceImpl.enrollStudent` MUST thực hiện khóa kiểm tra sĩ số lớp học trong transaction, đồng thời kiểm tra Course `OPEN` và Student không ở trạng thái ngừng học.
- **FR-COMP-008**: `EnrollmentServiceImpl.resumeEnrollment` MUST kiểm tra lại xung đột thời khóa biểu (`hasScheduleConflict`) trước khi kích hoạt lại học viên.
- **FR-COMP-009**: `EnrollmentServiceImpl.transferClass` MUST loại trừ lớp học cũ đang rời đi khi kiểm tra xung đột thời khóa biểu với lớp mới, và kiểm tra chặn ghi danh trùng ở lớp đích.
- **FR-COMP-010**: `ClassTimetableServiceImpl.generateRecurringSessions` MUST giới hạn ngày sinh lịch không vượt quá `endDate` của lớp, và kiểm tra sức chứa phòng `room.getCapacity() >= eduClass.getCapacity()`.
- **FR-COMP-011**: `LeadServiceImpl` MUST giới hạn quyền xem và cập nhật Lead cho STAFF theo tài khoản được phân công (ADMIN được toàn quyền); cấm chuyển trạng thái sang `ENROLLED` nếu chưa có Enrollment tương ứng.
- **FR-COMP-012**: `PaymentServiceImpl.recordManualPayment` MUST kiểm tra và bắt buộc có mã tham chiếu duy nhất khi thanh toán bằng `BANK_TRANSFER`, ngăn chặn gửi lặp trùng giao dịch, và lưu bản ghi `AuditLog`.
- **FR-COMP-013**: `AssessmentServiceImpl.reopenAssessment` MUST ghi nhận bản ghi `AuditLog` với lý do mở lại bài kiểm tra theo BR18.
- **FR-COMP-014**: Hệ thống MUST đọc thời hạn nộp học phí từ setting `TUITION_DUE_DAYS` thay vì hardcode 10 ngày; và kiểm tra trạng thái tuyển sinh `SYSTEM_ADMISSIONS_OPEN` khi tiếp nhận tư vấn/ghi danh mới.
- **FR-COMP-015**: Hệ thống MUST cung cấp các route chính sách `/terms`, `/privacy`, `/refund-policy`, `/support` với nội dung hoàn chỉnh và liên kết footer/register chuẩn.
- **FR-COMP-016**: Giao diện JSP MUST loại bỏ việc nối chuỗi ký tự trực tiếp vào `onclick`, chuyển sang sử dụng `data-*` attributes và listener an toàn.
- **FR-COMP-017**: CSS Design Tokens MUST bổ sung đầy đủ `--info`, `--info-subtle`, `--info-border`, `--bg-alt`, `--radius-xs` cho cả Light Mode và Dark Mode.
- **FR-COMP-018**: Hệ thống MUST cung cấp `TeacherDashboardServlet` phục vụ màn hình `/teacher/dashboard` với dữ liệu lịch dạy, lớp học phụ trách và lối tắt nghiệp vụ.
- **FR-COMP-019**: `AttendanceServiceImpl` MUST hỗ trợ tiêm `EntityManager` / `Supplier<EntityManager>` để chạy 100% Unit Test trong môi trường cô lập không cần CSDL thật.
- **FR-COMP-020**: CSDL MUST có bộ script Seed Data chia tách theo thứ tự `01` - `08`, cung cấp dữ liệu dồi dào, chạy được ngay bằng SSMS hoặc script PowerShell/Batch.
- **FR-COMP-021**: `AssessmentRepository.findClassesByTeacher` MUST sử dụng `JOIN FETCH` để nạp sẵn `c.course cr`, `cr.subject`, và `c.room` nhằm triệt tiêu hoàn toàn lỗi `LazyInitializationException` khi giáo viên xem Dashboard giảng dạy ngoài phiên EntityManager.
- **FR-COMP-022**: Chuẩn hóa cấu trúc layout nội bộ trong `admin/dashboard.jsp`, `admin/reports.jsp`, `staff/lead-list.jsp`, `staff/lead-detail.jsp` sang cấu trúc chuẩn `<div class="admin-layout">`, `<div class="admin-main">`, `<main class="admin-content">` và định nghĩa fallback tokens/classes `.dashboard-container`, `.dashboard-main`, `.dashboard-content` trong `admin.css` để bảo đảm giao diện không bị lệch layout, xô đẩy thanh topbar hay tạo khoảng trắng bất thường.

---

## 4. Success Criteria

- **SC-001**: 149/149 Unit Test (bao gồm 5 test Attendance) chạy đạt 100% trong môi trường cô lập.
- **SC-002**: Tính toán điểm trung bình Portal cho điểm 8/10 và 80/100 cho kết quả chính xác 8.00 / 10.
- **SC-003**: Công nợ tính đúng theo số dư thực tế `finalAmount - paidAmount` trên toàn bộ báo cáo và dashboard.
- **SC-004**: 100% các nút thao tác trên JSP không bị lỗi JavaScript khi tên hoặc ghi chú chứa dấu nháy đơn, nháy kép hoặc ký tự đặc biệt.
- **SC-005**: 100% liên kết chính sách chân trang (`/terms`, `/privacy`, `/refund-policy`, `/support`) truy cập thành công, hiển thị giao diện chuẩn `design.md`.
- **SC-006**: Bộ script CSDL được chia tách rõ ràng, người mới có thể khởi tạo toàn bộ CSDL và dữ liệu kiểm thử chỉ với một lệnh.
- **SC-007**: Bàn làm việc giáo viên (`/teacher/dashboard`) tải thành công 100% cho mọi tài khoản giáo viên, không còn bị lỗi đóng kết nối / màn hình trắng.
- **SC-008**: Bảng điều khiển Admin (`/admin/dashboard`), Báo cáo (`/admin/reports`) và CRM Tuyển sinh (`/staff/leads`) hiển thị chuẩn xác layout flexbox, không bị chèn khoảng trắng hay tràn vỡ layout.
