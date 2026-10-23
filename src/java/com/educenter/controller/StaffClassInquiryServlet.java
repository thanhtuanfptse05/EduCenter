package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.Course;
import com.educenter.service.AcademicProgramService;
import com.educenter.service.AcademicProgramServiceImpl;
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
import java.util.List;

/**
 * Controller tra cứu Lớp học & Sĩ số dành cho Nhân viên Tư vấn Tuyển sinh (STAFF).
 * Chế độ View-Only phục vụ tư vấn phụ huynh và học viên ghi danh.
 */
@WebServlet(name = "StaffClassInquiryServlet", urlPatterns = {
        "/staff/classes",
        "/staff/classes/detail"
})
public class StaffClassInquiryServlet extends HttpServlet {

    private ClassTimetableService classService;
    private AcademicProgramService academicService;

    @Override
    public void init() throws ServletException {
        this.classService = new ClassTimetableServiceImpl();
        this.academicService = new AcademicProgramServiceImpl();
    }

    public void setServices(ClassTimetableService classService, AcademicProgramService academicService) {
        this.classService = classService;
        this.academicService = academicService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isStaff() && !user.isAdmin())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);

        String path = req.getServletPath();
        if ("/staff/classes".equals(path)) {
            handleList(req, resp);
        } else if ("/staff/classes/detail".equals(path)) {
            handleDetail(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String courseIdStr = req.getParameter("courseId");
        String status = req.getParameter("status");
        String pageStr = req.getParameter("page");

        Long courseId = null;
        if (courseIdStr != null && !courseIdStr.trim().isEmpty()) {
            try { courseId = Long.parseLong(courseIdStr.trim()); } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try { page = Integer.parseInt(pageStr.trim()); } catch (NumberFormatException ignored) {}
        }

        ClassFilterDTO filter = new ClassFilterDTO(keyword, courseId, status, page, 10);
        List<ClassAdminViewDTO> classes = classService.getClasses(filter);
        long totalItems = classService.countClasses(filter);
        int totalPages = (int) Math.ceil((double) totalItems / filter.getPageSize());

        ClassAdminStatsDTO stats = classService.getClassStats();

        CourseFilterDTO courseFilter = new CourseFilterDTO();
        courseFilter.setStatus("OPEN");
        courseFilter.setPageSize(100);
        List<CourseAdminViewDTO> courses = academicService.getCourseAdminList(courseFilter);

        req.setAttribute("classes", classes);
        req.setAttribute("stats", stats);
        req.setAttribute("courses", courses);
        req.setAttribute("filter", filter);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", Math.max(1, totalPages));
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageTitle", "Tra cứu Lớp học & Sĩ số Tuyển sinh");

        req.getRequestDispatcher("/WEB-INF/views/staff/class-inquiry.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        if (id == null) {
            FlashMessageUtil.setError(req, "ID lớp học không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/staff/classes");
            return;
        }

        ClassDetailDTO detail = classService.getClassDetail(id);
        if (detail == null) {
            FlashMessageUtil.setError(req, "Không tìm thấy lớp học yêu cầu!");
            resp.sendRedirect(req.getContextPath() + "/staff/classes");
            return;
        }

        req.setAttribute("classDetail", detail);
        req.setAttribute("pageTitle", "Thông tin Lớp học: " + detail.getName());
        req.getRequestDispatcher("/WEB-INF/views/staff/class-detail.jsp").forward(req, resp);
    }
}
