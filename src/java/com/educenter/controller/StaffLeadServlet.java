package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.Lead;
import com.educenter.service.LeadService;
import com.educenter.service.LeadServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "StaffLeadServlet", urlPatterns = {
        "/staff/leads",
        "/staff/leads/detail",
        "/staff/leads/create",
        "/staff/leads/status",
        "/staff/leads/consultation"
})
public class StaffLeadServlet extends HttpServlet {

    private final LeadService leadService;

    public StaffLeadServlet() {
        this.leadService = new LeadServiceImpl();
    }

    public StaffLeadServlet(LeadService leadService) {
        this.leadService = leadService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (currentUser == null || (!currentUser.isStaff() && !currentUser.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + req.getRequestURI());
            return;
        }

        String path = req.getServletPath();
        req.setAttribute("activeNav", "leads");
        if ("/staff/leads/detail".equals(path)) {
            handleLeadDetail(req, resp);
        } else {
            handleLeadList(req, resp);
        }
    }

    private void handleLeadList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        FlashMessageUtil.transferFlashMessagesToRequest(req);

        LeadFilterDTO filter = new LeadFilterDTO();
        filter.setKeyword(req.getParameter("keyword"));
        filter.setStatus(req.getParameter("status"));
        filter.setSource(req.getParameter("source"));

        String gradeStr = req.getParameter("gradeLevel");
        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try { filter.setGradeLevel(Integer.parseInt(gradeStr.trim())); } catch (NumberFormatException ignored) {}
        }

        String assignedStr = req.getParameter("assignedToId");
        if (assignedStr != null && !assignedStr.trim().isEmpty()) {
            try { filter.setAssignedToId(Long.parseLong(assignedStr.trim())); } catch (NumberFormatException ignored) {}
        }

        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try { filter.setPage(Integer.parseInt(pageStr.trim())); } catch (NumberFormatException ignored) {}
        }

        Map<String, Object> data = leadService.getLeadListPage(filter);
        req.setAttribute("data", data);
        req.setAttribute("filter", filter);
        req.setAttribute("pageTitle", "Quản lý Khách hàng & Tuyển sinh (CRM) — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/staff/lead-list.jsp").forward(req, resp);
    }

    private void handleLeadDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        FlashMessageUtil.transferFlashMessagesToRequest(req);

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã khách hàng không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/leads");
            return;
        }

        try {
            Long leadId = Long.parseLong(idStr.trim());
            LeadDetailDTO detail = leadService.getLeadDetail(leadId);
            req.setAttribute("lead", detail);
            req.setAttribute("pageTitle", "Chi tiết Khách hàng: " + detail.getName() + " — EduCenter ERP");
            req.getRequestDispatcher("/WEB-INF/views/staff/lead-detail.jsp").forward(req, resp);
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (currentUser == null || (!currentUser.isStaff() && !currentUser.isAdmin())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = req.getServletPath();
        switch (path) {
            case "/staff/leads/create" -> handleCreateLead(req, resp, currentUser);
            case "/staff/leads/status" -> handleUpdateStatus(req, resp, currentUser);
            case "/staff/leads/consultation" -> handleAddConsultation(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleCreateLead(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser) throws IOException {
        try {
            LeadCreateFormDTO form = new LeadCreateFormDTO();
            form.setName(req.getParameter("name"));
            form.setPhone(req.getParameter("phone"));
            form.setEmail(req.getParameter("email"));
            form.setSource(req.getParameter("source"));
            form.setNotes(req.getParameter("notes"));

            String gradeStr = req.getParameter("gradeLevel");
            if (gradeStr != null && !gradeStr.trim().isEmpty()) {
                form.setGradeLevel(Integer.parseInt(gradeStr.trim()));
            }

            String assignedStr = req.getParameter("assignedToId");
            if (assignedStr != null && !assignedStr.trim().isEmpty()) {
                form.setAssignedToId(Long.parseLong(assignedStr.trim()));
            }

            Lead created = leadService.createLead(form, currentUser);
            FlashMessageUtil.setSuccess(req, "Tiếp nhận khách hàng tiềm năng thành công: " + created.getName());
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + created.getId());
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads");
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi tạo khách hàng: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads");
        }
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser) throws IOException {
        String leadIdStr = req.getParameter("leadId");
        if (leadIdStr == null || leadIdStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã khách hàng không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/leads");
            return;
        }

        try {
            Long leadId = Long.parseLong(leadIdStr.trim());
            String newStatus = req.getParameter("status");
            String notes = req.getParameter("notes");

            Long assignedToId = null;
            String assignedStr = req.getParameter("assignedToId");
            if (assignedStr != null && !assignedStr.trim().isEmpty()) {
                assignedToId = Long.parseLong(assignedStr.trim());
            }

            leadService.updateLeadStatus(leadId, newStatus, notes, assignedToId, currentUser);
            FlashMessageUtil.setSuccess(req, "Cập nhật tiến trình tư vấn thành công.");
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + leadId);
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + leadIdStr);
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi cập nhật: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + leadIdStr);
        }
    }

    private void handleAddConsultation(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser) throws IOException {
        String leadIdStr = req.getParameter("leadId");
        if (leadIdStr == null || leadIdStr.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã khách hàng không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/leads");
            return;
        }

        try {
            Long leadId = Long.parseLong(leadIdStr.trim());
            ConsultationFormDTO form = new ConsultationFormDTO();
            form.setLeadId(leadId);
            form.setNotes(req.getParameter("notes"));
            form.setNextAppointmentStr(req.getParameter("nextAppointment"));

            leadService.addConsultation(form, currentUser);
            FlashMessageUtil.setSuccess(req, "Ghi nhận nhật ký tư vấn thành công.");
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + leadId);
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + leadIdStr);
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi ghi nhật ký: " + ex.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/leads/detail?id=" + leadIdStr);
        }
    }
}
