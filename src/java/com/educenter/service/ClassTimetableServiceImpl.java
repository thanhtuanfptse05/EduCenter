package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.*;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.function.Supplier;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClassTimetableServiceImpl implements ClassTimetableService {

    private static final Logger LOGGER = Logger.getLogger(ClassTimetableServiceImpl.class.getName());

    private final RoomRepository roomRepository;
    private final EduClassRepository eduClassRepository;
    private final ClassSessionRepository classSessionRepository;
    private final CourseRepository courseRepository;
    private final TeacherRepository teacherRepository;
    private final UserRepository userRepository;
    private final AuditLogRepository auditLogRepository;
    private final Supplier<EntityManager> emSupplier;

    public ClassTimetableServiceImpl() {
        this(new RoomRepository(), new EduClassRepository(), new ClassSessionRepository(),
             new CourseRepository(), new TeacherRepository(), new UserRepository(),
             new AuditLogRepository(), JPAUtil::getEntityManager);
    }

    public ClassTimetableServiceImpl(RoomRepository roomRepository,
                                     EduClassRepository eduClassRepository,
                                     ClassSessionRepository classSessionRepository,
                                     CourseRepository courseRepository,
                                     TeacherRepository teacherRepository,
                                     UserRepository userRepository,
                                     AuditLogRepository auditLogRepository,
                                     Supplier<EntityManager> emSupplier) {
        this.roomRepository = Objects.requireNonNull(roomRepository, "roomRepository must not be null");
        this.eduClassRepository = Objects.requireNonNull(eduClassRepository, "eduClassRepository must not be null");
        this.classSessionRepository = Objects.requireNonNull(classSessionRepository, "classSessionRepository must not be null");
        this.courseRepository = Objects.requireNonNull(courseRepository, "courseRepository must not be null");
        this.teacherRepository = Objects.requireNonNull(teacherRepository, "teacherRepository must not be null");
        this.userRepository = Objects.requireNonNull(userRepository, "userRepository must not be null");
        this.auditLogRepository = Objects.requireNonNull(auditLogRepository, "auditLogRepository must not be null");
        this.emSupplier = Objects.requireNonNull(emSupplier, "emSupplier must not be null");
    }

    @Override
    public ClassAdminStatsDTO getClassStats() {
        EntityManager em = emSupplier.get();
        try {
            long totalClasses = eduClassRepository.countTotal(em);
            long openClasses = eduClassRepository.countByStatus(em, "OPEN");
            long ongoingClasses = eduClassRepository.countByStatus(em, "ONGOING");
            long closedClasses = eduClassRepository.countByStatus(em, "CLOSED");
            long totalRooms = roomRepository.countTotalRooms(em);
            long availableRooms = roomRepository.countAvailableRooms(em);

            return new ClassAdminStatsDTO(totalClasses, openClasses, ongoingClasses, closedClasses, totalRooms, availableRooms);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<RoomDTO> getAllRooms() {
        EntityManager em = emSupplier.get();
        try {
            List<Room> rooms = roomRepository.findAll(em);
            List<RoomDTO> dtos = new ArrayList<>();
            for (Room r : rooms) {
                RoomDTO dto = toRoomDTO(r);
                dto.setActiveClassesCount(roomRepository.countClassesByRoom(em, r.getId()));
                dtos.add(dto);
            }
            return dtos;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<RoomDTO> getAvailableRooms() {
        EntityManager em = emSupplier.get();
        try {
            List<Room> rooms = roomRepository.findAvailableRooms(em);
            List<RoomDTO> dtos = new ArrayList<>();
            for (Room r : rooms) {
                dtos.add(toRoomDTO(r));
            }
            return dtos;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public RoomDTO getRoomById(Long id) {
        if (id == null) return null;
        EntityManager em = emSupplier.get();
        try {
            return roomRepository.findById(em, id).map(this::toRoomDTO).orElse(null);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public RoomDTO createRoom(RoomFormDTO form, Long actorUserId) {
        validateRoomForm(form);
        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (roomRepository.findByCode(em, form.getCode()).isPresent()) {
                throw new ValidationException("Mã phòng học '" + form.getCode() + "' đã tồn tại!");
            }

            Room room = new Room(form.getCode().trim().toUpperCase(), form.getName().trim(), 
                                 form.getCapacity(), form.getStatus());
            roomRepository.save(em, room);

            logAudit(em, actorUserId, "CREATE_ROOM", "Rooms", room.getId(),
                     "Tạo mới phòng học: " + room.getCode() + " - " + room.getName());

            tx.commit();
            return toRoomDTO(room);
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi tạo phòng học", e);
            throw new RuntimeException("Không thể tạo phòng học: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public RoomDTO updateRoom(RoomFormDTO form, Long actorUserId) {
        if (form.getId() == null) throw new ValidationException("ID phòng học không hợp lệ!");
        validateRoomForm(form);

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Room room = roomRepository.findById(em, form.getId())
                .orElseThrow(() -> new ValidationException("Phòng học không tồn tại!"));

            Optional<Room> existingCode = roomRepository.findByCode(em, form.getCode());
            if (existingCode.isPresent() && !existingCode.get().getId().equals(room.getId())) {
                throw new ValidationException("Mã phòng học '" + form.getCode() + "' đã được sử dụng!");
            }

            room.setCode(form.getCode().trim().toUpperCase());
            room.setName(form.getName().trim());
            room.setCapacity(form.getCapacity());
            room.setStatus(form.getStatus());

            roomRepository.update(em, room);

            logAudit(em, actorUserId, "UPDATE_ROOM", "Rooms", room.getId(),
                     "Cập nhật phòng học: " + room.getCode() + " (" + room.getStatus() + ")");

            tx.commit();
            return toRoomDTO(room);
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật phòng học", e);
            throw new RuntimeException("Không thể cập nhật phòng học: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<ClassAdminViewDTO> getClasses(ClassFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            List<EduClass> classes = eduClassRepository.findClasses(em, filter);
            List<ClassAdminViewDTO> dtos = new ArrayList<>();
            for (EduClass c : classes) {
                ClassAdminViewDTO dto = toClassAdminViewDTO(c);
                dto.setEnrolledCount(eduClassRepository.countEnrolledStudents(em, c.getId()));
                dtos.add(dto);
            }
            return dtos;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public long countClasses(ClassFilterDTO filter) {
        EntityManager em = emSupplier.get();
        try {
            return eduClassRepository.countClasses(em, filter);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public ClassDetailDTO getClassDetail(Long id) {
        if (id == null) return null;
        EntityManager em = emSupplier.get();
        try {
            EduClass c = eduClassRepository.findById(em, id).orElse(null);
            if (c == null) return null;

            ClassDetailDTO dto = toClassDetailDTO(c);
            dto.setEnrolledCount(eduClassRepository.countEnrolledStudents(em, c.getId()));

            List<ClassSession> sessions = classSessionRepository.findByClassId(em, c.getId());
            List<ClassSessionDTO> sessionDTOs = new ArrayList<>();
            for (ClassSession s : sessions) {
                sessionDTOs.add(toClassSessionDTO(s));
            }
            dto.setSessions(sessionDTOs);

            return dto;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public ClassFormDTO getClassForm(Long id) {
        if (id == null) return null;
        EntityManager em = emSupplier.get();
        try {
            EduClass c = eduClassRepository.findById(em, id).orElse(null);
            if (c == null) return null;

            ClassFormDTO form = new ClassFormDTO();
            form.setId(c.getId());
            form.setCourseId(c.getCourse().getId());
            form.setTeacherId(c.getTeacher().getId());
            form.setRoomId(c.getRoom() != null ? c.getRoom().getId() : null);
            form.setCode(c.getCode());
            form.setName(c.getName());
            form.setCapacity(c.getCapacity());
            form.setStartDate(c.getStartDate());
            form.setEndDate(c.getEndDate());
            form.setStatus(c.getStatus());

            return form;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public Long createClass(ClassFormDTO form, Long actorUserId) {
        validateClassForm(form);
        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            // BR04: Khóa học phải ở trạng thái OPEN
            Course course = courseRepository.findById(em, form.getCourseId())
                .orElseThrow(() -> new ValidationException("Khóa học không tồn tại!"));
            if (!"OPEN".equalsIgnoreCase(course.getStatus())) {
                throw new ValidationException("Chỉ được tạo lớp cho khóa học đang mở tuyển sinh (OPEN)!");
            }

            // Giáo viên phụ trách
            Teacher teacher = teacherRepository.findById(em, form.getTeacherId())
                .orElseThrow(() -> new ValidationException("Giáo viên không tồn tại!"));

            // Phòng học (nếu có chọn)
            Room room = null;
            if (form.getRoomId() != null && form.getRoomId() > 0) {
                room = roomRepository.findById(em, form.getRoomId())
                    .orElseThrow(() -> new ValidationException("Phòng học không tồn tại!"));
                if ("MAINTENANCE".equalsIgnoreCase(room.getStatus())) {
                    throw new ValidationException("Phòng học " + room.getCode() + " đang bảo trì, không thể xếp lớp!");
                }
                if (form.getCapacity() > room.getCapacity()) {
                    throw new ValidationException("Sĩ số lớp (" + form.getCapacity() + 
                                                  ") vượt quá sức chứa phòng " + room.getCode() + " (" + room.getCapacity() + " chỗ)!");
                }
            }

            // Kiểm tra trùng mã lớp
            if (eduClassRepository.findByCode(em, form.getCode()).isPresent()) {
                throw new ValidationException("Mã lớp '" + form.getCode() + "' đã tồn tại!");
            }

            EduClass eduClass = new EduClass();
            eduClass.setCourse(course);
            eduClass.setTeacher(teacher);
            eduClass.setRoom(room);
            eduClass.setCode(form.getCode().trim().toUpperCase());
            eduClass.setName(form.getName().trim());
            eduClass.setCapacity(form.getCapacity());
            eduClass.setStartDate(form.getStartDate());
            eduClass.setEndDate(form.getEndDate());
            eduClass.setStatus(form.getStatus() != null ? form.getStatus().toUpperCase() : "OPEN");
            eduClass.setCreatedAt(LocalDateTime.now());
            eduClass.setUpdatedAt(LocalDateTime.now());

            eduClassRepository.save(em, eduClass);

            logAudit(em, actorUserId, "CREATE_CLASS", "Classes", eduClass.getId(),
                     "Tạo mới lớp học: " + eduClass.getCode() + " - " + eduClass.getName());

            tx.commit();
            return eduClass.getId();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi tạo lớp học", e);
            throw new RuntimeException("Không thể tạo lớp học: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void updateClass(ClassFormDTO form, Long actorUserId) {
        if (form.getId() == null) throw new ValidationException("ID lớp học không hợp lệ!");
        validateClassForm(form);

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            EduClass eduClass = eduClassRepository.findById(em, form.getId())
                .orElseThrow(() -> new ValidationException("Lớp học không tồn tại!"));

            // BR19: Lớp CLOSED không được cập nhật bình thường
            if ("CLOSED".equalsIgnoreCase(eduClass.getStatus()) && !"CLOSED".equalsIgnoreCase(form.getStatus())) {
                throw new ValidationException("Lớp học đã đóng (CLOSED), không thể cập nhật!");
            }

            // Khóa học
            Course course = courseRepository.findById(em, form.getCourseId())
                .orElseThrow(() -> new ValidationException("Khóa học không tồn tại!"));

            // Giáo viên
            Teacher teacher = teacherRepository.findById(em, form.getTeacherId())
                .orElseThrow(() -> new ValidationException("Giáo viên không tồn tại!"));

            // Kiểm tra sĩ số với học viên đang ACTIVE (FR-003)
            long activeEnrolled = eduClassRepository.countEnrolledStudents(em, eduClass.getId());
            if (form.getCapacity() < activeEnrolled) {
                throw new ValidationException("Sĩ số tối đa không thể nhỏ hơn số học viên hiện tại (" + activeEnrolled + " học viên)!");
            }

            // Phòng học
            Room room = null;
            if (form.getRoomId() != null && form.getRoomId() > 0) {
                room = roomRepository.findById(em, form.getRoomId())
                    .orElseThrow(() -> new ValidationException("Phòng học không tồn tại!"));
                if (form.getCapacity() > room.getCapacity()) {
                    throw new ValidationException("Sĩ số lớp (" + form.getCapacity() + 
                                                  ") vượt quá sức chứa phòng " + room.getCode() + " (" + room.getCapacity() + " chỗ)!");
                }
            }

            // Kiểm tra mã lớp trùng
            Optional<EduClass> existingCode = eduClassRepository.findByCode(em, form.getCode());
            if (existingCode.isPresent() && !existingCode.get().getId().equals(eduClass.getId())) {
                throw new ValidationException("Mã lớp '" + form.getCode() + "' đã được sử dụng!");
            }

            eduClass.setCourse(course);
            eduClass.setTeacher(teacher);
            eduClass.setRoom(room);
            eduClass.setCode(form.getCode().trim().toUpperCase());
            eduClass.setName(form.getName().trim());
            eduClass.setCapacity(form.getCapacity());
            eduClass.setStartDate(form.getStartDate());
            eduClass.setEndDate(form.getEndDate());
            eduClass.setStatus(form.getStatus());
            eduClass.setUpdatedAt(LocalDateTime.now());

            eduClassRepository.update(em, eduClass);

            logAudit(em, actorUserId, "UPDATE_CLASS", "Classes", eduClass.getId(),
                     "Cập nhật thông tin lớp: " + eduClass.getCode());

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật lớp học", e);
            throw new RuntimeException("Không thể cập nhật lớp học: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public void changeClassStatus(Long classId, String newStatus, Long actorUserId) {
        if (classId == null) throw new ValidationException("ID lớp không hợp lệ!");
        if (newStatus == null || newStatus.trim().isEmpty()) throw new ValidationException("Trạng thái mới không hợp lệ!");

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            EduClass eduClass = eduClassRepository.findById(em, classId)
                .orElseThrow(() -> new ValidationException("Lớp học không tồn tại!"));

            String oldStatus = eduClass.getStatus();
            eduClass.setStatus(newStatus.trim().toUpperCase());
            eduClass.setUpdatedAt(LocalDateTime.now());
            eduClassRepository.update(em, eduClass);

            logAudit(em, actorUserId, "CHANGE_CLASS_STATUS", "Classes", eduClass.getId(),
                     "Chuyển trạng thái lớp " + eduClass.getCode() + " từ " + oldStatus + " sang " + newStatus);

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi đổi trạng thái lớp", e);
            throw new RuntimeException("Không thể đổi trạng thái lớp: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public List<ClassSessionDTO> getClassSessions(Long classId) {
        if (classId == null) return List.of();
        EntityManager em = emSupplier.get();
        try {
            List<ClassSession> sessions = classSessionRepository.findByClassId(em, classId);
            List<ClassSessionDTO> dtos = new ArrayList<>();
            for (ClassSession s : sessions) {
                dtos.add(toClassSessionDTO(s));
            }
            return dtos;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public int generateSchedule(ScheduleGeneratorDTO dto, Long actorUserId) {
        if (dto.getClassId() == null) throw new ValidationException("Lớp học không hợp lệ!");
        if (dto.getDaysOfWeek() == null || dto.getDaysOfWeek().isEmpty()) {
            throw new ValidationException("Vui lòng chọn ít nhất một thứ trong tuần để xếp lịch!");
        }
        if (dto.getStartAt() == null || dto.getEndAt() == null) {
            throw new ValidationException("Vui lòng nhập giờ bắt đầu và giờ kết thúc!");
        }
        if (!dto.getEndAt().isAfter(dto.getStartAt())) {
            throw new ValidationException("Giờ kết thúc phải sau giờ bắt đầu!");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            EduClass eduClass = eduClassRepository.findById(em, dto.getClassId())
                .orElseThrow(() -> new ValidationException("Lớp học không tồn tại!"));

            // BR19: Lớp CLOSED hoặc CANCELLED không được tạo thêm buổi học
            if ("CLOSED".equalsIgnoreCase(eduClass.getStatus()) || "CANCELLED".equalsIgnoreCase(eduClass.getStatus())) {
                throw new ValidationException("Lớp học đang ở trạng thái " + eduClass.getStatus() + ", không thể sinh lịch học mới (BR19)!");
            }

            // Xác định giáo viên thực dạy
            Long teacherId = dto.getTeacherId() != null ? dto.getTeacherId() : eduClass.getTeacher().getId();
            Teacher teacher = teacherRepository.findById(em, teacherId)
                .orElseThrow(() -> new ValidationException("Giáo viên giảng dạy không tồn tại!"));

            // Xác định phòng học
            Long roomId = dto.getRoomId() != null ? dto.getRoomId() : (eduClass.getRoom() != null ? eduClass.getRoom().getId() : null);
            if (roomId == null) {
                throw new ValidationException("Chưa chọn phòng học cho buổi học!");
            }
            Room room = roomRepository.findById(em, roomId)
                .orElseThrow(() -> new ValidationException("Phòng học không tồn tại!"));
            if ("MAINTENANCE".equalsIgnoreCase(room.getStatus())) {
                throw new ValidationException("Phòng " + room.getCode() + " đang bảo trì, không thể xếp lịch!");
            }

            int targetSessions = dto.getTotalSessions() != null && dto.getTotalSessions() > 0 ? dto.getTotalSessions() : 10;
            LocalDate currentDate = dto.getStartDate() != null ? dto.getStartDate() : eduClass.getStartDate();
            LocalDate maxDate = eduClass.getEndDate();

            List<ClassSession> newSessions = new ArrayList<>();
            DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
            DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

            int generatedCount = 0;
            while (generatedCount < targetSessions && !currentDate.isAfter(maxDate.plusMonths(3))) {
                int dayOfWeekCode = toVietnameseDayOfWeek(currentDate.getDayOfWeek());

                if (dto.getDaysOfWeek().contains(dayOfWeekCode)) {
                    // Kiểm tra xem ngày này có bị loại trừ không
                    if (dto.getExcludeDates() == null || !dto.getExcludeDates().contains(currentDate)) {
                        
                        // BR05: Kiểm tra xung đột lịch giáo viên
                        List<ClassSession> teacherConflicts = classSessionRepository.checkTeacherConflict(
                            em, teacher.getId(), currentDate, dto.getStartAt(), dto.getEndAt(), null);
                        if (!teacherConflicts.isEmpty()) {
                            ClassSession conf = teacherConflicts.get(0);
                            throw new ValidationException("Trùng lịch giáo viên " + teacher.getUser().getFullName() + 
                                " vào ngày " + currentDate.format(dateFmt) + " (" + dto.getStartAt().format(timeFmt) + 
                                "-" + dto.getEndAt().format(timeFmt) + ") với lớp " + conf.getEduClass().getName() + " (BR05)!");
                        }

                        // BR06: Kiểm tra xung đột phòng học
                        List<ClassSession> roomConflicts = classSessionRepository.checkRoomConflict(
                            em, room.getId(), currentDate, dto.getStartAt(), dto.getEndAt(), null);
                        if (!roomConflicts.isEmpty()) {
                            ClassSession conf = roomConflicts.get(0);
                            throw new ValidationException("Trùng lịch phòng học " + room.getName() + " (" + room.getCode() + 
                                ") vào ngày " + currentDate.format(dateFmt) + " (" + dto.getStartAt().format(timeFmt) + 
                                "-" + dto.getEndAt().format(timeFmt) + ") với lớp " + conf.getEduClass().getName() + " (BR06)!");
                        }

                        // Hợp lệ -> tạo entity
                        ClassSession session = new ClassSession();
                        session.setEduClass(eduClass);
                        session.setRoom(room);
                        session.setTeacher(teacher);
                        session.setSessionDate(currentDate);
                        session.setStartAt(dto.getStartAt());
                        session.setEndAt(dto.getEndAt());
                        session.setTitle("Buổi " + (generatedCount + 1) + ": " + eduClass.getName());
                        session.setStatus("SCHEDULED");
                        session.setCreatedAt(LocalDateTime.now());
                        session.setUpdatedAt(LocalDateTime.now());

                        newSessions.add(session);
                        generatedCount++;
                    }
                }
                currentDate = currentDate.plusDays(1);
            }

            if (newSessions.isEmpty()) {
                throw new ValidationException("Không có buổi học nào được sinh ra! Vui lòng kiểm tra lại thứ trong tuần và khoảng thời gian.");
            }

            // Persist toàn bộ (Atomic batch)
            for (ClassSession s : newSessions) {
                classSessionRepository.save(em, s);
            }

            logAudit(em, actorUserId, "GENERATE_SCHEDULE", "Classes", eduClass.getId(),
                     "Tự động sinh " + newSessions.size() + " buổi học cho lớp: " + eduClass.getCode());

            tx.commit();
            return newSessions.size();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi sinh lịch học", e);
            throw new RuntimeException("Không thể sinh lịch học: " + e.getMessage(), e);
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    @Override
    public TimetableGridDTO getTimetableWeek(LocalDate weekStartDate) {
        if (weekStartDate == null) {
            weekStartDate = LocalDate.now().with(DayOfWeek.MONDAY);
        } else {
            weekStartDate = weekStartDate.with(DayOfWeek.MONDAY);
        }
        LocalDate weekEndDate = weekStartDate.plusDays(6);

        EntityManager em = emSupplier.get();
        try {
            List<ClassSession> sessions = classSessionRepository.findSessionsBetween(em, weekStartDate, weekEndDate);
            TimetableGridDTO grid = new TimetableGridDTO(weekStartDate, weekEndDate);
            List<ClassSessionDTO> dtos = new ArrayList<>();
            for (ClassSession s : sessions) {
                dtos.add(toClassSessionDTO(s));
            }
            grid.setSessions(dtos);
            return grid;
        } finally {
            if (em.isOpen()) em.close();
        }
    }

    // Helper methods
    private int toVietnameseDayOfWeek(DayOfWeek dow) {
        switch (dow) {
            case MONDAY: return 2;
            case TUESDAY: return 3;
            case WEDNESDAY: return 4;
            case THURSDAY: return 5;
            case FRIDAY: return 6;
            case SATURDAY: return 7;
            case SUNDAY: return 8;
            default: return 2;
        }
    }

    private void validateRoomForm(RoomFormDTO form) {
        if (form.getCode() == null || form.getCode().trim().isEmpty()) {
            throw new ValidationException("Mã phòng học không được để trống!");
        }
        if (form.getName() == null || form.getName().trim().isEmpty()) {
            throw new ValidationException("Tên phòng học không được để trống!");
        }
        if (form.getCapacity() == null || form.getCapacity() <= 0) {
            throw new ValidationException("Sức chứa phòng học phải lớn hơn 0!");
        }
    }

    private void validateClassForm(ClassFormDTO form) {
        if (form.getCourseId() == null || form.getCourseId() <= 0) {
            throw new ValidationException("Vui lòng chọn khóa học liên kết!");
        }
        if (form.getTeacherId() == null || form.getTeacherId() <= 0) {
            throw new ValidationException("Vui lòng chọn giáo viên phụ trách!");
        }
        if (form.getCode() == null || form.getCode().trim().isEmpty()) {
            throw new ValidationException("Mã lớp học không được để trống!");
        }
        if (form.getName() == null || form.getName().trim().isEmpty()) {
            throw new ValidationException("Tên lớp học không được để trống!");
        }
        if (form.getCapacity() == null || form.getCapacity() <= 0) {
            throw new ValidationException("Sĩ số tối đa phải lớn hơn 0 (BR04)!");
        }
        if (form.getStartDate() == null || form.getEndDate() == null) {
            throw new ValidationException("Vui lòng chọn ngày bắt đầu và kết thúc!");
        }
        if (form.getEndDate().isBefore(form.getStartDate())) {
            throw new ValidationException("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu (BR04)!");
        }
    }

    private RoomDTO toRoomDTO(Room r) {
        RoomDTO dto = new RoomDTO();
        dto.setId(r.getId());
        dto.setCode(r.getCode());
        dto.setName(r.getName());
        dto.setCapacity(r.getCapacity());
        dto.setStatus(r.getStatus());
        dto.setCreatedAt(r.getCreatedAt());
        return dto;
    }

    private ClassAdminViewDTO toClassAdminViewDTO(EduClass c) {
        ClassAdminViewDTO dto = new ClassAdminViewDTO();
        dto.setId(c.getId());
        dto.setCode(c.getCode());
        dto.setName(c.getName());
        if (c.getCourse() != null) {
            dto.setCourseId(c.getCourse().getId());
            dto.setCourseName(c.getCourse().getName());
            dto.setCourseCode(c.getCourse().getCode());
        }
        if (c.getTeacher() != null) {
            dto.setTeacherId(c.getTeacher().getId());
            if (c.getTeacher().getUser() != null) {
                dto.setTeacherName(c.getTeacher().getUser().getFullName());
            }
        }
        if (c.getRoom() != null) {
            dto.setRoomId(c.getRoom().getId());
            dto.setRoomName(c.getRoom().getName() + " (" + c.getRoom().getCode() + ")");
        }
        dto.setCapacity(c.getCapacity());
        dto.setStartDate(c.getStartDate());
        dto.setEndDate(c.getEndDate());
        dto.setStatus(c.getStatus());
        return dto;
    }

    private ClassDetailDTO toClassDetailDTO(EduClass c) {
        ClassDetailDTO dto = new ClassDetailDTO();
        dto.setId(c.getId());
        dto.setCode(c.getCode());
        dto.setName(c.getName());
        if (c.getCourse() != null) {
            dto.setCourseId(c.getCourse().getId());
            dto.setCourseName(c.getCourse().getName());
            dto.setCourseCode(c.getCourse().getCode());
            dto.setTotalCourseSessions(c.getCourse().getTotalSessions());
            if (c.getCourse().getSubject() != null) {
                dto.setSubjectName(c.getCourse().getSubject().getName());
            }
        }
        if (c.getTeacher() != null) {
            dto.setTeacherId(c.getTeacher().getId());
            if (c.getTeacher().getUser() != null) {
                dto.setTeacherName(c.getTeacher().getUser().getFullName());
                dto.setTeacherEmail(c.getTeacher().getUser().getEmail());
                dto.setTeacherPhone(c.getTeacher().getUser().getPhone());
            }
        }
        if (c.getRoom() != null) {
            dto.setRoomId(c.getRoom().getId());
            dto.setRoomName(c.getRoom().getName());
            dto.setRoomCode(c.getRoom().getCode());
            dto.setRoomCapacity(c.getRoom().getCapacity());
        }
        dto.setCapacity(c.getCapacity());
        dto.setStartDate(c.getStartDate());
        dto.setEndDate(c.getEndDate());
        dto.setStatus(c.getStatus());
        dto.setVersion(c.getVersion());
        return dto;
    }

    private ClassSessionDTO toClassSessionDTO(ClassSession s) {
        ClassSessionDTO dto = new ClassSessionDTO();
        dto.setId(s.getId());
        if (s.getEduClass() != null) {
            dto.setClassId(s.getEduClass().getId());
            dto.setClassName(s.getEduClass().getName());
            dto.setClassCode(s.getEduClass().getCode());
            if (s.getEduClass().getCourse() != null && s.getEduClass().getCourse().getSubject() != null) {
                dto.setSubjectCode(s.getEduClass().getCourse().getSubject().getCode());
                dto.setSubjectName(s.getEduClass().getCourse().getSubject().getName());
            }
        }
        if (s.getRoom() != null) {
            dto.setRoomId(s.getRoom().getId());
            dto.setRoomName(s.getRoom().getName());
            dto.setRoomCode(s.getRoom().getCode());
        }
        if (s.getTeacher() != null) {
            dto.setTeacherId(s.getTeacher().getId());
            if (s.getTeacher().getUser() != null) {
                dto.setTeacherName(s.getTeacher().getUser().getFullName());
            }
        }
        dto.setSessionDate(s.getSessionDate());
        dto.setStartAt(s.getStartAt());
        dto.setEndAt(s.getEndAt());
        dto.setTitle(s.getTitle());
        dto.setStatus(s.getStatus());
        return dto;
    }

    private void logAudit(EntityManager em, Long actorUserId, String action, String entityName, Long entityId, String details) {
        try {
            AuditLog log = new AuditLog();
            log.setAction(action);
            log.setEntityType(entityName);
            log.setEntityId(entityId);
            log.setNewValues(details);
            log.setActorId(actorUserId);
            log.setIpAddress("127.0.0.1");
            log.setCreatedAt(LocalDateTime.now());
            auditLogRepository.save(em, log);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Không thể ghi AuditLog: " + e.getMessage());
        }
    }
}
