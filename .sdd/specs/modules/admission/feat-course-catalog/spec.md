# Feature: Danh Mục Khóa Học & Giỏ Đăng Ký (feat-course-catalog) — SPECIFICATION
**Status:** Approved / Locked | **Version:** 1.0.0 | **Date:** 2026-10-22
**Module ID:** `MOD-ADMISSION` (M01 – Public Website & Course Catalog)
**Author / Owner:** Member 02 (Admission & Public Portal)
**Inherits From:**
- Layer 1: `.sdd/constitution.md` (Article 1, Article 2 SEC-01..05)
- Layer 2: `.sdd/specs/modules/admission/module.md`
- Assignment PRJ301 Standard: Mục 3.2 (Home & hiển thị dữ liệu - 2,0 điểm) & Mục 3.6 (Giỏ hàng hoặc tương đương - 1,0 điểm)
- UI/UX Standard: `design.md` (Default Light mode, Design Tokens, Lucide SVG outline icons, Local CSS)

---

## 1. Business Context & Goal

### Approved repair amendment — 2026-10-23

The locked [portal/cart repair](../feat-portal-cart-repair/spec.md) supersedes contradictions: no coupons/combo discounts/invented original prices; guest selections survive login and merge once; editable notes; current fee/status revalidation; atomic/idempotent confirmation and session-bound persisted receipts. Operational filters cover grades 6–12; public navigation remains identical. Initial task checkmarks do not certify these later repairs.

* **Why:** Website của trung tâm gia sư và luyện thi EduCenter cần một cổng giới thiệu chương trình đào tạo trực quan, chuyên nghiệp, hỗ trợ phụ huynh và học sinh dễ dàng tìm kiếm, lọc theo môn học, khối lớp, mức học phí, xem chi tiết lộ trình học và lựa chọn nhiều khóa học vào danh sách dự định đăng ký (Registration Cart) trước khi gửi yêu cầu tuyển sinh.
* **Mục tiêu Assignment PRJ301 (Tổng 3,0 điểm):**
  1. **Mục 3.2 – Home & Hiển thị dữ liệu (2,0 điểm):** Load dữ liệu thật từ SQL Server qua JPA; phân nhóm theo Môn học / Khối lớp 6–12; tìm kiếm từ khóa linh hoạt; lọc đa tiêu chí (môn, khối, học phí); sắp xếp (mới nhất, học phí tăng/giảm); phân trang động; trang chi tiết khóa học và gợi ý các khóa học liên quan cùng khối/môn.
  2. **Mục 3.6 – Giỏ hàng hoặc tương đương (1,0 điểm):** Danh sách khóa học dự định đăng ký (`/registration-cart`), cho phép thêm khóa học, cập nhật ghi chú/nhu cầu, xóa khỏi danh sách, tự động tính tổng học phí dự kiến, hỗ trợ cả khách vãng lai (Session Cart) và đồng bộ CSDL (`RegistrationCartItems`) khi đăng nhập.
* **Impact:** Kết nối trực tiếp người truy cập từ Trang chủ (`/`) sang luồng Tuyển sinh & CRM (`M03 - Leads`), kích hoạt quy trình xếp lớp và ghi danh (`M05/M06`).

---

## 2. User Personas & Actors

| Vai trò (Actor) | Quyền hạn & Thao tác tại Module |
|---|---|
| **Guest (Khách vãng lai)** | Xem danh sách khóa học, tìm kiếm, lọc, xem chi tiết, thêm vào giỏ hàng session, gửi yêu cầu đăng ký tư vấn. |
| **Student (Học viên)** | Duyệt khóa học, thêm vào giỏ hàng tài khoản, xem các khóa phù hợp với khối lớp của mình, gửi xác nhận đăng ký. |
| **Parent (Phụ huynh)** | Tra cứu khóa học theo khối lớp của con, đối soát học phí niêm yết, chọn nhiều môn/khóa cùng lúc vào giỏ đăng ký. |
| **Staff / Admin** | Xem danh mục khóa học public dưới góc độ khách hàng, kiểm tra hiển thị học phí và trạng thái tuyển sinh `OPEN`/`CLOSED`. |

