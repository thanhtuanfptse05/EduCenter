package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("ClassTimetableService — Class, Room & Schedule Conflict Rules (BR04, BR05, BR06, BR19)")
public class ClassTimetableServiceTest {

    private ClassTimetableService service;
    private MockRoomRepository mockRoomRepo;
    private MockEduClassRepository mockClassRepo;
    private MockClassSessionRepository mockSessionRepo;
    private MockCourseRepository mockCourseRepo;
    private MockTeacherRepository mockTeacherRepo;
    private MockUserRepository mockUserRepo;
    private MockAuditLogRepository mockAuditLogRepo;

    static class MockRoomRepository extends RoomRepository {
        Map<Long, Room> rooms = new HashMap<>();
        long nextId = 1L;

        @Override
        public Optional<Room> findById(EntityManager em, Long id) {
            return Optional.ofNullable(rooms.get(id));
        }

        @Override
        public Optional<Room> findByCode(EntityManager em, String code) {
            return rooms.values().stream()
                .filter(r -> r.getCode().equalsIgnoreCase(code))
                .findFirst();
        }

        @Override
        public List<Room> findAll(EntityManager em) {
            return new ArrayList<>(rooms.values());
        }

        @Override
        public List<Room> findAvailableRooms(EntityManager em) {
            List<Room> result = new ArrayList<>();
            for (Room r : rooms.values()) {
                if ("AVAILABLE".equalsIgnoreCase(r.getStatus())) result.add(r);
            }
            return result;
        }

        @Override
        public long countTotalRooms(EntityManager em) { return rooms.size(); }

        @Override
        public long countAvailableRooms(EntityManager em) {
            return rooms.values().stream().filter(r -> "AVAILABLE".equalsIgnoreCase(r.getStatus())).count();
        }

        @Override
        public long countClassesByRoom(EntityManager em, Long roomId) { return 0L; }

        @Override
        public void save(EntityManager em, Room room) {
            room.setId(nextId++);
            rooms.put(room.getId(), room);
        }

        @Override
        public Room update(EntityManager em, Room room) {
            rooms.put(room.getId(), room);
            return room;
        }
    }

    static class MockEduClassRepository extends EduClassRepository {
        Map<Long, EduClass> classes = new HashMap<>();
        long nextId = 1L;

        @Override
        public Optional<EduClass> findById(EntityManager em, Long id) {
            return Optional.ofNullable(classes.get(id));
        }

        @Override
        public Optional<EduClass> findByCode(EntityManager em, String code) {
            return classes.values().stream()
                .filter(c -> c.getCode().equalsIgnoreCase(code))
                .findFirst();
        }

        @Override
        public List<EduClass> findClasses(EntityManager em, ClassFilterDTO filter) {
            return new ArrayList<>(classes.values());
        }

        @Override
        public long countClasses(EntityManager em, ClassFilterDTO filter) { return classes.size(); }

        @Override
        public long countTotal(EntityManager em) { return classes.size(); }

        @Override
        public long countByStatus(EntityManager em, String status) {
            return classes.values().stream()
                .filter(c -> c.getStatus().equalsIgnoreCase(status))
                .count();
        }

        @Override
        public long countEnrolledStudents(EntityManager em, Long classId) { return 5L; }

        @Override
        public void save(EntityManager em, EduClass eduClass) {
            eduClass.setId(nextId++);
            classes.put(eduClass.getId(), eduClass);
        }

        @Override
        public EduClass update(EntityManager em, EduClass eduClass) {
            classes.put(eduClass.getId(), eduClass);
            return eduClass;
        }
    }

    static class MockClassSessionRepository extends ClassSessionRepository {
        Map<Long, ClassSession> sessions = new HashMap<>();
        long nextId = 1L;
        boolean simulateTeacherConflict = false;
        boolean simulateRoomConflict = false;

        @Override
        public Optional<ClassSession> findById(EntityManager em, Long id) {
            return Optional.ofNullable(sessions.get(id));
        }

        @Override
        public List<ClassSession> findByClassId(EntityManager em, Long classId) {
            List<ClassSession> result = new ArrayList<>();
            for (ClassSession s : sessions.values()) {
                if (s.getEduClass() != null && classId.equals(s.getEduClass().getId())) {
                    result.add(s);
                }
            }
            return result;
        }

