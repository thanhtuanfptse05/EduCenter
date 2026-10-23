package com.educenter.repository;

import com.educenter.dto.AvailableTeacherUserDTO;
import com.educenter.dto.TeacherAdminStatsDTO;
import com.educenter.dto.TeacherFilterDTO;
import com.educenter.entity.Teacher;
import com.educenter.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class TeacherRepository {

    public List<Teacher> findAdminTeachers(EntityManager em, TeacherFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT t FROM Teacher t JOIN FETCH t.user u WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        if ("name_asc".equalsIgnoreCase(filter.getSort())) {
            jpql.append(" ORDER BY t.fullName ASC, t.id DESC");
        } else {
            jpql.append(" ORDER BY t.id DESC");
        }

        TypedQuery<Teacher> query = em.createQuery(jpql.toString(), Teacher.class);
        setFilterParameters(query, filter);

        query.setFirstResult(filter.getOffset());
        query.setMaxResults(filter.getPageSize());

        return query.getResultList();
    }

    public long countAdminTeachers(EntityManager em, TeacherFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(t) FROM Teacher t JOIN t.user u WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setFilterParameters(query, filter);

        return query.getSingleResult();
    }

    public TeacherAdminStatsDTO getAdminStats(EntityManager em) {
        long total = em.createQuery("SELECT COUNT(t) FROM Teacher t", Long.class).getSingleResult();
        long active = em.createQuery("SELECT COUNT(t) FROM Teacher t WHERE t.status = 'ACTIVE'", Long.class).getSingleResult();
        long onLeave = em.createQuery("SELECT COUNT(t) FROM Teacher t WHERE t.status = 'ON_LEAVE'", Long.class).getSingleResult();
        long inactive = em.createQuery("SELECT COUNT(t) FROM Teacher t WHERE t.status = 'INACTIVE'", Long.class).getSingleResult();
        long activeClasses = em.createQuery("SELECT COUNT(cl) FROM EduClass cl WHERE cl.status = 'OPEN' AND cl.teacher IS NOT NULL", Long.class).getSingleResult();

        return new TeacherAdminStatsDTO(total, active, onLeave, inactive, activeClasses);
    }

    public Optional<Teacher> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        try {
            TypedQuery<Teacher> query = em.createQuery(
                    "SELECT t FROM Teacher t JOIN FETCH t.user u WHERE t.id = :id", Teacher.class);
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Teacher> findByUserId(EntityManager em, Long userId) {
        if (userId == null) return Optional.empty();
        try {
            TypedQuery<Teacher> query = em.createQuery(
                    "SELECT t FROM Teacher t JOIN FETCH t.user u WHERE u.id = :userId", Teacher.class);
            query.setParameter("userId", userId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public boolean existsByUserId(EntityManager em, Long userId, Long excludeId) {
        if (userId == null) return false;
        StringBuilder jpql = new StringBuilder("SELECT COUNT(t) FROM Teacher t WHERE t.user.id = :userId");
        if (excludeId != null) {
            jpql.append(" AND t.id <> :excludeId");
        }
        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        query.setParameter("userId", userId);
        if (excludeId != null) {
            query.setParameter("excludeId", excludeId);
        }
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    public List<AvailableTeacherUserDTO> findAvailableTeacherUsers(EntityManager em) {
        TypedQuery<User> query = em.createQuery(
                "SELECT DISTINCT u FROM User u JOIN u.roles r " +
                "WHERE r.code = 'TEACHER' AND u.status = 'ACTIVE' " +
                "AND u.id NOT IN (SELECT t.user.id FROM Teacher t) " +
                "ORDER BY u.fullName ASC", User.class);
        List<User> users = query.getResultList();
        List<AvailableTeacherUserDTO> result = new ArrayList<>();
        for (User u : users) {
            result.add(new AvailableTeacherUserDTO(u.getId(), u.getEmail(), u.getFullName(), u.getPhone()));
        }
        return result;
    }

    public long countActiveClassesByTeacher(EntityManager em, Long teacherId) {
        if (teacherId == null) return 0L;
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(cl) FROM EduClass cl WHERE cl.teacher.id = :tid AND cl.status = 'OPEN'", Long.class);
        query.setParameter("tid", teacherId);
        Long res = query.getSingleResult();
        return res != null ? res : 0L;
    }

    public long countTotalClassesByTeacher(EntityManager em, Long teacherId) {
        if (teacherId == null) return 0L;
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(cl) FROM EduClass cl WHERE cl.teacher.id = :tid", Long.class);
        query.setParameter("tid", teacherId);
        Long res = query.getSingleResult();
        return res != null ? res : 0L;
    }

    public long countFutureScheduledSessions(EntityManager em, Long teacherId) {
        if (teacherId == null) return 0L;
        jakarta.persistence.Query query = em.createNativeQuery(
                "SELECT COUNT(1) FROM dbo.ClassSessions " +
                "WHERE teacher_id = :tid AND status = 'SCHEDULED' AND session_date >= CAST(GETDATE() AS DATE)");
        query.setParameter("tid", teacherId);
        Object res = query.getSingleResult();
        return res != null ? ((Number) res).longValue() : 0L;
    }

    public Teacher save(EntityManager em, Teacher teacher) {
        if (teacher.getId() == null) {
            em.persist(teacher);
            return teacher;
        } else {
            return em.merge(teacher);
        }
    }

    public Teacher update(EntityManager em, Teacher teacher) {
        return em.merge(teacher);
    }

    private void appendFilterConditions(StringBuilder jpql, TeacherFilterDTO filter) {
        if (filter.getStatus() != null && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            jpql.append("AND UPPER(t.status) = :status ");
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            jpql.append("AND (LOWER(t.fullName) LIKE :kw OR LOWER(t.email) LIKE :kw OR LOWER(t.phone) LIKE :kw OR LOWER(t.specialization) LIKE :kw OR LOWER(u.email) LIKE :kw) ");
        }
    }

    private void setFilterParameters(TypedQuery<?> query, TeacherFilterDTO filter) {
        if (filter.getStatus() != null && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            query.setParameter("status", filter.getStatus().toUpperCase());
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            query.setParameter("kw", "%" + filter.getKeyword().trim().toLowerCase() + "%");
        }
    }
}
