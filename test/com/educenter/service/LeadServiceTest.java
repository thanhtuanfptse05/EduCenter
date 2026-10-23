package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Consultation;
import com.educenter.entity.Lead;
import com.educenter.entity.User;
import com.educenter.repository.LeadRepository;
import jakarta.persistence.*;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaDelete;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.CriteriaUpdate;
import jakarta.persistence.metamodel.Metamodel;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("LeadService — CRM Lead Management Tests (ADM-02, ADM-03)")
public class LeadServiceTest {

    private LeadServiceImpl leadService;
    private MockLeadRepository mockRepo;
    private StubEntityManager stubEm;

    static class MockLeadRepository extends LeadRepository {
        Map<Long, Lead> leadStore = new HashMap<>();
        List<Consultation> consultationStore = new ArrayList<>();
        List<User> staffStore = new ArrayList<>();
        long nextId = 1L;

        @Override
        public Lead save(EntityManager em, Lead lead) {
            if (lead.getId() == null) {
                lead.setId(nextId++);
            }
            leadStore.put(lead.getId(), lead);
            return lead;
        }

        @Override
        public Optional<Lead> findById(EntityManager em, Long id) {
            return Optional.ofNullable(leadStore.get(id));
        }

        @Override
        public List<Lead> findLeads(EntityManager em, LeadFilterDTO filter) {
            return new ArrayList<>(leadStore.values());
        }

        @Override
        public long countLeads(EntityManager em, LeadFilterDTO filter) {
            return leadStore.size();
        }

        @Override
        public Map<String, Long> getLeadStats(EntityManager em) {
            Map<String, Long> stats = new HashMap<>();
            stats.put("total", (long) leadStore.size());
            stats.put("new", leadStore.values().stream().filter(l -> "NEW".equals(l.getStatus())).count());
            stats.put("consulting", leadStore.values().stream().filter(l -> "CONSULTING".equals(l.getStatus()) || "CONTACTED".equals(l.getStatus())).count());
            stats.put("enrolled", leadStore.values().stream().filter(l -> "ENROLLED".equals(l.getStatus())).count());
            stats.put("lost", leadStore.values().stream().filter(l -> "LOST".equals(l.getStatus())).count());
            return stats;
        }

        @Override
        public List<Consultation> findConsultationsByLeadId(EntityManager em, Long leadId) {
            List<Consultation> result = new ArrayList<>();
            for (Consultation c : consultationStore) {
                if (c.getLead() != null && c.getLead().getId().equals(leadId)) {
                    result.add(c);
                }
            }
            return result;
        }

        @Override
        public Consultation saveConsultation(EntityManager em, Consultation c) {
            c.setId(nextId++);
            consultationStore.add(c);
            return c;
        }

        @Override
        public List<User> findStaffUsers(EntityManager em) {
            return staffStore;
        }
    }

    @BeforeEach
    void setUp() {
        mockRepo = new MockLeadRepository();
        stubEm = new StubEntityManager();
        leadService = new LeadServiceImpl(mockRepo, () -> stubEm);
    }

    @Test
    @DisplayName("Tạo Lead thành công với đầy đủ thông tin hợp lệ")
    void testCreateLeadSuccess() {
        LeadCreateFormDTO form = new LeadCreateFormDTO();
        form.setName("Nguyễn Văn An");
        form.setPhone("0912345678");
        form.setEmail("an.nguyen@gmail.com");
        form.setGradeLevel(10);
        form.setSource("HOTLINE");
        form.setNotes("Khách muốn học thêm Toán");

        UserPrincipalDTO staffUser = new UserPrincipalDTO(10L, "staff@educenter.vn", "Staff", "0912345678", null, "ACTIVE", Set.of("STAFF"));

        Lead created = leadService.createLead(form, staffUser);

        assertNotNull(created);
        assertNotNull(created.getId());
        assertEquals("Nguyễn Văn An", created.getName());
        assertEquals("0912345678", created.getPhone());
        assertEquals("an.nguyen@gmail.com", created.getEmail());
        assertEquals(10, created.getGradeLevel());
        assertEquals("HOTLINE", created.getSource());
        assertEquals("NEW", created.getStatus());
    }

    @Test
    @DisplayName("Ném lỗi khi số điện thoại không hợp lệ")
    void testCreateLeadInvalidPhone() {
        LeadCreateFormDTO form = new LeadCreateFormDTO();
        form.setName("Trần Thị B");
        form.setPhone("12345"); // Thiếu số và sai đầu số

        ValidationException ex = assertThrows(ValidationException.class, () ->
                leadService.createLead(form, null)
        );
        assertTrue(ex.getMessage().contains("Số điện thoại không hợp lệ"));
    }

    @Test
    @DisplayName("Ném lỗi khi tên để trống")
    void testCreateLeadMissingName() {
        LeadCreateFormDTO form = new LeadCreateFormDTO();
        form.setName("   ");
        form.setPhone("0987654321");

        ValidationException ex = assertThrows(ValidationException.class, () ->
                leadService.createLead(form, null)
        );
        assertTrue(ex.getMessage().contains("Họ và tên"));
    }

    @Test
    @DisplayName("Ném lỗi khi khối lớp ngoài 6-12")
    void testCreateLeadInvalidGrade() {
        LeadCreateFormDTO form = new LeadCreateFormDTO();
        form.setName("Lê Văn C");
        form.setPhone("0987654321");
        form.setGradeLevel(5); // ngoài khoảng 6-12

        ValidationException ex = assertThrows(ValidationException.class, () ->
                leadService.createLead(form, null)
        );
        assertTrue(ex.getMessage().contains("Khối lớp"));
    }

