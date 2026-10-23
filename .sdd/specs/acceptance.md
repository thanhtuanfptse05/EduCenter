# Bộ nghiệm thu liên tính năng và điều kiện bàn giao

**Baseline:** 2026-10-23 | **Trạng thái:** Đặc tả kiểm thử, chưa thực thi ứng dụng.

Từng feature có acceptance theo FR, user stories, edge cases và SC. Tài liệu này kiểm các chỗ giao nhau mà unit test một module không đủ. Dùng DB kiểm thử riêng và dữ liệu tổng hợp; không ghi test vào dữ liệu ứng dụng hiện tại, không đưa tài khoản thử lên UI. Các số tiền/điểm dưới đây là test fixtures, không dữ liệu hardcode sản phẩm.

## UAT-01 — Từ website đến ghi danh/hóa đơn

**P0:** UC06–10, UC13/14/17/25. Tiền đề: một Subject/Course OPEN, Teacher ACTIVE, Room AVAILABLE, Class OPEN còn chỗ và lịch hợp lệ.

1. Guest tìm/lọc/sort/page, xem chi tiết và khóa liên quan; chọn hai khóa, cập nhật ghi chú, xóa/thêm lại một khóa. Tổng bằng phí DB, quantity luôn1, không coupon/combo.
2. Đăng nhập Student/Parent: session ID đổi, giỏ không mất và merge một lần. Thử lỗi persist lúc merge: giỏ Guest chưa bị xóa.
3. Đổi phí hoặc đóng một Course ở tài khoản quản trị trước confirm: form yêu cầu kiểm lại/xác nhận giá mới hoặc chặn khóa đóng; không chốt snapshot giả.
4. Submit nhu cầu hợp lệ: một Lead NEW/WEBSITE với LeadCourses/notes snapshot; chưa có Enrollment/Invoice. Replay cùng nonce trả cùng receipt, không Lead thứ hai. Success code session khác không đọc được.
5. ADMIN phân công STAFF; STAFF ghi lịch sử liên hệ/đặt kiểm tra đầu vào/ghi kết quả/CONSULTING; chọn Student hiện có hoặc tạo đúng một hồ sơ. Parent được liên kết qua xác thực STAFF, không từ email trùng.
6. Ghi danh: Enrollment ACTIVE + History + initial Invoice/Items + Lead ENROLLED liên kết cùng commit; Student xem lớp và Invoice đúng phí. Thử lỗi tại từng bước lập hóa đơn/audit: không có bản ghi dở hoặc Lead chuyển sai.

**Pass khi:** Toàn bộ ID liên kết truy lại được; phí/sĩ số/Lead/giỏ/receipt đúng; replay không tạo bản sao, rollback không mất input/giỏ.

## UAT-02 — Sĩ số, ghi danh trùng và lịch học viên

**P0:** UC16/17; BR03/04/07. Chuẩn bị Class capacity1, hai Student và hai nhân viên.

- Dùng hai transaction đồng thời với barrier trước kiểm chỗ cuối: đúng một Enrollment ACTIVE, đúng một Invoice, request còn lại báo CLASS_FULL. Chạy tối thiểu20 cặp độc lập.
- Cùng Student/Class hai request/key khác nhau: một ghi danh, request còn lại DUPLICATE; replay cùng key trả cùng kết quả. Thử cùng key khác payload phải conflict.
- Hai Class khác nhau lịch chồng lấn, cùng Student ghi đồng thời: tối đa một thành công nếu chưa có ngoại lệ; khóa Student phải ngăn write skew.
- Một buổi tiếp giáp được phép; giao một phút bị chặn; kiểm toàn bộ lịch tương lai chứ không chỉ buổi đầu. Ngoại lệ ADMIN cho cặp buổi cụ thể có audit, không ngoại lệ Teacher/Room.
- Giảm capacity đồng thời ghi danh: invariant ACTIVE≤capacity luôn đúng. Class PLANNING/CLOSED/CANCELLED hoặc Course đóng không nhận.

**Pass khi:** Không chỉ Service mock pass; có SQL Server integration chứng minh ràng buộc và khóa thật.

## UAT-03 — Tạo lớp, lịch, dạy thay và điểm danh

**P0:** UC12/15/16/19/20/34. **P1 riêng:** UC21.

