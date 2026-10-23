# Hợp đồng dữ liệu và công thức dùng chung

**Version:** 1.0.0 | **Date:** 2026-10-23 | **Status:** Locked — baseline đặc tả nội bộ.

Nguồn gốc: SRS VII, [thiết kế DB hiện tại](../../docs/database/DATABASE_DESIGN.md), [schema hiện tại](../../docs/database/EduCenter_Schema_SQLServer.sql). Đây là **mô hình đích**, không tuyên bố mọi trường/ràng buộc đã có. Không chạy migration trong đợt viết spec. Mỗi thay đổi schema phải có migration giữ dữ liệu và cập nhật Entity trước tính năng phụ thuộc.

## 1. Định danh, kiểu và quy ước

- Giữ tên bảng hiện tại. Domain entity `EduClass` ánh xạ `Classes`; không tạo entity/bảng tên `Class` song song.
- PK thông thường BIGINT IDENTITY / Long; Roles dùng INT / Integer; UserRoles dùng cặp user_id/role_id. Không đổi ID hiện hữu sang UUID.
- Tiếng Việt dùng NVARCHAR; tiền DECIMAL(18,2)/BigDecimal, VND. Input tiền có quá 2 số lẻ bị từ chối; kết quả tính tỷ lệ ưu đãi làm tròn HALF_UP đến 2 số lẻ một lần khi chốt snapshot. Không dùng double cho tiền.
- Ngày nghiệp vụ DATE; session_date + start_at/end_at TIME theo Asia/Ho_Chi_Minh. Không diễn giải TIME như timestamp UTC. Buổi không qua nửa đêm; end_at>start_at. created_at/confirmed_at theo cùng múi giờ nghiệp vụ đã cấu hình, không theo tùy ý máy chạy.
- Mã nghiệp vụ trim, không rỗng, duy nhất không phân biệt hoa/thường theo collation đã thống nhất. Email trim/lowercase Locale.ROOT; không tự bỏ dấu chấm hoặc phần +tag.
- Mọi query dùng ID và bind parameter; sort allowlist. DTO trả dữ liệu cần cho view và đã lọc quyền; không giữ EntityManager mở qua JSP hoặc session.
- Trạng thái là code ổn định bên dưới, label Việt Nam ở view. Dropdown nghiệp vụ lấy lựa chọn hợp lệ từ backend; không hardcode danh sách môn, lớp, người nhận hoặc dữ liệu mẫu trong JSP.
- optimistic version cho sửa thông thường; khóa dữ liệu ổn định cho nghiệp vụ đếm/đối chiếu. Chỉ @Version trên Class nhưng không cập nhật/khóa Class khi tạo Enrollment **không đủ** bảo vệ capacity.

## 2. Danh mục đủ 30 bảng nghiệp vụ SRS

Các cột thông dụng created_at/updated_at, FK và miền dữ liệu chi tiết kế thừa DATABASE_DESIGN; bảng dưới chốt chủ sở hữu, khóa tự nhiên, vòng đời và ràng buộc liên module.

