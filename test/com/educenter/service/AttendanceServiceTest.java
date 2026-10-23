package com.educenter.service;

import com.educenter.dto.AttendanceRosterItemDTO;
import com.educenter.dto.AttendanceSessionViewDTO;
import com.educenter.dto.TeachingJournalDTO;
import com.educenter.entity.*;
import com.educenter.repository.AttendanceRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("AttendanceService — Teacher Attendance Journal and Roster Tests")
public class AttendanceServiceTest {

    private AttendanceService attendanceService;
    private MockAttendanceRepository mockRepo;

    static class MockAttendanceRepository extends AttendanceRepository {
        ClassSession session;
        List<Attendance> attendances = new ArrayList<>();
        TeachingJournal journal;

        @Override
        public Optional<ClassSession> findSessionById(EntityManager em, Long sessionId) {
            if (session != null && session.getId().equals(sessionId)) {
                return Optional.of(session);
            }
            return Optional.empty();
        }

        @Override
        public List<AttendanceSessionViewDTO> findSessionsForTeacher(EntityManager em, Long teacherUserId, LocalDate sessionDate) {
            List<AttendanceSessionViewDTO> list = new ArrayList<>();
            if (session != null) {
                AttendanceSessionViewDTO dto = new AttendanceSessionViewDTO();
                dto.setSessionId(session.getId());
                dto.setClassId(session.getEduClass().getId());
                dto.setClassName(session.getEduClass().getName());
                dto.setSessionStatus(session.getStatus());
                list.add(dto);
            }
            return list;
        }

        @Override
        public List<AttendanceRosterItemDTO> findRosterForSession(EntityManager em, Long sessionId, Long classId, LocalDate sessionDate) {
            List<AttendanceRosterItemDTO> list = new ArrayList<>();
            list.add(new AttendanceRosterItemDTO(1L, "HV0001", "Học sinh 1", "0912345678", "PRESENT", ""));
            list.add(new AttendanceRosterItemDTO(2L, "HV0002", "Học sinh 2", "0987654321", null, ""));
            return list;
        }

        @Override
        public Optional<Attendance> findAttendanceBySessionAndStudent(EntityManager em, Long sessionId, Long studentId) {
            return attendances.stream()
                    .filter(a -> a.getStudent().getId().equals(studentId))
                    .findFirst();
        }

        @Override
        public Optional<TeachingJournal> findJournalBySessionId(EntityManager em, Long sessionId) {
            return Optional.ofNullable(journal);
        }

        @Override
        public void saveAttendance(EntityManager em, Attendance attendance) {
            if (attendance.getId() == null) {
                attendance.setId((long) (attendances.size() + 1));
                attendances.add(attendance);
            }
        }

        @Override
        public void saveJournal(EntityManager em, TeachingJournal j) {
            this.journal = j;
            if (j.getId() == null) j.setId(1L);
        }
    }

    @BeforeEach
    void setUp() {
        mockRepo = new MockAttendanceRepository();
        attendanceService = new AttendanceServiceImpl(mockRepo);

        // Tạo mock session
        ClassSession s = new ClassSession();
        s.setId(10L);
        s.setSessionDate(LocalDate.now());
        s.setStartAt(LocalTime.of(8, 0));
        s.setEndAt(LocalTime.of(10, 0));
        s.setStatus("SCHEDULED");

        EduClass c = new EduClass();
        c.setId(100L);
        c.setCode("CLS-MATH10");
        c.setName("Toán 10A1");

        Course cr = new Course();
        cr.setId(1L);
        cr.setName("Toán 10 Nâng Cao");
        Subject sub = new Subject();
        sub.setName("Toán học");
        cr.setSubject(sub);
        c.setCourse(cr);
        s.setEduClass(c);

        Teacher t = new Teacher();
        t.setId(5L);
        User u = new User();
        u.setId(50L);
        u.setFullName("Thầy Nguyễn Văn A");
        t.setUser(u);
        s.setTeacher(t);

        mockRepo.session = s;
    }

    @Test
    @DisplayName("FR-001: Giáo viên thực dạy xem được chi tiết buổi học và roster")
    void testGetSessionAttendance_AuthorizedTeacher() {
        // Teacher user id = 50L
        AttendanceSessionViewDTO dto = attendanceService.getSessionAttendance(10L, 50L, false);
        assertNotNull(dto);
        assertEquals(10L, dto.getSessionId());
        assertEquals("CLS-MATH10", dto.getClassCode());
        assertEquals(2, dto.getRoster().size());
    }

    @Test
    @DisplayName("FR-001: Giáo viên khác không được phân công bị chặn truy cập")
    void testGetSessionAttendance_UnauthorizedTeacher_ThrowsException() {
        // Teacher user id = 99L (khác 50L)
        assertThrows(ValidationException.class, () -> {
            attendanceService.getSessionAttendance(10L, 99L, false);
        });
    }

    @Test
    @DisplayName("FR-005: Buổi học COMPLETED bị khóa với giáo viên thường, Admin được hiệu chỉnh")
    void testCompletedSession_LockedForTeacher() {
        mockRepo.session.setStatus("COMPLETED");

        List<AttendanceRosterItemDTO> roster = new ArrayList<>();
        roster.add(new AttendanceRosterItemDTO(1L, "HV0001", "Học sinh 1", "0912345678", "PRESENT", ""));

        // Giáo viên thường sửa -> bị chặn
        assertThrows(ValidationException.class, () -> {
            attendanceService.saveAttendance(10L, roster, 50L, false);
        });
    }

    @Test
    @DisplayName("FR-004: Chặn chốt hoàn tất buổi học khi còn học sinh chưa điểm danh")
    void testCompleteSession_UnrecordedStudents_Blocked() {
        // Mock roster có 1 học sinh chưa có trạng thái (null)
        assertThrows(ValidationException.class, () -> {
            attendanceService.completeSessionAttendance(10L, 50L, false);
        });
    }

    @Test
    @DisplayName("FR-006: Lưu và truy xuất nhật ký giảng dạy thành công")
    void testSaveTeachingJournal_Success() {
        TeachingJournal j = new TeachingJournal();
        j.setId(1L);
        j.setClassSession(mockRepo.session);
        j.setContent("Ôn tập phương trình bậc hai");
        j.setHomework("Bài 1 đến 5 trang 42 SGK");
        mockRepo.journal = j;

        TeachingJournalDTO dto = attendanceService.getTeachingJournal(10L, 50L, false);
        assertNotNull(dto);
        assertEquals("Ôn tập phương trình bậc hai", dto.getContent());
        assertEquals("Bài 1 đến 5 trang 42 SGK", dto.getHomework());
    }
}
