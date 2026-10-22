package com.educenter.dto;

import java.io.Serializable;

/**
 * DTO carrying login form submission parameters.
 */
public class LoginRequestDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String email;
    private String password;
    private boolean rememberMe;
    private String redirectUrl;

    public LoginRequestDTO() {
    }

    public LoginRequestDTO(String email, String password, boolean rememberMe, String redirectUrl) {
        this.email = email;
        this.password = password;
        this.rememberMe = rememberMe;
        this.redirectUrl = redirectUrl;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isRememberMe() {
        return rememberMe;
    }

    public void setRememberMe(boolean rememberMe) {
        this.rememberMe = rememberMe;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }
}
