# Bộ đặc tả EduCenter — SRS v1.1

**Baseline:** 2026-10-23 | **Phạm vi:** một trung tâm/một cơ sở, lớp6–12, GROUP và ONE_TO_ONE.

Bộ tài liệu gồm **15 feature lõi + 2 spec UI hỗ trợ**, bao phủ **12 module,35 use case(31 P0+4 P1),55 ý mô tả module,20 business rule,30 bảng nghiệp vụ và49 màn hình**. Có **158 FR lõi** và10 FR hỗ trợ UI. Spec repair cũ được giữ như hồ sơ lịch sử, không thêm phạm vi vào MVP.

Locked là baseline đặc tả nội bộ theo yêu cầu chủ dự án, không chứng minh đã có code, test pass hay phê duyệt khách hàng/giảng viên. Đợt này chỉ cập nhật tài liệu và công cụ kiểm độ phủ; code ứng dụng, database và kết quả test runtime giữ hiện trạng.

## Đọc từ đâu

1. [Thứ tự code từng tính năng](implementation-order.md): bước0–17 cho P0, rồi4 use case P1; tách Finance A/B trước và sau ghi danh.
2. [Quyết định/giả định thống nhất](decisions.md):5 mã role/6 trách nhiệm, P0/P1, học phí, coupon, lịch, công bố và ngoại lệ lịch sử.
3. [Hợp đồng dữ liệu](data-contract.md), [tích hợp/giao dịch/quyền](integration.md) và [49 màn hình/routes](screen-map.md).
4. [Truy vết SRS](traceability.md), [quality gates](quality-gates.md), [nghiệm thu liên module](acceptance.md), [kết quả rà soát tài liệu](review.md).

## Danh mục feature lõi

| Feature/spec | Module SRS | Chủ sở hữu | Use cases liên quan | FR | Hiện thực hóa |
|---|---|---|---|---|---|
| [Quản lý môn học và chương trình/khóa học](modules/academic/feat-academic-programs/spec.md) | M04 | Member 01 | UC11 | 8 | Chưa có bằng chứng hoàn tất theo spec này |
| [Hồ sơ giáo viên và quyền phân công](modules/academic/feat-teacher-management/spec.md) | M04, M05, M12 | Member 01; Member 03 cấp tài khoản | UC12 | 8 | Chưa có bằng chứng hoàn tất theo spec này |
| [Lớp học, phòng học và lịch giảng dạy](modules/academic/feat-class-timetable/spec.md) | M05, M12 | Member 01 | UC15, UC16, UC19, UC34 | 12 | Chưa có bằng chứng hoàn tất theo spec này |
| [Điểm danh và nhật ký giảng dạy](modules/academic/feat-attendance-journal/spec.md) | M07 | Member 01 | UC20, UC21 | 9 | Chưa có bằng chứng hoàn tất theo spec này |
| [Bài kiểm tra, công bố điểm và tiến bộ](modules/academic/feat-assessment-progress/spec.md) | M08 | Member 01 | UC22, UC23, UC24, UC33 | 10 | Chưa có bằng chứng hoàn tất theo spec này |
| [Lead, tư vấn và kiểm tra đầu vào](modules/admission/feat-admission-crm/spec.md) | M03 | Member 02 | UC09, UC10 | 10 | Chưa có bằng chứng hoàn tất theo spec này |
| [Hồ sơ học viên, phụ huynh và xác thực giám hộ](modules/admission/feat-student-guardian/spec.md) | M06 | Member 02 | UC13, UC14 | 10 | Chưa có bằng chứng hoàn tất theo spec này |
| [Cổng học viên và phụ huynh với dữ liệu thật](modules/admission/feat-student-parent-portal/spec.md) | M06, M07, M08, M09, M10 | Member 02; Member 01/03 cung cấp dữ liệu | UC19, UC24, UC27 | 10 | Chưa có bằng chứng hoàn tất theo spec này |
| [Ghi danh, chuyển lớp, bảo lưu và lịch sử học](modules/admission/feat-enrollment/SPEC.md) | M03, M05, M06, M09 | Member 02; Member 03 lập hóa đơn trong giao dịch chung | UC17, UC18 | 12 | Chưa có bằng chứng hoàn tất theo spec này |
| [Học phí, hóa đơn, thanh toán và công nợ](modules/finance-admin/feat-tuition-payment/spec.md) | M09 | Member 03 | UC25, UC26, UC27 | 15 | Chưa có bằng chứng hoàn tất theo spec này |
| [Dashboard và báo cáo đối soát toàn trung tâm](modules/finance-admin/feat-dashboard-reporting/spec.md) | M11 | Member 03 | UC31, UC32, UC33 | 10 | Chưa có bằng chứng hoàn tất theo spec này |
| [Cấu hình, danh mục và nhật ký hệ thống](modules/finance-admin/feat-system-administration/spec.md) | M12 | Member 03 | UC05, UC34, UC35 | 10 | Chưa có bằng chứng hoàn tất theo spec này |
| [Hỏi đáp kiểm duyệt và thông báo trong ứng dụng](modules/admission/feat-notifications-qa/spec.md) | M10 | Member 02 | UC28, UC29, UC30 | 12 | Chưa có bằng chứng hoàn tất theo spec này |
| [Xác thực, hồ sơ và quản lý tài khoản](modules/finance-admin/feat-auth-rbac/spec.md) | M02, M12 | Member 03 | UC01, UC02, UC03, UC04, UC05 | 10 | Có code nền; v2 cần đối chiếu/nghiệm thu lại |
| [Website công khai, catalog và danh sách đăng ký](modules/admission/feat-course-catalog/spec.md) | M01 | Member 02 | UC06, UC07, UC08, UC09 | 12 | Có code nền; v2 cần đối chiếu/nghiệm thu lại |

