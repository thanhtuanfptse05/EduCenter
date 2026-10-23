package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ClassDetailDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private Long courseId;
    private String courseName;
    private String courseCode;
    private String subjectName;
    private Integer totalCourseSessions;
    private Long teacherId;
    private String teacherName;
    private String teacherEmail;
    private String teacherPhone;
    private Long roomId;
    private String roomName;
    private String roomCode;
    private Integer roomCapacity;
    private Integer capacity;
    private Long enrolledCount = 0L;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;
    private Long version;
    private List<ClassSessionDTO> sessions = new ArrayList<>();

    public ClassDetailDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getCourseCode() { return courseCode; }
    public void setCourseCode(String courseCode) { this.courseCode = courseCode; }

    public String getSubjectName() { return subjectName; }
    public void setSubjectName(String subjectName) { this.subjectName = subjectName; }

    public Integer getTotalCourseSessions() { return totalCourseSessions; }
    public void setTotalCourseSessions(Integer totalCourseSessions) { this.totalCourseSessions = totalCourseSessions; }

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public String getTeacherEmail() { return teacherEmail; }
    public void setTeacherEmail(String teacherEmail) { this.teacherEmail = teacherEmail; }

    public String getTeacherPhone() { return teacherPhone; }
    public void setTeacherPhone(String teacherPhone) { this.teacherPhone = teacherPhone; }

    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getRoomCode() { return roomCode; }
    public void setRoomCode(String roomCode) { this.roomCode = roomCode; }

    public Integer getRoomCapacity() { return roomCapacity; }
    public void setRoomCapacity(Integer roomCapacity) { this.roomCapacity = roomCapacity; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public Long getEnrolledCount() { return enrolledCount != null ? enrolledCount : 0L; }
    public void setEnrolledCount(Long enrolledCount) { this.enrolledCount = enrolledCount; }

    public int getRemainingSlots() {
        int cap = capacity != null ? capacity : 0;
        int enr = enrolledCount != null ? enrolledCount.intValue() : 0;
        return Math.max(0, cap - enr);
    }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getFormattedStartDate() {
        if (startDate == null) return "Chưa xác định";
        return startDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getFormattedEndDate() {
        if (endDate == null) return "Chưa xác định";
        return endDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getVersion() { return version; }
    public void setVersion(Long version) { this.version = version; }

    public List<ClassSessionDTO> getSessions() { return sessions; }
    public void setSessions(List<ClassSessionDTO> sessions) { this.sessions = sessions; }
}