1. Tạo Room/Class, xem trước/sinh lịch định kỳ có ngày loại trừ; số buổi và ngày giờ đúng. Sinh lại cùng request không trùng.
2. Thử lịch cùng Teacher khác Room, cùng Room khác Teacher, hai ngày cùng giờ, hai buổi tiếp giáp, buổi qua nửa đêm. Chỉ tình huống hợp lệ được lưu.
3. Hai request đặt lịch Class và TrialAssessment cùng Room/Teacher: không xung đột xuyên hai bảng. Lỗi giữa đợt rollback cả đợt.
4. Dời buổi và dạy thay: buổi cũ RESCHEDULED có liên kết buổi mới; Teacher cũ không ghi được, Teacher thực dạy mới có quyền. Portal tải lại thấy đúng.
5. Roster theo EnrollmentHistory; ghi đủ bốn trạng thái, thử thêm Student ngoài lớp và trùng cặp; hoàn tất không tự gán PRESENT cho người chưa chọn.
6. Teacher không sửa COMPLETED; ADMIN correction có lý do/audit, tỷ lệ và portal cập nhật. Buổi tương lai/hủy/dời không được hoàn tất như đã học.
7. Riêng P1: lưu một journal/buổi, nội dung dạy/bài tập/nhận xét; chỉ hiển thị cho người liên quan sau COMPLETED. P0 phải chạy được dù chưa có journal.

**Đối soát chuyên cần:** 4 buổi COMPLETED đủ điều kiện gồm PRESENT, LATE, ABSENT_EXCUSED, ABSENT_UNEXCUSED →50%. Thêm một COMPLETED thiếu điểm danh →40%, có1 thiếu; buổi CANCELLED không vào mẫu số. Không buổi hợp lệ →chưa có dữ liệu.

## UAT-04 — Điểm, công bố và tiến bộ

**P0:** UC22/23/24/33; BR09–11.

- Bài max_score20: 0 và20 hợp lệ, -0.01/20.01 bị chặn. Student ngoài roster ngày kiểm tra không có điểm; thiếu điểm khác0.
- DRAFT không lộ qua Student/Parent, HTML/JSON/chart/report/notification. Teacher ngoài Class và người chỉ dạy thay một buổi không chấm cả Class.
- Công bố cần ít nhất một score; kiểm/audit/state trong cùng transaction; lỗi audit không có PUBLISHED dở.
- Hai bài score5/10 weight1 và16/20 weight2 →normalized5 và8; weighted AVG7.00. Điểm nháp hoặc thiếu không vào mẫu số. MIN/MAX đúng tập đã công bố.
- ENTRANCE đã công bố5.5/10, lần sau8/10 →tăng2.5; không ENTRANCE thì không hiện tăng giả. Trial CRM không tự hiện trên chart học tập.
- ADMIN mở correction có lý do, chuyển DRAFT ẩn khỏi portal, sửa rồi công bố lại giữ audit before/after. Stale publish bị từ chối.

## UAT-05 — Thu tiền, idempotency và chứng từ

**P0:** UC25/26/27; BR12–14/20.

- Invoice1.000.000: thu400.000→PARTIALLY_PAID/debt600.000; thu600.000→PAID/debt0; amount0/âm/vượt2 số lẻ/vượtdebt bị chặn. Invoice0 đồng hợp lệ không cần Payment giả.
- Hai request cùng thu600.000 dư cuối: một commit, một lỗi số dư; chạy20 cặp. Replay key/cash receipt trả một Payment; bank reference dùng lại bị chặn.
- CASH/BANK_TRANSFER thủ công có actor/paid_at/confirmed_at/reference; không mở form VNPAY/MOMO chỉ vì CHECK cũ cho phép.
- Lỗi Payment/audit/projection: rollback nguyên tử. Biên lai GET/print chỉ đọc, không phát sinh Payment mới. Giữ rõ đây là biên lai nội bộ.
- Teacher, Student khác, Parent chưa verified không đọc Invoice/receipt dù biết ID; thu tiền chỉ STAFF/ADMIN.

## UAT-06 — Ưu đãi, hủy thu, hoàn và điều chỉnh

**P0 tính toàn vẹn tài chính:** WF-04; M09. Không ép dùng hoàn tự động theo số buổi.

