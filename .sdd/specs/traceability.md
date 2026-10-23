# Truy vết đầy đủ SRS v1.1 → feature specs

**Baseline:** 2026-10-23. Đây là kiểm tra độ phủ đặc tả, **không phải kết quả kiểm thử ứng dụng**. Nguồn: [SRS v1.1](../../EduCenter_Tutoring_Exam_Preparation_SRS_v1.1.md). Mã FR luôn thuộc feature ở cùng link. Dữ liệu máy đọc: [catalog.json](catalog.json); chạy `python -X utf8 .sdd/scripts/validate_specs.py` từ root để kiểm lại.

## 1. Use cases: 35/35 (31 P0 + 4 P1)

| UC | Tên theo SRS | Ưu tiên giữ nguyên | Spec chủ sở hữu và yêu cầu |
|---|---|---|---|
| UC01 | Đăng ký tài khoản | P0 | [feat-auth-rbac FR-001](modules/finance-admin/feat-auth-rbac/spec.md) |
| UC02 | Đăng nhập, đăng xuất | P0 | [feat-auth-rbac FR-002, FR-003](modules/finance-admin/feat-auth-rbac/spec.md) |
| UC03 | Quên, đổi mật khẩu | P0 | [feat-auth-rbac FR-004, FR-005](modules/finance-admin/feat-auth-rbac/spec.md) |
| UC04 | Cập nhật hồ sơ | P0 | [feat-auth-rbac FR-005](modules/finance-admin/feat-auth-rbac/spec.md) |
| UC05 | Quản lý tài khoản, vai trò | P0 | [feat-auth-rbac FR-006, FR-007, FR-009](modules/finance-admin/feat-auth-rbac/spec.md) |
| UC06 | Xem, tìm kiếm, lọc khóa học | P0 | [feat-course-catalog FR-001, FR-002, FR-011, FR-012](modules/admission/feat-course-catalog/spec.md) |
| UC07 | Xem chi tiết và khóa học liên quan | P0 | [feat-course-catalog FR-003](modules/admission/feat-course-catalog/spec.md) |
| UC08 | Quản lý danh sách khóa học đăng ký | P0 | [feat-course-catalog FR-004, FR-005, FR-006, FR-007, FR-008, FR-009](modules/admission/feat-course-catalog/spec.md) |
| UC09 | Gửi yêu cầu tư vấn | P0 | [feat-course-catalog FR-010](modules/admission/feat-course-catalog/spec.md) |
| UC10 | Quản lý Lead và lịch sử tư vấn | P0 | [feat-admission-crm FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008, FR-009, FR-010](modules/admission/feat-admission-crm/spec.md) |
| UC11 | Quản lý môn học, khóa học | P0 | [feat-academic-programs FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008](modules/academic/feat-academic-programs/spec.md) |
| UC12 | Quản lý giáo viên | P0 | [feat-teacher-management FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008](modules/academic/feat-teacher-management/spec.md) |
| UC13 | Quản lý học viên, phụ huynh | P0 | [feat-student-guardian FR-001, FR-002, FR-003, FR-008, FR-009, FR-010](modules/admission/feat-student-guardian/spec.md) |
| UC14 | Liên kết phụ huynh – học viên | P0 | [feat-student-guardian FR-004, FR-005, FR-006, FR-007](modules/admission/feat-student-guardian/spec.md) |
| UC15 | Tạo, sửa, đóng lớp | P0 | [feat-class-timetable FR-001, FR-003, FR-009](modules/academic/feat-class-timetable/spec.md) |
| UC16 | Xếp lịch, kiểm tra xung đột | P0 | [feat-class-timetable FR-004, FR-005, FR-006, FR-007, FR-008, FR-011, FR-012](modules/academic/feat-class-timetable/spec.md) |
| UC17 | Ghi danh học viên | P0 | [feat-enrollment FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-012](modules/admission/feat-enrollment/SPEC.md) |
| UC18 | Chuyển lớp, bảo lưu | P1 | [feat-enrollment FR-007, FR-008, FR-009, FR-010, FR-011](modules/admission/feat-enrollment/SPEC.md) |
| UC19 | Xem lịch học | P0 | [feat-student-parent-portal FR-001, FR-002, FR-003, FR-008](modules/admission/feat-student-parent-portal/spec.md) |
| UC20 | Điểm danh | P0 | [feat-attendance-journal FR-001, FR-002, FR-003, FR-004, FR-005, FR-007, FR-008, FR-009](modules/academic/feat-attendance-journal/spec.md) |
| UC21 | Ghi nhật ký giảng dạy | P1 | [feat-attendance-journal FR-006, FR-008](modules/academic/feat-attendance-journal/spec.md) |
| UC22 | Tạo bài kiểm tra | P0 | [feat-assessment-progress FR-001, FR-002](modules/academic/feat-assessment-progress/spec.md) |
| UC23 | Nhập, công bố điểm | P0 | [feat-assessment-progress FR-003, FR-004, FR-005, FR-006, FR-007, FR-010](modules/academic/feat-assessment-progress/spec.md) |
| UC24 | Xem kết quả học tập | P0 | [feat-student-parent-portal FR-004, FR-005, FR-006](modules/admission/feat-student-parent-portal/spec.md) |
| UC25 | Tạo hóa đơn học phí | P0 | [feat-tuition-payment FR-001, FR-002, FR-003, FR-004, FR-009, FR-012](modules/finance-admin/feat-tuition-payment/spec.md) |
| UC26 | Ghi nhận thanh toán | P0 | [feat-tuition-payment FR-005, FR-006, FR-007, FR-010, FR-011, FR-015](modules/finance-admin/feat-tuition-payment/spec.md) |
| UC27 | Xem công nợ, lịch sử đóng tiền | P0 | [feat-tuition-payment FR-008, FR-013, FR-014](modules/finance-admin/feat-tuition-payment/spec.md) |
| UC28 | Tạo, nhận thông báo | P1 | [feat-notifications-qa FR-009, FR-010, FR-011, FR-012](modules/admission/feat-notifications-qa/spec.md) |
| UC29 | Gửi câu hỏi | P0 | [feat-notifications-qa FR-001, FR-002, FR-006](modules/admission/feat-notifications-qa/spec.md) |
| UC30 | Trả lời, kiểm duyệt Q&A | P0 | [feat-notifications-qa FR-003, FR-004, FR-005, FR-006, FR-007, FR-008](modules/admission/feat-notifications-qa/spec.md) |
| UC31 | Thống kê tuyển sinh | P0 | [feat-dashboard-reporting FR-001, FR-003, FR-005, FR-007, FR-008, FR-009](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| UC32 | Thống kê học phí | P0 | [feat-dashboard-reporting FR-001, FR-004, FR-005, FR-008, FR-009](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| UC33 | Thống kê chuyên cần, điểm | P0 | [feat-dashboard-reporting FR-002, FR-005, FR-006, FR-007, FR-008, FR-010](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| UC34 | Quản lý phòng học | P0 | [feat-class-timetable FR-002, FR-003](modules/academic/feat-class-timetable/spec.md) |
| UC35 | Xem nhật ký thao tác | P1 | [feat-system-administration FR-006, FR-007, FR-008](modules/finance-admin/feat-system-administration/spec.md) |

UC19 còn được class-timetable FR-010 và portal thực thi; UC24 do assessment-progress FR-006/008 cung cấp; UC33 do assessment-progress FR-009 và attendance-journal FR-007 cung cấp. UC05 và UC34 được system-administration điều hướng, không tạo bản CRUD trùng chủ sở hữu.

## 2. Mô tả 12 module: 55/55 ý nguồn

Gồm 53 ý nghiệp vụ/ràng buộc và 2 ví dụ minh họa; ví dụ là dữ liệu kiểm thử, không là chỉ tiêu bắt buộc hoặc nội dung hardcode. Ý M05 về chuyển/bảo lưu còn tham chiếu enrollment FR-007–011; ý M12 quản lý User/Room dùng auth FR-006/007/009 và class-timetable FR-002/003. Các tham chiếu bổ sung này tránh chỉ gắn nhãn module mà bỏ luồng thực tế.

| Ý SRS III | Nội dung nguồn | Spec/yêu cầu đích |
|---|---|---|
| M01.01 | Trang chủ: giới thiệu trung tâm, giáo viên, khóa học nổi bật/mới mở. | [feat-course-catalog FR-001, FR-011](modules/admission/feat-course-catalog/spec.md) |
| M01.02 | Danh sách khóa học theo môn Toán, Văn, Anh, Lý, Hóa…, khối 6–12 và mục tiêu thi. | [feat-course-catalog FR-002, FR-003](modules/admission/feat-course-catalog/spec.md) |
| M01.03 | Tìm kiếm từ khóa, lọc môn/khối/mức phí, sắp xếp, phân trang. | [feat-course-catalog FR-002](modules/admission/feat-course-catalog/spec.md) |
| M01.04 | Trang chi tiết: mục tiêu, nội dung, số buổi, lịch dự kiến, học phí, sĩ số. | [feat-course-catalog FR-003](modules/admission/feat-course-catalog/spec.md) |
| M01.05 | Gợi ý khóa học tương tự. | [feat-course-catalog FR-003](modules/admission/feat-course-catalog/spec.md) |
| M01.06 | Form đăng ký tư vấn, kiểm tra đầu vào. | [feat-course-catalog FR-010](modules/admission/feat-course-catalog/spec.md) |
| M01.07 | Danh sách chọn khóa học đăng ký: thêm, bỏ, cập nhật lựa chọn, tổng học phí dự kiến. | [feat-course-catalog FR-004, FR-005, FR-006, FR-007, FR-008, FR-009](modules/admission/feat-course-catalog/spec.md) |
| M02.01 | Đăng ký, đăng nhập, đăng xuất. | [feat-auth-rbac FR-001, FR-002, FR-003](modules/finance-admin/feat-auth-rbac/spec.md) |
| M02.02 | Quên/đặt lại mật khẩu, đổi mật khẩu, cập nhật hồ sơ. | [feat-auth-rbac FR-004, FR-005](modules/finance-admin/feat-auth-rbac/spec.md) |
| M02.03 | Quản lý vai trò, trạng thái khóa/mở tài khoản. | [feat-auth-rbac FR-006, FR-007, FR-009](modules/finance-admin/feat-auth-rbac/spec.md) |
| M02.04 | Một phụ huynh có thể liên kết nhiều học viên; một học viên có thể có nhiều người giám hộ. | [feat-student-guardian FR-004, FR-005, FR-006, FR-007](modules/admission/feat-student-guardian/spec.md) |
| M02.05 | Mật khẩu lưu dạng hash an toàn, kiểm tra phân quyền ở server. | [feat-auth-rbac FR-001, FR-003, FR-008, FR-010](modules/finance-admin/feat-auth-rbac/spec.md) |
| M03.01 | Tiếp nhận khách hàng tiềm năng (Lead) từ website/nhân viên. | [feat-admission-crm FR-001, FR-002](modules/admission/feat-admission-crm/spec.md) |
| M03.02 | Phân công tư vấn viên, nguồn tuyển sinh, lịch sử liên hệ. | [feat-admission-crm FR-003, FR-004](modules/admission/feat-admission-crm/spec.md) |
| M03.03 | Đặt lịch học thử hoặc kiểm tra đầu vào; ghi nhận kết quả. | [feat-admission-crm FR-006, FR-007](modules/admission/feat-admission-crm/spec.md) |
| M03.04 | Quản lý trạng thái `NEW → CONTACTED → ASSESSED → CONSULTING → ENROLLED`, nhánh `LOST`. | [feat-admission-crm FR-005](modules/admission/feat-admission-crm/spec.md) |
| M03.05 | Chuyển Lead thành hồ sơ học viên và ghi danh. | [feat-admission-crm FR-008](modules/admission/feat-admission-crm/spec.md) |
| M04.01 | CRUD môn học, chương trình, khóa học. | [feat-academic-programs FR-001, FR-002, FR-003, FR-005, FR-006](modules/academic/feat-academic-programs/spec.md) |
| M04.02 | Khối lớp, mục tiêu thi, trình độ, thời lượng, số buổi, học phí, mô tả, trạng thái tuyển sinh. | [feat-academic-programs FR-002, FR-004, FR-007, FR-008](modules/academic/feat-academic-programs/spec.md) |
| M04.03 (minh họa) | Ví dụ: Toán 12 – Ôn thi tốt nghiệp THPT; 24 buổi; 90 phút/buổi; tối đa 15 học viên. | [feat-academic-programs FR-002](modules/academic/feat-academic-programs/spec.md) |
| M05.01 | Tạo lớp, chọn khóa học, phân giáo viên chính, phòng, sĩ số tối đa. | [feat-class-timetable FR-001, FR-002, FR-003](modules/academic/feat-class-timetable/spec.md) |
| M05.02 | Tạo lịch định kỳ và sinh các buổi học cụ thể. | [feat-class-timetable FR-004](modules/academic/feat-class-timetable/spec.md) |
| M05.03 | Kiểm tra trùng giáo viên, phòng, lịch học viên. | [feat-class-timetable FR-005, FR-006, FR-011](modules/academic/feat-class-timetable/spec.md) |
| M05.04 | Đổi lịch, học bù, giáo viên dạy thay, chuyển lớp, bảo lưu, kết thúc lớp. | [feat-class-timetable FR-007, FR-008, FR-009, FR-012](modules/academic/feat-class-timetable/spec.md) |
| M05.05 | Hỗ trợ lớp nhóm và lớp 1-1. | [feat-class-timetable FR-001](modules/academic/feat-class-timetable/spec.md) |
| M06.01 | Hồ sơ học viên, trường học, khối lớp, mục tiêu điểm số, thông tin liên hệ. | [feat-student-guardian FR-001, FR-003](modules/admission/feat-student-guardian/spec.md) |
| M06.02 | Hồ sơ phụ huynh và xác thực quan hệ giám hộ. | [feat-student-guardian FR-002, FR-004, FR-005, FR-006, FR-007](modules/admission/feat-student-guardian/spec.md) |
| M06.03 | Lịch sử đăng ký, trạng thái học, bảo lưu, nghỉ học, chuyển lớp. | [feat-enrollment FR-007, FR-008, FR-009, FR-010, FR-011](modules/admission/feat-enrollment/SPEC.md) |
| M06.04 | Tra cứu tiến độ và thông tin học viên theo quyền. | [feat-student-parent-portal FR-001, FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-008, FR-009, FR-010](modules/admission/feat-student-parent-portal/spec.md) |
| M07.01 | Giáo viên mở buổi học được phân công và điểm danh. | [feat-attendance-journal FR-001, FR-003, FR-004, FR-005, FR-009](modules/academic/feat-attendance-journal/spec.md) |
| M07.02 | Trạng thái: `PRESENT`, `ABSENT_EXCUSED`, `ABSENT_UNEXCUSED`, `LATE`. | [feat-attendance-journal FR-002](modules/academic/feat-attendance-journal/spec.md) |
| M07.03 | Ghi nội dung giảng dạy, bài tập về nhà, nhận xét. | [feat-attendance-journal FR-006](modules/academic/feat-attendance-journal/spec.md) |
| M07.04 | Tỷ lệ chuyên cần theo học viên, lớp, giai đoạn. | [feat-attendance-journal FR-007, FR-008](modules/academic/feat-attendance-journal/spec.md) |
| M08.01 | Kiểm tra đầu vào, giữa khóa, cuối khóa và bài kiểm tra định kỳ. | [feat-assessment-progress FR-001](modules/academic/feat-assessment-progress/spec.md) |
| M08.02 | Tạo bài kiểm tra, thang điểm, nhập điểm, nhận xét, công bố kết quả. | [feat-assessment-progress FR-002, FR-003, FR-004, FR-005, FR-006, FR-007, FR-010](modules/academic/feat-assessment-progress/spec.md) |
| M08.03 | So sánh điểm đầu vào và điểm theo thời gian; biểu đồ tiến bộ. | [feat-assessment-progress FR-008, FR-009](modules/academic/feat-assessment-progress/spec.md) |
| M08.04 (minh họa) | Ví dụ: 5,5 → 7,0 → 8,0; tăng 2,5 điểm so với đầu vào. | [feat-assessment-progress FR-008](modules/academic/feat-assessment-progress/spec.md) |
| M09.01 | Học phí niêm yết, ưu đãi, hóa đơn, các khoản thu. | [feat-tuition-payment FR-001, FR-002, FR-003](modules/finance-admin/feat-tuition-payment/spec.md) |
| M09.02 | Ghi nhận thanh toán từng đợt, phương thức và chứng từ tham chiếu. | [feat-tuition-payment FR-005, FR-006, FR-007](modules/finance-admin/feat-tuition-payment/spec.md) |
| M09.03 | Theo dõi số đã thu, còn nợ, lịch sử thanh toán, biên lai nội bộ. | [feat-tuition-payment FR-004, FR-008, FR-013, FR-014, FR-015](modules/finance-admin/feat-tuition-payment/spec.md) |
| M09.04 | Không tích hợp cổng ngân hàng thật trong MVP. | [feat-tuition-payment FR-005](modules/finance-admin/feat-tuition-payment/spec.md) |
| M09.05 | Không xóa lịch sử giao dịch; điều chỉnh có nhật ký. | [feat-tuition-payment FR-009, FR-010, FR-011, FR-012](modules/finance-admin/feat-tuition-payment/spec.md) |
| M10.01 | Thông báo đổi lịch, nghỉ học, học phí đến hạn, kết quả học tập. | [feat-notifications-qa FR-009, FR-010, FR-011, FR-012](modules/admission/feat-notifications-qa/spec.md) |
| M10.02 | Học viên/phụ huynh đặt câu hỏi về khóa học hoặc lịch học. | [feat-notifications-qa FR-001, FR-002](modules/admission/feat-notifications-qa/spec.md) |
| M10.03 | Nhân viên/giáo viên/admin trả lời theo quyền. | [feat-notifications-qa FR-003](modules/admission/feat-notifications-qa/spec.md) |
| M10.04 | Kiểm duyệt nội dung trước khi hiển thị công khai; duyệt, từ chối, ẩn. | [feat-notifications-qa FR-004, FR-005, FR-006, FR-007, FR-008](modules/admission/feat-notifications-qa/spec.md) |
| M11.01 | Tổng học viên, học viên mới, lớp hoạt động, số buổi học. | [feat-dashboard-reporting FR-002](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| M11.02 | Tỷ lệ chuyển đổi tuyển sinh, tỷ lệ chuyên cần. | [feat-dashboard-reporting FR-003, FR-006](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| M11.03 | Doanh thu đã thu, số phải thu, công nợ. | [feat-dashboard-reporting FR-004](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| M11.04 | Điểm trung bình, lớp đông/ít nhất, khóa học có nhiều lượt đăng ký. | [feat-dashboard-reporting FR-006, FR-007](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| M11.05 | Báo cáo dùng đủ `MAX`, `MIN`, `AVG`, `SUM`, `COUNT`. | [feat-dashboard-reporting FR-005, FR-008, FR-009, FR-010](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| M12.01 | Quản lý người dùng, vai trò, danh mục, phòng học. | [feat-system-administration FR-009](modules/finance-admin/feat-system-administration/spec.md) |
| M12.02 | Cấu hình thông số học phí, giới hạn nghiệp vụ. | [feat-system-administration FR-001, FR-002, FR-004](modules/finance-admin/feat-system-administration/spec.md) |
| M12.03 | Audit Logs: ai thao tác, lúc nào, thay đổi gì. | [feat-system-administration FR-005, FR-006, FR-007, FR-008](modules/finance-admin/feat-system-administration/spec.md) |
| M12.04 | Khóa/mở tài khoản, quản lý trạng thái hệ thống. | [feat-system-administration FR-003, FR-010](modules/finance-admin/feat-system-administration/spec.md) |

## 3. Business rules: 20/20

Nội dung rule gốc ở [business.md](../constraints/business.md); công thức và trạng thái cụ thể hóa ở data-contract/decisions, không sửa ý nghĩa BR.

| Rule | Feature chịu trách nhiệm thực thi hoặc áp dụng |
|---|---|
| BR01 | [feat-student-guardian](modules/admission/feat-student-guardian/spec.md); [feat-auth-rbac](modules/finance-admin/feat-auth-rbac/spec.md) |
| BR02 | [feat-academic-programs](modules/academic/feat-academic-programs/spec.md); [feat-teacher-management](modules/academic/feat-teacher-management/spec.md); [feat-class-timetable](modules/academic/feat-class-timetable/spec.md); [feat-attendance-journal](modules/academic/feat-attendance-journal/spec.md); [feat-assessment-progress](modules/academic/feat-assessment-progress/spec.md); [feat-admission-crm](modules/admission/feat-admission-crm/spec.md); [feat-student-guardian](modules/admission/feat-student-guardian/spec.md); [feat-student-parent-portal](modules/admission/feat-student-parent-portal/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md); [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md); [feat-dashboard-reporting](modules/finance-admin/feat-dashboard-reporting/spec.md); [feat-system-administration](modules/finance-admin/feat-system-administration/spec.md); [feat-notifications-qa](modules/admission/feat-notifications-qa/spec.md); [feat-auth-rbac](modules/finance-admin/feat-auth-rbac/spec.md); [feat-course-catalog](modules/admission/feat-course-catalog/spec.md) |
| BR03 | [feat-admission-crm](modules/admission/feat-admission-crm/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md) |
| BR04 | [feat-class-timetable](modules/academic/feat-class-timetable/spec.md); [feat-admission-crm](modules/admission/feat-admission-crm/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md) |
| BR05 | [feat-teacher-management](modules/academic/feat-teacher-management/spec.md); [feat-class-timetable](modules/academic/feat-class-timetable/spec.md) |
| BR06 | [feat-class-timetable](modules/academic/feat-class-timetable/spec.md) |
| BR07 | [feat-class-timetable](modules/academic/feat-class-timetable/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md) |
| BR08 | [feat-attendance-journal](modules/academic/feat-attendance-journal/spec.md) |
| BR09 | [feat-teacher-management](modules/academic/feat-teacher-management/spec.md); [feat-assessment-progress](modules/academic/feat-assessment-progress/spec.md) |
| BR10 | [feat-assessment-progress](modules/academic/feat-assessment-progress/spec.md); [feat-admission-crm](modules/admission/feat-admission-crm/spec.md) |
| BR11 | [feat-assessment-progress](modules/academic/feat-assessment-progress/spec.md); [feat-student-parent-portal](modules/admission/feat-student-parent-portal/spec.md); [feat-dashboard-reporting](modules/finance-admin/feat-dashboard-reporting/spec.md); [feat-notifications-qa](modules/admission/feat-notifications-qa/spec.md) |
| BR12 | [feat-student-parent-portal](modules/admission/feat-student-parent-portal/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md); [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md); [feat-dashboard-reporting](modules/finance-admin/feat-dashboard-reporting/spec.md) |
| BR13 | [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md) |
| BR14 | [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md) |
| BR15 | [feat-attendance-journal](modules/academic/feat-attendance-journal/spec.md); [feat-assessment-progress](modules/academic/feat-assessment-progress/spec.md); [feat-student-guardian](modules/admission/feat-student-guardian/spec.md); [feat-student-parent-portal](modules/admission/feat-student-parent-portal/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md); [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md); [feat-dashboard-reporting](modules/finance-admin/feat-dashboard-reporting/spec.md); [feat-notifications-qa](modules/admission/feat-notifications-qa/spec.md); [feat-auth-rbac](modules/finance-admin/feat-auth-rbac/spec.md) |
| BR16 | [feat-academic-programs](modules/academic/feat-academic-programs/spec.md); [feat-teacher-management](modules/academic/feat-teacher-management/spec.md); [feat-class-timetable](modules/academic/feat-class-timetable/spec.md); [feat-attendance-journal](modules/academic/feat-attendance-journal/spec.md); [feat-admission-crm](modules/admission/feat-admission-crm/spec.md); [feat-student-guardian](modules/admission/feat-student-guardian/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md); [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md); [feat-system-administration](modules/finance-admin/feat-system-administration/spec.md); [feat-notifications-qa](modules/admission/feat-notifications-qa/spec.md); [feat-course-catalog](modules/admission/feat-course-catalog/spec.md) |
| BR17 | [feat-notifications-qa](modules/admission/feat-notifications-qa/spec.md) |
| BR18 | [feat-academic-programs](modules/academic/feat-academic-programs/spec.md); [feat-teacher-management](modules/academic/feat-teacher-management/spec.md); [feat-class-timetable](modules/academic/feat-class-timetable/spec.md); [feat-attendance-journal](modules/academic/feat-attendance-journal/spec.md); [feat-assessment-progress](modules/academic/feat-assessment-progress/spec.md); [feat-admission-crm](modules/admission/feat-admission-crm/spec.md); [feat-student-guardian](modules/admission/feat-student-guardian/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md); [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md); [feat-system-administration](modules/finance-admin/feat-system-administration/spec.md); [feat-notifications-qa](modules/admission/feat-notifications-qa/spec.md); [feat-auth-rbac](modules/finance-admin/feat-auth-rbac/spec.md) |
| BR19 | [feat-class-timetable](modules/academic/feat-class-timetable/spec.md); [feat-enrollment](modules/admission/feat-enrollment/SPEC.md) |
| BR20 | [feat-student-parent-portal](modules/admission/feat-student-parent-portal/spec.md); [feat-tuition-payment](modules/finance-admin/feat-tuition-payment/spec.md); [feat-dashboard-reporting](modules/finance-admin/feat-dashboard-reporting/spec.md) |

## 4. Dữ liệu và màn hình

- 30/30 bảng SRS có chủ sở hữu, quan hệ/bất biến/vòng đời ở [data-contract.md](data-contract.md). PasswordResetTokens hiện có và 6 bảng hỗ trợ đích được ghi riêng, không giả vờ DDL đã đủ.
- 49/49 Screen ID SRS có đúng một feature lõi sở hữu ở [screen-map.md](screen-map.md); 2 spec UI hỗ trợ không tạo màn hình hoặc controller trùng.
- 5/5 WF và 7/7 FLOW được mô tả ở integration/screen-map và bộ nghiệm thu sau đây.

## 5. Quy trình xuyên module và tiêu chí ASM

| Nguồn | Spec/điểm nghiệm thu |
|---|---|
| WF-01 Tuyển sinh/ghi danh | catalog → CRM → student-guardian → enrollment → finance; UAT-01/02; transaction và concurrency integration.md §3–5 |
| WF-02 Tổ chức buổi | class-timetable → attendance-journal → portal; UAT-03; journal P1 không chặn attendance P0 |
| WF-03 Kiểm tra | assessment-progress → portal/reporting; UAT-04; DRAFT không lộ qua bất kỳ kênh nào |
| WF-04 Thu học phí | tuition-payment → reporting/portal; UAT-05/06; ledger/số dư và idempotency |
| WF-05 Parent | auth → student-guardian → portal/finance/communication; UAT-07 |
| FLOW-01–07 | screen-map.md liệt kê đầy đủ từng bước; UAT-01/03/04/05/07/08 |
| ASM 3.1 (1,0) | UC01–05, auth-rbac; đầy đủ đăng ký/login/logout/reset/đổi password/profile/role |
| ASM 3.2 (2,0) | UC06/07/09, catalog/home dữ liệu SQL Server; nhóm/tìm/lọc/sort/page/detail/related |
| ASM 3.3 (2,0) | CRUD Subjects/Courses/Classes/Teachers/Students/Guardians/Rooms/Leads; soft delete dữ liệu có quan hệ |
| ASM 3.5 (1,0) | dashboard-reporting FR-005; đủ MAX/MIN/AVG/SUM/COUNT trên dữ liệu thực |
| ASM 3.6 (1,0) | catalog FR-004–009; thêm, cập nhật ghi chú/lựa chọn, xóa và tổng phí; quantity1 là tương đương đăng ký khóa |
| ASM 3.8 (2,0) | notifications-qa FR-001–008; hỏi/trả lời/duyệt/từ chối/ẩn/tìm/hiển thị |
| ASM 3.7 | Không đưa vào bảng đánh giá rút gọn theo SRS; không khẳng định bị xóa khỏi đề chấm chính thức |
| Phê duyệt đề tài | Cần bằng chứng giảng viên chấp thuận ý tưởng khác; chưa có bằng chứng trong đợt viết spec, không tự đánh dấu |

Tổng tiêu chí rút gọn 9,0 điểm, không phải thang điểm đầy đủ đề gốc.

## 6. Kiến trúc, chất lượng và bàn giao (SRS VIII–XIV)

| Nhóm yêu cầu | Nơi đặc tả và điều kiện xác minh |
|---|---|
| Java17/Tomcat10.1/Jakarta/JSP/JSTL/EL/JPA/SQL Server/Ant/JUnit5 | QG05, integration.md §1; build WAR và persistence integration, không JDBC nghiệp vụ |
| GET/POST/PRG, request attributes, JSP bảo vệ, validation | QG02/05/08/11; screen-map và module contracts |
| Design system, Light mặc định, SVG, responsive, accessibility | QG04; UI supporting specs; kiểm360/768/1024/1440px và keyboard |
| Dữ liệu thật/empty/error/không demo helpers | QG03/09/11; D04 xử lý ngoại lệ lịch sử, không chấp nhận production giả |
| BCrypt/quyền record/giám hộ/PII trẻ vị thành niên | auth + student-guardian; QG01/08; UAT-07/09 |
| Transaction/concurrency/audit/soft delete/tài chính chính xác | QG06/07/12; integration/data-contract; UAT-02/05/06/10 |
| Source, schema/migrations và dữ liệu demo DB riêng | Delivery gate acceptance.md; versioned migrations không chạy trong đợt spec |
| SRS/Use Case/ERD/sitemap/screen flow/architecture | SRS nguồn + data-contract + screen-map + integration; cập nhật ERD triển khai khi migration đích được làm |
| URL/Controller/Service/Repository mapping | screen-map, module.md, integration handoff; đối chiếu CodeGraph khi lập plan từng feature |
| Test cases/kết quả, cài đặt/chạy, demo end-to-end | acceptance.md và implementation-order.md; README/scripts hiện có là công cụ, không là bằng chứng các feature mới đã pass |
| Tài khoản/video demo | Chỉ môi trường kiểm thử và tài liệu bàn giao riêng, không đưa credential/helpers lên UI; quay luồng P0 sau khi thực sự hoàn tất |
| Rủi ro scope/tích hợp/trễ tiến độ | D01–D17, dependency gates trong implementation-order; P1 tách rõ, không biến giai đoạn2 thành MVP |

## 7. Phạm vi kết luận

Đã ánh xạ toàn bộ danh mục SRS nêu trên sang đặc tả có tiêu chí nghiệm thu. Công cụ kiểm tra xác nhận cấu trúc, độ phủ và tham chiếu; nó không tự chứng minh chất lượng ngữ nghĩa, chính sách đã được khách hàng duyệt hoặc code đã khớp spec. Kiểm tra ngữ nghĩa và các quyết định giả định được ghi tại [review.md](review.md).
