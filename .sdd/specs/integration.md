# Hợp đồng tích hợp, giao dịch và phân quyền

**Version:** 1.0.0 | **Date:** 2026-10-23 | **Status:** Locked — baseline nội bộ.

## 1. Một chủ sở hữu cho mỗi nghiệp vụ

MVC bắt buộc: Browser → Encoding/Auth/Role/CSRF Filter → Servlet → Service → JPA Repository → Hibernate → SQL Server. Service là nơi kiểm nghiệp vụ/quyền bản ghi và điều phối EntityTransaction; Repository không tự commit, Servlet không mở transaction, JSP chỉ JSTL/EL. Persistence unit EduCenterPU; tạo/đóng EntityManager theo một use case, rollback khi lỗi, đóng trong finally. DTO đã load đủ trước khi đóng, không lazy-load từ JSP.

| Bên ghi / chủ sở hữu | Dữ liệu cấp cho bên đọc | Điều không được làm |
|---|---|---|
| Member 03 / auth | principal hiện hành, role/status/credential version | Module khác tự nâng quyền hoặc tin role trong form |
| Member 01 / academic-programs, teacher, class-timetable | khóa/giáo viên/lớp/buổi thật và khả dụng | Catalog hardcode lịch/giáo viên hoặc giữ một bản Course khác |
| Member 02 / CRM, Student/Guardian, enrollment | Lead conversion, Student, quan hệ verified và membership history | Finance tự tạo Enrollment; Parent tự xác thực quan hệ |
| Member 01 / attendance, assessment | chuyên cần sau COMPLETED, điểm PUBLISHED và công thức nguồn | Portal tự suy điểm nháp đã được công bố hoặc dùng dữ liệu showcase |
| Member 03 / finance | invoice/receipt/balance và ledger nghĩa vụ/thu/hoàn | Portal/CRM tự sửa Invoice/Payment hoặc tự tính cách khác |
| Member 02 / communication | Question/Answer duyệt, notification đúng recipient | Module khác ghi thẳng nội dung công khai để bỏ moderation |
| Member 03 / administration/reporting | settings allowlist, audit bền vững, report có nguồn | Xóa log, thêm key chạy SQL/shell, tạo KPI mẫu khi thiếu nguồn |

## 2. Ma trận quyền chuẩn (D01)

“Được giao” và “của mình/con” là điều kiện Service bắt buộc sau route Filter. ADMIN bao gồm hai trách nhiệm System Admin + Center Manager trong SRS. Khi một User có nhiều role, kiểm từng hành động hợp lệ và không cấp quyền rộng hơn chỉ vì UI đã chọn role khác.

| Hành động | ADMIN | STAFF | TEACHER | STUDENT | PARENT | Guest |
|---|---|---|---|---|---|---|
| Tạo User nội bộ / role / status / settings / đọc audit | Có | Không | Không | Không | Không | Không |
| Profile/password | Cá nhân | Cá nhân | Cá nhân | Cá nhân | Cá nhân | Chỉ đăng ký/khôi phục |
| Public catalog / giỏ / gửi nhu cầu | Đọc; gửi public theo route | Đọc; gửi public theo route | Đọc; gửi public theo route | Có | Có | Có qua session |
| Lead nội bộ | Toàn bộ / phân công | Được giao | Chỉ lịch thử được giao | Không | Không | Không |
| Môn/khóa/Teacher/Room/Class/Timetable | CRUD | CRUD hợp lệ | Chỉ đọc được giao | Lớp/lịch mình | Lớp/lịch con verified | Nội dung công khai |
| Student/Guardian/verify | CRUD/verify | CRUD/verify | Tối thiểu roster lớp mình | Hồ sơ mình đọc | Con verified đọc | Không |
| Enrollment / transfer / reserve | Có / duyệt ngoại lệ | Có, không tự duyệt ngoại lệ | Không | Chỉ xem | Chỉ xem | Không |
| Attendance/Journal | Đọc/correction có lý do | Đọc | Ghi buổi thực dạy | Kết quả COMPLETED | Kết quả COMPLETED con | Không |
| Assessment/Score | Ghi/correction/công bố | Đọc nghiệp vụ | Ghi/chốt lớp chính được giao | PUBLISHED mình | PUBLISHED con | Không |
| Invoice/Payment/receipt | Có | Lập/thu/đọc | Không | Phí mình | Phí con | Không |
| Discount/charge/credit/void/refund | Duyệt/ghi có audit | Chỉ áp ưu đãi đã duyệt, không phê duyệt | Không | Không | Không | Không |
| Reports | Toàn trung tâm | Theo nghiệp vụ ở màn hình staff | Học vụ lớp mình | Cá nhân portal | Con portal | Không |
| Question | Xử lý | Xử lý | Đọc/answer đúng khóa | Hỏi/bài mình | Hỏi/bài mình | Chỉ PUBLIC APPROVED |
| Duyệt Q&A | Có, khác tác giả | Có, khác tác giả | Không | Không | Không | Không |
| Notification | Gửi và inbox cá nhân | Gửi đúng phạm vi / inbox | Inbox mình | Inbox mình | Inbox mình | Không |

