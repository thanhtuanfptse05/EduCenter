package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.PortalRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("PortalService — Student and Parent Portal Data and Authorization Tests")
public class PortalServiceTest {

    private PortalService portalService;
    private MockPortalRepository mockPortalRepo;

    static class MockPortalRepository extends PortalRepository {
        Student mockStudent;
        Guardian mockGuardian;
        List<ChildGuardianViewDTO> mockChildren = new ArrayList<>();
        List<PortalScheduleItemDTO> mockSessions = new ArrayList<>();
        List<PortalScoreItemDTO> mockScores = new ArrayList<>();
        PortalAttendanceSummaryDTO mockAttendance = new PortalAttendanceSummaryDTO(10, 8, 1, 1, 0);
        List<ClassItemDTO> mockEnrolledClasses = new ArrayList<>();
        boolean isAuthorizedGuardian = false;

        @Override
        public Optional<Student> findStudentByUserId(EntityManager em, Long userId) {
            if (mockStudent != null && mockStudent.getUser() != null && mockStudent.getUser().getId().equals(userId)) {
                return Optional.of(mockStudent);
            }
            return Optional.empty();
        }

        @Override
        public Optional<Guardian> findGuardianByUserId(EntityManager em, Long userId) {
            if (mockGuardian != null && mockGuardian.getUser() != null && mockGuardian.getUser().getId().equals(userId)) {
                return Optional.of(mockGuardian);
            }
            return Optional.empty();
        }

        @Override
        public List<ChildGuardianViewDTO> findVerifiedChildrenByGuardianUserId(EntityManager em, Long guardianUserId) {
            return mockChildren;
        }

        @Override
        public boolean isGuardianOfStudent(EntityManager em, Long guardianUserId, Long studentId) {
            return isAuthorizedGuardian;
        }

        @Override
        public List<PortalScheduleItemDTO> findUpcomingSessionsByStudentId(EntityManager em, Long studentId, int limit) {
            return mockSessions;
        }

        @Override
        public List<PortalScheduleItemDTO> findScheduleByStudentId(EntityManager em, Long studentId, LocalDate fromDate, LocalDate toDate) {
            return mockSessions;
        }

        @Override
        public List<PortalScoreItemDTO> findPublishedScoresByStudentId(EntityManager em, Long studentId) {
            return mockScores;
        }

        @Override
        public PortalAttendanceSummaryDTO getAttendanceStatsByStudentId(EntityManager em, Long studentId) {
            return mockAttendance;
        }

        @Override
        public List<ClassItemDTO> findEnrolledClassesByStudentId(EntityManager em, Long studentId) {
            return mockEnrolledClasses;
        }
    }

