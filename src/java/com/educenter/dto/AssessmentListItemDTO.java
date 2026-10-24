package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class AssessmentListItemDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long classId;
    private String classCode;
    private String className;
    private String title;
    private String assessmentType; // 15_MIN, 1_PERIOD, MID_TERM, FINAL, ENTRANCE, TRIAL
    private BigDecimal maxScore = new BigDecimal("10.00");
    private BigDecimal weight = new BigDecimal("1.00");
    private LocalDate testDate;
    private String status; // DRAFT, PUBLISHED
    private int gradedCount;
    private int totalStudents;
    private BigDecimal averageScore;
    private LocalDateTime createdAt;

    public AssessmentListItemDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getName() { return title; }
    public void setName(String name) { this.title = name; }

    public String getAssessmentType() { return assessmentType; }
    public void setAssessmentType(String assessmentType) { this.assessmentType = assessmentType; }

    public BigDecimal getMaxScore() { return maxScore; }
    public void setMaxScore(BigDecimal maxScore) { this.maxScore = maxScore; }

    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }

    public LocalDate getTestDate() { return testDate; }
    public void setTestDate(LocalDate testDate) { this.testDate = testDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getGradedCount() { return gradedCount; }
    public void setGradedCount(int gradedCount) { this.gradedCount = gradedCount; }

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }

    public BigDecimal getAverageScore() { return averageScore; }
    public void setAverageScore(BigDecimal averageScore) { this.averageScore = averageScore; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
