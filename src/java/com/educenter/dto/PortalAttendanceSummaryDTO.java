package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * DTO summarizing attendance metrics for Student/Parent portal.
 */
public class PortalAttendanceSummaryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private int totalSessions;
    private int attendedSessions; // PRESENT
    private int lateSessions;     // LATE
    private int excusedSessions;  // ABSENT_EXCUSED
    private int unexcusedSessions;// ABSENT_UNEXCUSED

    public PortalAttendanceSummaryDTO() {}

    public PortalAttendanceSummaryDTO(int totalSessions, int attendedSessions, int lateSessions,
                                      int excusedSessions, int unexcusedSessions) {
        this.totalSessions = totalSessions;
        this.attendedSessions = attendedSessions;
        this.lateSessions = lateSessions;
        this.excusedSessions = excusedSessions;
        this.unexcusedSessions = unexcusedSessions;
    }

    public int getTotalSessions() { return totalSessions; }
    public void setTotalSessions(int totalSessions) { this.totalSessions = totalSessions; }

    public int getAttendedSessions() { return attendedSessions; }
    public void setAttendedSessions(int attendedSessions) { this.attendedSessions = attendedSessions; }

    public int getLateSessions() { return lateSessions; }
    public void setLateSessions(int lateSessions) { this.lateSessions = lateSessions; }

    public int getExcusedSessions() { return excusedSessions; }
    public void setExcusedSessions(int excusedSessions) { this.excusedSessions = excusedSessions; }

    public int getUnexcusedSessions() { return unexcusedSessions; }
    public void setUnexcusedSessions(int unexcusedSessions) { this.unexcusedSessions = unexcusedSessions; }

    public BigDecimal getAttendanceRate() {
        if (totalSessions <= 0) return BigDecimal.ZERO;
        // Đi học đầy đủ và muộn tính là có mặt (hoặc tính tỷ lệ chuyên cần)
        BigDecimal attended = BigDecimal.valueOf(attendedSessions + lateSessions);
        return attended.multiply(BigDecimal.valueOf(100))
                .divide(BigDecimal.valueOf(totalSessions), 1, RoundingMode.HALF_UP);
    }

    public String getAttendanceRateFormatted() {
        if (totalSessions <= 0) return "N/A";
        return getAttendanceRate().toPlainString() + "%";
    }
}
