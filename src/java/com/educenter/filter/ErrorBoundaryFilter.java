package com.educenter.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class ErrorBoundaryFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        request.setAttribute("currentYear", java.time.LocalDate.now(ZoneId.of("Asia/Ho_Chi_Minh")).getYear());
        try { chain.doFilter(request, response); }
        catch (ServletException | RuntimeException | LinkageError e) {
            String reference = "EC-" + UUID.randomUUID().toString().substring(0, 12).toUpperCase(java.util.Locale.ROOT);
            req.getServletContext().log("Incident " + reference + " at " + req.getServletPath(), e);
            req.setAttribute("incidentReference", reference);
            req.setAttribute("incidentTime", ZonedDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")));
            if (resp.isCommitted()) throw e;
            resp.resetBuffer(); resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
