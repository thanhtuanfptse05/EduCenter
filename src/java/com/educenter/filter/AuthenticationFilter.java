package com.educenter.filter;

import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.AuthService;
import com.educenter.service.AuthServiceImpl;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Filter checking authentication and refreshing active status for protected routes (FR-003).
 */
public class AuthenticationFilter implements Filter {

    private AuthService authService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.authService = new AuthServiceImpl();
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest && response instanceof HttpServletResponse) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            String contextPath = httpRequest.getContextPath();
            String uri = httpRequest.getRequestURI();
            String path = uri.substring(contextPath.length());

            if (isProtectedPath(path)) {
                HttpSession session = httpRequest.getSession(false);
                UserPrincipalDTO principal = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

                if (principal == null) {
                    // Save local redirect path
                    String queryString = httpRequest.getQueryString();
                    String fullPath = (queryString != null && !queryString.isEmpty()) ? (path + "?" + queryString) : path;
                    String encodedPath = URLEncoder.encode(fullPath, StandardCharsets.UTF_8);

                    FlashMessageUtil.setWarning(httpRequest, "Vui lòng đăng nhập để tiếp tục sử dụng hệ thống.");
                    httpResponse.sendRedirect(contextPath + "/login?redirect_url=" + encodedPath);
                    return;
                }

                // FR-003: Re-read active status and roles on every protected request
                UserPrincipalDTO freshPrincipal = authService.refreshPrincipal(principal.getUserId());
                if (freshPrincipal == null || !"ACTIVE".equalsIgnoreCase(freshPrincipal.getStatus())) {
                    if (session != null) {
                        session.invalidate();
                    }
                    FlashMessageUtil.setError(httpRequest, "Tài khoản của bạn đã bị khóa hoặc không còn hoạt động.");
                    httpResponse.sendRedirect(contextPath + "/login");
                    return;
                }

                // Update session with fresh roles and status
                session.setAttribute("currentUser", freshPrincipal);
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isProtectedPath(String path) {
        if (path == null) return false;
        return path.startsWith("/admin")
                || path.startsWith("/staff")
                || path.startsWith("/teacher")
                || path.startsWith("/student")
                || path.startsWith("/parent")
                || path.equals("/profile")
                || path.startsWith("/profile/");
    }

    @Override
    public void destroy() {
    }
}
