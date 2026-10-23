package com.educenter.repository;

import com.educenter.dto.*;
import com.educenter.entity.*;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

public class ReportRepository {

    public AdminDashboardDTO getDashboardData(EntityManager em) {
        AdminDashboardDTO dto = new AdminDashboardDTO();
        LocalDate now = LocalDate.now();
        int currentYear = now.getYear();
        int currentMonth = now.getMonthValue();

        try {
            // 1. Doanh thu tháng này
            BigDecimal monthRev = em.createQuery(
                    "SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'CONFIRMED' AND YEAR(p.paidAt) = :yr AND MONTH(p.paidAt) = :mo",
                    BigDecimal.class
            ).setParameter("yr", currentYear).setParameter("mo", currentMonth).getSingleResult();
            dto.setMonthRevenue(monthRev != null ? monthRev : BigDecimal.ZERO);

            // 2. Học phí phát sinh tháng này
            BigDecimal monthInv = em.createQuery(
                    "SELECT SUM(i.finalAmount) FROM Invoice i WHERE YEAR(i.createdAt) = :yr AND MONTH(i.createdAt) = :mo",
                    BigDecimal.class
            ).setParameter("yr", currentYear).setParameter("mo", currentMonth).getSingleResult();
            dto.setTotalInvoiced(monthInv != null ? monthInv : BigDecimal.ZERO);

            // 3. Công nợ chưa thanh toán (B06: Tổng học phí cần thu trừ đi các khoản đã thu confirmed của hóa đơn chưa thanh toán đủ)
            BigDecimal totalInvoicedUnpaid = em.createQuery(
                    "SELECT SUM(i.finalAmount) FROM Invoice i WHERE i.status IN ('UNPAID', 'PARTIALLY_PAID')",
                    BigDecimal.class
            ).getSingleResult();
            if (totalInvoicedUnpaid == null) totalInvoicedUnpaid = BigDecimal.ZERO;

            BigDecimal totalPaidForUnpaid = em.createQuery(
                    "SELECT SUM(p.amount) FROM Payment p WHERE p.invoice.status IN ('UNPAID', 'PARTIALLY_PAID') AND p.status = 'CONFIRMED'",
                    BigDecimal.class
            ).getSingleResult();
            if (totalPaidForUnpaid == null) totalPaidForUnpaid = BigDecimal.ZERO;

            BigDecimal debt = totalInvoicedUnpaid.subtract(totalPaidForUnpaid);
            if (debt.compareTo(BigDecimal.ZERO) < 0) debt = BigDecimal.ZERO;
            dto.setOutstandingDebt(debt);

            // 4. Học viên đang theo học (ACTIVE)
            Long activeStudents = em.createQuery(
                    "SELECT COUNT(DISTINCT e.student.id) FROM Enrollment e WHERE e.status = 'ACTIVE'",
                    Long.class
            ).getSingleResult();
            dto.setActiveStudentsCount(activeStudents != null ? activeStudents : 0L);

            // 5. Lớp đang mở hoặc đang dạy (OPEN, ONGOING)
            Long openClasses = em.createQuery(
                    "SELECT COUNT(c) FROM EduClass c WHERE c.status IN ('OPEN', 'ONGOING')",
                    Long.class
            ).getSingleResult();
            dto.setOpenClassesCount(openClasses != null ? openClasses : 0L);

            // 6. Tỷ lệ chuyên cần toàn trung tâm (B04: tính trên các buổi COMPLETED, bao gồm cả PRESENT và LATE, không mặc định 100% khi rỗng)
            Long totalAtt = em.createQuery("SELECT COUNT(a) FROM Attendance a JOIN a.session s WHERE s.status = 'COMPLETED'", Long.class).getSingleResult();
            Long attendedCount = em.createQuery("SELECT COUNT(a) FROM Attendance a JOIN a.session s WHERE s.status = 'COMPLETED' AND a.status IN ('PRESENT', 'LATE')", Long.class).getSingleResult();
            if (totalAtt != null && totalAtt > 0 && attendedCount != null) {
                double rate = ((double) attendedCount / totalAtt) * 100.0;
                dto.setAttendanceRate(Math.round(rate * 10.0) / 10.0);
            } else {
                dto.setAttendanceRate(0.0);
            }

            // 7. Tuyển sinh tháng này
            Long newLeads = em.createQuery(
                    "SELECT COUNT(l) FROM Lead l WHERE YEAR(l.createdAt) = :yr AND MONTH(l.createdAt) = :mo",
                    Long.class
            ).setParameter("yr", currentYear).setParameter("mo", currentMonth).getSingleResult();
            dto.setNewLeadsThisMonth(newLeads != null ? newLeads : 0L);

            Long enrolledLeads = em.createQuery(
                    "SELECT COUNT(l) FROM Lead l WHERE l.status = 'ENROLLED' AND YEAR(l.createdAt) = :yr AND MONTH(l.createdAt) = :mo",
                    Long.class
            ).setParameter("yr", currentYear).setParameter("mo", currentMonth).getSingleResult();
            dto.setEnrolledLeadsCount(enrolledLeads != null ? enrolledLeads : 0L);

            if (newLeads != null && newLeads > 0 && enrolledLeads != null) {
                double convRate = ((double) enrolledLeads / newLeads) * 100.0;
                dto.setLeadConversionRate(Math.round(convRate * 10.0) / 10.0);
            }

            // 8. Doanh thu 6 tháng gần nhất
            List<MonthlyRevenueItemDTO> monthlyRevenues = new ArrayList<>();
            for (int i = 5; i >= 0; i--) {
                LocalDate targetDate = now.minusMonths(i);
                int y = targetDate.getYear();
                int m = targetDate.getMonthValue();

                BigDecimal rev = em.createQuery(
                        "SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'CONFIRMED' AND YEAR(p.paidAt) = :yr AND MONTH(p.paidAt) = :mo",
                        BigDecimal.class
                ).setParameter("yr", y).setParameter("mo", m).getSingleResult();

                Long txCnt = em.createQuery(
                        "SELECT COUNT(p) FROM Payment p WHERE p.status = 'CONFIRMED' AND YEAR(p.paidAt) = :yr AND MONTH(p.paidAt) = :mo",
                        Long.class
                ).setParameter("yr", y).setParameter("mo", m).getSingleResult();

                monthlyRevenues.add(new MonthlyRevenueItemDTO(m, y, rev != null ? rev : BigDecimal.ZERO, txCnt != null ? txCnt : 0L));
            }
            dto.setMonthlyRevenues(monthlyRevenues);

            // 9. Phân bố nguồn Lead
            List<Object[]> sourceRows = em.createQuery(
                    "SELECT l.source, COUNT(l), SUM(CASE WHEN l.status = 'ENROLLED' THEN 1L ELSE 0L END) FROM Lead l GROUP BY l.source",
                    Object[].class
            ).getResultList();
            List<LeadSourceStatDTO> sourceList = new ArrayList<>();
            for (Object[] row : sourceRows) {
                String src = (String) row[0];
                Long tot = (Long) row[1];
                Long enr = (Long) row[2];
                sourceList.add(new LeadSourceStatDTO(src, tot != null ? tot : 0L, enr != null ? enr : 0L));
            }
            dto.setLeadSources(sourceList);

            // 10. Giao dịch thanh toán gần đây (5 items)
            List<Payment> recentPayments = em.createQuery(
                    "SELECT p FROM Payment p LEFT JOIN FETCH p.invoice i LEFT JOIN FETCH i.student s ORDER BY p.paidAt DESC",
                    Payment.class
            ).setMaxResults(5).getResultList();
            List<RecentPaymentItemDTO> pDtoList = new ArrayList<>();
            for (Payment p : recentPayments) {
                RecentPaymentItemDTO pDto = new RecentPaymentItemDTO();
                pDto.setPaymentCode(p.getPaymentCode());
                if (p.getInvoice() != null) {
                    pDto.setInvoiceCode(p.getInvoice().getInvoiceCode());
                    if (p.getInvoice().getStudent() != null) {
                        pDto.setStudentName(p.getInvoice().getStudent().getFullName());
                    }
                }
                pDto.setAmount(p.getAmount());
                pDto.setPaymentMethod(p.getPaymentMethod());
                pDto.setPaidAt(p.getPaidAt());
                pDtoList.add(pDto);
            }
            dto.setRecentPayments(pDtoList);

            // 11. Ghi danh gần đây (5 items)
            List<Enrollment> recentEnrollments = em.createQuery(
                    "SELECT e FROM Enrollment e LEFT JOIN FETCH e.student s LEFT JOIN FETCH e.eduClass c LEFT JOIN FETCH c.course cr ORDER BY e.enrolledAt DESC",
                    Enrollment.class
            ).setMaxResults(5).getResultList();
            List<RecentEnrollmentItemDTO> eDtoList = new ArrayList<>();
            for (Enrollment e : recentEnrollments) {
                RecentEnrollmentItemDTO eDto = new RecentEnrollmentItemDTO();
                if (e.getStudent() != null) {
                    eDto.setStudentName(e.getStudent().getFullName());
                }
                if (e.getEduClass() != null) {
                    eDto.setClassName(e.getEduClass().getName());
                    if (e.getEduClass().getCourse() != null) {
                        eDto.setCourseName(e.getEduClass().getCourse().getName());
                    }
                }
                eDto.setEnrolledAt(e.getEnrolledAt());
                eDto.setStatus(e.getStatus());
                eDtoList.add(eDto);
            }
            dto.setRecentEnrollments(eDtoList);

        } catch (Exception e) {
            // Keep default values on error
        }

        return dto;
    }

