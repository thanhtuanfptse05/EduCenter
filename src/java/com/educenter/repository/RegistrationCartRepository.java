package com.educenter.repository;

import com.educenter.entity.RegistrationCartItem;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class RegistrationCartRepository {

    public List<RegistrationCartItem> findByUserId(EntityManager em, Long userId) {
        if (userId == null) {
            return List.of();
        }
        TypedQuery<RegistrationCartItem> query = em.createQuery(
                "SELECT i FROM RegistrationCartItem i " +
                "JOIN FETCH i.course c " +
                "JOIN FETCH c.subject s " +
                "WHERE i.user.id = :userId " +
                "ORDER BY i.id ASC",
                RegistrationCartItem.class
        );
        query.setParameter("userId", userId);
        return query.getResultList();
    }

    public Optional<RegistrationCartItem> findByUserAndCourse(EntityManager em, Long userId, Long courseId) {
        if (userId == null || courseId == null) {
            return Optional.empty();
        }
        try {
            TypedQuery<RegistrationCartItem> query = em.createQuery(
                    "SELECT i FROM RegistrationCartItem i " +
                    "WHERE i.user.id = :userId AND i.course.id = :courseId",
                    RegistrationCartItem.class
            );
            query.setParameter("userId", userId);
            query.setParameter("courseId", courseId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public RegistrationCartItem save(EntityManager em, RegistrationCartItem item) {
        if (item.getId() == null) {
            em.persist(item);
            return item;
        } else {
            return em.merge(item);
        }
    }

    public void delete(EntityManager em, Long id) {
        if (id != null) {
            RegistrationCartItem item = em.find(RegistrationCartItem.class, id);
            if (item != null) {
                em.remove(item);
            }
        }
    }

    public void deleteByUserAndCourse(EntityManager em, Long userId, Long courseId) {
        if (userId == null || courseId == null) {
            return;
        }
        em.createQuery("DELETE FROM RegistrationCartItem i WHERE i.user.id = :userId AND i.course.id = :courseId")
                .setParameter("userId", userId)
                .setParameter("courseId", courseId)
                .executeUpdate();
    }

    public void clearByUserId(EntityManager em, Long userId) {
        if (userId == null) {
            return;
        }
        em.createQuery("DELETE FROM RegistrationCartItem i WHERE i.user.id = :userId")
                .setParameter("userId", userId)
                .executeUpdate();
    }
}
