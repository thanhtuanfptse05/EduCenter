package com.educenter.service;

import com.educenter.dto.AdminDashboardDTO;
import com.educenter.dto.DetailedReportDTO;
import com.educenter.dto.ReportFilterDTO;
import com.educenter.repository.ReportRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.time.LocalDate;
import java.util.function.Supplier;

public class ReportServiceImpl implements ReportService {

    private final ReportRepository reportRepository;
    private final Supplier<EntityManager> emSupplier;

    public ReportServiceImpl() {
        this(new ReportRepository(), () -> JPAUtil.getEntityManagerFactory().createEntityManager());
    }

    public ReportServiceImpl(ReportRepository reportRepository, Supplier<EntityManager> emSupplier) {
        this.reportRepository = reportRepository;
        this.emSupplier = emSupplier;
    }

    @Override
    public AdminDashboardDTO getAdminDashboardData() {
        EntityManager em = emSupplier.get();
        try {
            return reportRepository.getDashboardData(em);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public DetailedReportDTO getDetailedReport(ReportFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            LocalDate fromDate = (filter != null && filter.getFromDate() != null)
                    ? filter.getFromDate()
                    : LocalDate.now().withDayOfMonth(1);

            LocalDate toDate = (filter != null && filter.getToDate() != null)
                    ? filter.getToDate()
                    : LocalDate.now();

            if (fromDate.isAfter(toDate)) {
                LocalDate temp = fromDate;
                fromDate = toDate;
                toDate = temp;
            }

            return reportRepository.getDetailedReport(em, fromDate, toDate);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }
}
