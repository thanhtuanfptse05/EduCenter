package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class CartItemDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long courseId;
    private String courseCode;
    private String courseName;
    private String subjectName;
    private String subjectCode;
    private Integer gradeLevel;
    private BigDecimal fee = BigDecimal.ZERO;
    private String formattedFee;
    private Integer totalSessions;
    private Integer maxCapacity;
    private boolean available;
    private String teacherName;
    private String imageUrl;
    private String notes;
    private Long selectedClassId;
    private String selectedClassCode;

    public CartItemDTO() {}

    public boolean isAvailable() { return available; }
    public void setAvailable(boolean available) { this.available = available; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) {
        this.fee = (fee != null) ? fee : BigDecimal.ZERO;
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat df = new DecimalFormat("#,###", symbols);
        this.formattedFee = df.format(this.fee) + " đ";
    }

    public String getFormattedFee() { return formattedFee; }
    public void setFormattedFee(String formattedFee) { this.formattedFee = formattedFee; }

    public Integer getTotalSessions() { return totalSessions; }
    public void setTotalSessions(Integer totalSessions) { this.totalSessions = totalSessions; }

    public Integer getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(Integer maxCapacity) { this.maxCapacity = maxCapacity; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Long getSelectedClassId() { return selectedClassId; }
    public void setSelectedClassId(Long selectedClassId) { this.selectedClassId = selectedClassId; }

    public String getSelectedClassCode() { return selectedClassCode; }
    public void setSelectedClassCode(String selectedClassCode) { this.selectedClassCode = selectedClassCode; }
}
