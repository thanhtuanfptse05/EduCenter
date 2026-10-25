package com.educenter.controller;

import com.educenter.dto.ProfileUpdateDTO;
import com.educenter.dto.RegisterRequestDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.dto.UserViewDTO;
import com.educenter.entity.User;
import com.educenter.service.AuthService;
import com.educenter.service.AuthServiceImpl;
import com.educenter.service.UserService;
import com.educenter.service.UserServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.CsrfUtil;
import com.educenter.util.FlashMessageUtil;
import com.educenter.util.RouteUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

/**
 * Controller handling user authentication, registration, logout, password recovery and profile.
 * Implements Post/Redirect/Get (PRG) pattern for all mutating POST actions.
 */
@WebServlet(name = "AuthServlet", urlPatterns = {
        "/login",
        "/register",
        "/logout",
        "/forgot-password",
        "/reset-password",
        "/profile"
})
public class AuthServlet extends HttpServlet {

    private AuthService authService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.authService = new AuthServiceImpl();
        this.userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        switch (path) {
            case "/login" -> handleGetLogin(req, resp, currentUser);
            case "/register" -> handleGetRegister(req, resp, currentUser);
            case "/logout" -> handleGetLogout(req, resp, currentUser);
            case "/forgot-password" -> handleGetForgotPassword(req, resp);
            case "/reset-password" -> handleGetResetPassword(req, resp);
            case "/profile" -> handleGetProfile(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        switch (path) {
            case "/login" -> handlePostLogin(req, resp);
            case "/register" -> handlePostRegister(req, resp);
            case "/logout" -> handlePostLogout(req, resp);
            case "/forgot-password" -> handlePostForgotPassword(req, resp);
            case "/reset-password" -> handlePostResetPassword(req, resp);
            case "/profile" -> handlePostProfile(req, resp);
            default -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // --- GET Handlers ---

    private void handleGetLogin(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        if (currentUser != null) {
            resp.sendRedirect(req.getContextPath() + currentUser.getDefaultDashboardUrl());
            return;
        }
        if ("true".equals(req.getParameter("loggedOut"))) {
            FlashMessageUtil.setInfo(req, "Bạn đã đăng xuất khỏi hệ thống thành công.");
        }
        req.setAttribute("pageTitle", "Đăng nhập — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    private void handleGetRegister(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        if (currentUser != null) {
            resp.sendRedirect(req.getContextPath() + currentUser.getDefaultDashboardUrl());
            return;
        }
        req.setAttribute("pageTitle", "Đăng ký tài khoản — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    private void handleGetLogout(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        req.setAttribute("pageTitle", "Xác nhận đăng xuất — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/auth/logout.jsp").forward(req, resp);
    }

    private void handleGetForgotPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("pageTitle", "Quên mật khẩu — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(req, resp);
    }

    private void handleGetResetPassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            FlashMessageUtil.setError(req, "Mã token đặt lại mật khẩu không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
            return;
        }
        req.setAttribute("token", token.trim());
        req.setAttribute("resetState", authService.inspectPasswordReset(token.trim()));
        req.setAttribute("pageTitle", "Đặt lại mật khẩu — EduCenter ERP");
        req.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(req, resp);
    }

    private void handleGetProfile(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO currentUser)
            throws ServletException, IOException {
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Optional<UserViewDTO> userOpt = userService.getUserById(currentUser.getUserId());
        if (userOpt.isEmpty()) {
            FlashMessageUtil.setError(req, "Không tìm thấy thông tin tài khoản.");
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        req.setAttribute("userProfile", userOpt.get());
        req.setAttribute("pageTitle", "Hồ sơ cá nhân & Bảo mật — EduCenter ERP");
        req.setAttribute("activeNav", "profile");
        req.setAttribute("internalShell", true);
        req.getRequestDispatcher("/WEB-INF/views/auth/profile.jsp").forward(req, resp);
    }

    // --- POST Handlers (PRG Pattern) ---

    private void handlePostLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String redirectUrl = req.getParameter("redirect_url");

        try {
            UserPrincipalDTO principal = authService.login(email, password);

            // FR-002: Renew session on login (prevent session fixation)
            HttpSession oldSession = req.getSession(false);
            Object guestCart = oldSession == null ? null : oldSession.getAttribute(com.educenter.service.CartServiceImpl.SESSION_CART_KEY);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession newSession = req.getSession(true);
            newSession.setMaxInactiveInterval(30 * 60); // 30 minutes
            newSession.setAttribute("currentUser", principal);
            if (guestCart != null) newSession.setAttribute(com.educenter.service.CartServiceImpl.SESSION_CART_KEY, guestCart);
            CsrfUtil.getOrCreateToken(newSession);

            if (principal.isStudent() || principal.isParent()) {
                try {
                    new com.educenter.service.CartServiceImpl().mergeGuestCart(newSession, principal.getUserId());
                } catch (RuntimeException ex) {
                    FlashMessageUtil.setWarning(req, "Đã giữ lại lựa chọn từ giỏ khách. Vui lòng kiểm tra danh sách đăng ký trước khi xác nhận.");
                }
            }

            FlashMessageUtil.setSuccess(req, "Đăng nhập thành công! Chào mừng " + principal.getFullName() + ".");

            String target = RouteUtil.resolveAuthorizedRedirect(redirectUrl, req.getContextPath(), principal,
                    req.getContextPath() + principal.getDefaultDashboardUrl());
            resp.sendRedirect(target);
        } catch (ValidationException e) {
            // Clear any stale principal from the existing session so the user stays on /login and sees the error
            HttpSession currentSession = req.getSession(false);
            if (currentSession != null) {
                currentSession.removeAttribute("currentUser");
            }
            FlashMessageUtil.setError(req, e.getMessage());
            req.getSession(true).setAttribute("preserved_email", email);
            String loginUrl = req.getContextPath() + "/login";
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                loginUrl += "?redirect_url=" + java.net.URLEncoder.encode(redirectUrl, java.nio.charset.StandardCharsets.UTF_8);
            }
            resp.sendRedirect(loginUrl);
        }
    }

    private void handlePostRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String roleCode = req.getParameter("roleCode");
        String studentEmail = req.getParameter("studentEmail");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        RegisterRequestDTO dto = new RegisterRequestDTO(fullName, email, phone, roleCode, studentEmail, password, confirmPassword);

        try {
            authService.register(dto);
            if ("PARENT".equalsIgnoreCase(roleCode) && studentEmail != null && !studentEmail.trim().isEmpty()) {
                FlashMessageUtil.setSuccess(req, "Đăng ký thành công! Hệ thống đã tự động liên kết và xác minh quan hệ phụ huynh với học sinh (" + studentEmail.trim() + ").");
            } else {
                FlashMessageUtil.setSuccess(req, "Đăng ký tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            HttpSession session = req.getSession(true);
            session.setAttribute("preserved_fullName", fullName);
            session.setAttribute("preserved_email", email);
            session.setAttribute("preserved_phone", phone);
            session.setAttribute("preserved_roleCode", roleCode);
            session.setAttribute("preserved_studentEmail", studentEmail);
            resp.sendRedirect(req.getContextPath() + "/register");
        }
    }

    private void handlePostLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/?loggedOut=true");
    }

    private void handlePostForgotPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        try {
            String rawToken = authService.requestPasswordReset(email);
            if (rawToken != null) {
                String resetLink = req.getContextPath() + "/reset-password?token=" + rawToken;
                HttpSession session = req.getSession(true);
                session.setAttribute("demo_reset_link", resetLink);
                session.setAttribute("reset_link", resetLink);
                session.setAttribute("reset_email", (email != null) ? email.trim() : "");
                session.removeAttribute("preserved_email");
                FlashMessageUtil.setSuccess(req, "Xác thực email thành công! Bạn có thể mở liên kết dưới đây để đặt lại mật khẩu mới.");
            }
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            req.getSession(true).setAttribute("preserved_email", email);
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
        }
    }

    private void handlePostResetPassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String token = req.getParameter("token");
        String newPassword = req.getParameter("newPassword");
        String confirmNewPassword = req.getParameter("confirmNewPassword");

        try {
            authService.resetPassword(token, newPassword, confirmNewPassword);
            HttpSession existingSession = req.getSession(false);
            if (existingSession != null) existingSession.invalidate();
            FlashMessageUtil.setSuccess(req, "Đặt lại mật khẩu thành công! Vui lòng đăng nhập bằng mật khẩu mới.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/reset-password?token=" + token);
        }
    }

