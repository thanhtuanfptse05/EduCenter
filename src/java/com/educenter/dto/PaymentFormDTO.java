package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class PaymentFormDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long invoiceId;
    private BigDecimal amount;
    private String paymentMethod; // CASH, BANK_TRANSFER
    private String transactionRef;
    private String notes;

    public PaymentFormDTO() {}

    public Long getInvoiceId() { return invoiceId; }
    public void setInvoiceId(Long invoiceId) { this.invoiceId = invoiceId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
