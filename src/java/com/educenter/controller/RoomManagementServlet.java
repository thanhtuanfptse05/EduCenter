package com.educenter.controller;

import com.educenter.dto.RoomDTO;
import com.educenter.dto.RoomFormDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.ClassTimetableService;
import com.educenter.service.ClassTimetableServiceImpl;
import com.educenter.service.ValidationException;
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

/**
 * Controller Quản lý Danh mục Phòng học (UC34, M12).
 * Dành riêng cho ADMIN.
 */
@WebServlet(name = "RoomManagementServlet", urlPatterns = {
        "/admin/rooms",
        "/admin/rooms/create",
        "/admin/rooms/edit"
})
public class RoomManagementServlet extends HttpServlet {

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

        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        FlashMessageUtil.transferFlashMessagesToRequest(req);
        CsrfUtil.getOrCreateToken(session);

        List<RoomDTO> rooms = classService.getAllRooms();
        long availableCount = rooms.stream().filter(r -> "AVAILABLE".equalsIgnoreCase(r.getStatus())).count();
        long maintenanceCount = rooms.stream().filter(r -> "MAINTENANCE".equalsIgnoreCase(r.getStatus())).count();

        req.setAttribute("rooms", rooms);
        req.setAttribute("totalRooms", rooms.size());
        req.setAttribute("availableCount", availableCount);
        req.setAttribute("maintenanceCount", maintenanceCount);
        req.setAttribute("pageTitle", "Quản lý Phòng học");

        req.getRequestDispatcher("/WEB-INF/views/admin/room-list.jsp").forward(req, resp);
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
            FlashMessageUtil.setError(req, "Phiên thao tác đã hết hạn hoặc mã bảo mật không hợp lệ (CSRF).");
            resp.sendRedirect(req.getContextPath() + "/admin/rooms");
            return;
        }

        String path = req.getServletPath();
        String idStr = req.getParameter("id");
        Long id = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try { id = Long.parseLong(idStr.trim()); } catch (NumberFormatException ignored) {}
        }

        RoomFormDTO form = new RoomFormDTO();
        form.setId(id);
        form.setCode(req.getParameter("code"));
        form.setName(req.getParameter("name"));
        try {
            form.setCapacity(Integer.parseInt(req.getParameter("capacity")));
        } catch (Exception e) {
            form.setCapacity(0);
        }
        form.setStatus(req.getParameter("status"));

        try {
            if ("/admin/rooms/edit".equals(path) && id != null) {
                classService.updateRoom(form, user.getUserId());
                FlashMessageUtil.setSuccess(req, "Cập nhật phòng học " + form.getCode() + " thành công!");
            } else {
                classService.createRoom(form, user.getUserId());
                FlashMessageUtil.setSuccess(req, "Tạo mới phòng học " + form.getCode() + " thành công!");
            }
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
        } catch (Exception ex) {
            FlashMessageUtil.setError(req, "Lỗi hệ thống: " + ex.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/rooms");
    }
}
