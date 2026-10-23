package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.service.TeacherManagementService;
import com.educenter.service.TeacherManagementServiceImpl;
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
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "TeacherManagementServlet", urlPatterns = {
        "/staff/teachers",
        "/staff/teachers/form",
        "/staff/teachers/save",
        "/staff/teachers/status"
})
public class TeacherManagementServlet extends HttpServlet {

    private TeacherManagementService teacherService;

    @Override
    public void init() throws ServletException {
        this.teacherService = new TeacherManagementServiceImpl();
    }

    public void setTeacherService(TeacherManagementService teacherService) {
        this.teacherService = teacherService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isStaff() && !user.isAdmin())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        if ("/staff/teachers".equals(path)) {
            handleList(req, resp);
        } else if ("/staff/teachers/form".equals(path)) {
            handleForm(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isStaff() && !user.isAdmin())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã bảo mật không hợp lệ (CSRF). Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/staff/teachers");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/staff/teachers/save" -> handleSave(req, resp, user, ipAddress);
            case "/staff/teachers/status" -> handleStatus(req, resp, user, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String status = req.getParameter("status");
        String sort = req.getParameter("sort");
        String pageStr = req.getParameter("page");

        TeacherFilterDTO filter = new TeacherFilterDTO();
        if (q != null && !q.trim().isEmpty()) {
            filter.setKeyword(q.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            filter.setStatus(status.trim());
        }
        if (sort != null && !sort.trim().isEmpty()) {
            filter.setSort(sort.trim());
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

        TeacherAdminStatsDTO stats = teacherService.getAdminStats();
        List<TeacherAdminViewDTO> teachers = teacherService.getTeachers(filter);
        long totalItems = teacherService.countTeachers(filter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        req.setAttribute("teachers", teachers);
        req.setAttribute("stats", stats);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);

        req.setAttribute("filterQ", q);
        req.setAttribute("filterStatus", status);
        req.setAttribute("filterSort", sort);

        req.setAttribute("pageTitle", "Đội ngũ Giáo viên & Phân công chuyên môn — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/staff/teacher-list.jsp").forward(req, resp);
    }

    private void handleForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        TeacherFormDTO form;
        List<AvailableTeacherUserDTO> availableUsers = null;

        if (id != null) {
            try {
                form = teacherService.getTeacherForEdit(id);
            } catch (ValidationException e) {
                FlashMessageUtil.setError(req, e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/staff/teachers");
                return;
            }
        } else {
            form = new TeacherFormDTO();
            availableUsers = teacherService.getAvailableTeacherUsers();
        }

        req.setAttribute("teacherForm", form);
        req.setAttribute("availableUsers", availableUsers);
        req.setAttribute("isEdit", id != null);
        req.setAttribute("pageTitle", (id != null ? "Chỉnh sửa hồ sơ: " + form.getFullName() : "Thêm mới Giáo viên") + " — EduCenter ERP");

        req.getRequestDispatcher("/WEB-INF/views/staff/teacher-form.jsp").forward(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp,
                            UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String userIdStr = req.getParameter("userId");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String specialization = req.getParameter("specialization");
        String degree = req.getParameter("degree");
        String hourlyRateStr = req.getParameter("hourlyRate");
        String bio = req.getParameter("bio");
        String status = req.getParameter("status");

        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Long userId = null;
        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try { userId = Long.parseLong(userIdStr.trim()); } catch (NumberFormatException ignored) {}
        }

        BigDecimal hourlyRate = BigDecimal.ZERO;
        if (hourlyRateStr != null && !hourlyRateStr.trim().isEmpty()) {
            try {
                String cleanRate = hourlyRateStr.trim().replaceAll("[,.\\sđ/h]", "");
                if (!cleanRate.isEmpty()) {
                    hourlyRate = new BigDecimal(cleanRate);
                }
            } catch (Exception ignored) {
                FlashMessageUtil.setError(req, "Đơn giá thù lao không hợp lệ");
                resp.sendRedirect(req.getContextPath() + (id != null ? "/staff/teachers/form?id=" + id : "/staff/teachers/form"));
                return;
            }
        }

        TeacherFormDTO form = new TeacherFormDTO();
        form.setId(id);
        form.setUserId(userId);
        form.setFullName(fullName);
        form.setPhone(phone);
        form.setEmail(email);
        form.setSpecialization(specialization);
        form.setDegree(degree);
        form.setHourlyRate(hourlyRate);
        form.setBio(bio);
        form.setStatus(status != null ? status : "ACTIVE");

        try {
            teacherService.saveTeacher(form, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, (id == null ? "Thêm mới" : "Cập nhật") + " hồ sơ giáo viên thành công!");
            resp.sendRedirect(req.getContextPath() + "/staff/teachers");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            if (id != null) {
                resp.sendRedirect(req.getContextPath() + "/staff/teachers/form?id=" + id);
            } else {
                resp.sendRedirect(req.getContextPath() + "/staff/teachers/form");
            }
        }
    }

    private void handleStatus(HttpServletRequest req, HttpServletResponse resp,
                              UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");

        if (idStr == null || idStr.trim().isEmpty() || status == null || status.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Dữ liệu cập nhật trạng thái không hợp lệ");
            resp.sendRedirect(req.getContextPath() + "/staff/teachers");
            return;
        }

        try {
            Long id = Long.parseLong(idStr.trim());
            teacherService.updateStatus(id, status.trim(), user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái giáo viên thành công!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/teachers");
    }
}
