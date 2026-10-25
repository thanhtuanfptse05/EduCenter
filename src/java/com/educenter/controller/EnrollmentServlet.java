package com.educenter.controller;

import com.educenter.dto.ClassEnrollmentOptionDTO;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "EnrollmentServlet", urlPatterns = {
        "/staff/enrollments",
        "/staff/enrollments/create",
        "/staff/enrollments/save",
        "/staff/enrollments/transfer",
        "/staff/enrollments/reserve",
        "/staff/enrollments/resume",
        "/staff/enrollments/status",
        "/staff/enrollments/student-options",
        "/admin/enrollments",
        "/admin/enrollments/create",
        "/admin/enrollments/save",
        "/admin/enrollments/transfer",
        "/admin/enrollments/reserve",
        "/admin/enrollments/resume",
        "/admin/enrollments/status",
        "/admin/enrollments/student-options"
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

        if (path.endsWith("/student-options")) {
            handleGetStudentOptions(req, resp);
            return;
        }

        if (!"/staff/enrollments".equals(path) && !"/staff/enrollments/create".equals(path)
                && !"/admin/enrollments".equals(path) && !"/admin/enrollments/create".equals(path)) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Long preselectedStudentId = null;
        Long preselectedLeadId = null;
        Long preselectedCourseId = null;
        boolean autoOpenModal = path.endsWith("/create");

        String leadIdStr = req.getParameter("leadId");
        if (leadIdStr != null && !leadIdStr.isBlank()) {
            try {
                preselectedLeadId = Long.parseLong(leadIdStr.trim());
                Student student = enrollmentService.getOrCreateStudentFromLead(preselectedLeadId);
                if (student != null) {
                    preselectedStudentId = student.getId();
                    autoOpenModal = true;
                }
                preselectedCourseId = enrollmentService.getCourseIdFromLead(preselectedLeadId);
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

        if (preselectedCourseId == null && preselectedStudentId != null) {
            try {
                List<Long> regCourseIds = enrollmentService.getStudentRegisteredCourseIds(preselectedStudentId);
                if (regCourseIds != null && !regCourseIds.isEmpty()) {
                    preselectedCourseId = regCourseIds.get(0);
                }
            } catch (Exception ignored) {}
        }

        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr != null && !courseIdStr.isBlank()) {
            try {
                preselectedCourseId = Long.parseLong(courseIdStr.trim());
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

        String paidStr = req.getParameter("paid");
        if (paidStr == null || paidStr.isBlank()) {
            paidStr = req.getParameter("paymentConfirmed");
        }
        boolean preselectedPaid = "1".equals(paidStr) || "true".equalsIgnoreCase(paidStr);
        if (preselectedPaid) {
            autoOpenModal = true;
        }

        boolean isAdminContext = path.startsWith("/admin");
        req.setAttribute("pageData", pageData);
        req.setAttribute("preselectedStudentId", preselectedStudentId);
        req.setAttribute("preselectedLeadId", preselectedLeadId);
        req.setAttribute("preselectedCourseId", preselectedCourseId);
        req.setAttribute("preselectedPaid", preselectedPaid);
        req.setAttribute("autoOpenModal", autoOpenModal);
        req.setAttribute("pageTitle", "Quản lý ghi danh & Xếp lớp — EduCenter ERP");
        req.setAttribute("activeNav", isAdminContext ? "admin-enrollments" : "enrollments");
        req.setAttribute("enrollmentBasePath", req.getContextPath() + (isAdminContext ? "/admin/enrollments" : "/staff/enrollments"));
        req.setAttribute("isAdminContext", isAdminContext);
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

        if (path.endsWith("/save")) {
            handleSaveEnrollment(req, resp, user, path);
        } else if (path.endsWith("/transfer")) {
            handleTransferClass(req, resp, user, path);
        } else if (path.endsWith("/reserve")) {
            handleReserve(req, resp, user, path);
        } else if (path.endsWith("/resume")) {
            handleResume(req, resp, user, path);
        } else if (path.endsWith("/status")) {
            handleUpdateStatus(req, resp, user, path);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleGetStudentOptions(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String studentIdStr = req.getParameter("studentId");
        if (studentIdStr == null || studentIdStr.isBlank()) {
            resp.getWriter().write("{\"registeredCourseIds\":[],\"classes\":[]}");
            return;
        }

        try {
            Long studentId = Long.parseLong(studentIdStr.trim());
            List<Long> regCourseIds = enrollmentService.getStudentRegisteredCourseIds(studentId);
            List<ClassEnrollmentOptionDTO> classes = enrollmentService.getOpenClassOptionsForStudent(studentId);

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"studentId\":").append(studentId).append(",");
            json.append("\"registeredCourseIds\":[");
            for (int i = 0; i < regCourseIds.size(); i++) {
                if (i > 0) json.append(",");
                json.append(regCourseIds.get(i));
            }
            json.append("],");
            json.append("\"classes\":[");
            for (int i = 0; i < classes.size(); i++) {
                ClassEnrollmentOptionDTO c = classes.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"classId\":").append(c.getClassId()).append(",");
                json.append("\"classCode\":\"").append(escapeJson(c.getClassCode())).append("\",");
                json.append("\"className\":\"").append(escapeJson(c.getClassName())).append("\",");
                json.append("\"courseId\":").append(c.getCourseId() != null ? c.getCourseId() : 0).append(",");
                json.append("\"courseCode\":\"").append(escapeJson(c.getCourseCode())).append("\",");
                json.append("\"courseName\":\"").append(escapeJson(c.getCourseName())).append("\",");
                json.append("\"fee\":").append(c.getFee() != null ? c.getFee() : 0).append(",");
                json.append("\"currentEnrolled\":").append(c.getCurrentEnrolled()).append(",");
                json.append("\"capacity\":").append(c.getCapacity()).append(",");
                json.append("\"isFull\":").append(c.isFull()).append(",");
                json.append("\"hasScheduleConflict\":").append(c.isHasScheduleConflict()).append(",");
                json.append("\"conflictReason\":\"").append(escapeJson(c.getConflictReason())).append("\",");
                json.append("\"startDate\":\"").append(c.getStartDate() != null ? c.getStartDate().toString() : "").append("\"");
                json.append("}");
            }
            json.append("]");
            json.append("}");
            resp.getWriter().write(json.toString());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi lấy student options: " + e.getMessage(), e);
            resp.getWriter().write("{\"registeredCourseIds\":[],\"classes\":[],\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String getRedirectBase(String path) {
        return path.startsWith("/admin") ? "/admin/enrollments" : "/staff/enrollments";
    }

    private void handleSaveEnrollment(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String path) throws IOException {
        String redirectBase = getRedirectBase(path);
        try {
            Long studentId = Long.parseLong(req.getParameter("studentId"));
            Long classId = Long.parseLong(req.getParameter("classId"));

            String courseIdStr = req.getParameter("courseId");
            Long courseId = (courseIdStr != null && !courseIdStr.isBlank()) ? Long.parseLong(courseIdStr.trim()) : null;

            String startDateStr = req.getParameter("startDate");
            String notes = req.getParameter("notes");
            String leadIdStr = req.getParameter("leadId");

            // FR-014: Kiểm tra thông tin nộp tiền học phí
            String paymentConfirmedStr = req.getParameter("paymentConfirmed");
            boolean paymentConfirmed = "true".equalsIgnoreCase(paymentConfirmedStr) || "on".equalsIgnoreCase(paymentConfirmedStr);
            String paymentMethod = req.getParameter("paymentMethod");
            String transactionRef = req.getParameter("transactionRef");

            LocalDate startDate = LocalDate.parse(startDateStr);

            EnrollmentFormDTO form = new EnrollmentFormDTO();
            form.setStudentId(studentId);
            form.setCourseId(courseId);
            form.setClassId(classId);
            form.setStartDate(startDate);
            form.setNotes(notes);
            form.setPaymentConfirmed(paymentConfirmed);
            form.setPaymentMethod(paymentMethod);
            form.setTransactionRef(transactionRef);

            enrollmentService.enrollStudent(form, user.getUserId());

            if (leadIdStr != null && !leadIdStr.isBlank()) {
                try {
                    Long leadId = Long.parseLong(leadIdStr.trim());
                    enrollmentService.markLeadAsEnrolled(leadId);
                } catch (Exception ex) {
                    LOGGER.log(Level.WARNING, "Không thể cập nhật Lead status: " + ex.getMessage());
                }
            }

            FlashMessageUtil.setSuccess(req, "Ghi danh thành công học sinh vào lớp học! Học phí đã được thu đầy đủ và hóa đơn đã được chuyển sang trạng thái ĐÃ THANH TOÁN (PAID).");
        } catch (NumberFormatException | DateTimeParseException e) {
            FlashMessageUtil.setError(req, "Dữ liệu nhập vào không hợp lệ (mã học sinh, lớp hoặc ngày bắt đầu)!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi ghi danh: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể ghi danh: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + redirectBase);
    }

    private void handleTransferClass(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String path) throws IOException {
        String redirectBase = getRedirectBase(path);
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

        resp.sendRedirect(req.getContextPath() + redirectBase);
    }

    private void handleReserve(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String path) throws IOException {
        String redirectBase = getRedirectBase(path);
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

        resp.sendRedirect(req.getContextPath() + redirectBase);
    }

    private void handleResume(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String path) throws IOException {
        String redirectBase = getRedirectBase(path);
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

        resp.sendRedirect(req.getContextPath() + redirectBase);
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, String path) throws IOException {
        String redirectBase = getRedirectBase(path);
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

        resp.sendRedirect(req.getContextPath() + redirectBase);
    }
}
