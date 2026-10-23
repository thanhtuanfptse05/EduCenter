package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;

public class ClassAdminViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private Long courseId;
    private String courseName;
    private String courseCode;
    private Long teacherId;
    private String teacherName;
    private Long roomId;
    private String roomName;
    private Integer capacity;
    private Long enrolledCount = 0L;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;

    public ClassAdminViewDTO() {}

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

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

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

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
