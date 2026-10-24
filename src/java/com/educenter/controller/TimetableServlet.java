package com.educenter.controller;

import com.educenter.dto.TimetableGridDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.ClassTimetableService;
import com.educenter.service.ClassTimetableServiceImpl;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * Controller hiển thị Thời khóa biểu tuần trực quan (UC19, WF-02).
 * Hỗ trợ cả ADMIN (quản trị, đổi lịch) và STAFF (tra cứu tư vấn tuyển sinh).
 */
@WebServlet(name = "TimetableServlet", urlPatterns = {
        "/admin/timetable",
        "/staff/timetable"
})
public class TimetableServlet extends HttpServlet {

    private ClassTimetableService classService;

    @Override
    public void init() throws ServletException {
        this.classService = new ClassTimetableServiceImpl();
    }

    public void setClassService(ClassTimetableService classService) {
        this.classService = classService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String path = req.getServletPath();
        boolean isAdmin = user.isAdmin();
        boolean isStaff = user.isStaff();

        if (path.startsWith("/admin") && !isAdmin) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        if (path.startsWith("/staff") && !isStaff && !isAdmin) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);

        String weekParam = req.getParameter("date");
        LocalDate targetDate = LocalDate.now();
        if (weekParam != null && !weekParam.trim().isEmpty()) {
            try {
                targetDate = LocalDate.parse(weekParam.trim());
            } catch (Exception ignored) {}
        }

        LocalDate monday = targetDate.with(DayOfWeek.MONDAY);
        TimetableGridDTO grid = classService.getTimetableWeek(monday);

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String weekRangeLabel = "Từ ngày " + monday.format(dtf) + " đến " + monday.plusDays(6).format(dtf);

        req.setAttribute("grid", grid);
        req.setAttribute("currentMonday", monday);
        req.setAttribute("prevMonday", monday.minusWeeks(1));
        req.setAttribute("nextMonday", monday.plusWeeks(1));
        req.setAttribute("todayDate", LocalDate.now());
        req.setAttribute("weekRangeLabel", weekRangeLabel);
        req.setAttribute("isAdmin", isAdmin);
        req.setAttribute("pageTitle", "Thời khóa biểu giảng dạy & học tập");
        req.setAttribute("activeNav", path.startsWith("/staff") ? "staff-timetable" : "timetable");
        req.setAttribute("internalShell", true);

        req.getRequestDispatcher("/WEB-INF/views/admin/timetable.jsp").forward(req, resp);
    }
}