| Bảng | Chủ sở hữu ghi / feature | Khóa/quan hệ và bất biến | Trạng thái / dữ liệu cốt lõi |
|---|---|---|---|
| Users | auth-rbac | email duy nhất chuẩn hóa; nhiều role qua UserRoles; không hard delete User có lịch sử | ACTIVE/INACTIVE/LOCKED; password_hash không trả view; full_name/phone/avatar |
| Roles | auth-rbac | code duy nhất, không cho thêm quyền tùy ý từ form | ADMIN/STAFF/TEACHER/STUDENT/PARENT; ADMIN bao phủ Manager |
| UserRoles | auth-rbac | unique(user_id, role_id); ít nhất một role/User; bảo vệ ADMIN cuối | assigned_at; role mutation có audit |
| Leads | admission-crm; catalog chỉ tiếp nhận | người gửi, source, assigned_to, khóa quan tâm và liên kết chuyển đổi; không auto-gộp theo phone | NEW/CONTACTED/ASSESSED/CONSULTING/ENROLLED/LOST; LOST có lý do |
| Consultations | admission-crm | FK Lead và Staff; mỗi lần liên hệ là một record, sửa có audit | notes, contacted_at, kết quả và next_contact_at |
| Subjects | academic-programs | code duy nhất; không ngừng khi còn Course OPEN | ACTIVE/INACTIVE; tên/mô tả |
| Courses | academic-programs | FK Subject; code duy nhất; grade 6–12, fee≥0, duration/total_sessions/max_capacity>0 | OPEN/CLOSED/ARCHIVED; mục tiêu/trình độ/phút mỗi buổi; không sửa snapshot Invoice |
| Classes | class-timetable | FK Course/Teacher/Room; code duy nhất; capacity>0 và≤Room.capacity; ONE_TO_ONE=1 | PLANNING/OPEN/ONGOING/CLOSED/CANCELLED; start/end date; @Version |
| Rooms | class-timetable | code duy nhất; capacity>0; một cơ sở; không bảo trì khi chưa xử lý buổi tương lai | AVAILABLE/MAINTENANCE |
| ClassSessions | class-timetable | FK Class, người thực dạy/Room; unique lịch sinh theo class/date/start; không chồng tài nguyên | SCHEDULED/IN_PROGRESS/COMPLETED/CANCELLED/RESCHEDULED; rescheduled_from_id, makeup_for_id |
| Students | student-guardian | User tùy chọn và duy nhất nếu có; grade 6–12, dob không tương lai | STUDYING/RESERVED/DROPPED/GRADUATED; trường/mục tiêu/liên hệ |
| Guardians | student-guardian | User PARENT duy nhất, phone bắt buộc; không tự xác thực | ACTIVE/INACTIVE; họ tên/liên hệ tối thiểu |
| StudentGuardians | student-guardian | unique(student_id,guardian_id); verified_by/at; revoked_by/at/reason bổ sung | Có quyền khi verified_at có giá trị, chưa revoked, User/Guardian hoạt động; is_primary chỉ phục vụ nhận tin |
| Teachers | teacher-management | User TEACHER duy nhất; public fields được duyệt, nội bộ không public | ACTIVE/ON_LEAVE/INACTIVE; nhiều môn qua TeacherSubjects; hourly_rate chỉ tham khảo |
| Enrollments | enrollment | FK Student/Class; không trùng ACTIVE/RESERVED cùng cặp; chỉ ACTIVE chiếm chỗ; initial_invoice duy nhất | ACTIVE/RESERVED/TRANSFERRED/DROPPED/COMPLETED; ngày hiệu lực, source_lead_id, previous_enrollment_id |
| RegistrationCartItems | course-catalog | unique(user_id,course_id), quantity=1 trong dịch vụ; notes tối đa 500; Guest không có row DB | Lựa chọn không giữ chỗ, chỉ phí dự kiến; refresh Course trước xác nhận |
| Attendances | attendance-journal | unique(session_id,student_id); roster theo ngày; correction audit, không DELETE | PRESENT/ABSENT_EXCUSED/ABSENT_UNEXCUSED/LATE; marked_by/time, version |
| TeachingJournals | attendance-journal | unique(session_id); giáo viên thực dạy hoặc ADMIN correction | content/homework/comment; công khai sau COMPLETED |
| Assessments | assessment-progress | FK Class; ENTRANCE/MID_TERM/FINAL/PERIODIC; max_score>0, weight>0 | DRAFT/PUBLISHED; ngày kiểm tra, published_by/at, version; correction có audit |
| AssessmentScores | assessment-progress | unique(assessment_id,student_id), 0≤score≤max_score ở Service; không có row nghĩa chưa nhập | score/remark/graded_by/at; không public nếu Assessment DRAFT |
| Invoices | tuition-payment | FK Enrollment/Student, invoice_code duy nhất; một initial Invoice/Enrollment; snapshot bất biến sau phát hành | UNPAID/PARTIALLY_PAID/PAID/CANCELLED; total_amount/discount_amount/final_amount/due_date/version |
| InvoiceItems | tuition-payment | FK Invoice; quantity>0, unit_price≥0, amount=unit_price*quantity; bất biến sau phát hành | mô tả nghĩa vụ và snapshot giá, không dùng sửa âm trực tiếp để hoàn tiền |
| Payments | tuition-payment | FK Invoice; payment_code duy nhất, amount>0, xác nhận bởi User có quyền | CONFIRMED gốc; CASH/BANK_TRANSFER ở MVP; amount/method/ref/paid_at/confirmed_at |
| Discounts | tuition-payment | code duy nhất; loại PERCENTAGE/FIXED_AMOUNT, ngày hợp lệ, điều kiện/mức trần, ADMIN duyệt | ACTIVE/EXPIRED/DISABLED; không xuất coupon trên public |
| Questions | notifications-qa | tác giả/khóa, PUBLIC/PRIVATE, title/content có giới hạn; moderation không tự duyệt | PENDING/APPROVED/REJECTED/HIDDEN; moderator/time/reason, version |
| Answers | notifications-qa | FK Question/author, Teacher đúng phạm vi; công khai chỉ khi cả cha/con APPROVED | PENDING/APPROVED/REJECTED/HIDDEN; moderator/time/reason, version |
| Notifications | notifications-qa | FK recipient, unique(recipient,event_key) cho sự kiện, đích kiểm quyền lại | TIMETABLE/ATTENDANCE/GRADE/TUITION/GENERAL; read_at và is_read nhất quán |
| AuditLogs | system-administration (dịch vụ chung) | append-only; actor/entity/action/time/before/after/reason; không password/token | Thiếu audit trọng yếu thì rollback nghiệp vụ, không dùng log ứng dụng thay dữ liệu audit |
| SystemSettings | system-administration | setting_key duy nhất, allowlist/type/range; không secrets DB/SMTP | setting_value, updated_by/at/version; áp dụng cho giao dịch tương lai |
| TrialAssessments | admission-crm | FK Lead/Subject/evaluator, loại TRIAL/ENTRANCE, lịch phòng/giáo viên; cùng khóa tài nguyên với ClassSession | SCHEDULED/COMPLETED/CANCELLED; score null hoặc 0–10; test_date/time và notes |

