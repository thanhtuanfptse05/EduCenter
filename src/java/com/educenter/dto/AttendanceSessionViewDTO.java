package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AttendanceSessionViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long sessionId;
    private Long classId;
    private String classCode;
    private String className;
    private String subjectName;
    private Long teacherId;
    private String teacherName;
    private String roomName;
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String sessionStatus; // SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED

    // Thống kê sĩ số & điểm danh
    private int totalStudents;
    private int presentCount;
    private int lateCount;
    private int excusedCount;
    private int unexcusedCount;
    private int unrecordedCount;

    // Journal flag
    private boolean hasJournal;
    private TeachingJournalDTO journal;

    private List<AttendanceRosterItemDTO> roster = new ArrayList<>();

    public AttendanceSessionViewDTO() {}

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

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

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

    public String getSessionStatus() { return sessionStatus; }
    public void setSessionStatus(String sessionStatus) { this.sessionStatus = sessionStatus; }

    public int getTotalStudents() { return totalStudents; }
    public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }

    public int getPresentCount() { return presentCount; }
    public void setPresentCount(int presentCount) { this.presentCount = presentCount; }

    public int getLateCount() { return lateCount; }
    public void setLateCount(int lateCount) { this.lateCount = lateCount; }

    public int getExcusedCount() { return excusedCount; }
    public void setExcusedCount(int excusedCount) { this.excusedCount = excusedCount; }

    public int getUnexcusedCount() { return unexcusedCount; }
    public void setUnexcusedCount(int unexcusedCount) { this.unexcusedCount = unexcusedCount; }

    public int getUnrecordedCount() { return unrecordedCount; }
    public void setUnrecordedCount(int unrecordedCount) { this.unrecordedCount = unrecordedCount; }

    public boolean isHasJournal() { return hasJournal; }
    public void setHasJournal(boolean hasJournal) { this.hasJournal = hasJournal; }

    public TeachingJournalDTO getJournal() { return journal; }
    public void setJournal(TeachingJournalDTO journal) { this.journal = journal; }

    public List<AttendanceRosterItemDTO> getRoster() { return roster; }
    public void setRoster(List<AttendanceRosterItemDTO> roster) { this.roster = roster; }
}
