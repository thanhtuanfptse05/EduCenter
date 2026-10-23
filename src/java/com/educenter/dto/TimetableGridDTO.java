package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class TimetableGridDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private LocalDate weekStartDate;
    private LocalDate weekEndDate;
    private List<LocalDate> daysOfWeek = new ArrayList<>();
    private List<ClassSessionDTO> sessions = new ArrayList<>();

    public TimetableGridDTO() {}

    public TimetableGridDTO(LocalDate weekStartDate, LocalDate weekEndDate) {
        this.weekStartDate = weekStartDate;
        this.weekEndDate = weekEndDate;
        if (weekStartDate != null) {
            for (int i = 0; i < 7; i++) {
                this.daysOfWeek.add(weekStartDate.plusDays(i));
            }
        }
    }

    public LocalDate getWeekStartDate() { return weekStartDate; }
    public void setWeekStartDate(LocalDate weekStartDate) { this.weekStartDate = weekStartDate; }

    public LocalDate getWeekEndDate() { return weekEndDate; }
    public void setWeekEndDate(LocalDate weekEndDate) { this.weekEndDate = weekEndDate; }

    public List<LocalDate> getDaysOfWeek() { return daysOfWeek; }
    public void setDaysOfWeek(List<LocalDate> daysOfWeek) { this.daysOfWeek = daysOfWeek; }

    public List<ClassSessionDTO> getSessions() { return sessions; }
    public void setSessions(List<ClassSessionDTO> sessions) { this.sessions = sessions; }

    public List<ClassSessionDTO> getSessionsForDate(LocalDate date) {
        List<ClassSessionDTO> result = new ArrayList<>();
        if (date == null || sessions == null) return result;
        for (ClassSessionDTO s : sessions) {
            if (date.equals(s.getSessionDate())) {
                result.add(s);
            }
        }
        return result;
    }

    public String formatDay(LocalDate date) {
        if (date == null) return "";
        return date.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}
