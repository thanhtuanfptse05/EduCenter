package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.PaymentRepository;
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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("PaymentService — Manual Tuition Payment, Invoicing and Receipt Tests")
public class PaymentServiceTest {

    private PaymentServiceImpl paymentService;
    private MockPaymentRepository mockRepo;
    private StubEntityManager stubEm;

    static class MockPaymentRepository extends PaymentRepository {
        Invoice invoice;
        List<Payment> savedPayments = new ArrayList<>();
        BigDecimal currentPaidAmount = BigDecimal.ZERO;
        Payment singlePayment;

        @Override
        public Optional<Invoice> findInvoiceById(EntityManager em, Long invoiceId) {
            if (invoice != null && invoice.getId().equals(invoiceId)) {
                return Optional.of(invoice);
            }
            return Optional.empty();
        }

        @Override
        public BigDecimal calculateInvoicePaidAmount(EntityManager em, Long invoiceId) {
            return currentPaidAmount;
        }

        @Override
        public void savePayment(EntityManager em, Payment payment) {
            payment.setId((long) (savedPayments.size() + 1));
            savedPayments.add(payment);
        }

        @Override
        public void updateInvoice(EntityManager em, Invoice inv) {
            this.invoice = inv;
        }

        @Override
        public Optional<Payment> findPaymentById(EntityManager em, Long paymentId) {
            if (singlePayment != null && singlePayment.getId().equals(paymentId)) {
                return Optional.of(singlePayment);
            }
            return savedPayments.stream().filter(p -> p.getId().equals(paymentId)).findFirst();
        }

        @Override
        public String[] findPrimaryGuardianInfo(EntityManager em, Long studentId) {
            return new String[] { "Nguyễn Văn Phụ Huynh", "0988888888" };
        }

        @Override
        public List<InvoiceItemViewDTO> findItemsByInvoiceId(EntityManager em, Long invoiceId) {
            List<InvoiceItemViewDTO> list = new ArrayList<>();
            InvoiceItemViewDTO item = new InvoiceItemViewDTO();
            item.setId(1L);
            item.setDescription("Học phí khóa Toán 10");
            item.setUnitPrice(new BigDecimal("2000000"));
            item.setQuantity(1);
            item.setAmount(new BigDecimal("2000000"));
            list.add(item);
            return list;
        }

        @Override
        public List<PaymentRecordDTO> findPaymentsByInvoiceId(EntityManager em, Long invoiceId) {
            List<PaymentRecordDTO> list = new ArrayList<>();
            for (Payment p : savedPayments) {
                PaymentRecordDTO dto = new PaymentRecordDTO();
                dto.setId(p.getId());
                dto.setPaymentCode(p.getPaymentCode());
                dto.setAmount(p.getAmount());
                dto.setPaymentMethod(p.getPaymentMethod());
                dto.setPaidAt(p.getPaidAt());
                dto.setStatus(p.getStatus());
                list.add(dto);
            }
            return list;
        }
    }

    static class StubEntityTransaction implements EntityTransaction {
        boolean active = false;
        boolean committed = false;
        boolean rolledBack = false;

        @Override public void begin() { active = true; }
        @Override public void commit() { active = false; committed = true; }
        @Override public void rollback() { active = false; rolledBack = true; }
        @Override public void setRollbackOnly() {}
        @Override public boolean getRollbackOnly() { return false; }
        @Override public boolean isActive() { return active; }
    }

    static class StubEntityManager implements EntityManager {
        User staffUser;
        final StubEntityTransaction tx = new StubEntityTransaction();

        @SuppressWarnings("unchecked")
        @Override
        public <T> T find(Class<T> entityClass, Object primaryKey) {
            if (entityClass == User.class && staffUser != null && staffUser.getId().equals(primaryKey)) {
                return (T) staffUser;
            }
            return null;
        }