## 3. Phần mở rộng cần migration (không âm thầm coi đã có)

SRS nói **30 bảng đề xuất**, không giới hạn tuyệt đối số bảng hỗ trợ. Schema đang có thêm PasswordResetTokens cho reset an toàn. Baseline không bỏ bảng nào trong 30 bảng; đề xuất 6 bảng hỗ trợ nghiệp vụ/hạ tầng dưới đây. Khi triển khai, mỗi migration phải có rà soát dữ liệu cũ, không chỉ CREATE trên DB trắng.

| Bảng hỗ trợ | Vì sao cần | Trường/khóa tối thiểu và quy tắc |
|---|---|---|
| PasswordResetTokens (đã có trong schema) | UC03: token một lần có thời hạn | user_id, token_hash unique, expires_at, consumed_at; chỉ hash, khóa khi tiêu thụ; transaction chung với đổi password |
| TeacherSubjects (đích) | UC12: nhiều môn định danh, tìm/phân công không parse văn bản | PK(teacher_id,subject_id), FK; không suy quyền tài khoản từ quan hệ môn |
| LeadCourses (đích) | Giữ các lựa chọn gửi giỏ và đối chiếu CRM không parse notes | PK(lead_id,course_id); snapshot code/name/fee/notes; không xóa khi Course archive |
| EnrollmentHistory (đích) | BR08 và báo cáo phải giữ roster tại ngày trước chuyển/bảo lưu | enrollment_id, status, effective_from/to, actor, reason; khoảng [from,to), không chồng; status hiện tại và history đổi cùng transaction |
| ScheduleExceptions (đích) | BR07: phê duyệt ngoại lệ từng Student/cặp buổi | student_id, hai session_id sắp thứ tự, phiên bản ngày/giờ hai buổi, approved_by/at/reason, revoked_at; unique cặp còn hiệu lực; ADMIN duyệt; dời buổi vô hiệu ngoại lệ cũ |
| FinancialAdjustments (đích) | WF-04: hoàn một phần/điều chỉnh/hủy thu vẫn append-only | invoice_id, payment_id tùy loại, kind CHARGE/CREDIT/VOID_PAYMENT/REFUND, amount>0, effective_at, actor/approved_by/time/reason/reference, request_key unique; ghi rồi không sửa/xóa |
| IdempotencyKeys (đích) | Bảo vệ submit lặp khác session sau retry và kết quả commit | unique(actor_scope,operation,key_hash), payload_hash, result_entity/type/id; lưu nguyên tử cùng nghiệp vụ, replay đúng payload trả cùng kết quả, khác payload bị chặn; Guest scope là session nonce bền qua login |

