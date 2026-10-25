package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public class ClassEnrollmentOptionDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long classId;
    private String classCode;
    private String className;
    private Long courseId;
    private String courseCode;
    private String courseName;
    private String subjectName;
    private int currentEnrolled;
    private int capacity;
    private BigDecimal fee;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private boolean hasScheduleConflict;
    private String conflictReason;

    public ClassEnrollmentOptionDTO() {}

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

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

    public boolean isHasScheduleConflict() { return hasScheduleConflict; }
    public void setHasScheduleConflict(boolean hasScheduleConflict) { this.hasScheduleConflict = hasScheduleConflict; }

    public String getConflictReason() { return conflictReason; }
    public void setConflictReason(String conflictReason) { this.conflictReason = conflictReason; }

    public boolean isFull() {
        return currentEnrolled >= capacity;
    }
}
