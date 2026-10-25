package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;

public class EnrollmentFormDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long studentId;
    private Long courseId;
    private Long classId;
    private LocalDate startDate;
    private String notes;

    // FR-014: Mandatory tuition payment fields
    private Boolean paymentConfirmed = false;
    private String paymentMethod; // CASH, BANK_TRANSFER
    private String transactionRef;
    private java.math.BigDecimal paymentAmount;

    public EnrollmentFormDTO() {}

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Boolean getPaymentConfirmed() { return paymentConfirmed; }
    public boolean isPaymentConfirmed() { return Boolean.TRUE.equals(paymentConfirmed); }
    public void setPaymentConfirmed(Boolean paymentConfirmed) { this.paymentConfirmed = paymentConfirmed; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public java.math.BigDecimal getPaymentAmount() { return paymentAmount; }
    public void setPaymentAmount(java.math.BigDecimal paymentAmount) { this.paymentAmount = paymentAmount; }
}
