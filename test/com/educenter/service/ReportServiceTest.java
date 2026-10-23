package com.educenter.service;

import com.educenter.dto.AdminDashboardDTO;
import com.educenter.dto.DetailedReportDTO;
import com.educenter.dto.MonthlyRevenueItemDTO;
import com.educenter.dto.ReportFilterDTO;
import com.educenter.repository.ReportRepository;
import jakarta.persistence.*;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaDelete;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.CriteriaUpdate;
import jakarta.persistence.metamodel.Metamodel;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ReportService — Executive Dashboard & Reports Tests (ADM-01, ADM-16)")
public class ReportServiceTest {

    private ReportServiceImpl reportService;
    private MockReportRepository mockRepo;
    private StubEntityManager stubEm;

    static class MockReportRepository extends ReportRepository {
        AdminDashboardDTO dashboardStub = new AdminDashboardDTO();
        DetailedReportDTO reportStub = new DetailedReportDTO();

        @Override
        public AdminDashboardDTO getDashboardData(EntityManager em) {
            dashboardStub.setMonthRevenue(BigDecimal.valueOf(50000000));
            dashboardStub.setTotalInvoiced(BigDecimal.valueOf(65000000));
            dashboardStub.setOutstandingDebt(BigDecimal.valueOf(15000000));
            dashboardStub.setActiveStudentsCount(120);
            dashboardStub.setOpenClassesCount(8);
            dashboardStub.setAttendanceRate(96.5);
            dashboardStub.setNewLeadsThisMonth(25);
            dashboardStub.setEnrolledLeadsCount(15);
            dashboardStub.setLeadConversionRate(60.0);

            List<MonthlyRevenueItemDTO> revList = new ArrayList<>();
            for (int i = 1; i <= 6; i++) {
                revList.add(new MonthlyRevenueItemDTO(i, 2026, BigDecimal.valueOf(40000000 + i * 2000000), 10 + i));
            }
            dashboardStub.setMonthlyRevenues(revList);

            return dashboardStub;
        }

        @Override
        public DetailedReportDTO getDetailedReport(EntityManager em, LocalDate fromDate, LocalDate toDate) {
            reportStub.setFromDate(fromDate);
            reportStub.setToDate(toDate);
            reportStub.setTotalRevenue(BigDecimal.valueOf(120000000));
            reportStub.setTotalInvoiced(BigDecimal.valueOf(150000000));
            reportStub.setOutstandingDebt(BigDecimal.valueOf(30000000));
            reportStub.setPaymentCount(35);

            reportStub.setMinCourseFee(BigDecimal.valueOf(2500000));
            reportStub.setMaxCourseFee(BigDecimal.valueOf(6000000));
            reportStub.setAvgCourseFee(BigDecimal.valueOf(4200000));

            reportStub.setTotalClassesCount(10);
            reportStub.setMinClassCapacity(10);
            reportStub.setMaxClassCapacity(25);
            reportStub.setAvgClassCapacity(15.5);

            reportStub.setTotalAttendances(300);
            reportStub.setPresentCount(280);
            reportStub.setLateCount(10);
            reportStub.setExcusedCount(5);
            reportStub.setUnexcusedCount(5);
            reportStub.setAttendanceRate(93.3);

            reportStub.setTotalScoresCount(50);
            reportStub.setMinScore(BigDecimal.valueOf(4.5));
            reportStub.setMaxScore(BigDecimal.valueOf(10.0));
            reportStub.setAvgScore(BigDecimal.valueOf(8.25));

            reportStub.setTotalLeads(40);
            reportStub.setEnrolledLeads(20);
            reportStub.setLeadConversionRate(50.0);

            return reportStub;
        }
    }

    @BeforeEach
    void setUp() {
        mockRepo = new MockReportRepository();
        stubEm = new StubEntityManager();
        reportService = new ReportServiceImpl(mockRepo, () -> stubEm);
    }

    @Test
    @DisplayName("Lấy dữ liệu Dashboard tổng quan chính xác")
    void testGetAdminDashboardData() {
        AdminDashboardDTO data = reportService.getAdminDashboardData();

        assertNotNull(data);
        assertEquals(BigDecimal.valueOf(50000000), data.getMonthRevenue());
        assertEquals(BigDecimal.valueOf(65000000), data.getTotalInvoiced());
        assertEquals(BigDecimal.valueOf(15000000), data.getOutstandingDebt());
        assertEquals(120, data.getActiveStudentsCount());
        assertEquals(8, data.getOpenClassesCount());
        assertEquals(96.5, data.getAttendanceRate());
        assertEquals(25, data.getNewLeadsThisMonth());
        assertEquals(15, data.getEnrolledLeadsCount());
        assertEquals(60.0, data.getLeadConversionRate());
        assertEquals(6, data.getMonthlyRevenues().size());
    }

    @Test
    @DisplayName("Lấy báo cáo chi tiết với khoảng thời gian hợp lệ")
    void testGetDetailedReportWithDateRange() {
        LocalDate from = LocalDate.of(2026, 1, 1);
        LocalDate to = LocalDate.of(2026, 6, 30);
        ReportFilterDTO filter = new ReportFilterDTO(from, to);

        DetailedReportDTO report = reportService.getDetailedReport(filter);

        assertNotNull(report);
        assertEquals(from, report.getFromDate());
        assertEquals(to, report.getToDate());
        assertEquals(BigDecimal.valueOf(120000000), report.getTotalRevenue());
        assertEquals(BigDecimal.valueOf(2500000), report.getMinCourseFee());
        assertEquals(BigDecimal.valueOf(6000000), report.getMaxCourseFee());
        assertEquals(BigDecimal.valueOf(4200000), report.getAvgCourseFee());
        assertEquals(10, report.getTotalClassesCount());
        assertEquals(93.3, report.getAttendanceRate());
        assertEquals(BigDecimal.valueOf(8.25), report.getAvgScore());
    }

