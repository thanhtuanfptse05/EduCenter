package com.educenter.controller;

import com.educenter.dto.SystemSettingsGroupedDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.AuditLog;
import com.educenter.service.AuthorizationException;
import com.educenter.service.SystemSettingService;
import com.educenter.service.SystemSettingServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.CsrfUtil;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for System Administration & Configuration dashboard (ADM-19).
 */
@WebServlet(name = "SystemSettingServlet", urlPatterns = {
        "/admin/settings",
        "/admin/settings/save",
        "/admin/settings/toggle-admissions"
})
public class SystemSettingServlet extends HttpServlet {

    private SystemSettingService systemSettingService;

    @Override
    public void init() throws ServletException {
        this.systemSettingService = new SystemSettingServiceImpl();
    }

    public void setSystemSettingService(SystemSettingService systemSettingService) {
        this.systemSettingService = systemSettingService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (!"/admin/settings".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        HttpSession session = req.getSession(false);
        UserPrincipalDTO admin = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (admin == null || !admin.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        SystemSettingsGroupedDTO grouped = systemSettingService.getGroupedSettings();
        List<AuditLog> recentLogs = systemSettingService.getRecentAuditLogs(20);

        String activeTab = req.getParameter("tab");
        if (activeTab == null || activeTab.trim().isEmpty()) {
            activeTab = "config";
        }

        req.setAttribute("groupedSettings", grouped);
        req.setAttribute("recentAuditLogs", recentLogs);
        req.setAttribute("activeTab", activeTab);
        req.setAttribute("pageTitle", "Cấu hình hệ thống & Quản trị — EduCenter ERP");

        req.getRequestDispatcher("/WEB-INF/views/admin/settings.jsp").forward(req, resp);
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

        // Validate CSRF token
        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã bảo mật không hợp lệ (CSRF). Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/admin/settings");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/admin/settings/save" -> handleSaveSettings(req, resp, admin, ipAddress);
            case "/admin/settings/toggle-admissions" -> handleToggleAdmissions(req, resp, admin, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleSaveSettings(HttpServletRequest req, HttpServletResponse resp,
                                    UserPrincipalDTO admin, String ipAddress) throws IOException {
        Map<String, String> values = new HashMap<>();
        addIfPresent(req, values, SystemSettingServiceImpl.KEY_CENTER_NAME);
        addIfPresent(req, values, SystemSettingServiceImpl.KEY_CENTER_HOTLINE);
        addIfPresent(req, values, SystemSettingServiceImpl.KEY_CENTER_EMAIL);
        addIfPresent(req, values, SystemSettingServiceImpl.KEY_CENTER_ADDRESS);
        addIfPresent(req, values, SystemSettingServiceImpl.KEY_MAX_CAPACITY);
        addIfPresent(req, values, SystemSettingServiceImpl.KEY_TUITION_DUE_DAYS);

        try {
            systemSettingService.updateSettings(admin.getUserId(), values, ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật tham số cấu hình hệ thống thành công.");
        } catch (ValidationException | AuthorizationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Đã xảy ra lỗi khi lưu cấu hình. Vui lòng thử lại.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/settings");
    }

    private void handleToggleAdmissions(HttpServletRequest req, HttpServletResponse resp,
                                        UserPrincipalDTO admin, String ipAddress) throws IOException {
        String openParam = req.getParameter("admissionsOpen");
        boolean open = "true".equalsIgnoreCase(openParam);

        try {
            systemSettingService.setAdmissionsOpen(admin.getUserId(), open, ipAddress);
            if (open) {
                FlashMessageUtil.setSuccess(req, "Đã mở tiếp nhận đơn tuyển sinh mới.");
            } else {
                FlashMessageUtil.setWarning(req, "Đã tạm dừng tiếp nhận đơn tuyển sinh mới trên toàn hệ thống.");
            }
        } catch (ValidationException | AuthorizationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Không thể thay đổi trạng thái tuyển sinh. Vui lòng thử lại.");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/settings");
    }

    private void addIfPresent(HttpServletRequest req, Map<String, String> map, String key) {
        String val = req.getParameter(key);
        if (val != null) {
            map.put(key, val);
        }
    }
}
