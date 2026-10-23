package com.educenter.dto;

import java.io.Serializable;

public class AvailableTeacherUserDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long userId;
    private String email;
    private String fullName;
    private String phone;

    public AvailableTeacherUserDTO() {}

    public AvailableTeacherUserDTO(Long userId, String email, String fullName, String phone) {
        this.userId = userId;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
