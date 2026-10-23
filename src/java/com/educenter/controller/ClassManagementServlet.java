package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.Course;
import com.educenter.entity.Teacher;
import com.educenter.service.*;
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
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Controller Quản lý Lớp học & Buổi học (feat-class-timetable - UC15, UC16, UC19).
 * Dành riêng cho ADMIN và Quản trị viên trung tâm.
 */
@WebServlet(name = "ClassManagementServlet", urlPatterns = {
        "/admin/classes",
        "/admin/classes/create",
        "/admin/classes/edit",
        "/admin/classes/detail",
        "/admin/classes/generate-schedule",
        "/admin/classes/status"
})
public class ClassManagementServlet extends HttpServlet {

    private ClassTimetableService classService;
    private AcademicProgramService academicService;
    private TeacherManagementService teacherService;

    @Override
    public void init() throws ServletException {
        this.classService = new ClassTimetableServiceImpl();
        this.academicService = new AcademicProgramServiceImpl();
        this.teacherService = new TeacherManagementServiceImpl();
    }

    public void setServices(ClassTimetableService classService, AcademicProgramService academicService, TeacherManagementService teacherService) {
        this.classService = classService;
        this.academicService = academicService;
        this.teacherService = teacherService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        req.setAttribute("activeNav", "classes");
        req.setAttribute("internalShell", true);

        String path = req.getServletPath();
        if ("/admin/classes".equals(path)) {
            handleList(req, resp);
        } else if ("/admin/classes/create".equals(path)) {
            handleCreateForm(req, resp);
        } else if ("/admin/classes/edit".equals(path)) {
            handleEditForm(req, resp);
        } else if ("/admin/classes/detail".equals(path)) {
            handleDetail(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã bảo mật không hợp lệ (CSRF). Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        String path = req.getServletPath();
        if ("/admin/classes/create".equals(path)) {
            handleSave(req, resp, false, user.getUserId());
        } else if ("/admin/classes/edit".equals(path)) {
            handleSave(req, resp, true, user.getUserId());
        } else if ("/admin/classes/generate-schedule".equals(path)) {
            handleGenerateSchedule(req, resp, user.getUserId());
        } else if ("/admin/classes/status".equals(path)) {
            handleChangeStatus(req, resp, user.getUserId());
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

        // Lấy danh sách khóa học cho dropdown lọc
        CourseFilterDTO courseFilter = new CourseFilterDTO();
        courseFilter.setPageSize(100);
        List<CourseAdminViewDTO> courses = academicService.getCourseAdminList(courseFilter);

        req.setAttribute("classes", classes);
        req.setAttribute("stats", stats);
        req.setAttribute("courses", courses);
        req.setAttribute("filter", filter);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", Math.max(1, totalPages));
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageTitle", "Quản lý Lớp học & Lịch giảng dạy");

        req.getRequestDispatcher("/WEB-INF/views/admin/class-list.jsp").forward(req, resp);
    }

    private void handleCreateForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadDropdownData(req);
        ClassFormDTO form = new ClassFormDTO();
        form.setCapacity(15);
        form.setStartDate(LocalDate.now().plusDays(7));
        form.setEndDate(LocalDate.now().plusMonths(3));
        form.setStatus("OPEN");

        req.setAttribute("classForm", form);
        req.setAttribute("isEdit", false);
        req.setAttribute("pageTitle", "Tạo mới Lớp học");
        req.getRequestDispatcher("/WEB-INF/views/admin/class-form.jsp").forward(req, resp);
    }

    private void handleEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Long id = parseLong(idStr);
        if (id == null) {
            FlashMessageUtil.setError(req, "ID lớp học không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        ClassFormDTO form = classService.getClassForm(id);
        if (form == null) {
            FlashMessageUtil.setError(req, "Không tìm thấy lớp học yêu cầu!");
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        loadDropdownData(req);
        req.setAttribute("classForm", form);
        req.setAttribute("isEdit", true);
        req.setAttribute("pageTitle", "Chỉnh sửa Lớp học: " + form.getCode());
        req.getRequestDispatcher("/WEB-INF/views/admin/class-form.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        Long id = parseLong(idStr);
        if (id == null) {
            FlashMessageUtil.setError(req, "ID lớp học không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        ClassDetailDTO detail = classService.getClassDetail(id);
        if (detail == null) {
            FlashMessageUtil.setError(req, "Không tìm thấy lớp học yêu cầu!");
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        List<RoomDTO> availableRooms = classService.getAvailableRooms();
        TeacherFilterDTO tFilter = new TeacherFilterDTO();
        tFilter.setStatus("ACTIVE");
        tFilter.setPageSize(100);
        List<TeacherAdminViewDTO> teachers = teacherService.getTeachers(tFilter);

        req.setAttribute("classDetail", detail);
        req.setAttribute("availableRooms", availableRooms);
        req.setAttribute("teachers", teachers);
        req.setAttribute("pageTitle", "Chi tiết Lớp học: " + detail.getName());
        req.getRequestDispatcher("/WEB-INF/views/admin/class-detail.jsp").forward(req, resp);
    }

    private void handleSave(HttpServletRequest req, HttpServletResponse resp, boolean isEdit, Long actorUserId) throws IOException {
        ClassFormDTO form = new ClassFormDTO();
        if (isEdit) {
            form.setId(parseLong(req.getParameter("id")));
        }
        form.setCourseId(parseLong(req.getParameter("courseId")));
        form.setTeacherId(parseLong(req.getParameter("teacherId")));
        form.setRoomId(parseLong(req.getParameter("roomId")));
        form.setCode(req.getParameter("code"));
        form.setName(req.getParameter("name"));

        try {
            form.setCapacity(Integer.parseInt(req.getParameter("capacity")));
        } catch (Exception e) {
            form.setCapacity(0);
        }

        try {
            form.setStartDate(LocalDate.parse(req.getParameter("startDate")));
            form.setEndDate(LocalDate.parse(req.getParameter("endDate")));
        } catch (Exception ignored) {}

        form.setStatus(req.getParameter("status"));

        try {
            if (isEdit) {
                classService.updateClass(form, actorUserId);
                FlashMessageUtil.setSuccess(req, "Cập nhật lớp học " + form.getCode() + " thành công!");
                resp.sendRedirect(req.getContextPath() + "/admin/classes/detail?id=" + form.getId());
            } else {
                Long newId = classService.createClass(form, actorUserId);
                FlashMessageUtil.setSuccess(req, "Tạo mới lớp học " + form.getCode() + " thành công!");
                resp.sendRedirect(req.getContextPath() + "/admin/classes/detail?id=" + newId);
            }
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            if (isEdit) {
                resp.sendRedirect(req.getContextPath() + "/admin/classes/edit?id=" + form.getId());
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/classes/create");
            }
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi hệ thống: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
        }
    }

    private void handleGenerateSchedule(HttpServletRequest req, HttpServletResponse resp, Long actorUserId) throws IOException {
        Long classId = parseLong(req.getParameter("classId"));
        if (classId == null) {
            FlashMessageUtil.setError(req, "ID lớp học không hợp lệ!");
            resp.sendRedirect(req.getContextPath() + "/admin/classes");
            return;
        }

        ScheduleGeneratorDTO dto = new ScheduleGeneratorDTO();
        dto.setClassId(classId);
        dto.setRoomId(parseLong(req.getParameter("roomId")));
        dto.setTeacherId(parseLong(req.getParameter("teacherId")));

        String[] days = req.getParameterValues("daysOfWeek");
        if (days != null) {
            for (String d : days) {
                try { dto.getDaysOfWeek().add(Integer.parseInt(d.trim())); } catch (Exception ignored) {}
            }
        }

        try {
            dto.setStartAt(LocalTime.parse(req.getParameter("startAt")));
            dto.setEndAt(LocalTime.parse(req.getParameter("endAt")));
        } catch (Exception ignored) {}

        try {
            dto.setStartDate(LocalDate.parse(req.getParameter("startDate")));
        } catch (Exception ignored) {}

        try {
            dto.setTotalSessions(Integer.parseInt(req.getParameter("totalSessions")));
        } catch (Exception ignored) {}

        try {
            int count = classService.generateSchedule(dto, actorUserId);
            FlashMessageUtil.setSuccess(req, "Đã sinh thành công " + count + " buổi học cho lớp học!");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi sinh lịch học: " + ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/classes/detail?id=" + classId);
    }

    private void handleChangeStatus(HttpServletRequest req, HttpServletResponse resp, Long actorUserId) throws IOException {
        Long classId = parseLong(req.getParameter("classId"));
        String newStatus = req.getParameter("status");

        try {
            classService.changeClassStatus(classId, newStatus, actorUserId);
            FlashMessageUtil.setSuccess(req, "Đã cập nhật trạng thái lớp sang " + newStatus + " thành công!");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi cập nhật trạng thái: " + ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/classes/detail?id=" + classId);
    }

    private void loadDropdownData(HttpServletRequest req) {
        // Khóa học OPEN
        CourseFilterDTO courseFilter = new CourseFilterDTO();
        courseFilter.setStatus("OPEN");
        courseFilter.setPageSize(100);
        List<CourseAdminViewDTO> courses = academicService.getCourseAdminList(courseFilter);

        // Giáo viên ACTIVE
        TeacherFilterDTO teacherFilter = new TeacherFilterDTO();
        teacherFilter.setStatus("ACTIVE");
        teacherFilter.setPageSize(100);
        List<TeacherAdminViewDTO> teachers = teacherService.getTeachers(teacherFilter);

        // Phòng học AVAILABLE
        List<RoomDTO> rooms = classService.getAvailableRooms();

        req.setAttribute("courses", courses);
        req.setAttribute("teachers", teachers);
        req.setAttribute("rooms", rooms);
    }

    private Long parseLong(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try {
            return Long.parseLong(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
