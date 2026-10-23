package com.educenter.filter;

import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.CartServiceImpl;
import com.educenter.service.PortalReferenceService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PageDataFilter implements Filter {
    private static final Logger LOG = Logger.getLogger(PageDataFilter.class.getName());

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        String path = req.getRequestURI().substring(req.getContextPath().length());
        if (path.startsWith("/assets/") || !"GET".equals(req.getMethod())) {
            chain.doFilter(request, response); return;
        }
        req.setAttribute("currentYear", LocalDate.now(java.time.ZoneId.of("Asia/Ho_Chi_Minh")).getYear());
        try {
            PortalReferenceService.Data data = new PortalReferenceService().getData();
            req.setAttribute("portalSubjects", data.subjects());
            req.setAttribute("availableGrades", data.grades());
            Map<String, String> settings = data.contact();
            req.setAttribute("contactAddress", first(settings, "center_address", "contact_address", "address"));
            req.setAttribute("contactPhone", first(settings, "center_phone", "contact_phone", "hotline"));
            req.setAttribute("contactEmail", first(settings, "center_email", "contact_email", "email"));
            HttpSession session = req.getSession(false);
            UserPrincipalDTO user = session == null ? null : (UserPrincipalDTO) session.getAttribute("currentUser");
            req.setAttribute("cartCount", new CartServiceImpl().getCart(session, user == null ? null : user.getUserId()).getTotalCourses());
        } catch (RuntimeException | LinkageError e) {
            LOG.log(Level.WARNING, "Reference data unavailable", e);
            req.setAttribute("referenceDataUnavailable", true);
            req.setAttribute("portalSubjects", List.of());
            req.setAttribute("availableGrades", List.of());
        }
        chain.doFilter(request, response);
    }

    private static String first(Map<String, String> values, String... keys) {
        for (String key : keys) { String v = values.get(key); if (v != null && !v.isBlank()) return v; }
        return null;
    }
}
