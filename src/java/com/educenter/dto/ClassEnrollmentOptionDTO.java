package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public class ClassEnrollmentOptionDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long classId;
    private String classCode;
    private String className;
    private String courseName;
    private String subjectName;
    private int currentEnrolled;
    private int capacity;
    private BigDecimal fee;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;

    public ClassEnrollmentOptionDTO() {}

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public int getCurrentEnrolled() { return currentEnrolled; }
    public void setCurrentEnrolled(int currentEnrolled) { this.currentEnrolled = currentEnrolled; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public BigDecimal getFee() { return fee; }
    public void setFee(BigDecimal fee) { this.fee = fee; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isFull() {
        return currentEnrolled >= capacity;
    }
}
