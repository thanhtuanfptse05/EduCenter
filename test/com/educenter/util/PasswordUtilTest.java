package com.educenter.util;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("PasswordUtil — BCrypt Security & Hashing Tests")
public class PasswordUtilTest {

    @Test
    @DisplayName("Hash password produces non-empty BCrypt string with cost factor 10")
    public void testHashPassword() {
        String plain = "123456";
        String hashed = PasswordUtil.hashPassword(plain);

        assertNotNull(hashed);
        assertTrue(hashed.startsWith("$2a$10$") || hashed.startsWith("$2b$10$"),
                "Hash must start with BCrypt cost factor 10 prefix");
        assertNotEquals(plain, hashed);
    }

    @Test
    @DisplayName("Verify password succeeds for correct credentials")
    public void testVerifyPasswordSuccess() {
        String plain = "SecretPassword!2026";
        String hashed = PasswordUtil.hashPassword(plain);

        assertTrue(PasswordUtil.verifyPassword(plain, hashed), "Password verification should pass");
    }

    @Test
    @DisplayName("Verify password fails for incorrect credentials")
    public void testVerifyPasswordFailure() {
        String plain = "CorrectPassword";
        String hashed = PasswordUtil.hashPassword(plain);

        assertFalse(PasswordUtil.verifyPassword("WrongPassword", hashed), "Wrong password should fail verification");
        assertFalse(PasswordUtil.verifyPassword(null, hashed), "Null password should return false");
        assertFalse(PasswordUtil.verifyPassword(plain, null), "Null hash should return false");
        assertFalse(PasswordUtil.verifyPassword(plain, "invalid-hash-string"), "Corrupt hash should return false safely");
    }

    @Test
    @DisplayName("Blank or null password throws IllegalArgumentException on hash")
    public void testHashInvalidInputs() {
        assertThrows(IllegalArgumentException.class, () -> PasswordUtil.hashPassword(null));
        assertThrows(IllegalArgumentException.class, () -> PasswordUtil.hashPassword("   "));
    }
}