    @Test
    @DisplayName("Tự động hoán đổi ngày nếu fromDate > toDate")
    void testGetDetailedReportSwapDates() {
        LocalDate from = LocalDate.of(2026, 10, 31);
        LocalDate to = LocalDate.of(2026, 10, 1);
        ReportFilterDTO filter = new ReportFilterDTO(from, to);

        DetailedReportDTO report = reportService.getDetailedReport(filter);

        assertNotNull(report);
        assertEquals(to, report.getFromDate());
        assertEquals(from, report.getToDate());
    }

    @Test
    @DisplayName("Tự động dùng tháng hiện tại khi filter là null")
    void testGetDetailedReportNullFilter() {
        DetailedReportDTO report = reportService.getDetailedReport(null);

        assertNotNull(report);
        assertNotNull(report.getFromDate());
        assertNotNull(report.getToDate());
        assertEquals(LocalDate.now().withDayOfMonth(1), report.getFromDate());
        assertEquals(LocalDate.now(), report.getToDate());
    }

    // ==========================================
    // STUB ENTITY MANAGER FOR PURE JUNIT 5
    // ==========================================
    static class StubEntityManager implements EntityManager {
        @Override public void persist(Object entity) {}
        @Override public <T> T merge(T entity) { return entity; }
        @Override public void remove(Object entity) {}
        @Override public <T> T find(Class<T> entityClass, Object primaryKey) { return null; }
        @Override public <T> T find(Class<T> entityClass, Object primaryKey, Map<String, Object> properties) { return null; }
        @Override public <T> T find(Class<T> entityClass, Object primaryKey, LockModeType lockMode) { return null; }
        @Override public <T> T find(Class<T> entityClass, Object primaryKey, LockModeType lockMode, Map<String, Object> properties) { return null; }
        @Override public <T> T getReference(Class<T> entityClass, Object primaryKey) { return null; }
        @Override public void flush() {}
        @Override public void setFlushMode(FlushModeType flushMode) {}
        @Override public FlushModeType getFlushMode() { return null; }
        @Override public void lock(Object entity, LockModeType lockMode) {}
        @Override public void lock(Object entity, LockModeType lockMode, Map<String, Object> properties) {}
        @Override public void refresh(Object entity) {}
        @Override public void refresh(Object entity, Map<String, Object> properties) {}
        @Override public void refresh(Object entity, LockModeType lockMode) {}
        @Override public void refresh(Object entity, LockModeType lockMode, Map<String, Object> properties) {}
        @Override public void clear() {}
        @Override public void detach(Object entity) {}
        @Override public boolean contains(Object entity) { return false; }
        @Override public LockModeType getLockMode(Object entity) { return null; }
        @Override public void setProperty(String propertyName, Object value) {}
        @Override public Map<String, Object> getProperties() { return Collections.emptyMap(); }
        @Override public Query createQuery(String qlString) { return null; }
        @Override public <T> TypedQuery<T> createQuery(CriteriaQuery<T> criteriaQuery) { return null; }
        @Override public Query createQuery(CriteriaUpdate updateQuery) { return null; }
        @Override public Query createQuery(CriteriaDelete deleteQuery) { return null; }
        @Override public <T> TypedQuery<T> createQuery(String qlString, Class<T> resultClass) { return null; }
        @Override public Query createNamedQuery(String name) { return null; }
        @Override public <T> TypedQuery<T> createNamedQuery(String name, Class<T> resultClass) { return null; }
        @Override public Query createNativeQuery(String sqlString) { return null; }
        @Override public Query createNativeQuery(String sqlString, Class resultClass) { return null; }
        @Override public Query createNativeQuery(String sqlString, String resultSetMapping) { return null; }
        @Override public StoredProcedureQuery createNamedStoredProcedureQuery(String name) { return null; }
        @Override public StoredProcedureQuery createStoredProcedureQuery(String procedureName) { return null; }
        @Override public StoredProcedureQuery createStoredProcedureQuery(String procedureName, Class... resultClasses) { return null; }
        @Override public StoredProcedureQuery createStoredProcedureQuery(String procedureName, String... resultSetMappings) { return null; }
        @Override public void joinTransaction() {}
        @Override public boolean isJoinedToTransaction() { return false; }
        @Override public <T> T unwrap(Class<T> cls) { return null; }
        @Override public Object getDelegate() { return null; }
        @Override public void close() {}
        @Override public boolean isOpen() { return true; }
        @Override public EntityTransaction getTransaction() { return null; }
        @Override public EntityManagerFactory getEntityManagerFactory() { return null; }
        @Override public CriteriaBuilder getCriteriaBuilder() { return null; }
        @Override public Metamodel getMetamodel() { return null; }
        @Override public <T> EntityGraph<T> createEntityGraph(Class<T> rootType) { return null; }
        @Override public EntityGraph<?> createEntityGraph(String graphName) { return null; }
        @Override public EntityGraph<?> getEntityGraph(String graphName) { return null; }
        @Override public <T> List<EntityGraph<? super T>> getEntityGraphs(Class<T> entityClass) { return Collections.emptyList(); }
    }
}
