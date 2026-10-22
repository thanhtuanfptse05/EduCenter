# PLAN.MD — EDUCENTER 10-WEEK SPRINT & TASK TRACKING
**Methodology:** Spec-Driven & Agent-Driven Development (SDD/ADD Hybrid)  
**Timeline:** 10 Weeks | **Team:** 3 Members  

---

## MILESTONES
- [x] **M0 (Tuần 1):** Khởi tạo dự án, phân tích SRS v1.1, thiết lập bộ khung SDD (`.sdd/`, `.agents/`, `.specify/`, `.codegraph/`).
- [ ] **M1 (Cuối Tuần 2):** Hoàn thiện ERD 30 bảng, SQL Schema, sitemap, wireframe JSP và kiểm duyệt yêu cầu khách hàng/giảng viên.
- [ ] **M2 (Cuối Tuần 5):** Chạy luồng khóa học, CRM Lead, học viên, phụ huynh và ghi danh (`Enrollment`).
- [ ] **M3 (Cuối Tuần 8):** Tích hợp toàn bộ use case P0: Điểm danh, Điểm số, Hóa đơn/Thanh toán, Q&A, Báo cáo điều hành.
- [ ] **M4 (Cuối Tuần 10):** Kiểm thử tích hợp, UAT, nghiệm thu và bàn giao MVP v1.0.

---

## CURRENT SPRINT: SPRINT 1 (TUẦN 1 - 2) — FOUNDATION & SPECS
* [x] **TASK-01:** Phân chia và tổ chức cấu trúc thư mục theo mô hình SDD Hybrid chuẩn.
* [x] **TASK-02:** Xây dựng `constitution.md`, `business.md` (BR01-BR20), `safety.md`, `shared_context.md`.
* [x] **TASK-03:** Khởi tạo Spec Hierarchy (Global -> Module: Academic, Admission, Finance-Admin -> Feature Specs).
* [ ] **TASK-04:** Thiết lập cấu hình `persistence.xml` kết nối Microsoft SQL Server cho JPA/Hibernate.
* [ ] **TASK-05:** Tạo 30 Entity classes trong `com.educenter.entity`.
* [ ] **TASK-06:** Tạo bộ lọc `AuthenticationFilter`, `RoleFilter`, `EncodingFilter` (UTF-8).
