package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class CourseDetailDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private CourseCardDTO course;
    private TeacherCardDTO primaryTeacher;
    private List<ClassItemDTO> openClasses = new ArrayList<>();
    private List<CourseCardDTO> relatedCourses = new ArrayList<>();
    private BigDecimal originalFee;
    private BigDecimal discountAmount;

    public CourseDetailDTO() {}

    public CourseCardDTO getCourse() { return course; }
    public void setCourse(CourseCardDTO course) { this.course = course; }

    public TeacherCardDTO getPrimaryTeacher() { return primaryTeacher; }
    public void setPrimaryTeacher(TeacherCardDTO primaryTeacher) { this.primaryTeacher = primaryTeacher; }

    public List<ClassItemDTO> getOpenClasses() { return openClasses; }
    public void setOpenClasses(List<ClassItemDTO> openClasses) {
        this.openClasses = (openClasses != null) ? openClasses : new ArrayList<>();
    }

    public List<CourseCardDTO> getRelatedCourses() { return relatedCourses; }
    public void setRelatedCourses(List<CourseCardDTO> relatedCourses) {
        this.relatedCourses = (relatedCourses != null) ? relatedCourses : new ArrayList<>();
    }

    public BigDecimal getOriginalFee() { return originalFee; }
    public void setOriginalFee(BigDecimal originalFee) { this.originalFee = originalFee; }

    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
}
