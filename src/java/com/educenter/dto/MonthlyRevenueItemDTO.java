package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class MonthlyRevenueItemDTO implements Serializable {

    private int month;
    private int year;
    private String label;
    private BigDecimal revenue = BigDecimal.ZERO;
    private long transactionCount;

    public MonthlyRevenueItemDTO() {}

    public MonthlyRevenueItemDTO(int month, int year, BigDecimal revenue, long transactionCount) {
        this.month = month;
        this.year = year;
        this.label = "T" + month + "/" + year;
        this.revenue = (revenue != null) ? revenue : BigDecimal.ZERO;
        this.transactionCount = transactionCount;
    }

    public int getMonth() { return month; }
    public void setMonth(int month) { this.month = month; }

    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public BigDecimal getRevenue() { return revenue; }
    public void setRevenue(BigDecimal revenue) { this.revenue = revenue; }

    public long getTransactionCount() { return transactionCount; }
    public void setTransactionCount(long transactionCount) { this.transactionCount = transactionCount; }
}