    public DetailedReportDTO getDetailedReport(EntityManager em, LocalDate fromDate, LocalDate toDate) {
        DetailedReportDTO dto = new DetailedReportDTO();
        if (fromDate == null) fromDate = LocalDate.now().withDayOfMonth(1);
        if (toDate == null) toDate = LocalDate.now();

        dto.setFromDate(fromDate);
        dto.setToDate(toDate);

        LocalDateTime startDt = fromDate.atStartOfDay();
        LocalDateTime endDt = toDate.atTime(LocalTime.MAX);

        try {
            // 1. Tài chính: SUM, COUNT trong khoảng thời gian
            BigDecimal totalRev = em.createQuery(
                    "SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'CONFIRMED' AND p.paidAt >= :startDt AND p.paidAt <= :endDt",
                    BigDecimal.class
            ).setParameter("startDt", startDt).setParameter("endDt", endDt).getSingleResult();
            dto.setTotalRevenue(totalRev != null ? totalRev : BigDecimal.ZERO);

            Long payCount = em.createQuery(
                    "SELECT COUNT(p) FROM Payment p WHERE p.status = 'CONFIRMED' AND p.paidAt >= :startDt AND p.paidAt <= :endDt",
                    Long.class
            ).setParameter("startDt", startDt).setParameter("endDt", endDt).getSingleResult();
            dto.setPaymentCount(payCount != null ? payCount : 0L);

            BigDecimal totalInv = em.createQuery(
                    "SELECT SUM(i.finalAmount) FROM Invoice i WHERE i.createdAt >= :startDt AND i.createdAt <= :endDt",
                    BigDecimal.class
            ).setParameter("startDt", startDt).setParameter("endDt", endDt).getSingleResult();
            dto.setTotalInvoiced(totalInv != null ? totalInv : BigDecimal.ZERO);

            // B06: Công nợ thực tế (tổng finalAmount trừ khoản đã thu confirmed)
            BigDecimal totalInvoicedUnpaid = em.createQuery(
                    "SELECT SUM(i.finalAmount) FROM Invoice i WHERE i.status IN ('UNPAID', 'PARTIALLY_PAID')",
                    BigDecimal.class
            ).getSingleResult();
            if (totalInvoicedUnpaid == null) totalInvoicedUnpaid = BigDecimal.ZERO;

            BigDecimal totalPaidForUnpaid = em.createQuery(
                    "SELECT SUM(p.amount) FROM Payment p WHERE p.invoice.status IN ('UNPAID', 'PARTIALLY_PAID') AND p.status = 'CONFIRMED'",
                    BigDecimal.class
            ).getSingleResult();
            if (totalPaidForUnpaid == null) totalPaidForUnpaid = BigDecimal.ZERO;

            BigDecimal debt = totalInvoicedUnpaid.subtract(totalPaidForUnpaid);
            if (debt.compareTo(BigDecimal.ZERO) < 0) debt = BigDecimal.ZERO;
            dto.setOutstandingDebt(debt);

            // Doanh thu theo phương thức thanh toán
            List<Object[]> methodRows = em.createQuery(
                    "SELECT p.paymentMethod, SUM(p.amount) FROM Payment p WHERE p.status = 'CONFIRMED' AND p.paidAt >= :startDt AND p.paidAt <= :endDt GROUP BY p.paymentMethod",
                    Object[].class
            ).setParameter("startDt", startDt).setParameter("endDt", endDt).getResultList();
            Map<String, BigDecimal> methodMap = new HashMap<>();
            for (Object[] r : methodRows) {
                methodMap.put((String) r[0], (BigDecimal) r[1]);
            }
            dto.setRevenueByMethod(methodMap);

            // 2. Học phí Khóa học: MIN, MAX, AVG (ASM 3.5 Requirement)
            Object[] feeAggs = em.createQuery(
                    "SELECT MIN(c.fee), MAX(c.fee), AVG(c.fee) FROM Course c",
                    Object[].class
            ).getSingleResult();
            if (feeAggs != null) {
                dto.setMinCourseFee(feeAggs[0] != null ? (BigDecimal) feeAggs[0] : BigDecimal.ZERO);
                dto.setMaxCourseFee(feeAggs[1] != null ? (BigDecimal) feeAggs[1] : BigDecimal.ZERO);
                if (feeAggs[2] != null) {
                    dto.setAvgCourseFee(BigDecimal.valueOf(((Double) feeAggs[2])).setScale(0, RoundingMode.HALF_UP));
                }
            }

            // 3. Sĩ số Lớp học: MIN, MAX, AVG, COUNT (ASM 3.5 Requirement)
            Object[] classAggs = em.createQuery(
                    "SELECT COUNT(c), MIN(c.capacity), MAX(c.capacity), AVG(c.capacity) FROM EduClass c",
                    Object[].class
            ).getSingleResult();
            if (classAggs != null) {
                dto.setTotalClassesCount(classAggs[0] != null ? (Long) classAggs[0] : 0L);
                dto.setMinClassCapacity(classAggs[1] != null ? (Integer) classAggs[1] : 0);
                dto.setMaxClassCapacity(classAggs[2] != null ? (Integer) classAggs[2] : 0);
                dto.setAvgClassCapacity(classAggs[3] != null ? Math.round(((Double) classAggs[3]) * 10.0) / 10.0 : 0.0);
            }

            // 4. Chuyên cần học vụ trong kỳ (B04: tính các buổi COMPLETED, bao gồm PRESENT và LATE, không mặc định 100% khi rỗng)
            List<Object[]> attRows = em.createQuery(
                    "SELECT a.status, COUNT(a) FROM Attendance a JOIN a.session s WHERE s.status = 'COMPLETED' AND s.sessionDate >= :fromD AND s.sessionDate <= :toD GROUP BY a.status",
                    Object[].class
            ).setParameter("fromD", fromDate).setParameter("toD", toDate).getResultList();
            long totAtt = 0;
            for (Object[] r : attRows) {
                String st = (String) r[0];
                Long cnt = (Long) r[1];
                totAtt += (cnt != null ? cnt : 0L);
                if ("PRESENT".equals(st)) dto.setPresentCount(cnt != null ? cnt : 0L);
                else if ("LATE".equals(st)) dto.setLateCount(cnt != null ? cnt : 0L);
                else if ("ABSENT_EXCUSED".equals(st)) dto.setExcusedCount(cnt != null ? cnt : 0L);
                else if ("ABSENT_UNEXCUSED".equals(st)) dto.setUnexcusedCount(cnt != null ? cnt : 0L);
            }
            dto.setTotalAttendances(totAtt);
            if (totAtt > 0) {
                double aRate = ((double) (dto.getPresentCount() + dto.getLateCount()) / totAtt) * 100.0;
                dto.setAttendanceRate(Math.round(aRate * 10.0) / 10.0);
            } else {
                dto.setAttendanceRate(0.0);
            }

            // 5. Điểm số bài kiểm tra đã công bố: MIN, MAX, AVG, COUNT (ASM 3.5 Requirement)
            Object[] scoreAggs = em.createQuery(
                    "SELECT COUNT(s), MIN(s.score), MAX(s.score), AVG(s.score) FROM AssessmentScore s JOIN s.assessment a WHERE a.status = 'PUBLISHED'",
                    Object[].class
            ).getSingleResult();
            if (scoreAggs != null) {
                dto.setTotalScoresCount(scoreAggs[0] != null ? (Long) scoreAggs[0] : 0L);
                dto.setMinScore(scoreAggs[1] != null ? (BigDecimal) scoreAggs[1] : BigDecimal.ZERO);
                dto.setMaxScore(scoreAggs[2] != null ? (BigDecimal) scoreAggs[2] : BigDecimal.ZERO);
                if (scoreAggs[3] != null) {
                    dto.setAvgScore(BigDecimal.valueOf((Double) scoreAggs[3]).setScale(2, RoundingMode.HALF_UP));
                }
            }

            // 6. Tuyển sinh trong kỳ: COUNT & Tỷ lệ chuyển đổi
            Long leadsCnt = em.createQuery(
                    "SELECT COUNT(l) FROM Lead l WHERE l.createdAt >= :startDt AND l.createdAt <= :endDt",
                    Long.class
            ).setParameter("startDt", startDt).setParameter("endDt", endDt).getSingleResult();
            dto.setTotalLeads(leadsCnt != null ? leadsCnt : 0L);

            Long enrolledCnt = em.createQuery(
                    "SELECT COUNT(l) FROM Lead l WHERE l.status = 'ENROLLED' AND l.createdAt >= :startDt AND l.createdAt <= :endDt",
                    Long.class
            ).setParameter("startDt", startDt).setParameter("endDt", endDt).getSingleResult();
            dto.setEnrolledLeads(enrolledCnt != null ? enrolledCnt : 0L);

            if (leadsCnt != null && leadsCnt > 0 && enrolledCnt != null) {
                double lRate = ((double) enrolledCnt / leadsCnt) * 100.0;
                dto.setLeadConversionRate(Math.round(lRate * 10.0) / 10.0);
            }

        } catch (Exception e) {
            // Keep defaults
        }

        return dto;
    }
}
