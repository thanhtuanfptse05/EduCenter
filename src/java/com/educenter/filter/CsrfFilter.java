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
        if (request instanceof HttpServletRequest httpRequest && response instanceof HttpServletResponse httpResponse) {
            String method = httpRequest.getMethod();

            // Auto-create CSRF token for any GET request that visits a page
            HttpSession session = httpRequest.getSession(true);
            String csrfToken = CsrfUtil.getOrCreateToken(session);
            httpRequest.setAttribute(CsrfUtil.CSRF_PARAM_NAME, csrfToken);

            if ("POST".equalsIgnoreCase(method)) {
                if (!CsrfUtil.isValidToken(httpRequest)) {
                    httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    FlashMessageUtil.setError(httpRequest, "Phiên làm việc đã hết hạn hoặc mã bảo mật (CSRF) không hợp lệ. Vui lòng tải lại trang.");
                    String referer = httpRequest.getHeader("Referer");
                    if (referer != null && referer.contains(httpRequest.getContextPath())) {
                        httpResponse.sendRedirect(referer);
                    } else {
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
                    }
                    return;
                }
            }
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
