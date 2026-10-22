package com.educenter.repository;

import com.educenter.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

/**
 * JPA Repository for User entity using pure JPA EntityManager and JPQL.
 * Strictly adheres to assignment requirements (No raw JDBC).
 */
public class UserRepository {

    public Optional<User> findByEmail(EntityManager em, String email) {
        if (email == null || email.trim().isEmpty()) {
            return Optional.empty();
        }
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.roles WHERE LOWER(u.email) = LOWER(:email)",
                    User.class
            );
            query.setParameter("email", email.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<User> findById(EntityManager em, Long id) {
        if (id == null) {
            return Optional.empty();
        }
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.roles WHERE u.id = :id",
                    User.class
            );
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<User> findByIdWithLock(EntityManager em, Long id) {
        if (id == null) {
            return Optional.empty();
        }
        try {
            TypedQuery<User> query = em.createQuery(
                    "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.roles WHERE u.id = :id",
                    User.class
            );
            query.setParameter("id", id);
            query.setLockMode(LockModeType.PESSIMISTIC_WRITE);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public boolean existsByEmail(EntityManager em, String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE LOWER(u.email) = LOWER(:email)",
                Long.class
        );
        query.setParameter("email", email.trim());
        return query.getSingleResult() > 0;
    }

    public List<User> searchUsers(EntityManager em, String keyword, String roleCode, String status, int offset, int limit) {
        StringBuilder jpql = new StringBuilder("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.roles r WHERE 1=1 ");
        appendFilterConditions(jpql, keyword, roleCode, status);
        jpql.append(" ORDER BY u.id DESC");

        TypedQuery<User> query = em.createQuery(jpql.toString(), User.class);
        setFilterParameters(query, keyword, roleCode, status);
        query.setFirstResult(Math.max(0, offset));
        query.setMaxResults(Math.max(1, limit));
        return query.getResultList();
    }

    public long countUsers(EntityManager em, String keyword, String roleCode, String status) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(DISTINCT u) FROM User u LEFT JOIN u.roles r WHERE 1=1 ");
        appendFilterConditions(jpql, keyword, roleCode, status);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setFilterParameters(query, keyword, roleCode, status);
        return query.getSingleResult();
    }

    public long countActiveAdmins(EntityManager em) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(DISTINCT u) FROM User u JOIN u.roles r " +
                "WHERE u.status = 'ACTIVE' AND UPPER(r.code) = 'ADMIN'",
                Long.class
        );
        return query.getSingleResult();
    }

    public long countByStatus(EntityManager em, String status) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(u) FROM User u WHERE u.status = :status",
                Long.class
        );
        query.setParameter("status", status);
        return query.getSingleResult();
    }

    public void save(EntityManager em, User user) {
        em.persist(user);
    }

    public User update(EntityManager em, User user) {
        return em.merge(user);
    }

    private void appendFilterConditions(StringBuilder jpql, String keyword, String roleCode, String status) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            jpql.append(" AND (LOWER(u.email) LIKE LOWER(:keyword) OR LOWER(u.fullName) LIKE LOWER(:keyword) OR u.phone LIKE :keyword) ");
        }
        if (roleCode != null && !roleCode.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleCode)) {
            jpql.append(" AND UPPER(r.code) = UPPER(:roleCode) ");
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            jpql.append(" AND u.status = :status ");
        }
    }

    private void setFilterParameters(TypedQuery<?> query, String keyword, String roleCode, String status) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim() + "%");
        }
        if (roleCode != null && !roleCode.trim().isEmpty() && !"ALL".equalsIgnoreCase(roleCode)) {
            query.setParameter("roleCode", roleCode.trim());
        }
        if (status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            query.setParameter("status", status.trim());
        }
    }
}
