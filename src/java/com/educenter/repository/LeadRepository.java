package com.educenter.repository;

import com.educenter.dto.LeadFilterDTO;
import com.educenter.entity.Consultation;
import com.educenter.entity.Lead;
import com.educenter.entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.*;

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

    public List<Lead> findLeads(EntityManager em, LeadFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT l FROM Lead l LEFT JOIN FETCH l.assignedTo WHERE 1=1");
        Map<String, Object> params = new HashMap<>();
        buildWhereClause(filter, jpql, params);
        jpql.append(" ORDER BY l.createdAt DESC");

        TypedQuery<Lead> query = em.createQuery(jpql.toString(), Lead.class);
        params.forEach(query::setParameter);

        int page = filter != null ? filter.getPage() : 1;
        int pageSize = filter != null ? filter.getPageSize() : 10;
        query.setFirstResult((page - 1) * pageSize);
        query.setMaxResults(pageSize);

        return query.getResultList();
    }

    public long countLeads(EntityManager em, LeadFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(l) FROM Lead l WHERE 1=1");
        Map<String, Object> params = new HashMap<>();
        buildWhereClause(filter, jpql, params);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        params.forEach(query::setParameter);

        Long count = query.getSingleResult();
        return (count != null) ? count : 0L;
    }

    private void buildWhereClause(LeadFilterDTO filter, StringBuilder jpql, Map<String, Object> params) {
        if (filter == null) return;

        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            String kw = "%" + filter.getKeyword().trim().toLowerCase() + "%";
            jpql.append(" AND (LOWER(l.name) LIKE :kw OR l.phone LIKE :kw OR LOWER(l.email) LIKE :kw)");
            params.put("kw", kw);
        }
        if (filter.getStatus() != null && !filter.getStatus().trim().isEmpty()) {
            jpql.append(" AND l.status = :st");
            params.put("st", filter.getStatus().trim());
        }
        if (filter.getSource() != null && !filter.getSource().trim().isEmpty()) {
            jpql.append(" AND l.source = :sc");
            params.put("sc", filter.getSource().trim());
        }
        if (filter.getGradeLevel() != null && filter.getGradeLevel() > 0) {
            jpql.append(" AND l.gradeLevel = :gl");
            params.put("gl", filter.getGradeLevel());
        }
        if (filter.getAssignedToId() != null && filter.getAssignedToId() > 0) {
            jpql.append(" AND l.assignedTo.id = :aid");
            params.put("aid", filter.getAssignedToId());
        }
    }

    public Map<String, Long> getLeadStats(EntityManager em) {
        Map<String, Long> stats = new HashMap<>();
        stats.put("total", 0L);
        stats.put("new", 0L);
        stats.put("consulting", 0L);
        stats.put("enrolled", 0L);
        stats.put("lost", 0L);

        try {
            List<Object[]> rows = em.createQuery(
                    "SELECT l.status, COUNT(l) FROM Lead l GROUP BY l.status",
                    Object[].class
            ).getResultList();

            long total = 0;
            long consulting = 0;
            for (Object[] row : rows) {
                String st = (String) row[0];
                Long cnt = (Long) row[1];
                total += cnt;
                if ("NEW".equals(st)) {
                    stats.put("new", cnt);
                } else if ("ENROLLED".equals(st)) {
                    stats.put("enrolled", cnt);
                } else if ("LOST".equals(st)) {
                    stats.put("lost", cnt);
                } else if ("CONTACTED".equals(st) || "ASSESSED".equals(st) || "CONSULTING".equals(st)) {
                    consulting += cnt;
                }
            }
            stats.put("total", total);
            stats.put("consulting", consulting);
        } catch (Exception e) {
            // Keep defaults
        }
        return stats;
    }

    public List<Consultation> findConsultationsByLeadId(EntityManager em, Long leadId) {
        if (leadId == null) return Collections.emptyList();
        try {
            return em.createQuery(
                    "SELECT c FROM Consultation c LEFT JOIN FETCH c.staff WHERE c.lead.id = :lid ORDER BY c.contactedAt DESC",
                    Consultation.class
            ).setParameter("lid", leadId).getResultList();
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    public Consultation saveConsultation(EntityManager em, Consultation c) {
        if (c.getId() == null) {
            em.persist(c);
            return c;
        } else {
            return em.merge(c);
        }
    }

    public List<User> findStaffUsers(EntityManager em) {
        try {
            return em.createQuery(
                    "SELECT DISTINCT u FROM User u JOIN u.roles r WHERE r.code IN ('STAFF', 'ADMIN') AND u.status = 'ACTIVE' ORDER BY u.fullName ASC",
                    User.class
            ).getResultList();
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }
}
