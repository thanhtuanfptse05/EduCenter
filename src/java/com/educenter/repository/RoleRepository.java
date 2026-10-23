package com.educenter.repository;

import com.educenter.entity.Role;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

/**
 * JPA Repository for Role entities using JPQL queries.
 */
public class RoleRepository {

    public Optional<Role> findByCode(EntityManager em, String code) {
        if (code == null || code.trim().isEmpty()) {
            return Optional.empty();
        }
        try {
            TypedQuery<Role> query = em.createQuery(
                    "SELECT r FROM Role r WHERE UPPER(r.code) = UPPER(:code)", Role.class);
            query.setParameter("code", code.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Role> findById(EntityManager em, Integer id) {
        if (id == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(em.find(Role.class, id));
    }

    public List<Role> findAll(EntityManager em) {
        TypedQuery<Role> query = em.createQuery(
                "SELECT r FROM Role r ORDER BY r.id ASC", Role.class);
        return query.getResultList();
    }

    public void lockAdminRole(EntityManager em) {
        Role admin = findByCode(em, "ADMIN").orElseThrow(() -> new IllegalStateException("ADMIN role is missing"));
        em.lock(admin, jakarta.persistence.LockModeType.PESSIMISTIC_WRITE);
    }
}
