package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.Student;
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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "StudentManagementServlet", urlPatterns = {
        "/staff/students",
        "/staff/students/detail",
        "/staff/students/save",
        "/staff/students/status",
        "/staff/students/user-link",
        "/admin/students"
})
public class StudentManagementServlet extends HttpServlet {

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

        if ("/admin/students".equals(path)) {
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        req.setAttribute("activeNav", "students");
        req.setAttribute("internalShell", true);

        if ("/staff/students".equals(path)) {
            handleList(req, resp);
        } else if ("/staff/students/detail".equals(path)) {
            handleDetail(req, resp);
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
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        String ipAddress = req.getRemoteAddr();

        switch (path) {
            case "/staff/students/save" -> handleSave(req, resp, user, ipAddress);
            case "/staff/students/status" -> handleStatus(req, resp, user, ipAddress);
            case "/staff/students/user-link" -> handleUserLink(req, resp, user, ipAddress);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String gradeStr = req.getParameter("grade");
        String status = req.getParameter("status");
        String pageStr = req.getParameter("page");

        StudentFilterDTO filter = new StudentFilterDTO();
        if (q != null && !q.trim().isEmpty()) {
            filter.setKeyword(q.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            filter.setStatus(status.trim());
        }
        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try {
                filter.setGradeLevel(Integer.parseInt(gradeStr.trim()));
            } catch (NumberFormatException ignored) {}
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

        StudentStatsDTO stats = studentService.getStudentStats();
        List<StudentAdminViewDTO> students = studentService.getStudents(filter);
        long totalItems = studentService.countStudents(filter);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages < 1) totalPages = 1;

        List<User> availableUsers = studentService.getAvailableStudentUsers(null);

        req.setAttribute("students", students);
        req.setAttribute("stats", stats);
        req.setAttribute("filter", filter);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("availableUsers", availableUsers);

        req.getRequestDispatcher("/WEB-INF/views/staff/student-list.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã học viên không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        Long studentId;
        try {
            studentId = Long.parseLong(idStr.trim());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã học viên phải là số.");
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        try {
            StudentDetailDTO detail = studentService.getStudentDetail(studentId);
            List<User> availableUsers = studentService.getAvailableStudentUsers(studentId);

            req.setAttribute("detail", detail);
            req.setAttribute("student", detail.getStudent());
            req.setAttribute("guardians", detail.getGuardians());
            req.setAttribute("enrolledClasses", detail.getEnrolledClasses());
            req.setAttribute("availableUsers", availableUsers);

            req.getRequestDispatcher("/WEB-INF/views/staff/student-detail.jsp").forward(req, resp);
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/students");
        }
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String fullName = req.getParameter("fullName");
        String dobStr = req.getParameter("dob");
        String gender = req.getParameter("gender");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String school = req.getParameter("school");
        String gradeStr = req.getParameter("gradeLevel");
        String targetGoal = req.getParameter("targetGoal");
        String status = req.getParameter("status");
        String userIdStr = req.getParameter("userId");

        StudentFormDTO form = new StudentFormDTO();
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                form.setId(Long.parseLong(idStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        form.setFullName(fullName);
        form.setGender(gender);
        form.setPhone(phone);
        form.setEmail(email);
        form.setSchool(school);
        form.setTargetGoal(targetGoal);
        form.setStatus(status != null && !status.trim().isEmpty() ? status.trim() : "STUDYING");

        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                form.setDob(LocalDate.parse(dobStr.trim()));
            } catch (DateTimeParseException e) {
                FlashMessageUtil.setError(req, "Định dạng ngày sinh không hợp lệ (chuẩn YYYY-MM-DD).");
                resp.sendRedirect(req.getContextPath() + (form.getId() != null ? "/staff/students/detail?id=" + form.getId() : "/staff/students"));
                return;
            }
        }

        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try {
                form.setGradeLevel(Integer.parseInt(gradeStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                long uId = Long.parseLong(userIdStr.trim());
                if (uId > 0) form.setUserId(uId);
            } catch (NumberFormatException ignored) {}
        }

        try {
            Student saved = studentService.saveStudent(form, user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, (form.getId() == null ? "Tạo mới" : "Cập nhật") + " hồ sơ học viên " + saved.getFullName() + " (" + saved.getCode() + ") thành công.");
            resp.sendRedirect(req.getContextPath() + "/staff/students/detail?id=" + saved.getId());
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + (form.getId() != null ? "/staff/students/detail?id=" + form.getId() : "/staff/students"));
        }
    }

    private void handleStatus(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String idStr = req.getParameter("id");
        String status = req.getParameter("status");
        String redirect = req.getParameter("redirect");

        if (idStr == null || status == null) {
            FlashMessageUtil.setError(req, "Tham số không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        try {
            Long studentId = Long.parseLong(idStr.trim());
            studentService.updateStudentStatus(studentId, status.trim(), user.getUserId(), ipAddress);
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái học viên thành " + status + " thành công.");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException nfe) {
            FlashMessageUtil.setError(req, "Mã học viên không hợp lệ.");
        }

        if ("detail".equalsIgnoreCase(redirect) && idStr != null) {
            resp.sendRedirect(req.getContextPath() + "/staff/students/detail?id=" + idStr.trim());
        } else {
            resp.sendRedirect(req.getContextPath() + "/staff/students");
        }
    }

    private void handleUserLink(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String ipAddress) throws IOException {
        String studentIdStr = req.getParameter("studentId");
        String userIdStr = req.getParameter("userId");
        String action = req.getParameter("action"); // "link" or "unlink"

        if (studentIdStr == null || studentIdStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã học viên không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        Long studentId;
        try {
            studentId = Long.parseLong(studentIdStr.trim());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã học viên phải là số.");
            resp.sendRedirect(req.getContextPath() + "/staff/students");
            return;
        }

        try {
            if ("unlink".equalsIgnoreCase(action)) {
                studentService.unlinkStudentUser(studentId, user.getUserId(), ipAddress);
                FlashMessageUtil.setSuccess(req, "Hủy liên kết tài khoản đăng nhập thành công.");
            } else {
                if (userIdStr == null || userIdStr.trim().isEmpty()) {
                    FlashMessageUtil.setError(req, "Vui lòng chọn tài khoản người dùng để liên kết.");
                    resp.sendRedirect(req.getContextPath() + "/staff/students/detail?id=" + studentId);
                    return;
                }
                Long userId = Long.parseLong(userIdStr.trim());
                studentService.linkStudentUser(studentId, userId, user.getUserId(), ipAddress);
                FlashMessageUtil.setSuccess(req, "Liên kết tài khoản người dùng Học viên thành công.");
            }
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã tài khoản không hợp lệ.");
        }

        resp.sendRedirect(req.getContextPath() + "/staff/students/detail?id=" + studentId);
    }
}
