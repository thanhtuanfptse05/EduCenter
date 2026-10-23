package com.educenter.dto;

import java.io.Serializable;

public class LeadSourceStatDTO implements Serializable {

    private String source;
    private long totalLeads;
    private long enrolledCount;
    private double conversionRate;

    public LeadSourceStatDTO() {}

    public LeadSourceStatDTO(String source, long totalLeads, long enrolledCount) {
        this.source = source;
        this.totalLeads = totalLeads;
        this.enrolledCount = enrolledCount;
        this.conversionRate = (totalLeads > 0) ? ((double) enrolledCount / totalLeads) * 100.0 : 0.0;
    }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public long getTotalLeads() { return totalLeads; }
    public void setTotalLeads(long totalLeads) { this.totalLeads = totalLeads; }

    public long getEnrolledCount() { return enrolledCount; }
    public void setEnrolledCount(long enrolledCount) { this.enrolledCount = enrolledCount; }

    public double getConversionRate() { return conversionRate; }
    public void setConversionRate(double conversionRate) { this.conversionRate = conversionRate; }
}
