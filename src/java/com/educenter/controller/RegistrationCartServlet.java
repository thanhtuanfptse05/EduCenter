package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.service.ValidationException;
import com.educenter.service.CartService;
import com.educenter.service.CartServiceImpl;
import com.educenter.util.CsrfUtil;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;

@WebServlet(name = "RegistrationCartServlet", urlPatterns = {
        "/registration-cart",
        "/registration-cart/add",
        "/registration-cart/remove",
        "/registration-cart/update",
        "/registration-cart/clear",
        "/registration/confirm"
})
public class RegistrationCartServlet extends HttpServlet {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        this.cartService = new CartServiceImpl();
    }

    public void setCartService(CartService cartService) {
        this.cartService = cartService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if (!"/registration-cart".equals(path) && !"/registration/confirm".equals(path)) {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED); return;
        }
        FlashMessageUtil.transferFlashMessagesToRequest(req);
        HttpSession session = req.getSession(true);
        CsrfUtil.getOrCreateToken(session);

        UserPrincipalDTO currentUser = (UserPrincipalDTO) session.getAttribute("currentUser");
        Long userId = (currentUser != null) ? currentUser.getUserId() : null;

        CartViewDTO cart = cartService.getCart(session, userId);
        req.setAttribute("cart", cart);
        req.setAttribute("cartCount", cart.getTotalCourses());

        if ("/registration/confirm".equals(path)) {
            if (cart.isEmpty()) {
                FlashMessageUtil.setWarning(req, "Danh sách đăng ký đang trống. Vui lòng chọn ít nhất 1 khóa học.");
                resp.sendRedirect(req.getContextPath() + "/registration-cart");
                return;
            }

            RegistrationCheckoutDTO form = (RegistrationCheckoutDTO) session.getAttribute("CHECKOUT_FORM_DRAFT");
            if (form == null) {
                form = new RegistrationCheckoutDTO();
                if (currentUser != null) {
                    form.setFullName(currentUser.getFullName());
                    form.setPhoneNumber(currentUser.getPhone());
                    form.setEmail(currentUser.getEmail());
                }
            } else {
                session.removeAttribute("CHECKOUT_FORM_DRAFT");
            }

            if (session.getAttribute(CartServiceImpl.CHECKOUT_TOKEN) == null)
                session.setAttribute(CartServiceImpl.CHECKOUT_TOKEN, java.util.UUID.randomUUID().toString());
            form.setSubmissionToken((String) session.getAttribute(CartServiceImpl.CHECKOUT_TOKEN));

            req.setAttribute("form", form);
            req.setAttribute("pageTitle", "Xác Nhận Nhu Cầu Đăng Ký Khóa Học — EduCenter");
            req.getRequestDispatcher("/WEB-INF/views/public/registration-confirm.jsp").forward(req, resp);
        } else {
            req.setAttribute("pageTitle", "Giỏ Đăng Ký Khóa Học — EduCenter");
            req.getRequestDispatcher("/WEB-INF/views/public/registration-cart.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(true);

        if (!CsrfUtil.isValidToken(req)) {
            FlashMessageUtil.setError(req, "Phiên làm việc bảo mật đã hết hạn. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/registration-cart");
            return;
        }

        UserPrincipalDTO currentUser = (UserPrincipalDTO) session.getAttribute("currentUser");
        Long userId = (currentUser != null) ? currentUser.getUserId() : null;

        try { switch (path) {
            case "/registration-cart/add" -> handleAddToCart(req, resp, session, userId);
            case "/registration-cart/remove" -> handleRemoveFromCart(req, resp, session, userId);
            case "/registration-cart/update" -> {
                cartService.updateNotes(session, userId, Long.valueOf(req.getParameter("courseId")), req.getParameter("notes"));
                FlashMessageUtil.setSuccess(req, "Đã cập nhật ghi chú đăng ký.");
                resp.sendRedirect(req.getContextPath() + "/registration-cart");
            }
            case "/registration-cart/clear" -> handleClearCart(req, resp, session, userId);
            case "/registration/confirm" -> handleConfirmRegistration(req, resp, session, userId);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        } } catch (ValidationException | NumberFormatException e) {
            FlashMessageUtil.setError(req, e instanceof ValidationException ? e.getMessage() : "Mã khóa học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/registration-cart");
        } catch (RuntimeException e) {
            getServletContext().log("Cart operation failed", e);
            FlashMessageUtil.setError(req, "Chưa thể cập nhật đăng ký. Dữ liệu của bạn được giữ lại, vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/registration-cart");
        }
    }

    private void handleAddToCart(HttpServletRequest req, HttpServletResponse resp, HttpSession session, Long userId) throws IOException {
        String courseIdParam = req.getParameter("courseId");
        String notes = req.getParameter("notes");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Không tìm thấy khóa học cần thêm.");
            resp.sendRedirect(req.getContextPath() + "/courses");
            return;
        }

        try {
            Long courseId = Long.parseLong(courseIdParam.trim());
            boolean added = cartService.addToCart(session, userId, courseId, notes);
            if (added) FlashMessageUtil.setSuccess(req, "Đã thêm khóa học vào danh sách đăng ký.");
            else FlashMessageUtil.setInfo(req, "Khóa học này đã có trong danh sách đăng ký của bạn.");
            resp.sendRedirect(req.getContextPath() + "/registration-cart");
        } catch (ValidationException ve) {
            FlashMessageUtil.setError(req, ve.getMessage());
            resp.sendRedirect(req.getContextPath() + "/courses");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã khóa học không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/courses");
        }
    }

    private void handleRemoveFromCart(HttpServletRequest req, HttpServletResponse resp, HttpSession session, Long userId) throws IOException {
        String courseIdParam = req.getParameter("courseId");
        if (courseIdParam != null && !courseIdParam.trim().isEmpty()) {
            try {
                Long courseId = Long.parseLong(courseIdParam.trim());
                cartService.removeFromCart(session, userId, courseId);
                FlashMessageUtil.setInfo(req, "Đã xóa khóa học khỏi danh sách đăng ký.");
            } catch (NumberFormatException ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/registration-cart");
    }

    private void handleClearCart(HttpServletRequest req, HttpServletResponse resp, HttpSession session, Long userId) throws IOException {
        cartService.clearCart(session, userId);
        FlashMessageUtil.setInfo(req, "Đã làm trống danh sách khóa học dự định đăng ký.");
        resp.sendRedirect(req.getContextPath() + "/registration-cart");
    }

    private void handleConfirmRegistration(HttpServletRequest req, HttpServletResponse resp, HttpSession session, Long userId) throws IOException {
        RegistrationCheckoutDTO checkout = new RegistrationCheckoutDTO();
        checkout.setFullName(req.getParameter("fullName"));
        checkout.setPhoneNumber(req.getParameter("phoneNumber"));
        checkout.setEmail(req.getParameter("email"));

        String gradeStr = req.getParameter("gradeLevel");
        if (gradeStr != null && !gradeStr.trim().isEmpty()) {
            try {
                checkout.setGradeLevel(Integer.parseInt(gradeStr.trim()));
            } catch (NumberFormatException ignored) {}
        }

        checkout.setSchoolName(req.getParameter("schoolName"));
        String[] goals = req.getParameterValues("targetGoals");
        if (goals != null) {
            checkout.setTargetGoals(Arrays.asList(goals));
        }
        checkout.setNotes(req.getParameter("notes"));
        checkout.setConsentChecked(req.getParameter("consentCheck") != null);
        checkout.setSubmissionToken(req.getParameter("submissionToken"));

        try {
            // Save lead and clear cart
            String leadCode = cartService.confirmRegistration(session, userId, checkout);
            session.setAttribute("LAST_LEAD_CODE", leadCode);
            session.setAttribute("LAST_LEAD_NAME", checkout.getFullName());
            session.setAttribute("LAST_LEAD_PHONE", checkout.getPhoneNumber());
            session.setAttribute("LAST_LEAD_GRADE", checkout.getGradeLevel());

            resp.sendRedirect(req.getContextPath() + "/consultation/success?code=" + leadCode);
        } catch (RuntimeException ve) {
            if (!(ve instanceof ValidationException)) getServletContext().log("Registration transaction failed", ve);
            FlashMessageUtil.setError(req, ve instanceof ValidationException ? ve.getMessage() : "Chưa thể lưu hồ sơ. Vui lòng thử lại; danh sách đăng ký đã được giữ nguyên.");
            session.setAttribute("CHECKOUT_FORM_DRAFT", checkout);
            resp.sendRedirect(req.getContextPath() + "/registration/confirm");
        }
    }
}