        @Override public EntityTransaction getTransaction() { return tx; }
        @Override public void close() {}
        @Override public boolean isOpen() { return true; }
        @Override public void persist(Object entity) {}
        @Override public <T> T merge(T entity) { return entity; }
        @Override public void remove(Object entity) {}
        @Override public <T> T find(Class<T> entityClass, Object primaryKey, Map<String, Object> properties) { return find(entityClass, primaryKey); }
        @Override public <T> T find(Class<T> entityClass, Object primaryKey, LockModeType lockMode) { return find(entityClass, primaryKey); }
        @Override public <T> T find(Class<T> entityClass, Object primaryKey, LockModeType lockMode, Map<String, Object> properties) { return find(entityClass, primaryKey); }
        @Override public <T> T getReference(Class<T> entityClass, Object primaryKey) { return find(entityClass, primaryKey); }
        @Override public void flush() {}
        @Override public void setFlushMode(FlushModeType flushMode) {}
        @Override public FlushModeType getFlushMode() { return FlushModeType.AUTO; }
        @Override public void lock(Object entity, LockModeType lockMode) {}
        @Override public void lock(Object entity, LockModeType lockMode, Map<String, Object> properties) {}
        @Override public void refresh(Object entity) {}
        @Override public void refresh(Object entity, Map<String, Object> properties) {}
        @Override public void refresh(Object entity, LockModeType lockMode) {}
        @Override public void refresh(Object entity, LockModeType lockMode, Map<String, Object> properties) {}
        @Override public void clear() {}
        @Override public void detach(Object entity) {}
        @Override public boolean contains(Object entity) { return false; }
        @Override public LockModeType getLockMode(Object entity) { return LockModeType.NONE; }
        @Override public void setProperty(String propertyName, Object value) {}
        @Override public Map<String, Object> getProperties() { return null; }
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
        @Override public EntityManagerFactory getEntityManagerFactory() { return null; }
        @Override public CriteriaBuilder getCriteriaBuilder() { return null; }
        @Override public Metamodel getMetamodel() { return null; }
        @Override public <T> EntityGraph<T> createEntityGraph(Class<T> rootType) { return null; }
        @Override public EntityGraph<?> createEntityGraph(String graphName) { return null; }
        @Override public EntityGraph<?> getEntityGraph(String graphName) { return null; }
        @Override public <T> List<EntityGraph<? super T>> getEntityGraphs(Class<T> entityClass) { return null; }
    }

    @BeforeEach
    void setUp() {
        mockRepo = new MockPaymentRepository();
        stubEm = new StubEntityManager();

        paymentService = new PaymentServiceImpl(mockRepo) {
            @Override
            protected EntityManager getEntityManager() {
                return stubEm;
            }
        };
    }

    private Invoice createMockInvoice(Long id, BigDecimal finalAmount, String status) {
        Invoice inv = new Invoice();
        inv.setId(id);
        inv.setInvoiceCode("INV-20261024-00001");
        inv.setTotalAmount(finalAmount);
        inv.setDiscountAmount(BigDecimal.ZERO);
        inv.setFinalAmount(finalAmount);
        inv.setStatus(status);
        inv.setDueDate(LocalDate.now().plusDays(7));
        inv.setCreatedAt(LocalDateTime.now().minusDays(1));
        inv.setUpdatedAt(LocalDateTime.now().minusDays(1));

        Student s = new Student();
        s.setId(10L);
        s.setFullName("Nguyễn Văn Học Trò");
        s.setPhone("0912345678");
        s.setEmail("hoctro@example.com");
        inv.setStudent(s);

        EduClass c = new EduClass();
        c.setId(100L);
        c.setCode("CLS-MATH10");
        c.setName("Lớp Toán 10 Nâng Cao");

        Enrollment e = new Enrollment();
        e.setId(50L);
        e.setStudent(s);
        e.setEduClass(c);
        inv.setEnrollment(e);

        return inv;
    }

    private User createMockStaffUser(Long id, String name) {
        User u = new User();
        u.setId(id);
        u.setEmail("accountant@educenter.vn");
        u.setFullName(name);
        return u;
    }

