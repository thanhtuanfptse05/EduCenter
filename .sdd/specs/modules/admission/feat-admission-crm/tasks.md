# Tasks: Quản lý Lead & CRM Tuyển sinh (feat-admission-crm)

## Phase 1: Entity & DTOs
- [x] Task 1.1: Tạo entity `Consultation.java` trong `com.educenter.entity` và khai báo vào `persistence.xml`.
- [x] Task 1.2: Tạo các DTOs: `LeadFilterDTO`, `LeadListItemDTO`, `LeadDetailDTO`, `LeadCreateFormDTO`, `ConsultationFormDTO`.

## Phase 2: Repository Layer
- [x] Task 2.1: Mở rộng `LeadRepository.java` với các method `findLeads`, `countLeads`, `getLeadStats`, `findConsultationsByLeadId`, `saveConsultation`, `findStaffUsers`.

## Phase 3: Service Layer & Business Rules
- [x] Task 3.1: Định nghĩa interface `LeadService.java`.
- [x] Task 3.2: Triển khai `LeadServiceImpl.java` xử lý validation, chuyển đổi trạng thái, lịch sử tư vấn.

## Phase 4: Unit Testing
- [x] Task 4.1: Viết `LeadServiceTest.java` (JUnit 5) kiểm tra toàn bộ luồng nghiệp vụ CRM.

## Phase 5: Controller & Refactoring
- [x] Task 5.1: Loại bỏ mapping `"/staff/leads"` khỏi `LandingServlet.java`.
- [x] Task 5.2: Tạo `StaffLeadServlet.java` trong `com.educenter.controller` xử lý các route `/staff/leads*`.

## Phase 6: Views & UI Design System
- [x] Task 6.1: Tạo `web/WEB-INF/views/staff/lead-list.jsp` (ADM-02).
- [x] Task 6.2: Tạo `web/WEB-INF/views/staff/lead-detail.jsp` (ADM-03).
- [x] Task 6.3: Cập nhật sidebar `sidebar.jspf` nếu cần.

## Phase 7: Verification & Push to Main
- [x] Task 7.1: Chạy `scripts\verify.ps1` kiểm tra compile và pass 100% test suites.
- [x] Task 7.2: Commit và push lên nhánh `main`.