1. ADMIN duyệt Discount theo ngày/điều kiện; STAFF chỉ áp đã duyệt. Phần trăm>100, fixed>gross, expired/disabled bị chặn; snapshot không đổi khi policy đổi sau đó.
2. Invoice thu đủ1.000.000: ADMIN CREDIT200.000+REFUND200.000 cùng quyết định →nghĩa vụ800.000, thu ròng800.000, nợ0; Payment gốc không sửa/xóa.
3. REFUND một phần rồi retry: không trùng, tổng bù không vượt khoản gốc. VOID tiền nhập sai không bị ghi thêm tiền chi REFUND cho cùng phần.
4. Giảm nghĩa vụ dưới thu ròng mà không có hoàn phù hợp bị chặn, không dùng clamp0 che nợ âm. Hủy Invoice còn thu ròng>0 bị chặn; hoàn/credit xong mới hủy có audit.
5. Payment legacy REFUNDED/CANCELLED phải có migration đối soát; không vừa loại thu gốc vừa trừ adjustment. Thiếu bằng chứng ngày/actor cũ được ghi hạn chế, không bịa.

**Pass khi:** Tổng nghĩa vụ/thu/hoàn/nợ khớp ledger đến0,01; giữ đủ before/after, quyết định, chứng từ và tham chiếu gốc.

## UAT-07 — Cô lập Student/Parent và dữ liệu cá nhân

**P0:** WF-05; UC13/14/19/24/27; BR02/11/15.

- PARENT A có hai con, mỗi con có thêm Guardian khác; truy đúng dữ liệu từng con. PARENT B không liên kết, liên kết chưa verified, revoked hoặc Guardian INACTIVE đều bị chặn.
- Thử thay childId/studentId/sessionId/assessmentId/invoiceId/paymentId trên HTML/form/data/receipt; không đọc/ghi ngoài phạm vi. Không match quyền bằng email/phone trùng.
- Thu hồi giữa phiên đang mở: request kế tiếp và đích notification cũ không trả PII con. Cache/selected child không là quyền.
- Student chưa có hồ sơ hoặc Parent chưa có con thấy empty state có hướng dẫn; không điền dữ liệu mẫu hoặc tự tạo quan hệ.
- Chỉ Student.user_id liên kết đọc portal mình; Teacher chỉ roster và dữ liệu học vụ cần thiết, không học phí hoặc hồ sơ gia đình ngoài nhu cầu.

## UAT-08 — Q&A và thông báo

**P0:** UC29/30, ASM3.8. **P1:** UC28.

1. Student/Parent tạo PENDING, tác giả xem trạng thái; Guest/search không thấy. Teacher đúng khóa trả lời PENDING; Teacher ngoài khóa bị chặn.
2. STAFF/ADMIN khác tác giả duyệt/từ chối/ẩn có reason/time/audit. Không tự duyệt; thiếu người duyệt khác thì bài chờ, không bypass.
3. Answer APPROVED nhưng Question PENDING/HIDDEN/PRIVATE không public. Sửa nội dung đã duyệt về PENDING, giữ revision/audit; HTML người nhập được escape.
4. Câu hỏi chứa học phí/điểm/liên hệ con là PRIVATE; mỗi lần đọc xét quyền chủ thể nguồn, không công khai qua search/snippet.
5. Riêng P1: tạo Notification cho người đúng phạm vi sau source commit, replay event không trùng. Đánh dấu read lặp giữ read_at đầu. User khác không đọc/đánh dấu được. Không gửi điểm DRAFT hoặc thông tin con chưa verified.

## UAT-09 — Auth, quyền quản trị và UI thật

**P0:** UC01–05; QG01–05/08/09/11.

- Register chỉ STUDENT/PARENT; email chuẩn hóa/trùng đồng thời; password≥6 ký tự/≤72 UTF-8 bytes, BCrypt≥10, xác nhận đúng. Không demo account/autofill.
- Login đổi session ID; logout chỉ POST; CSRF sai không mutation; session timeout30phút; redirect_url ngoài miền/ngoài quyền bị chặn.
- Reset cùng response tồn tại/không/khóa; gửi SMTP cấu hình thật; token30phút một lần, hash-only, yêu cầu mới hủy cũ; không link/token UI/log. Môi trường thiếu SMTP ghi chưa xác minh, không tuyên bố pass.
- Đổi password/reset vô hiệu phiên cũ; role/status refresh request kế tiếp. Hai ADMIN cùng tước quyền cuối không thể làm mất toàn bộ ACTIVE ADMIN.
- Profile không đổi role/email/status bằng payload. UI không tự nhận2FA/device/certification/uptime hoặc hiển thị learning showcase giả; nội dung thiếu lấy từ DB/empty state.
- Từng màn hình đúng Light lần đầu dù OS Dark, theme lưu khi chủ động;360/768/1024/1440px, keyboard/focus/label/contrast; không tràn trang, emoji/Tailwind CDN, nút chết, stacktrace.

