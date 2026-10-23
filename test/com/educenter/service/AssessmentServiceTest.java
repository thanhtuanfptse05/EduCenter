package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.AssessmentRepository;
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
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("AssessmentService — Teacher Assessment and Grading Tests (TCH-05, TCH-06)")
public class AssessmentServiceTest {

    private AssessmentServiceImpl assessmentService;
    private MockAssessmentRepository mockRepo;
    private StubEntityManager stubEm;

    static class MockAssessmentRepository extends AssessmentRepository {
        Assessment assessment;
        List<Student> students = new ArrayList<>();
        List<AssessmentScore> scores = new ArrayList<>();

        @Override
        public Optional<Assessment> findAssessmentById(EntityManager em, Long id) {
            if (assessment != null && assessment.getId().equals(id)) {
                return Optional.of(assessment);
            }
            return Optional.empty();
        }

        @Override
        public List<Student> findActiveStudentsInClass(EntityManager em, Long classId) {
            return students;
        }

        @Override
        public List<AssessmentScore> findScoresByAssessmentId(EntityManager em, Long assessmentId) {
            return scores;
        }

        @Override
        public Optional<AssessmentScore> findScore(EntityManager em, Long assessmentId, Long studentId) {
            return scores.stream().filter(s -> s.getStudent().getId().equals(studentId)).findFirst();
        }

        @Override
        public void saveAssessment(EntityManager em, Assessment a) {
            a.setId(100L);
            this.assessment = a;
        }

        @Override
        public void updateAssessment(EntityManager em, Assessment a) {
            this.assessment = a;
        }

        @Override
        public void saveScore(EntityManager em, AssessmentScore s) {
            s.setId((long) (scores.size() + 1));
            scores.add(s);
        }

