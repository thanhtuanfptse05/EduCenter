package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class InvoiceItemViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String description;
    private String itemType;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private Integer quantity = 1;
    private BigDecimal amount = BigDecimal.ZERO;

    public InvoiceItemViewDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
}
