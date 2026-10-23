# Feature Specification: Các phân khu nội dung trang chủ

**Feature:** `feat-landing-showcase` | **Module SRS:** M01 | **Owner:** Member 02
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M01, VIII PUB-01; đặc tả UI hỗ trợ catalog v2; **Use cases:** UC06, UC09.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Trang chủ cần giới thiệu trung tâm rõ ràng và dẫn người dùng tới khóa học/tư vấn bằng nội dung thực tế. Đây là spec UI hỗ trợ, không có quyền định nghĩa dữ liệu nghiệp vụ khác catalog.

**Trong phạm vi:** Navbar/anchor hoạt động, lộ trình/chương trình/môn/giáo viên/CTA tư vấn từ backend, responsive và theme đúng design.md.

**Ngoài phạm vi:** 3D/emoji/glow/gradient, số liệu tiến bộ giả, runner/flag hoạt hình, chứng nhận/thành tích không có nguồn, cấp quyền hoặc thay đổi cart.

**Actors & Permissions:** Guest/All đọc thông tin được công bố; STAFF/ADMIN quản lý nội dung qua dữ liệu nguồn đã phân quyền, không nhập trực tiếp JSP.

## User Scenarios & Testing

### User Story 1 — Khám phá nội dung trang chủ (Priority: P0)

Là người quan tâm, tôi muốn xem chương trình/môn/đội ngũ và mở đúng khóa để gửi nhu cầu.

**Giá trị/ưu tiên:** Hỗ trợ UC06/09.

**Independent Test:** Bấm từng anchor/CTA, thử DB rỗng ở các độ rộng.

**Acceptance Scenarios:**
1. Given dữ liệu được công bố có thật, When mở home, Then hiển thị đúng nội dung và CTA tới catalog có filter.
2. Given không có thành tích/tiến bộ công khai hợp lệ, When mở home, Then không dựng số liệu hoặc lộ dữ liệu cá nhân.

### Edge Cases

- Anchor mất target, section không có dữ liệu, tên/mô tả dài, không có ảnh/bằng cấp.
- Login rồi vào home, OS Dark lần đầu, localStorage bị chặn, menu mobile.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL trình bày lộ trình bằng nội dung đã duyệt từ backend, bố cục dễ đọc, outline SVG nếu cần; không giữ yêu cầu 3D/emoji/glow từ bản v1. | M01; D04; design.md | Không tự gắn 100+ trường hoặc cam kết điểm; không có dữ liệu thì ẩn khối không cần thiết. |
| FR-002 | THE SYSTEM SHALL dựng chương trình theo khối dữ liệu thực, hỗ trợ backend6–12 dù marketing nhấn10–12; CTA chọn đúng filter. | M01; UC06 | Card/đếm khớp Courses/Classes, không hardcode ba card làm dữ liệu. |
| FR-003 | THE SYSTEM SHALL dựng môn từ Subjects và COUNT khóa OPEN, link /courses?subjectId= đúng ID. | M01; UC06 | Môn không có khóa hiện đúng0 hoặc ẩn theo chính sách; lỗi DB không giả thành0. |
| FR-004 | THE SYSTEM SHALL chỉ public hồ sơ Teacher và trường/bằng cấp đã được phép, không tự tạo verified/kinh nghiệm/thành tích. | M01; BR02; QG03 | Không lộ PII học viên hoặc liên hệ riêng. |
| FR-005 | THE SYSTEM SHALL dùng cùng intake form/CSRF/validation/Lead/receipt của catalog; home luôn public, anchor/CTA hoạt động ở mọi độ rộng. | UC09; QG02/04 | Không tạo luồng Lead thứ hai khác chuẩn; keyboard/mobile dùng được. |

### Key Entities

- Published center content: nội dung đã duyệt từ SystemSettings allowlist có cấu trúc.
- Subject/Course/Class/Teacher: nguồn catalog sở hữu dữ liệu.
- Lead: form home dùng cùng tiếp nhận M01/M03.

### State & Business Rules

Không có state machine riêng. Nội dung chưa xác thực không công bố; dữ liệu cá nhân không dùng làm showcase marketing.

**Business rules:** BR02. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** PUB-01. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. PUB-01 thuộc catalog về quyền sở hữu màn hình; supporting spec này chỉ chi tiết trình bày và kế thừa screen-map.

## Success Criteria

- **SC-001:** 100% anchor/CTA hoạt động ở360/768/1024/1440px, cùng navigation/theme.
- **SC-002:** 0 KPI/tiến bộ/bằng cấp/chứng nhận không có nguồn, không dữ liệu học viên riêng công khai.

## Assumptions

- Thay FR-01..05 bản cũ bằng FR-001..005 tương ứng chủ đề; yêu cầu hình thức xung đột design.md được loại bỏ.
- Không tạo bảng Awards/Roadmap tự phát; nếu nội dung cần public thì là settings cấu trúc đã validate hoặc Course data.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Kế thừa feat-course-catalog v2; teacher/academic/sysadmin cung cấp nguồn. Plan/tasks v1 chỉ là lịch sử và phải lập lại trước code.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
