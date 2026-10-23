# Feature Specification: Hồ sơ học viên, phụ huynh và xác thực giám hộ

**Feature:** `feat-student-guardian` | **Module SRS:** M06 | **Owner:** Member 02
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M06, WF-05, V UC13/14, VII, VIII ADM-06/07/08; **Use cases:** UC13, UC14.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Hồ sơ học viên và quan hệ giám hộ đã xác thực là nền tảng cô lập dữ liệu lịch, điểm và học phí, đặc biệt với người học chưa có tài khoản.

**Trong phạm vi:** CRUD hồ sơ Student/Guardian, khối/trường/mục tiêu/liên hệ, gắn tài khoản, liên kết nhiều-nhiều/xác thực/thu hồi và lịch sử học.

**Ngoài phạm vi:** Parent tự xác thực quan hệ, tự nâng vai trò, lưu hồ sơ định danh nhạy cảm không cần thiết, xóa giao dịch khi xóa hồ sơ.

**Actors & Permissions:** STAFF/ADMIN quản lý/xác thực; Teacher chỉ đọc trường cần thiết của học viên lớp được giao; Student/Parent đọc qua portal. Quản trị User/role thuộc M02.

## User Scenarios & Testing

### User Story 1 — Quản lý hồ sơ (Priority: P0)

Là STAFF, tôi muốn tạo và tra cứu hồ sơ để ghi danh đúng người.

**Giá trị/ưu tiên:** Ngăn tạo nhầm hoặc trùng học viên.

**Independent Test:** Tạo học viên không có tài khoản, tìm/sửa trường/khối.

**Acceptance Scenarios:**
1. Given tên/khối hợp lệ, When tạo hồ sơ, Then có Student riêng dù user_id rỗng.
2. Given Student có giao dịch, When ngừng hồ sơ, Then giữ lịch sử và không xóa hóa đơn/ghi danh.

### User Story 2 — Liên kết và thu hồi giám hộ (Priority: P0)

Là STAFF, tôi muốn xác thực phụ huynh trước khi cấp quyền xem con.

**Giá trị/ưu tiên:** Điều kiện của BR15 và WF-05.

**Independent Test:** Một Parent liên kết hai Student, thu hồi một liên kết.

**Acceptance Scenarios:**
1. Given liên kết chưa xác thực, When Parent đăng nhập, Then chưa đọc được dữ liệu con.
2. Given liên kết đã xác thực, When thu hồi và Parent tải lại URL cũ, Then bị chặn ngay, kể cả học phí và notification đích.

### Edge Cases

