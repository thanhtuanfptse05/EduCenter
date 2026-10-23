package com.educenter.controller;

import com.educenter.dto.PortalScheduleItemDTO;
import com.educenter.dto.PortalScoreItemDTO;
import com.educenter.dto.StudentDashboardSummaryDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.PortalService;
import com.educenter.service.PortalServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * Controller handling Student Portal views (STD-01, STD-02, STD-03).
 */
@WebServlet(name = "StudentPortalServlet", urlPatterns = {
        "/student/dashboard",
        "/student/schedule",
        "/student/progress"
})
public class StudentPortalServlet extends HttpServlet {

    private PortalService portalService;

    @Override
    public void init() throws ServletException {
        this.portalService = new PortalServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        switch (path) {
            case "/student/dashboard" -> handleDashboard(req, resp, currentUser);
            case "/student/schedule" -> handleSchedule(req, resp, currentUser);
            case "/student/progress" -> handleProgress(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        StudentDashboardSummaryDTO summary = portalService.getStudentDashboard(currentUser.getUserId());
        req.setAttribute("dashboard", summary);
        req.setAttribute("activeNav", "student-dashboard");
        req.setAttribute("pageTitle", "Cổng học viên — Bảng điều khiển");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }

    private void handleSchedule(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        String fromStr = req.getParameter("fromDate");
        String toStr = req.getParameter("toDate");

        LocalDate fromDate = null;
        LocalDate toDate = null;
        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) fromDate = LocalDate.parse(fromStr.trim());
            if (toStr != null && !toStr.trim().isEmpty()) toDate = LocalDate.parse(toStr.trim());
        } catch (DateTimeParseException ignored) {}

        List<PortalScheduleItemDTO> scheduleList = portalService.getStudentSchedule(currentUser.getUserId(), fromDate, toDate);
        req.setAttribute("scheduleList", scheduleList);
        req.setAttribute("fromDate", fromDate != null ? fromDate.toString() : "");
        req.setAttribute("toDate", toDate != null ? toDate.toString() : "");
        req.setAttribute("activeNav", "student-schedule");
        req.setAttribute("pageTitle", "Lịch học & Thời khóa biểu — EduCenter");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/student/schedule.jsp").forward(req, resp);
    }

    private void handleProgress(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        StudentDashboardSummaryDTO summary = portalService.getStudentDashboard(currentUser.getUserId());
        List<PortalScoreItemDTO> scores = portalService.getStudentProgress(currentUser.getUserId());
        req.setAttribute("dashboard", summary);
        req.setAttribute("scores", scores);
        req.setAttribute("activeNav", "student-progress");
        req.setAttribute("pageTitle", "Kết quả học tập & Chuyên cần — EduCenter");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/student/progress.jsp").forward(req, resp);
    }
}
