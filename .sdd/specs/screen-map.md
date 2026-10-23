# Danh mục 49 màn hình và hợp đồng điều hướng

**Version:** 1.0.0 | **Date:** 2026-10-23 | **Status:** Locked — baseline nội bộ.

ID chuẩn lấy từ SRS VIII, không lấy ID trùng nghĩa trong prototype. URL dưới đây là hợp đồng đích, không tuyên bố controller đã tồn tại. JSP là đường dẫn đích có thể tái dùng view hiện hữu cùng trách nhiệm khi lập plan; không tạo servlet/view trùng chỉ vì tên logic khác. Mọi POST có CSRF và PRG, kiểm role + bản ghi; GET luôn chỉ đọc. Form lỗi giữ input an toàn, không password/token. Các form phụ dùng GET /.../form?id= để tạo/sửa dưới cùng Screen ID.

| ID | Màn hình / GET | Quyền và điều kiện | POST được sở hữu | JSP đích | Feature | Input/hành vi chính |
|---|---|---|---|---|---|---|
| PUB-01 | Trang chủ: `/` | Guest/All | — | `/WEB-INF/views/public/home.jsp` | feat-course-catalog | Thông tin trung tâm/khóa/giáo viên từ DB; CTA tới catalog/tư vấn |
| PUB-02 | Danh sách khóa học: `/courses` | Guest/All | — | `/WEB-INF/views/public/course-list.jsp` | feat-course-catalog | keyword, subjectId, gradeLevel, targetExam, minFee, maxFee, sort, page; pageSize9 |
| PUB-03 | Chi tiết khóa học: `/courses/detail?id={id}` | Guest/All | `/registration-cart/add` | `/WEB-INF/views/public/course-detail.jsp` | feat-course-catalog | id; detail thật, lớp/lịch, tối đa3 liên quan, Course OPEN mới thêm |
| PUB-04 | Danh sách đăng ký: `/registration-cart` | Guest/Student/Parent | `/registration-cart/add`; `/registration-cart/update`; `/registration-cart/remove`; `/registration-cart/clear` | `/WEB-INF/views/public/registration-cart.jsp` | feat-course-catalog | courseId/notes; quantity1, tổng current fee, không giữ chỗ |
| PUB-05 | Xác nhận nhu cầu đăng ký: `/registration/confirm` | Guest/Student/Parent | `/registration/confirm` | `/WEB-INF/views/public/registration-confirm.jsp` | feat-course-catalog | liên hệ/grade/notes/nonce; revalidate phí/trạng thái, Lead chưa Enrollment |
| PUB-06 | Đăng ký tư vấn: `/consultation` | Guest/All | `/consultation` | `/WEB-INF/views/public/consultation.jsp` | feat-course-catalog | name/phone/email/grade/courseIds/requestType/preferredTime/notes/nonce |
| PUB-07 | Kết quả gửi yêu cầu: `/consultation/success` | Session đã gửi | — | `/WEB-INF/views/public/consultation-success.jsp` | feat-course-catalog | receipt persisted và session; code URL không cấp quyền |
| AUTH-01 | Đăng nhập: `/login` | Guest/All | `/login` | `/WEB-INF/views/auth/login.jsp` | feat-auth-rbac | email/password/redirect_url local; renew session |
| AUTH-02 | Đăng ký tài khoản: `/register` | Guest | `/register` | `/WEB-INF/views/auth/register.jsp` | feat-auth-rbac | name/email/phone/password/confirm/STUDENT hoặc PARENT |
| AUTH-03 | Quên mật khẩu: `/forgot-password` | Guest | `/forgot-password` | `/WEB-INF/views/auth/forgot-password.jsp` | feat-auth-rbac | email; phản hồi chung; không show link; SMTP thật |
| AUTH-04 | Đặt lại mật khẩu: `/reset-password` | Guest có token | `/reset-password` | `/WEB-INF/views/auth/reset-password.jsp` | feat-auth-rbac | token/password/confirm; validity/expiry thật, single-use30phút |
| AUTH-05 | Hồ sơ cá nhân: `/profile` | Đã login | `/profile` | `/WEB-INF/views/auth/profile.jsp` | feat-auth-rbac | action profile/password; dữ liệu actor, không sửa role/email |
| ADM-01 | Dashboard điều hành: `/admin/dashboard` | ADMIN | — | `/WEB-INF/views/admin/dashboard.jsp` | feat-dashboard-reporting | KPI/alerts/thời điểm/phạm vi thật |
| ADM-02 | Quản lý Lead: `/staff/leads` | ADMIN/STAFF được giao | `/staff/leads/save`; `/staff/leads/assign`; `/staff/leads/status` | `/WEB-INF/views/staff/lead-list.jsp` | feat-admission-crm | search/status/source/assignedTo/dates; phân công ADMIN |
| ADM-03 | Chi tiết tư vấn: `/staff/leads/detail?id={id}` | ADMIN/STAFF được giao | `/staff/leads/consultations/save`; `/staff/leads/trials/save`; `/staff/leads/convert` | `/WEB-INF/views/staff/lead-detail.jsp` | feat-admission-crm | leadId, liên hệ/lịch thử/kết quả; convert đi qua enrollment chung |
| ADM-04 | Quản lý khóa học: `/staff/courses` | ADMIN/STAFF | `/staff/subjects/save`; `/staff/subjects/delete`; `/staff/courses/delete` | `/WEB-INF/views/staff/course-list.jsp` | feat-academic-programs | CRUD môn; tìm/lọc khóa; delete là ngừng/archive khi liên quan |
| ADM-05 | Form khóa học: `/staff/courses/form` | ADMIN/STAFF | `/staff/courses/save` | `/WEB-INF/views/staff/course-form.jsp` | feat-academic-programs | code/name/subject/grade/target/level/fee/sessionMinutes/totalSessions/status/version |
| ADM-06 | Danh sách học viên: `/staff/students` | ADMIN/STAFF | `/staff/students/save`; `/staff/students/delete` | `/WEB-INF/views/staff/student-list.jsp` | feat-student-guardian | Student CRUD; id/name/dob/school/grade/goal/status; ngừng có kiểm tra |
| ADM-07 | Hồ sơ học viên: `/staff/students/detail?id={id}` | ADMIN/STAFF | `/staff/students/user-link` | `/WEB-INF/views/staff/student-detail.jsp` | feat-student-guardian | thông tin/lịch sử/quan hệ; link ghi danh ADM-12 |
| ADM-08 | Phụ huynh/người giám hộ: `/staff/guardians` | ADMIN/STAFF | `/staff/guardians/save`; `/staff/guardians/delete`; `/staff/guardians/link`; `/staff/guardians/verify`; `/staff/guardians/revoke` | `/WEB-INF/views/staff/guardian-list.jsp` | feat-student-guardian | guardian/student/relation/verification/reason; Parent không tự verify |
| ADM-09 | Giáo viên: `/staff/teachers` | ADMIN/STAFF | `/staff/teachers/save`; `/staff/teachers/delete` | `/WEB-INF/views/staff/teacher-list.jsp` | feat-teacher-management | User TEACHER, chuyên môn/subjectIds/publicFields/status/version |
| ADM-10 | Danh sách lớp: `/staff/classes` | ADMIN/STAFF | `/staff/classes/save`; `/staff/classes/close`; `/staff/classes/delete` | `/WEB-INF/views/staff/class-list.jsp` | feat-class-timetable | code/course/teacher/room/capacity/type/dates/status/version |
| ADM-11 | Chi tiết lớp: `/staff/classes/detail?id={id}` | ADMIN/STAFF | — | `/WEB-INF/views/staff/class-detail.jsp` | feat-class-timetable | id; roster/buổi/điểm/chuyên cần đúng nguồn; mutation qua route chuyên trách |
| ADM-12 | Ghi danh / chuyển lớp: `/staff/enrollments` | ADMIN/STAFF | `/staff/enrollments/save`; `/staff/enrollments/transfer`; `/staff/enrollments/reserve`; `/staff/enrollments/resume`; `/staff/enrollments/status` | `/WEB-INF/views/staff/enrollment-form.jsp` | feat-enrollment | Student/Class/start/Lead/Discount/requestKey; P1 transfer/reserve có duyệt phí |
| ADM-13 | Lịch học / phòng: `/staff/timetable` | ADMIN/STAFF | `/staff/timetable/generate`; `/staff/timetable/reschedule`; `/staff/timetable/substitute`; `/staff/timetable/cancel`; `/staff/timetable/exceptions`; `/staff/rooms/save`; `/staff/rooms/delete` | `/WEB-INF/views/staff/timetable.jsp` | feat-class-timetable | week/class/room/teacher; preview/nonce; exception chỉ ADMIN; Room CRUD |
| ADM-14 | Hóa đơn học phí: `/staff/invoices` | ADMIN/STAFF | `/staff/invoices/create` | `/WEB-INF/views/staff/invoice-list.jsp` | feat-tuition-payment | Student/Class/status/due; create idempotent chỉ initial Invoice còn thiếu hợp lệ |
| ADM-15 | Chi tiết hóa đơn / thu tiền: `/staff/invoices/detail?id={id}` | ADMIN/STAFF | `/staff/invoices/payment`; `/staff/invoices/adjust`; `/staff/invoices/refund`; `/staff/invoices/cancel` | `/WEB-INF/views/staff/invoice-detail.jsp` | feat-tuition-payment | Invoice/amount/method/ref/requestKey; adjust/refund/cancel ADMIN; print GET chỉ đọc |
| ADM-16 | Báo cáo thống kê: `/admin/reports` | ADMIN | — | `/WEB-INF/views/admin/reports.jsp` | feat-dashboard-reporting | from/to/subject/course/class/asOf; đúng định nghĩa cohort/ledger |
| ~~ADM-17~~ | *Duyệt Q&A: `/staff/questions`* | *Đã loại bỏ khỏi phạm vi theo D19* | — | — | feat-notifications-qa | *HỦY TRIỂN KHAI / OUT OF SCOPE* |
| ADM-18 | Quản lý tài khoản và quyền: `/admin/users` | ADMIN | `/admin/users`; `/admin/users/status`; `/admin/users/roles` | `/WEB-INF/views/admin/user-list.jsp` | feat-auth-rbac | action create/status/roles; targetId/roleCodes/actionStatus; filter status tách biệt |
| ADM-19 | Cấu hình và nhật ký: `/admin/settings` | ADMIN | `/admin/settings/save` | `/WEB-INF/views/admin/settings.jsp` | feat-system-administration | allowlist typed settings/version; tab audit P1 chỉ đọc |
| TCH-01 | Dashboard giáo viên: `/teacher/dashboard` | TEACHER/ADMIN theo phạm vi | — | `/WEB-INF/views/teacher/dashboard.jsp` | feat-class-timetable | lịch/lớp/tác vụ thật; có lịch thử được giao |
| TCH-02 | Lớp và lịch dạy: `/teacher/classes` | TEACHER/ADMIN theo phạm vi | — | `/WEB-INF/views/teacher/class-list.jsp` | feat-class-timetable | lớp/người thực dạy; link session; không lộ toàn trung tâm |
| TCH-03 | Điểm danh buổi học: `/teacher/attendance?sessionId={id}` | Người thực dạy/ADMIN correction | `/teacher/attendance/save`; `/teacher/attendance/start`; `/teacher/attendance/complete`; `/teacher/attendance/correct` | `/WEB-INF/views/teacher/attendance.jsp` | feat-attendance-journal | sessionId, roster/status/notes/version; COMPLETED sửa ADMIN có lý do |
| TCH-04 | Nhật ký giảng dạy: `/teacher/journal?sessionId={id}` | Người thực dạy/ADMIN correction | `/teacher/journal/save`; `/teacher/journal/correct` | `/WEB-INF/views/teacher/journal.jsp` | feat-attendance-journal | session/content/homework/comments/version; UC21 P1 |
| TCH-05 | Bài kiểm tra: `/teacher/assessments` | Teacher chính lớp/ADMIN | `/teacher/assessments/save`; `/teacher/assessments/delete` | `/WEB-INF/views/teacher/assessment-list.jsp` | feat-assessment-progress | class/type/date/maxScore/weight; report học vụ lớp được giao |
| TCH-06 | Nhập và công bố điểm: `/teacher/scores?assessmentId={id}` | Teacher chính lớp/ADMIN | `/teacher/scores/save`; `/teacher/scores/publish`; `/teacher/scores/reopen` | `/WEB-INF/views/teacher/scores.jsp` | feat-assessment-progress | assessmentId/score/remark/version; reopen ADMIN có lý do |
| STD-01 | Dashboard học viên: `/student/dashboard` | STUDENT của mình | — | `/WEB-INF/views/student/dashboard.jsp` | feat-student-parent-portal | hồ sơ User liên kết, lịch/tiến bộ tóm tắt thật |
| STD-02 | Lịch học và lớp của tôi: `/student/schedule` | STUDENT của mình | — | `/WEB-INF/views/student/schedule.jsp` | feat-student-parent-portal | lớp/giai đoạn; thay đổi lịch thật |
| STD-03 | Kết quả học tập: `/student/progress` | STUDENT của mình | — | `/WEB-INF/views/student/progress.jsp` | feat-student-parent-portal | PUBLISHED/chuyên cần COMPLETED/journal có thật |
| STD-04 | Học phí của tôi: `/student/tuition` | STUDENT của mình | — | `/WEB-INF/views/student/tuition.jsp` | feat-tuition-payment | Invoice/balance/receipt của mình; không nút trả tiền online |
| PAR-01 | Dashboard phụ huynh: `/parent/dashboard` | PARENT verified | — | `/WEB-INF/views/parent/dashboard.jsp` | feat-student-parent-portal | bộ chọn con từ StudentGuardians verified chưa revoked |
| PAR-02 | Hồ sơ theo dõi con: `/parent/children/detail?id={id}` | PARENT verified con chọn | — | `/WEB-INF/views/parent/child-detail.jsp` | feat-student-parent-portal | id Student; lịch/chuyên cần/điểm PUBLISHED/phí riêng |
| PAR-03 | Học phí và thông báo: `/parent/tuition` | PARENT verified con chọn | — | `/WEB-INF/views/parent/tuition.jsp` | feat-tuition-payment | studentId; học phí/notification đúng con, link COM-03 |
| ~~COM-01~~ | *Danh sách câu hỏi: `/questions`* | *Đã loại bỏ khỏi phạm vi theo D19* | — | — | feat-notifications-qa | *HỦY TRIỂN KHAI / OUT OF SCOPE* |
| ~~COM-02~~ | *Chi tiết/đặt câu hỏi: `/questions/detail?id={id}`* | *Đã loại bỏ khỏi phạm vi theo D19* | — | — | feat-notifications-qa | *HỦY TRIỂN KHAI / OUT OF SCOPE* |
| COM-03 | Thông báo cá nhân: `/notifications` | Đã login, của mình | `/notifications/read`; `/notifications/send` | `/WEB-INF/views/common/notifications.jsp` | feat-notifications-qa | read chỉ recipient; send STAFF/ADMIN đúng phạm vi; UC28 P1 |
| SYS-01 | Không có quyền: `/errors/403` | All | — | `/WEB-INF/views/common/403.jsp` | feat-auth-rbac | HTTP403, không lộ dữ liệu; link về trang được phép |
| SYS-02 | Không tìm thấy: `/errors/404` | All | — | `/WEB-INF/views/common/404.jsp` | feat-auth-rbac | HTTP404, không lộ stacktrace; link home/search |

