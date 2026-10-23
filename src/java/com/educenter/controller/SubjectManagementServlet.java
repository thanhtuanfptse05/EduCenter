package com.educenter.controller;

import com.educenter.dto.SubjectAdminViewDTO;
import com.educenter.dto.SubjectFormDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.ValidationException;
import com.educenter.service.AcademicProgramService;
import com.educenter.service.AcademicProgramServiceImpl;
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

/**
 * Controller for Subject Catalog Management (ADM-05, UC10).
 * Strictly restricted to ADMIN / Center Managers.
 */
@WebServlet(name = "SubjectManagementServlet", urlPatterns = {
        "/admin/subjects",
        "/admin/subjects/save",
        "/admin/subjects/status"
})
public class SubjectManagementServlet extends HttpServlet {

    private AcademicProgramService academicProgramService;

    @Override
    public void init() throws ServletException {
        this.academicProgramService = new AcademicProgramServiceImpl();
    }

    public void setAcademicProgramService(AcademicProgramService academicProgramService) {
        this.academicProgramService = academicProgramService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (!"/admin/subjects".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        List<SubjectAdminViewDTO> subjects = academicProgramService.getSubjectAdminList();

        long activeCount = subjects.stream().filter(s -> "ACTIVE".equalsIgnoreCase(s.getStatus())).count();
        long inactiveCount = subjects.size() - activeCount;
        long totalCourses = subjects.stream().mapToLong(SubjectAdminViewDTO::getTotalCourses).sum();

        req.setAttribute("subjects", subjects);
        req.setAttribute("totalSubjects", subjects.size());
        req.setAttribute("activeCount", activeCount);
        req.setAttribute("inactiveCount", inactiveCount);
        req.setAttribute("totalCourses", totalCourses);
        req.setAttribute("pageTitle", "Quản lý danh mục môn học — EduCenter ERP");

        req.getRequestDispatcher("/WEB-INF/views/admin/subject-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã bảo mật không hợp lệ (CSRF). Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/admin/subjects");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/admin/subjects/save" -> handleSaveSubject(req, resp, user, ipAddress);
            case "/admin/subjects/status" -> handleToggleStatus(req, resp, user, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleSaveSubject(HttpServletRequest req, HttpServletResponse resp,
                                   UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String status = req.getParameter("status");

        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        SubjectFormDTO dto = new SubjectFormDTO();
        dto.setId(id);
        dto.setCode(code);
        dto.setName(name);
        dto.setDescription(description);
        dto.setStatus(status != null ? status : "ACTIVE");

        try {
            academicProgramService.saveSubject(dto, user.getUserId(), user.getEmail(), ipAddress);
            FlashMessageUtil.setSuccess(req, (id == null ? "Thêm mới môn học thành công!" : "Cập nhật môn học thành công!"));
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi lưu môn học: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/subjects");
    }

    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp,
                                    UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã môn học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/subjects");
            return;
        }

        try {
            Long id = Long.parseLong(idStr.trim());
            academicProgramService.toggleSubjectStatus(id, user.getUserId(), user.getEmail(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái môn học thành công!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi đổi trạng thái: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/subjects");
    }
}
