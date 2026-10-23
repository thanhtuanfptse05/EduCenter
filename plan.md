# PLAN.MD — EDUCENTER 10-WEEK SPRINT & TASK TRACKING

> Bảng mốc/checkbox bên dưới là kế hoạch lịch sử, không xác nhận tiến độ baseline đặc tả ngày2026-10-23. Bộ [spec đầy đủ](.sdd/specs/README.md) đã được bổ sung; dùng [thứ tự code](.sdd/specs/implementation-order.md) và lập plan/tasks từng feature hiện hành trước triển khai. Không coi spec locked hoặc task cũ là bằng chứng ERP hoàn tất.
**Methodology:** Spec-Driven & Agent-Driven Development (SDD/ADD Hybrid)  
**Timeline:** 10 Weeks | **Team:** 3 Members  

---

## MILESTONES
- [x] **M0 (Tuần 1):** Khởi tạo dự án, phân tích SRS v1.1, thiết lập bộ khung SDD (`.sdd/`, `.agents/`, `.specify/`, `.codegraph/`).
- [x] **M1 (Cuối Tuần 2):** Hoàn thiện ERD 30 bảng, SQL Server Schema DDL (`EduCenter_Schema_SQLServer.sql`), Design System (`design.md`) và Feature Spec đầu tiên (`feat-auth-rbac`).
- [ ] **M2 (Cuối Tuần 5):** Chạy luồng khóa học, CRM Lead, học viên, phụ huynh và ghi danh (`Enrollment`).
- [ ] **M3 (Cuối Tuần 8):** Tích hợp toàn bộ use case P0: Điểm danh, Điểm số, Hóa đơn/Thanh toán, Q&A, Báo cáo điều hành.
- [ ] **M4 (Cuối Tuần 10):** Kiểm thử tích hợp, UAT, nghiệm thu và bàn giao MVP v1.0.

---

## CURRENT SPRINT: SPRINT 1 (TUẦN 1 - 2) — FOUNDATION & SPECS
* [x] **TASK-01:** Phân chia và tổ chức cấu trúc thư mục theo mô hình SDD Hybrid chuẩn.
* [x] **TASK-02:** Xây dựng `constitution.md`, `business.md` (BR01-BR20), `safety.md`, `shared_context.md`.
* [x] **TASK-03:** Khởi tạo Spec Hierarchy (Global -> Module: Academic, Admission, Finance-Admin -> Feature Specs).
* [x] **TASK-04:** Thiết kế CSDL SQL Server 30 bảng (`DATABASE_DESIGN.md`) và script DDL khởi tạo (`EduCenter_Schema_SQLServer.sql`).
* [x] **TASK-05:** Chuẩn hóa Design System (`design.md`) và thiết lập quy tắc bắt buộc áp dụng toàn hệ thống.
* [x] **TASK-06:** Hoàn thành bộ Spec `feat-auth-rbac` (`spec.md`, `plan.md`, `tasks.md`) sẵn sàng triển khai.
* [ ] **TASK-07:** Cài đặt triển khai Phase 1 - Phase 7 của `feat-auth-rbac` (AuthService, JPA Repository, Security Filter, Login/Register/Profile JSP Views).

