package com.educenter.service;

import com.educenter.dto.LoginRequestDTO;
import com.educenter.dto.RegisterRequestDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.entity.User;

/**
 * Service interface for authentication, registration, and password management.
 */
public interface AuthService {

    /**
     * Authenticates a user by email and password.
     * Enforces active status check and returns UserPrincipalDTO.
     */
    UserPrincipalDTO login(String email, String password);

    /**
     * Registers a new account with STUDENT or PARENT role.
     * Enforces BR01 email uniqueness and password rules.
     */
    User register(RegisterRequestDTO dto);

    /**
     * Changes account password with current password verification.
     */
    void changePassword(Long userId, String currentPassword, String newPassword, String confirmNewPassword);

    /**
     * Generates a password reset token for valid email (FR-004).
     * Returns the raw token string (or empty if email does not exist).
     */
    String requestPasswordReset(String email);

    /**
     * Resets password using token verification.
     */
    void resetPassword(String rawToken, String newPassword, String confirmNewPassword);

    /**
     * Re-reads fresh status and roles for an authenticated user ID.
     */
    UserPrincipalDTO refreshPrincipal(Long userId);
}