        @Override
        public List<ClassSession> checkTeacherConflict(EntityManager em, Long teacherId, LocalDate sessionDate,
                                                       LocalTime startAt, LocalTime endAt, Long excludeSessionId) {
            if (simulateTeacherConflict) {
                EduClass c = new EduClass();
                c.setName("Lớp Trùng Lịch");
                ClassSession conflict = new ClassSession();
                conflict.setId(999L);
                conflict.setEduClass(c);
                return List.of(conflict);
            }
            return Collections.emptyList();
        }

        @Override
        public List<ClassSession> checkRoomConflict(EntityManager em, Long roomId, LocalDate sessionDate,
                                                    LocalTime startAt, LocalTime endAt, Long excludeSessionId) {
            if (simulateRoomConflict) {
                EduClass c = new EduClass();
                c.setName("Lớp Trùng Phòng");
                ClassSession conflict = new ClassSession();
                conflict.setId(888L);
                conflict.setEduClass(c);
                return List.of(conflict);
            }
            return Collections.emptyList();
        }

        @Override
        public List<ClassSession> findSessionsBetween(EntityManager em, LocalDate fromDate, LocalDate toDate) {
            return new ArrayList<>(sessions.values());
        }

        @Override
        public void save(EntityManager em, ClassSession session) {
            session.setId(nextId++);
            sessions.put(session.getId(), session);
        }

        @Override
        public ClassSession update(EntityManager em, ClassSession session) {
            sessions.put(session.getId(), session);
            return session;
        }
    }

    static class MockCourseRepository extends CourseRepository {
        Map<Long, Course> courses = new HashMap<>();

        @Override
        public Optional<Course> findById(EntityManager em, Long id) {
            return Optional.ofNullable(courses.get(id));
        }
    }

    static class MockTeacherRepository extends TeacherRepository {
        Map<Long, Teacher> teachers = new HashMap<>();

        @Override
        public Optional<Teacher> findById(EntityManager em, Long id) {
            return Optional.ofNullable(teachers.get(id));
        }
    }

    static class MockUserRepository extends UserRepository {
        Map<Long, User> users = new HashMap<>();

        @Override
        public Optional<User> findById(EntityManager em, Long id) {
            return Optional.ofNullable(users.get(id));
        }
    }

    static class MockAuditLogRepository extends AuditLogRepository {
        List<AuditLog> logs = new ArrayList<>();

        @Override
        public void save(EntityManager em, AuditLog log) {
            logs.add(log);
        }
    }

    @BeforeEach
    void setUp() {
        mockRoomRepo = new MockRoomRepository();
        mockClassRepo = new MockEduClassRepository();
        mockSessionRepo = new MockClassSessionRepository();
        mockCourseRepo = new MockCourseRepository();
        mockTeacherRepo = new MockTeacherRepository();
        mockUserRepo = new MockUserRepository();
        mockAuditLogRepo = new MockAuditLogRepository();

        // Chuẩn bị Mock EntityManager
        EntityTransaction mockTx = (EntityTransaction) Proxy.newProxyInstance(
            getClass().getClassLoader(),
            new Class<?>[]{EntityTransaction.class},
            (proxy, method, args) -> {
                if ("isActive".equals(method.getName())) return false;
                return null;
            }
        );

        EntityManager mockEm = (EntityManager) Proxy.newProxyInstance(
            getClass().getClassLoader(),
            new Class<?>[]{EntityManager.class},
            (proxy, method, args) -> {
                if ("getTransaction".equals(method.getName())) return mockTx;
                if ("isOpen".equals(method.getName())) return true;
                return null;
            }
        );

        service = new ClassTimetableServiceImpl(
            mockRoomRepo, mockClassRepo, mockSessionRepo, mockCourseRepo,
            mockTeacherRepo, mockUserRepo, mockAuditLogRepo, () -> mockEm
        );

        // Khởi tạo dữ liệu mẫu
        Course openCourse = new Course();
        openCourse.setId(10L);
        openCourse.setName("Toán 12 Luyện thi THPT");
        openCourse.setStatus("OPEN");
        mockCourseRepo.courses.put(10L, openCourse);

        Course draftCourse = new Course();
        draftCourse.setId(20L);
        draftCourse.setName("Văn 12 Cơ bản");
        draftCourse.setStatus("DRAFT");
        mockCourseRepo.courses.put(20L, draftCourse);

        User teacherUser = new User();
        teacherUser.setId(100L);
        teacherUser.setFullName("Thầy Nguyễn Văn A");
        teacherUser.setEmail("nguyenvana@educenter.vn");

        Teacher teacher = new Teacher();
        teacher.setId(5L);
        teacher.setUser(teacherUser);
        teacher.setStatus("ACTIVE");
        mockTeacherRepo.teachers.put(5L, teacher);

        Room room = new Room("P101", "Phòng Lý thuyết 101", 20, "AVAILABLE");
        room.setId(1L);
        mockRoomRepo.rooms.put(1L, room);
    }

