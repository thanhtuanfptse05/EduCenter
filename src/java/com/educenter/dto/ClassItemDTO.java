package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;

public class ClassItemDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private String shiftName = "Ca Học Tối";
    private String scheduleText;
    private String roomName;
    private String teacherName;
    private String teacherDegree;
    private Integer capacity;
    private int enrolledCount = 0;
    private LocalDate startDate;
    private String status = "OPEN";

    public ClassItemDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getShiftName() { return shiftName; }
    public void setShiftName(String shiftName) { this.shiftName = shiftName; }

    public String getScheduleText() { return scheduleText; }
    public void setScheduleText(String scheduleText) { this.scheduleText = scheduleText; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }

    public String getTeacherDegree() { return teacherDegree; }
    public void setTeacherDegree(String teacherDegree) { this.teacherDegree = teacherDegree; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public int getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(int enrolledCount) { this.enrolledCount = enrolledCount; }

    public int getRemainingSlots() {
        int cap = (capacity != null) ? capacity : 0;
        return Math.max(0, cap - enrolledCount);
    }

    public int getPercentFilled() {
        int cap = (capacity != null && capacity > 0) ? capacity : 1;
        return Math.min(100, (int) Math.round(((double) enrolledCount / cap) * 100));
    }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
