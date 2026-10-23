package com.educenter.repository;

import com.educenter.entity.ClassSession;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class ClassSessionRepository {

    private static final List<String> ACTIVE_STATUSES = Arrays.asList("SCHEDULED", "IN_PROGRESS", "COMPLETED");

    public Optional<ClassSession> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        try {
            TypedQuery<ClassSession> query = em.createQuery(
                "SELECT s FROM ClassSession s " +
                "JOIN FETCH s.eduClass c " +
                "JOIN FETCH s.room r " +
                "JOIN FETCH s.teacher t " +
                "JOIN FETCH t.user u " +
                "WHERE s.id = :id", ClassSession.class);
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<ClassSession> findByClassId(EntityManager em, Long classId) {
        if (classId == null) return List.of();
        TypedQuery<ClassSession> query = em.createQuery(
            "SELECT s FROM ClassSession s " +
            "JOIN FETCH s.room r " +
            "JOIN FETCH s.teacher t " +
            "JOIN FETCH t.user u " +
            "WHERE s.eduClass.id = :classId " +
            "ORDER BY s.sessionDate ASC, s.startAt ASC", ClassSession.class);
        query.setParameter("classId", classId);
        return query.getResultList();
    }

    /**
     * BR05: Kiểm tra giáo viên có bị trùng lịch trong ngày sessionDate không.
     * Giao nhau khi: s.startAt < endAt AND s.endAt > startAt
     */
    public List<ClassSession> checkTeacherConflict(EntityManager em, Long teacherId, LocalDate sessionDate, 
                                                   LocalTime startAt, LocalTime endAt, Long excludeSessionId) {
        StringBuilder jpql = new StringBuilder(
            "SELECT s FROM ClassSession s " +
            "JOIN FETCH s.eduClass c " +
            "WHERE s.teacher.id = :teacherId " +
            "AND s.sessionDate = :sessionDate " +
            "AND s.status IN :statuses " +
            "AND s.startAt < :endAt " +
            "AND s.endAt > :startAt ");
        
        if (excludeSessionId != null && excludeSessionId > 0) {
            jpql.append("AND s.id != :excludeSessionId ");
        }

        TypedQuery<ClassSession> query = em.createQuery(jpql.toString(), ClassSession.class);
        query.setParameter("teacherId", teacherId);
        query.setParameter("sessionDate", sessionDate);
        query.setParameter("statuses", ACTIVE_STATUSES);
        query.setParameter("startAt", startAt);
        query.setParameter("endAt", endAt);
        if (excludeSessionId != null && excludeSessionId > 0) {
            query.setParameter("excludeSessionId", excludeSessionId);
        }

        return query.getResultList();
    }

    /**
     * BR06: Kiểm tra phòng học có bị trùng lịch trong ngày sessionDate không.
     * Giao nhau khi: s.startAt < endAt AND s.endAt > startAt
     */
    public List<ClassSession> checkRoomConflict(EntityManager em, Long roomId, LocalDate sessionDate, 
                                                LocalTime startAt, LocalTime endAt, Long excludeSessionId) {
        StringBuilder jpql = new StringBuilder(
            "SELECT s FROM ClassSession s " +
            "JOIN FETCH s.eduClass c " +
            "WHERE s.room.id = :roomId " +
            "AND s.sessionDate = :sessionDate " +
            "AND s.status IN :statuses " +
            "AND s.startAt < :endAt " +
            "AND s.endAt > :startAt ");
        
        if (excludeSessionId != null && excludeSessionId > 0) {
            jpql.append("AND s.id != :excludeSessionId ");
        }

        TypedQuery<ClassSession> query = em.createQuery(jpql.toString(), ClassSession.class);
        query.setParameter("roomId", roomId);
        query.setParameter("sessionDate", sessionDate);
        query.setParameter("statuses", ACTIVE_STATUSES);
        query.setParameter("startAt", startAt);
        query.setParameter("endAt", endAt);
        if (excludeSessionId != null && excludeSessionId > 0) {
            query.setParameter("excludeSessionId", excludeSessionId);
        }

        return query.getResultList();
    }

    /**
     * Tra cứu các buổi học trong khoảng ngày (cho thời khóa biểu tuần)
     */
    public List<ClassSession> findSessionsBetween(EntityManager em, LocalDate fromDate, LocalDate toDate) {
        TypedQuery<ClassSession> query = em.createQuery(
            "SELECT s FROM ClassSession s " +
            "JOIN FETCH s.eduClass c " +
            "JOIN FETCH s.room r " +
            "JOIN FETCH s.teacher t " +
            "JOIN FETCH t.user u " +
            "WHERE s.sessionDate >= :fromDate AND s.sessionDate <= :toDate " +
            "ORDER BY s.sessionDate ASC, s.startAt ASC", ClassSession.class);
        query.setParameter("fromDate", fromDate);
        query.setParameter("toDate", toDate);
        return query.getResultList();
    }

    public void save(EntityManager em, ClassSession session) {
        em.persist(session);
    }

    public ClassSession update(EntityManager em, ClassSession session) {
        return em.merge(session);
    }
}
