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

@WebServlet(name = "SubjectManagementServlet", urlPatterns = {
        "/staff/subjects",
        "/staff/subjects/save",
        "/staff/subjects/status"
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
        if (!"/staff/subjects".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (user == null || (!user.isStaff() && !user.isAdmin())) {
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
        req.setAttribute("pageTitle", "Quản lý môn học — EduCenter ERP");

        req.getRequestDispatcher("/WEB-INF/views/staff/subject-list.jsp").forward(req, resp);
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
            resp.sendRedirect(req.getContextPath() + "/staff/subjects");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/staff/subjects/save" -> handleSaveSubject(req, resp, user, ipAddress);
            case "/staff/subjects/status" -> handleToggleStatus(req, resp, user, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleSaveSubject(HttpServletRequest req, HttpServletResponse resp,
                                   UserPrincipalDTO user, String ipAddress) throws IOException {
        String idParam = req.getParameter("id");
        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String status = req.getParameter("status");

        Long id = null;
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                id = Long.parseLong(idParam.trim());
            } catch (NumberFormatException ignored) {}
        }

        SubjectFormDTO dto = new SubjectFormDTO(id, code, name, description, status);
        try {
            academicProgramService.saveSubject(dto, user.getUserId(), user.getEmail(), ipAddress);
            FlashMessageUtil.setSuccess(req, (id == null ? "Tạo môn học mới thành công!" : "Cập nhật môn học thành công!"));
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi lưu môn học: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/subjects");
    }

    private void handleToggleStatus(HttpServletRequest req, HttpServletResponse resp,
                                    UserPrincipalDTO user, String ipAddress) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã môn học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/subjects");
            return;
        }

        try {
            Long id = Long.parseLong(idParam.trim());
            academicProgramService.toggleSubjectStatus(id, user.getUserId(), user.getEmail(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái môn học thành công.");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/subjects");
    }
}
