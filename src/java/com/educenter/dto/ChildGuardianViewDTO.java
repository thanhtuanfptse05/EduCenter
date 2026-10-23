package com.educenter.dto;

import java.io.Serializable;

/**
 * DTO representing a child linked to a guardian in Parent Portal.
 */
public class ChildGuardianViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String fullName;
    private String code; // HV0001
    private Integer gradeLevel;
    private String school;
    private String relationship;
    private Boolean isPrimary;
    private boolean verified;

    public ChildGuardianViewDTO() {}

    public ChildGuardianViewDTO(Long id, String fullName, String code, Integer gradeLevel,
                                String school, String relationship, Boolean isPrimary, boolean verified) {
        this.id = id;
        this.fullName = fullName;
        this.code = code;
        this.gradeLevel = gradeLevel;
        this.school = school;
        this.relationship = relationship;
        this.isPrimary = isPrimary;
        this.verified = verified;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getSchool() { return school; }
    public void setSchool(String school) { this.school = school; }

    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }

    public Boolean getIsPrimary() { return isPrimary; }
    public void setIsPrimary(Boolean isPrimary) { this.isPrimary = isPrimary; }

    public boolean isVerified() { return verified; }
    public void setVerified(boolean verified) { this.verified = verified; }
}
