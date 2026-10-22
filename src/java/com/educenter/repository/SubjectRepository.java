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
                    "SELECT s FROM Subject s WHERE UPPER(s.code) = UPPER(:code)",
                    Subject.class
            );
            query.setParameter("code", code.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }
}
