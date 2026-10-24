package com.educenter.dto;

import java.io.Serializable;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * Lightweight principal object stored in HttpSession under "currentUser".
 */
public class UserPrincipalDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long userId;
    private String email;
    private String fullName;
    private String phone;
    private String avatarUrl;
    private String status;
    private Set<String> roles;
    private String credentialFingerprint;

    public String getCredentialFingerprint() { return credentialFingerprint; }
    public void setCredentialFingerprint(String value) { credentialFingerprint = value; }

    public UserPrincipalDTO() {
        this.roles = new HashSet<>();
    }

    public UserPrincipalDTO(Long userId, String email, String fullName, String phone,
                            String avatarUrl, String status, Set<String> roles) {
        this.userId = userId;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.avatarUrl = avatarUrl;
        this.status = status;
        this.roles = (roles != null) ? new HashSet<>(roles) : new HashSet<>();
    }

    public boolean hasRole(String roleCode) {
        if (roles == null || roleCode == null) return false;
        return roles.contains(roleCode.toUpperCase());
    }

    public boolean isAdmin() {
        return hasRole("ADMIN");
    }

    public boolean isStaff() {
        return hasRole("STAFF");
    }

    public boolean isTeacher() {
        return hasRole("TEACHER");
    }

    public boolean isStudent() {
        return hasRole("STUDENT");
    }

    public boolean isParent() {
        return hasRole("PARENT");
    }

    /**
     * Determines primary role for default dashboard redirection.
     * Order of priority: ADMIN > STAFF > TEACHER > STUDENT > PARENT
     */
    public String getPrimaryRole() {
        if (isAdmin()) return "ADMIN";
        if (isStaff()) return "STAFF";
        if (isTeacher()) return "TEACHER";
        if (isStudent()) return "STUDENT";
        if (isParent()) return "PARENT";
        return roles.isEmpty() ? "GUEST" : roles.iterator().next();
    }

    /**
     * Resolves the default landing URL for this principal.
     */
    public String getDefaultDashboardUrl() {
        String primary = getPrimaryRole();
        return switch (primary) {
            case "ADMIN" -> "/admin/dashboard";
            case "STAFF" -> "/staff/dashboard";
            case "TEACHER" -> "/teacher/dashboard";
            case "STUDENT" -> "/student/dashboard";
            case "PARENT" -> "/parent/dashboard";
            default -> "/";
        };
    }

    // Getters and Setters

    public Long getUserId() {
        return userId;
    }

    public Long getId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public void setId(Long id) {
        this.userId = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Set<String> getRoles() {
        return Collections.unmodifiableSet(roles);
    }

    public void setRoles(Set<String> roles) {
        this.roles = (roles != null) ? new HashSet<>(roles) : new HashSet<>();
    }

    @Override
    public String toString() {
        return "UserPrincipalDTO{" + "userId=" + userId + ", email='" + email + '\'' + ", roles=" + roles + '}';
    }
}
