package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;

public class TeacherAdminViewDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long userId;
    private String userEmail;
    private String fullName;
    private String phone;
    private String email;
    private String avatarUrl;
    private String specialization;
    private String degree;
    private BigDecimal hourlyRate;
    private String status;
    private long activeClassesCount;
    private long totalClassesCount;
    private LocalDateTime createdAt;

    public TeacherAdminViewDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() {
        return "GV" + String.format("%03d", id != null ? id : 0);
    }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }

    public BigDecimal getHourlyRate() { return hourlyRate; }
    public void setHourlyRate(BigDecimal hourlyRate) { this.hourlyRate = hourlyRate; }

    public String getFormattedHourlyRate() {
        if (hourlyRate == null || hourlyRate.compareTo(BigDecimal.ZERO) == 0) return "0 đ/h";
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(hourlyRate) + " đ/h";
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public long getActiveClassesCount() { return activeClassesCount; }
    public void setActiveClassesCount(long activeClassesCount) { this.activeClassesCount = activeClassesCount; }

    public long getTotalClassesCount() { return totalClassesCount; }
    public void setTotalClassesCount(long totalClassesCount) { this.totalClassesCount = totalClassesCount; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
