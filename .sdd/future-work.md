# Phạm vi đã đặc tả và triển khai còn lại

**Cập nhật:** 2026-10-23. Bộ [spec đầy đủ](specs/README.md) đã bao phủ SRS; công việc tiếp theo là đối chiếu code, lập plan/tasks đúng phiên bản và implement theo [thứ tự code](specs/implementation-order.md). Không còn dùng “chưa có spec” cho các module bên dưới.

| Module | Hiện trạng được ghi nhận trước baseline | Spec và phần triển khai tiếp theo |
|---|---|---|
| M01 Public | Có home/catalog/detail/giỏ/intake/receipt | [catalog v2](specs/modules/admission/feat-course-catalog/spec.md): đồng bộ dữ liệu thật và bỏ ngoại lệ minh họa theo D04; chưa xác nhận v2 đã đạt |
| M02 Auth | Có auth/RBAC5 mã, quản trị User và sửa phiên | [auth v2](specs/modules/finance-admin/feat-auth-rbac/spec.md): reset SMTP không lộ link, bỏ security demo, đối chiếu đủ FR hiện hành |
| M03 CRM | Có tiếp nhận Lead, chưa có CRM đầy đủ | [CRM](specs/modules/admission/feat-admission-crm/spec.md): phân công/timeline/Trial/convert |
| M04 Courses/Teacher | Catalog có Entity/query đọc; chưa chứng minh CRUD học vụ hoàn chỉnh | [programs](specs/modules/academic/feat-academic-programs/spec.md), [teacher](specs/modules/academic/feat-teacher-management/spec.md) |
| M05 Classes/Timetable/Room | Chưa có bằng chứng hoàn tất vận hành | [class-timetable](specs/modules/academic/feat-class-timetable/spec.md): CRUD, sinh/đổi/bù/thay lịch và concurrency |
| M06 People/Enrollment/Portal | Dashboard mới là trang điều hướng | [people](specs/modules/admission/feat-student-guardian/spec.md), [enrollment](specs/modules/admission/feat-enrollment/SPEC.md), [portal](specs/modules/admission/feat-student-parent-portal/spec.md) |
| M07 Attendance/Journal | Chưa có bằng chứng hoàn tất | [attendance/journal](specs/modules/academic/feat-attendance-journal/spec.md): P0 chuyên cần, P1 nhật ký |
| M08 Assessment/Progress | Chưa có bằng chứng hoàn tất | [assessment](specs/modules/academic/feat-assessment-progress/spec.md): điểm/publish/progress thật |
| M09 Finance | Chưa có bằng chứng hoàn tất | [tuition/payment](specs/modules/finance-admin/feat-tuition-payment/spec.md): Invoice factory trước Enrollment, ledger/thu/nợ/hoàn sau |
| M10 Communication | Chưa có bằng chứng hoàn tất | [Q&A/notification](specs/modules/admission/feat-notifications-qa/spec.md): P0 moderation, P1 inbox/sự kiện |
| M11 Reporting | Dashboard chưa có nghiệp vụ thống kê đầy đủ | [reporting](specs/modules/finance-admin/feat-dashboard-reporting/spec.md): nguồn thật, đủ5 aggregates và đối soát |
| M12 Administration | Có User management/audit mutation nền | [system administration](specs/modules/finance-admin/feat-system-administration/spec.md): settings/audit nền P0, UI audit P1; Room thuộc M05 |

Ba ngoại lệ đợt sửa portal/cart cũ (link reset trực tiếp, profile security demo, home learning showcase) là hồ sơ lịch sử, không phải miễn trừ baseline production mới. D04 quy định đích; đợt viết spec không thay code hoặc sửa lại bằng chứng kiểm thử cũ.

Giỏ công khai không coupon/combo; ưu đãi nội bộ của Finance vẫn được đặc tả theo SRS, có ADMIN duyệt. Không xóa schema/lịch sử để thực hiện việc bỏ coupon UI.

**P1 đã có spec nhưng làm sau P0:** UC18 chuyển/bảo lưu; UC21 nhật ký; UC28 thông báo; UC35 màn audit. Hạ tầng history/audit và bảo toàn tài chính vẫn bắt buộc cho P0 khi liên quan.

**Giai đoạn2 ngoài MVP:** nhiều cơ sở, video learning, ngân hàng thật, CRM nâng cao, payroll, native mobile, AI, SMS/Zalo, import Excel,2FA/device management. Không làm các mục này chỉ vì prototype có nội dung minh họa.
