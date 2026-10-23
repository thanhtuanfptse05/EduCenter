package com.educenter.util;

import java.nio.charset.StandardCharsets;
import java.util.Locale;
import java.util.regex.Pattern;

/**
 * Validation utilities enforcing BR01, BR02, and security specifications.
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$"
    );

    private static final Pattern VN_PHONE_PATTERN = Pattern.compile(
            "^(0)(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-9]|9[0-9])[0-9]{7}$"
    );

    private ValidationUtil() {
        // Prevent instantiation
    }

    /**
     * Normalizes email address to trimmed lowercase using Locale.ROOT (BR01).
     */
    public static String normalizeEmail(String email) {
        if (email == null) {
            return null;
        }
        return email.trim().toLowerCase(Locale.ROOT);
    }

    /**
     * Validates whether an email address is syntactically valid.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) {
            return false;
        }
        String normalized = email.trim();
        return !normalized.isEmpty() && normalized.length() <= 255 && EMAIL_PATTERN.matcher(normalized).matches();
    }

    /**
     * Validates password rules: minimum 6 characters, maximum 72 bytes UTF-8 (BCrypt technical limit).
     */
    public static boolean isValidPassword(String password) {
        if (password == null) {
            return false;
        }
        if (password.length() < 6) {
            return false;
        }
        byte[] bytes = password.getBytes(StandardCharsets.UTF_8);
        return bytes.length <= 72;
    }

    /**
     * Validates Vietnamese phone numbers. If null or empty, returns true (optional field).
     */
    public static boolean isValidPhone(String phone, boolean required) {
        if (phone == null || phone.trim().isEmpty()) {
            return !required;
        }
        String cleanPhone = phone.trim().replaceAll("[\\s.-]", "");
        return VN_PHONE_PATTERN.matcher(cleanPhone).matches();
    }

    /**
     * Validates full name: non-empty, max 150 characters, safe text.
     */
    public static boolean isValidFullName(String name) {
        if (name == null) {
            return false;
        }
        String trimmed = name.trim();
        return trimmed.length() >= 2 && trimmed.length() <= 150;
    }

    /**
     * Normalizes optional avatar URL: trims, handles protocol-relative, data URI, or missing protocol.
     */
    public static String normalizeAvatarUrl(String url) {
        if (url == null) {
            return null;
        }
        String trimmed = url.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        if (trimmed.startsWith("//")) {
            return "https:" + trimmed;
        }
        if (!trimmed.startsWith("http://") && !trimmed.startsWith("https://")
                && !trimmed.startsWith("/") && !trimmed.startsWith("data:image/")) {
            if (trimmed.contains(".") && !trimmed.contains(" ")) {
                return "https://" + trimmed;
            }
        }
        return trimmed;
    }

    /**
     * Validates optional avatar URL: allows HTTP/HTTPS, absolute local path, or data URI up to 500 chars.
     */
    public static boolean isValidAvatarUrl(String url) {
        if (url == null || url.trim().isEmpty()) {
            return true;
        }
        String normalized = normalizeAvatarUrl(url);
        if (normalized == null || normalized.length() > 500) {
            return false;
        }
        return normalized.startsWith("http://")
                || normalized.startsWith("https://")
                || normalized.startsWith("/")
                || normalized.startsWith("data:image/");
    }
}
