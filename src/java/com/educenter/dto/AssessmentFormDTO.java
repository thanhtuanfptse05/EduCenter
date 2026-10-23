package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public class AssessmentFormDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long classId;
    private String title;
    private String assessmentType = "15_MIN"; // 15_MIN, 1_PERIOD, MID_TERM, FINAL, ENTRANCE, TRIAL
    private BigDecimal maxScore = new BigDecimal("10.00");
    private BigDecimal weight = new BigDecimal("1.00");
    private LocalDate testDate = LocalDate.now();

    public AssessmentFormDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getAssessmentType() { return assessmentType; }
    public void setAssessmentType(String assessmentType) { this.assessmentType = assessmentType; }

    public BigDecimal getMaxScore() { return maxScore; }
    public void setMaxScore(BigDecimal maxScore) { this.maxScore = maxScore; }

    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }

    public LocalDate getTestDate() { return testDate; }
    public void setTestDate(LocalDate testDate) { this.testDate = testDate; }
}
