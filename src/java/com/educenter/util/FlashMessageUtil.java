package com.educenter.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Utility class supporting the Post/Redirect/Get (PRG) pattern with single-use flash messages.
 */
public final class FlashMessageUtil {

    public static final String FLASH_SUCCESS = "flash_success";
    public static final String FLASH_ERROR = "flash_error";
    public static final String FLASH_INFO = "flash_info";
    public static final String FLASH_WARNING = "flash_warning";

    private FlashMessageUtil() {
        // Prevent instantiation
    }

    /**
     * Sets a flash success message in session.
     */
    public static void setSuccess(HttpServletRequest request, String message) {
        setFlash(request, FLASH_SUCCESS, message);
    }

    /**
     * Sets a flash error message in session.
     */
    public static void setError(HttpServletRequest request, String message) {
        setFlash(request, FLASH_ERROR, message);
    }

    /**
     * Sets a flash info message in session.
     */
    public static void setInfo(HttpServletRequest request, String message) {
        setFlash(request, FLASH_INFO, message);
    }

    /**
     * Sets a flash warning message in session.
     */
    public static void setWarning(HttpServletRequest request, String message) {
        setFlash(request, FLASH_WARNING, message);
    }

    private static void setFlash(HttpServletRequest request, String key, String message) {
        HttpSession session = request.getSession(true);
        session.setAttribute(key, message);
    }

    /**
     * Consumes (reads and removes) a flash message from session, making it available as a request attribute.
     */
    public static void transferFlashMessagesToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            for (String key : new String[]{FLASH_SUCCESS, FLASH_ERROR, FLASH_INFO, FLASH_WARNING}) {
                Object val = session.getAttribute(key);
                if (val != null) {
                    request.setAttribute(key, val);
                    session.removeAttribute(key);
                }
            }
        }
    }
}
