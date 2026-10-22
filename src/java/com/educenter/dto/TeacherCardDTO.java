package com.educenter.dto;

import java.io.Serializable;

public class TeacherCardDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String fullName;
    private String specialization;
    private String degree;
    private String bio;
    private String experienceBadge;
    private String gradesText;
    private String photoUrl;

    public TeacherCardDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getDegree() { return degree; }
    public void setDegree(String degree) { this.degree = degree; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getExperienceBadge() { return experienceBadge; }
    public void setExperienceBadge(String experienceBadge) { this.experienceBadge = experienceBadge; }

    public String getGradesText() { return gradesText; }
    public void setGradesText(String gradesText) { this.gradesText = gradesText; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }
}
