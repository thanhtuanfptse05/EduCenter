package com.educenter.dto;

import java.io.Serializable;

public class StudentStatsDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private long totalStudents;
    private long studyingStudents;
    private long reservedStudents;
    private long graduatedStudents;
    private long droppedStudents;

    public StudentStatsDTO() {}

    public StudentStatsDTO(long totalStudents, long studyingStudents, long reservedStudents, long graduatedStudents, long droppedStudents) {
        this.totalStudents = totalStudents;
        this.studyingStudents = studyingStudents;
        this.reservedStudents = reservedStudents;
        this.graduatedStudents = graduatedStudents;
        this.droppedStudents = droppedStudents;
    }

    public long getTotalStudents() { return totalStudents; }
    public void setTotalStudents(long totalStudents) { this.totalStudents = totalStudents; }

    public long getStudyingStudents() { return studyingStudents; }
    public void setStudyingStudents(long studyingStudents) { this.studyingStudents = studyingStudents; }

    public long getReservedStudents() { return reservedStudents; }
    public void setReservedStudents(long reservedStudents) { this.reservedStudents = reservedStudents; }

    public long getGraduatedStudents() { return graduatedStudents; }
    public void setGraduatedStudents(long graduatedStudents) { this.graduatedStudents = graduatedStudents; }

    public long getDroppedStudents() { return droppedStudents; }
    public void setDroppedStudents(long droppedStudents) { this.droppedStudents = droppedStudents; }

    public long getStudyingCount() { return studyingStudents; }
    public long getReservedCount() { return reservedStudents; }
    public long getGraduatedCount() { return graduatedStudents; }
    public long getDroppedCount() { return droppedStudents; }
    public long getTotalCount() { return totalStudents; }
}
