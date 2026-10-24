package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

/**
 * DTO representing an officially published assessment score for Student/Parent portal.
 */
public class PortalScoreItemDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long assessmentId;
    private String assessmentTitle;
    private String assessmentType; // '15_MIN', '1_PERIOD', 'MID_TERM', 'FINAL', 'TRIAL'
    private String subjectName;
    private String classCode;
    private LocalDate assessmentDate;
    private BigDecimal score;
    private BigDecimal maxScore;
    private BigDecimal weight;
    private String remark;

    public PortalScoreItemDTO() {}

    public Long getAssessmentId() { return assessmentId; }
    public void setAssessmentId(Long assessmentId) { this.assessmentId = assessmentId; }

    public String getAssessmentTitle() { return assessmentTitle; }
    public void setAssessmentTitle(String assessmentTitle) { this.assessmentTitle = assessmentTitle; }

    public String getAssessmentType() { return assessmentType; }
    public void setAssessmentType(String assessmentType) { this.assessmentType = assessmentType; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public LocalDate getAssessmentDate() { return assessmentDate; }
    public void setAssessmentDate(LocalDate assessmentDate) { this.assessmentDate = assessmentDate; }

    public BigDecimal getScore() { return score; }
    public void setScore(BigDecimal score) { this.score = score; }

    public BigDecimal getMaxScore() { return maxScore; }
    public void setMaxScore(BigDecimal maxScore) { this.maxScore = maxScore; }

    public BigDecimal getWeight() { return weight; }
    public void setWeight(BigDecimal weight) { this.weight = weight; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getFormattedDate() {
        if (assessmentDate == null) return "";
        return assessmentDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public boolean isPassed() {
        if (score == null) return false;
        return score.compareTo(new BigDecimal("5.0")) >= 0;
    }

    public String getGradeRating() {
        if (score == null) return "Chưa có điểm";
        BigDecimal max = (maxScore != null && maxScore.compareTo(BigDecimal.ZERO) > 0) ? maxScore : BigDecimal.TEN;
        double ratio = score.doubleValue() / max.doubleValue();
        if (ratio >= 0.90) return "Xuất sắc";
        if (ratio >= 0.80) return "Giỏi";
        if (ratio >= 0.65) return "Khá";
        if (ratio >= 0.50) return "Đạt";
        return "Cần cố gắng";
    }

    public String getTypeNameVi() {
        if (assessmentType == null) return "Bài kiểm tra";
        return switch (assessmentType.toUpperCase()) {
            case "15_MIN" -> "Kiểm tra 15 phút";
            case "1_PERIOD" -> "Kiểm tra 1 tiết";
            case "MID_TERM" -> "Giữa kỳ";
            case "FINAL" -> "Cuối kỳ";
            case "TRIAL" -> "Thi thử ĐGNL/TN";
            default -> assessmentType;
        };
    }
}