    @Test
    @DisplayName("Cập nhật trạng thái Lead sang CONSULTING thành công")
    void testUpdateLeadStatusSuccess() {
        Lead lead = new Lead();
        lead.setName("Khách Mới");
        lead.setPhone("0933221100");
        lead.setStatus("NEW");
        lead = mockRepo.save(stubEm, lead);

        UserPrincipalDTO staff = new UserPrincipalDTO(5L, "staff5@educenter.vn", "Staff 5", "0912345678", null, "ACTIVE", Set.of("STAFF"));

        leadService.updateLeadStatus(lead.getId(), "CONSULTING", "Đã tư vấn qua điện thoại", null, staff);

        Lead updated = mockRepo.findById(stubEm, lead.getId()).orElse(null);
        assertNotNull(updated);
        assertEquals("CONSULTING", updated.getStatus());
        assertTrue(updated.getNotes().contains("Đã tư vấn qua điện thoại"));
    }

    @Test
    @DisplayName("Ném lỗi khi cập nhật trạng thái không hợp lệ")
    void testUpdateLeadStatusInvalid() {
        Lead lead = new Lead();
        lead.setName("Khách Test");
        lead.setPhone("0933221100");
        lead.setStatus("NEW");
        Lead savedLead = mockRepo.save(stubEm, lead);

        ValidationException ex = assertThrows(ValidationException.class, () ->
                leadService.updateLeadStatus(savedLead.getId(), "INVALID_STATE", "Ghi chú", null, null)
        );
        assertTrue(ex.getMessage().contains("không hợp lệ"));
    }

    @Test
    @DisplayName("Thêm nhật ký tư vấn tự động chuyển trạng thái Lead từ NEW sang CONTACTED")
    void testAddConsultationSuccess() {
        Lead lead = new Lead();
        lead.setName("Phụ huynh Mai");
        lead.setPhone("0977889900");
        lead.setStatus("NEW");
        lead = mockRepo.save(stubEm, lead);

        User staffUser = new User();
        staffUser.setId(2L);
        staffUser.setFullName("Nhân viên tư vấn Hà");
        stubEm.mockUsers.put(2L, staffUser);

        UserPrincipalDTO staffPrincipal = new UserPrincipalDTO(2L, "ha.staff@educenter.vn", "Nhân viên tư vấn Hà", "0912345678", null, "ACTIVE", Set.of("STAFF"));

        ConsultationFormDTO form = new ConsultationFormDTO();
        form.setLeadId(lead.getId());
        form.setNotes("Phụ huynh quan tâm khóa Tiếng Anh 9");
        form.setNextAppointmentStr("2026-11-01T09:00");

        leadService.addConsultation(form, staffPrincipal);

        Lead updated = mockRepo.findById(stubEm, lead.getId()).orElse(null);
        assertNotNull(updated);
        assertEquals("CONTACTED", updated.getStatus());

        List<Consultation> consultations = mockRepo.findConsultationsByLeadId(stubEm, lead.getId());
        assertEquals(1, consultations.size());
        assertEquals("Phụ huynh quan tâm khóa Tiếng Anh 9", consultations.get(0).getNotes());
        assertEquals("Nhân viên tư vấn Hà", consultations.get(0).getStaff().getFullName());
    }

    @Test
    @DisplayName("Lấy chi tiết Lead trả về đầy đủ DTO và lịch sử tư vấn")
    void testGetLeadDetailSuccess() {
        Lead lead = new Lead();
        lead.setName("Chi Tiết Khách");
        lead.setPhone("0911223344");
        lead.setStatus("CONSULTING");
        lead = mockRepo.save(stubEm, lead);

        LeadDetailDTO detail = leadService.getLeadDetail(lead.getId());
        assertNotNull(detail);
        assertEquals("Chi Tiết Khách", detail.getName());
        assertEquals("CONSULTING", detail.getStatus());
        assertEquals("Đang tư vấn", detail.getStatusDisplayName());
    }

    // ==========================================
    // STUB ENTITY MANAGER FOR PURE JUNIT 5
    // ==========================================
    static class StubEntityManager implements EntityManager {
        Map<Long, User> mockUsers = new HashMap<>();
        StubEntityTransaction tx = new StubEntityTransaction();

        @Override public void persist(Object entity) {}
        @Override public <T> T merge(T entity) { return entity; }
        @Override public void remove(Object entity) {}
        @Override
        public <T> T find(Class<T> entityClass, Object primaryKey) {
            if (entityClass == User.class) {
                return (T) mockUsers.get(primaryKey);
            }
            return null;
        }
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
        @Override public EntityTransaction getTransaction() { return tx; }
        @Override public EntityManagerFactory getEntityManagerFactory() { return null; }
        @Override public CriteriaBuilder getCriteriaBuilder() { return null; }
        @Override public Metamodel getMetamodel() { return null; }
        @Override public <T> EntityGraph<T> createEntityGraph(Class<T> rootType) { return null; }
        @Override public EntityGraph<?> createEntityGraph(String graphName) { return null; }
        @Override public EntityGraph<?> getEntityGraph(String graphName) { return null; }
        @Override public <T> List<EntityGraph<? super T>> getEntityGraphs(Class<T> entityClass) { return Collections.emptyList(); }
    }

    static class StubEntityTransaction implements EntityTransaction {
        private boolean active = false;
        @Override public void begin() { active = true; }
        @Override public void commit() { active = false; }
        @Override public void rollback() { active = false; }
        @Override public void setRollbackOnly() {}
        @Override public boolean getRollbackOnly() { return false; }
        @Override public boolean isActive() { return active; }
    }
}
