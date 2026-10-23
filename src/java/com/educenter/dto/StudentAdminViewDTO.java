package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class StudentAdminViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private Long id;
    private String code;
    private String fullName;
    private LocalDate dob;
    private String formattedDob;
    private String gender; // 'NAM', 'NU', 'KHAC'
    private String phone;
    private String email;
    private String school;
    private Integer gradeLevel;
    private String targetGoal;
    private String status; // STUDYING, RESERVED, DROPPED, GRADUATED
    private Long userId;
    private String userEmail;
    private String userStatus;
    private long guardianCount = 0;
    private long enrolledClassCount = 0;
    private LocalDateTime createdAt;

    public StudentAdminViewDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) {
        this.id = id;
        this.code = "HV" + String.format("%04d", id != null ? id : 0);
    }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) {
        this.dob = dob;
        this.formattedDob = (dob != null) ? dob.format(DATE_FMT) : "Chưa cập nhật";
    }

    public String getFormattedDob() { return formattedDob != null ? formattedDob : "Chưa cập nhật"; }
    public void setFormattedDob(String formattedDob) { this.formattedDob = formattedDob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getGenderDisplay() {
        if ("NAM".equalsIgnoreCase(gender)) return "Nam";
        if ("NU".equalsIgnoreCase(gender)) return "Nữ";
        return "Khác";
    }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSchool() { return school; }
    public void setSchool(String school) { this.school = school; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getTargetGoal() { return targetGoal; }
    public void setTargetGoal(String targetGoal) { this.targetGoal = targetGoal; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getUserStatus() { return userStatus; }
    public void setUserStatus(String userStatus) { this.userStatus = userStatus; }

    public boolean isHasUserAccount() { return userId != null; }

    public long getGuardianCount() { return guardianCount; }
    public void setGuardianCount(long guardianCount) { this.guardianCount = guardianCount; }

    public long getGuardiansCount() { return guardianCount; }
    public void setGuardiansCount(long count) { this.guardianCount = count; }

    public long getEnrolledClassCount() { return enrolledClassCount; }
    public void setEnrolledClassCount(long enrolledClassCount) { this.enrolledClassCount = enrolledClassCount; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
