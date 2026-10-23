package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ScheduleGeneratorDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long classId;
    private Long roomId;
    private Long teacherId;
    private List<Integer> daysOfWeek = new ArrayList<>(); // 2=T2, 3=T3, 4=T4, 5=T5, 6=T6, 7=T7, 8=CN
    private LocalTime startAt;
    private LocalTime endAt;
    private LocalDate startDate;
    private Integer totalSessions = 10;
    private List<LocalDate> excludeDates = new ArrayList<>();

    public ScheduleGeneratorDTO() {}

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

    public List<Integer> getDaysOfWeek() { return daysOfWeek; }
    public void setDaysOfWeek(List<Integer> daysOfWeek) { this.daysOfWeek = daysOfWeek; }

    public LocalTime getStartAt() { return startAt; }
    public void setStartAt(LocalTime startAt) { this.startAt = startAt; }

    public LocalTime getEndAt() { return endAt; }
    public void setEndAt(LocalTime endAt) { this.endAt = endAt; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public Integer getTotalSessions() { return totalSessions; }
    public void setTotalSessions(Integer totalSessions) { this.totalSessions = totalSessions; }

    public List<LocalDate> getExcludeDates() { return excludeDates; }
    public void setExcludeDates(List<LocalDate> excludeDates) { this.excludeDates = excludeDates; }
}
