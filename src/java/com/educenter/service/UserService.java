package com.educenter.service;

import com.educenter.dto.ProfileUpdateDTO;
import com.educenter.dto.UserPageDTO;
import com.educenter.dto.UserViewDTO;
import com.educenter.entity.User;
import java.util.Optional;
import java.util.Set;

/**
 * Service interface for user profile and administrative user management.
 */
public interface UserService {

    /**
     * Updates personal profile information (name, phone, avatar).
     */
    User updateProfile(Long userId, ProfileUpdateDTO dto);

    /**
     * Admin toggles status (ACTIVE <-> LOCKED).
     * Enforces last active admin protection and records AuditLogs (BR18).
     */
    void toggleUserStatus(Long adminId, Long targetUserId, String newStatus, String ipAddress);

    /**
     * Admin assigns roles to user.
     * Enforces last active admin protection and records AuditLogs (BR18).
     */
    void assignRoles(Long adminId, Long targetUserId, Set<String> roleCodes, String ipAddress);

    /**
     * Retrieves paginated and filtered user list for admin portal.
     */
    UserPageDTO getUserList(String keyword, String roleCode, String status, int page, int pageSize);

    /**
     * Retrieves user view details by ID.
     */
    Optional<UserViewDTO> getUserById(Long id);

    /**
     * Admin creates a new user account with initial roles and password.
     */
    User createUser(Long adminId, com.educenter.dto.UserCreateDTO dto, String ipAddress);
}
