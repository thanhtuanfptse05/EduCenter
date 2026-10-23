package com.educenter.controller;

import com.educenter.dto.LandingDataDTO;
import com.educenter.dto.LeadFormDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.Lead;
import com.educenter.service.LandingService;
import com.educenter.service.LandingServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.FlashMessageUtil;
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
            if ("true".equals(req.getParameter("loggedOut"))) {
                FlashMessageUtil.setInfo(req, "Bạn đã đăng xuất khỏi hệ thống thành công.");
                FlashMessageUtil.transferFlashMessagesToRequest(req);
            }
            req.setAttribute("pageTitle", "EduCenter — Gia sư, bồi dưỡng kiến thức và luyện thi");
            LandingDataDTO portalData = landingService.getLandingPortalData();
            req.setAttribute("portalData", portalData);
            if (session != null) {
                req.setAttribute("leadDraft", session.getAttribute("LEAD_FORM_DRAFT"));
                session.removeAttribute("LEAD_FORM_DRAFT");
            }
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
            session.removeAttribute("LEAD_FORM_DRAFT");
            session.setAttribute("alertType", "success");
            session.setAttribute("alertMessage", "Đã ghi nhận yêu cầu tư vấn. Mã hồ sơ: LEAD-" + lead.getId() + ". Trung tâm sẽ liên hệ theo thông tin bạn cung cấp.");
            resp.sendRedirect(req.getContextPath() + "/#dang-ky-tu-van");
        } catch (ValidationException ve) {
            session.setAttribute("LEAD_FORM_DRAFT", form);
            session.setAttribute("alertType", "error");
            session.setAttribute("alertMessage", ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/#dang-ky-tu-van");
        } catch (Exception e) {
            getServletContext().log("Cannot save consultation request", e);
            session.setAttribute("LEAD_FORM_DRAFT", form);
            session.setAttribute("alertType", "error");
            session.setAttribute("alertMessage", "Chưa thể lưu yêu cầu tư vấn. Vui lòng thử lại sau; thông tin đã nhập được giữ lại.");
            resp.sendRedirect(req.getContextPath() + "/#dang-ky-tu-van");
        }
    }
}

