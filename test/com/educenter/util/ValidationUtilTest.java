package com.educenter.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ValidationUtil & RouteUtil Tests")
public class ValidationUtilTest {

    @Test
    @DisplayName("Email normalization trims and converts to lowercase using Locale.ROOT (BR01)")
    public void testEmailNormalization() {
        assertEquals("user@educenter.vn", ValidationUtil.normalizeEmail("  User@EduCenter.VN  "));
        assertNull(ValidationUtil.normalizeEmail(null));
    }

    @Test
    @DisplayName("Email validation adheres to RFC 5322 format")
    public void testEmailValidation() {
        assertTrue(ValidationUtil.isValidEmail("admin@educenter.vn"));
        assertTrue(ValidationUtil.isValidEmail("student.nam+test@domain.com.vn"));
        assertFalse(ValidationUtil.isValidEmail("invalid-email"));
        assertFalse(ValidationUtil.isValidEmail("@domain.com"));
        assertFalse(ValidationUtil.isValidEmail("user@"));
        assertFalse(ValidationUtil.isValidEmail(null));
    }

    @Test
    @DisplayName("Password rules enforce min 6 characters and max 72 UTF-8 bytes")
    public void testPasswordValidation() {
        assertTrue(ValidationUtil.isValidPassword("123456"));
        assertTrue(ValidationUtil.isValidPassword("StrongPass#2026"));
        assertFalse(ValidationUtil.isValidPassword("12345")); // too short
        assertFalse(ValidationUtil.isValidPassword(null));
    }

    @Test
    @DisplayName("Safe redirect prevents open redirect vulnerabilities")
    public void testSafeRedirect() {
        assertTrue(RouteUtil.isSafeRedirect("/admin/users", ""));
        assertTrue(RouteUtil.isSafeRedirect("/profile", ""));
        assertFalse(RouteUtil.isSafeRedirect("https://attacker.com/evil", ""));
        assertFalse(RouteUtil.isSafeRedirect("//attacker.com/evil", ""));
        assertFalse(RouteUtil.isSafeRedirect("/\\attacker.com", ""));
        assertFalse(RouteUtil.isSafeRedirect("javascript:alert(1)", ""));
        assertFalse(RouteUtil.isSafeRedirect(null, ""));
    }
}