        @Override
        public void updateScore(EntityManager em, AssessmentScore s) {
            // Updated in-place
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
        EduClass eduClass;
        Student student;
        User user;
        final StubEntityTransaction tx = new StubEntityTransaction();

        @SuppressWarnings("unchecked")
        @Override
        public <T> T find(Class<T> entityClass, Object primaryKey) {
            if (entityClass == EduClass.class && eduClass != null && eduClass.getId().equals(primaryKey)) {
                return (T) eduClass;
            }
            if (entityClass == Student.class && student != null && student.getId().equals(primaryKey)) {
                return (T) student;
            }
            if (entityClass == User.class && user != null && user.getId().equals(primaryKey)) {
                return (T) user;
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
        mockRepo = new MockAssessmentRepository();
        stubEm = new StubEntityManager();

        assessmentService = new AssessmentServiceImpl(mockRepo) {
            @Override
            protected EntityManager getEntityManager() {
                return stubEm;
            }
        };
    }

    private EduClass createMockClass(Long id, Long teacherUserId) {
        EduClass c = new EduClass();
        c.setId(id);
        c.setCode("CLS-MATH10");
        c.setName("Lớp Toán 10 Nâng Cao");

        User u = new User();
        u.setId(teacherUserId);
        u.setFullName("Thầy Nguyễn Văn A");

        Teacher t = new Teacher();
        t.setId(10L);
        t.setUser(u);
        c.setTeacher(t);

        Course cr = new Course();
        cr.setId(1L);
        Subject s = new Subject();
        s.setName("Toán học");
        cr.setSubject(s);
        c.setCourse(cr);

        return c;
    }

    private Student createMockStudent(Long id, String name) {
        Student s = new Student();
        s.setId(id);
        s.setFullName(name);
        s.setPhone("0912345678");
        return s;
    }

    @Test
    @DisplayName("TCH-05: Giáo viên tạo bài kiểm tra mới thành công với trạng thái DRAFT")
    void testCreateAssessment_Success() {
        EduClass c = createMockClass(10L, 5L);
        stubEm.eduClass = c;

        AssessmentFormDTO form = new AssessmentFormDTO();
        form.setClassId(10L);
        form.setTitle("Kiểm tra 15 phút Số học");
        form.setAssessmentType("15_MIN");
        form.setMaxScore(new BigDecimal("10.00"));
        form.setWeight(new BigDecimal("1.00"));
        form.setTestDate(LocalDate.now());

        Long id = assessmentService.createAssessment(form, 5L, false);

        assertNotNull(id);
        assertNotNull(mockRepo.assessment);
        assertEquals("Kiểm tra 15 phút Số học", mockRepo.assessment.getTitle());
        assertEquals("DRAFT", mockRepo.assessment.getStatus());
        assertTrue(stubEm.tx.committed);
    }

    @Test
    @DisplayName("BR09: Chặn tạo bài kiểm tra có thang điểm tối đa (max_score) <= 0")
    void testCreateAssessment_InvalidMaxScore_ThrowsValidationException() {
        AssessmentFormDTO form = new AssessmentFormDTO();
        form.setClassId(10L);
        form.setTitle("Kiểm tra vi phạm thang điểm");
        form.setMaxScore(new BigDecimal("0")); // Invalid

        ValidationException ex = assertThrows(ValidationException.class, () ->
                assessmentService.createAssessment(form, 5L, false)
        );
        assertTrue(ex.getMessage().contains("phải lớn hơn 0"));
    }

    @Test
    @DisplayName("BR18: Chặn giáo viên tạo bài kiểm tra cho lớp mình không phụ trách")
    void testCreateAssessment_UnauthorizedTeacher_ThrowsValidationException() {
        EduClass c = createMockClass(10L, 99L); // Lớp thuộc về Thầy khác (UserID 99)
        stubEm.eduClass = c;

        AssessmentFormDTO form = new AssessmentFormDTO();
        form.setClassId(10L);
        form.setTitle("Kiểm tra trái quyền");
        form.setMaxScore(new BigDecimal("10.00"));
        form.setWeight(new BigDecimal("1.00"));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                assessmentService.createAssessment(form, 5L, false) // UserID 5 cố tình tạo
        );
        assertTrue(ex.getMessage().contains("không được phân công"));
    }

    @Test
    @DisplayName("TCH-06: Giáo viên nhập điểm hợp lệ cho học sinh trong lớp")
    void testSaveScores_ValidScore_SavedSuccessfully() {
        EduClass c = createMockClass(10L, 5L);
        stubEm.eduClass = c;

        Assessment a = new Assessment();
        a.setId(1L);
        a.setEduClass(c);
        a.setTitle("Kiểm tra 1 tiết Đại số");
        a.setMaxScore(new BigDecimal("10.00"));
        a.setStatus("DRAFT");
        mockRepo.assessment = a;

        Student s = createMockStudent(20L, "Trần Văn Bình");
        mockRepo.students.add(s);
        stubEm.student = s;
        stubEm.user = c.getTeacher().getUser();

        StudentScoreItemDTO scoreItem = new StudentScoreItemDTO();
        scoreItem.setStudentId(20L);
        scoreItem.setScore(new BigDecimal("8.50"));
        scoreItem.setRemarks("Làm bài tốt, trình bày sạch sẽ");

        assessmentService.saveScores(1L, Collections.singletonList(scoreItem), 5L, false);

        assertEquals(1, mockRepo.scores.size());
        assertEquals(new BigDecimal("8.50"), mockRepo.scores.get(0).getScore());
        assertTrue(stubEm.tx.committed);
    }

    @Test
    @DisplayName("BR09: Chặn nhập điểm vượt quá thang điểm tối đa (score > max_score)")
    void testSaveScores_ScoreExceedingMaxScore_ThrowsValidationException() {
        EduClass c = createMockClass(10L, 5L);
        stubEm.eduClass = c;

        Assessment a = new Assessment();
        a.setId(1L);
        a.setEduClass(c);
        a.setMaxScore(new BigDecimal("10.00"));
        a.setStatus("DRAFT");
        mockRepo.assessment = a;

        Student s = createMockStudent(20L, "Trần Văn Bình");
        mockRepo.students.add(s);
        stubEm.student = s;

        StudentScoreItemDTO scoreItem = new StudentScoreItemDTO();
        scoreItem.setStudentId(20L);
        scoreItem.setScore(new BigDecimal("10.50")); // Vượt quá 10.00

        ValidationException ex = assertThrows(ValidationException.class, () ->
                assessmentService.saveScores(1L, Collections.singletonList(scoreItem), 5L, false)
        );
        assertTrue(ex.getMessage().contains("phải từ 0 đến 10.00"));
    }

    @Test
    @DisplayName("TCH-06: Công bố bài kiểm tra (PUBLISHED) khi đã có điểm số")
    void testPublishAssessment_Success() {
        EduClass c = createMockClass(10L, 5L);
        stubEm.eduClass = c;

        Assessment a = new Assessment();
        a.setId(1L);
        a.setEduClass(c);
        a.setStatus("DRAFT");
        mockRepo.assessment = a;

        AssessmentScore sc = new AssessmentScore();
        sc.setId(1L);
        sc.setScore(new BigDecimal("9.00"));
        mockRepo.scores.add(sc);

        assessmentService.publishAssessment(1L, 5L, false);

        assertEquals("PUBLISHED", a.getStatus());
        assertTrue(stubEm.tx.committed);
    }

    @Test
    @DisplayName("BR11: Chặn công bố bài kiểm tra khi chưa có bất kỳ điểm số nào")
    void testPublishAssessment_EmptyScores_ThrowsValidationException() {
        EduClass c = createMockClass(10L, 5L);
        stubEm.eduClass = c;

        Assessment a = new Assessment();
        a.setId(1L);
        a.setEduClass(c);
        a.setStatus("DRAFT");
        mockRepo.assessment = a;
        mockRepo.scores.clear(); // Chưa có điểm

        ValidationException ex = assertThrows(ValidationException.class, () ->
                assessmentService.publishAssessment(1L, 5L, false)
        );
        assertTrue(ex.getMessage().contains("chưa có bất kỳ điểm số nào"));
    }

    @Test
    @DisplayName("BR18: Chỉ ADMIN mới có quyền mở lại bài kiểm tra đã công bố về DRAFT")
    void testReopenAssessment_AdminOnly() {
        EduClass c = createMockClass(10L, 5L);
        stubEm.eduClass = c;

        Assessment a = new Assessment();
        a.setId(1L);
        a.setEduClass(c);
        a.setStatus("PUBLISHED");
        mockRepo.assessment = a;

        // Giáo viên thường cố tình reopen -> Bị từ chối
        assertThrows(ValidationException.class, () ->
                assessmentService.reopenAssessment(1L, 5L, false, "Muốn sửa điểm")
        );

        // Admin mở lại có lý do hợp lệ -> Thành công
        assessmentService.reopenAssessment(1L, 1L, true, "Cần sửa điểm phúc khảo cho học sinh");
        assertEquals("DRAFT", a.getStatus());
        assertTrue(stubEm.tx.committed);
    }
}
