package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class InvoicePageDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<InvoiceViewDTO> items = new ArrayList<>();
    private int currentPage = 1;
    private int pageSize = 10;
    private long totalItems = 0;
    private int totalPages = 1;

    private BigDecimal totalAmountSum = BigDecimal.ZERO;
    private BigDecimal totalPaidSum = BigDecimal.ZERO;
    private BigDecimal totalDebtSum = BigDecimal.ZERO;
    private long overdueCount = 0;

    public InvoicePageDTO() {}

    public List<InvoiceViewDTO> getItems() { return items; }
    public void setItems(List<InvoiceViewDTO> items) { this.items = items; }

    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }

    public long getTotalItems() { return totalItems; }
    public void setTotalItems(long totalItems) { this.totalItems = totalItems; }

    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }

    public BigDecimal getTotalAmountSum() { return totalAmountSum; }
    public void setTotalAmountSum(BigDecimal totalAmountSum) { this.totalAmountSum = totalAmountSum; }

    public BigDecimal getTotalPaidSum() { return totalPaidSum; }
    public void setTotalPaidSum(BigDecimal totalPaidSum) { this.totalPaidSum = totalPaidSum; }

    public BigDecimal getTotalDebtSum() { return totalDebtSum; }
    public void setTotalDebtSum(BigDecimal totalDebtSum) { this.totalDebtSum = totalDebtSum; }

    public long getOverdueCount() { return overdueCount; }
    public void setOverdueCount(long overdueCount) { this.overdueCount = overdueCount; }
}
