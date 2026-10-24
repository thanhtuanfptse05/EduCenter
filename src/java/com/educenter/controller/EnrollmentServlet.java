package com.educenter.controller;

import com.educenter.dto.EnrollmentFormDTO;
import com.educenter.dto.EnrollmentPageDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.Student;
import com.educenter.service.EnrollmentService;
import com.educenter.service.EnrollmentServiceImpl;
import com.educenter.service.ValidationException;
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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "EnrollmentServlet", urlPatterns = {
        "/staff/enrollments",
        "/staff/enrollments/create",
        "/staff/enrollments/save",
        "/staff/enrollments/transfer",
        "/staff/enrollments/reserve",
        "/staff/enrollments/resume",
        "/staff/enrollments/status"
})
public class EnrollmentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EnrollmentServlet.class.getName());

    private EnrollmentService enrollmentService;

    @Override
    public void init() throws ServletException {
        this.enrollmentService = new EnrollmentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (!"/staff/enrollments".equals(path) && !"/staff/enrollments/create".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Long preselectedStudentId = null;
        Long preselectedLeadId = null;
        boolean autoOpenModal = "/staff/enrollments/create".equals(path);

        String leadIdStr = req.getParameter("leadId");
        if (leadIdStr != null && !leadIdStr.isBlank()) {
            try {
                preselectedLeadId = Long.parseLong(leadIdStr.trim());
                Student student = enrollmentService.getOrCreateStudentFromLead(preselectedLeadId);
                if (student != null) {
                    preselectedStudentId = student.getId();
                    autoOpenModal = true;
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Không thể chuyển đổi Lead sang học viên: " + leadIdStr, e);
            }
        }

        String studentIdStr = req.getParameter("studentId");
        if (studentIdStr != null && !studentIdStr.isBlank()) {
            try {
                preselectedStudentId = Long.parseLong(studentIdStr.trim());
                autoOpenModal = true;
            } catch (NumberFormatException ignored) {}
        }

        Long classId = null;
        try {
            String cIdStr = req.getParameter("classId");
            if (cIdStr != null && !cIdStr.isBlank()) {
                classId = Long.parseLong(cIdStr);
            }
        } catch (NumberFormatException ignored) {}

        String status = req.getParameter("status");
        String keyword = req.getParameter("q");

        int page = 1;
        try {
            String pStr = req.getParameter("page");
            if (pStr != null && !pStr.isBlank()) {
                page = Integer.parseInt(pStr);
            }
        } catch (NumberFormatException ignored) {}

        EnrollmentPageDTO pageData = enrollmentService.getEnrollmentsPaged(classId, status, keyword, page, 10);

        req.setAttribute("pageData", pageData);
        req.setAttribute("preselectedStudentId", preselectedStudentId);
        req.setAttribute("preselectedLeadId", preselectedLeadId);
        req.setAttribute("autoOpenModal", autoOpenModal);
        req.setAttribute("pageTitle", "Quản lý ghi danh & Xếp lớp — EduCenter ERP");
        req.setAttribute("activeNav", "enrollments");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/staff/enrollment-list.jsp").forward(req, resp);
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

        switch (path) {
            case "/staff/enrollments/save" -> handleSaveEnrollment(req, resp, user);
            case "/staff/enrollments/transfer" -> handleTransferClass(req, resp, user);
            case "/staff/enrollments/reserve" -> handleReserve(req, resp, user);
            case "/staff/enrollments/resume" -> handleResume(req, resp, user);
            case "/staff/enrollments/status" -> handleUpdateStatus(req, resp, user);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleSaveEnrollment(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        try {
            Long studentId = Long.parseLong(req.getParameter("studentId"));
            Long classId = Long.parseLong(req.getParameter("classId"));
            String startDateStr = req.getParameter("startDate");
            String notes = req.getParameter("notes");
            String leadIdStr = req.getParameter("leadId");

            LocalDate startDate = LocalDate.parse(startDateStr);

            EnrollmentFormDTO form = new EnrollmentFormDTO();
            form.setStudentId(studentId);
            form.setClassId(classId);
            form.setStartDate(startDate);
            form.setNotes(notes);

            enrollmentService.enrollStudent(form, user.getUserId());

            if (leadIdStr != null && !leadIdStr.isBlank()) {
                try {
                    Long leadId = Long.parseLong(leadIdStr.trim());
                    enrollmentService.markLeadAsEnrolled(leadId);
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Không thể cập nhật Lead status: " + ex.getMessage());
                }
            }

            FlashMessageUtil.setSuccess(req, "Ghi danh thành công học sinh vào lớp học! Hóa đơn học phí ban đầu đã được khởi tạo.");
        } catch (NumberFormatException | DateTimeParseException e) {
            FlashMessageUtil.setError(req, "Dữ liệu nhập vào không hợp lệ (mã học sinh, lớp hoặc ngày bắt đầu)!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi ghi danh: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể ghi danh: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/enrollments");
    }

    private void handleTransferClass(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        try {
            Long enrollmentId = Long.parseLong(req.getParameter("enrollmentId"));
            Long newClassId = Long.parseLong(req.getParameter("newClassId"));
            String transferDateStr = req.getParameter("transferDate");
            String notes = req.getParameter("notes");

            LocalDate transferDate = (transferDateStr != null && !transferDateStr.isBlank())
                    ? LocalDate.parse(transferDateStr) : LocalDate.now();

            enrollmentService.transferClass(enrollmentId, newClassId, transferDate, notes, user.getUserId());
            FlashMessageUtil.setSuccess(req, "Chuyển lớp thành công cho học viên!");
        } catch (NumberFormatException | DateTimeParseException e) {
            FlashMessageUtil.setError(req, "Dữ liệu chuyển lớp không hợp lệ!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chuyển lớp: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể chuyển lớp: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/enrollments");
    }

    private void handleReserve(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        try {
            Long enrollmentId = Long.parseLong(req.getParameter("enrollmentId"));
            String reason = req.getParameter("reason");

            enrollmentService.reserveEnrollment(enrollmentId, reason, user.getUserId());
            FlashMessageUtil.setSuccess(req, "Bảo lưu học tập thành công. Học viên đã được chuyển sang trạng thái RESERVED!");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã ghi danh không hợp lệ!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi bảo lưu: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể bảo lưu: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/enrollments");
    }

    private void handleResume(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        try {
            Long enrollmentId = Long.parseLong(req.getParameter("enrollmentId"));

            enrollmentService.resumeEnrollment(enrollmentId, user.getUserId());
            FlashMessageUtil.setSuccess(req, "Phục hồi học tập thành công. Học viên đã trở lại trạng thái ACTIVE!");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã ghi danh không hợp lệ!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi phục hồi học tập: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể phục hồi học tập: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/enrollments");
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        try {
            Long enrollmentId = Long.parseLong(req.getParameter("enrollmentId"));
            String newStatus = req.getParameter("newStatus");
            String reason = req.getParameter("reason");

            enrollmentService.updateEnrollmentStatus(enrollmentId, newStatus, reason, user.getUserId());
            FlashMessageUtil.setSuccess(req, "Cập nhật trạng thái ghi danh thành công!");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã ghi danh không hợp lệ!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật trạng thái: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể cập nhật trạng thái: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/staff/enrollments");
    }
}
