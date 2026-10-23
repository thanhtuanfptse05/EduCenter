package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.service.ValidationException;
import com.educenter.service.CartService;
import com.educenter.service.CartServiceImpl;
import com.educenter.service.CourseService;
import com.educenter.service.CourseServiceImpl;
import com.educenter.util.CsrfUtil;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PublicCourseServlet", urlPatterns = {
        "/courses",
        "/courses/detail",
        "/consultation/success"
})
public class PublicCourseServlet extends HttpServlet {

    private CourseService courseService;
    private CartService cartService;

    @Override
    public void init() throws ServletException {
        this.courseService = new CourseServiceImpl();
        this.cartService = new CartServiceImpl();
    }

    public void setCourseService(CourseService courseService) {
        this.courseService = courseService;
    }

    public void setCartService(CartService cartService) {
        this.cartService = cartService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        FlashMessageUtil.transferFlashMessagesToRequest(req);
        HttpSession session = req.getSession(true);
        CsrfUtil.getOrCreateToken(session);

        UserPrincipalDTO currentUser = (UserPrincipalDTO) session.getAttribute("currentUser");
        Long userId = (currentUser != null) ? currentUser.getUserId() : null;

        switch (path) {
            case "/courses" -> handleCourseList(req, resp);
            case "/courses/detail" -> handleCourseDetail(req, resp);
            case "/consultation/success" -> handleConsultationSuccess(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleCourseList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CourseFilterDTO filter = new CourseFilterDTO();

        String keyword = req.getParameter("keyword");
        if (keyword == null) keyword = req.getParameter("q");
        if (keyword != null && !keyword.trim().isEmpty()) {
            filter.setKeyword(keyword.trim());
        }

        String subParam = req.getParameter("subjectId");
        if (subParam == null || subParam.isEmpty()) {
            subParam = req.getParameter("sub");
        }
        if (subParam != null && !subParam.trim().isEmpty()) {
            try {
                filter.setSubjectId(Long.parseLong(subParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        String gradeParam = req.getParameter("gradeLevel");
        if (gradeParam == null || gradeParam.isEmpty()) {
            gradeParam = req.getParameter("grade");
        }
        if (gradeParam != null && !gradeParam.trim().isEmpty()) {
            try {
                int grade = Integer.parseInt(gradeParam.trim());
                if (grade >= 6 && grade <= 12) filter.setGradeLevel(grade);
            } catch (NumberFormatException ignored) {}
        }

        String feeRange = req.getParameter("fee_range");
        if (feeRange != null && !feeRange.trim().isEmpty()) {
            filter.setFeeRange(feeRange.trim());
        }

        String sort = req.getParameter("sort");
        if (sort != null && !sort.trim().isEmpty()) {
            filter.setSort(sort.trim());
        }

        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                filter.setPage(Integer.parseInt(pageParam.trim()));
            } catch (NumberFormatException ignored) {}
        }

        CoursePageDTO coursePage = courseService.getCourseCatalog(filter);
        List<SubjectCardDTO> subjects = courseService.getActiveSubjects();

        req.setAttribute("coursePage", coursePage);
        req.setAttribute("subjects", subjects);
        req.setAttribute("filter", filter);
        req.setAttribute("pageTitle", "Danh Mục Khóa Học & Luyện Thi THPT — EduCenter");

        req.getRequestDispatcher("/WEB-INF/views/public/course-list.jsp").forward(req, resp);
    }

    private void handleCourseDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Vui lòng chọn khóa học cần xem chi tiết.");
            resp.sendRedirect(req.getContextPath() + "/courses");
            return;
        }

        Long courseId;
        try {
            courseId = Long.parseLong(idParam.trim());
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã khóa học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/courses");
            return;
        }

        try {
            CourseDetailDTO detail = courseService.getCourseDetail(courseId);
            req.setAttribute("detail", detail);
            req.setAttribute("pageTitle", detail.getCourse().getName() + " — EduCenter");
            req.getRequestDispatcher("/WEB-INF/views/public/course-detail.jsp").forward(req, resp);
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/courses");
        }
    }

    private void handleConsultationSuccess(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        RegistrationReceiptDTO receipt = session == null ? null : (RegistrationReceiptDTO) session.getAttribute(CartServiceImpl.RECEIPT_KEY);
        String requestedCode = req.getParameter("code");
        if (receipt == null || (requestedCode != null && !requestedCode.equals(receipt.getCode()))) {
            FlashMessageUtil.setInfo(req, "Chưa có phiếu tiếp nhận hợp lệ trong phiên này.");
            resp.sendRedirect(req.getContextPath() + "/courses"); return;
        }

        req.setAttribute("receipt", receipt);
        req.setAttribute("leadCode", receipt.getCode());
        req.setAttribute("pageTitle", "Đăng Ký Tư Vấn Thành Công — EduCenter");
        req.getRequestDispatcher("/WEB-INF/views/public/consultation-success.jsp").forward(req, resp);
    }
}