## UAT-10 — Báo cáo và quản trị

**P0:** UC31/32/33, settings/audit ghi. **P1:** UC35 đọc audit.

- COUNT DISTINCT Student/Lead/Enrollment đúng thực thể; Class có0 học viên vẫn vào lớp ít nhất; MAX/MIN/AVG/SUM/COUNT đều có truy vấn thật/bằng chứng đối soát.
- Cohort10 Lead tạo trong kỳ,4 đã ENROLLED trước ngày chốt→40%, không lấy Enrollment từ Lead kỳ khác. Cohort0→chưa có dữ liệu.
- Invoice2 items/3 payments, Student2 Guardian/3 scores không nhân tổng do JOIN. Bảng chi tiết cộng bằng KPI; snapshot cùng thời điểm; nguồn lỗi không báo0 giả.
- Thu kỳ1, hoàn kỳ2: tiền thu ròng từng kỳ và dư nợ tại ngày chốt khớp ledger; không gọi hóa đơn chưa thu là tiền đã thu.
- ADMIN xem toàn trung tâm; Teacher chỉ report học vụ lớp mình, không tài chính/lớp khác qua data endpoint; Staff không dùng /admin/reports.
- Settings key/type/range allowlist, không secrets; sửa có audit/version. Đóng system.admissions_open chặn intake/enrollment ở Service nhưng không khóa login/xem lịch sử; mở lại không mất dữ liệu.
- Ghi audit trọng yếu là P0, lỗi log rollback. Riêng P1 audit UI lọc/page/chi tiết an toàn, không edit/delete log; tài khoản actor ngừng vẫn truy vết được.

## UAT-11 — P1 chuyển lớp và bảo lưu

UC18 thực hiện sau khi P0 Enrollment/Finance/Lịch đã nghiệm thu. Chuyển sang lớp đủ/khóa đóng/lịch xung đột bị chặn; chuyển hợp lệ có Enrollment đích, bản cũ TRANSFERRED, previous link và History không chồng sai. Bảo lưu không giữ chỗ; quay lại khi chỗ đã đầy bị chặn. Lịch sử Attendance/Score/Invoice cũ không mất. Đổi phí/hoàn khi chuyển cần ADMIN duyệt bút toán cùng transaction; lỗi finance giữ nguyên lớp cũ. Không tự sinh initial Invoice lần2 khi resume.

## Điều kiện bàn giao (SRS XII–XIII)

- 31 UC P0, acceptance của FR và QG liên quan có bằng chứng. 4 UC P1 có nghiệm thu riêng khi đưa vào release, không đánh dấu P0 thiếu chỉ vì P1 chưa bật.
- Java17 WAR chạy Tomcat10.1, SQL Server/JPA không JDBC nghiệp vụ; migrations từ schema đang dùng và DB mới đều được kiểm, không mất dữ liệu. EntityManager/transaction đóng/rollback đúng.
- Tài liệu version đúng: SRS/spec, ERD triển khai, screen map/sitemap/flows, architecture/URL/Controller/Service/Repository, hướng dẫn môi trường/secrets/migrations/build/run/backup, test cases và kết quả.
- Tài khoản/data demo chỉ DB kiểm thử; kịch bản/video demo website→CRM→ghi danh→lịch→điểm danh→điểm→thu tiền→báo cáo. Không đưa tài khoản hoặc test guide vào UI.
- Đề tài khác có bằng chứng giảng viên duyệt; chưa có thì ghi “chưa xác nhận”, không tự đánh dấu được duyệt hoặc đủ10điểm ASM.
- Commit/push hoặc merge main chỉ sau checks tương ứng và báo rõ chưa xác minh môi trường nào. Đợt viết spec chỉ kiểm tài liệu, không thay kết quả test ứng dụng.
