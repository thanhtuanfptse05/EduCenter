package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class CourseCardDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private Integer gradeLevel;
    private String targetExam;
    private BigDecimal fee;
    private String formattedFee;
    private Integer durationWeeks;
    private Integer totalSessions;
    private Integer maxCapacity;
    private String description;
    private String imageUrl;
    private Boolean isFeatured = false;
    private String status = "OPEN";
    private String subjectName;
    private String subjectCode;
    private String teacherName;
    private String teacherTitle;
    private String scheduleText;
    private String modelText; // e.g. "Nhóm nhỏ (Tối đa 15 HV)" hoặc "Gia sư 1 kèm 1"
    private int openClassCount = 0;

    public CourseCardDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getTargetExam() { return targetExam; }
    public void setTargetExam(String targetExam) { this.targetExam = targetExam; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) {
        this.fee = fee;
        if (fee != null && fee.compareTo(BigDecimal.ZERO) >= 0) {
            DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
            symbols.setGroupingSeparator('.');
            DecimalFormat df = new DecimalFormat("#,###", symbols);
            this.formattedFee = df.format(fee) + " đ";
        } else {
            this.formattedFee = "Theo lộ trình";
        }
    }

    public String getFormattedFee() { return formattedFee; }
    public void setFormattedFee(String formattedFee) { this.formattedFee = formattedFee; }

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

    public boolean isOpenForRegistration() { return "OPEN".equalsIgnoreCase(status) && fee != null && fee.signum() >= 0; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getSubjectCode() { return subjectCode; }
    public void setSubjectCode(String subjectCode) { this.subjectCode = subjectCode; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public String getTeacherTitle() { return teacherTitle; }
    public void setTeacherTitle(String teacherTitle) { this.teacherTitle = teacherTitle; }

    public String getScheduleText() { return scheduleText; }
    public void setScheduleText(String scheduleText) { this.scheduleText = scheduleText; }

    public String getModelText() { return modelText; }
    public void setModelText(String modelText) { this.modelText = modelText; }

    public int getOpenClassCount() { return openClassCount; }
    public void setOpenClassCount(int openClassCount) { this.openClassCount = openClassCount; }
}