---

## 3. User Stories

### Story 1 (Happy Path - Tìm kiếm & Lọc khóa học):
> Là một **Học sinh lớp 12 hoặc Phụ huynh**,
> Tôi muốn truy cập trang `/courses`, lọc theo môn Toán/Lý/Hóa và khối 12,
> Để nhanh chóng tìm được khóa luyện thi THPT Quốc Gia với học phí và thời lượng phù hợp.

### Story 2 (Happy Path - Xem chi tiết & Khóa học liên quan):
> Là một **Người dùng đang quan tâm khóa học**,
> Tôi muốn bấm vào xem chi tiết một khóa học tại `/courses/detail?id=...`,
> Để xem mục tiêu đào tạo, lộ trình 24 buổi, thông tin giáo viên phụ trách, lịch mở lớp dự kiến và danh sách các khóa học liên quan gợi ý.

### Story 3 (Happy Path - Quản lý Giỏ đăng ký khóa học):
> Là một **Học sinh/Phụ huynh muốn đăng ký nhiều môn**,
> Tôi muốn bấm "Thêm vào danh sách đăng ký", mở trang `/registration-cart` để xem các khóa đã chọn, xóa môn không cần thiết và xem tổng học phí dự kiến,
> Để chuẩn bị ngân sách và chuyển sang bước gửi hồ sơ đăng ký.

### Story 4 (Happy Path - Xác nhận nhu cầu đăng ký):
> Là một **Người dùng đã chọn xong khóa học trong giỏ**,
> Tôi muốn điền thông tin liên hệ (hoặc tự động điền nếu đã đăng nhập) tại `/registration/confirm`,
> Để gửi thông tin thành Lead chuyển về bộ phận tuyển sinh tư vấn xếp lớp mà không bị mất giỏ hàng.

### Story 5 (Edge Path - Giỏ hàng rỗng & Bộ lọc không có kết quả):
> Là một **Người dùng tìm kiếm khóa học với tiêu chí quá hẹp**,
> Tôi muốn nhận được thông báo Empty State rõ ràng kèm nút "Đặt lại bộ lọc" hoặc "Xem tất cả khóa học",
> Để không bị gián đoạn trải nghiệm trên trang.

---

## 4. Acceptance Criteria (EARS Notation)

### 4.1 Ubiquitous Requirements (Yêu cầu hệ thống phổ quát)
* **THE SYSTEM SHALL** truy vấn 100% dữ liệu khóa học, môn học, giáo viên từ CSDL SQL Server qua JPA `EntityManager` và JPQL bound parameters (tuyệt đối không dùng JDBC thuần).
* **THE SYSTEM SHALL** định dạng toàn bộ số tiền học phí bằng chuẩn tiền tệ Việt Nam (`<fmt:formatNumber value="..." pattern="#,##0" /> VNĐ`).
* **THE SYSTEM SHALL** phân trang danh sách khóa học với kích thước trang chuẩn là **9 khóa học/trang**, hiển thị thanh điều hướng phân trang đồng bộ với các bộ lọc hiện tại.

### 4.2 Event-Driven Requirements (Yêu cầu xử lý sự kiện)
* **WHEN** người dùng gửi yêu cầu lọc hoặc tìm kiếm tại `/courses`:
  * **THE SYSTEM SHALL** áp dụng đồng thời các tiêu chuẩn: từ khóa `q` (tìm trong tên khóa và mô tả), `subjectId`, `gradeLevel` (từ 6 đến 12), khoảng học phí (`feeRange`), và `sort` (mới nhất `newest`, học phí tăng dần `fee_asc`, giảm dần `fee_desc`, tên `name_asc`).
