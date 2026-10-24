package com.educenter.controller;

import com.educenter.dto.AttendanceRosterItemDTO;
import com.educenter.dto.AttendanceSessionViewDTO;
import com.educenter.dto.TeachingJournalDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.AttendanceService;
import com.educenter.service.AttendanceServiceImpl;
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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TeacherAttendanceServlet", urlPatterns = {
        "/teacher/attendance",
        "/teacher/attendance/save",
        "/teacher/attendance/complete",
        "/teacher/journal",
        "/teacher/journal/save"
})
public class TeacherAttendanceServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TeacherAttendanceServlet.class.getName());

    private AttendanceService attendanceService;

    @Override
    public void init() throws ServletException {
        this.attendanceService = new AttendanceServiceImpl();
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

        String sessionIdStr = req.getParameter("sessionId");
        Long sessionId = null;
        if (sessionIdStr != null && !sessionIdStr.isBlank()) {
            try {
                sessionId = Long.parseLong(sessionIdStr);
            } catch (NumberFormatException ignored) {}
        }

        if (user.isAdmin() && !user.isTeacher() && sessionId == null && !path.startsWith("/teacher/journal")) {
            resp.sendRedirect(req.getContextPath() + "/admin/academic-stats");
            return;
        }

        if (path.startsWith("/teacher/journal")) {
            handleGetJournal(req, resp, user, sessionId);
            return;
        }

        // /teacher/attendance
        if (sessionId != null) {
            handleGetAttendanceDetail(req, resp, user, sessionId);
        } else {
            handleGetSessionsList(req, resp, user);
        }
    }

    private void handleGetSessionsList(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws ServletException, IOException {
        String dateStr = req.getParameter("date");
        LocalDate date = null;
        if (dateStr != null && !dateStr.isBlank()) {
            try {
                date = LocalDate.parse(dateStr);
            } catch (DateTimeParseException ignored) {}
        }

        List<AttendanceSessionViewDTO> sessions = attendanceService.getTeacherSessions(user.getUserId(), date, user.isAdmin());
        req.setAttribute("sessions", sessions);
        req.setAttribute("filterDate", dateStr);
        req.setAttribute("pageTitle", "Điểm danh & Lịch dạy — EduCenter");
        req.setAttribute("activeNav", "attendance");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/teacher/attendance-sessions.jsp").forward(req, resp);
    }

    private void handleGetAttendanceDetail(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, Long sessionId)
            throws ServletException, IOException {
        try {
            AttendanceSessionViewDTO sessionData = attendanceService.getSessionAttendance(sessionId, user.getUserId(), user.isAdmin());
            req.setAttribute("sessionData", sessionData);
            req.setAttribute("pageTitle", "Điểm danh ca học " + sessionData.getClassCode() + " — EduCenter");
            req.setAttribute("activeNav", "attendance");
            req.setAttribute("internalShell", true);
            req.getRequestDispatcher("/WEB-INF/views/teacher/attendance.jsp").forward(req, resp);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance");
        }
    }

    private void handleGetJournal(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user, Long sessionId)
            throws ServletException, IOException {
        if (sessionId == null) {
            FlashMessageUtil.setError(req, "Vui lòng chọn ca học cần cập nhật sổ đầu bài / nhật ký!");
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance");
            return;
        }

        try {
            AttendanceSessionViewDTO sessionData = attendanceService.getSessionAttendance(sessionId, user.getUserId(), user.isAdmin());
            TeachingJournalDTO journal = attendanceService.getTeachingJournal(sessionId, user.getUserId(), user.isAdmin());
            req.setAttribute("sessionData", sessionData);
            req.setAttribute("journal", journal);
            req.setAttribute("pageTitle", "Sổ đầu bài & Nhật ký ca học " + sessionData.getClassCode() + " — EduCenter");
            req.setAttribute("activeNav", "journal");
            req.setAttribute("internalShell", true);
            req.getRequestDispatcher("/WEB-INF/views/teacher/journal.jsp").forward(req, resp);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isTeacher() && !user.isAdmin())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        switch (path) {
            case "/teacher/attendance/save" -> handleSaveAttendance(req, resp, user);
            case "/teacher/attendance/complete" -> handleCompleteAttendance(req, resp, user);
            case "/teacher/journal/save" -> handleSaveJournal(req, resp, user);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleSaveAttendance(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        Long sessionId = null;
        try {
            sessionId = Long.parseLong(req.getParameter("sessionId"));
            String[] studentIds = req.getParameterValues("studentIds");

            List<AttendanceRosterItemDTO> rosterItems = new ArrayList<>();
            if (studentIds != null) {
                for (String sIdStr : studentIds) {
                    Long studentId = Long.parseLong(sIdStr);
                    String status = req.getParameter("status_" + studentId);
                    String remarks = req.getParameter("remarks_" + studentId);
                    rosterItems.add(new AttendanceRosterItemDTO(studentId, null, null, null, status, remarks));
                }
            }

            attendanceService.saveAttendance(sessionId, rosterItems, user.getUserId(), user.isAdmin());

            boolean completeAfterSave = "true".equalsIgnoreCase(req.getParameter("completeAfterSave"));
            if (completeAfterSave) {
                attendanceService.completeSessionAttendance(sessionId, user.getUserId(), user.isAdmin());
                FlashMessageUtil.setSuccess(req, "Chốt hoàn tất ca học và lưu điểm danh thành công! Trạng thái ca học đã được cập nhật sang COMPLETED.");
            } else {
                FlashMessageUtil.setSuccess(req, "Lưu thông tin điểm danh thành công!");
            }
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu điểm danh: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể lưu điểm danh: " + e.getMessage());
        }

        if (sessionId != null) {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance?sessionId=" + sessionId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance");
        }
    }

    private void handleCompleteAttendance(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        Long sessionId = null;
        try {
            sessionId = Long.parseLong(req.getParameter("sessionId"));
            String[] studentIds = req.getParameterValues("studentIds");
            if (studentIds != null && studentIds.length > 0) {
                List<AttendanceRosterItemDTO> rosterItems = new ArrayList<>();
                for (String sIdStr : studentIds) {
                    Long studentId = Long.parseLong(sIdStr);
                    String status = req.getParameter("status_" + studentId);
                    String remarks = req.getParameter("remarks_" + studentId);
                    rosterItems.add(new AttendanceRosterItemDTO(studentId, null, null, null, status, remarks));
                }
                attendanceService.saveAttendance(sessionId, rosterItems, user.getUserId(), user.isAdmin());
            }
            attendanceService.completeSessionAttendance(sessionId, user.getUserId(), user.isAdmin());
            FlashMessageUtil.setSuccess(req, "Chốt hoàn tất buổi học thành công! Trạng thái ca học đã được cập nhật sang COMPLETED.");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi chốt điểm danh: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể chốt điểm danh: " + e.getMessage());
        }

        if (sessionId != null) {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance?sessionId=" + sessionId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance");
        }
    }

    private void handleSaveJournal(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user) throws IOException {
        Long sessionId = null;
        try {
            sessionId = Long.parseLong(req.getParameter("sessionId"));
            String content = req.getParameter("content");
            String homework = req.getParameter("homework");
            String remarks = req.getParameter("teacherRemarks");

            attendanceService.saveTeachingJournal(sessionId, content, homework, remarks, user.getUserId(), user.isAdmin());
            FlashMessageUtil.setSuccess(req, "Cập nhật nhật ký giảng dạy & sổ đầu bài thành công!");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu nhật ký: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Không thể lưu nhật ký: " + e.getMessage());
        }

        if (sessionId != null) {
            resp.sendRedirect(req.getContextPath() + "/teacher/journal?sessionId=" + sessionId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/teacher/attendance");
        }
    }
}