    @Test
    @DisplayName("ADM-15: Thu một phần tiền mặt thủ công chuyển trạng thái hóa đơn sang PARTIALLY_PAID")
    void testRecordPayment_PartialAmount_ChangesStatusToPartiallyPaid() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("3000000"), "UNPAID");
        mockRepo.invoice = inv;
        mockRepo.currentPaidAmount = BigDecimal.ZERO;

        stubEm.staffUser = createMockStaffUser(5L, "Kế toán viên A");

        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("1000000"));
        form.setPaymentMethod("CASH");
        form.setNotes("Thu tiền mặt đợt 1 tại quầy");

        PaymentRecordDTO result = paymentService.recordManualPayment(form, 5L);

        assertNotNull(result);
        assertEquals(new BigDecimal("1000000"), result.getAmount());
        assertEquals("CASH", result.getPaymentMethod());
        assertEquals("CONFIRMED", result.getStatus());
        assertEquals("PARTIALLY_PAID", inv.getStatus());
        assertEquals(1, mockRepo.savedPayments.size());
        assertTrue(stubEm.tx.committed);
    }

    @Test
    @DisplayName("ADM-15: Thu chuyển khoản đủ tiền còn lại chuyển trạng thái hóa đơn sang PAID")
    void testRecordPayment_FullAmount_ChangesStatusToPaid() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("2500000"), "PARTIALLY_PAID");
        mockRepo.invoice = inv;
        mockRepo.currentPaidAmount = new BigDecimal("1000000"); // Đã đóng 1tr, còn nợ 1.5tr

        stubEm.staffUser = createMockStaffUser(5L, "Kế toán viên A");

        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("1500000"));
        form.setPaymentMethod("BANK_TRANSFER");
        form.setTransactionRef("MB-FT2610249999");
        form.setNotes("Chuyển khoản sao kê MB Bank khớp lệnh");

        PaymentRecordDTO result = paymentService.recordManualPayment(form, 5L);

        assertNotNull(result);
        assertEquals(new BigDecimal("1500000"), result.getAmount());
        assertEquals("BANK_TRANSFER", result.getPaymentMethod());
        assertEquals("MB-FT2610249999", result.getTransactionRef());
        assertEquals("PAID", inv.getStatus());
        assertTrue(stubEm.tx.committed);
    }

    @Test
    @DisplayName("BR14: Chặn thu số tiền vượt quá số nợ còn lại của hóa đơn")
    void testRecordPayment_ExceedingDebt_ThrowsValidationException() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("2000000"), "UNPAID");
        mockRepo.invoice = inv;
        mockRepo.currentPaidAmount = new BigDecimal("1500000"); // Còn nợ 500,000 đ

        stubEm.staffUser = createMockStaffUser(5L, "Kế toán viên A");

        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("800000")); // Thu 800k > 500k nợ
        form.setPaymentMethod("CASH");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                paymentService.recordManualPayment(form, 5L)
        );
        assertTrue(ex.getMessage().contains("vượt quá số nợ còn lại"));
    }

    @Test
    @DisplayName("Validation: Chặn số tiền thu nhỏ hơn hoặc bằng 0")
    void testRecordPayment_ZeroOrNegativeAmount_ThrowsValidationException() {
        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("0"));
        form.setPaymentMethod("CASH");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                paymentService.recordManualPayment(form, 5L)
        );
        assertTrue(ex.getMessage().contains("lớn hơn 0"));
    }

    @Test
    @DisplayName("Duyệt tay: Chặn phương thức thanh toán không hợp lệ (ngoài CASH / BANK_TRANSFER)")
    void testRecordPayment_InvalidPaymentMethod_ThrowsValidationException() {
        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("500000"));
        form.setPaymentMethod("BITCOIN"); // Không hợp lệ

        ValidationException ex = assertThrows(ValidationException.class, () ->
                paymentService.recordManualPayment(form, 5L)
        );
        assertTrue(ex.getMessage().contains("Phương thức thanh toán chỉ chấp nhận"));
    }

    @Test
    @DisplayName("ADM-15: Chặn thu tiền đối với hóa đơn đã thanh toán đầy đủ (PAID)")
    void testRecordPayment_AlreadyPaidInvoice_ThrowsValidationException() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("2000000"), "PAID");
        mockRepo.invoice = inv;
        mockRepo.currentPaidAmount = new BigDecimal("2000000");

        stubEm.staffUser = createMockStaffUser(5L, "Kế toán viên A");

        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("500000"));
        form.setPaymentMethod("CASH");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                paymentService.recordManualPayment(form, 5L)
        );
        assertTrue(ex.getMessage().contains("đã được thanh toán đầy đủ"));
    }

    @Test
    @DisplayName("ADM-15: Chặn thu tiền đối với hóa đơn đã bị hủy (CANCELLED)")
    void testRecordPayment_CancelledInvoice_ThrowsValidationException() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("2000000"), "CANCELLED");
        mockRepo.invoice = inv;

        stubEm.staffUser = createMockStaffUser(5L, "Kế toán viên A");

        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(1L);
        form.setAmount(new BigDecimal("500000"));
        form.setPaymentMethod("CASH");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                paymentService.recordManualPayment(form, 5L)
        );
        assertTrue(ex.getMessage().contains("Hóa đơn đã bị hủy"));
    }

    @Test
    @DisplayName("ADM-15: Xem chi tiết hóa đơn kèm danh sách khoản mục và lịch sử thanh toán")
    void testGetInvoiceDetail_Success() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("2000000"), "PARTIALLY_PAID");
        mockRepo.invoice = inv;
        mockRepo.currentPaidAmount = new BigDecimal("500000");

        InvoiceDetailDTO detail = paymentService.getInvoiceDetail(1L);

        assertNotNull(detail);
        assertEquals("INV-20261024-00001", detail.getInvoiceCode());
        assertEquals("HV0010", detail.getStudentCode());
        assertEquals("Nguyễn Văn Học Trò", detail.getStudentName());
        assertEquals("CLS-MATH10", detail.getClassCode());
        assertEquals(new BigDecimal("2000000"), detail.getFinalAmount());
        assertEquals(new BigDecimal("500000"), detail.getPaidAmount());
        assertEquals(new BigDecimal("1500000"), detail.getDebtAmount());
        assertEquals("Nguyễn Văn Phụ Huynh", detail.getGuardianName());
        assertEquals(1, detail.getItems().size());
    }

    @Test
    @DisplayName("ADM-15: Lấy thông tin phiếu thu phục vụ in biên lai")
    void testGetPaymentReceipt_Success() {
        Invoice inv = createMockInvoice(1L, new BigDecimal("2000000"), "PAID");

        Payment p = new Payment();
        p.setId(99L);
        p.setPaymentCode("PAY-20261024-ABCDE");
        p.setInvoice(inv);
        p.setAmount(new BigDecimal("2000000"));
        p.setPaymentMethod("CASH");
        p.setPaidAt(LocalDateTime.now());
        p.setConfirmedBy(createMockStaffUser(5L, "Kế toán Trưởng"));
        p.setNotes("Phiếu thu học phí cả khóa");
        p.setStatus("CONFIRMED");

        mockRepo.singlePayment = p;
        mockRepo.currentPaidAmount = new BigDecimal("2000000");

        ReceiptViewDTO receipt = paymentService.getPaymentReceipt(99L);

        assertNotNull(receipt);
        assertEquals("PAY-20261024-ABCDE", receipt.getPaymentCode());
        assertEquals(new BigDecimal("2000000"), receipt.getPaymentAmount());
        assertEquals("CASH", receipt.getPaymentMethod());
        assertEquals("Kế toán Trưởng", receipt.getCashierName());
        assertEquals("Nguyễn Văn Học Trò", receipt.getStudentName());
        assertEquals(BigDecimal.ZERO, receipt.getRemainingDebtAmount());
    }
}
