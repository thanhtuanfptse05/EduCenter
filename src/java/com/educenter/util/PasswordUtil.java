package com.educenter.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for secure password hashing and verification using BCrypt.
 * Strictly enforces SEC-01 requirement (cost factor >= 10).
 */
public final class PasswordUtil {

    private static final int BCRYPT_LOG_ROUNDS = 10;

    private PasswordUtil() {
        // Prevent instantiation
    }

    /**
     * Hashes a plain-text password using BCrypt with salt cost 10.
     *
     * @param plainPassword Plain-text password to hash
     * @return BCrypt hashed string
     * @throws IllegalArgumentException if password is null or blank
     */
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_LOG_ROUNDS));
    }

    /**
     * Verifies a plain-text password against a BCrypt hash.
     *
     * @param plainPassword Plain-text password to check
     * @param hashedPassword Stored BCrypt hash
     * @return true if password matches hash, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null || hashedPassword.isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // Invalid hash format
            return false;
        }
    }
}
