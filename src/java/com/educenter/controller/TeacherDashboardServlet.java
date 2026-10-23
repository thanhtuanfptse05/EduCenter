package com.educenter.controller;

import com.educenter.dto.AssessmentListItemDTO;
import com.educenter.dto.AttendanceSessionViewDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.EduClass;
import com.educenter.service.AssessmentService;
import com.educenter.service.AssessmentServiceImpl;
import com.educenter.service.AttendanceService;
import com.educenter.service.AttendanceServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Dedicated Teacher Dashboard controller providing active teaching schedules,
 * assigned classes overview, today's attendance sessions, and assessment status.
 */
@WebServlet(name = "TeacherDashboardServlet", urlPatterns = {
        "/teacher/dashboard"
})
public class TeacherDashboardServlet extends HttpServlet {

    private final AttendanceService attendanceService;
    private final AssessmentService assessmentService;

    public TeacherDashboardServlet() {
        this(new AttendanceServiceImpl(), new AssessmentServiceImpl());
    }

    public TeacherDashboardServlet(AttendanceService attendanceService, AssessmentService assessmentService) {
        this.attendanceService = attendanceService;
        this.assessmentService = assessmentService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isTeacher() && !user.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=/teacher/dashboard");
            return;
        }

        Long teacherUserId = user.getUserId();
        boolean isAdmin = user.isAdmin();

        // 1. Assigned classes
        List<EduClass> assignedClasses = assessmentService.getTeacherClasses(teacherUserId, isAdmin);

        // 2. Today's sessions
        LocalDate today = LocalDate.now();
        List<AttendanceSessionViewDTO> todaySessions = attendanceService.getTeacherSessions(teacherUserId, today, isAdmin);

        // 3. Upcoming schedule (all upcoming sessions)
        List<AttendanceSessionViewDTO> upcomingSessions = attendanceService.getTeacherSessions(teacherUserId, null, isAdmin);

        // 4. Recent assessments
        List<AssessmentListItemDTO> assessments = assessmentService.getAssessments(teacherUserId, isAdmin, null, null);

        // KPI Counts
        int completedSessionsCount = 0;
        for (AttendanceSessionViewDTO s : upcomingSessions) {
            if ("COMPLETED".equalsIgnoreCase(s.getSessionStatus())) {
                completedSessionsCount++;
            }
        }

        req.setAttribute("assignedClasses", assignedClasses);
        req.setAttribute("todaySessions", todaySessions);
        req.setAttribute("upcomingSessions", upcomingSessions);
        req.setAttribute("assessments", assessments);

        req.setAttribute("totalClassesCount", assignedClasses.size());
        req.setAttribute("todaySessionsCount", todaySessions.size());
        req.setAttribute("completedSessionsCount", completedSessionsCount);
        req.setAttribute("assessmentsCount", assessments.size());

        req.setAttribute("pageTitle", "Bàn làm việc Giảng dạy — EduCenter ERP");
        req.setAttribute("activeNav", "teacher-dashboard");
        req.setAttribute("breadcrumb", "Giáo viên / Bàn làm việc giảng dạy");
        req.setAttribute("internalShell", true);

        req.getRequestDispatcher("/WEB-INF/views/teacher/dashboard.jsp").forward(req, resp);
    }
}
