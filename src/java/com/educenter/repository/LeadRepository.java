package com.educenter.repository;

import com.educenter.entity.Lead;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.util.Optional;

public class LeadRepository {

    public Lead save(EntityManager em, Lead lead) {
        if (lead.getId() == null) {
            em.persist(lead);
            return lead;
        } else {
            return em.merge(lead);
        }
    }

    public Optional<Lead> findById(EntityManager em, Long id) {
        if (id == null) {
            return Optional.empty();
        }
        Lead lead = em.find(Lead.class, id);
        return Optional.ofNullable(lead);
    }

    public long countLeadsThisYear(EntityManager em, int year) {
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(l) FROM Lead l WHERE YEAR(l.createdAt) = :yr",
                    Long.class
            );
            query.setParameter("yr", year);
            Long count = query.getSingleResult();
            return (count != null) ? count : 0L;
        } catch (Exception e) {
            return 0L;
        }
    }
}
