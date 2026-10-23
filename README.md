# EduCenter

Ứng dụng Java Web quản lý trung tâm gia sư và luyện thi lớp 6–12. Stack: Java 17, Jakarta Servlet/JSP/JSTL, JPA 3.1/Hibernate, SQL Server, Ant và Tomcat 10.1.

## Bộ đặc tả đầy đủ và thứ tự triển khai

[Mục lục specs](.sdd/specs/README.md) bao phủ 12 module, 35 use case (31 P0 + 4 P1), 20 business rules, 30 bảng nghiệp vụ và 49 màn hình theo SRS v1.1. Xem [thứ tự code từng tính năng](.sdd/specs/implementation-order.md), [truy vết yêu cầu](.sdd/specs/traceability.md) và [hợp đồng tích hợp](.sdd/specs/integration.md). Đây là baseline đặc tả mới; code và kiểm thử các module còn lại chưa được xác nhận hoàn tất.

## Hiện trạng đã triển khai (trước baseline đặc tả mới)

- Trang chủ công khai, danh mục/tìm kiếm/bộ lọc khóa học, chi tiết khóa/lớp và biểu mẫu tư vấn.
- Giỏ đăng ký khách/tài khoản: khóa học duy nhất, ghi chú, cập nhật học phí, gộp khi đăng nhập, xóa/xóa hết, xác nhận tạo Lead và biên nhận theo phiên. Không có mã giảm giá hay combo giảm giá; đây là yêu cầu tư vấn, chưa phải giao dịch ghi danh/thanh toán.
- Đăng ký, đăng nhập/đăng xuất, hồ sơ, đổi/reset mật khẩu; CSRF và phân quyền 5 vai trò `ADMIN`, `STAFF`, `TEACHER`, `STUDENT`, `PARENT`.
- Quản trị tài khoản/trạng thái/vai trò và Audit Log. Các dashboard vai trò hiện là trang điều hướng tài khoản.
- Một navbar/footer công khai dùng chung; mặc định giao diện sáng; menu mobile và lựa chọn theme được lưu.

Bản sửa theo yêu cầu ngày 2026-10-23 có [spec đã khóa](.sdd/specs/modules/admission/feat-portal-cart-repair/spec.md), [kế hoạch](.sdd/specs/modules/admission/feat-portal-cart-repair/plan.md) và [bằng chứng kiểm thử](.sdd/specs/modules/admission/feat-portal-cart-repair/verification.md). [design.md](design.md) là tài liệu thiết kế chuẩn duy nhất.

## Ba ngoại lệ lịch sử của đợt sửa portal/cart

Link reset vẫn hiển thị trực tiếp; phần 2FA/thiết bị/lịch sử trong hồ sơ vẫn là nội dung minh họa; thẻ tiến độ/học viên/phụ huynh ở trang chủ vẫn dùng số liệu minh họa. Đây là hiện trạng của đợt sửa cũ, không được xem là production đã hoàn tất. Baseline mới yêu cầu thay bằng luồng bảo mật/dữ liệu thật hoặc ẩn phần chưa có theo [D04](.sdd/specs/decisions.md); đợt viết spec chưa thay đổi code này.

Các module ERP còn lại được ghi rõ trong [future-work.md](.sdd/future-work.md). Không dùng trạng thái Completed của tài liệu cũ để kết luận toàn bộ ERP đã hoàn thành.

## Chạy ứng dụng

1. Cài Java 17, NetBeans 17/Ant, Tomcat 10.1 và SQL Server. Tạo dữ liệu theo `docs/database/` và các migration phù hợp với môi trường.
2. Cấu hình `src/conf/META-INF/persistence.xml`; đồng bộ bản tương thích tại `src/java/META-INF/persistence.xml`. Có thể ghi đè bằng `EDUCENTER_DB_URL`, `EDUCENTER_DB_USER`, `EDUCENTER_DB_PASSWORD`. Ứng dụng không tự thay đổi schema khi khởi động.
3. Mở dự án NetBeans, chọn Tomcat 10.1, Clean and Build rồi Run. JSP nằm dưới `web/WEB-INF/views/`.

## Kiểm thử độc lập

Chép các JAR công khai trong `Tomcat 10.1/lib/` và `bin/tomcat-juli.jar` vào `build/tools/tomcat/` (thư mục build được bỏ qua bởi Git). Sau đó chạy từ thư mục dự án:

```powershell
.\scripts\verify.ps1
.\scripts\verify.ps1 -Integration
.\scripts\verify.ps1 -Serve -Port 18080
```

Lệnh đầu chạy unit test và tạo `dist/EduCenter.war`. Integration test đọc CSDL cấu hình để kiểm tra kết nối, tạo CSDL SQL Server riêng có tiền tố `EduCenterRepairTest_`, chạy HTTP/JSP/transaction tests rồi dọn riêng CSDL đó. Tài khoản kiểm thử cần quyền tạo/xóa CSDL; không có test ghi vào dữ liệu ứng dụng hiện tại.

Khi server kiểm thử đang chạy, `python scripts/browser-check.py` dùng Python Playwright và Chrome để kiểm tra 9 route tại 360/768/1024/1440px, menu/theme/overflow/JavaScript và lưu ảnh tại `build/repair/screenshots/`. Dùng `-Serve -Fixture -Port 18081` và các biến môi trường trong verification.md để kiểm tra thêm tài khoản/menu nội bộ trên CSDL riêng. Các công cụ này chỉ phục vụ kiểm thử, không đóng gói vào ứng dụng.

## Cấu trúc

- `src/java/com/educenter/`: controller, filter, service, repository, entity, DTO, util.
- `web/WEB-INF/views/`: các view được bảo vệ; `web/assets/`: CSS/JS/ảnh cục bộ.
- `test/`: JUnit và hỗ trợ Tomcat/SQL Server; `scripts/`: Ant/PowerShell và kiểm thử trình duyệt.
- `.sdd/`: constitution, spec, tiến độ và công việc tương lai.

Dự án học tập PRJ301, nhóm 3 thành viên: Academic; Admission; Finance & Administration.
