package com.educenter.repository;

import com.educenter.entity.AuditLog;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * JPA Repository for AuditLog entity (BR18).
 */
public class AuditLogRepository {

    public void save(EntityManager em, AuditLog log) {
        em.persist(log);
    }

    public List<AuditLog> findRecentByEntity(EntityManager em, String entityType, Long entityId, int limit) {
        TypedQuery<AuditLog> query = em.createQuery(
                "SELECT a FROM AuditLog a WHERE a.entityType = :entityType AND a.entityId = :entityId " +
                "ORDER BY a.createdAt DESC",
                AuditLog.class
        );
        query.setParameter("entityType", entityType);
        query.setParameter("entityId", entityId);
        query.setMaxResults(Math.max(1, limit));
        return query.getResultList();
    }
}
