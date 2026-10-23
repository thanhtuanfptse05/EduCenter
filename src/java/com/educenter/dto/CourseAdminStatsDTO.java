package com.educenter.dto;

import java.io.Serializable;

public class CourseAdminStatsDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private long totalCourses;
    private long openCourses;
    private long closedCourses;
    private long archivedCourses;
    private long totalSubjects;
    private long activeSubjects;

    public CourseAdminStatsDTO() {}

    public CourseAdminStatsDTO(long totalCourses, long openCourses, long closedCourses, long archivedCourses, long totalSubjects, long activeSubjects) {
        this.totalCourses = totalCourses;
        this.openCourses = openCourses;
        this.closedCourses = closedCourses;
        this.archivedCourses = archivedCourses;
        this.totalSubjects = totalSubjects;
        this.activeSubjects = activeSubjects;
    }

    public long getTotalCourses() { return totalCourses; }
    public void setTotalCourses(long totalCourses) { this.totalCourses = totalCourses; }

    public long getOpenCourses() { return openCourses; }
    public void setOpenCourses(long openCourses) { this.openCourses = openCourses; }

    public long getClosedCourses() { return closedCourses; }
    public void setClosedCourses(long closedCourses) { this.closedCourses = closedCourses; }

    public long getArchivedCourses() { return archivedCourses; }
    public void setArchivedCourses(long archivedCourses) { this.archivedCourses = archivedCourses; }

    public long getTotalSubjects() { return totalSubjects; }
    public void setTotalSubjects(long totalSubjects) { this.totalSubjects = totalSubjects; }

    public long getActiveSubjects() { return activeSubjects; }
    public void setActiveSubjects(long activeSubjects) { this.activeSubjects = activeSubjects; }
}
