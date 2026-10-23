package com.educenter.repository;

import com.educenter.dto.ClassFilterDTO;
import com.educenter.entity.EduClass;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class EduClassRepository {

    public Optional<EduClass> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        try {
            TypedQuery<EduClass> query = em.createQuery(
                "SELECT c FROM EduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject s " +
                "JOIN FETCH c.teacher t " +
                "JOIN FETCH t.user u " +
                "LEFT JOIN FETCH c.room r " +
                "WHERE c.id = :id", EduClass.class);
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<EduClass> findByCode(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) return Optional.empty();
        try {
            TypedQuery<EduClass> query = em.createQuery(
                "SELECT c FROM EduClass c WHERE LOWER(c.code) = LOWER(:code)", EduClass.class);
            query.setParameter("code", code.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<EduClass> findClasses(EntityManager em, ClassFilterDTO filter) {
        StringBuilder jpql = new StringBuilder(
            "SELECT c FROM EduClass c " +
            "JOIN FETCH c.course cr " +
            "JOIN FETCH c.teacher t " +
            "JOIN FETCH t.user u " +
            "LEFT JOIN FETCH c.room r " +
            "WHERE 1=1 ");
        
        appendFilterConditions(jpql, filter);
        jpql.append(" ORDER BY c.id DESC");

        TypedQuery<EduClass> query = em.createQuery(jpql.toString(), EduClass.class);
        setFilterParameters(query, filter);

        int offset = (filter.getPage() - 1) * filter.getPageSize();
        query.setFirstResult(Math.max(0, offset));
        query.setMaxResults(filter.getPageSize());

        return query.getResultList();
    }

    public long countClasses(EntityManager em, ClassFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(c) FROM EduClass c WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setFilterParameters(query, filter);

        return query.getSingleResult();
    }

    public long countByStatus(EntityManager em, String status) {
        if (status == null || status.trim().isEmpty() || "ALL".equalsIgnoreCase(status)) {
            return countTotal(em);
        }
        return em.createQuery(
            "SELECT COUNT(c) FROM EduClass c WHERE c.status = :status", Long.class)
            .setParameter("status", status.toUpperCase())
            .getSingleResult();
    }

    public long countTotal(EntityManager em) {
        return em.createQuery("SELECT COUNT(c) FROM EduClass c", Long.class).getSingleResult();
    }

    public long countEnrolledStudents(EntityManager em, Long classId) {
        if (classId == null) return 0L;
        try {
            // Đếm học viên có enrollment ACTIVE trong lớp này
            return em.createQuery(
                "SELECT COUNT(e) FROM Enrollment e WHERE e.eduClass.id = :classId AND e.status = 'ACTIVE'", Long.class)
                .setParameter("classId", classId)
                .getSingleResult();
        } catch (Exception e) {
            // Trường hợp entity Enrollment chưa được tạo trong JPA, fallback native query an toàn
            try {
                Object res = em.createNativeQuery(
                    "SELECT COUNT(*) FROM dbo.Enrollments WHERE class_id = ? AND status = 'ACTIVE'")
                    .setParameter(1, classId)
                    .getSingleResult();
                if (res instanceof Number) {
                    return ((Number) res).longValue();
                }
            } catch (Exception ignored) {}
            return 0L;
        }
    }

    public void save(EntityManager em, EduClass eduClass) {
        em.persist(eduClass);
    }

    public EduClass update(EntityManager em, EduClass eduClass) {
        return em.merge(eduClass);
    }

    private void appendFilterConditions(StringBuilder jpql, ClassFilterDTO filter) {
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            jpql.append(" AND (LOWER(c.code) LIKE :keyword OR LOWER(c.name) LIKE :keyword) ");
        }
        if (filter.getCourseId() != null && filter.getCourseId() > 0) {
            jpql.append(" AND c.course.id = :courseId ");
        }
        if (filter.getStatus() != null && !filter.getStatus().trim().isEmpty() && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            jpql.append(" AND c.status = :status ");
        }
    }

    private void setFilterParameters(TypedQuery<?> query, ClassFilterDTO filter) {
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            query.setParameter("keyword", "%" + filter.getKeyword().trim().toLowerCase() + "%");
        }
        if (filter.getCourseId() != null && filter.getCourseId() > 0) {
            query.setParameter("courseId", filter.getCourseId());
        }
        if (filter.getStatus() != null && !filter.getStatus().trim().isEmpty() && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            query.setParameter("status", filter.getStatus().trim().toUpperCase());
        }
    }
}