* **WHEN** người dùng chọn một khóa học tại danh sách:
  * **THE SYSTEM SHALL** điều hướng đến `/courses/detail?id={id}`, hiển thị đầy đủ thông tin chi tiết, danh sách lớp học đang mở (`Classes` có trạng thái `OPEN` hoặc `PLANNING`), và truy vấn **Top 3 khóa học liên quan** (ưu tiên cùng môn học hoặc cùng khối lớp).
* **WHEN** người dùng bấm nút "Thêm vào danh sách đăng ký" (`POST /registration-cart/add`):
  * **THE SYSTEM SHALL** kiểm tra khóa học tồn tại và đang ở trạng thái `OPEN`. Nếu người dùng đã đăng nhập, lưu/cập nhật vào bảng `RegistrationCartItems`; nếu là khách vãng lai, lưu vào `sessionScope.registrationCart`. Sau đó redirect về `/registration-cart` kèm flash message thành công.
* **WHEN** người dùng xóa khóa học khỏi giỏ (`POST /registration-cart/remove`):
  * **THE SYSTEM SHALL** xóa bản ghi tương ứng khỏi CSDL/Session và cập nhật lại tổng học phí dự kiến.
* **WHEN** người dùng bấm "Xác nhận gửi hồ sơ đăng ký" tại `/registration/confirm`:
  * **THE SYSTEM SHALL** thực thi trong Transaction: tạo bản ghi `Leads` (nguồn `WEBSITE`, trạng thái `NEW`), lưu các khóa học đã đăng ký vào ghi chú tư vấn, làm trống giỏ hàng và chuyển hướng sang `/consultation/success` hiển thị mã hồ sơ tuyển sinh.

### 4.3 State-Driven Requirements (Yêu cầu theo trạng thái)
* **WHILE** giỏ hàng chưa có khóa học nào:
  * **THE SYSTEM SHALL** hiển thị Empty State thân thiện, vô hiệu hóa nút thanh toán/xác nhận và cung cấp nút "Khám phá khóa học ngay" dẫn về `/courses`.
* **WHILE** một khóa học đang ở trạng thái `CLOSED` hoặc `ARCHIVED`:
  * **THE SYSTEM SHALL** hiển thị huy hiệu "Tạm dừng tuyển sinh" và vô hiệu hóa nút thêm vào giỏ đăng ký.

### 4.4 Unwanted Behavior & Exception Handling (Xử lý ngoại lệ)
* **IF** tham số `id` khóa học trên URL không hợp lệ hoặc không tồn tại trong CSDL:
  * **THEN THE SYSTEM SHALL** chuyển hướng về `/courses` kèm thông báo flash lỗi: *"Không tìm thấy thông tin khóa học yêu cầu."*
* **IF** người dùng thêm vào giỏ một khóa học đã có sẵn trong giỏ:
  * **THEN THE SYSTEM SHALL** hiển thị thông báo: *"Khóa học này đã có trong danh sách đăng ký của bạn."* mà không nhân bản dòng dữ liệu.

---

## 5. UI/UX & Navigation Mapping (Tuân Thủ 100% design.md)

### 5.1 Bảng Danh Sách Màn Hình & URL

| Screen ID | Tên Màn Hình | URL (HTTP Method) | JSP View Path | Vai Trò Cho Phép |
|---|---|---|---|---|
| **PUB-02** | Danh sách khóa học | `GET /courses` | `/WEB-INF/views/public/course-list.jsp` | All / Guest |
| **PUB-03** | Chi tiết khóa học | `GET /courses/detail?id=...` | `/WEB-INF/views/public/course-detail.jsp` | All / Guest |
| **PUB-04** | Giỏ đăng ký khóa học | `GET /registration-cart`<br>`POST /registration-cart/add`<br>`POST /registration-cart/remove` | `/WEB-INF/views/public/registration-cart.jsp` | All / Guest |
| **PUB-05** | Xác nhận nhu cầu đăng ký | `GET /registration/confirm`<br>`POST /registration/confirm` | `/WEB-INF/views/public/registration-confirm.jsp` | All / Guest |
| **PUB-07** | Đăng ký thành công | `GET /consultation/success` | `/WEB-INF/views/public/consultation-success.jsp` | All / Guest |

