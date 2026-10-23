# Feature Specification: Cấu hình, danh mục và nhật ký hệ thống

**Feature:** `feat-system-administration` | **Module SRS:** M12 | **Owner:** Member 03
**Created/Updated:** 2026-10-23 | **Version:** 2.0.0 | **Status:** Locked — baseline đặc tả nội bộ theo yêu cầu chủ dự án.
**Implementation:** Chưa nghiệm thu; tài liệu này không xác nhận đã có code.
**Nguồn:** SRS v1.1 III M12, V UC05/34/35, VI BR18, VIII ADM-18/19, XIII; **Use cases:** UC05, UC34, UC35.

Kế thừa [quyết định chung](../../../decisions.md), [quality gates](../../../quality-gates.md), [hợp đồng dữ liệu](../../../data-contract.md), [tích hợp](../../../integration.md), [màn hình](../../../screen-map.md) và [module](../module.md). FR/SC là mã cục bộ của feature này. Locked không thay thế phê duyệt khách hàng/giảng viên.

## Business Context & Scope

Cấu hình nghiệp vụ và audit phải truy vết được, không lẫn với quản lý tài khoản hay sửa trực tiếp giao dịch tài chính.

**Trong phạm vi:** SystemSettings theo allowlist, thông tin trung tâm/danh mục cần thiết, giới hạn nghiệp vụ, đọc/lọc AuditLogs UC35 P1; điều hướng tới quản lý tài khoản/phòng do feature riêng sở hữu.

**Ngoài phạm vi:** Chỉnh schema/SQL từ UI, đọc secrets SMTP/DB, xóa audit, thay đổi tùy ý RBAC, tích hợp chi nhánh hoặc dashboard sức khỏe giả.

**Actors & Permissions:** ADMIN quản lý cấu hình/đọc audit; STAFF quản lý phòng ở ADM-13 theo UC34, không sửa settings nhạy cảm. Đổi tài khoản/role do feat-auth-rbac sở hữu duy nhất.

## User Scenarios & Testing

### User Story 1 — Cấu hình hợp lệ (Priority: P0)

Là ADMIN, tôi muốn cập nhật thông tin trung tâm và thông số cho giao dịch tương lai.

**Giá trị/ưu tiên:** Dữ liệu chung không hardcode UI.

**Independent Test:** Sửa tên/liên hệ trung tâm và kỳ hạn hóa đơn.

**Acceptance Scenarios:**
1. Given key allowlist và value hợp lệ, When lưu, Then thông tin mới hiển thị từ DB và có audit.
2. Given key lạ hoặc đang sửa secret, When POST, Then từ chối, không chạy cấu hình tùy ý.

### User Story 2 — Tra cứu audit (Priority: P1)

Là ADMIN, tôi muốn xem ai đổi phí/quyền/điểm để đối soát.

**Giá trị/ưu tiên:** UC35 P1; ghi audit trọng yếu vẫn bắt buộc P0.

**Independent Test:** Đổi role/phí/công bố điểm, rồi lọc nhật ký.

**Acceptance Scenarios:**
1. Given thao tác đã commit, When tìm theo actor/đối tượng/ngày, Then có before/after/reason an toàn.
2. Given không phải ADMIN, When gọi trang/data audit, Then 403; không có API sửa/xóa log.

### Edge Cases

- Cấu hình thiếu/rỗng/sai kiểu; hai người sửa cùng key; cập nhật kỳ hạn không sửa hóa đơn cũ.
- Before/after có password/token/PII, log dài hoặc nội dung HTML.
- Audit lỗi trong giao dịch trọng yếu; tài khoản actor đã ngừng vẫn cần truy vết.
- Cấu hình giảm giới hạn thấp hơn thực tế lớp; trang audit chưa triển khai không đồng nghĩa tắt ghi audit.

## Requirements

### Functional Requirements

Các yêu cầu áp dụng đồng thời QG01–QG12. Cột nghiệm thu là kết quả bắt buộc khi chạy trường hợp tương ứng; không phải bằng chứng test đã pass.