## Route bổ sung trong cùng màn hình

- GET /logout: xác nhận, POST /logout: hủy session; thuộc AUTH-01, không mutation bằng GET.
- GET /questions/new: tạo câu hỏi, GET /questions/edit?id=: sửa bài của mình; POST /questions/save hoặc /questions/update; thuộc COM-02.
- GET /staff/rooms và /staff/rooms/form: tab/form phòng của ADM-13, có thể truy cập trực tiếp để quản lý UC34.
- GET /staff/trials: tab lịch thử của ADM-03; POST /staff/leads/trials/save xử lý booking/result đúng actor. Teacher xem lịch thử được giao ở TCH-01/02, ghi kết quả qua POST /teacher/trials/result với kiểm phân công; không có quyền đọc toàn Lead.
- GET /staff/subjects/form, /staff/courses/form, /staff/teachers/form, /staff/students/form, /staff/guardians/form, /staff/classes/form: form phụ của màn hình quản trị tương ứng, cùng quyền/validation.
- GET /staff/invoices/receipt?id=: biên lai nội bộ thật; finance kiểm quyền tương tự chi tiết. Student/Parent dùng GET /student/tuition/receipt và /parent/tuition/receipt với kiểm chủ thể, không mở quyền /staff bằng link in.
- GET /admin/audit-logs: tab nhật ký của ADM-19, UC35 P1; không có POST edit/delete. GET /errors/500: lỗi an toàn cùng shell, không thêm UC mới.
- Biểu đồ/lịch/báo cáo nếu cần GET data endpoint thì endpoint đó kế thừa đúng scope và trạng thái công bố của màn hình, không tạo “public API” để bỏ RBAC.