### 5.2 Quy Chuẩn Giao Diện Theo design.md
* **Default Light Mode:** Nền sáng `--bg: #F8FAFC`, thẻ khóa học Card `--surface: #FFFFFF`, viền mỏng `1px solid var(--border)`, bo góc `border-radius: 12px`, bóng đổ nhẹ `var(--shadow-sm)`.
* **Icons Lucide SVG:**
  * Icon Book-Open (môn học / chương trình).
  * Icon Clock (thời lượng / số buổi).
  * Icon Users (sĩ số tối đa).
  * Icon Graduation-Cap (giáo viên phụ trách).
  * Icon Shopping-Cart / List-Plus (danh sách đăng ký).
  * Icon Search / Filter / Check-Circle.
* **Typography:** Chuẩn `Inter`, tiêu đề thẻ semi-bold 16px, giá tiền học phí 18px đậm màu `--primary`.

---

## 6. Data Model & JPA Entity Design

### 6.1 Các Entity Tham Gia
1. **`Subject` (`dbo.Subjects`):** `id`, `code`, `name`, `description`, `status`.
2. **`Course` (`dbo.Courses`):** `id`, `subject`, `code`, `name`, `gradeLevel`, `targetExam`, `fee`, `durationWeeks`, `totalSessions`, `maxCapacity`, `description`, `imageUrl`, `isFeatured`, `status`.
3. **`Teacher` (`dbo.Teachers`):** `id`, `user`, `fullName`, `specialization`, `degree`, `status`.
4. **`EduClass` (`dbo.Classes`):** `id`, `course`, `teacher`, `room`, `code`, `name`, `capacity`, `startDate`, `endDate`, `status`.
5. **`RegistrationCartItem` (`dbo.RegistrationCartItems`):** `id`, `user` (`User`), `course` (`Course`), `quantity`, `notes`, `createdAt`.

### 6.2 DTOs (Data Transfer Objects)
* `CourseFilterDTO`: keyword, subjectId, gradeLevel, minFee, maxFee, sort, page, pageSize.
* `CourseCardDTO`: id, code, name, subjectName, subjectCode, gradeLevel, targetExam, fee, totalSessions, durationWeeks, maxCapacity, isFeatured, status, openClassCount.
* `CourseDetailDTO`: CourseCardDTO + detailed description, teacherName, teacherDegree, openClasses list.
* `CartItemDTO`: courseId, courseCode, courseName, subjectName, gradeLevel, fee, notes.
* `CartViewDTO`: List<CartItemDTO>, totalCourses, totalFee.
* `RegistrationCheckoutDTO`: fullName, phone, email, gradeLevel, notes, List<Long> courseIds.

---

## 7. Definition of Done (DoD)

- [ ] Lớp Entity `RegistrationCartItem` được ánh xạ chuẩn JPA và khai báo trong `persistence.xml`.
- [ ] `CourseRepository` cung cấp đầy đủ JPQL tìm kiếm, lọc đa tiêu chí, phân trang và truy vấn khóa học liên quan.
- [ ] `CartService` xử lý logic thêm/xóa/tính tổng tiền cho cả Guest (Session) và Authenticated User (Database).
- [ ] `PublicCourseServlet` và `RegistrationCartServlet` áp dụng chuẩn PRG pattern và bảo vệ CSRF trên các POST actions.
- [ ] Các trang JSP (`course-list.jsp`, `course-detail.jsp`, `registration-cart.jsp`, `registration-confirm.jsp`, `consultation-success.jsp`) tuân thủ 100% `design.md` (Default Light mode, SVG outline icons, Design tokens, Empty state).
- [ ] Viết JUnit 5 test suite cho `CourseService` và `CartService` pass 100%.
- [ ] Biên dịch `ant compile` đạt `BUILD SUCCESSFUL`.
- [ ] Commit và push lên nhánh `main`.
