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
