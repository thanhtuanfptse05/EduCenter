# Thứ tự code tính năng EduCenter

**Baseline:** 2026-10-23. Thứ tự này phục vụ triển khai bộ spec mới, không phải xác nhận đã hoàn thành code. Tái sử dụng phần auth/catalog/cart đang có sau khi đối chiếu v2; không viết lại từ đầu chỉ vì spec được chuẩn hóa.

## 1. Quy tắc trước mỗi bước

Chọn feature trong bảng, đọc spec + decisions/data-contract/integration/screen-map, dùng Spec Kit plan→tasks cho **phiên bản spec hiện hành**, dùng CodeGraph đối chiếu code hiện tại, rồi mới implement. Mỗi lát nghiệp vụ đi đủ Entity/migration cần thiết → Repository → Service/quyền/transaction → Controller/PRG → JSP/CSS → test phù hợp. Không làm toàn bộ JSP trước backend hoặc hardcode dữ liệu chờ module khác.

Plan/tasks hiện có thuộc baseline cũ đã được đánh dấu lịch sử; checkbox cũ không chứng minh FR mới hoàn thành. Spec Kit converge chỉ chạy sau khi tasks mới đã qua implement, không dùng converge thay cho viết spec.

## 2. Thứ tự P0 khuyến nghị

| Bước | Tính năng / phần việc | Phải có trước | Đầu ra cụ thể để sang bước tiếp | Gate nghiệm thu chính |
|---|---|---|---|---|
| 0 | Nền chung và đối chiếu schema | Đọc toàn bộ tài liệu chung | Baseline DB/migration tăng dần; ID/status/tiền/thời gian thống nhất; skeleton DTO/lỗi/flash/CSRF; cơ chế audit và idempotency dùng chung; dữ liệu test riêng | Không đổi/xóa dữ liệu thật; nhận diện chính xác trường/bảng còn thiếu, build nền hoạt động |
| 1 | **Auth/RBAC v2** — UC01–05 | Bước0 | Đăng ký/login/logout/profile/reset SMTP/role/status/last-admin; Service kiểm role/record, phiên thu hồi; bỏ link reset/demo helpers khỏi scope sản phẩm | UAT-09;5 mã role bảo toàn6 trách nhiệm SRS; không mất ADMIN cuối |
| 2 | **System Administration phần P0** | Auth, audit nền | Settings allowlist, thông tin trung tâm thật, cờ tuyển sinh, API ghi audit chung; không cần UI xem log P1 | Setting sai/trái quyền bị chặn; mutation trọng yếu có log cùng transaction |
| 3 | **Môn học/chương trình/khóa học** — UC11 | Auth/settings | CRUD Subjects/Courses, phí/trình độ/số buổi/trạng thái, nguồn public thật | CRUD/archiving/fee snapshot; không đổi hóa đơn lịch sử |
| 4 | **Giáo viên** — UC12 | Auth + Subjects | Hồ sơ gắn User TEACHER, chuyên môn nhiều môn, trạng thái/public fields, không lộ thù lao/liên hệ riêng | Không Teacher trùng User; chặn phân công hồ sơ nghỉ/khóa |
| 5 | **Học viên/phụ huynh/giám hộ** — UC13–14 | Auth | Hồ sơ có/không User, quan hệ nhiều-nhiều verified/revoked, kiểm quyền dùng chung | UAT-07 phần quan hệ; Parent chưa verified không đọc được con |
| 6 | **Phòng/lớp/lịch** — UC15/16/19/34 | Khóa/Teacher/Student; schema Enrollment/History và query membership nền | CRUD Room/Class, lịch định kỳ, khóa tài nguyên, dạy thay/đổi/học bù; Teacher dashboard/lớp thật | UAT-03 lịch; phòng/Teacher không trùng; hook Student conflict có integration khi ghi danh ở bước10 |
| 7 | **Website/catalog/cart/tư vấn v2** — UC06–09 | Courses/Teacher/Class/settings, Auth; hợp đồng Lead tiếp nhận | Dữ liệu home thật; filter/sort/page/detail/related; giỏ Guest→login; create Lead/LeadCourses/receipt atomic | UAT-01 phần public; không số liệu/showcase/discount giả; chưa Enrollment |
| 8 | **CRM Lead/tư vấn/học thử/đầu vào** — UC10 | Intake + Student + Teacher/Room/lịch | Phân công, timeline, trạng thái, Trial booking/result, chọn hồ sơ chuyển đổi | Lead không tự ENROLLED; lịch thử dùng chung khóa Teacher/Room với lịch lớp |
| 9 | **Finance phần A: lập hóa đơn nền** — UC25 | Schema Enrollment/Student/Course + Auth/audit/idempotency | Invoice/Items/Discount snapshot, invoice factory dùng transaction ngoài; tính ledger/balance chuẩn; chưa cần toàn bộ màn thu tiền | Unit/JPA tests factory/ưu đãi/rollback; một initial Invoice/Enrollment; không commit lồng |
| 10 | **Ghi danh P0** — UC17 | CRM + Student + Class/lịch + Finance A | Enrollment ACTIVE + History + initial Invoice + Lead conversion cùng transaction; Student conflict và capacity thật | UAT-01 cuối + UAT-02; test20 cặp tranh chỗ, trùng, lỗi invoice rollback; đóng gate tích hợp Student lịch bước6 |
| 11 | **Finance phần B: thu/công nợ/biên lai/điều chỉnh** — UC26/27 | Enrollment + Finance A + quan hệ giám hộ | Thanh toán từng đợt, chống trùng/vượt dư, ledger bù/hủy/hoàn có duyệt, tuition Student/Parent | UAT-05/06/07;20 cặp thu đồng thời; đối soát đến0,01; không xóa lịch sử |
| 12 | **Điểm danh P0** — UC20 | Lịch + EnrollmentHistory + Teacher permissions | Roster theo ngày,4 trạng thái, hoàn tất/correction, chuyên cần D11 | UAT-03 điểm danh; unique attendance; thiếu không tự PRESENT; không journal vẫn chạy |
| 13 | **Kiểm tra/điểm/tiến bộ** — UC22–24 | Lớp/Teacher/roster + Auth/audit | Assessment/Score/thang/trọng số, publish/correction, dữ liệu tiến bộ chuẩn hóa | UAT-04; nháp không lộ; AVG/MIN/MAX đúng nhiều thang |
| 14 | **Student/Parent Portal hoàn chỉnh** — UC19/24/27 | Quan hệ + lịch + Attendance + PublishedScore + Finance | Dashboard/lịch/tiến bộ/phí thật; chọn con, link receipt an toàn; không phải trang điều hướng đơn thuần | UAT-07 toàn bộ và đối chiếu từng số nguồn; không mock để lấp phân khu |
| 15 | **Q&A P0** — UC29/30 | Auth + Course/phân công + quan hệ riêng | Ask/answer/moderation/search/public/private đúng trạng thái; không tự duyệt | UAT-08 phần Q&A; đủ ASM3.8; chưa cần notification P1 |
| 16 | **Dashboard và báo cáo** — UC31–33 | CRM/Enrollment/Lịch/Attendance/Score/Finance đủ nguồn | KPI thật, cohort conversion, chuyên cần/điểm, nghĩa vụ/thu/nợ, đủ5 aggregates, drill-down | UAT-10; không JOIN nhân tổng, không trộn tiền thu/phải thu; Teacher chỉ lớp mình |
| 17 | **Kiểm thử xuyên suốt và bàn giao MVP P0** | Các bước trên đạt gate |31 UC P0 có bằng chứng; WAR/migration/install docs/ERD/URL map/demo luồng, main chạy được | UAT-01–10 phần P0, QG01–12, không lỗi nghiêm trọng quyền/tài chính; báo thật giới hạn môi trường |

