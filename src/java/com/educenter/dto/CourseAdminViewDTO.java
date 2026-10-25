package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.LocalDateTime;

public class CourseAdminViewDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private Long subjectId;
    private String subjectName;
    private String subjectCode;
    private Integer gradeLevel;
    private String targetExam;
    private BigDecimal fee;
    private Integer durationWeeks;
    private Integer totalSessions;
    private Integer maxCapacity;
    private Boolean isFeatured;
    private String status;
    private long openClassCount;
    private long totalClassCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public CourseAdminViewDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getTargetExam() { return targetExam; }
    public void setTargetExam(String targetExam) { this.targetExam = targetExam; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }

    public BigDecimal getTuitionFee() { return fee; }
    public void setTuitionFee(BigDecimal tuitionFee) { this.fee = tuitionFee; }

    public String getFormattedFee() {
        if (fee == null) return "0 đ";
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(fee) + " đ";
    }

    public Integer getDurationWeeks() { return durationWeeks; }
    public void setDurationWeeks(Integer durationWeeks) { this.durationWeeks = durationWeeks; }

    public Integer getTotalSessions() { return totalSessions; }
    public void setTotalSessions(Integer totalSessions) { this.totalSessions = totalSessions; }

    public Integer getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(Integer maxCapacity) { this.maxCapacity = maxCapacity; }

    public Boolean getIsFeatured() { return isFeatured; }
    public void setIsFeatured(Boolean isFeatured) { this.isFeatured = isFeatured; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public long getOpenClassCount() { return openClassCount; }
    public void setOpenClassCount(long openClassCount) { this.openClassCount = openClassCount; }

    public long getTotalClassCount() { return totalClassCount; }
    public void setTotalClassCount(long totalClassCount) { this.totalClassCount = totalClassCount; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
