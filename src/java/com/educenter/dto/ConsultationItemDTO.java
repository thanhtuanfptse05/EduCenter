package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class ConsultationItemDTO implements Serializable {

    private Long id;
    private Long leadId;
    private Long staffId;
    private String staffName;
    private String notes;
    private LocalDateTime contactedAt;
    private LocalDateTime nextAppointment;

    public ConsultationItemDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getLeadId() { return leadId; }
    public void setLeadId(Long leadId) { this.leadId = leadId; }

    public Long getStaffId() { return staffId; }
    public void setStaffId(Long staffId) { this.staffId = staffId; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getContactedAt() { return contactedAt; }
    public void setContactedAt(LocalDateTime contactedAt) { this.contactedAt = contactedAt; }

    public LocalDateTime getNextAppointment() { return nextAppointment; }
    public void setNextAppointment(LocalDateTime nextAppointment) { this.nextAppointment = nextAppointment; }
}
