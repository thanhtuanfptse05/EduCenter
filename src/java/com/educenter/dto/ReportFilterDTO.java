package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDate;

public class ReportFilterDTO implements Serializable {

    private LocalDate fromDate;
    private LocalDate toDate;
    private String reportType = "ALL";

    public ReportFilterDTO() {}

    public ReportFilterDTO(LocalDate fromDate, LocalDate toDate) {
        this.fromDate = fromDate;
        this.toDate = toDate;
    }

    public LocalDate getFromDate() { return fromDate; }
    public void setFromDate(LocalDate fromDate) { this.fromDate = fromDate; }

    public LocalDate getToDate() { return toDate; }
    public void setToDate(LocalDate toDate) { this.toDate = toDate; }

    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }
}