Routes /admin chỉ ADMIN; /staff STAFF/ADMIN; /teacher TEACHER/ADMIN; /student STUDENT/ADMIN; /parent PARENT/ADMIN. Route được phép không bỏ điều kiện bản ghi. Home/catalog vẫn public sau login. /questions public chỉ trả nội dung được duyệt; /notifications và mọi mutation Q&A cần auth phù hợp. /profile mọi tài khoản đã đăng nhập hợp lệ.

## 3. Hợp đồng điều phối ghi danh → hóa đơn

### Input và output

Input: actor từ session đã refresh, request key, Student ID, Class ID, ngày bắt đầu, Lead ID tùy chọn, Discount ID đã duyệt tùy chọn, lý do/ngoại lệ lịch nếu có. Không tin fee/remainingSeats/roles/studentOwner gửi từ browser.

Output khi commit: Enrollment ID, initial Invoice ID/code, Student ID, Lead ID nếu chuyển đổi, snapshot tổng phí và redirect target ADM-15. Validation trả lỗi trường/mã nghiệp vụ và input an toàn, không Entity hoặc exception stacktrace.

### Các bước trong một transaction

1. Recheck actor và system.admissions_open; nhận khóa request/idempotency và đối chiếu payload. Tiếp nhận Lead public cũng kiểm tra cờ tuyển sinh ở Service; đóng tuyển sinh không khóa quyền đọc/đăng nhập.
2. Khóa Student; khóa Course liên quan và Class đích theo thứ tự ổn định; reload status/khả dụng/phí.
3. Kiểm tra Student, lớp OPEN/ONGOING, Course OPEN, ACTIVE/RESERVED trùng, capacity, toàn bộ lịch và ngoại lệ đã duyệt.
4. Tạo Enrollment ACTIVE + khoảng EnrollmentHistory. Finance lập Invoice/Items/snapshot bằng **chính EntityManager và transaction đang chạy**. Finance không begin/commit riêng.
5. Nếu từ Lead: khóa Lead, kiểm tra chưa chuyển sang Enrollment khác; gắn Student/Enrollment, cập nhật ENROLLED, không tạo Student lần nữa nếu đã chọn hồ sơ có sẵn.
6. Ghi audit và kết quả IdempotencyKeys. Commit một lần. Sau commit mới báo thành công/clear form và redirect. Notification P1 có thể cùng transaction hoặc xử lý sau commit có key sự kiện; lỗi kênh thông báo không được trả rằng Enrollment thất bại khi nó đã commit.

Nếu phí/khóa đổi so với form đã xem: yêu cầu xác nhận lại phí hiện hành trước commit, không chốt giá cũ ngầm. Mã lỗi: DUPLICATE_ENROLLMENT, CLASS_FULL, CLASS_NOT_ENROLLABLE, STUDENT_SCHEDULE_CONFLICT, FEE_CHANGED, STALE_VERSION, INVALID_INPUT, FORBIDDEN, SOURCE_UNAVAILABLE. Thông báo Việt rõ; không công khai ID/bản ghi của người ngoài quyền.

## 4. Hợp đồng tiền và các thao tác nhiều đối tượng

- Thu tiền: khóa Invoice, reload ledger/số dư, kiểm actor/amount/method/reference/request key; tạo Payment+audit+projection status nguyên tử. Không “check số dư ở GET rồi chỉ INSERT ở POST”. Bank reference chuẩn hóa trim và kiểm duy nhất cho phương thức chuyển khoản, không dùng phone/tên làm chứng từ.
- Điều chỉnh/hoàn/hủy: khóa Invoice và các Payment nguồn; ADMIN kiểm phần tiền chưa bù; ghi FinancialAdjustment append-only, chứng từ chi nếu REFUND, audit; không cập nhật số tiền Payment gốc. Dùng công thức data-contract trước commit để không âm nghĩa vụ/thu ròng/nợ.
- Chuyển lớp: khóa Student, Course liên quan, hai Class theo ID tăng dần, sau đó Invoice/Payment liên quan theo ID; kiểm đích/roster/lịch; đóng khoảng cũ và mở mới; liên kết previous_enrollment_id; adjustment phí được duyệt cùng transaction nếu có. Không tự lấy số buổi còn lại thành tiền hoàn.
- Bảo lưu/quay lại: đóng/mở lịch sử hiệu lực cùng đổi status; RESERVED không chiếm chỗ và không mất nghĩa vụ học phí. Quay lại không phát hành initial Invoice thứ hai.

## 5. Quy tắc khóa và tranh chấp