Các cột bổ sung phải được lập kế hoạch rõ: course.level/session_minutes; class.class_type; Lead conversion/lost reason; Trial lịch/loại/status; session links/version; guardian revocation; audit reason; published metadata; discount approval/snapshot; Payment.confirmed_at; optimistic version; Notification.event_key. Các CHECK/UNIQUE chưa có trong DDL hiện tại phải bổ sung sau khi xử lý dữ liệu cũ.

Không thể hoàn thành P1 chuyển/bảo lưu/nhật ký/thông báo/audit UI bằng cách gán status ngoài CHECK hiện tại. Với P0 báo cáo lịch sử, EnrollmentHistory là tiền đề dù UC18 P1 chưa bật.

## 4. Công thức tài chính duy nhất

Ký hiệu theo một Invoice và thời điểm chốt T:

```text
gross               = SUM(InvoiceItems.amount)
base_due            = gross - approved_discount_snapshot
charges             = SUM(CHARGE.amount đến T)
credits             = SUM(CREDIT.amount đến T)
obligation          = base_due + charges - credits
receipts            = SUM(Payments.amount đã CONFIRMED, paid_at <= T)
voided_receipts      = SUM(VOID_PAYMENT.amount đến T)
refunds             = SUM(REFUND.amount đến T)
net_collected       = receipts - voided_receipts - refunds
outstanding_debt    = obligation - net_collected
```

- Luôn obligation≥0, net_collected≥0, outstanding_debt≥0 sau commit. Không dùng max(0, ...) để che dữ liệu âm. Từ chối giao dịch làm sai bất biến.
- CHARGE/CREDIT thay nghĩa vụ; VOID_PAYMENT sửa khoản thu nhập sai không có tiền chi; REFUND có dòng tiền trả lại thật. Không ghi VOID và REFUND cho cùng phần tiền. Tổng VOID+REFUND trên mỗi Payment không vượt Payment.amount.
- Giảm nghĩa vụ xuống dưới thu ròng phải kèm hoàn được duyệt trong cùng transaction hoặc từ chối. Hủy hóa đơn yêu cầu thu ròng=0, credit về nghĩa vụ0 và audit trước chuyển CANCELLED. Invoice miễn phí obligation=0/collected=0/debt=0 có PAID hợp lệ.
- Invoice tổng hợp UNPAID khi thu ròng=0 và nghĩa vụ>0; PARTIALLY_PAID khi 0<thu ròng<nghĩa vụ; PAID khi debt=0; CANCELLED do quy trình hủy. status/version có thể cập nhật như projection; snapshot tiền gốc và bút toán không bị sửa.
- Schema legacy có Payment.CANCELLED/REFUNDED. Migration phải chuyển lịch sử thành bút toán bù có tham chiếu rồi chuẩn hóa quy ước tính tổng, kiểm đối soát trước/sau; không vừa loại Payment khỏi receipts vừa trừ reversal lần nữa. Không tạo ngày/actor hoàn giả nếu thiếu bằng chứng: đánh dấu cần đối soát dữ liệu cũ.
- Thu theo kỳ dùng paid_at, hoàn theo effective_at của bút toán chi; dư nợ đến ngày chốt dùng toàn bộ sự kiện đến T. Thu kỳ này không đồng nghĩa nghĩa vụ phát hành kỳ này. Report financial source phải aggregate từng tập trước JOIN.

