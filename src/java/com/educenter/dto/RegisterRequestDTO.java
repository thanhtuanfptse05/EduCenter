package com.educenter.dto;

import java.io.Serializable;

/**
 * DTO carrying registration form parameters.
 */
public class RegisterRequestDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String fullName;
    private String email;
    private String phone;
    private String roleCode; // STUDENT or PARENT
    private String password;
    private String confirmPassword;

    public RegisterRequestDTO() {
        this.roleCode = "STUDENT";
    }

    public RegisterRequestDTO(String fullName, String email, String phone, String roleCode,
                              String password, String confirmPassword) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.roleCode = roleCode;
        this.password = password;
        this.confirmPassword = confirmPassword;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }
}
