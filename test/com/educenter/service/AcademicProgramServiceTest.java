package com.educenter.service;

import com.educenter.dto.CourseAdminStatsDTO;
import com.educenter.dto.CourseAdminViewDTO;
import com.educenter.dto.CourseFilterDTO;
import com.educenter.dto.CourseFormDTO;
import com.educenter.dto.SubjectAdminViewDTO;
import com.educenter.dto.SubjectFormDTO;
import com.educenter.entity.AuditLog;
import com.educenter.entity.Course;
import com.educenter.entity.Subject;
import com.educenter.service.ValidationException;
import com.educenter.repository.AuditLogRepository;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.SubjectRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("AcademicProgramService — Subjects & Courses Management Tests (M04, UC11, BR16, BR18)")
public class AcademicProgramServiceTest {

    private AcademicProgramService academicService;
    private MockSubjectRepository mockSubjectRepo;
    private MockCourseRepository mockCourseRepo;
    private MockAuditLogRepository mockAuditLogRepo;

    static class MockSubjectRepository extends SubjectRepository {
        Map<Long, Subject> storage = new HashMap<>();
        AtomicLong idGen = new AtomicLong(100);

        @Override
        public List<Subject> findAllActive(EntityManager em) {
            List<Subject> list = new ArrayList<>();
            for (Subject s : storage.values()) {
                if ("ACTIVE".equalsIgnoreCase(s.getStatus())) list.add(s);
            }
            return list;
        }

        @Override
        public List<Subject> findAllAdmin(EntityManager em) {
            return new ArrayList<>(storage.values());
        }

        @Override
        public Optional<Subject> findById(EntityManager em, Long id) {
            return Optional.ofNullable(storage.get(id));
        }

        @Override
        public Optional<Subject> findByCode(EntityManager em, String code) {
            if (code == null) return Optional.empty();
            return storage.values().stream()
                    .filter(s -> code.trim().equalsIgnoreCase(s.getCode()))
                    .findFirst();
        }

        @Override
        public boolean existsByCode(EntityManager em, String code, Long excludeId) {
            if (code == null) return false;
            return storage.values().stream()
                    .filter(s -> code.trim().equalsIgnoreCase(s.getCode()))
                    .anyMatch(s -> excludeId == null || !s.getId().equals(excludeId));
        }

        @Override
        public Subject save(EntityManager em, Subject subject) {
            if (subject.getId() == null) {
                subject.setId(idGen.incrementAndGet());
            }
            storage.put(subject.getId(), subject);
            return subject;
        }

        @Override
        public Subject update(EntityManager em, Subject subject) {
            storage.put(subject.getId(), subject);
            return subject;
        }

        @Override
        public long countCoursesBySubject(EntityManager em, Long subjectId) {
            return 0L;
        }

        @Override
        public long countOpenCoursesBySubject(EntityManager em, Long subjectId) {
            // Stubbed via test field if needed
            return openCountBySubject.getOrDefault(subjectId, 0L);
        }

        Map<Long, Long> openCountBySubject = new HashMap<>();
    }

    static class MockCourseRepository extends CourseRepository {
        Map<Long, Course> storage = new HashMap<>();
        AtomicLong idGen = new AtomicLong(200);

        @Override
        public List<Course> findAdminCourses(EntityManager em, CourseFilterDTO filter) {
            return new ArrayList<>(storage.values());
        }

        @Override
        public long countAdminCourses(EntityManager em, CourseFilterDTO filter) {
            return storage.size();
        }

        @Override
        public CourseAdminStatsDTO getAdminStats(EntityManager em) {
            long total = storage.size();
            long open = storage.values().stream().filter(c -> "OPEN".equals(c.getStatus())).count();
            long closed = storage.values().stream().filter(c -> "CLOSED".equals(c.getStatus())).count();
            long archived = storage.values().stream().filter(c -> "ARCHIVED".equals(c.getStatus())).count();
            return new CourseAdminStatsDTO(total, open, closed, archived, 5L, 4L);
        }

        @Override
        public Optional<Course> findById(EntityManager em, Long id) {
            return Optional.ofNullable(storage.get(id));
        }

        @Override
        public boolean existsByCode(EntityManager em, String code, Long excludeId) {
            if (code == null) return false;
            return storage.values().stream()
                    .filter(c -> code.trim().equalsIgnoreCase(c.getCode()))
                    .anyMatch(c -> excludeId == null || !c.getId().equals(excludeId));
        }

        @Override
        public Course save(EntityManager em, Course course) {
            if (course.getId() == null) {
                course.setId(idGen.incrementAndGet());
            }
            storage.put(course.getId(), course);
            return course;
        }

        @Override
        public Course update(EntityManager em, Course course) {
            storage.put(course.getId(), course);
            return course;
        }

