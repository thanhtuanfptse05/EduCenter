# Feature Specification: Lớp học, phòng học và lịch giảng dạy

**Feature:** `feat-class-timetable` | **Module SRS:** M05, M12 | **Owner:** Member 01
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M05/M12, WF-02, V UC15/16/19/34, VIII ADM-10/11/13, TCH-01/02; **Use cases:** UC15, UC16, UC19, UC34.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Một lịch nguồn cho giáo viên, phòng và học viên giúp tránh trùng và đồng bộ thay đổi tới mọi portal.

**Trong phạm vi:** CRUD lớp/phòng, GROUP/ONE_TO_ONE, sinh lịch định kỳ, đổi lịch/học bù/dạy thay, đóng/hủy lớp, lịch tuần theo người liên quan.

**Ngoài phạm vi:** Nhiều cơ sở, online, tự tối ưu lịch, chuyển/bảo lưu (enrollment sở hữu), ngoại lệ trùng giáo viên/phòng.

**Actors & Permissions:** 
- ADMIN: Toàn quyền quản trị danh mục Phòng học, tạo và quản lý Lớp học, xếp lịch học, tự động sinh các buổi học, đổi lịch/hủy lịch/đóng lớp.
- STAFF (Tư vấn tuyển sinh): Chỉ có quyền xem/tra cứu danh sách lớp học, chi tiết lớp học, sĩ số còn trống và thời khóa biểu để tư vấn tuyển sinh và xếp lớp cho học viên.
- TEACHER: Đọc lịch dạy, danh sách lớp và buổi học được phân công.
- STUDENT / PARENT: Đọc lịch học các lớp đã ghi danh qua Portal.

## User Scenarios & Testing

### User Story 1 — Quản lý lớp học và tự động sinh lịch học (Priority: P0)

Là ADMIN, tôi muốn tạo lớp học từ khóa học đã mở, phân công giáo viên giảng dạy, chọn phòng học và cấu hình lịch học định kỳ theo thứ trong tuần để hệ thống tự động sinh ra các buổi học cụ thể.

**Giá trị/ưu tiên:** Tiền đề bắt buộc để tuyển sinh (Enrollments) và điểm danh (Attendance).

**Independent Test:** Tạo lớp và sinh lịch hai buổi/tuần, kiểm tra giáo viên và phòng học hiển thị đúng.

**Acceptance Scenarios:**
1. Given thông tin lớp và khóa học OPEN hợp lệ, When cấu hình lịch tuần (VD: T2, T4, T6 từ 18:00 - 20:00), Then hệ thống sinh danh sách buổi học (ClassSessions) đúng ngày/giờ/phòng/người dạy.
2. Given phòng hoặc giáo viên bị trùng giờ với buổi học khác đã tồn tại, When sinh lịch, Then từ chối lưu cả đợt và cảnh báo chi tiết xung đột (BR05, BR06).

### User Story 2 — Tra cứu lớp học & Thời khóa biểu tuyển sinh (Priority: P0)

Là STAFF (Tư vấn tuyển sinh), tôi muốn tra cứu danh sách các lớp học đang mở tuyển sinh, xem sĩ số hiện tại/tối đa, lịch học định kỳ và thời khóa biểu tuần để tư vấn chính xác cho phụ huynh và học sinh.

**Giá trị/ưu tiên:** Giúp nhân viên tuyển sinh có dữ liệu thời gian thực để tư vấn và chốt ghi danh.

**Independent Test:** Đăng nhập tài khoản STAFF, truy cập danh sách lớp và lịch học, kiểm tra không có nút Thêm/Sửa/Xóa lớp học hoặc phòng học.

**Acceptance Scenarios:**
1. Given nhân viên STAFF đăng nhập, When vào danh sách lớp học hoặc thời khóa biểu, Then xem được thông tin lớp, sĩ số còn trống, giáo viên, phòng và lịch học mà không có quyền chỉnh sửa.

### User Story 3 — Quản lý phòng học & Đóng lớp học an toàn (Priority: P0)

Là ADMIN, tôi muốn quản lý danh mục phòng học (thêm, sửa, trạng thái phòng) và đóng lớp an toàn khi khóa học kết thúc.

**Giá trị/ưu tiên:** Bao phủ vòng đời và UC34.

**Independent Test:** Tạo/sửa phòng, bảo trì và đóng lớp.

**Acceptance Scenarios:**
1. Given phòng còn lịch tương lai, When đưa bảo trì, Then phải dời/hủy lịch trước.
2. Given lớp CLOSED, When tạo buổi/ghi danh mới, Then bị chặn và giữ lịch sử.

### Edge Cases

