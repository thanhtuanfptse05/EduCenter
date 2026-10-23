package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class CourseFormDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long subjectId;
    private String code;
    private String name;
    private Integer gradeLevel;
    private String targetExam;
    private BigDecimal fee = BigDecimal.ZERO;
    private Integer durationWeeks = 12;
    private Integer totalSessions = 24;
    private Integer maxCapacity = 15;
    private String description;
    private String imageUrl;
    private Boolean isFeatured = false;
    private String status = "OPEN";

    public CourseFormDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getTargetExam() { return targetExam; }
    public void setTargetExam(String targetExam) { this.targetExam = targetExam; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }

    public Integer getDurationWeeks() { return durationWeeks; }
    public void setDurationWeeks(Integer durationWeeks) { this.durationWeeks = durationWeeks; }

    public Integer getTotalSessions() { return totalSessions; }
    public void setTotalSessions(Integer totalSessions) { this.totalSessions = totalSessions; }

    public Integer getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(Integer maxCapacity) { this.maxCapacity = maxCapacity; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Boolean getIsFeatured() { return isFeatured; }
    public void setIsFeatured(Boolean isFeatured) { this.isFeatured = isFeatured; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
