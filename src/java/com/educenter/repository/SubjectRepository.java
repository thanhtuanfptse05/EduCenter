package com.educenter.repository;

import com.educenter.entity.Subject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class SubjectRepository {

    public List<Subject> findAllActive(EntityManager em) {
        TypedQuery<Subject> query = em.createQuery(
                "SELECT s FROM Subject s WHERE s.status = 'ACTIVE' ORDER BY s.id ASC",
                Subject.class
        );
        return query.getResultList();
    }

    public List<Subject> findAllAdmin(EntityManager em) {
        TypedQuery<Subject> query = em.createQuery(
                "SELECT s FROM Subject s ORDER BY s.status ASC, s.name ASC",
                Subject.class
        );
        return query.getResultList();
    }

    public Optional<Subject> findById(EntityManager em, Long id) {
        if (id == null) {
            return Optional.empty();
        }
        try {
            Subject s = em.find(Subject.class, id);
            return Optional.ofNullable(s);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Subject> findByCode(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) {
            return Optional.empty();
        }
        try {
            TypedQuery<Subject> query = em.createQuery(
                    "SELECT s FROM Subject s WHERE UPPER(TRIM(s.code)) = UPPER(TRIM(:code))",
                    Subject.class
            );
            query.setParameter("code", code.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public boolean existsByCode(EntityManager em, String code, Long excludeId) {
        if (code == null || code.trim().isEmpty()) {
            return false;
        }
        StringBuilder jpql = new StringBuilder(
                "SELECT COUNT(s) FROM Subject s WHERE UPPER(TRIM(s.code)) = UPPER(TRIM(:code))"
        );
        if (excludeId != null) {
            jpql.append(" AND s.id <> :excludeId");
        }
        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        query.setParameter("code", code.trim());
        if (excludeId != null) {
            query.setParameter("excludeId", excludeId);
        }
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    public Subject save(EntityManager em, Subject subject) {
        if (subject.getId() == null) {
            em.persist(subject);
            return subject;
        } else {
            return em.merge(subject);
        }
    }

    public Subject update(EntityManager em, Subject subject) {
        return em.merge(subject);
    }

    public long countCoursesBySubject(EntityManager em, Long subjectId) {
        if (subjectId == null) return 0L;
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Course c WHERE c.subject.id = :subjectId",
                Long.class
        );
        query.setParameter("subjectId", subjectId);
        Long res = query.getSingleResult();
        return res != null ? res : 0L;
    }

    public long countOpenCoursesBySubject(EntityManager em, Long subjectId) {
        if (subjectId == null) return 0L;
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Course c WHERE c.subject.id = :subjectId AND c.status = 'OPEN'",
                Long.class
        );
        query.setParameter("subjectId", subjectId);
        Long res = query.getSingleResult();
        return res != null ? res : 0L;
    }

    public long countActiveSubjects(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(s) FROM Subject s WHERE s.status = 'ACTIVE'",
                Long.class
        );
        Long res = query.getSingleResult();
        return res != null ? res : 0L;
    }

    public long countTotalSubjects(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(s) FROM Subject s",
                Long.class
        );
        Long res = query.getSingleResult();
        return res != null ? res : 0L;
    }
}