## Đối chiếu alias từ design.md/prototype

| Alias cũ | ID/route chuẩn của SRS |
|---|---|
| /courses/{id} | PUB-03 /courses/detail?id=; không thêm mapping trùng |
| /manager/dashboard, /manager/reports | ADM-01 /admin/dashboard; ADM-16 /admin/reports; trách nhiệm Manager thuộc ADMIN |
| CRM-01/02/03 | ADM-02/03; lịch thử là tab ADM-03 |
| AC-01/02/03/04/05/06 | ADM-04/05/10/11/13/13 (phòng là tab) |
| PPL-01/02/03/04 | ADM-06/07/08/09 |
| ENR-01; FIN-01/02/03; RPT-01 | ADM-12; ADM-14/15/15; ADM-16 |
| STU-01/02; /student/learning | STD-01; STD-02 và STD-03; dùng hai route SRS riêng |
| /parent/students/{id} | PAR-02 /parent/children/detail?id= |
| SEC-01/02; SYS-01 dùng để chỉ profile ở prototype | ADM-18/19; profile là AUTH-05; SYS-01 chuẩn là lỗi403 |
| COM-02 dùng để chỉ moderation ở prototype | Moderation là ADM-17; COM-02 chuẩn là chi tiết/đặt câu hỏi |
| PUB-05 dùng để chỉ consultation ở prototype | PUB-05 chuẩn là /registration/confirm; consultation là PUB-06 |

