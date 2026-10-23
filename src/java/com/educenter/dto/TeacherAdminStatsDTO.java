package com.educenter.dto;

import java.io.Serializable;

public class TeacherAdminStatsDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private long totalTeachers;
    private long activeTeachers;
    private long onLeaveTeachers;
    private long inactiveTeachers;
    private long totalActiveClasses;

    public TeacherAdminStatsDTO() {}

    public TeacherAdminStatsDTO(long totalTeachers, long activeTeachers, long onLeaveTeachers, long inactiveTeachers, long totalActiveClasses) {
        this.totalTeachers = totalTeachers;
        this.activeTeachers = activeTeachers;
        this.onLeaveTeachers = onLeaveTeachers;
        this.inactiveTeachers = inactiveTeachers;
        this.totalActiveClasses = totalActiveClasses;
    }

    public long getTotalTeachers() { return totalTeachers; }
    public void setTotalTeachers(long totalTeachers) { this.totalTeachers = totalTeachers; }

    public long getActiveTeachers() { return activeTeachers; }
    public void setActiveTeachers(long activeTeachers) { this.activeTeachers = activeTeachers; }

    public long getOnLeaveTeachers() { return onLeaveTeachers; }
    public void setOnLeaveTeachers(long onLeaveTeachers) { this.onLeaveTeachers = onLeaveTeachers; }

    public long getInactiveTeachers() { return inactiveTeachers; }
    public void setInactiveTeachers(long inactiveTeachers) { this.inactiveTeachers = inactiveTeachers; }

    public long getTotalActiveClasses() { return totalActiveClasses; }
    public void setTotalActiveClasses(long totalActiveClasses) { this.totalActiveClasses = totalActiveClasses; }
}
