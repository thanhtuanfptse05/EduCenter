# EDUCENTER AI AGENT SAFETY GUARDRAILS
**Layer:** Agent Behavioral & Security Guardrails  
**Audience:** Antigravity IDE, Claude Code, GitHub Copilot, developers

---

## 1. MANDATORY AGENT PROTOCOLS
1. **DÙNG SPECKIT VIẾT SPEC:** Mọi tính năng phải đi qua quy trình Spec Kit (`/speckit-specify` -> `/speckit-plan` -> `/speckit-tasks` -> `/speckit-implement` -> `/speckit-converge`).
2. **DÙNG CODEGRAPH ĐỌC CODE:** Mọi thao tác tìm kiếm, trace quan hệ, đọc mã nguồn phải ưu tiên qua MCP `codegraph_explore` hoặc lệnh `codegraph explore`.
3. **NGUYÊN TẮC SPEC-FIRST:** Bắt buộc sửa `SPEC.md` / `PLAN.md` trước khi sửa mã nguồn để tránh mơ hồ và Spec-Code Drift.
4. **ĐẨY LÊN MAIN KHI XONG TÍNH NĂNG:** Mọi tính năng hoàn thành và pass kiểm thử phải được đẩy lên nhánh `main` ngay.

---

## 2. STRICT PROHIBITIONS (CẤM TUYỆT ĐỐI)
1. **NO RAW JDBC:** Không viết bất kỳ dòng mã nào sử dụng `java.sql.Connection`, `java.sql.PreparedStatement`, `java.sql.Statement` cho logic nghiệp vụ (vi phạm tiêu chí Assignment PRJ301). Phải dùng JPA `EntityManager`.
2. **NO PLAINTEXT PASSWORDS:** Không lưu mật khẩu thô trong code, database, hoặc log. Phải băm bằng BCrypt (cost >= 10).
3. **NO JAVA SCRIPTLETS IN JSP:** Không dùng `<% ... %>`, `<%= ... %>` trong các file `.jsp`. Phải dùng JSTL `<c:...>` và Expression Language `${...}`.
4. **NO HARD DELETIONS ON FINANCIAL RECORDS:** Không thực thi câu lệnh SQL/JPQL `DELETE` trên các bảng `Invoices`, `Payments`, `Enrollments`, `Attendances`.
5. **NO UNAUTHORIZED DATA EXPOSURE:** Không được bỏ qua kiểm tra quyền theo bản ghi (ví dụ: Phụ huynh A truy cập học viên B không thuộc quyền giám hộ).

---

## 3. PRE-COMMIT CHECKLIST FOR AGENTS
* [ ] Spec tương ứng trong `.sdd/specs/` đã được cập nhật trước khi code?
* [ ] Code đã tuân thủ chuẩn Jakarta EE (namespace `jakarta.servlet.*`, `jakarta.persistence.*`, `jakarta.tags.*`)?
* [ ] Đã đóng `EntityManager` an toàn và rollback khi có lỗi transaction?
* [ ] Đã kiểm tra null và validate định dạng dữ liệu đầu vào?
* [ ] Tính năng hoàn thành đã được commit và push lên nhánh `main`?
