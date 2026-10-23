package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class ClassSessionDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long classId;
    private String className;
    private String classCode;
    private Long roomId;
    private String roomName;
    private String roomCode;
    private Long teacherId;
    private String teacherName;
    private LocalDate sessionDate;
    private LocalTime startAt;
    private LocalTime endAt;
    private String title;
    private String status;

    public ClassSessionDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getClassName() { return className; }
    public void setClassName(String className) { this.className = className; }

    public String getClassCode() { return classCode; }
    public void setClassCode(String classCode) { this.classCode = classCode; }

    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getRoomCode() { return roomCode; }
    public void setRoomCode(String roomCode) { this.roomCode = roomCode; }

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public LocalDate getSessionDate() { return sessionDate; }
    public void setSessionDate(LocalDate sessionDate) { this.sessionDate = sessionDate; }

    public LocalTime getStartAt() { return startAt; }
    public void setStartAt(LocalTime startAt) { this.startAt = startAt; }

    public LocalTime getEndAt() { return endAt; }
    public void setEndAt(LocalTime endAt) { this.endAt = endAt; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFormattedTime() {
        if (startAt == null || endAt == null) return "";
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm");
        return startAt.format(dtf) + " - " + endAt.format(dtf);
    }
}
