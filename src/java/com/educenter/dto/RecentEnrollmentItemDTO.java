package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class RecentEnrollmentItemDTO implements Serializable {

    private String studentName;
    private String className;
    private String courseName;
    private LocalDateTime enrolledAt;
    private String status;

    public RecentEnrollmentItemDTO() {}

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public LocalDateTime getEnrolledAt() { return enrolledAt; }
    public void setEnrolledAt(LocalDateTime enrolledAt) { this.enrolledAt = enrolledAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