| ID | Yêu cầu kiểm chứng được | Truy vết nguồn | Nghiệm thu / kết quả quan sát |
|---|---|---|---|
| FR-001 | THE SYSTEM SHALL cung cấp danh sách settings có key định danh, kiểu, đơn vị, miền giá trị và quyền sửa allowlist. | M12; SystemSettings | Không cho thêm key tùy ý, không eval giá trị thành code/query. |
| FR-002 | WHEN lưu settings, THE SYSTEM SHALL kiểm tra lại ADMIN, phiên bản cũ, kiểu/giới hạn, ghi updated_by/time và audit cùng giao dịch. | M12; BR18 | Lỗi validation/audit không cập nhật một phần; stale edit báo xung đột. |
| FR-003 | THE SYSTEM SHALL lấy tên/địa chỉ một cơ sở/liên hệ công khai/chính sách hiển thị từ settings thật; thiếu thì bỏ phần không có hoặc báo chưa cập nhật. | M01; M12; QG03 | Không hardcode hai chi nhánh/hotline/chứng nhận/uptime giả. |
| FR-004 | THE SYSTEM SHALL áp dụng thay đổi thông số chỉ cho thao tác tương lai; không tự sửa nghĩa vụ/điểm/lịch đã chốt. | M12; BR16; BR18 | Đổi gia hạn không thay due_date hóa đơn cũ; giảm capacity mặc định không sửa lớp đang có. |
| FR-005 | THE SYSTEM SHALL tách secrets DB/SMTP khỏi bảng settings công khai/UI/audit; không cho đọc hoặc ghi qua form này. | SEC-01; BR02; QG08 | Response/log không có password, token, connection string. |
| FR-006 | THE SYSTEM SHALL ghi audit trọng yếu cho phí, công bố/correction điểm, role/status, lịch, giám hộ, tài chính và ngừng bản ghi dù màn hình UC35 chưa có. | BR18; M12 | P0 có audit bền vững; lỗi ghi log trọng yếu rollback mutation. |
| FR-007 | WHEN mở audit (P1), THE SYSTEM SHALL lọc/sort/page theo ngày/actor/action/entity, mở chi tiết before/after/reason đã che dữ liệu nhạy cảm. | UC35; AuditLogs | Kết quả đúng bộ lọc, escape nội dung, không tải toàn log vào trình duyệt. |
| FR-008 | THE SYSTEM SHALL giữ audit append-only và định danh actor lịch sử; không cung cấp chỉnh/xóa log từ UI. | UC35; BR16; BR18 | Không có POST delete/edit audit; ngừng User không mất log. |
| FR-009 | THE SYSTEM SHALL điều hướng tài khoản tới ADM-18 và phòng tới ADM-13, dùng đúng chủ sở hữu, không tạo CRUD trùng. | UC05; UC34; M12 | Role/room validation giống feature gốc, không bypass bằng settings. |
| FR-010 | WHEN ADMIN đổi system.admissions_open, THE SYSTEM SHALL audit và áp dụng ở Service cho tiếp nhận nhu cầu/ghi danh mới; không khóa quyền xem dữ liệu hoặc tài khoản ADMIN. | M12; trạng thái hệ thống | Khi đóng tuyển sinh, public thông báo rõ và POST intake/enrollment bị từ chối; mở lại hoạt động bình thường, lịch sử không đổi. |

### Key Entities

- SystemSetting: giá trị allowlist có kiểu và người cập nhật.
- AuditLog: tác giả/thời điểm/thao tác/đối tượng/before/after/reason, dữ liệu được che phù hợp.
- User/Role và Room: tham chiếu feature chuyên trách, không có bản sao nghiệp vụ.

### State & Business Rules

Cấu hình dùng giá trị đã validate theo phiên bản, không tự thêm enum ở UI. Audit chỉ đọc sau commit. Ghi audit là hạ tầng P0, màn hình đọc UC35 là P1.

**Business rules:** BR02, BR16, BR18. Chi tiết và chủ sở hữu tại traceability.md; không tự định nghĩa lại công thức chung.

### UI & Navigation

**Screens:** ADM-19. URL/quyền/GET/POST được quy định ở screen-map.md; mỗi ID có đúng một chủ sở hữu. ADM-19 tách cấu hình và tab audit có quyền ADMIN; link quản lý phòng/tài khoản dẫn tới màn hình gốc. Không đưa chi tiết persistence/implementation vào flow cho người dùng.

## Success Criteria

- **SC-001:** 100% thay đổi cấu hình hợp lệ có actor/time/audit, key ngoài allowlist bị chặn.
- **SC-002:** 100% mutation trọng yếu kiểm tra có audit đúng cùng transaction.
- **SC-003:** 0 secrets hoặc chức năng sửa/xóa audit được lộ qua màn hình/data endpoint.

## Assumptions

- Các settings baseline: center.name/address/phone/email, finance.due_grace_days (0–365), class.default_capacity (>0), public nội dung đã duyệt; không cấu hình khóa cho phép bỏ security.
- Sao lưu/restore là quy trình bàn giao do quản trị môi trường thực hiện, không xây nút chạy shell từ web.
- Các lựa chọn chưa được SRS quyết định được ghi tại decisions.md; không coi đây là xác nhận của khách hàng.
- Cần plan/tasks cập nhật và bằng chứng quality gates trước khi triển khai/đánh dấu hoàn thành.

## Dependencies & Handoff

Auth bảo vệ ADMIN; QG07 là hợp đồng audit chung. Class-timetable sở hữu Rooms; auth sở hữu User/Role; tài chính/giám hộ/học vụ cung cấp sự kiện audit cùng transaction.

Checklist chất lượng: [requirements.md](checklists/requirements.md). Trạng thái hiện thực hóa và thứ tự triển khai: [README](../../../README.md).
