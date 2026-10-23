package com.educenter.dto;

import java.io.Serializable;

public class ConsultationFormDTO implements Serializable {

    private Long leadId;
    private String notes;
    private String nextAppointmentStr;

    public ConsultationFormDTO() {}

    public Long getLeadId() { return leadId; }
    public void setLeadId(Long leadId) { this.leadId = leadId; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getNextAppointmentStr() { return nextAppointmentStr; }
    public void setNextAppointmentStr(String nextAppointmentStr) { this.nextAppointmentStr = nextAppointmentStr; }
}
