package com.educenter.filter;

import com.educenter.util.CsrfUtil;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter validating CSRF token on mutating requests (POST).
 */
public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest && response instanceof HttpServletResponse) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            String uri = httpRequest.getRequestURI();
            String contextPath = httpRequest.getContextPath();
            String path = uri.substring(contextPath.length());

            // Bypass static assets from CSRF filter
            if (path.startsWith("/assets/")) {
                chain.doFilter(request, response);
                return;
            }

            String method = httpRequest.getMethod();

            // Auto-create CSRF token for page requests
            HttpSession session = httpRequest.getSession(true);
            String csrfToken = CsrfUtil.getOrCreateToken(session);
            httpRequest.setAttribute(CsrfUtil.CSRF_PARAM_NAME, csrfToken);

            if ("POST".equalsIgnoreCase(method)) {
                if (!CsrfUtil.isValidToken(httpRequest)) {
                    if (isAuthEndpoint(path)) {
                        // Refresh CSRF token in session and redirect gracefully
                        session.removeAttribute(CsrfUtil.CSRF_SESSION_ATTR);
                        CsrfUtil.getOrCreateToken(session);
                        FlashMessageUtil.setError(httpRequest, "Phiên làm việc đã hết hạn hoặc mã bảo mật không khớp. Vui lòng thử lại.");
                        String redirectUrl = contextPath + path;
                        String query = httpRequest.getQueryString();
                        if (query != null && !query.isEmpty()) {
                            redirectUrl += "?" + query;
                        }
                        httpResponse.sendRedirect(redirectUrl);
                        return;
                    }
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Mã bảo mật không hợp lệ. Vui lòng tải lại trang.");
                    return;
                }
            }
        }
        chain.doFilter(request, response);
    }

    private boolean isAuthEndpoint(String path) {
        if (path == null) return false;
        return path.equals("/login")
                || path.equals("/register")
                || path.equals("/forgot-password")
                || path.equals("/reset-password");
    }

    @Override
    public void destroy() {
    }
}
