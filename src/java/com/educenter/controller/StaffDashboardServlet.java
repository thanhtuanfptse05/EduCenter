package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Controller serving dedicated Admissions & Customer Operations Dashboard for Staff (/staff/dashboard).
 */
@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/staff/dashboard"})
public class StaffDashboardServlet extends HttpServlet {

    private final LeadService leadService;
    private final EnrollmentService enrollmentService;
    private final ClassTimetableService classTimetableService;

    public StaffDashboardServlet() {
        this.leadService = new LeadServiceImpl();
        this.enrollmentService = new EnrollmentServiceImpl();
        this.classTimetableService = new ClassTimetableServiceImpl();
    }

    public StaffDashboardServlet(LeadService leadService, EnrollmentService enrollmentService, ClassTimetableService classTimetableService) {
        this.leadService = leadService;
        this.enrollmentService = enrollmentService;
        this.classTimetableService = classTimetableService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (currentUser == null || (!currentUser.isStaff() && !currentUser.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + req.getRequestURI());
            return;
        }

        // 1. Lead KPI Stats
        Map<String, Long> leadStats = leadService.getLeadStats();
        req.setAttribute("leadStats", leadStats);

        // 2. Recent Leads assigned to staff (or top recent leads if admin/all)
        LeadFilterDTO filter = new LeadFilterDTO();
        filter.setPage(1);
        filter.setPageSize(6);
        if (currentUser.isStaff() && !currentUser.isAdmin()) {
            filter.setStaffUserId(currentUser.getUserId());
        }
        Map<String, Object> leadData = leadService.getLeadListPage(filter);
        req.setAttribute("myLeads", leadData.get("leads"));

        // 3. New unassigned leads needing attention
        LeadFilterDTO unassignedFilter = new LeadFilterDTO();
        unassignedFilter.setStatus("NEW");
        unassignedFilter.setPage(1);
        unassignedFilter.setPageSize(5);
        Map<String, Object> unassignedData = leadService.getLeadListPage(unassignedFilter);
        req.setAttribute("unassignedLeads", unassignedData.get("leads"));

        // 4. Recent Enrollments
        EnrollmentPageDTO enrollmentPage = enrollmentService.getEnrollmentsPaged(null, null, null, 1, 6);
        req.setAttribute("recentEnrollments", enrollmentPage.getItems());
        req.setAttribute("enrollmentStats", enrollmentPage);

        // 5. Classes enrolling
        ClassFilterDTO classFilter = new ClassFilterDTO();
        classFilter.setStatus("OPEN");
        List<ClassAdminViewDTO> openClasses = classTimetableService.getClasses(classFilter);
        req.setAttribute("openClasses", openClasses);

        req.setAttribute("activeNav", "dashboard");
        req.setAttribute("breadcrumb", "Bàn làm việc Tuyển sinh & Chăm sóc Khách hàng");
        req.setAttribute("pageTitle", "Bàn làm việc Tuyển sinh — EduCenter ERP");
        req.setAttribute("internalShell", true);

        req.getRequestDispatcher("/WEB-INF/views/staff/dashboard.jsp").forward(req, resp);
    }
}
