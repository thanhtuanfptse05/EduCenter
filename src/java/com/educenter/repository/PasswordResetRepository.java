package com.educenter.repository;

import com.educenter.entity.PasswordResetToken;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * JPA Repository for PasswordResetToken entity (FR-004).
 */
public class PasswordResetRepository {

    public void save(EntityManager em, PasswordResetToken token) {
        em.persist(token);
    }

    public Optional<PasswordResetToken> findByTokenHash(EntityManager em, String tokenHash) {
        if (tokenHash == null || tokenHash.trim().isEmpty()) {
            return Optional.empty();
        }
        try {
            TypedQuery<PasswordResetToken> query = em.createQuery(
                    "SELECT t FROM PasswordResetToken t JOIN FETCH t.user u JOIN FETCH u.roles " +
                    "WHERE t.tokenHash = :tokenHash",
                    PasswordResetToken.class
            );
            query.setParameter("tokenHash", tokenHash.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public void invalidatePriorTokens(EntityManager em, Long userId) {
        if (userId == null) {
            return;
        }
        em.createQuery(
                "UPDATE PasswordResetToken t SET t.consumedAt = :now " +
                "WHERE t.user.id = :userId AND t.consumedAt IS NULL"
        )
        .setParameter("now", LocalDateTime.now())
        .setParameter("userId", userId)
        .executeUpdate();
    }

    public Optional<PasswordResetToken> findByTokenHashForUpdate(EntityManager em, String hash) {
        Optional<PasswordResetToken> token = findByTokenHash(em, hash);
        token.ifPresent(value -> { em.lock(value, jakarta.persistence.LockModeType.PESSIMISTIC_WRITE); em.refresh(value); });
        return token;
    }
}