## Bảy luồng điều hướng phải nghiệm thu

1. FLOW-01: PUB-01→PUB-02→PUB-03→PUB-04→PUB-05→PUB-07→ADM-02→ADM-03→ADM-07→ADM-12→ADM-15.
2. FLOW-02: PUB-06→PUB-07→ADM-02→ADM-03→ADM-06/07→ADM-12→ADM-14.
3. FLOW-03: ADM-04→ADM-05→ADM-10→ADM-11→ADM-13→ADM-11.
4. FLOW-04: AUTH-01→TCH-01→TCH-02→TCH-03→TCH-04(P1)→TCH-05→TCH-06; P0 bỏ bước journal vẫn hoàn tất attendance được.
5. FLOW-05: AUTH-01→PAR-01→PAR-02→PAR-03→COM-02, luôn kiểm liên kết hiện hành.
6. FLOW-06: AUTH-01→ADM-14→ADM-15→ADM-14→ADM-16; payment thành công chỉ sau commit, lỗi không ghi dở.
7. ~~FLOW-07~~: *(Đã loại bỏ khỏi phạm vi triển khai theo Quyết định D19)*.

Không tự thêm chức năng export CSV/PDF hoặc link chính sách chết vì prototype có nút. Nếu cần export trong giai đoạn sau phải đặc tả và kiểm quyền riêng; baseline yêu cầu báo cáo trên web và biên lai nội bộ.