    static EntityManager createMockEntityManager(MockPortalRepository repo) {
        return (EntityManager) java.lang.reflect.Proxy.newProxyInstance(
                EntityManager.class.getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("find".equals(method.getName()) && args != null && args.length >= 2) {
                        Class<?> entityClass = (Class<?>) args[0];
                        Long id = (Long) args[1];
                        if (Student.class.equals(entityClass) && repo.mockStudent != null && id.equals(repo.mockStudent.getId())) {
                            return repo.mockStudent;
                        }
                    }
                    if ("close".equals(method.getName())) return null;
                    return null;
                }
        );
    }

    @BeforeEach
    public void setUp() {
        mockPortalRepo = new MockPortalRepository();
        portalService = new PortalServiceImpl(mockPortalRepo, () -> createMockEntityManager(mockPortalRepo));
    }

    @Test
    @DisplayName("Student Dashboard with linked profile returns complete summary")
    public void testStudentDashboard_ProfileLinked_ReturnsData() {
        User u = new User("student@educenter.vn", "hash", "Nguyen Van An", "0912345678");
        u.setId(10L);

        Student s = new Student();
        s.setId(100L);
        s.setUser(u);
        s.setFullName("Nguyen Van An");
        s.setGradeLevel(12);
        s.setSchool("THPT Chu Van An");
        mockPortalRepo.mockStudent = s;

        PortalScoreItemDTO scoreItem = new PortalScoreItemDTO();
        scoreItem.setScore(new BigDecimal("9.0"));
        mockPortalRepo.mockScores.add(scoreItem);

        StudentDashboardSummaryDTO summary = portalService.getStudentDashboard(10L);
        assertNotNull(summary);
        assertEquals(100L, summary.getStudentId());
        assertEquals("Nguyen Van An", summary.getStudentName());
        assertEquals(12, summary.getGradeLevel());
        assertEquals(new BigDecimal("9.00"), summary.getAverageScore());
        assertEquals(new BigDecimal("90.0"), summary.getAttendanceSummary().getAttendanceRate());
    }

    @Test
    @DisplayName("Student Dashboard with unlinked profile returns empty summary container")
    public void testStudentDashboard_ProfileNotLinked_ReturnsEmptyContainer() {
        StudentDashboardSummaryDTO summary = portalService.getStudentDashboard(999L);
        assertNotNull(summary);
        assertNull(summary.getStudentId());
        assertNull(summary.getStudentName());
    }

    @Test
    @DisplayName("Student schedule returns list of classes")
    public void testStudentSchedule_ReturnsScheduleList() {
        User u = new User("student@educenter.vn", "hash", "Nguyen Van An", "0912345678");
        u.setId(10L);
        Student s = new Student();
        s.setId(100L);
        s.setUser(u);
        mockPortalRepo.mockStudent = s;

        PortalScheduleItemDTO item = new PortalScheduleItemDTO();
        item.setSessionId(1L);
        item.setSessionDate(LocalDate.now());
        item.setStartTime(LocalTime.of(8, 0));
        item.setEndTime(LocalTime.of(10, 0));
        mockPortalRepo.mockSessions.add(item);

        List<PortalScheduleItemDTO> schedule = portalService.getStudentSchedule(10L, null, null);
        assertNotNull(schedule);
        assertEquals(1, schedule.size());
        assertEquals(1L, schedule.get(0).getSessionId());
    }

    @Test
    @DisplayName("Parent Dashboard with verified children returns selected child data")
    public void testParentDashboard_WithVerifiedChildren_ReturnsSelectedChild() {
        User u = new User("parent@educenter.vn", "hash", "Tran Quoc Tuan", "0944556677");
        u.setId(20L);

        Guardian g = new Guardian();
        g.setId(200L);
        g.setUser(u);
        g.setFullName("Tran Quoc Tuan");
        mockPortalRepo.mockGuardian = g;

        Student child = new Student();
        child.setId(100L);
        child.setFullName("Tran Hoang Nam");
        child.setGradeLevel(12);
        mockPortalRepo.mockStudent = child;

        ChildGuardianViewDTO childView = new ChildGuardianViewDTO(
                100L, "Tran Hoang Nam", "HV0100", 12, "THPT Chu Van An", "Bố", true, true);
        mockPortalRepo.mockChildren.add(childView);

        ParentDashboardSummaryDTO parentSummary = portalService.getParentDashboard(20L, null);
        assertNotNull(parentSummary);
        assertEquals(200L, parentSummary.getGuardianId());
        assertTrue(parentSummary.hasChildren());
        assertEquals(100L, parentSummary.getSelectedChildId());
        assertNotNull(parentSummary.getSelectedChildSummary());
        assertEquals("Tran Hoang Nam", parentSummary.getSelectedChildSummary().getStudentName());
    }

    @Test
    @DisplayName("Parent Dashboard without verified children returns empty state")
    public void testParentDashboard_NoChildren_ReturnsEmptyList() {
        User u = new User("parent@educenter.vn", "hash", "Tran Quoc Tuan", "0944556677");
        u.setId(20L);
        Guardian g = new Guardian();
        g.setId(200L);
        g.setUser(u);
        mockPortalRepo.mockGuardian = g;

        ParentDashboardSummaryDTO parentSummary = portalService.getParentDashboard(20L, null);
        assertNotNull(parentSummary);
        assertFalse(parentSummary.hasChildren());
        assertNull(parentSummary.getSelectedChildSummary());
    }

    @Test
    @DisplayName("Parent accessing unauthorized child throws ValidationException")
    public void testParentGetChildDetail_UnauthorizedChild_ThrowsValidationException() {
        mockPortalRepo.isAuthorizedGuardian = false;

        ValidationException ex = assertThrows(ValidationException.class, () ->
                portalService.getChildDetail(20L, 999L));
        assertTrue(ex.getMessage().contains("không có quyền truy cập"));
    }

    @Test
    @DisplayName("Parent accessing authorized child returns detailed summary")
    public void testParentGetChildDetail_AuthorizedChild_ReturnsData() {
        mockPortalRepo.isAuthorizedGuardian = true;
        Student child = new Student();
        child.setId(100L);
        child.setFullName("Tran Hoang Nam");
        child.setGradeLevel(12);
        mockPortalRepo.mockStudent = child;

        StudentDashboardSummaryDTO detail = portalService.getChildDetail(20L, 100L);
        assertNotNull(detail);
        assertEquals(100L, detail.getStudentId());
        assertEquals("Tran Hoang Nam", detail.getStudentName());
    }
}
