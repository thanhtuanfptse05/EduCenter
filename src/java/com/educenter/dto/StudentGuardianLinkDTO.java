package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class StudentGuardianLinkDTO implements Serializable {

    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DATETIME_FMT = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private Long id;
    private Long studentId;
    private String studentCode;
    private String studentName;
    private Integer studentGradeLevel;

    private Long guardianId;
    private String guardianCode;
    private String guardianName;
    private String guardianPhone;
    private String guardianEmail;
    private String guardianOccupation;

    private String relationship;
    private Boolean isPrimary = false;
    private LocalDateTime verifiedAt;
    private String formattedVerifiedAt;
    private Long verifiedBy;
    private String verifierName;

    public StudentGuardianLinkDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) {
        this.studentId = studentId;
        this.studentCode = "HV" + String.format("%04d", studentId != null ? studentId : 0);
    }

    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public Integer getStudentGradeLevel() { return studentGradeLevel; }
    public void setStudentGradeLevel(Integer studentGradeLevel) { this.studentGradeLevel = studentGradeLevel; }

    public Long getGuardianId() { return guardianId; }
    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
        this.guardianCode = "PH" + String.format("%04d", guardianId != null ? guardianId : 0);
    }

    public String getGuardianCode() { return guardianCode; }
    public void setGuardianCode(String guardianCode) { this.guardianCode = guardianCode; }

    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }

    public String getGuardianPhone() { return guardianPhone; }
    public void setGuardianPhone(String guardianPhone) { this.guardianPhone = guardianPhone; }

    public String getGuardianEmail() { return guardianEmail; }
    public void setGuardianEmail(String guardianEmail) { this.guardianEmail = guardianEmail; }

    public String getGuardianOccupation() { return guardianOccupation; }
    public void setGuardianOccupation(String guardianOccupation) { this.guardianOccupation = guardianOccupation; }

    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }

    public Boolean getIsPrimary() { return isPrimary; }
    public void setIsPrimary(Boolean isPrimary) { this.isPrimary = isPrimary; }

    public LocalDateTime getVerifiedAt() { return verifiedAt; }
    public void setVerifiedAt(LocalDateTime verifiedAt) {
        this.verifiedAt = verifiedAt;
        this.formattedVerifiedAt = (verifiedAt != null) ? verifiedAt.format(DATETIME_FMT) : null;
    }

    public String getFormattedVerifiedAt() { return formattedVerifiedAt; }
    public void setFormattedVerifiedAt(String formattedVerifiedAt) { this.formattedVerifiedAt = formattedVerifiedAt; }

    public Long getVerifiedBy() { return verifiedBy; }
    public void setVerifiedBy(Long verifiedBy) { this.verifiedBy = verifiedBy; }

    public String getVerifierName() { return verifierName; }
    public void setVerifierName(String verifierName) { this.verifierName = verifierName; }

    public boolean isVerified() {
        return verifiedAt != null;
    }
}
