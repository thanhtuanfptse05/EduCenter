package com.educenter.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Public controller serving educational policies, terms of service, privacy regulations,
 * tuition refund rules, and institutional support channels.
 */
@WebServlet(name = "PolicyServlet", urlPatterns = {
        "/terms",
        "/privacy",
        "/refund-policy",
        "/support"
})
public class PolicyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        switch (path) {
            case "/terms":
                req.setAttribute("pageTitle", "Quy chế đào tạo & Điều khoản dịch vụ — EduCenter");
                req.setAttribute("activeNav", "terms");
                req.getRequestDispatcher("/WEB-INF/views/public/policy-terms.jsp").forward(req, resp);
                break;
            case "/privacy":
                req.setAttribute("pageTitle", "Chính sách bảo mật dữ liệu học tập — EduCenter");
                req.setAttribute("activeNav", "privacy");
                req.getRequestDispatcher("/WEB-INF/views/public/policy-privacy.jsp").forward(req, resp);
                break;
            case "/refund-policy":
                req.setAttribute("pageTitle", "Quy định hoàn phí & Bảo lưu học tập — EduCenter");
                req.setAttribute("activeNav", "refund-policy");
                req.getRequestDispatcher("/WEB-INF/views/public/policy-refund.jsp").forward(req, resp);
                break;
            case "/support":
                req.setAttribute("pageTitle", "Trung tâm hỗ trợ kỹ thuật & Liên hệ — EduCenter");
                req.setAttribute("activeNav", "support");
                req.getRequestDispatcher("/WEB-INF/views/public/policy-support.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/");
                break;
        }
    }
}
