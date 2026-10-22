package com.educenter.service;

import com.educenter.dto.LandingDataDTO;
import com.educenter.dto.LeadFormDTO;
import com.educenter.entity.Course;
import com.educenter.entity.Lead;
import com.educenter.entity.Subject;
import com.educenter.entity.Teacher;
import com.educenter.repository.LandingRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("LandingService — Public Portal Data & CRM Lead Generation Tests")
public class LandingServiceTest {

    private LandingService landingService;
    private MockLandingRepository mockLandingRepo;

    static class MockLandingRepository extends LandingRepository {
        List<Lead> savedLeads = new ArrayList<>();
        long leadIdGen = 100L;

        @Override
        public long countActiveStudents(EntityManager em) { return 1250L; }

        @Override
        public long countOpenClasses(EntityManager em) { return 45L; }

        @Override
        public long countActiveTeachers(EntityManager em) { return 28L; }

        @Override
        public long countClassesByGrade(EntityManager em, int gradeLevel) {
            return switch (gradeLevel) {
                case 10 -> 12L;
                case 11 -> 15L;
                case 12 -> 18L;
                default -> 0L;
            };
        }

        @Override
        public List<com.educenter.entity.EduClass> findOpenClassesForCourses(EntityManager em, List<Long> courseIds) {
            return new ArrayList<>();
        }

        @Override
        public List<Course> findFeaturedCourses(EntityManager em) {
            List<Course> list = new ArrayList<>();
            Course c = new Course();
            c.setId(1L);
            c.setCode("TOAN12-TN");
            c.setName("Toán 12 Luyện Thi THPTQG");
            c.setGradeLevel(12);
            c.setFee(new BigDecimal("3600000.00"));
            c.setMaxCapacity(15);
            c.setTotalSessions(24);
            c.setDurationWeeks(12);

            Subject s = new Subject();
            s.setId(10L);
            s.setCode("MATH");
            s.setName("Toán học");
            c.setSubject(s);

            list.add(c);
            return list;
        }

        @Override
        public List<Teacher> findFacultyTeachers(EntityManager em) {
            List<Teacher> list = new ArrayList<>();
            Teacher t = new Teacher();
            t.setId(1L);
            t.setFullName("ThS. Đặng Vũ Nam");
            t.setDegree("Thạc sĩ ĐH Sư Phạm");
            t.setSpecialization("Toán THPT");
            t.setBio("10 năm kinh nghiệm luyện thi");
            list.add(t);
            return list;
        }

        @Override
        public List<Subject> findAllActiveSubjects(EntityManager em) {
            List<Subject> list = new ArrayList<>();
            Subject s = new Subject();
            s.setId(1L);
            s.setCode("MATH");
            s.setName("Toán học");
            s.setDescription("Đại số và Hình học");
            list.add(s);
            return list;
        }

        @Override
        public long countCoursesBySubject(EntityManager em, Long subjectId) {
            return 18L;
        }

        @Override
        public String findRepresentativeImageBySubject(EntityManager em, Long subjectId) {
            return "/assets/images/courses/math.jpg";
        }

        @Override
        public Lead saveLead(EntityManager em, Lead lead) {
            lead.setId(leadIdGen++);
            savedLeads.add(lead);
            return lead;
        }
    }

    @BeforeEach
    void setUp() {
        mockLandingRepo = new MockLandingRepository();

        EntityTransaction mockTx = (EntityTransaction) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{EntityTransaction.class},
                (proxy, method, args) -> {
                    if ("isActive".equals(method.getName())) return true;
                    return null;
                }
        );

        EntityManager mockEm = (EntityManager) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("getTransaction".equals(method.getName())) return mockTx;
                    if ("close".equals(method.getName())) return null;
                    return null;
                }
        );

        landingService = new LandingServiceImpl(mockLandingRepo, () -> mockEm);
    }

    @Test
    @DisplayName("getLandingPortalData returns valid aggregated database statistics and lists")
    void testGetLandingPortalData() {
        LandingDataDTO data = landingService.getLandingPortalData();

        assertNotNull(data);
        assertEquals(1250L, data.getTotalStudents());
        assertEquals(45L, data.getOpenClassesCount());
        assertEquals(28L, data.getTotalTeachersCount());
        assertEquals(12L, data.getGrade10ClassCount());
        assertEquals(15L, data.getGrade11ClassCount());
        assertEquals(18L, data.getGrade12ClassCount());

        assertFalse(data.getFeaturedCourses().isEmpty());
        assertEquals("Toán 12 Luyện Thi THPTQG", data.getFeaturedCourses().get(0).getName());
        assertEquals("3.600.000 đ", data.getFeaturedCourses().get(0).getFormattedFee());

        assertFalse(data.getFacultyTeachers().isEmpty());
        assertEquals("ThS. Đặng Vũ Nam", data.getFacultyTeachers().get(0).getFullName());

        assertFalse(data.getSubjects().isEmpty());
        assertEquals("Toán học", data.getSubjects().get(0).getName());
        assertEquals(18L, data.getSubjects().get(0).getCourseCount());
    }

    @Test
    @DisplayName("registerLead succeeds with valid Vietnamese mobile phone and full name")
    void testRegisterLeadSuccess() {
        LeadFormDTO form = new LeadFormDTO();
        form.setFullName("Nguyễn Văn Hùng");
        form.setPhone("0988123456");
        form.setGradeLevel(12);
        form.setSubject("Toán học");
        form.setLearningModel("Lớp nhóm nhỏ (10-15 bạn)");
        form.setNotes("Mục tiêu 8.5+");

        Lead lead = landingService.registerLead(form);

        assertNotNull(lead);
        assertNotNull(lead.getId());
        assertEquals("Nguyễn Văn Hùng", lead.getName());
        assertEquals("0988123456", lead.getPhone());
        assertEquals(12, lead.getGradeLevel());
        assertEquals("WEBSITE", lead.getSource());
        assertEquals("NEW", lead.getStatus());
        assertTrue(lead.getNotes().contains("Toán học"));
        assertEquals(1, mockLandingRepo.savedLeads.size());
    }

    @Test
    @DisplayName("registerLead throws ValidationException on invalid phone format")
    void testRegisterLeadInvalidPhone() {
        LeadFormDTO form = new LeadFormDTO();
        form.setFullName("Nguyễn Văn Hùng");
        form.setPhone("123456789"); // Invalid prefix/length

        ValidationException ex = assertThrows(ValidationException.class, () -> landingService.registerLead(form));
        assertTrue(ex.getMessage().contains("Số điện thoại không đúng định dạng"));
    }

    @Test
    @DisplayName("registerLead throws ValidationException on blank name")
    void testRegisterLeadBlankName() {
        LeadFormDTO form = new LeadFormDTO();
        form.setFullName("   ");
        form.setPhone("0988123456");

        ValidationException ex = assertThrows(ValidationException.class, () -> landingService.registerLead(form));
        assertTrue(ex.getMessage().contains("Vui lòng nhập họ và tên"));
    }
}
