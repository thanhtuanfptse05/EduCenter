# Research & Technical Decisions: feat-academic-programs

**Feature:** `feat-academic-programs` | **Module:** Academic (M04) | **Use Case:** UC11, ADM-04, ADM-05

---

## 1. Architectural Decisions

### Decision 1: Service Separation vs Extension
- **Context:** `CourseService` hiện tại chỉ cung cấp 3 API đọc cho public catalog (`getCourseCatalog`, `getCourseDetail`, `getActiveSubjects`).
- **Decision:** Tạo `AcademicProgramService` (và `AcademicProgramServiceImpl`) riêng biệt phục vụ phân hệ quản trị đào tạo M04 (STAFF/ADMIN). Giữ nguyên `CourseService` cho public portal để đảm bảo Single Responsibility Principle và không làm ảnh hưởng tới các callers hiện tại (`CourseServlet`, `PortalReferenceService`, `CartService`).
- **Rationale:** Quản trị môn học và khóa học yêu cầu các giao dịch ghi (`EntityTransaction`), ghi nhận nhật ký kiểm toán (`AuditLog`), xử lý quyền tác vụ (`STAFF`/`ADMIN`), và xác thực ràng buộc nghiệp vụ (BR02, BR16, BR18) phức tạp hơn nhiều so với việc chỉ đọc công khai.

### Decision 2: Unique Code Validation & Case-Insensitive Matching
- **Context:** FR-001 và FR-002 yêu cầu mã môn học (`Subject.code`) và mã khóa học (`Course.code`) phải là duy nhất. Edge case: "Mã trùng khác hoa/thường".
- **Decision:** Trong repository và service, thực hiện kiểm tra `UPPER(TRIM(code)) = UPPER(:code)` và loại trừ chính ID đang chỉnh sửa (`AND id <> :currentId`). Báo lỗi rõ ràng trên form `CourseFormDTO` hoặc `SubjectFormDTO` khi bị trùng.

### Decision 3: Soft State Management & Inactive Subject Guard (BR16)
- **Context:** Môn học có trạng thái `ACTIVE` / `INACTIVE`. Khóa học có trạng thái `OPEN` / `CLOSED` / `ARCHIVED`. FR-006 yêu cầu chặn ngừng môn học (`INACTIVE`) khi còn ít nhất một khóa học đang `OPEN`.
- **Decision:** 
  - Trước khi cho phép cập nhật trạng thái môn học thành `INACTIVE`, gọi `courseRepository.countOpenBySubject(em, subjectId)`. Nếu > 0, ném `ValidationException` thông báo rõ ràng cho nhân viên cần đóng hoặc lưu trữ các khóa học trực thuộc trước.
  - Tuyệt đối không xóa vật lý bản ghi `Subject` và `Course` (BR16). Khi không còn tuyển sinh, chuyển trạng thái sang `ARCHIVED` hoặc `INACTIVE`.

### Decision 4: Fee Change Immutability & Audit Trail (BR18)
- **Context:** FR-004 yêu cầu khi sửa học phí khóa học, các hóa đơn và phiếu ghi danh đã lập trong quá khứ phải giữ nguyên snapshot học phí cũ. Đồng thời phải ghi nhận nhật ký kiểm toán.
- **Decision:**
  - Bảng `Invoices` và `InvoiceDetails` (cũng như `RegistrationItems`) đã có các trường `unit_price`, `final_amount` độc lập, lưu snapshot giá tại thời điểm giao dịch.
  - Trong `AcademicProgramServiceImpl.saveCourse()`, nếu `course.getId() != null` và `fee` thay đổi so với giá trị hiện tại trong DB, service ghi lại `AuditLog` với `action = "UPDATE_COURSE_FEE"`, `tableName = "Courses"`, `oldValue = oldFee.toString()`, `newValue = newFee.toString()` trong cùng `EntityTransaction` (atomic).

### Decision 5: UI & Design System Alignment (design.md)
- **Context:** Màn hình ADM-04 (Danh sách khóa học) và ADM-05 (Form khóa học, Quản lý môn học) phải đạt chuẩn thương mại cao cấp (production-grade ERP).
- **Decision:**
  - Layout: Dùng chung thẻ layout chuẩn với `sidebar.jspf`, `navbar.jspf`, default Light mode (biến CSS token `--bg: #f8fafc`, `--surface: #ffffff`, `--primary: #0284c7`, `--text: #0f172a`...).
  - Icons: Bộ icon outline SVG Lucide chuẩn 18–20px (không dùng emoji, không icon 3D).
  - KPI Cards động: Tổng số khóa học, Khóa đang mở tuyển sinh (`OPEN`), Khóa tạm đóng (`CLOSED`), Khóa lưu trữ (`ARCHIVED`), Tổng số môn học. Tất cả lấy từ CSDL.
  - Bảng dữ liệu có phân trang, thanh tìm kiếm từ khóa, bộ lọc khối 6–12, bộ lọc môn học, bộ lọc trạng thái, badge trạng thái hiện đại.
  - Trạng thái rỗng (Empty State) hiển thị chuyên nghiệp với icon minh họa SVG và nút "Tạo khóa học đầu tiên".

---

## 2. Risk Assessment & Mitigations
| Rủi ro | Giải pháp giảm thiểu |
|---|---|
| Xung đột mã môn/khóa khi tạo song song | Ràng buộc Unique Key ở cấp DB (`UQ_Subjects_Code`, `UQ_Courses_Code`) bắt ngoại lệ `PersistenceException` và kiểm tra logic `existsByCode` trước khi persist. |
| Người dùng cố tình nhập khối ngoài 6–12 | Server-side validation kiểm tra chặt `gradeLevel >= 6 && gradeLevel <= 12`. Báo lỗi field cụ thể. |
| Học phí hoặc số buổi nhập số âm / 0 | Validation: `fee >= 0`, `durationWeeks > 0`, `totalSessions > 0`, `maxCapacity > 0`. |
| CSRF tấn công khi cập nhật trạng thái | Mọi form POST đều bắt buộc kèm `name="csrfToken"` và kiểm tra bằng `CsrfUtil.isValidToken(req)`. |