Ví dụ nghiệm thu: hóa đơn1.000.000, thu400.000→debt600.000; thu600.000→debt0; CREDIT200.000+REFUND200.000 nguyên tử→obligation800.000/net_collected800.000/debt0. Hai Payment gốc vẫn nguyên vẹn. Không làm tròn từng card hay trừ refund hai lần.

## 5. Roster, chuyên cần và điểm

- Membership tại thời điểm t lấy từ EnrollmentHistory có status ACTIVE và from≤t<to (to rỗng là vô hạn); giới hạn thêm start_date/end_date Enrollment. Tạo Enrollment phải mở lịch sử ACTIVE cùng transaction. Chuyển/bảo lưu đóng khoảng cũ, không cập nhật ngược quá khứ đã điểm danh nếu chưa có correction ADMIN.
- Roster Attendance dùng ngày/giờ buổi; roster Assessment dùng ngày kiểm tra. Nếu dữ liệu cũ chưa có lịch sử thì cần migration từ bằng chứng nguồn/audit; không suy toàn bộ quá khứ từ status hiện tại.
- Chuyên cần = 100*(PRESENT+LATE)/số buổi COMPLETED đủ membership trong kỳ. Attendance chưa nhập không tạo điểm danh vắng giả; báo riêng số thiếu và chưa tính có mặt. Không mẫu số: “Chưa có dữ liệu”. Hủy/dời lịch cũ không vào mẫu số.
- normalized_score = score/max_score*10. weighted_average = SUM(normalized_score*weight)/SUM(weight) chỉ trên score đã nhập, Assessment PUBLISHED, phạm vi/lọc đúng. MIN/MAX cũng cùng tập. Kết quả hiển thị làm tròn HALF_UP 2 số lẻ; không làm tròn trước SUM.
- Baseline đầu vào là ENTRANCE PUBLISHED sớm nhất của Student trong Course; nếu cùng ngày tie-break assessment.id. Tiến bộ = normalized điểm mới nhất - baseline. Không baseline hoặc chưa có lần sau: thông báo thiếu mốc, không đường tăng giả. Trial CRM không tự công bố.
- Teacher nhập/chốt điểm khi là giáo viên chính đang được giao Class và User/Teacher ACTIVE, hoặc ADMIN có quyền; người dạy thay một buổi chỉ có quyền Attendance/Journal buổi đó. Sửa điểm PUBLISHED phải qua correction ADMIN theo spec.

## 6. Dữ liệu và quyền giám hộ

parent.user_id phải trùng actor, Guardian ACTIVE, liên kết verified chưa revoked, Student đúng ID; liên kết được kiểm lại ở mỗi request, bao gồm tuition/receipt/chart/notification. Student tự đọc yêu cầu Student.user_id=actor; không match theo tên/email/phone. Số điện thoại chung không là bằng chứng giám hộ. ADMIN quản trị phải có ngữ cảnh nghiệp vụ, không tạo phiên mạo danh. Khi Phụ huynh đăng ký tài khoản có cung cấp email học sinh trùng khớp với hồ sơ học viên đã có trong hệ thống, hệ thống hỗ trợ cơ chế tự động liên kết và xác thực (auto-verify) để phụ huynh có thể truy cập cổng thông tin của con ngay lập tức.

## 7. Dữ liệu nhạy cảm, lưu giữ và bàn giao

Không secrets/token/password thô trong audit, DTO, URL success hoặc flash. Audit before/after che dữ liệu nhạy cảm không cần đối soát, vẫn giữ ID/actor. Không hard delete dữ liệu tài chính/ghi danh/điểm danh/audit. Baseline không tự đặt thời hạn pháp lý xóa dữ liệu; chính sách lưu giữ cần được chủ trung tâm chốt khi vận hành thật. Dữ liệu demo được seed ở DB kiểm thử riêng, không đưa tài khoản demo hoặc hướng dẫn thử vào UI.
