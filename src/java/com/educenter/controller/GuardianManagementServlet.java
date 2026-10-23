package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.Guardian;
import com.educenter.entity.User;
import com.educenter.service.StudentService;
import com.educenter.service.StudentServiceImpl;
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
import java.util.List;

@WebServlet(name = "GuardianManagementServlet", urlPatterns = {
        "/staff/guardians",
        "/staff/guardians/save",
        "/staff/guardians/status",
        "/staff/guardians/link",
        "/staff/guardians/unlink",
        "/staff/guardians/verify",
        "/staff/guardians/revoke",
        "/admin/guardians"
})
public class GuardianManagementServlet extends HttpServlet {

    private StudentService studentService;

    @Override
    public void init() throws ServletException {
        this.studentService = new StudentServiceImpl();
    }

    public void setStudentService(StudentService studentService) {
        this.studentService = studentService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isAdmin() && !user.isStaff())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if ("/admin/guardians".equals(path)) {
            resp.sendRedirect(req.getContextPath() + "/staff/guardians");
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        req.setAttribute("activeNav", "guardians");
        req.setAttribute("internalShell", true);

        if ("/staff/guardians".equals(path)) {
            handleList(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isAdmin() && !user.isStaff())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã CSRF không hợp lệ. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/staff/guardians");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/staff/guardians/save" -> handleSave(req, resp, user, ipAddress);
            case "/staff/guardians/status" -> handleStatus(req, resp, user, ipAddress);
            case "/staff/guardians/link" -> handleLink(req, resp, user, ipAddress);
            case "/staff/guardians/unlink" -> handleUnlink(req, resp, user, ipAddress);
            case "/staff/guardians/verify" -> handleVerify(req, resp, user, ipAddress);
            case "/staff/guardians/revoke" -> handleRevoke(req, resp, user, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String status = req.getParameter("status");
        String verification = req.getParameter("verification");
        String pageStr = req.getParameter("page");

        GuardianFilterDTO filter = new GuardianFilterDTO();
        if (q != null && !q.trim().isEmpty()) {
            filter.setKeyword(q.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            filter.setStatus(status.trim());
        }
        if (verification != null && !verification.trim().isEmpty()) {
            filter.setVerification(verification.trim());
        }

        int page = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr.trim()));
            } catch (NumberFormatException ignored) {}
        }
        int pageSize = 10;
        filter.setPage(page);
        filter.setPageSize(pageSize);

        List<GuardianAdminViewDTO> guardians = studentService.getGuardians(filter);
        long totalItems = studentService.countGuardians(filter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        List<User> availableParentUsers = studentService.getAvailableParentUsers(null);

        req.setAttribute("guardians", guardians);
        req.setAttribute("filter", filter);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("availableParentUsers", availableParentUsers);

        req.getRequestDispatcher("/WEB-INF/views/staff/guardian-list.jsp").forward(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String userIdStr = req.getParameter("userId");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String occupation = req.getParameter("occupation");
        String address = req.getParameter("address");
        String status = req.getParameter("status");
        String redirect = req.getParameter("redirect");

        GuardianFormDTO form = new GuardianFormDTO();
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                form.setId(Long.parseLong(idStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                form.setUserId(Long.parseLong(userIdStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        form.setFullName(fullName);
        form.setPhone(phone);
        form.setEmail(email);
        form.setOccupation(occupation);
        form.setAddress(address);
        form.setStatus(status != null && !status.trim().isEmpty() ? status.trim() : "ACTIVE");

        try {
            Guardian saved = studentService.saveGuardian(form, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, (form.getId() == null ? "Thêm mới" : "Cập nhật") + " hồ sơ phụ huynh " + saved.getFullName() + " (" + saved.getCode() + ") thành công.");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        }

        if (redirect != null && !redirect.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + redirect.trim());
        } else {
            resp.sendRedirect(req.getContextPath() + "/staff/guardians");
        }
    }

    private void handleStatus(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");

        if (idStr == null || status == null) {
            FlashMessageUtil.setError(req, "Tham số không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/guardians");
            return;
        }

        try {
            Long guardianId = Long.parseLong(idStr.trim());
            studentService.updateGuardianStatus(guardianId, status.trim(), user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái phụ huynh thành " + status + " thành công.");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException nfe) {
            FlashMessageUtil.setError(req, "Mã phụ huynh không hợp lệ.");
        }

        resp.sendRedirect(req.getContextPath() + "/staff/guardians");
    }

    private void handleLink(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String studentIdStr = req.getParameter("studentId");
        String guardianIdStr = req.getParameter("guardianId");
        String relationship = req.getParameter("relationship");
        String isPrimaryStr = req.getParameter("isPrimary");
        String redirect = req.getParameter("redirect");

        if (studentIdStr == null || guardianIdStr == null) {
            FlashMessageUtil.setError(req, "Vui lòng chọn học viên và phụ huynh.");
            redirectAfterAction(req, resp, redirect);
            return;
        }

        try {
            Long studentId = Long.parseLong(studentIdStr.trim());
            Long guardianId = Long.parseLong(guardianIdStr.trim());
            boolean isPrimary = "true".equalsIgnoreCase(isPrimaryStr) || "1".equals(isPrimaryStr);

            studentService.linkGuardianToStudent(studentId, guardianId, relationship, isPrimary, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Thiết lập liên kết phụ huynh - học viên thành công (chờ xác thực hồ sơ).");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã đối tượng không hợp lệ.");
        }

        redirectAfterAction(req, resp, redirect);
    }

    private void handleUnlink(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String linkIdStr = req.getParameter("linkId");
        String redirect = req.getParameter("redirect");

        if (linkIdStr == null || linkIdStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã liên kết không hợp lệ.");
            redirectAfterAction(req, resp, redirect);
            return;
        }

        try {
            Long linkId = Long.parseLong(linkIdStr.trim());
            studentService.unlinkGuardianFromStudent(linkId, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Hủy liên kết giám hộ thành công.");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã liên kết không hợp lệ.");
        }

        redirectAfterAction(req, resp, redirect);
    }

    private void handleVerify(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String linkIdStr = req.getParameter("linkId");
        String notes = req.getParameter("notes");
        String redirect = req.getParameter("redirect");

        if (linkIdStr == null || linkIdStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã liên kết không hợp lệ.");
            redirectAfterAction(req, resp, redirect);
            return;
        }

        try {
            Long linkId = Long.parseLong(linkIdStr.trim());
            studentService.verifyGuardianLink(linkId, notes, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Xác thực quan hệ giám hộ thành công. Phụ huynh đã được cấp quyền tra cứu thông tin con em.");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã liên kết không hợp lệ.");
        }

        redirectAfterAction(req, resp, redirect);
    }

    private void handleRevoke(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String linkIdStr = req.getParameter("linkId");
        String reason = req.getParameter("reason");
        String redirect = req.getParameter("redirect");

        if (linkIdStr == null || linkIdStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã liên kết không hợp lệ.");
            redirectAfterAction(req, resp, redirect);
            return;
        }

        try {
            Long linkId = Long.parseLong(linkIdStr.trim());
            studentService.revokeGuardianLink(linkId, reason, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Thu hồi quyền giám hộ thành công. Quyền truy cập thông tin con em đã được đóng.");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã liên kết không hợp lệ.");
        }

        redirectAfterAction(req, resp, redirect);
    }

    private void redirectAfterAction(HttpServletRequest req, HttpServletResponse resp, String redirect) throws IOException {
        if (redirect != null && !redirect.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + redirect.trim());
        } else {
            resp.sendRedirect(req.getContextPath() + "/staff/guardians");
        }
    }
}
