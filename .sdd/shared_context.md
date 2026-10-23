# EDUCENTER SHARED CONTEXT & CROSS-AGENT SYNCHRONIZATION
**Version:** 1.0.0 | **Updated:** 2026-10-22
**Team Allocation:** 3 Members | **Timeline:** 10 Weeks

## Trạng thái triển khai — 2026-10-23

**Baseline đặc tả mới:** [15 feature lõi và2 UI supporting specs](specs/README.md) đã phủ12 module/35UC/20BR/30bảng/49screens. Xem [thứ tự code](specs/implementation-order.md); cần plan/tasks mới theo phiên bản spec trước implement. Đây là hoàn tất đặc tả, không hoàn tất ERP. [D01–D17](specs/decisions.md) và [hợp đồng tích hợp](specs/integration.md) thống nhất role/status/phí/lịch/publish; ngoại lệ demo/reset đợt repair cũ chỉ là lịch sử theo D04.

Phạm vi đang chạy: auth/RBAC 5 vai trò (ADMIN gộp quản trị và quản lý trung tâm), quản trị tài khoản, trang chủ/catalog/chi tiết khóa, tư vấn và giỏ đăng ký. Dashboard vai trò hiện là trang điều hướng; `/staff/leads` chưa phải màn hình CRM đầy đủ.

Bản sửa hiện tại: [portal/cart repair](specs/modules/admission/feat-portal-cart-repair/spec.md), [kiểm thử](specs/modules/admission/feat-portal-cart-repair/verification.md). Không còn tính năng giảm giá/coupon/combo trong luồng đã triển khai. Ba nội dung được chủ dự án giữ nguyên được liệt kê trong spec; không đánh dấu chúng là production.

Các phân công/touchpoint bên dưới là kiến trúc và kế hoạch, không phải bằng chứng hoàn thành. Xem [các module chưa triển khai](future-work.md).

---

## 1. SUB-DOMAIN & TEAM RESPONSIBILITY MAPPING

### Member 01: Academic & Learning Subsystem (~35%)
* **Scope Modules:**
  * M04: Academic Programs & Courses (Môn học, khóa học, khối lớp 6-12)
  * M05: Class & Timetable Management (Tạo lớp, xếp lịch, phòng, kiểm tra trùng giờ)
  * M07: Attendance & Teaching Journal (Điểm danh buổi học, ghi bài giảng/bài tập)
  * M08: Assessment & Learning Progress (Kiểm tra đầu vào/giữa kỳ/cuối kỳ, nhập & công bố điểm, biểu đồ tiến bộ)
* **Portals & Views:** `/teacher/*` (Teacher Portal) và các màn hình quản lý học vụ `/staff/classes`, `/staff/courses`, `/staff/timetable`.
* **Git Branch:** `feature/academic`

### Member 02: Admission & Student Subsystem (~35%)
* **Scope Modules:**
  * M01: Public Website & Course Catalog (Trang chủ, danh mục, giỏ đăng ký khóa học)
  * M03: Admission & CRM (Tiếp nhận Lead, lịch sử tư vấn, học thử, chuyển đổi)
  * M06: Student & Guardian Management (Hồ sơ học sinh, phụ huynh, liên kết giám hộ)
  * M10: Notifications & Q&A Community (Diễn đàn hỏi đáp, kiểm duyệt, thông báo)
* **Portals & Views:** `/` (Public Home), `/courses`, `/registration-cart`, `/consultation`, `/student/*`, `/parent/*`, `/questions`.
* **Git Branch:** `feature/admission`

### Member 03: Finance & Administration Subsystem (~30%)
* **Scope Modules:**
  * M02: Authentication & Account Management (Đăng nhập, đăng ký, quên mật khẩu, hồ sơ, RBAC)
  * M09: Tuition & Payment (Hóa đơn, thanh toán đợt, công nợ, biên lai nội bộ)
  * M11: Dashboard & Reporting (Thống kê tuyển sinh, tài chính, chuyên cần, MAX/MIN/AVG/SUM/COUNT)
  * M12: System Administration & Audit Logs (Quản trị người dùng, phân quyền, cấu hình phòng/hệ thống, nhật ký thao tác)
* **Portals & Views:** `/login`, `/register`, `/forgot-password`, `/profile`, `/admin/*`, `/staff/invoices`.
* **Git Branch:** `feature/finance`

---

## 2. INTEGRATION TOUCHPOINTS (ĐIỂM CHẠM GIỮA CÁC PHÂN HỆ)
1. **Enrollment -> Invoice (Admission -> Finance):**
   * Khi Member 02 ghi danh học viên vào lớp (`Enrollment`), hệ thống lập tức sinh ra hóa đơn tương ứng (`Invoice`) thuộc quản lý của Member 03.
2. **Attendance & Grading -> Student Progress (Academic -> Admission):**
   * Dữ liệu điểm danh (`Attendances`) và điểm số (`AssessmentScores`) do Member 01 xây dựng sẽ được hiển thị trên cổng học viên (`StudentPortal`) và cổng phụ huynh (`ParentPortal`) do Member 02 phụ trách.
3. **RBAC Filter -> All Controllers (Finance -> All):**
   * Bộ lọc phân quyền (`com.educenter.filter.RoleFilter`) do Member 03 thiết lập bảo vệ toàn bộ URL của Member 01 và Member 02.
