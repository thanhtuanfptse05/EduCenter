package com.educenter.repository;

import com.educenter.dto.AttendanceRosterItemDTO;
import com.educenter.dto.AttendanceSessionViewDTO;
import com.educenter.dto.TeachingJournalDTO;
import com.educenter.entity.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class AttendanceRepository {

    public Optional<ClassSession> findSessionById(EntityManager em, Long sessionId) {
        if (sessionId == null) return Optional.empty();
        try {
            TypedQuery<ClassSession> query = em.createQuery(
                    "SELECT cs FROM ClassSession cs " +
                    "JOIN FETCH cs.eduClass c " +
                    "JOIN FETCH c.course cr " +
                    "JOIN FETCH cr.subject sub " +
                    "JOIN FETCH cs.teacher t " +
                    "JOIN FETCH t.user u " +
                    "LEFT JOIN FETCH cs.room r " +
                    "WHERE cs.id = :sessionId",
                    ClassSession.class
            );
            query.setParameter("sessionId", sessionId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<AttendanceSessionViewDTO> findSessionsForTeacher(EntityManager em, Long teacherUserId, LocalDate sessionDate) {
        StringBuilder jpql = new StringBuilder(
                "SELECT cs FROM ClassSession cs " +
                "JOIN FETCH cs.eduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "JOIN FETCH cs.teacher t " +
                "JOIN FETCH t.user u " +
                "LEFT JOIN FETCH cs.room r " +
                "WHERE 1=1 "
        );

        if (teacherUserId != null) {
            jpql.append("AND u.id = :teacherUserId ");
        }
        if (sessionDate != null) {
            jpql.append("AND cs.sessionDate = :sessionDate ");
        }

        jpql.append("ORDER BY cs.sessionDate DESC, cs.startAt ASC");

        TypedQuery<ClassSession> query = em.createQuery(jpql.toString(), ClassSession.class);
        if (teacherUserId != null) {
            query.setParameter("teacherUserId", teacherUserId);
        }
        if (sessionDate != null) {
            query.setParameter("sessionDate", sessionDate);
        }

        List<ClassSession> sessions = query.getResultList();
        List<AttendanceSessionViewDTO> results = new ArrayList<>();

        for (ClassSession cs : sessions) {
            AttendanceSessionViewDTO dto = new AttendanceSessionViewDTO();
            dto.setSessionId(cs.getId());
            dto.setClassId(cs.getEduClass().getId());
            dto.setClassCode(cs.getEduClass().getCode());
            dto.setClassName(cs.getEduClass().getName());
            dto.setSubjectName(cs.getEduClass().getCourse().getSubject().getName());
            dto.setTeacherId(cs.getTeacher().getId());
            dto.setTeacherName(cs.getTeacher().getUser().getFullName());
            dto.setRoomName(cs.getRoom() != null ? cs.getRoom().getName() : "Chưa xếp phòng");
            dto.setSessionDate(cs.getSessionDate());
            dto.setStartTime(cs.getStartAt());
            dto.setEndTime(cs.getEndAt());
            dto.setSessionStatus(cs.getStatus());

            // Thống kê số lượng điểm danh
            long totalRoster = countActiveStudentsInClass(em, cs.getEduClass().getId(), cs.getSessionDate());
            long present = countAttendanceByStatus(em, cs.getId(), "PRESENT");
            long late = countAttendanceByStatus(em, cs.getId(), "LATE");
            long excused = countAttendanceByStatus(em, cs.getId(), "ABSENT_EXCUSED");
            long unexcused = countAttendanceByStatus(em, cs.getId(), "ABSENT_UNEXCUSED");

            dto.setTotalStudents((int) totalRoster);
            dto.setPresentCount((int) present);
            dto.setLateCount((int) late);
            dto.setExcusedCount((int) excused);
            dto.setUnexcusedCount((int) unexcused);
            dto.setUnrecordedCount((int) Math.max(0, totalRoster - (present + late + excused + unexcused)));

            // Kiểm tra journal
            dto.setHasJournal(hasJournal(em, cs.getId()));

            results.add(dto);
        }
        return results;
    }

    public long countActiveStudentsInClass(EntityManager em, Long classId, LocalDate date) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM Enrollment e " +
                "WHERE e.eduClass.id = :classId " +
                "AND e.status IN ('ACTIVE', 'COMPLETED') " +
                "AND e.startDate <= :date " +
                "AND (e.endDate IS NULL OR e.endDate >= :date)",
                Long.class
        );
        query.setParameter("classId", classId);
        query.setParameter("date", date);
        return query.getSingleResult();
    }

    public long countAttendanceByStatus(EntityManager em, Long sessionId, String status) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(a) FROM Attendance a " +
                "WHERE a.session.id = :sessionId AND a.status = :status",
                Long.class
        );
        query.setParameter("sessionId", sessionId);
        query.setParameter("status", status);
        return query.getSingleResult();
    }

    public boolean hasJournal(EntityManager em, Long sessionId) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(j) FROM TeachingJournal j WHERE j.classSession.id = :sessionId",
                Long.class
        );
        query.setParameter("sessionId", sessionId);
        return query.getSingleResult() > 0;
    }

    public long countValidEnrollmentForStudent(EntityManager em, Long classId, Long studentId, LocalDate sessionDate) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM Enrollment e " +
                "WHERE e.eduClass.id = :classId " +
                "AND e.student.id = :studentId " +
                "AND e.startDate <= :sessionDate " +
                "AND (e.endDate IS NULL OR e.endDate >= :sessionDate)",
                Long.class
        );
        query.setParameter("classId", classId);
        query.setParameter("studentId", studentId);
        query.setParameter("sessionDate", sessionDate);
        return query.getSingleResult();
    }

    public List<AttendanceRosterItemDTO> findRosterForSession(EntityManager em, Long sessionId, Long classId, LocalDate sessionDate) {
        // 1. Lấy danh sách học viên có Enrollment hiệu lực vào ngày buổi học diễn ra
        TypedQuery<Student> query = em.createQuery(
                "SELECT DISTINCT e.student FROM Enrollment e " +
                "WHERE e.eduClass.id = :classId " +
                "AND e.startDate <= :sessionDate " +
                "AND (e.endDate IS NULL OR e.endDate >= :sessionDate) " +
                "ORDER BY e.student.fullName ASC",
                Student.class
        );
        query.setParameter("classId", classId);
        query.setParameter("sessionDate", sessionDate);

        TypedQuery<Attendance> attQuery = em.createQuery(
                "SELECT a FROM Attendance a " +
                "JOIN FETCH a.student s " +
                "WHERE a.session.id = :sessionId",
                Attendance.class
        );
        attQuery.setParameter("sessionId", sessionId);
        List<Attendance> attendances = attQuery.getResultList();

        java.util.Map<Long, Student> studentMap = new java.util.LinkedHashMap<>();
        for (Student s : query.getResultList()) {
            if (s != null && s.getId() != null) {
                studentMap.put(s.getId(), s);
            }
        }
        // B05: Đảm bảo học viên đã có bản ghi điểm danh trong quá khứ không bị mất khỏi danh sách
        for (Attendance a : attendances) {
            if (a.getStudent() != null && a.getStudent().getId() != null) {
                studentMap.putIfAbsent(a.getStudent().getId(), a.getStudent());
            }
        }
        List<Student> students = new ArrayList<>(studentMap.values());
        students.sort(Comparator.comparing(Student::getFullName, String.CASE_INSENSITIVE_ORDER));

        List<AttendanceRosterItemDTO> roster = new ArrayList<>();
        for (Student s : students) {
            Optional<Attendance> match = attendances.stream()
                    .filter(a -> a.getStudent().getId().equals(s.getId()))
                    .findFirst();

            String attStatus = match.map(Attendance::getStatus).orElse(null);
            String remarks = match.map(Attendance::getRemarks).orElse(null);

            roster.add(new AttendanceRosterItemDTO(
                    s.getId(),
                    s.getCode(),
                    s.getFullName(),
                    s.getPhone(),
                    attStatus,
                    remarks
            ));
        }
        return roster;
    }

    public Optional<Attendance> findAttendanceBySessionAndStudent(EntityManager em, Long sessionId, Long studentId) {
        try {
            TypedQuery<Attendance> query = em.createQuery(
                    "SELECT a FROM Attendance a " +
                    "WHERE a.session.id = :sessionId AND a.student.id = :studentId",
                    Attendance.class
            );
            query.setParameter("sessionId", sessionId);
            query.setParameter("studentId", studentId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<TeachingJournal> findJournalBySessionId(EntityManager em, Long sessionId) {
        try {
            TypedQuery<TeachingJournal> query = em.createQuery(
                    "SELECT j FROM TeachingJournal j " +
                    "WHERE j.classSession.id = :sessionId",
                    TeachingJournal.class
            );
            query.setParameter("sessionId", sessionId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public void saveAttendance(EntityManager em, Attendance attendance) {
        if (attendance.getId() == null) {
            em.persist(attendance);
        } else {
            em.merge(attendance);
        }
    }

    public void saveJournal(EntityManager em, TeachingJournal journal) {
        if (journal.getId() == null) {
            em.persist(journal);
        } else {
            em.merge(journal);
        }
    }
}
