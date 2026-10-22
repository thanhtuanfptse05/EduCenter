package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.SubjectRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("CourseService — Course Catalog, Details & Filtering Tests")
public class CourseServiceTest {

    private CourseService courseService;
    private MockCourseRepository mockCourseRepo;
    private MockSubjectRepository mockSubjectRepo;

    static class MockCourseRepository extends CourseRepository {
        List<Course> mockCourses = new ArrayList<>();
        List<EduClass> mockClasses = new ArrayList<>();

        @Override
        public List<Course> searchCourses(EntityManager em, CourseFilterDTO filter) {
            List<Course> filtered = new ArrayList<>();
            for (Course c : mockCourses) {
                if (filter.getGradeLevel() != null && !filter.getGradeLevel().equals(c.getGradeLevel())) {
                    continue;
                }
                if (filter.getSubjectId() != null && (c.getSubject() == null || !filter.getSubjectId().equals(c.getSubject().getId()))) {
                    continue;
                }
                if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
                    String kw = filter.getKeyword().toLowerCase();
                    if (!c.getName().toLowerCase().contains(kw) && !c.getCode().toLowerCase().contains(kw)) {
                        continue;
                    }
                }
                filtered.add(c);
            }
            return filtered;
        }

        @Override
        public long countCourses(EntityManager em, CourseFilterDTO filter) {
            return searchCourses(em, filter).size();
        }

        @Override
        public Optional<Course> findById(EntityManager em, Long id) {
            return mockCourses.stream().filter(c -> c.getId().equals(id)).findFirst();
        }

        @Override
        public List<EduClass> findOpenClassesByCourseId(EntityManager em, Long courseId) {
            return mockClasses.stream().filter(cl -> cl.getCourse() != null && cl.getCourse().getId().equals(courseId)).toList();
        }

