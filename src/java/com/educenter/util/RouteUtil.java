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
            return !path.contains(":") && !path.contains("\\");
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
}
