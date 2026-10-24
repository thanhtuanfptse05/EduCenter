package com.educenter.service;

import com.educenter.dto.AttendanceRosterItemDTO;
import com.educenter.dto.AttendanceSessionViewDTO;
import com.educenter.dto.TeachingJournalDTO;
import com.educenter.entity.*;
import com.educenter.repository.AttendanceRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AttendanceServiceImpl implements AttendanceService {

    private static final Logger LOGGER = Logger.getLogger(AttendanceServiceImpl.class.getName());

    private final AttendanceRepository attendanceRepository;
    private final java.util.function.Supplier<EntityManager> emSupplier;

    public AttendanceServiceImpl() {
        this(new AttendanceRepository(), JPAUtil::getEntityManager);
    }

    public AttendanceServiceImpl(AttendanceRepository attendanceRepository) {
        this(attendanceRepository, JPAUtil::getEntityManager);
    }

    public AttendanceServiceImpl(AttendanceRepository attendanceRepository, java.util.function.Supplier<EntityManager> emSupplier) {
        this.attendanceRepository = attendanceRepository;
        this.emSupplier = (emSupplier != null) ? emSupplier : JPAUtil::getEntityManager;
    }

    protected EntityManager getEntityManager() {
        return emSupplier.get();
    }

    @Override
    public List<AttendanceSessionViewDTO> getTeacherSessions(Long teacherUserId, LocalDate sessionDate, boolean isAdmin) {
        EntityManager em = getEntityManager();
        try {
            Long queryUserId = isAdmin ? null : teacherUserId;
            return attendanceRepository.findSessionsForTeacher(em, queryUserId, sessionDate);
        } finally {
            em.close();
        }
    }

    @Override
    public AttendanceSessionViewDTO getSessionAttendance(Long sessionId, Long teacherUserId, boolean isAdmin) {
        if (sessionId == null) {
            throw new ValidationException("Mã buổi học không được để trống!");
        }

        EntityManager em = getEntityManager();
        try {
            ClassSession session = attendanceRepository.findSessionById(em, sessionId)
                    .orElseThrow(() -> new ValidationException("Buổi học không tồn tại!"));

            // Kiểm tra phân quyền giáo viên thực dạy
            validateTeacherPermission(session, teacherUserId, isAdmin);

            AttendanceSessionViewDTO dto = new AttendanceSessionViewDTO();
            dto.setSessionId(session.getId());
            dto.setClassId(session.getEduClass().getId());
            dto.setClassCode(session.getEduClass().getCode());
            dto.setClassName(session.getEduClass().getName());
            dto.setSubjectName(session.getEduClass().getCourse().getSubject().getName());
            dto.setTeacherId(session.getTeacher().getId());
            dto.setTeacherName(session.getTeacher().getUser().getFullName());
            dto.setRoomName(session.getRoom() != null ? session.getRoom().getName() : "Chưa xếp phòng");
            dto.setSessionDate(session.getSessionDate());
            dto.setStartTime(session.getStartAt());
            dto.setEndTime(session.getEndAt());
            dto.setSessionStatus(session.getStatus());

            // Lấy danh sách điểm danh của buổi
            List<AttendanceRosterItemDTO> roster = attendanceRepository.findRosterForSession(
                    em, session.getId(), session.getEduClass().getId(), session.getSessionDate()
            );
            dto.setRoster(roster);
            dto.setTotalStudents(roster.size());

            int present = 0, late = 0, excused = 0, unexcused = 0, unrecorded = 0;
            for (AttendanceRosterItemDTO item : roster) {
                if ("PRESENT".equalsIgnoreCase(item.getAttendanceStatus())) present++;
                else if ("LATE".equalsIgnoreCase(item.getAttendanceStatus())) late++;
                else if ("ABSENT_EXCUSED".equalsIgnoreCase(item.getAttendanceStatus())) excused++;
                else if ("ABSENT_UNEXCUSED".equalsIgnoreCase(item.getAttendanceStatus())) unexcused++;
                else unrecorded++;
            }
            dto.setPresentCount(present);
            dto.setLateCount(late);
            dto.setExcusedCount(excused);
            dto.setUnexcusedCount(unexcused);
            dto.setUnrecordedCount(unrecorded);

            // Journal
            Optional<TeachingJournal> journalOpt = attendanceRepository.findJournalBySessionId(em, sessionId);
            if (journalOpt.isPresent()) {
                dto.setHasJournal(true);
                TeachingJournal j = journalOpt.get();
                dto.setJournal(new TeachingJournalDTO(j.getId(), session.getId(), j.getContent(), j.getHomework(), j.getTeacherRemarks(), j.getUpdatedAt()));
            } else {
                dto.setHasJournal(false);
            }

            return dto;
        } finally {
            em.close();
        }
    }

    @Override
    public void saveAttendance(Long sessionId, List<AttendanceRosterItemDTO> rosterItems, Long actorUserId, boolean isAdmin) {
        if (sessionId == null) {
            throw new ValidationException("Mã buổi học không được để trống!");
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            ClassSession session = attendanceRepository.findSessionById(em, sessionId)
                    .orElseThrow(() -> new ValidationException("Buổi học không tồn tại!"));

            validateTeacherPermission(session, actorUserId, isAdmin);

            // FR-004: Chưa đến ngày diễn ra ca học thì không được mở điểm danh
            if (session.getSessionDate() != null && session.getSessionDate().isAfter(LocalDate.now())) {
                throw new ValidationException("Chưa đến ngày diễn ra ca học (" + session.getSessionDate() + "). Bạn chỉ có thể điểm danh khi đến ngày học!");
            }

            // FR-005 (v1.1): giáo viên thực dạy (đã qua validateTeacherPermission) được sửa buổi COMPLETED
            if ("CANCELLED".equalsIgnoreCase(session.getStatus())) {
                throw new ValidationException("Buổi học đã bị hủy, không thể điểm danh!");
            }

            User actor = em.find(User.class, actorUserId);
            if (actor == null && session.getTeacher() != null && session.getTeacher().getUser() != null) {
                actor = session.getTeacher().getUser();
            }
            if (actor == null) {
                throw new ValidationException("Không xác định được danh tính người thực hiện điểm danh!");
            }

            tx.begin();

            // Nếu buổi đang SCHEDULED, tự động chuyển sang IN_PROGRESS
            if ("SCHEDULED".equalsIgnoreCase(session.getStatus())) {
                session.setStatus("IN_PROGRESS");
                session.setUpdatedAt(LocalDateTime.now());
                em.merge(session);
            }

            if (rosterItems != null) {
                // Khử trùng lặp studentId nếu danh sách form gửi lên có phần tử lặp
                java.util.Map<Long, AttendanceRosterItemDTO> uniqueItems = new java.util.LinkedHashMap<>();
                for (AttendanceRosterItemDTO item : rosterItems) {
                    if (item != null && item.getStudentId() != null) {
                        uniqueItems.put(item.getStudentId(), item);
                    }
                }

                for (AttendanceRosterItemDTO item : uniqueItems.values()) {
                    String status = item.getAttendanceStatus();
                    if (status == null || status.isBlank()) continue;

                    // Validate trạng thái (FR-002)
                    if (!"PRESENT".equals(status) && !"LATE".equals(status)
                            && !"ABSENT_EXCUSED".equals(status) && !"ABSENT_UNEXCUSED".equals(status)) {
                        throw new ValidationException("Trạng thái điểm danh '" + status + "' không hợp lệ!");
                    }

                    // B01: Kiểm tra học viên có thuộc danh sách hợp lệ của lớp tại thời điểm buổi học hoặc đã có bản ghi điểm danh
                    Optional<Attendance> existingOpt = attendanceRepository.findAttendanceBySessionAndStudent(em, sessionId, item.getStudentId());
                    if (existingOpt.isEmpty()) {
                        long validCount = attendanceRepository.countValidEnrollmentForStudent(em, session.getEduClass().getId(), item.getStudentId(), session.getSessionDate());
                        if (validCount <= 0) {
                            throw new ValidationException("Học viên (ID: " + item.getStudentId() + ") không có ghi danh hợp lệ trong lớp " + session.getEduClass().getCode() + " vào ngày " + session.getSessionDate() + "!");
                        }
                    }

                    Student student = em.find(Student.class, item.getStudentId());
                    if (student == null) {
                        throw new ValidationException("Học viên (ID: " + item.getStudentId() + ") không tồn tại trong hệ thống!");
                    }

                    Attendance attendance = existingOpt.orElseGet(() -> {
                        Attendance a = new Attendance();
                        a.setSession(session);
                        a.setStudent(student);
                        return a;
                    });

                    attendance.setStatus(status);
                    attendance.setRemarks(item.getRemarks());
                    attendance.setRecordedBy(actor);
                    attendance.setRecordedAt(LocalDateTime.now());

                    attendanceRepository.saveAttendance(em, attendance);
                }
            }

            tx.commit();
            LOGGER.info("Lưu điểm danh thành công cho ca học ID: " + sessionId + " bởi User: " + actorUserId);

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu điểm danh: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi lưu điểm danh: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public void completeSessionAttendance(Long sessionId, Long actorUserId, boolean isAdmin) {
        if (sessionId == null) {
            throw new ValidationException("Mã buổi học không được để trống!");
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            ClassSession session = attendanceRepository.findSessionById(em, sessionId)
                    .orElseThrow(() -> new ValidationException("Buổi học không tồn tại!"));

            validateTeacherPermission(session, actorUserId, isAdmin);

            // FR-004: Chưa đến ngày diễn ra ca học thì không thể chốt
            if (session.getSessionDate() != null && session.getSessionDate().isAfter(LocalDate.now())) {
                throw new ValidationException("Chưa đến ngày diễn ra ca học (" + session.getSessionDate() + "). Không thể chốt hoàn tất ca học tương lai!");
            }

            if ("CANCELLED".equalsIgnoreCase(session.getStatus())) {
                throw new ValidationException("Buổi học đã bị hủy, không thể hoàn tất!");
            }

            // FR-004: Kiểm tra còn học viên nào chưa điểm danh không
            List<AttendanceRosterItemDTO> roster = attendanceRepository.findRosterForSession(
                    em, session.getId(), session.getEduClass().getId(), session.getSessionDate()
            );

            boolean hasUnrecorded = roster.stream().anyMatch(r -> r.getAttendanceStatus() == null || r.getAttendanceStatus().isBlank());
            if (hasUnrecorded) {
                throw new ValidationException("Còn học viên chưa được ghi nhận điểm danh. Vui lòng điểm danh đầy đủ trước khi chốt buổi học!");
            }

            tx.begin();
            session.setStatus("COMPLETED");
            session.setUpdatedAt(LocalDateTime.now());
            em.merge(session);
            tx.commit();

            LOGGER.info("Chốt hoàn tất điểm danh ca học ID: " + sessionId);

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi chốt điểm danh: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi chốt điểm danh: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    @Override
    public TeachingJournalDTO getTeachingJournal(Long sessionId, Long teacherUserId, boolean isAdmin) {
        if (sessionId == null) {
            throw new ValidationException("Mã buổi học không được để trống!");
        }

        EntityManager em = getEntityManager();
        try {
            ClassSession session = attendanceRepository.findSessionById(em, sessionId)
                    .orElseThrow(() -> new ValidationException("Buổi học không tồn tại!"));

            validateTeacherPermission(session, teacherUserId, isAdmin);

            Optional<TeachingJournal> journalOpt = attendanceRepository.findJournalBySessionId(em, sessionId);
            if (journalOpt.isPresent()) {
                TeachingJournal j = journalOpt.get();
                return new TeachingJournalDTO(j.getId(), sessionId, j.getContent(), j.getHomework(), j.getTeacherRemarks(), j.getUpdatedAt());
            } else {
                return new TeachingJournalDTO(null, sessionId, "", "", "", null);
            }
        } finally {
            em.close();
        }
    }

    @Override
    public void saveTeachingJournal(Long sessionId, String content, String homework, String remarks, Long actorUserId, boolean isAdmin) {
        if (sessionId == null) {
            throw new ValidationException("Mã buổi học không được để trống!");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new ValidationException("Nội dung bài học không được để trống!");
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            ClassSession session = attendanceRepository.findSessionById(em, sessionId)
                    .orElseThrow(() -> new ValidationException("Buổi học không tồn tại!"));

            validateTeacherPermission(session, actorUserId, isAdmin);

            tx.begin();

            Optional<TeachingJournal> journalOpt = attendanceRepository.findJournalBySessionId(em, sessionId);
            TeachingJournal journal = journalOpt.orElseGet(() -> {
                TeachingJournal j = new TeachingJournal();
                j.setClassSession(session);
                return j;
            });

            journal.setContent(content.trim());
            journal.setHomework(homework != null ? homework.trim() : null);
            journal.setTeacherRemarks(remarks != null ? remarks.trim() : null);
            journal.setUpdatedAt(LocalDateTime.now());

            attendanceRepository.saveJournal(em, journal);

            tx.commit();
            LOGGER.info("Lưu nhật ký giảng dạy thành công cho ca học ID: " + sessionId);

        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu nhật ký: " + e.getMessage(), e);
            throw new RuntimeException("Lỗi khi lưu nhật ký: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }

    private void validateTeacherPermission(ClassSession session, Long teacherUserId, boolean isAdmin) {
        if (isAdmin) return; // Admin có toàn quyền
        if (teacherUserId == null) {
            throw new ValidationException("Không xác định được danh tính giáo viên!");
        }
        Long assignedTeacherUserId = session.getTeacher().getUser().getId();
        if (!assignedTeacherUserId.equals(teacherUserId)) {
            throw new ValidationException("Bạn không được phân công giảng dạy buổi học này!");
        }
    }
}