        @Override
        public long countClassesByCourse(EntityManager em, Long courseId) {
            return 2L;
        }

        @Override
        public long countOpenClassesByCourse(EntityManager em, Long courseId) {
            return 1L;
        }
    }

    static class MockAuditLogRepository extends AuditLogRepository {
        List<AuditLog> logs = new ArrayList<>();

        @Override
        public void save(EntityManager em, AuditLog log) {
            logs.add(log);
        }

        @Override
        public List<AuditLog> findRecentLogs(EntityManager em, int limit) {
            return new ArrayList<>(logs);
        }
    }

    static EntityManager createMockEntityManager() {
        EntityTransaction mockTx = (EntityTransaction) Proxy.newProxyInstance(
                EntityTransaction.class.getClassLoader(),
                new Class<?>[]{EntityTransaction.class},
                (proxy, method, args) -> {
                    if ("isActive".equals(method.getName())) return false;
                    return null;
                }
        );
        return (EntityManager) Proxy.newProxyInstance(
                EntityManager.class.getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("getTransaction".equals(method.getName())) return mockTx;
                    if ("close".equals(method.getName())) return null;
                    return null;
                }
        );
    }

    @BeforeEach
    void setUp() {
        mockSubjectRepo = new MockSubjectRepository();
        mockCourseRepo = new MockCourseRepository();
        mockAuditLogRepo = new MockAuditLogRepository();

        // Seed Active Subject: MATH
        Subject math = new Subject();
        math.setId(1L);
        math.setCode("MATH");
        math.setName("Toán học");
        math.setStatus("ACTIVE");
        mockSubjectRepo.storage.put(1L, math);

        // Seed Inactive Subject: HIST
        Subject hist = new Subject();
        hist.setId(2L);
        hist.setCode("HIST");
        hist.setName("Lịch sử");
        hist.setStatus("INACTIVE");
        mockSubjectRepo.storage.put(2L, hist);

        // Seed Course: MATH-10
        Course course1 = new Course();
        course1.setId(10L);
        course1.setSubject(math);
        course1.setCode("MATH-10");
        course1.setName("Toán 10 Cơ Bản");
        course1.setGradeLevel(10);
        course1.setFee(new BigDecimal("3000000"));
        course1.setDurationWeeks(12);
        course1.setTotalSessions(24);
        course1.setMaxCapacity(15);
        course1.setStatus("OPEN");
        mockCourseRepo.storage.put(10L, course1);

        academicService = new AcademicProgramServiceImpl(
                mockSubjectRepo,
                mockCourseRepo,
                mockAuditLogRepo,
                AcademicProgramServiceTest::createMockEntityManager
        );
    }

    @Test
    @DisplayName("Tạo môn học hợp lệ: Lưu dữ liệu và ghi AuditLog thành công")
    void testSaveSubject_Valid_PersistsAndAudits() {
        SubjectFormDTO dto = new SubjectFormDTO(null, "PHYS", "Vật lý", "Môn Vật lý", "ACTIVE");
        academicService.saveSubject(dto, 1L, "staff@educenter.vn", "127.0.0.1");

        assertTrue(mockSubjectRepo.existsByCode(null, "PHYS", null));
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("CREATE_SUBJECT", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Tạo môn học trùng mã: Ném ValidationException")
    void testSaveSubject_DuplicateCode_ThrowsException() {
        SubjectFormDTO dto = new SubjectFormDTO(null, "math", "Toán ứng dụng", "Mô tả", "ACTIVE");
        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.saveSubject(dto, 1L, "staff@educenter.vn", "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("đã tồn tại"));
    }

    @Test
    @DisplayName("BR16: Ngừng môn học bị chặn khi còn khóa học đang OPEN")
    void testToggleSubjectStatus_ActiveToInactive_BlockedWhenOpenCoursesExist() {
        mockSubjectRepo.openCountBySubject.put(1L, 2L); // Subject MATH đang có 2 khóa OPEN

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.toggleSubjectStatus(1L, 1L, "staff@educenter.vn", "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("Không thể ngừng môn học đang có 2 khóa học mở"));
    }

    @Test
    @DisplayName("Ngừng môn học thành công khi không còn khóa học OPEN nào")
    void testToggleSubjectStatus_SuccessWhenNoOpenCourses() {
        mockSubjectRepo.openCountBySubject.put(1L, 0L);

        academicService.toggleSubjectStatus(1L, 1L, "staff@educenter.vn", "127.0.0.1");

        Subject s = mockSubjectRepo.storage.get(1L);
        assertEquals("INACTIVE", s.getStatus());
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("TOGGLE_SUBJECT_STATUS", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Tạo khóa học hợp lệ: Lưu thành công và ghi AuditLog")
    void testSaveCourse_Valid_PersistsAndAudits() {
        CourseFormDTO dto = new CourseFormDTO();
        dto.setCode("MATH-11-ADV");
        dto.setName("Toán 11 Nâng cao");
        dto.setSubjectId(1L); // MATH is ACTIVE
        dto.setGradeLevel(11);
        dto.setFee(new BigDecimal("3500000"));
        dto.setDurationWeeks(14);
        dto.setTotalSessions(28);
        dto.setMaxCapacity(15);
        dto.setStatus("OPEN");

        academicService.saveCourse(dto, 1L, "staff@educenter.vn", "127.0.0.1");

        assertTrue(mockCourseRepo.existsByCode(null, "MATH-11-ADV", null));
        assertEquals(1, mockAuditLogRepo.logs.size());
        assertEquals("CREATE_COURSE", mockAuditLogRepo.logs.get(0).getAction());
    }

    @Test
    @DisplayName("Tạo khóa học trùng mã: Ném ValidationException")
    void testSaveCourse_DuplicateCode_ThrowsException() {
        CourseFormDTO dto = new CourseFormDTO();
        dto.setCode("math-10"); // Trùng với MATH-10 đã seed
        dto.setName("Toán 10 Mới");
        dto.setSubjectId(1L);
        dto.setGradeLevel(10);
        dto.setFee(new BigDecimal("2500000"));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.saveCourse(dto, 1L, "staff@educenter.vn", "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("đã tồn tại"));
    }

    @Test
    @DisplayName("Tạo khóa học với khối lớp không hợp lệ (ngoài 6-12): Ném ValidationException")
    void testSaveCourse_InvalidGrade_ThrowsException() {
        CourseFormDTO dto = new CourseFormDTO();
        dto.setCode("MATH-05");
        dto.setName("Toán Lớp 5");
        dto.setSubjectId(1L);
        dto.setGradeLevel(5); // Ngoài 6-12
        dto.setFee(new BigDecimal("2000000"));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.saveCourse(dto, 1L, "staff@educenter.vn", "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("Khối lớp"));
    }

    @Test
    @DisplayName("Tạo khóa học với học phí âm: Ném ValidationException")
    void testSaveCourse_NegativeFee_ThrowsException() {
        CourseFormDTO dto = new CourseFormDTO();
        dto.setCode("MATH-TEST");
        dto.setName("Toán Test");
        dto.setSubjectId(1L);
        dto.setGradeLevel(10);
        dto.setFee(new BigDecimal("-100000"));

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.saveCourse(dto, 1L, "staff@educenter.vn", "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("Học phí"));
    }

    @Test
    @DisplayName("BR18: Sửa học phí của khóa học tạo thêm AuditLog UPDATE_COURSE_FEE")
    void testSaveCourse_FeeChange_AuditsFeeChange() {
        CourseFormDTO dto = new CourseFormDTO();
        dto.setId(10L);
        dto.setSubjectId(1L);
        dto.setCode("MATH-10");
        dto.setName("Toán 10 Cơ Bản Refactored");
        dto.setGradeLevel(10);
        dto.setFee(new BigDecimal("3800000")); // Đổi từ 3.000.000 sang 3.800.000
        dto.setDurationWeeks(12);
        dto.setTotalSessions(24);
        dto.setMaxCapacity(15);
        dto.setStatus("OPEN");

        academicService.saveCourse(dto, 1L, "staff@educenter.vn", "127.0.0.1");

        assertEquals(2, mockAuditLogRepo.logs.size());
        boolean hasFeeAudit = mockAuditLogRepo.logs.stream()
                .anyMatch(log -> "UPDATE_COURSE_FEE".equals(log.getAction()) && "3000000".equals(log.getOldValues()) && "3800000".equals(log.getNewValues()));
        assertTrue(hasFeeAudit, "Bắt buộc phải có AuditLog UPDATE_COURSE_FEE ghi rõ học phí cũ và mới");
    }

    @Test
    @DisplayName("Mở tuyển sinh (OPEN) bị chặn nếu môn học đang ngừng hoạt động (INACTIVE)")
    void testUpdateCourseStatus_Open_BlockedIfSubjectInactive() {
        // Course với môn HIST (INACTIVE)
        Course c = new Course();
        c.setId(20L);
        c.setSubject(mockSubjectRepo.storage.get(2L)); // HIST
        c.setCode("HIST-10");
        c.setName("Lịch sử 10");
        c.setStatus("CLOSED");
        mockCourseRepo.storage.put(20L, c);

        ValidationException ex = assertThrows(ValidationException.class, () ->
                academicService.updateCourseStatus(20L, "OPEN", 1L, "staff@educenter.vn", "127.0.0.1")
        );
        assertTrue(ex.getMessage().contains("ngừng hoạt động"));
    }
}