## UI hỗ trợ và hồ sơ lịch sử

- [Landing sections](modules/admission/feat-landing-showcase/spec.md): hỗ trợ PUB-01, kế thừa catalog, không còn yêu cầu3D/emoji/số liệu giả.
- [Auth/footer](modules/admission/feat-auth-footer-redesign/spec.md): kế thừa auth/catalog, không tự định nghĩa policy/reset time hoặc chứng nhận giả.
- [Portal/cart repair lịch sử](modules/admission/feat-portal-cart-repair/spec.md):3 ngoại lệ của đợt sửa cũ và verification cũ được giữ để không sửa lại bằng chứng quá khứ; không phải miễn trừ production cho baseline mới.
- Plan/tasks/data-model/contracts cũ có banner version lịch sử. Chạy Spec Kit plan/tasks cập nhật trước code theo v2; chưa có bộ plan/tasks mới cho toàn bộ ERP và không tuyên bố đã qua implement/converge.

## Cách quản lý nguồn sự thật

SRS v1.1 là đầu vào nghiệp vụ; AGENTS.md và constitution là ràng buộc dự án; design.md giữ design tokens/bố cục. decisions.md cụ thể hóa lựa chọn MVP được SRS cho phép, không sửa constitution. Hợp đồng chung ở đây quyết định nghĩa dữ liệu/trạng thái/quyền/routes; feature spec quyết định hành vi và nghiệm thu. Template và các tài liệu version cũ không ghi đè baseline mới.

SRS có6 vai trò trách nhiệm; MVP hiện hữu gộp System Admin/Center Manager vào ADMIN, giữ5 mã theo constitution. Các đề xuất P1/giai đoạn2 không bị lẫn với31 UC P0. Giỏ không coupon/combo; Discount chỉ nghiệp vụ Finance nội bộ đã duyệt.

## Kiểm tra lại tài liệu

```powershell
python -X utf8 .sdd/scripts/validate_specs.py
```

[catalog.json](catalog.json) chứa map nguồn/feature/FR và screen owner để kiểm không sót hoặc tham chiếu FR không tồn tại. Validator chỉ kiểm cấu trúc/độ phủ/tham chiếu, không thay review ngữ nghĩa hay test app. Mỗi feature có checklists/requirements.md đã review chất lượng đặc tả; các gate triển khai vẫn chưa được đánh dấu pass.

Tình trạng chạy thực tế: [shared_context](../shared_context.md), [future-work](../future-work.md) và [README dự án](../../README.md). Không coi bảng phân công hoặc spec locked là chứng nhận hiện thực hóa.
