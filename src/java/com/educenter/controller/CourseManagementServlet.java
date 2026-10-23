package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.Subject;
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
import java.math.BigDecimal;
import java.util.List;

/**
 * Controller for Course & Curriculum Management (ADM-04, ADM-05, UC11).
 * Strictly restricted to ADMIN / Center Managers.
 */
@WebServlet(name = "CourseManagementServlet", urlPatterns = {
        "/admin/courses",
        "/admin/courses/form",
        "/admin/courses/save",
        "/admin/courses/status"
})
public class CourseManagementServlet extends HttpServlet {

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
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        // Strictly ADMIN only
        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        if ("/admin/courses".equals(path)) {
            handleList(req, resp);
        } else if ("/admin/courses/form".equals(path)) {
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

        // Strictly ADMIN only
        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã bảo mật không hợp lệ (CSRF). Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/admin/courses");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/admin/courses/save" -> handleSaveCourse(req, resp, user, ipAddress);
            case "/admin/courses/status" -> handleUpdateStatus(req, resp, user, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String subjectIdStr = req.getParameter("subjectId");
        String gradeStr = req.getParameter("grade");
        String status = req.getParameter("status");
        String sort = req.getParameter("sort");
        String pageStr = req.getParameter("page");

        CourseFilterDTO filter = new CourseFilterDTO();
        if (q != null && !q.trim().isEmpty()) {
            filter.setKeyword(q.trim());
        }
        if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
            try { filter.setSubjectId(Long.parseLong(subjectIdStr.trim())); } catch (NumberFormatException ignored) {}
        }
        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try { filter.setGradeLevel(Integer.parseInt(gradeStr.trim())); } catch (NumberFormatException ignored) {}
        }
        if (status != null && !status.trim().isEmpty()) {
            filter.setStatus(status.trim());
        }
        if (sort != null && !sort.trim().isEmpty()) {
            filter.setSort(sort.trim());
        }

        int page = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try { page = Math.max(1, Integer.parseInt(pageStr.trim())); } catch (NumberFormatException ignored) {}
        }
        int pageSize = 10;
        filter.setPage(page);
        filter.setPageSize(pageSize);

        CourseAdminStatsDTO stats = academicProgramService.getCourseAdminStats();
        List<CourseAdminViewDTO> courses = academicProgramService.getCourseAdminList(filter);
        long totalItems = academicProgramService.countCourseAdminList(filter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        List<Subject> subjects = academicProgramService.getActiveSubjects();

        req.setAttribute("courses", courses);
        req.setAttribute("stats", stats);
        req.setAttribute("subjects", subjects);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);

        req.setAttribute("filterQ", q);
        req.setAttribute("filterSubjectId", subjectIdStr);
        req.setAttribute("filterGrade", gradeStr);
        req.setAttribute("filterStatus", status);
        req.setAttribute("filterSort", sort);

        req.setAttribute("pageTitle", "Quản lý khóa học & Chương trình — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/admin/course-list.jsp").forward(req, resp);
    }

    private void handleForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        CourseFormDTO form;
        if (id != null) {
            try {
                form = academicProgramService.getCourseForm(id);
            } catch (ValidationException e) {
                FlashMessageUtil.setError(req, e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/admin/courses");
                return;
            }
        } else {
            form = new CourseFormDTO();
        }

        List<Subject> subjects = academicProgramService.getActiveSubjects();

        req.setAttribute("courseForm", form);
        req.setAttribute("subjects", subjects);
        req.setAttribute("isEdit", id != null);
        req.setAttribute("pageTitle", (id != null ? "Chỉnh sửa khóa học: " + form.getName() : "Tạo khóa học mới") + " — EduCenter ERP");

        req.getRequestDispatcher("/WEB-INF/views/admin/course-form.jsp").forward(req, resp);
    }

    private void handleSaveCourse(HttpServletRequest req, HttpServletResponse resp,
                                  UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String subjectIdStr = req.getParameter("subjectId");
        String code = req.getParameter("code");
        String name = req.getParameter("name");
        String gradeStr = req.getParameter("gradeLevel");
        String targetExam = req.getParameter("targetExam");
        String feeStr = req.getParameter("fee");
        String durationStr = req.getParameter("durationWeeks");
        String sessionsStr = req.getParameter("totalSessions");
        String capacityStr = req.getParameter("maxCapacity");
        String description = req.getParameter("description");
        String imageUrl = req.getParameter("imageUrl");
        String isFeaturedStr = req.getParameter("isFeatured");
        String status = req.getParameter("status");

        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Long subjectId = null;
        if (subjectIdStr != null && !subjectIdStr.trim().isEmpty()) {
            try { subjectId = Long.parseLong(subjectIdStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Integer grade = null;
        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try { grade = Integer.parseInt(gradeStr.trim()); } catch (NumberFormatException ignored) {}
        }

        BigDecimal fee = BigDecimal.ZERO;
        if (feeStr != null && !feeStr.trim().isEmpty()) {
            try {
                String cleanFee = feeStr.replaceAll("[,\\s]", "");
                fee = new BigDecimal(cleanFee);
            } catch (Exception ignored) {}
        }

        Integer duration = 12;
        if (durationStr != null && !durationStr.trim().isEmpty()) {
            try { duration = Integer.parseInt(durationStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Integer sessions = 24;
        if (sessionsStr != null && !sessionsStr.trim().isEmpty()) {
            try { sessions = Integer.parseInt(sessionsStr.trim()); } catch (NumberFormatException ignored) {}
        }

        Integer capacity = 15;
        if (capacityStr != null && !capacityStr.trim().isEmpty()) {
            try { capacity = Integer.parseInt(capacityStr.trim()); } catch (NumberFormatException ignored) {}
        }

        boolean isFeatured = "true".equalsIgnoreCase(isFeaturedStr) || "on".equalsIgnoreCase(isFeaturedStr);

        CourseFormDTO dto = new CourseFormDTO();
        dto.setId(id);
        dto.setSubjectId(subjectId);
        dto.setCode(code);
        dto.setName(name);
        dto.setGradeLevel(grade);
        dto.setTargetExam(targetExam);
        dto.setFee(fee);
        dto.setDurationWeeks(duration);
        dto.setTotalSessions(sessions);
        dto.setMaxCapacity(capacity);
        dto.setDescription(description);
        dto.setImageUrl(imageUrl);
        dto.setIsFeatured(isFeatured);
        dto.setStatus(status);

        try {
            academicProgramService.saveCourse(dto, user.getUserId(), user.getEmail(), ipAddress);
            FlashMessageUtil.setSuccess(req, (id == null ? "Tạo khóa học mới thành công!" : "Cập nhật khóa học thành công!"));
            resp.sendRedirect(req.getContextPath() + "/admin/courses");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            if (id != null) {
                resp.sendRedirect(req.getContextPath() + "/admin/courses/form?id=" + id);
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/courses/form");
            }
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi lưu khóa học: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/courses");
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp,
                                    UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");

        if (idStr == null || idStr.trim().isEmpty() || status == null || status.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Thông tin cập nhật trạng thái không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/courses");
            return;
        }

        try {
            Long id = Long.parseLong(idStr.trim());
            academicProgramService.updateCourseStatus(id, status.trim(), user.getUserId(), user.getEmail(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Đã cập nhật trạng thái khóa học sang " + status.toUpperCase() + ".");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            FlashMessageUtil.setError(req, "Lỗi khi cập nhật trạng thái: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/courses");
    }
}
