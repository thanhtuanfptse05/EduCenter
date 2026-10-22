package com.educenter.dto;

import java.io.Serializable;

public class LeadFormDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String fullName;
    private String phone;
    private Integer gradeLevel;
    private String subject;
    private String learningModel;
    private String notes;

    public LeadFormDTO() {}

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getLearningModel() { return learningModel; }
    public void setLearningModel(String learningModel) { this.learningModel = learningModel; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