**Lý do tách Finance A/B:** Ghi danh bắt buộc sinh Invoice trong cùng transaction; màn thu tiền lại cần Enrollment/Invoice thật. Viết invoice factory trước, tích hợp ghi danh, rồi hoàn thiện thu tiền giúp cắt vòng phụ thuộc mà vẫn không tạo dữ liệu mock trên UI. Bước9 là bàn giao kỹ thuật, chưa đánh dấu toàn bộ UC25 hoàn tất cho đến bước10 chứng minh end-to-end.

Bước6 cũng chưa thể tuyên bố toàn bộ chống trùng Student đã nghiệm thu khi chưa có membership thật; phải khép gate với bước10. Không nhận việc “lịch đã xong” chỉ vì calendar hiển thị đẹp.

## 3. Thứ tự P1 sau khi P0 ổn định

| Thứ tự | Use case | Feature/spec gốc | Phụ thuộc và nghiệm thu |
|---|---|---|---|
| P1-1 | UC18 Chuyển lớp/bảo lưu | feat-enrollment FR-007–011 | Cần EnrollmentHistory, khóa nhiều Class/Student, lịch và Finance ledger; UAT-11, không mất buổi/điểm/Invoice cũ |
| P1-2 | UC21 Nhật ký giảng dạy | feat-attendance-journal FR-006/008 | Cần buổi/Teacher/Attendance/portal; tối đa một journal/buổi, chỉ công bố sau COMPLETED |
| P1-3 | UC28 Thông báo | feat-notifications-qa FR-009–012 | Cần sự kiện commit lịch/điểm/attendance/finance, recipient/guardian và event key; replay không trùng, không lộ điểm nháp/PII |
| P1-4 | UC35 Màn hình audit | feat-system-administration FR-007/008 | Dữ liệu log đã ghi từ P0; lọc/page/chi tiết an toàn, chỉ ADMIN, không sửa/xóa |

P1 có đầy đủ đặc tả từ đầu; chỉ thứ tự code được hoãn. Nếu nguồn lực cho phép, nhật ký và UI audit có thể làm sớm sau khi đủ phụ thuộc, nhưng không bỏ kiểm thử P0 hoặc đẩy scope giai đoạn2 vào MVP.

## 4. Chia việc cho ba thành viên

- **Member01:** bước3/4/6/12/13 và P1 journal; bàn giao DTO/query lịch, roster, điểm công bố, công thức cho Member02/03.
- **Member02:** bước5/7/8/10/14/15 và P1 thông báo/chuyển lớp; nhận invoice factory từ Member03 trước tích hợp ghi danh.
- **Member03:** bước0/1/2/9/11/16, ledger/audit/role và P1 audit; hỗ trợ transaction chung bước10.

Đây là phân công dự án, không có agent hay tác vụ nền nào được tự tạo. Chỉ làm song song phần đủ dependency; thống nhất migration/service contract trước khi sửa shared Entity hoặc các Filter. Tính năng đạt Definition of Done thì commit/push hoặc merge main theo AGENTS.md; không để main ở trạng thái nửa tích hợp.

## 5. Hành động tiếp theo cụ thể

Bắt đầu bằng **rà soát nền hiện tại và auth v2**, không code CRM/ghi danh ngay. `.specify/feature.json` trỏ feat-auth-rbac để lệnh plan tiếp theo mở đúng feature. Sau mỗi bước cập nhật trạng thái thực tế trong future-work/shared_context kèm bằng chứng; không đổi Locked của spec thành “code hoàn thành”.