        @Override
        public List<Course> findRelatedCourses(EntityManager em, Long subjectId, Integer gradeLevel, Long excludeCourseId, int limit) {
            return mockCourses.stream()
                    .filter(c -> !c.getId().equals(excludeCourseId))
                    .limit(limit)
                    .toList();
        }
    }

    static class MockSubjectRepository extends SubjectRepository {
        List<Subject> mockSubjects = new ArrayList<>();

        @Override
        public List<Subject> findAllActive(EntityManager em) {
            return mockSubjects;
        }
    }

    @BeforeEach
    void setUp() {
        mockCourseRepo = new MockCourseRepository();
        mockSubjectRepo = new MockSubjectRepository();

        Subject math = new Subject();
        math.setId(1L);
        math.setCode("MAT");
        math.setName("Toán học");
        mockSubjectRepo.mockSubjects.add(math);

        Subject phys = new Subject();
        phys.setId(2L);
        phys.setCode("PHY");
        phys.setName("Vật lý");
        mockSubjectRepo.mockSubjects.add(phys);

        Course c1 = new Course();
        c1.setId(1L);
        c1.setCode("MAT12-LT01");
        c1.setName("Toán 12 Ôn Thi Tốt Nghiệp THPT");
        c1.setGradeLevel(12);
        c1.setSubject(math);
        c1.setFee(new BigDecimal("3600000"));
        c1.setTotalSessions(24);
        c1.setMaxCapacity(15);
        c1.setStatus("OPEN");
        c1.setIsFeatured(true);
        mockCourseRepo.mockCourses.add(c1);

        Course c2 = new Course();
        c2.setId(2L);
        c2.setCode("PHY12-CD03");
        c2.setName("Vật Lý 12 Chuyên Đề Điện Xoay Chiều");
        c2.setGradeLevel(12);
        c2.setSubject(phys);
        c2.setFee(new BigDecimal("3200000"));
        c2.setTotalSessions(20);
        c2.setMaxCapacity(15);
        c2.setStatus("OPEN");
        c2.setIsFeatured(false);
        mockCourseRepo.mockCourses.add(c2);

        Course c3 = new Course();
        c3.setId(3L);
        c3.setCode("MAT11-NC01");
        c3.setName("Toán 11 Nâng Cao");
        c3.setGradeLevel(11);
        c3.setSubject(math);
        c3.setFee(new BigDecimal("3000000"));
        c3.setTotalSessions(24);
        c3.setMaxCapacity(15);
        c3.setStatus("OPEN");
        c3.setIsFeatured(false);
        mockCourseRepo.mockCourses.add(c3);

        Teacher teacher = new Teacher();
        teacher.setId(10L);
        teacher.setFullName("ThS. Đặng Vũ Nam");
        teacher.setDegree("Thạc sĩ Sư Phạm");
        teacher.setSpecialization("Toán THPT");

        EduClass cl1 = new EduClass();
        cl1.setId(101L);
        cl1.setCode("MAT12-LT01-A");
        cl1.setName("Toán 12 Ca Tối A");
        cl1.setCourse(c1);
        cl1.setTeacher(teacher);
        cl1.setCapacity(15);
        cl1.setStatus("OPEN");
        mockCourseRepo.mockClasses.add(cl1);

        TypedQuery<?> mockQuery = (TypedQuery<?>) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{TypedQuery.class},
                (proxy, method, args) -> {
                    if ("getSingleResult".equals(method.getName())) return 5L;
                    if ("setParameter".equals(method.getName())) return proxy;
                    return null;
                }
        );

        EntityManager mockEm = (EntityManager) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("isOpen".equals(method.getName())) return true;
                    if ("close".equals(method.getName())) return null;
                    if ("createQuery".equals(method.getName())) return mockQuery;
                    return null;
                }
        );

        courseService = new CourseServiceImpl(mockCourseRepo, mockSubjectRepo, () -> mockEm);
    }

    @Test
    @DisplayName("getCourseCatalog returns all courses when filter is blank")
    void testGetCourseCatalogAll() {
        CourseFilterDTO filter = new CourseFilterDTO();
        CoursePageDTO page = courseService.getCourseCatalog(filter);

        assertNotNull(page);
        assertEquals(3, page.getItems().size());
        assertEquals(3, page.getTotalRecords());
        assertEquals(1, page.getCurrentPage());
    }

    @Test
    @DisplayName("getCourseCatalog filters accurately by gradeLevel")
    void testGetCourseCatalogFilterGrade() {
        CourseFilterDTO filter = new CourseFilterDTO();
        filter.setGradeLevel(12);

        CoursePageDTO page = courseService.getCourseCatalog(filter);
        assertNotNull(page);
        assertEquals(2, page.getItems().size());
        assertTrue(page.getItems().stream().allMatch(c -> c.getGradeLevel() == 12));
    }

    @Test
    @DisplayName("getCourseCatalog filters accurately by keyword")
    void testGetCourseCatalogFilterKeyword() {
        CourseFilterDTO filter = new CourseFilterDTO();
        filter.setKeyword("Vật Lý");

        CoursePageDTO page = courseService.getCourseCatalog(filter);
        assertNotNull(page);
        assertEquals(1, page.getItems().size());
        assertEquals("PHY12-CD03", page.getItems().get(0).getCode());
    }

    @Test
    @DisplayName("getCourseDetail returns complete course, primary teacher, classes, and related courses")
    void testGetCourseDetailSuccess() {
        CourseDetailDTO detail = courseService.getCourseDetail(1L);

        assertNotNull(detail);
        assertEquals("MAT12-LT01", detail.getCourse().getCode());
        assertNotNull(detail.getPrimaryTeacher());
        assertEquals("ThS. Đặng Vũ Nam", detail.getPrimaryTeacher().getFullName());
        assertEquals(1, detail.getOpenClasses().size());
        assertEquals("MAT12-LT01-A", detail.getOpenClasses().get(0).getCode());
        assertNotNull(detail.getOriginalFee());
        assertTrue(detail.getOriginalFee().compareTo(detail.getCourse().getFee()) > 0);
    }

    @Test
    @DisplayName("getCourseDetail throws ValidationException when courseId does not exist")
    void testGetCourseDetailNotFound() {
        assertThrows(ValidationException.class, () -> courseService.getCourseDetail(999L));
    }

    @Test
    @DisplayName("getActiveSubjects returns list of subjects with course count")
    void testGetActiveSubjects() {
        List<SubjectCardDTO> subjects = courseService.getActiveSubjects();
        assertNotNull(subjects);
        assertEquals(2, subjects.size());
        assertEquals("MAT", subjects.get(0).getCode());
    }
}
