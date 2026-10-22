package com.educenter.controller;

import com.educenter.dto.LandingDataDTO;
import com.educenter.dto.LeadFormDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.Lead;
import com.educenter.service.LandingService;
import com.educenter.service.LandingServiceImpl;
import com.educenter.service.ValidationException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller handling public root landing and role dashboard landing routes (FR-008).
 * Provides dynamic database metrics, featured courses, teachers, and handles CRM leads.
 */
@WebServlet(name = "LandingServlet", urlPatterns = {
        "",
        "/index",
        "/dang-ky-tu-van",
        "/admin/dashboard",
        "/staff/leads",
        "/teacher/dashboard",
        "/student/dashboard",
        "/parent/dashboard"
})
public class LandingServlet extends HttpServlet {

    private final LandingService landingService;

    public LandingServlet() {
        this.landingService = new LandingServiceImpl();
    }

    public LandingServlet(LandingService landingService) {
        this.landingService = landingService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (path.isEmpty() || "/".equals(path) || "/index".equals(path) || "/dang-ky-tu-van".equals(path)) {
            req.setAttribute("pageTitle", "EduCenter — Hệ Thống Gia Sư & Bổ Trợ THPT Chuyên Biệt Lớp 10, 11, 12");
            LandingDataDTO portalData = landingService.getLandingPortalData();
            req.setAttribute("portalData", portalData);
            req.getRequestDispatcher("/WEB-INF/views/common/landing.jsp").forward(req, resp);
            return;
        }

        // Authenticated dashboard routes
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + path);
            return;
        }

        String roleName = switch (path) {
            case "/admin/dashboard" -> "Quản Trị Viên & Giám Đốc Trung Tâm";
            case "/staff/leads" -> "Tuyển Sinh & Quản Lý Học Vụ";
            case "/teacher/dashboard" -> "Giáo Viên / Gia Sư Giảng Dạy";
            case "/student/dashboard" -> "Học Viên Luyện Thi";
            case "/parent/dashboard" -> "Phụ Huynh Học Sinh";
            default -> "Người Dùng Hệ Thống";
        };

        req.setAttribute("dashboardRoleName", roleName);
        req.setAttribute("dashboardPath", path);
        req.setAttribute("pageTitle", "Bảng điều khiển (" + roleName + ") — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/common/landing.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (path.isEmpty() || "/".equals(path) || "/index".equals(path) || "/dang-ky-tu-van".equals(path)) {
            handleConsultationSubmission(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private void handleConsultationSubmission(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(true);

        LeadFormDTO form = new LeadFormDTO();
        form.setFullName(req.getParameter("fullName"));
        form.setPhone(req.getParameter("phone"));
        String gradeStr = req.getParameter("gradeLevel");
        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try {
                form.setGradeLevel(Integer.parseInt(gradeStr.trim()));
            } catch (NumberFormatException ignored) {}
        }
        form.setSubject(req.getParameter("subject"));
        form.setLearningModel(req.getParameter("learningModel"));
        form.setNotes(req.getParameter("notes"));

        try {
            Lead lead = landingService.registerLead(form);
            session.setAttribute("alertType", "success");
            session.setAttribute("alertMessage", "Đã ghi nhận yêu cầu tư vấn thành công! Mã hồ sơ CRM: #CRM-THPT-00"
                    + lead.getId() + ". Chuyên viên học vụ EduCenter sẽ liên hệ quý phụ huynh trong 30 phút.");
            resp.sendRedirect(req.getContextPath() + "/#dang-ky-tu-van");
        } catch (ValidationException ve) {
            session.setAttribute("alertType", "error");
            session.setAttribute("alertMessage", ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/#dang-ky-tu-van");
        } catch (Exception e) {
            session.setAttribute("alertType", "error");
            session.setAttribute("alertMessage", "Có lỗi xảy ra khi lưu thông tin. Quý phụ huynh vui lòng liên hệ hotline 1900 6868.");
            resp.sendRedirect(req.getContextPath() + "/#dang-ky-tu-van");
        }
    }
}

