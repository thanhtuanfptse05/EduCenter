package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class AdminDashboardDTO implements Serializable {

    // Financial KPIs
    private BigDecimal monthRevenue = BigDecimal.ZERO;
    private BigDecimal totalInvoiced = BigDecimal.ZERO;
    private BigDecimal outstandingDebt = BigDecimal.ZERO;

    // Academic KPIs
    private long activeStudentsCount;
    private long openClassesCount;
    private double attendanceRate;

    // CRM KPIs
    private long newLeadsThisMonth;
    private long enrolledLeadsCount;
    private double leadConversionRate;

    // Charts & Analytics
    private List<MonthlyRevenueItemDTO> monthlyRevenues = new ArrayList<>();
    private List<LeadSourceStatDTO> leadSources = new ArrayList<>();

    // Recent activities
    private List<RecentPaymentItemDTO> recentPayments = new ArrayList<>();
    private List<RecentEnrollmentItemDTO> recentEnrollments = new ArrayList<>();

    public AdminDashboardDTO() {}

    public BigDecimal getMonthRevenue() { return monthRevenue; }
    public void setMonthRevenue(BigDecimal monthRevenue) { this.monthRevenue = monthRevenue; }

    public BigDecimal getTotalInvoiced() { return totalInvoiced; }
    public void setTotalInvoiced(BigDecimal totalInvoiced) { this.totalInvoiced = totalInvoiced; }

    public BigDecimal getOutstandingDebt() { return outstandingDebt; }
    public void setOutstandingDebt(BigDecimal outstandingDebt) { this.outstandingDebt = outstandingDebt; }

    public long getActiveStudentsCount() { return activeStudentsCount; }
    public void setActiveStudentsCount(long activeStudentsCount) { this.activeStudentsCount = activeStudentsCount; }

    public long getOpenClassesCount() { return openClassesCount; }
    public void setOpenClassesCount(long openClassesCount) { this.openClassesCount = openClassesCount; }

    public double getAttendanceRate() { return attendanceRate; }
    public void setAttendanceRate(double attendanceRate) { this.attendanceRate = attendanceRate; }

    public long getNewLeadsThisMonth() { return newLeadsThisMonth; }
    public void setNewLeadsThisMonth(long newLeadsThisMonth) { this.newLeadsThisMonth = newLeadsThisMonth; }

    public long getEnrolledLeadsCount() { return enrolledLeadsCount; }
    public void setEnrolledLeadsCount(long enrolledLeadsCount) { this.enrolledLeadsCount = enrolledLeadsCount; }

    public double getLeadConversionRate() { return leadConversionRate; }
    public void setLeadConversionRate(double leadConversionRate) { this.leadConversionRate = leadConversionRate; }

    public List<MonthlyRevenueItemDTO> getMonthlyRevenues() { return monthlyRevenues; }
    public void setMonthlyRevenues(List<MonthlyRevenueItemDTO> monthlyRevenues) { this.monthlyRevenues = monthlyRevenues; }

    public List<LeadSourceStatDTO> getLeadSources() { return leadSources; }
    public void setLeadSources(List<LeadSourceStatDTO> leadSources) { this.leadSources = leadSources; }

    public List<RecentPaymentItemDTO> getRecentPayments() { return recentPayments; }
    public void setRecentPayments(List<RecentPaymentItemDTO> recentPayments) { this.recentPayments = recentPayments; }

    public List<RecentEnrollmentItemDTO> getRecentEnrollments() { return recentEnrollments; }
    public void setRecentEnrollments(List<RecentEnrollmentItemDTO> recentEnrollments) { this.recentEnrollments = recentEnrollments; }
}
