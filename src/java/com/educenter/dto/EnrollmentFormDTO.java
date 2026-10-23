package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;

public class EnrollmentFormDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long studentId;
    private Long classId;
    private LocalDate startDate;
    private String notes;

    public EnrollmentFormDTO() {}

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