- Tiếp giáp được phép; khác ngày cùng giờ; giờ bằng 0 hoặc qua nửa đêm.
- Sinh lại cùng mẫu; thay giáo viên chính khi buổi đã sinh; ngày loại trừ.
- Giảm capacity dưới ACTIVE; phòng nhỏ hơn lớp; học viên chuyển/bảo lưu.
- COMPLETED không đổi giờ/người dạy bằng form thường; hủy lớp không xóa công nợ.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | WHEN lưu lớp, THE SYSTEM SHALL yêu cầu khóa OPEN, mã duy nhất, giáo viên hợp lệ, ngày bắt đầu≤kết thúc, capacity>0; ONE_TO_ONE capacity=1. | M05; UC15; BR04 | Chặn capacity=0, 1-1>1, giáo viên sai và ngày đảo. |
| FR-002 | THE SYSTEM SHALL CRUD phòng với mã/tên/sức chứa dương và AVAILABLE/MAINTENANCE; phòng đã dùng không xóa vật lý. | UC34; M12; BR16 | Phòng bảo trì không được xếp buổi mới; lịch sử giữ nguyên. |
| FR-003 | WHEN mở lớp/xếp buổi, THE SYSTEM SHALL bảo đảm capacity lớp≤sức chứa phòng; giảm capacity không dưới ACTIVE hiện tại. | UC15; UC34; BR04 | Cả POST trực tiếp cũng chặn giảm dưới sĩ số hoặc đổi phòng nhỏ. |
| FR-004 | WHEN sinh lịch, THE SYSTEM SHALL nhận ngày trong tuần/khoảng ngày/giờ/số buổi/ngày loại trừ và cho xem trước; lưu cả đợt nguyên tử. | UC16; M05 | Preview khớp lưu; lặp khóa yêu cầu không sinh trùng. |
| FR-005 | THE SYSTEM SHALL chặn chồng lấn giáo viên/phòng cùng ngày giữa buổi SCHEDULED/IN_PROGRESS/COMPLETED. | BR05; BR06; UC16 | Tiếp giáp được phép; giao một phút bị chặn; CANCELLED/RESCHEDULED không chiếm lịch. |
| FR-006 | WHEN tạo/đổi buổi hoặc ghi danh, THE SYSTEM SHALL kiểm tra lịch Student ACTIVE theo hiệu lực và chặn xung đột chưa có ngoại lệ ADMIN cụ thể. | BR07; UC16; UC19 | Ngoại lệ có lý do/actor/cặp buổi/audit; thay lịch phải xét lại. |
| FR-007 | WHEN dời buổi, THE SYSTEM SHALL giữ buổi cũ RESCHEDULED, liên kết buổi thay thế; học bù tham chiếu buổi bị hủy. | M05; UC16; WF-02 | Portal không coi buổi cũ còn học; không nhân đôi kế hoạch số buổi. |
| FR-008 | WHEN dạy thay, THE SYSTEM SHALL chỉ đổi buổi được chọn sau kiểm tra lịch; thay giáo viên chính không sửa buổi COMPLETED. | M05; BR05; BR09 | Người cũ mất quyền ghi buổi thay, giáo viên mới thấy đúng phân công. |
| FR-009 | THE SYSTEM SHALL chuyển PLANNING→OPEN→ONGOING→CLOSED hoặc CANCELLED và yêu cầu xử lý buổi tương lai trước khi đóng/hủy; chỉ ADMIN được mở lại CLOSED có lý do/audit và kiểm tra lại điều kiện ngày/lịch trước khi bổ sung học bù. | UC15; BR19 | Lớp đóng không nhận buổi/ghi danh; không mất phí/điểm danh; STAFF không tự mở lại để lách trạng thái. |
| FR-010 | THE SYSTEM SHALL cung cấp lịch tuần theo ngày/lớp/phòng/người liên quan, đồng bộ mọi portal sau commit và tải lại. | UC19; WF-02; WF-05 | Không lộ lịch lớp ngoài quyền; buổi hủy không hiện như sắp học. |
| FR-011 | THE SYSTEM SHALL tuần tự hóa kiểm tra/ghi lịch trên tài nguyên ổn định và rollback cả đợt khi lỗi. | UC16; QG06 | Hai request cùng phòng/giáo viên không tạo chồng lấn hoặc nửa đợt lịch. |
| FR-012 | THE SYSTEM SHALL audit đổi lịch/dạy thay/đóng lớp/bảo trì, kèm lý do khi ảnh hưởng lịch đã công bố. | BR18; M05 | Có before/after, actor và tham chiếu buổi thay. |

### Key Entities

- Class: đợt Course, loại lớp, capacity, giáo viên chính, vòng đời.
- Room: phòng một cơ sở, sức chứa và tình trạng.
- ClassSession: ngày/giờ/phòng/người thực dạy và liên kết dời/học bù.
- EnrollmentHistory và ngoại lệ lịch: người học theo hiệu lực và phê duyệt cá biệt.

### State & Business Rules

Class PLANNING/OPEN/ONGOING/CLOSED/CANCELLED; Session SCHEDULED/IN_PROGRESS/COMPLETED/CANCELLED/RESCHEDULED; Room AVAILABLE/MAINTENANCE. D08/D09 quy định giao nhau và điều kiện tuyển sinh. COMPLETED chỉ sửa dữ liệu học vụ bằng correction có audit.

**Business rules:** BR02, BR04, BR05, BR06, BR07, BR16, BR18, BR19. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-10, ADM-11, ADM-13, TCH-01, TCH-02. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-13 chứa lịch tuần/quản lý phòng; Teacher dashboard/lớp dùng lịch thật; form đổi lịch hiển thị cũ/mới và xung đột.

## Success Criteria

- **SC-001:** 0 cặp lịch chồng lấn giáo viên/phòng sau 20 cặp thao tác đồng thời cùng tài nguyên.
- **SC-002:** 100% buổi dời/hủy hiển thị nhất quán ở các portal sau tải lại.
- **SC-003:** 100% ca tiếp giáp/khác ngày/1-1/phòng bảo trì/lớp đóng đúng FR.

## Assumptions

- Mẫu lịch là input; buổi cụ thể là nguồn sự thật.
- Học bù sau CLOSED cần ADMIN mở lại có audit trước; không lách BR19.
- Không tin teacherId/studentId trên URL làm căn cứ quyền.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Cần auth, khóa, giáo viên, học viên và lịch sử enrollment. Attendance/assessment/portal/reporting đọc ClassSession; các quan hệ bổ sung ở data-contract.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
