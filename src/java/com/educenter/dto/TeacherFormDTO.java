package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class TeacherFormDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private String fullName;
    private String phone;
    private String email;
    private String specialization;
    private String degree;
    private BigDecimal hourlyRate = BigDecimal.ZERO;
    private String bio;
    private String status = "ACTIVE";

    public TeacherFormDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }

    public BigDecimal getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(BigDecimal hourlyRate) { this.hourlyRate = hourlyRate; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
