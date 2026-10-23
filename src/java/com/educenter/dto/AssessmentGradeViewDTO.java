package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class AssessmentGradeViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long assessmentId;
    private String title;
    private String assessmentType;
    private BigDecimal maxScore;
    private BigDecimal weight;
    private LocalDate testDate;
    private String status; // DRAFT, PUBLISHED

    private Long classId;
    private String classCode;
    private String className;
    private String subjectName;

    private List<StudentScoreItemDTO> students = new ArrayList<>();

    private int totalStudents;
    private int gradedCount;
    private BigDecimal averageScore;

    public AssessmentGradeViewDTO() {}

    public Long getAssessmentId() { return assessmentId; }
    public void setAssessmentId(Long assessmentId) { this.assessmentId = assessmentId; }

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

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public List<StudentScoreItemDTO> getStudents() { return students; }
    public void setStudents(List<StudentScoreItemDTO> students) { this.students = students; }

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }

    public int getGradedCount() { return gradedCount; }
    public void setGradedCount(int gradedCount) { this.gradedCount = gradedCount; }

    public BigDecimal getAverageScore() { return averageScore; }
    public void setAverageScore(BigDecimal averageScore) { this.averageScore = averageScore; }
}
