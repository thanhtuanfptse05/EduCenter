package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

public class DetailedReportDTO implements Serializable {

    private LocalDate fromDate;
    private LocalDate toDate;

    // 1. Finance Aggregates (SUM, COUNT)
    private BigDecimal totalRevenue = BigDecimal.ZERO;
    private BigDecimal totalInvoiced = BigDecimal.ZERO;
    private BigDecimal outstandingDebt = BigDecimal.ZERO;
    private long paymentCount;
    private Map<String, BigDecimal> revenueByMethod = new HashMap<>();

    // 2. Course Fee Aggregates (MIN, MAX, AVG)
    private BigDecimal minCourseFee = BigDecimal.ZERO;
    private BigDecimal maxCourseFee = BigDecimal.ZERO;
    private BigDecimal avgCourseFee = BigDecimal.ZERO;

    // 3. Class Capacity Aggregates (MIN, MAX, AVG, COUNT)
    private long totalClassesCount;
    private int minClassCapacity;
    private int maxClassCapacity;
    private double avgClassCapacity;

    // 4. Attendance Aggregates
    private long totalAttendances;
    private long presentCount;
    private long lateCount;
    private long excusedCount;
    private long unexcusedCount;
    private double attendanceRate;

    // 5. Assessment Score Aggregates (MIN, MAX, AVG, COUNT)
    private long totalScoresCount;
    private BigDecimal minScore = BigDecimal.ZERO;
    private BigDecimal maxScore = BigDecimal.ZERO;
    private BigDecimal avgScore = BigDecimal.ZERO;

    // 6. CRM & Admissions (COUNT, Rate)
    private long totalLeads;
    private long enrolledLeads;
    private double leadConversionRate;

    public DetailedReportDTO() {}

    public LocalDate getFromDate() { return fromDate; }
    public void setFromDate(LocalDate fromDate) { this.fromDate = fromDate; }

    public LocalDate getToDate() { return toDate; }
    public void setToDate(LocalDate toDate) { this.toDate = toDate; }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

    public BigDecimal getTotalInvoiced() { return totalInvoiced; }
    public void setTotalInvoiced(BigDecimal totalInvoiced) { this.totalInvoiced = totalInvoiced; }

    public BigDecimal getOutstandingDebt() { return outstandingDebt; }
    public void setOutstandingDebt(BigDecimal outstandingDebt) { this.outstandingDebt = outstandingDebt; }

    public long getPaymentCount() { return paymentCount; }
    public void setPaymentCount(long paymentCount) { this.paymentCount = paymentCount; }

    public Map<String, BigDecimal> getRevenueByMethod() { return revenueByMethod; }
    public void setRevenueByMethod(Map<String, BigDecimal> revenueByMethod) { this.revenueByMethod = revenueByMethod; }

    public BigDecimal getMinCourseFee() { return minCourseFee; }
    public void setMinCourseFee(BigDecimal minCourseFee) { this.minCourseFee = minCourseFee; }

    public BigDecimal getMaxCourseFee() { return maxCourseFee; }
    public void setMaxCourseFee(BigDecimal maxCourseFee) { this.maxCourseFee = maxCourseFee; }

    public BigDecimal getAvgCourseFee() { return avgCourseFee; }
    public void setAvgCourseFee(BigDecimal avgCourseFee) { this.avgCourseFee = avgCourseFee; }

    public long getTotalClassesCount() { return totalClassesCount; }
    public void setTotalClassesCount(long totalClassesCount) { this.totalClassesCount = totalClassesCount; }

    public int getMinClassCapacity() { return minClassCapacity; }
    public void setMinClassCapacity(int minClassCapacity) { this.minClassCapacity = minClassCapacity; }

    public int getMaxClassCapacity() { return maxClassCapacity; }
    public void setMaxClassCapacity(int maxClassCapacity) { this.maxClassCapacity = maxClassCapacity; }

    public double getAvgClassCapacity() { return avgClassCapacity; }
    public void setAvgClassCapacity(double avgClassCapacity) { this.avgClassCapacity = avgClassCapacity; }

    public long getTotalAttendances() { return totalAttendances; }
    public void setTotalAttendances(long totalAttendances) { this.totalAttendances = totalAttendances; }

    public long getPresentCount() { return presentCount; }
    public void setPresentCount(long presentCount) { this.presentCount = presentCount; }

    public long getLateCount() { return lateCount; }
    public void setLateCount(long lateCount) { this.lateCount = lateCount; }

    public long getExcusedCount() { return excusedCount; }
    public void setExcusedCount(long excusedCount) { this.excusedCount = excusedCount; }

    public long getUnexcusedCount() { return unexcusedCount; }
    public void setUnexcusedCount(long unexcusedCount) { this.unexcusedCount = unexcusedCount; }

    public double getAttendanceRate() { return attendanceRate; }
    public void setAttendanceRate(double attendanceRate) { this.attendanceRate = attendanceRate; }

    public long getTotalScoresCount() { return totalScoresCount; }
    public void setTotalScoresCount(long totalScoresCount) { this.totalScoresCount = totalScoresCount; }

    public BigDecimal getMinScore() { return minScore; }
    public void setMinScore(BigDecimal minScore) { this.minScore = minScore; }

    public BigDecimal getMaxScore() { return maxScore; }
    public void setMaxScore(BigDecimal maxScore) { this.maxScore = maxScore; }

    public BigDecimal getAvgScore() { return avgScore; }
    public void setAvgScore(BigDecimal avgScore) { this.avgScore = avgScore; }

    public long getTotalLeads() { return totalLeads; }
    public void setTotalLeads(long totalLeads) { this.totalLeads = totalLeads; }

    public long getEnrolledLeads() { return enrolledLeads; }
    public void setEnrolledLeads(long enrolledLeads) { this.enrolledLeads = enrolledLeads; }

    public double getLeadConversionRate() { return leadConversionRate; }
    public void setLeadConversionRate(double leadConversionRate) { this.leadConversionRate = leadConversionRate; }
}
