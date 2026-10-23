# Điều kiện chung áp dụng cho mọi feature spec

**Version:** 1.0.0 | **Date:** 2026-10-23 | **Status:** Locked — baseline nội bộ.

Feature kế thừa toàn bộ QG; mã FR/SC cục bộ phải ghi kèm đường dẫn feature khi tham chiếu chéo. Spec mô tả hành vi đích; triển khai vẫn cần plan/tasks tương ứng trước khi sửa src/web.

| ID | Điều kiện phải nghiệm thu | Cách xác minh |
|---|---|---|
| QG01 | Filter chặn chức năng ngoài vai trò; Service kiểm tra lại actor đang ACTIVE và quyền trên từng bản ghi. | Thử URL, form sửa ID, quyền bị thu hồi giữa hai request; không đọc/ghi được dữ liệu ngoài phạm vi. |
| QG02 | Mọi thay đổi qua POST có CSRF; GET không đổi trạng thái. POST thành công hoặc validation nghiệp vụ dùng PRG, flash một lần; chỉ giữ trường không nhạy cảm. | Reload trang sau POST không lặp mutation; CSRF sai không ghi; password/token không nằm trong flash/log. Request bị chặn bảo mật trả 403, không bắt buộc redirect. |
| QG03 | Toàn bộ dữ liệu thực thể, dropdown nghiệp vụ, thống kê, biểu đồ và thông tin trung tâm lấy từ DB qua Repository → Service → Controller → request → JSTL/EL. | DB rỗng có empty state thật; lỗi DB có trạng thái “không tải được” thay vì báo 0. Nhãn tĩnh, hướng dẫn và bản dịch UI không phải dữ liệu mock. |
| QG04 | Mọi màn hình dùng design.md: Inter, CSS token/local CSS, SVG outline 18–20px; lần đầu Light dù OS Dark; Dark chỉ do người dùng lưu educenter-theme. | Kiểm tra 360, 768, 1024, 1440px, bàn phím, focus, label/lỗi, tương phản; không tràn toàn trang, emoji, Tailwind CDN. |
| QG05 | Java 17, Jakarta Servlet/JPA, JSP trong WEB-INF/views, JSTL/EL, Ant; không JDBC nghiệp vụ hoặc scriptlet. | Review + build WAR; persistence metadata trên classpath META-INF/persistence.xml; EntityManager đóng và rollback đúng. |
| QG06 | Service điều phối một transaction cho thao tác liên module; chống double-submit và tranh chấp bằng khóa dữ liệu ổn định + ràng buộc DB. | Kiểm thử hai request cùng slot/lịch/số dư, lặp khóa yêu cầu và lỗi giữa transaction; không ghi dở hoặc tạo bản sao. |
| QG07 | Không xóa vật lý hóa đơn, khoản thu, ghi danh, điểm danh hoặc dữ liệu có giao dịch; chỉnh sửa trọng yếu có actor/time/before/after/reason. | Theo dấu lịch sử sau archive/cancel/transfer/refund; audit cùng transaction, lỗi audit làm rollback thao tác trọng yếu. |
| QG08 | Input có giới hạn/validation server, output escape theo context, truy vấn bind tham số, sort theo allowlist, phân trang ở DB. | Thử Unicode, HTML, SQL metacharacters, ID sai, page quá lớn, stale version; không XSS, stacktrace, lộ token/PII không cần thiết. |
| QG09 | Sản phẩm không hiển thị tài khoản demo, autofill, số liệu minh họa, link reset, thành tích/chứng nhận giả hoặc nút chức năng chưa có. | Đối chiếu dữ liệu nguồn, không lấp empty state bằng rows/cards giả; dữ liệu demo chỉ ở môi trường kiểm thử và tài liệu demo riêng. |
| QG10 | Chỉ ghi hoàn thành khi có bằng chứng test phù hợp; thiếu SQL Server/Tomcat/SMTP phải ghi rõ chưa xác minh. | JUnit 5 nghiệp vụ trọng yếu, SQL Server integration, HTTP/role tests và browser UAT cho luồng P0; không tự đánh dấu pass. |
| QG11 | List tìm kiếm/lọc/sort/page giữ bộ lọc sau thao tác, chi tiết không tồn tại trả 404 an toàn, trái quyền trả 403, lỗi hệ thống có mã sự cố. | Có empty/error/success/disabled/loading state phù hợp với từng màn hình; link quay lại hoạt động, không href="#" chết. |
| QG12 | Dữ liệu thời gian và tiền thống nhất data-contract; báo cáo không cộng trùng do JOIN hoặc gộp tiền thu với tiền phải thu. | Đối soát từng record và bộ dữ liệu biên gồm hoàn một phần, thiếu điểm, học viên chuyển/bảo lưu, buổi bị hủy. |

## Definition of Done triển khai

Spec locked nội bộ và checklist yêu cầu đạt; plan/tasks mới bao phủ phiên bản spec hiện hành; các QG liên quan và acceptance của feature có bằng chứng; không lỗi nghiêm trọng phân quyền/tài chính; WAR chạy trong môi trường bàn giao; commit/push hoặc merge lên main theo AGENTS.md. Đợt viết tài liệu hiện tại không tự đánh dấu các điều kiện triển khai này đã đạt.
