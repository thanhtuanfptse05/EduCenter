package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO providing comprehensive summary for Student Dashboard (STD-01).
 */
public class StudentDashboardSummaryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long studentId;
    private String studentName;
    private String studentCode;
    private Integer gradeLevel;
    private String school;
    private int enrolledClassCount;
    private BigDecimal averageScore;
    private PortalAttendanceSummaryDTO attendanceSummary;
    private List<PortalScheduleItemDTO> upcomingSessions = new ArrayList<>();
    private List<PortalScoreItemDTO> recentScores = new ArrayList<>();
    private List<ClassItemDTO> enrolledClasses = new ArrayList<>();

    public StudentDashboardSummaryDTO() {}

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getSchool() { return school; }
    public void setSchool(String school) { this.school = school; }

    public int getEnrolledClassCount() { return enrolledClassCount; }
    public void setEnrolledClassCount(int enrolledClassCount) { this.enrolledClassCount = enrolledClassCount; }

    public BigDecimal getAverageScore() { return averageScore; }
    public void setAverageScore(BigDecimal averageScore) { this.averageScore = averageScore; }

    public PortalAttendanceSummaryDTO getAttendanceSummary() { return attendanceSummary; }
    public void setAttendanceSummary(PortalAttendanceSummaryDTO attendanceSummary) { this.attendanceSummary = attendanceSummary; }

    public List<PortalScheduleItemDTO> getUpcomingSessions() { return upcomingSessions; }
    public void setUpcomingSessions(List<PortalScheduleItemDTO> upcomingSessions) { this.upcomingSessions = upcomingSessions; }

    public List<PortalScoreItemDTO> getRecentScores() { return recentScores; }
    public void setRecentScores(List<PortalScoreItemDTO> recentScores) { this.recentScores = recentScores; }

    public List<ClassItemDTO> getEnrolledClasses() { return enrolledClasses; }
    public void setEnrolledClasses(List<ClassItemDTO> enrolledClasses) { this.enrolledClasses = enrolledClasses; }
}
