package com.educenter.controller;

import com.educenter.dto.UserPrincipalDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Global router servlet that intelligently dispatches generic URLs (/dashboard, /admin, /staff, etc.)
 * to the corresponding role-specific dashboard or login screen, eliminating 404s and blank screens.
 */
@WebServlet(name = "DashboardRouterServlet", urlPatterns = {
        "/dashboard",
        "/admin",
        "/admin/",
        "/staff",
        "/staff/",
        "/teacher",
        "/teacher/",
        "/student",
        "/student/",
        "/parent",
        "/parent/"
})
public class DashboardRouterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String contextPath = req.getContextPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (path.startsWith("/admin")) {
            if (currentUser != null && currentUser.isAdmin()) {
                resp.sendRedirect(contextPath + "/admin/dashboard");
            } else {
                resp.sendRedirect(contextPath + "/login?redirect_url=/admin/dashboard");
            }
            return;
        }

        if (path.startsWith("/staff")) {
            if (currentUser != null && (currentUser.isStaff() || currentUser.isAdmin())) {
                resp.sendRedirect(contextPath + "/staff/dashboard");
            } else {
                resp.sendRedirect(contextPath + "/login?redirect_url=/staff/dashboard");
            }
            return;
        }

        if (path.startsWith("/teacher")) {
            if (currentUser != null && (currentUser.isTeacher() || currentUser.isAdmin())) {
                resp.sendRedirect(contextPath + "/teacher/dashboard");
            } else {
                resp.sendRedirect(contextPath + "/login?redirect_url=/teacher/dashboard");
            }
            return;
        }

        if (path.startsWith("/student")) {
            if (currentUser != null && (currentUser.isStudent() || currentUser.isAdmin())) {
                resp.sendRedirect(contextPath + "/student/dashboard");
            } else {
                resp.sendRedirect(contextPath + "/login?redirect_url=/student/dashboard");
            }
            return;
        }

        if (path.startsWith("/parent")) {
            if (currentUser != null && (currentUser.isParent() || currentUser.isAdmin())) {
                resp.sendRedirect(contextPath + "/parent/dashboard");
            } else {
                resp.sendRedirect(contextPath + "/login?redirect_url=/parent/dashboard");
            }
            return;
        }

        // Generic /dashboard
        if (currentUser != null) {
            resp.sendRedirect(contextPath + currentUser.getDefaultDashboardUrl());
        } else {
            resp.sendRedirect(contextPath + "/login?redirect_url=/dashboard");
        }
    }
}
