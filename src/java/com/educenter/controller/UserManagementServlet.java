package com.educenter.controller;

import com.educenter.dto.UserPageDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.UserService;
import com.educenter.service.UserServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Administrative controller for User Management and Role-Based Access Control (ADM-18).
 */
@WebServlet(name = "UserManagementServlet", urlPatterns = {
        "/admin/users",
        "/admin/users/status",
        "/admin/users/roles"
})
public class UserManagementServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (!"/admin/users".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String keyword = req.getParameter("q");
        String roleCode = req.getParameter("role");
        String status = req.getParameter("status");
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ignored) {}

        UserPageDTO pageData = userService.getUserList(keyword, roleCode, status, page, 10);
        req.setAttribute("pageData", pageData);
        req.setAttribute("pageTitle", "Quản lý người dùng & Phân quyền — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO admin = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (admin == null || !admin.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String ipAddress = req.getRemoteAddr();
        String returnQuery = buildFilterQuery(req);

        switch (path) {
            case "/admin/users/status" -> handleToggleStatus(req, resp, admin, ipAddress, returnQuery);
            case "/admin/users/roles" -> handleAssignRoles(req, resp, admin, ipAddress, returnQuery);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO admin,
                                    String ipAddress, String returnQuery) throws IOException {
        try {
            Long targetUserId = Long.parseLong(req.getParameter("userId"));
            String newStatus = req.getParameter("actionStatus");
            userService.toggleUserStatus(admin.getUserId(), targetUserId, newStatus, ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái người dùng thành công.");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Tham số yêu cầu không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users" + returnQuery);
    }

    private void handleAssignRoles(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO admin,
                                   String ipAddress, String returnQuery) throws IOException {
        try {
            Long targetUserId = Long.parseLong(req.getParameter("userId"));
            String[] rolesParam = req.getParameterValues("roles");
            Set<String> roleCodes = (rolesParam != null) ? new HashSet<>(Arrays.asList(rolesParam)) : new HashSet<>();
            userService.assignRoles(admin.getUserId(), targetUserId, roleCodes, ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật phân quyền người dùng thành công.");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Tham số phân quyền không hợp lệ.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users" + returnQuery);
    }

    private String buildFilterQuery(HttpServletRequest req) {
        StringBuilder sb = new StringBuilder("?");
        String q = req.getParameter("q");
        String role = req.getParameter("role");
        String status = req.getParameter("status");
        String page = req.getParameter("page");

        if (q != null && !q.isEmpty()) {
            sb.append("q=").append(URLEncoder.encode(q, StandardCharsets.UTF_8)).append("&");
        }
        if (role != null && !role.isEmpty()) {
            sb.append("role=").append(URLEncoder.encode(role, StandardCharsets.UTF_8)).append("&");
        }
        if (status != null && !status.isEmpty()) {
            sb.append("status=").append(URLEncoder.encode(status, StandardCharsets.UTF_8)).append("&");
        }
        if (page != null && !page.isEmpty()) {
            sb.append("page=").append(URLEncoder.encode(page, StandardCharsets.UTF_8));
        }

        String res = sb.toString();
        return res.endsWith("&") ? res.substring(0, res.length() - 1) : res;
    }
}
