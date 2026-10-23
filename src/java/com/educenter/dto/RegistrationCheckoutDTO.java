package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class RegistrationCheckoutDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String fullName;
    private String phoneNumber;
    private String email;
    private Integer gradeLevel;
    private String schoolName;
    private List<String> targetGoals = new ArrayList<>();
    private String notes;
    private boolean consentChecked = false;
    private String submissionToken;

    public RegistrationCheckoutDTO() {}

    public String getSubmissionToken() { return submissionToken; }
    public void setSubmissionToken(String submissionToken) { this.submissionToken = submissionToken; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getSchoolName() { return schoolName; }
    public void setSchoolName(String schoolName) { this.schoolName = schoolName; }

    public List<String> getTargetGoals() { return targetGoals; }
    public void setTargetGoals(List<String> targetGoals) {
        this.targetGoals = (targetGoals != null) ? targetGoals : new ArrayList<>();
    }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public boolean isConsentChecked() { return consentChecked; }
    public void setConsentChecked(boolean consentChecked) { this.consentChecked = consentChecked; }
}
