package com.educenter.util;

import java.net.URI;
import java.net.URISyntaxException;

/**
 * Route and URL utility preventing Open Redirect vulnerabilities (CWE-601).
 */
public final class RouteUtil {

    private RouteUtil() {
        // Prevent instantiation
    }

    /**
     * Determines whether a given redirect URL is safe (local relative path within same application).
     * Rejects absolute URLs, external schemes (http:, https:, javascript:), double slashes (//attacker.com),
     * and backslash path traversal tricks.
     *
     * @param redirectUrl URL candidate to validate
     * @param contextPath Servlet context path
     * @return true if strictly safe and local
     */
    public static boolean isSafeRedirect(String redirectUrl, String contextPath) {
        if (redirectUrl == null || redirectUrl.trim().isEmpty()) {
            return false;
        }
        String url = redirectUrl.trim();
        // Prevent protocol-relative URLs or Windows backslash evasion
        if (url.startsWith("//") || url.startsWith("/\\") || url.startsWith("\\")) {
            return false;
        }
        // Must start with a single slash
        if (!url.startsWith("/")) {
            return false;
        }
        try {
            URI uri = new URI(url);
            // Must not have scheme or host
            if (uri.getScheme() != null || uri.getHost() != null || uri.getAuthority() != null) {
                return false;
            }
            // Strip context path if present
            String path = uri.getPath();
            if (path == null) {
                return false;
            }
            // Block forbidden patterns
            String raw = uri.getRawPath().toLowerCase(java.util.Locale.ROOT);
            return !path.contains(":") && !path.contains("\\") && !path.contains("//")
                    && !path.contains(";") && path.chars().noneMatch(Character::isISOControl)
                    && !raw.contains("%2f") && !raw.contains("%5c") && !raw.contains("%2e")
                    && uri.normalize().getPath().equals(path);
        } catch (URISyntaxException e) {
            return false;
        }
    }

    /**
     * Returns the safe redirect target, or a fallback default route if the candidate is unsafe.
     */
    public static String resolveSafeRedirect(String redirectUrl, String contextPath, String fallback) {
        if (isSafeRedirect(redirectUrl, contextPath)) {
            return redirectUrl.trim();
        }
        return fallback;
    }

    public static String resolveAuthorizedRedirect(String url, String contextPath,
            com.educenter.dto.UserPrincipalDTO user, String fallback) {
        if (!isSafeRedirect(url, contextPath)) return fallback;
        URI parsed = URI.create(url.trim());
        String path = parsed.getPath();
        if (!contextPath.isEmpty() && (path.equals(contextPath) || path.startsWith(contextPath + "/")))
            path = path.substring(contextPath.length());
        if (path.isEmpty()) path = "/";
        boolean publicPath = path.equals("/") || path.equals("/index") || path.equals("/courses")
                || path.equals("/courses/detail") || path.equals("/registration-cart") || path.equals("/registration/confirm") || path.equals("/profile");
        boolean dashboard = path.equals(user.getDefaultDashboardUrl()) || user.isAdmin() && java.util.Set.of(
                "/admin/dashboard", "/admin/users", "/staff/leads", "/teacher/dashboard", "/student/dashboard", "/parent/dashboard").contains(path);
        if (!publicPath && !dashboard) return fallback;
        return contextPath + path + (parsed.getRawQuery() == null ? "" : "?" + parsed.getRawQuery());
    }
}
