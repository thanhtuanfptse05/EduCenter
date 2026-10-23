package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PaymentRecordDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String paymentCode;
    private BigDecimal amount = BigDecimal.ZERO;
    private String paymentMethod; // CASH, BANK_TRANSFER
    private String transactionRef;
    private LocalDateTime paidAt;
    private Long confirmedById;
    private String confirmedByName;
    private String notes;
    private String status; // CONFIRMED, CANCELLED, REFUNDED

    public PaymentRecordDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getPaymentCode() { return paymentCode; }
    public void setPaymentCode(String paymentCode) { this.paymentCode = paymentCode; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }

    public Long getConfirmedById() { return confirmedById; }
    public void setConfirmedById(Long confirmedById) { this.confirmedById = confirmedById; }

    public String getConfirmedByName() { return confirmedByName; }
    public void setConfirmedByName(String confirmedByName) { this.confirmedByName = confirmedByName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
