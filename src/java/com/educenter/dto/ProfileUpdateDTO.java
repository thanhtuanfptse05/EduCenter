package com.educenter.dto;

import java.io.Serializable;

/**
 * DTO carrying profile details and password update parameters.
 */
public class ProfileUpdateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String action; // "profile" or "password"
    private String fullName;
    private String phone;
    private String avatarUrl;

    // Fields for password change
    private String currentPassword;
    private String newPassword;
    private String confirmNewPassword;

    public ProfileUpdateDTO() {
        this.action = "profile";
    }

    public ProfileUpdateDTO(String fullName, String phone, String avatarUrl) {
        this();
        this.fullName = fullName;
        this.phone = phone;
        this.avatarUrl = avatarUrl;
    }

    public boolean isPasswordChange() {
        return "password".equalsIgnoreCase(action);
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
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

    public String getCurrentPassword() {
        return currentPassword;
    }

    public void setCurrentPassword(String currentPassword) {
        this.currentPassword = currentPassword;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getConfirmNewPassword() {
        return confirmNewPassword;
    }

    public void setConfirmNewPassword(String confirmNewPassword) {
        this.confirmNewPassword = confirmNewPassword;
    }
}
