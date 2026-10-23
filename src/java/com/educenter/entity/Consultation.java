package com.educenter.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "Consultations")
public class Consultation implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lead_id", nullable = false)
    private Lead lead;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "staff_id", nullable = false)
    private User staff;

    @Column(name = "notes", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String notes;

    @Column(name = "contacted_at", nullable = false)
    private LocalDateTime contactedAt = LocalDateTime.now();

    @Column(name = "next_appointment")
    private LocalDateTime nextAppointment;

    public Consultation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Lead getLead() { return lead; }
    public void setLead(Lead lead) { this.lead = lead; }

    public User getStaff() { return staff; }
    public void setStaff(User staff) { this.staff = staff; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getContactedAt() { return contactedAt; }
    public void setContactedAt(LocalDateTime contactedAt) { this.contactedAt = contactedAt; }

    public LocalDateTime getNextAppointment() { return nextAppointment; }
    public void setNextAppointment(LocalDateTime nextAppointment) { this.nextAppointment = nextAppointment; }
}
