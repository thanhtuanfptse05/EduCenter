package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.EduClass;
import com.educenter.service.AssessmentService;
import com.educenter.service.AssessmentServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TeacherAssessmentServlet", urlPatterns = {
        "/teacher/assessments",
        "/teacher/assessments/create",
        "/teacher/scores",
        "/teacher/scores/save",
        "/teacher/scores/reopen"
})
public class TeacherAssessmentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TeacherAssessmentServlet.class.getName());

    private AssessmentService assessmentService;

    @Override
    public void init() throws ServletException {
        this.assessmentService = new AssessmentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isTeacher() && !user.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + path);
            return;
        }

        if ("/teacher/scores".equals(path)) {
            handleGetScores(req, resp, user);
            return;
        }

        handleGetAssessmentsList(req, resp, user);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isTeacher() && !user.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + path);
            return;
        }

        if ("/teacher/assessments/create".equals(path)) {
            handleCreateAssessment(req, resp, user);
            return;
        }

        if ("/teacher/scores/save".equals(path)) {
            handleSaveScores(req, resp, user);
            return;
        }

        if ("/teacher/scores/reopen".equals(path)) {
            handleReopenAssessment(req, resp, user);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
    }

    private void handleGetAssessmentsList(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws ServletException, IOException {
        String classIdStr = req.getParameter("classId");
        String status = req.getParameter("status");

        Long classId = null;
        if (classIdStr != null && !classIdStr.isBlank()) {
            try {
                classId = Long.parseLong(classIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        List<EduClass> classes = assessmentService.getTeacherClasses(user.getUserId(), user.isAdmin());
        List<AssessmentListItemDTO> assessments = assessmentService.getAssessments(user.getUserId(), user.isAdmin(), classId, status);

        req.setAttribute("classes", classes);
        req.setAttribute("assessments", assessments);
        req.setAttribute("selectedClassId", classId);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("activeNav", "assessments");

        req.getRequestDispatcher("/WEB-INF/views/teacher/assessment-list.jsp").forward(req, resp);
    }

    private void handleGetScores(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            FlashMessageUtil.setError(req, "Vui lòng chọn bài kiểm tra để chấm điểm.");
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
            return;
        }

        try {
            Long assessmentId = Long.parseLong(idStr.trim());
            AssessmentGradeViewDTO gradeView = assessmentService.getGradeView(assessmentId, user.getUserId(), user.isAdmin());
            req.setAttribute("gradeView", gradeView);
            req.setAttribute("activeNav", "assessments");
            req.getRequestDispatcher("/WEB-INF/views/teacher/scores.jsp").forward(req, resp);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã bài kiểm tra không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
        }
    }

    private void handleCreateAssessment(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws IOException {
        String classIdStr = req.getParameter("classId");
        String title = req.getParameter("title");
        String type = req.getParameter("assessmentType");
        String maxScoreStr = req.getParameter("maxScore");
        String weightStr = req.getParameter("weight");
        String testDateStr = req.getParameter("testDate");

        Long classId = null;
        try {
            if (classIdStr != null && !classIdStr.isBlank()) {
                classId = Long.parseLong(classIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        BigDecimal maxScore = new BigDecimal("10.00");
        if (maxScoreStr != null && !maxScoreStr.isBlank()) {
            try {
                maxScore = new BigDecimal(maxScoreStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        BigDecimal weight = new BigDecimal("1.00");
        if (weightStr != null && !weightStr.isBlank()) {
            try {
                weight = new BigDecimal(weightStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        LocalDate testDate = LocalDate.now();
        if (testDateStr != null && !testDateStr.isBlank()) {
            try {
                testDate = LocalDate.parse(testDateStr.trim());
            } catch (DateTimeParseException ignored) {}
        }

        AssessmentFormDTO form = new AssessmentFormDTO();
        form.setClassId(classId);
        form.setTitle(title);
        form.setAssessmentType(type);
        form.setMaxScore(maxScore);
        form.setWeight(weight);
        form.setTestDate(testDate);

        try {
            Long newId = assessmentService.createAssessment(form, user.getUserId(), user.isAdmin());
            FlashMessageUtil.setSuccess(req, "Tạo bài kiểm tra thành công! Vui lòng nhập điểm cho học sinh.");
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + newId);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi tạo bài kiểm tra: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Có lỗi xảy ra khi tạo bài kiểm tra. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
        }
    }

    private void handleSaveScores(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws IOException {
        String idStr = req.getParameter("assessmentId");
        String action = req.getParameter("action"); // DRAFT or PUBLISH

        Long assessmentId = null;
        try {
            if (idStr != null && !idStr.isBlank()) {
                assessmentId = Long.parseLong(idStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (assessmentId == null) {
            FlashMessageUtil.setError(req, "Mã bài kiểm tra không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
            return;
        }

        List<StudentScoreItemDTO> scoreItems = new ArrayList<>();
        Enumeration<String> paramNames = req.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (name.startsWith("score_")) {
                String studentIdStr = name.substring("score_".length());
                try {
                    Long studentId = Long.parseLong(studentIdStr);
                    String scoreValStr = req.getParameter(name);
                    String remarksVal = req.getParameter("remarks_" + studentId);

                    BigDecimal score = null;
                    if (scoreValStr != null && !scoreValStr.isBlank()) {
                        score = new BigDecimal(scoreValStr.trim().replace(",", "."));
                    }

                    StudentScoreItemDTO item = new StudentScoreItemDTO();
                    item.setStudentId(studentId);
                    item.setScore(score);
                    item.setRemarks(remarksVal != null ? remarksVal.trim() : null);
                    scoreItems.add(item);
                } catch (NumberFormatException ignored) {}
            }
        }

        try {
            assessmentService.saveScores(assessmentId, scoreItems, user.getUserId(), user.isAdmin());

            if ("PUBLISH".equalsIgnoreCase(action)) {
                assessmentService.publishAssessment(assessmentId, user.getUserId(), user.isAdmin());
                FlashMessageUtil.setSuccess(req, "Bảng điểm đã được công bố thành công (PUBLISHED)! Học viên và Phụ huynh đã có thể xem trên Portal.");
            } else {
                FlashMessageUtil.setSuccess(req, "Đã lưu nháp bảng điểm thành công (DRAFT).");
            }
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + assessmentId);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + assessmentId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi lưu bảng điểm: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Có lỗi xảy ra trong quá trình lưu điểm. Vui lòng kiểm tra lại dữ liệu.");
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + assessmentId);
        }
    }

    private void handleReopenAssessment(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws IOException {
        String idStr = req.getParameter("assessmentId");
        String reason = req.getParameter("reason");

        Long assessmentId = null;
        try {
            if (idStr != null && !idStr.isBlank()) {
                assessmentId = Long.parseLong(idStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (assessmentId == null) {
            FlashMessageUtil.setError(req, "Mã bài kiểm tra không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/teacher/assessments");
            return;
        }

        try {
            assessmentService.reopenAssessment(assessmentId, user.getUserId(), user.isAdmin(), reason);
            FlashMessageUtil.setSuccess(req, "Đã mở lại bài kiểm tra về trạng thái Bản nháp (DRAFT) để chỉnh sửa điểm.");
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + assessmentId);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + assessmentId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi mở lại bài kiểm tra: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể mở lại bài kiểm tra.");
            resp.sendRedirect(req.getContextPath() + "/teacher/scores?id=" + assessmentId);
        }
    }
}
