# GEMINI.md — Instructions for Gemini & Antigravity IDE

## MANDATORY WORKFLOW RULES (BẮT BUỘC TUÂN THỦ)

1. **BẮT BUỘC DÙNG SKILL SPECKIT ĐỂ VIẾT SPEC:**
   * Mọi tính năng, màn hình, luồng nghiệp vụ phải được đặc tả bằng Spec Kit skills (`/speckit-specify`, `/speckit-plan`, `/speckit-tasks`, `/speckit-implement`, `/speckit-converge`).
   * Không sinh code tùy tiện khi chưa có spec và task tương ứng trong `.sdd/specs/`.

2. **BẮT BUỘC DÙNG CODEGRAPH ĐỂ ĐỌC CODE:**
   * Khi cần định vị mã nguồn, tìm kiếm class/servlet/method, phân tích call-paths, dynamic dispatch hoặc đánh giá ảnh hưởng: **BẮT BUỘC** gọi `codegraph_explore` MCP tool hoặc chạy `codegraph explore` trong terminal.
   * Tuyệt đối không dùng vòng lặp grep/find đọc thủ công từng file.

3. **NGUYÊN TẮC SPEC-FIRST (SỬA SPEC RỒI MỚI ĐƯỢC SỬA CODE):**
   * Khi có thay đổi yêu cầu, thêm edge case, hoặc refactor logic: **BẮT BUỘC SỬA VÀ KHÓA SPEC TRƯỚC** (`SPEC.md`, `PLAN.md`).
   * Chỉ sửa code trong `src/` hoặc `web/` sau khi spec đã được cập nhật rõ ràng, nhằm triệt tiêu hoàn toàn sự mơ hồ và Spec-Code Drift.

4. **CODE XONG TÍNH NĂNG LÀ PHẢI ĐẨY LÊN MAIN:**
   * Ngay khi hoàn tất triển khai một tính năng hoặc một cụm Use Case P0 và pass kiểm thử/DoD: **BẮT BUỘC** commit và push lên nhánh `main` (với commit format `feat([scope]): [description]`).
   * Nhánh `main` luôn là bản build chạy ổn định và sẵn sàng demo.

5. **BẮT BUỘC TUÂN THỦ DESIGN SYSTEM (DESIGN.MD):**
   * Mọi màn hình JSP, CSS, JavaScript, bố cục layout, typography, màu sắc, components **BẮT BUỘC** tuân thủ tuyệt đối theo đặc tả trong [`design.md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design.md) (tức [`design (1).md`](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/design%20(1).md)).
   * **Default Light Mode:** Lần đầu truy cập luôn luôn là giao diện sáng (Light mode). Chỉ kích hoạt Dark mode khi người dùng chủ động chuyển đổi qua nút toggle.
   * **Icon chuẩn hóa:** Tuyệt đối KHÔNG dùng emoji làm icon, không dùng icon 3D hay sticker hoạt hình. Bắt buộc dùng bộ icon outline SVG đồng nhất (khuyến nghị Lucide SVG 18–20px).
   * **Design Tokens & No External CDN:** Dùng CSS cục bộ với CSS variables token (`--bg`, `--surface`, `--primary`, `--text`...), typography chuẩn `Inter`, bo góc và khoảng cách chuẩn hóa. CẤM dùng Tailwind CDN hay các framework lạ làm lệch chuẩn giao diện.