Toàn bộ Service dùng một thứ tự khóa khi nhiều loại tham gia: **User/Role bảo mật → Idempotency scope → Student → Course → Class → Teacher → Room → các lịch nguồn → Lead → Invoice → Payment**; các ID trong một loại tăng dần. Chỉ lấy các loại cần thiết. Không nâng khóa theo thứ tự ngược trong hàm con; điều phối ngoài phải biết toàn bộ tài nguyên cần khóa hoặc retry cả transaction khi phát hiện thay tài nguyên. Quy trình thay phân công/lịch không được khóa buổi trước rồi mới khóa Teacher/Room.

- Đếm ACTIVE Enrollment dưới khóa Class; thay membership và đổi capacity đều dùng cùng khóa. Unique filtered ACTIVE là phòng tuyến DB, không thay khóa/tính lại capacity. RESERVED trùng cũng phải chặn dưới khóa Student/Class; cần migration ràng buộc phù hợp nếu mở P1.
- Xếp lịch khóa Teacher/Room và Student liên quan trước truy vấn overlap. Mọi đường sinh/đổi buổi và TrialAssessment đều dùng cùng resource locks và truy vấn hợp nhất cả hai nguồn. Hai bảng lịch không được tự kiểm tra tách rời.
- Biên thời gian: cùng ngày, newStart<oldEnd AND newEnd>oldStart; chỉ CANCELLED/RESCHEDULED không chiếm tài nguyên. Ngày/giờ khác phiên bản làm ScheduleException cũ vô hiệu.
- Role/status bảo vệ ADMIN cuối khóa Role ADMIN rồi User theo ID như auth plan; không ghi role từ module Teacher/Student. Cấp/thu quyền phải audit trong cùng transaction.
- Idempotency có unique scope+operation+key_hash và payload_hash; không lưu raw token hoặc PII trong key. Tạo result cùng transaction. Tranh khóa/unique sau rollback phải truy lại kết quả đã commit; không báo success trước commit. Key lặp khác payload trả conflict. Receipt Guest chỉ session đã gửi, không mở rộng quyền bằng result key.
- Lỗi optimistic/deadlock: rollback toàn bộ, cho retry có giới hạn ở transaction boundary và giữ idempotency; hết retry trả thông báo xung đột để tải lại, không lặp mù khoản thu.

## 6. Publish, portal và thông báo

Attendance/Journal chỉ cho người học sau COMPLETED; AssessmentScore chỉ khi Assessment PUBLISHED. Quy tắc nằm ở Service/query DTO, áp dụng cả HTML, chart, export, notification, không chỉ c:if. Sửa điểm công bố mở DRAFT có ADMIN/lý do/audit; publish lại nguyên tử.

Parent scope dựa StudentGuardians verified chưa revoked **ở thời điểm request**. Notification có thể còn tồn tại sau thu hồi nhưng không trả payload PII/chi tiết con và link đích phải chặn. Thông báo không là bằng chứng cho quyền; Teacher chỉ xem buổi/lớp được giao hiện hành.

Q&A Answer chỉ public khi bản thân và Question đều APPROVED, Question PUBLIC. Sửa bài approved trở lại PENDING và giữ revision trong audit; không tự duyệt nội dung chính mình. Câu hỏi PRIVATE gắn Student/đối tượng nguồn nếu có và phải kiểm quyền nguồn khi đọc/trả lời; cần cột tham chiếu bổ sung khi triển khai.

## 7. Audit và báo cáo nhất quán

Các thay đổi role/status, StudentGuardian, phí/Invoice/Payment/adjustment, EnrollmentHistory, lịch/Teacher/Room, lớp tạo/mở/đóng/đổi capacity, điểm công bố/correction và settings phải có audit. Log cần actor, time, action/entity/id, before/after, reason và request/operation correlation; che secrets. Create/open/close Class cũng ghi trạng thái đầy đủ để báo cáo as-of từ baseline có nguồn lịch sử, không dựa status hiện tại cho quá khứ. Lịch sử trước baseline thiếu bằng chứng được báo hạn chế và cần đối soát, không bịa ngày trạng thái.

Báo cáo dùng cùng thời điểm snapshot cho một lần đọc; aggregate Payments/Adjustments/InvoiceItems riêng trước JOIN; COUNT DISTINCT ở đúng thực thể, không tính một Student nhiều lần vì nhiều Guardian. Định nghĩa cohort, mẫu số và ngày giao dịch ở data-contract/feature báo cáo. Khi nguồn lỗi không thay aggregate bằng 0.

## 8. Bàn giao giữa ba thành viên

Mỗi bàn giao có: version spec, migration tăng dần không trùng số, Entity/DTO và Service contract, input/output/mã lỗi, role/record scope, transaction owner, dữ liệu kiểm thử và bằng chứng. Tên Servlet trong module là tên logic đề xuất; đối chiếu mapping đang có bằng CodeGraph trước code, tái sử dụng controller hiện hữu nếu đúng trách nhiệm. URL đích và Screen ID tuân screen-map, không tạo route /manager hoặc /courses/{id} trùng chỉ do mockup.
