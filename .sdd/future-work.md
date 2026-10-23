# Phạm vi ERP chưa hoàn thành

Cập nhật 2026-10-23. Đây là backlog ngoài phạm vi [portal/cart repair](specs/modules/admission/feat-portal-cart-repair/spec.md); cần spec/plan/tasks riêng trước khi triển khai.

| Module | Phần còn lại |
|---|---|
| M03 Admission/CRM | Danh sách Lead, lịch sử tư vấn, học thử, chuyển đổi; hiện mới có tiếp nhận Lead |
| M04–M05 Academic | CRUD khóa/lớp, xếp lịch/phòng/ca và kiểm tra trùng lịch; hiện có catalog công khai |
| M06 Enrollment/Guardian | Ghi danh có kiểm soát sĩ số, hồ sơ học viên, liên kết phụ huynh và cô lập dữ liệu |
| M07–M08 Learning | Điểm danh, nhật ký, kiểm tra/điểm và tiến độ thực tế |
| M09 Finance | Hóa đơn, thanh toán, công nợ, biên lai và tính toàn vẹn sổ giao dịch |
| M10 Communication | Q&A, kiểm duyệt và thông báo |
| M11 Reporting | Dashboard theo vai trò, KPI và báo cáo thực tế |
| M12 Administration | Cấu hình/phòng và màn hình Audit Log đầy đủ; hiện có quản trị tài khoản và ghi log mutation |

Chủ dự án yêu cầu giữ nguyên trong đợt sửa: hiển thị link reset trực tiếp; minh họa 2FA/thiết bị/lịch sử; minh họa tiến độ và theo dõi phụ huynh trang chủ. Việc thay SMTP/2FA/quản lý phiên thiết bị và dữ liệu học tập thật chỉ thực hiện ở scope được duyệt sau này.

Tính năng mã giảm giá/combo đã được loại khỏi luồng hiện tại theo yêu cầu. Không xóa schema hay lịch sử tài chính để thực hiện thay đổi này.
