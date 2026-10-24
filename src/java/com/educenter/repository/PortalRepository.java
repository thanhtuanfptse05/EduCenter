package com.educenter.repository;

import com.educenter.dto.*;
import com.educenter.entity.*;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Repository handling secure data aggregation for Student and Parent Portals.
 */
public class PortalRepository {

    public Optional<Student> findStudentByUserId(EntityManager em, Long userId) {
        if (userId == null) return Optional.empty();
        try {
            TypedQuery<Student> query = em.createQuery(
                    "SELECT s FROM Student s LEFT JOIN FETCH s.user u WHERE s.user.id = :userId",
                    Student.class
            );
            query.setParameter("userId", userId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Guardian> findGuardianByUserId(EntityManager em, Long userId) {
        if (userId == null) return Optional.empty();
        try {
            TypedQuery<Guardian> query = em.createQuery(
                    "SELECT g FROM Guardian g LEFT JOIN FETCH g.user u WHERE g.user.id = :userId",
                    Guardian.class
            );
            query.setParameter("userId", userId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<ChildGuardianViewDTO> findVerifiedChildrenByGuardianUserId(EntityManager em, Long guardianUserId) {
        if (guardianUserId == null) return List.of();
        TypedQuery<StudentGuardian> query = em.createQuery(
                "SELECT sg FROM StudentGuardian sg " +
                "JOIN FETCH sg.student s " +
                "WHERE sg.guardian.user.id = :guardianUserId AND sg.verifiedAt IS NOT NULL " +
                "ORDER BY sg.isPrimary DESC, s.fullName ASC",
                StudentGuardian.class
        );
        query.setParameter("guardianUserId", guardianUserId);
        List<StudentGuardian> links = query.getResultList();

        List<ChildGuardianViewDTO> results = new ArrayList<>();
        for (StudentGuardian link : links) {
            Student s = link.getStudent();
            results.add(new ChildGuardianViewDTO(
                    s.getId(),
                    s.getFullName(),
                    s.getCode(),
                    s.getGradeLevel(),
                    s.getSchool(),
                    link.getRelationship(),
                    link.getIsPrimary(),
                    link.isVerified()
            ));
        }
        return results;
    }

    public boolean isGuardianOfStudent(EntityManager em, Long guardianUserId, Long studentId) {
        if (guardianUserId == null || studentId == null) return false;
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(sg) FROM StudentGuardian sg " +
                "WHERE sg.guardian.user.id = :guardianUserId AND sg.student.id = :studentId AND sg.verifiedAt IS NOT NULL",
                Long.class
        );
        query.setParameter("guardianUserId", guardianUserId);
        query.setParameter("studentId", studentId);
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    public List<PortalScheduleItemDTO> findUpcomingSessionsByStudentId(EntityManager em, Long studentId, int limit) {
        if (studentId == null) return List.of();
        LocalDate today = LocalDate.now();
        TypedQuery<ClassSession> query = em.createQuery(
                "SELECT cs FROM ClassSession cs " +
                "JOIN FETCH cs.eduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "JOIN FETCH cs.teacher t " +
                "JOIN FETCH cs.room r " +
                "WHERE cs.sessionDate >= :today AND cs.status <> 'CANCELLED' " +
                "AND EXISTS (SELECT 1 FROM Enrollment e WHERE e.eduClass = c AND e.student.id = :studentId AND e.status = 'ACTIVE') " +
                "ORDER BY cs.sessionDate ASC, cs.startAt ASC",
                ClassSession.class
        );
        query.setParameter("today", today);
        query.setParameter("studentId", studentId);
        query.setMaxResults(Math.max(1, limit));

        List<ClassSession> sessions = query.getResultList();
        List<PortalScheduleItemDTO> items = new ArrayList<>();
        for (ClassSession cs : sessions) {
            PortalScheduleItemDTO dto = new PortalScheduleItemDTO();
            dto.setSessionId(cs.getId());
            dto.setClassId(cs.getEduClass().getId());
            dto.setClassCode(cs.getEduClass().getCode());
            dto.setClassName(cs.getEduClass().getName());
            dto.setSubjectName(cs.getEduClass().getCourse().getSubject().getName());
            dto.setTeacherName(cs.getTeacher().getFullName());
            dto.setRoomName(cs.getRoom() != null ? cs.getRoom().getName() : "Chưa xếp phòng");
            dto.setSessionDate(cs.getSessionDate());
            dto.setStartTime(cs.getStartAt());
            dto.setEndTime(cs.getEndAt());
            dto.setStatus(cs.getStatus());
            dto.setNotes(cs.getTitle());
            items.add(dto);
        }
        return items;
    }

    public List<PortalScheduleItemDTO> findScheduleByStudentId(EntityManager em, Long studentId, LocalDate fromDate, LocalDate toDate) {
        if (studentId == null) return List.of();
        StringBuilder jpql = new StringBuilder(
                "SELECT cs FROM ClassSession cs " +
                "JOIN FETCH cs.eduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "JOIN FETCH cs.teacher t " +
                "JOIN FETCH cs.room r " +
                "WHERE EXISTS (SELECT 1 FROM Enrollment e WHERE e.eduClass = c AND e.student.id = :studentId AND e.status = 'ACTIVE') "
        );
        if (fromDate != null) jpql.append("AND cs.sessionDate >= :fromDate ");
        if (toDate != null) jpql.append("AND cs.sessionDate <= :toDate ");
        jpql.append("ORDER BY cs.sessionDate ASC, cs.startAt ASC");

        TypedQuery<ClassSession> query = em.createQuery(jpql.toString(), ClassSession.class);
        query.setParameter("studentId", studentId);
        if (fromDate != null) query.setParameter("fromDate", fromDate);
        if (toDate != null) query.setParameter("toDate", toDate);

        List<ClassSession> sessions = query.getResultList();
        List<PortalScheduleItemDTO> items = new ArrayList<>();
        for (ClassSession cs : sessions) {
            PortalScheduleItemDTO dto = new PortalScheduleItemDTO();
            dto.setSessionId(cs.getId());
            dto.setClassId(cs.getEduClass().getId());
            dto.setClassCode(cs.getEduClass().getCode());
            dto.setClassName(cs.getEduClass().getName());
            dto.setSubjectName(cs.getEduClass().getCourse().getSubject().getName());
            dto.setTeacherName(cs.getTeacher().getFullName());
            dto.setRoomName(cs.getRoom() != null ? cs.getRoom().getName() : "Chưa xếp phòng");
            dto.setSessionDate(cs.getSessionDate());
            dto.setStartTime(cs.getStartAt());
            dto.setEndTime(cs.getEndAt());
            dto.setStatus(cs.getStatus());
            dto.setNotes(cs.getTitle());
            items.add(dto);
        }
        return items;
    }

    public List<PortalScoreItemDTO> findPublishedScoresByStudentId(EntityManager em, Long studentId) {
        if (studentId == null) return List.of();
        TypedQuery<AssessmentScore> query = em.createQuery(
                "SELECT sc FROM AssessmentScore sc " +
                "JOIN FETCH sc.assessment a " +
                "JOIN FETCH a.eduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "WHERE sc.student.id = :studentId AND a.status = 'PUBLISHED' " +
                "ORDER BY a.testDate DESC",
                AssessmentScore.class
        );
        query.setParameter("studentId", studentId);

        List<AssessmentScore> scores = query.getResultList();
        List<PortalScoreItemDTO> items = new ArrayList<>();
        for (AssessmentScore sc : scores) {
            PortalScoreItemDTO dto = new PortalScoreItemDTO();
            dto.setAssessmentId(sc.getAssessment().getId());
            dto.setAssessmentTitle(sc.getAssessment().getTitle());
            dto.setAssessmentType(sc.getAssessment().getAssessmentType());
            dto.setSubjectName(sc.getAssessment().getEduClass().getCourse().getSubject().getName());
            dto.setClassCode(sc.getAssessment().getEduClass().getCode());
            dto.setAssessmentDate(sc.getAssessment().getTestDate());
            dto.setScore(sc.getScore());
            dto.setMaxScore(sc.getAssessment().getMaxScore());
            dto.setWeight(sc.getAssessment().getWeight());
            dto.setRemark(sc.getRemarks());
            items.add(dto);
        }
        return items;
    }

    public PortalAttendanceSummaryDTO getAttendanceStatsByStudentId(EntityManager em, Long studentId) {
        if (studentId == null) return new PortalAttendanceSummaryDTO(0, 0, 0, 0, 0);

        TypedQuery<Object[]> query = em.createQuery(
                "SELECT att.status, COUNT(att) FROM Attendance att " +
                "WHERE att.student.id = :studentId " +
                "GROUP BY att.status",
                Object[].class
        );
        query.setParameter("studentId", studentId);
        List<Object[]> rows = query.getResultList();

        int present = 0;
        int late = 0;
        int excused = 0;
        int unexcused = 0;

        for (Object[] row : rows) {
            String status = (String) row[0];
            long count = ((Number) row[1]).longValue();
            if ("PRESENT".equalsIgnoreCase(status)) {
                present += (int) count;
            } else if ("LATE".equalsIgnoreCase(status)) {
                late += (int) count;
            } else if ("ABSENT_EXCUSED".equalsIgnoreCase(status)) {
                excused += (int) count;
            } else if ("ABSENT_UNEXCUSED".equalsIgnoreCase(status)) {
                unexcused += (int) count;
            }
        }

        int total = present + late + excused + unexcused;
        return new PortalAttendanceSummaryDTO(total, present, late, excused, unexcused);
    }

    public List<ClassItemDTO> findEnrolledClassesByStudentId(EntityManager em, Long studentId) {
        if (studentId == null) return List.of();
        TypedQuery<EduClass> query = em.createQuery(
                "SELECT c FROM EduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "JOIN FETCH c.teacher t " +
                "LEFT JOIN FETCH c.room r " +
                "WHERE EXISTS (SELECT 1 FROM Enrollment e WHERE e.eduClass = c AND e.student.id = :studentId AND e.status = 'ACTIVE') " +
                "ORDER BY c.startDate DESC",
                EduClass.class
        );
        query.setParameter("studentId", studentId);
        List<EduClass> classes = query.getResultList();

        List<ClassItemDTO> results = new ArrayList<>();
        for (EduClass c : classes) {
            ClassItemDTO dto = new ClassItemDTO();
            dto.setId(c.getId());
            dto.setCode(c.getCode());
            dto.setName(c.getName());
            if (c.getCourse() != null && c.getCourse().getSubject() != null) {
                dto.setSubjectName(c.getCourse().getSubject().getName());
            }
            dto.setRoomName(c.getRoom() != null ? c.getRoom().getName() : "Chưa xếp phòng");
            dto.setTeacherName(c.getTeacher().getFullName());
            dto.setCapacity(c.getCapacity());
            dto.setStartDate(c.getStartDate());
            dto.setStatus(c.getStatus());
            results.add(dto);
        }
        return results;
    }

    public int countEnrolledClasses(EntityManager em, Long studentId) {
        if (studentId == null) return 0;
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM Enrollment e WHERE e.student.id = :studentId AND e.status = 'ACTIVE'",
                Long.class
        );
        query.setParameter("studentId", studentId);
        Long count = query.getSingleResult();
        return count != null ? count.intValue() : 0;
    }
}