    @Test
    @DisplayName("Tạo lớp học thất bại nếu Khóa học không ở trạng thái OPEN (BR04)")
    void testCreateClass_CourseNotOpen() {
        ClassFormDTO form = new ClassFormDTO();
        form.setCourseId(20L); // DRAFT course
        form.setTeacherId(5L);
        form.setCode("CLS-01");
        form.setName("Lớp Văn 12");
        form.setCapacity(15);
        form.setStartDate(LocalDate.now());
        form.setEndDate(LocalDate.now().plusMonths(3));

        ValidationException ex = assertThrows(ValidationException.class, () -> service.createClass(form, 1L));
        assertTrue(ex.getMessage().contains("OPEN"));
    }

    @Test
    @DisplayName("Tạo lớp học thất bại nếu ngày kết thúc trước ngày bắt đầu (BR04)")
    void testCreateClass_InvalidDates() {
        ClassFormDTO form = new ClassFormDTO();
        form.setCourseId(10L);
        form.setTeacherId(5L);
        form.setCode("CLS-02");
        form.setName("Lớp Toán 12");
        form.setCapacity(15);
        form.setStartDate(LocalDate.now().plusMonths(1));
        form.setEndDate(LocalDate.now()); // Kết thúc trước bắt đầu

        ValidationException ex = assertThrows(ValidationException.class, () -> service.createClass(form, 1L));
        assertTrue(ex.getMessage().contains("ngày bắt đầu"));
    }

    @Test
    @DisplayName("Tạo lớp học thất bại nếu sĩ số vượt quá sức chứa phòng (BR04)")
    void testCreateClass_CapacityExceedsRoom() {
        ClassFormDTO form = new ClassFormDTO();
        form.setCourseId(10L);
        form.setTeacherId(5L);
        form.setRoomId(1L); // Sức chứa phòng P101 = 20
        form.setCode("CLS-03");
        form.setName("Lớp Toán 12");
        form.setCapacity(25); // Sĩ số 25 > 20
        form.setStartDate(LocalDate.now());
        form.setEndDate(LocalDate.now().plusMonths(3));

        ValidationException ex = assertThrows(ValidationException.class, () -> service.createClass(form, 1L));
        assertTrue(ex.getMessage().contains("vượt quá sức chứa phòng"));
    }

    @Test
    @DisplayName("Tạo lớp học thành công với dữ liệu hợp lệ")
    void testCreateClass_Success() {
        ClassFormDTO form = new ClassFormDTO();
        form.setCourseId(10L);
        form.setTeacherId(5L);
        form.setRoomId(1L);
        form.setCode("MAT12-01");
        form.setName("Toán 12 Cơ bản");
        form.setCapacity(15);
        form.setStartDate(LocalDate.now());
        form.setEndDate(LocalDate.now().plusMonths(3));

        Long classId = service.createClass(form, 1L);
        assertNotNull(classId);
        assertTrue(classId > 0);
        assertEquals(1, mockClassRepo.classes.size());
    }

    @Test
    @DisplayName("Sinh lịch thất bại nếu lớp đang ở trạng thái CLOSED (BR19)")
    void testGenerateSchedule_ClassClosed() {
        EduClass c = new EduClass();
        c.setId(100L);
        c.setCode("CLOSED-01");
        c.setName("Lớp Đã Đóng");
        c.setStatus("CLOSED");
        c.setStartDate(LocalDate.now());
        c.setEndDate(LocalDate.now().plusMonths(2));
        mockClassRepo.classes.put(100L, c);

        ScheduleGeneratorDTO dto = new ScheduleGeneratorDTO();
        dto.setClassId(100L);
        dto.setRoomId(1L);
        dto.setTeacherId(5L);
        dto.setDaysOfWeek(List.of(2, 4, 6)); // T2, T4, T6
        dto.setStartAt(LocalTime.of(18, 0));
        dto.setEndAt(LocalTime.of(20, 0));

        ValidationException ex = assertThrows(ValidationException.class, () -> service.generateSchedule(dto, 1L));
        assertTrue(ex.getMessage().contains("BR19"));
    }

