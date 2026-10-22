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
 * Controller handling public root landing and role dashboard landing routes (FR-008).
 */
@WebServlet(name = "LandingServlet", urlPatterns = {
        "",
        "/index",
        "/admin/dashboard",
        "/staff/leads",
        "/teacher/dashboard",
        "/student/dashboard",
        "/parent/dashboard"
})
public class LandingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (path.isEmpty() || "/".equals(path) || "/index".equals(path)) {
            req.setAttribute("pageTitle", "EduCenter — Hệ Thống Quản Trị Trung Tâm Gia Sư & Luyện Thi");
            req.getRequestDispatcher("/WEB-INF/views/common/landing.jsp").forward(req, resp);
            return;
        }

        // Authenticated dashboard routes
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + path);
            return;
        }

        String roleName = switch (path) {
            case "/admin/dashboard" -> "Quản Trị Viên & Giám Đốc Trung Tâm";
            case "/staff/leads" -> "Tuyển Sinh & Quản Lý Học Vụ";
            case "/teacher/dashboard" -> "Giáo Viên / Gia Sư Giảng Dạy";
            case "/student/dashboard" -> "Học Viên Luyện Thi";
            case "/parent/dashboard" -> "Phụ Huynh Học Sinh";
            default -> "Người Dùng Hệ Thống";
        };

        req.setAttribute("dashboardRoleName", roleName);
        req.setAttribute("dashboardPath", path);
        req.setAttribute("pageTitle", "Bảng điều khiển (" + roleName + ") — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/common/landing.jsp").forward(req, resp);
    }
}
