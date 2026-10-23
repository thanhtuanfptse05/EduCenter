package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class StudentScoreItemDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long studentId;
    private String studentCode;
    private String studentName;
    private String studentPhone;
    private BigDecimal score;
    private String remarks;
    private Long scoreId;

    public StudentScoreItemDTO() {}

    public StudentScoreItemDTO(Long studentId, String studentCode, String studentName, String studentPhone, BigDecimal score, String remarks) {
        this.studentId = studentId;
        this.studentCode = studentCode;
        this.studentName = studentName;
        this.studentPhone = studentPhone;
        this.score = score;
        this.remarks = remarks;
    }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }

    public BigDecimal getScore() { return score; }
    public void setScore(BigDecimal score) { this.score = score; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public Long getScoreId() { return scoreId; }
    public void setScoreId(Long scoreId) { this.scoreId = scoreId; }
}
