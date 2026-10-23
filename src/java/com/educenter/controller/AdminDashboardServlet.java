package com.educenter.controller;

import com.educenter.dto.AdminDashboardDTO;
import com.educenter.dto.DetailedReportDTO;
import com.educenter.dto.ReportFilterDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.ReportService;
import com.educenter.service.ReportServiceImpl;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {
        "/admin/dashboard",
        "/admin/reports"
})
public class AdminDashboardServlet extends HttpServlet {

    private final ReportService reportService;

    public AdminDashboardServlet() {
        this.reportService = new ReportServiceImpl();
    }

    public AdminDashboardServlet(ReportService reportService) {
        this.reportService = reportService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (currentUser == null || !currentUser.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + req.getRequestURI());
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);

        String path = req.getServletPath();
        if ("/admin/reports".equals(path)) {
            handleReports(req, resp);
        } else {
            handleDashboard(req, resp);
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AdminDashboardDTO dashboard = reportService.getAdminDashboardData();
        req.setAttribute("dashboard", dashboard);
        req.setAttribute("activeNav", "dashboard");
        req.setAttribute("pageTitle", "Bảng điều khiển Giám đốc & Quản trị — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void handleReports(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ReportFilterDTO filter = new ReportFilterDTO();

        String fromStr = req.getParameter("fromDate");
        if (fromStr != null && !fromStr.trim().isEmpty()) {
            try { filter.setFromDate(LocalDate.parse(fromStr.trim())); } catch (Exception ignored) {}
        } else {
            filter.setFromDate(LocalDate.now().withDayOfMonth(1));
        }

        String toStr = req.getParameter("toDate");
        if (toStr != null && !toStr.trim().isEmpty()) {
            try { filter.setToDate(LocalDate.parse(toStr.trim())); } catch (Exception ignored) {}
        } else {
            filter.setToDate(LocalDate.now());
        }

        String typeStr = req.getParameter("reportType");
        if (typeStr != null && !typeStr.trim().isEmpty()) {
            filter.setReportType(typeStr.trim());
        }

        DetailedReportDTO report = reportService.getDetailedReport(filter);
        req.setAttribute("report", report);
        req.setAttribute("filter", filter);
        req.setAttribute("activeNav", "reports");
        req.setAttribute("pageTitle", "Báo cáo Thống kê & Đối soát Trung tâm — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }
}