- Một Parent nhiều con, một Student nhiều Guardian; phụ huynh có cùng số điện thoại.
- Tự đăng ký PARENT không tự tạo quyền xem con; tài khoản bị khóa; đổi user_id đã có lịch sử.
- Student chưa có User; học viên đổi khối; hai người xác thực/thu hồi đồng thời.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL CRUD Student với mã định danh ổn định, tên, ngày sinh hợp lệ, trường, khối 6–12, mục tiêu/liên hệ, trạng thái và User tùy chọn. | UC13; M06 | Tạo không User được; ngày sinh tương lai/khối ngoài miền bị từ chối. |
| FR-002 | THE SYSTEM SHALL CRUD Guardian có User PARENT hợp lệ, tên và điện thoại; một User tối đa một Guardian. | UC13; M02 | User không có PARENT hoặc đã liên kết bị từ chối; không tự cấp role qua form. |
| FR-003 | THE SYSTEM SHALL tìm/lọc/page Student/Guardian theo từ khóa/khối/trạng thái và mở lịch sử ghi danh, bảo lưu, chuyển/nghỉ theo quyền. | UC13; M06 | Lịch sử đúng Student, không mất khi Enrollment đổi trạng thái. |
| FR-004 | WHEN liên kết, THE SYSTEM SHALL tạo duy nhất một cặp Student/Guardian với quan hệ, người nhận chính và trạng thái chưa xác thực. | UC14; BR15 | Lặp cặp không nhân bản; chưa verified không có quyền. |
| FR-005 | WHEN xác thực, THE SYSTEM SHALL yêu cầu STAFF/ADMIN, căn cứ/lý do xác nhận, verified_by/time và audit. | UC14; BR15; BR18 | Parent không tự xác thực bằng payload; có bằng chứng tác giả/time. |
| FR-006 | WHEN thu hồi, THE SYSTEM SHALL ghi lý do/người/thời điểm, giữ lịch sử và chặn quyền trên request kế tiếp. | UC14; BR02; BR15 | URL/ID cũ, học phí, chart và đích thông báo không còn truy cập được. |
| FR-007 | THE SYSTEM SHALL hỗ trợ nhiều Guardian/Student và nhiều Student/Guardian; cờ nhận chính không tự cấp quyền xác thực. | M02; M06; BR15 | Hai người giám hộ xác thực đều đọc được; is_primary=true nhưng chưa verified vẫn bị chặn. |
| FR-008 | WHEN ngừng hồ sơ, THE SYSTEM SHALL yêu cầu giải quyết Enrollment ACTIVE/lịch tương lai và không hard delete nếu đã có quan hệ. | UC13; BR16 | Không xóa học phí/điểm danh; hướng dẫn chuyển trạng thái học qua enrollment. |
| FR-009 | THE SYSTEM SHALL kiểm tra quyền từng hồ sơ và chỉ cung cấp tối thiểu PII cần thiết cho Teacher/portal. | BR02; BR15; QG08 | Teacher không đọc học phí/liên hệ riêng ngoài nhu cầu; ID đoán không lộ dữ liệu. |
| FR-010 | WHEN gắn/đổi User, THE SYSTEM SHALL kiểm tra role, duy nhất và audit; tự đăng ký Student không tự gắn vào hồ sơ cùng tên/email. | UC13; BR01; BR02 | Không chiếm hồ sơ bằng email/số điện thoại trùng; đổi liên kết có lịch sử. |

### Key Entities

- Student: hồ sơ người học, User tùy chọn, trường/khối/mục tiêu/trạng thái.
- Guardian: hồ sơ người giám hộ gắn User PARENT.
- StudentGuardian: cặp nhiều-nhiều, quan hệ, xác thực/thu hồi và người xác nhận.
- EnrollmentHistory: lịch sử học theo lớp; hồ sơ không tự sửa lịch sử tài chính.

### State & Business Rules

Student STUDYING/RESERVED/DROPPED/GRADUATED là tổng quan hồ sơ; Enrollment có vòng đời riêng. Guardian ACTIVE/INACTIVE; quan hệ chỉ có quyền khi verified và chưa revoked, hồ sơ/tài khoản đủ điều kiện. Không lấy cờ STUDYING làm bằng chứng đang thuộc mọi lớp.

**Business rules:** BR01, BR02, BR15, BR16, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-06, ADM-07, ADM-08. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-06 list, ADM-07 hồ sơ/tab lịch sử, ADM-08 danh sách và quan hệ giám hộ. Badge xác thực có trạng thái chữ và quyền thao tác rõ ràng.

## Success Criteria

- **SC-001:** 100% cặp giám hộ chưa xác thực/đã thu hồi bị chặn đọc dữ liệu con ở mọi kênh.
- **SC-002:** 0 hồ sơ hoặc giao dịch lịch sử bị mất sau ngừng/thu hồi.
- **SC-003:** Hỗ trợ đúng một Parent có hai con và một con có hai Parent mà không nhân bản hồ sơ.

## Assumptions

- Không bắt buộc Student có tài khoản; để truy cập portal phải được STAFF gắn User STUDENT tường minh.
- Không lưu ảnh giấy tờ xác thực trong baseline; chỉ lưu căn cứ tối thiểu và quyền đọc hạn chế.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Auth quản lý User/role. Enrollment quản lý trạng thái học từng lớp. Portal, finance, Q&A riêng và notifications phải gọi cùng kiểm tra liên kết hiện hành.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