    @Test
    @DisplayName("Sinh lịch thất bại khi phát hiện trùng lịch giáo viên (BR05)")
    void testGenerateSchedule_TeacherConflict() {
        EduClass c = new EduClass();
        c.setId(101L);
        c.setCode("MAT12-NEW");
        c.setName("Toán 12 Mới");
        c.setStatus("OPEN");
        c.setStartDate(LocalDate.now());
        c.setEndDate(LocalDate.now().plusMonths(2));
        mockClassRepo.classes.put(101L, c);

        mockSessionRepo.simulateTeacherConflict = true;

        ScheduleGeneratorDTO dto = new ScheduleGeneratorDTO();
        dto.setClassId(101L);
        dto.setRoomId(1L);
        dto.setTeacherId(5L);
        dto.setDaysOfWeek(List.of(2, 4, 6));
        dto.setStartAt(LocalTime.of(18, 0));
        dto.setEndAt(LocalTime.of(20, 0));

        ValidationException ex = assertThrows(ValidationException.class, () -> service.generateSchedule(dto, 1L));
        assertTrue(ex.getMessage().contains("BR05"));
    }

    @Test
    @DisplayName("Sinh lịch thất bại khi phát hiện trùng lịch phòng học (BR06)")
    void testGenerateSchedule_RoomConflict() {
        EduClass c = new EduClass();
        c.setId(102L);
        c.setCode("MAT12-NEW2");
        c.setName("Toán 12 Mới 2");
        c.setStatus("OPEN");
        c.setStartDate(LocalDate.now());
        c.setEndDate(LocalDate.now().plusMonths(2));
        mockClassRepo.classes.put(102L, c);

        mockSessionRepo.simulateTeacherConflict = false;
        mockSessionRepo.simulateRoomConflict = true;

        ScheduleGeneratorDTO dto = new ScheduleGeneratorDTO();
        dto.setClassId(102L);
        dto.setRoomId(1L);
        dto.setTeacherId(5L);
        dto.setDaysOfWeek(List.of(2, 4, 6));
        dto.setStartAt(LocalTime.of(18, 0));
        dto.setEndAt(LocalTime.of(20, 0));

        ValidationException ex = assertThrows(ValidationException.class, () -> service.generateSchedule(dto, 1L));
        assertTrue(ex.getMessage().contains("BR06"));
    }

    @Test
    @DisplayName("Sinh lịch tự động thành công khi không có xung đột (Atomic batch)")
    void testGenerateSchedule_Success() {
        EduClass c = new EduClass();
        c.setId(103L);
        c.setCode("MAT12-OK");
        c.setName("Toán 12 Chuẩn");
        c.setStatus("OPEN");
        c.setStartDate(LocalDate.of(2026, 11, 2)); // T2
        c.setEndDate(LocalDate.of(2026, 12, 31));
        mockClassRepo.classes.put(103L, c);

        mockSessionRepo.simulateTeacherConflict = false;
        mockSessionRepo.simulateRoomConflict = false;

        ScheduleGeneratorDTO dto = new ScheduleGeneratorDTO();
        dto.setClassId(103L);
        dto.setRoomId(1L);
        dto.setTeacherId(5L);
        dto.setDaysOfWeek(List.of(2, 4, 6)); // T2, T4, T6
        dto.setStartAt(LocalTime.of(18, 0));
        dto.setEndAt(LocalTime.of(20, 0));
        dto.setTotalSessions(6);
        dto.setStartDate(LocalDate.of(2026, 11, 2));

        int generated = service.generateSchedule(dto, 1L);
        assertEquals(6, generated);
        assertEquals(6, mockSessionRepo.sessions.size());
    }

    @Test
    @DisplayName("Quản lý danh mục phòng học — Kiểm tra mã phòng duy nhất")
    void testCreateRoom_DuplicateCode() {
        RoomFormDTO form = new RoomFormDTO();
        form.setCode("P101"); // Mã P101 đã có trong setUp
        form.setName("Phòng số 101 mới");
        form.setCapacity(25);
        form.setStatus("AVAILABLE");

        ValidationException ex = assertThrows(ValidationException.class, () -> service.createRoom(form, 1L));
        assertTrue(ex.getMessage().contains("đã tồn tại"));
    }
}
