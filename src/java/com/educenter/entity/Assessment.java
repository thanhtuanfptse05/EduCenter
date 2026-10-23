package com.educenter.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "Assessments")
public class Assessment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id", nullable = false)
    private EduClass eduClass;

    @Column(name = "title", length = 200, nullable = false)
    private String title;

    @Column(name = "assessment_type", length = 30, nullable = false)
    private String assessmentType; // ENTRANCE, 15_MIN, 1_PERIOD, MID_TERM, FINAL, TRIAL

    @Column(name = "max_score", precision = 5, scale = 2, nullable = false)
    private BigDecimal maxScore = new BigDecimal("10.00");

    @Column(name = "weight", precision = 4, scale = 2, nullable = false)
    private BigDecimal weight = new BigDecimal("1.00");

    @Column(name = "test_date", nullable = false)
    private LocalDate testDate;

    @Column(name = "status", length = 20, nullable = false)
    private String status = "DRAFT"; // DRAFT, PUBLISHED

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    public Assessment() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public EduClass getEduClass() { return eduClass; }
    public void setEduClass(EduClass eduClass) { this.eduClass = eduClass; }

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

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
