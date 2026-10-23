package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * DTO representing an individual class session in Student/Parent schedule.
 */
public class PortalScheduleItemDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long sessionId;
    private Long classId;
    private String classCode;
    private String className;
    private String subjectName;
    private String teacherName;
    private String roomName;
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String status; // SCHEDULED, COMPLETED, CANCELLED
    private String notes;

    public PortalScheduleItemDTO() {}

    public Long getSessionId() { return sessionId; }
    public void setSessionId(Long sessionId) { this.sessionId = sessionId; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public LocalDate getSessionDate() { return sessionDate; }
    public void setSessionDate(LocalDate sessionDate) { this.sessionDate = sessionDate; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getFormattedDate() {
        if (sessionDate == null) return "";
        return sessionDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public String getDayOfWeekVi() {
        if (sessionDate == null) return "";
        return switch (sessionDate.getDayOfWeek()) {
            case MONDAY -> "Thứ 2";
            case TUESDAY -> "Thứ 3";
            case WEDNESDAY -> "Thứ 4";
            case THURSDAY -> "Thứ 5";
            case FRIDAY -> "Thứ 6";
            case SATURDAY -> "Thứ 7";
            case SUNDAY -> "Chủ nhật";
        };
    }

    public String getTimeRange() {
        if (startTime == null || endTime == null) return "";
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("HH:mm");
        return startTime.format(fmt) + " - " + endTime.format(fmt);
    }
}
