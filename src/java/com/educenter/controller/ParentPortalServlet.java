package com.educenter.controller;

import com.educenter.dto.ParentDashboardSummaryDTO;
import com.educenter.dto.StudentDashboardSummaryDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.PortalService;
import com.educenter.service.PortalServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller handling Parent Portal views (PAR-01, PAR-02) with strict child verification.
 */
@WebServlet(name = "ParentPortalServlet", urlPatterns = {
        "/parent/dashboard",
        "/parent/progress",
        "/parent/children/detail"
})
public class ParentPortalServlet extends HttpServlet {

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
            case "/parent/dashboard" -> handleDashboard(req, resp, currentUser);
            case "/parent/progress" -> handleProgress(req, resp, currentUser);
            case "/parent/children/detail" -> handleChildDetail(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        String childIdStr = req.getParameter("childId");
        Long selectedChildId = null;
        if (childIdStr != null && !childIdStr.trim().isEmpty()) {
            try {
                selectedChildId = Long.parseLong(childIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        ParentDashboardSummaryDTO dashboard = portalService.getParentDashboard(currentUser.getUserId(), selectedChildId);
        req.setAttribute("dashboard", dashboard);
        req.setAttribute("activeNav", "parent-dashboard");
        req.setAttribute("pageTitle", "Cổng phụ huynh — Theo dõi học tập của con");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/parent/dashboard.jsp").forward(req, resp);
    }

    private void handleProgress(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        String childIdStr = req.getParameter("childId");
        if (childIdStr == null || childIdStr.trim().isEmpty()) {
            childIdStr = req.getParameter("id");
        }

        Long childStudentId = null;
        if (childIdStr != null && !childIdStr.trim().isEmpty()) {
            try {
                childStudentId = Long.parseLong(childIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        ParentDashboardSummaryDTO parentSummary = portalService.getParentDashboard(currentUser.getUserId(), childStudentId);
        if (childStudentId == null) {
            childStudentId = parentSummary.getSelectedChildId();
        }
        if (childStudentId == null && parentSummary.hasChildren()) {
            childStudentId = parentSummary.getVerifiedChildren().get(0).getId();
        }

        if (childStudentId == null) {
            req.setAttribute("dashboard", parentSummary);
            req.setAttribute("activeNav", "parent-progress");
            req.setAttribute("pageTitle", "Tiến độ học tập của con — EduCenter");
            req.setAttribute("internalShell", true);
            req.getRequestDispatcher("/WEB-INF/views/parent/dashboard.jsp").forward(req, resp);
            return;
        }

        try {
            StudentDashboardSummaryDTO childDetail = portalService.getChildDetail(currentUser.getUserId(), childStudentId);
            req.setAttribute("childDetail", childDetail);
            req.setAttribute("parentSummary", parentSummary);
            req.setAttribute("activeNav", "parent-progress");
            req.setAttribute("breadcrumb", "Tiến độ & Kết quả học tập của con");
            req.setAttribute("pageTitle", "Tiến độ học tập: " + childDetail.getStudentName() + " — EduCenter");
            req.setAttribute("internalShell", true);
            req.getRequestDispatcher("/WEB-INF/views/parent/child-detail.jsp").forward(req, resp);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/parent/dashboard");
        }
    }

    private void handleChildDetail(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/parent/dashboard");
            return;
        }

        try {
            Long childStudentId = Long.parseLong(idStr.trim());
            StudentDashboardSummaryDTO childDetail = portalService.getChildDetail(currentUser.getUserId(), childStudentId);
            req.setAttribute("childDetail", childDetail);
            req.setAttribute("activeNav", "parent-dashboard");
            req.setAttribute("pageTitle", "Chi tiết hồ sơ học tập: " + childDetail.getStudentName() + " — EduCenter");
            req.setAttribute("internalShell", true);
            req.getRequestDispatcher("/WEB-INF/views/parent/child-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã học sinh không đúng định dạng.");
            resp.sendRedirect(req.getContextPath() + "/parent/dashboard");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/parent/dashboard");
        }
    }
}
