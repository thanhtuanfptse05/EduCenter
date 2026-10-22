# QUY TẮC BẮT BUỘC TRONG QUY TRÌNH PHÁT TRIỂN (MANDATORY WORKFLOW RULES)
**Áp dụng:** Toàn bộ AI Coding Agents (Antigravity, Claude, Copilot) và thành viên dự án EduCenter.
**Hiệu lực:** Tuyệt đối tuân thủ, không có ngoại lệ.

---

## 1. BẮT BUỘC DÙNG SPECKIT ĐỂ VIẾT SPEC VÀ KẾ HOẠCH
* Mọi yêu cầu tính năng mới, chỉnh sửa nghiệp vụ hoặc tạo mới phân hệ đều **BẮT BUỘC** sử dụng bộ skills của GitHub Spec Kit:
  * `/speckit-constitution`: Khởi tạo và cập nhật hiến pháp kỹ thuật dự án.
  * `/speckit-specify`: Đặc tả tính năng từ User Stories và Business Rules theo chuẩn EARS (Ubiquitous, Event-driven, State-driven, Unwanted behavior, Optional).
  * `/speckit-plan`: Lập kế hoạch kiến trúc kỹ thuật (Servlet, Service, JPA Repository, View JSP).
  * `/speckit-tasks`: Chia nhỏ công việc thành atomic tasks (mỗi task <= 4 giờ).
  * `/speckit-implement`: Triển khai code theo đúng từng task đã duyệt.
  * `/speckit-converge`: Đánh giá mức độ hội tụ, đồng bộ task còn thiếu.
* **CẤM:** Không được code tự do khi chưa có Spec hoặc bỏ qua quy trình Spec Kit.

---

## 2. BẮT BUỘC DÙNG CODEGRAPH ĐỂ ĐỌC VÀ ĐIỀU HƯỚNG CODE
* Khi cần tìm hiểu cấu trúc dự án, tìm kiếm class/servlet/service/repository, tra cứu call-paths, dynamic dispatch hoặc đánh giá ảnh hưởng (impact analysis):
  * **BẮT BUỘC** gọi công cụ MCP `codegraph_explore` (hoặc lệnh `codegraph explore "<symbol or question>"`) **TRƯỚC TIÊN**.
  * Coi mã nguồn trả về từ CodeGraph là dữ liệu đã đọc — không chạy lặp lại các lệnh grep/find/cat/view_file thủ công tốn token và làm chậm tốc độ.
  * Chỉ dùng `view_file` khi cần kiểm tra chính xác từng dòng cụ thể để sửa mã nguồn.

---

## 3. NGUYÊN TẮC "SPEC-FIRST": SỬA SPEC RỒI MỚI ĐƯỢC SỬA CODE
* **Tuyệt đối tránh mơ hồ và Spec-Code Drift (Lệch pha giữa Spec và Code):**
  * Khi có sự thay đổi về yêu cầu, phát hiện edge case mới, hoặc cần refactor logic nghiệp vụ: **PHẢI CẬP NHẬT VÀ KHÓA (LOCK) SPEC TRƯỚC**.
  * Sau khi Spec (`SPEC.md` / `PLAN.md`) được cập nhật và làm rõ, mới tiến hành sửa code trong `src/` hoặc `web/`.
  * **CẤM TUYỆT ĐỐI:** Hành vi "Code trước rồi sửa spec sau" hoặc "Sửa code mà không cập nhật tài liệu spec liên quan".

---

## 4. CODE XONG TÍNH NĂNG LÀ PHẢI ĐẨY LÊN MAIN (CONTINUOUS TRUNK INTEGRATION)
* Sau khi một tính năng hoặc một cụm Use Case P0 được implement hoàn tất và pass các tiêu chuẩn Definition of Done (DoD):
  1. Code tuân thủ Java 17 + Tomcat 10.1 (`jakarta.*`) + JPA/Hibernate (không JDBC thuần).
  2. Unit tests và manual validation hoạt động ổn định, không phát sinh lỗi regression.
  3. **BẮT BUỘC** thực hiện commit và đẩy code lên nhánh `main` (hoặc merge PR vào `main`) với thông điệp commit chuẩn:
     `feat([scope]): [mô tả tính năng]`
* Đảm bảo nhánh `main` luôn ở trạng thái production-ready, sẵn sàng demo cho giảng viên/khách hàng bất kỳ lúc nào.
