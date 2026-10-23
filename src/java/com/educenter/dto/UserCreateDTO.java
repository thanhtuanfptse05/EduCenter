package com.educenter.dto;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

public class UserCreateDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String email;
    private String password;
    private String fullName;
    private String phone;
    private String status = "ACTIVE";
    private Set<String> roles = new HashSet<>();

    public UserCreateDTO() {}

    public UserCreateDTO(String email, String password, String fullName, String phone, String status, Set<String> roles) {
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.status = status;
        this.roles = (roles != null) ? roles : new HashSet<>();
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Set<String> getRoles() { return roles; }
    public void setRoles(Set<String> roles) { this.roles = roles; }
}