    private void handlePostProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        UserPrincipalDTO currentUser = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if ("password".equalsIgnoreCase(action)) {
            String currentPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirmNewPassword = req.getParameter("confirmNewPassword");
            try {
                authService.changePassword(currentUser.getUserId(), currentPassword, newPassword, confirmNewPassword);
                session.setAttribute("currentUser", authService.refreshPrincipal(currentUser.getUserId()));
                FlashMessageUtil.setSuccess(req, "Đổi mật khẩu thành công! Tài khoản của bạn đã được bảo vệ.");
            } catch (ValidationException e) {
                FlashMessageUtil.setError(req, e.getMessage());
            }
        } else {
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            String avatarUrl = req.getParameter("avatarUrl");

            ProfileUpdateDTO dto = new ProfileUpdateDTO();
            dto.setFullName(fullName);
            dto.setPhone(phone);
            dto.setAvatarUrl(avatarUrl);

            try {
                User updated = userService.updateProfile(currentUser.getUserId(), dto);
                currentUser.setFullName(updated.getFullName());
                currentUser.setPhone(updated.getPhone());
                currentUser.setAvatarUrl(updated.getAvatarUrl());
                session.setAttribute("currentUser", currentUser);
                FlashMessageUtil.setSuccess(req, "Cập nhật thông tin cá nhân thành công!");
            } catch (ValidationException e) {
                FlashMessageUtil.setError(req, e.getMessage());
            }
        }
        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}
