package com.educenter.dto;

import java.io.Serializable;

public class ClassAdminStatsDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private long totalClasses = 0;
    private long openClasses = 0;
    private long ongoingClasses = 0;
    private long closedClasses = 0;
    private long totalRooms = 0;
    private long availableRooms = 0;

    public ClassAdminStatsDTO() {}

    public ClassAdminStatsDTO(long totalClasses, long openClasses, long ongoingClasses, long closedClasses, long totalRooms, long availableRooms) {
        this.totalClasses = totalClasses;
        this.openClasses = openClasses;
        this.ongoingClasses = ongoingClasses;
        this.closedClasses = closedClasses;
        this.totalRooms = totalRooms;
        this.availableRooms = availableRooms;
    }

    public long getTotalClasses() { return totalClasses; }
    public void setTotalClasses(long totalClasses) { this.totalClasses = totalClasses; }

    public long getOpenClasses() { return openClasses; }
    public void setOpenClasses(long openClasses) { this.openClasses = openClasses; }

    public long getOngoingClasses() { return ongoingClasses; }
    public void setOngoingClasses(long ongoingClasses) { this.ongoingClasses = ongoingClasses; }

    public long getClosedClasses() { return closedClasses; }
    public void setClosedClasses(long closedClasses) { this.closedClasses = closedClasses; }

    public long getTotalRooms() { return totalRooms; }
    public void setTotalRooms(long totalRooms) { this.totalRooms = totalRooms; }

    public long getAvailableRooms() { return availableRooms; }
    public void setAvailableRooms(long availableRooms) { this.availableRooms = availableRooms; }
}
