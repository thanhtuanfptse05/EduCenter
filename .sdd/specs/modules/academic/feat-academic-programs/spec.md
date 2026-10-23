# Feature Specification: Quản lý môn học và chương trình/khóa học

**Feature:** `feat-academic-programs` | **Module SRS:** M04 | **Owner:** Member 01
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M04, V UC11, VII, VIII ADM-04/05, XVII 3.3; **Use cases:** UC11.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Danh mục học thuật là nguồn duy nhất cho website, lớp học và phí ban đầu. Nhân viên quản lý môn và khóa theo khối 6–12 để tuyển sinh và đào tạo dùng cùng dữ liệu.

**Trong phạm vi:** CRUD môn/khóa, chương trình, trình độ, mục tiêu thi, số buổi, thời lượng, phí niêm yết, trạng thái và nội dung công khai.

**Ngoài phạm vi:** Lập lớp/lịch, thay đổi hóa đơn đã phát hành, bảng Programs độc lập, coupon công khai và e-learning.

**Actors & Permissions:** STAFF/ADMIN quản lý; TEACHER đọc khóa được giao; Guest/Student/Parent đọc qua catalog. Không công khai ghi chú nội bộ.

## User Scenarios & Testing

### User Story 1 — Tạo và tra cứu khóa (Priority: P0)

Là STAFF, tôi muốn tạo môn và khóa theo khối để tuyển sinh dùng danh mục thống nhất.

**Giá trị/ưu tiên:** Là tiền đề catalog và lớp học.

**Independent Test:** Tạo môn, tạo khóa, tìm/lọc và mở chi tiết public.

**Acceptance Scenarios:**
1. Given môn ACTIVE và dữ liệu hợp lệ, When lưu khóa OPEN, Then khóa xuất hiện đúng môn/khối và phí.
2. Given mã khóa trùng, When lưu, Then không có bản ghi mới và báo lỗi trường mã.

### User Story 2 — Ngừng tuyển sinh an toàn (Priority: P0)

Là ADMIN, tôi muốn sửa/lưu trữ khóa để thay đổi thông tin không làm đổi lịch sử phí.

**Giá trị/ưu tiên:** Bảo vệ lịch sử nghiệp vụ.

**Independent Test:** Đổi phí khóa đã có hóa đơn rồi archive.

**Acceptance Scenarios:**
1. Given khóa có hóa đơn, When sửa phí, Then hóa đơn cũ giữ snapshot.
2. Given khóa ARCHIVED, When thêm vào giỏ hoặc ghi danh bằng ID cũ, Then bị từ chối; lịch sử vẫn đọc được.

### Edge Cases

- Mã trùng khác hoa/thường, môn INACTIVE còn khóa OPEN.
- Khối 5/13, phí âm, số buổi/thời lượng bằng 0, HTML trong mô tả.
- Hai người sửa cùng khóa; archive trong lúc người khác xác nhận giỏ; lỗi DB.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL tạo/xem/sửa/ngừng hoạt động môn với mã duy nhất, tên, mô tả, ACTIVE/INACTIVE. | M04; UC11; ASM 3.3 | Đủ vòng CRUD; mã trùng bị từ chối. |
| FR-002 | WHEN lưu khóa, THE SYSTEM SHALL kiểm tra mã duy nhất, tên, môn ACTIVE, khối 6–12, mục tiêu/trình độ, thời lượng/số buổi dương, phí không âm. | M04; UC11 | Giá trị biên hợp lệ lưu được; lỗi không ghi dở và giữ input an toàn. |
| FR-003 | THE SYSTEM SHALL tìm khóa theo từ khóa/môn/khối/trạng thái, sort tên/phí/ngày tạo và phân trang giữ bộ lọc. | UC11; QG08 | Kết quả/tổng số/trang nhất quán; sort theo allowlist. |
| FR-004 | WHEN đổi phí, THE SYSTEM SHALL audit before/after và không sửa giá trị đã chụp trên hóa đơn. | BR18; M09 | Công nợ/hóa đơn cũ không thay đổi; lập mới dùng phí mới. |
| FR-005 | THE SYSTEM SHALL quản lý OPEN↔CLOSED và chuyển ARCHIVED; CLOSED/ARCHIVED không nhận yêu cầu đăng ký mới. | M04; BR16 | Catalog, giỏ và ghi danh cùng từ chối trạng thái không mở. |
| FR-006 | IF môn/khóa đã có quan hệ, THE SYSTEM SHALL ngừng/lưu trữ thay hard delete; chặn ngừng môn khi còn khóa OPEN. | UC11; BR16 | Không mất lớp/ghi danh/lịch sử; hướng dẫn đóng khóa trước. |
| FR-007 | THE SYSTEM SHALL cấp catalog mô tả/ảnh/nổi bật thực tế và trạng thái chưa có dữ liệu cho trường còn thiếu. | M01; M04; QG03 | Không sinh khóa/lịch/giáo viên giả để lấp trang. |
| FR-008 | IF phiên bản sửa đã cũ, THE SYSTEM SHALL từ chối ghi đè và yêu cầu tải lại, giữ input an toàn. | UC11; QG06 | Hai người sửa không làm mất dữ liệu nhau. |

### Key Entities

- Subject: môn học và trạng thái.
- Course: chương trình/khóa theo môn/khối, mục tiêu, trình độ, thời lượng, số buổi, phí và xuất bản.
- Class/Invoice: dữ liệu tham chiếu và snapshot lịch sử.

### State & Business Rules

Subject ACTIVE/INACTIVE; Course OPEN/CLOSED/ARCHIVED. Dùng ID ổn định; chương trình và khóa cùng biểu diễn bởi Course theo D05/D06.

**Business rules:** BR02, BR16, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-04, ADM-05. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. Form tách thông tin học thuật/tuyển sinh/phí; xác nhận đóng/archive; empty/error state có hành động đúng quyền.

## Success Criteria

- **SC-001:** 100% CRUD hợp lệ tra cứu lại được đúng mã/dữ liệu.
- **SC-002:** Không hóa đơn/ghi danh lịch sử nào đổi khi sửa phí hoặc archive khóa.
- **SC-003:** 100% mã trùng, input ngoài miền và sửa đồng thời được xử lý không ghi dở.

## Assumptions

- Course đại diện chương trình/khóa; không quản lý giáo trình số.
- Phút/buổi và trình độ cần migration nếu schema thiếu.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Auth/RBAC là tiền đề. Member 01 sở hữu ghi Subjects/Courses; catalog, CRM, lớp và tài chính đọc cùng nguồn.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
