package com.educenter.filter;

import com.educenter.dto.UserPrincipalDTO;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter enforcing Role-Based Access Control (RBAC) matrix per Section 7.2.
 */
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        if (request instanceof HttpServletRequest && response instanceof HttpServletResponse) {
            HttpServletRequest httpRequest = (HttpServletRequest) request;
            HttpServletResponse httpResponse = (HttpServletResponse) response;

            String contextPath = httpRequest.getContextPath();
            String path = httpRequest.getRequestURI().substring(contextPath.length());

            HttpSession session = httpRequest.getSession(false);
            UserPrincipalDTO principal = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

            if (principal != null) {
                boolean authorized = isAuthorized(path, principal);
                if (!authorized) {
                    httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    httpRequest.setAttribute("pageTitle", "Truy cập bị từ chối - 403");
                    httpRequest.setAttribute("forbiddenPath", path);
                    httpRequest.getRequestDispatcher("/WEB-INF/views/common/403.jsp").forward(request, response);
                    return;
                }
            }
        }
        chain.doFilter(request, response);
    }

    private boolean isAuthorized(String path, UserPrincipalDTO principal) {
        if (path == null) return true;

        // Admin has access to all subsystems
        if (principal.isAdmin()) {
            return true;
        }

        if (path.startsWith("/admin")) {
            return principal.isAdmin();
        }
        if (path.startsWith("/staff")) {
            return principal.isStaff() || principal.isAdmin();
        }
        if (path.startsWith("/teacher")) {
            return principal.isTeacher() || principal.isAdmin();
        }
        if (path.startsWith("/student")) {
            return principal.isStudent() || principal.isAdmin();
        }
        if (path.startsWith("/parent")) {
            return principal.isParent() || principal.isAdmin();
        }

        // Profile and general routes are accessible to all authenticated users
        return true;
    }

    @Override
    public void destroy() {
    }
}
