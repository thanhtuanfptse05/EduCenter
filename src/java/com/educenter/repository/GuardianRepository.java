package com.educenter.repository;

import com.educenter.dto.GuardianFilterDTO;
import com.educenter.entity.Guardian;
import com.educenter.entity.StudentGuardian;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class GuardianRepository {

    public Optional<Guardian> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        try {
            TypedQuery<Guardian> query = em.createQuery(
                    "SELECT g FROM Guardian g LEFT JOIN FETCH g.user u WHERE g.id = :id",
                    Guardian.class
            );
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Guardian> findByUserId(EntityManager em, Long userId) {
        if (userId == null) return Optional.empty();
        try {
            TypedQuery<Guardian> query = em.createQuery(
                    "SELECT g FROM Guardian g LEFT JOIN FETCH g.user u WHERE g.user.id = :userId",
                    Guardian.class
            );
            query.setParameter("userId", userId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public boolean existsByUserId(EntityManager em, Long userId, Long excludeGuardianId) {
        if (userId == null) return false;
        StringBuilder jpql = new StringBuilder("SELECT COUNT(g) FROM Guardian g WHERE g.user.id = :userId");
        if (excludeGuardianId != null) {
            jpql.append(" AND g.id <> :excludeGuardianId");
        }
        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        query.setParameter("userId", userId);
        if (excludeGuardianId != null) {
            query.setParameter("excludeGuardianId", excludeGuardianId);
        }
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    public Guardian save(EntityManager em, Guardian guardian) {
        if (guardian.getId() == null) {
            em.persist(guardian);
            return guardian;
        } else {
            return em.merge(guardian);
        }
    }

    public Guardian update(EntityManager em, Guardian guardian) {
        return em.merge(guardian);
    }

    public List<Guardian> searchGuardians(EntityManager em, GuardianFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT g FROM Guardian g LEFT JOIN FETCH g.user u WHERE 1=1 ");
        appendFilterConditions(jpql, filter);
        jpql.append(" ORDER BY g.id DESC");

        TypedQuery<Guardian> query = em.createQuery(jpql.toString(), Guardian.class);
        setFilterParameters(query, filter);

        query.setFirstResult(filter.getOffset());
        query.setMaxResults(filter.getPageSize());

        return query.getResultList();
    }

    public long countGuardians(EntityManager em, GuardianFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(g) FROM Guardian g WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setFilterParameters(query, filter);

        Long count = query.getSingleResult();
        return count != null ? count : 0L;
    }

    public List<StudentGuardian> findLinksByStudentId(EntityManager em, Long studentId) {
        if (studentId == null) return List.of();
        TypedQuery<StudentGuardian> query = em.createQuery(
                "SELECT sg FROM StudentGuardian sg " +
                "JOIN FETCH sg.guardian g " +
                "LEFT JOIN FETCH g.user u " +
                "WHERE sg.student.id = :studentId " +
                "ORDER BY sg.isPrimary DESC, sg.id ASC",
                StudentGuardian.class
        );
        query.setParameter("studentId", studentId);
        return query.getResultList();
    }

    public List<StudentGuardian> findLinksByGuardianId(EntityManager em, Long guardianId) {
        if (guardianId == null) return List.of();
        TypedQuery<StudentGuardian> query = em.createQuery(
                "SELECT sg FROM StudentGuardian sg " +
                "JOIN FETCH sg.student s " +
                "WHERE sg.guardian.id = :guardianId " +
                "ORDER BY sg.id ASC",
                StudentGuardian.class
        );
        query.setParameter("guardianId", guardianId);
        return query.getResultList();
    }

    public Optional<StudentGuardian> findLinkById(EntityManager em, Long linkId) {
        if (linkId == null) return Optional.empty();
        try {
            TypedQuery<StudentGuardian> query = em.createQuery(
                    "SELECT sg FROM StudentGuardian sg " +
                    "JOIN FETCH sg.student s " +
                    "JOIN FETCH sg.guardian g " +
                    "LEFT JOIN FETCH g.user u " +
                    "WHERE sg.id = :linkId",
                    StudentGuardian.class
            );
            query.setParameter("linkId", linkId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<StudentGuardian> findLinkByStudentAndGuardian(EntityManager em, Long studentId, Long guardianId) {
        if (studentId == null || guardianId == null) return Optional.empty();
        try {
            TypedQuery<StudentGuardian> query = em.createQuery(
                    "SELECT sg FROM StudentGuardian sg " +
                    "WHERE sg.student.id = :studentId AND sg.guardian.id = :guardianId",
                    StudentGuardian.class
            );
            query.setParameter("studentId", studentId);
            query.setParameter("guardianId", guardianId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public StudentGuardian saveLink(EntityManager em, StudentGuardian link) {
        if (link.getId() == null) {
            em.persist(link);
            return link;
        } else {
            return em.merge(link);
        }
    }

    public void deleteLink(EntityManager em, StudentGuardian link) {
        em.remove(em.contains(link) ? link : em.merge(link));
    }

    public void clearPrimaryForStudent(EntityManager em, Long studentId) {
        if (studentId == null) return;
        em.createQuery("UPDATE StudentGuardian sg SET sg.isPrimary = false WHERE sg.student.id = :studentId")
          .setParameter("studentId", studentId)
          .executeUpdate();
    }

    private void appendFilterConditions(StringBuilder jpql, GuardianFilterDTO filter) {
        if (filter.getStatus() != null && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            jpql.append(" AND g.status = :status");
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            jpql.append(" AND (LOWER(g.fullName) LIKE :kw OR LOWER(g.phone) LIKE :kw OR LOWER(g.email) LIKE :kw OR LOWER(g.occupation) LIKE :kw OR LOWER(g.address) LIKE :kw)");
        }
        if ("VERIFIED".equalsIgnoreCase(filter.getVerification())) {
            jpql.append(" AND EXISTS (SELECT 1 FROM StudentGuardian sg WHERE sg.guardian = g AND sg.verifiedAt IS NOT NULL)");
        } else if ("UNVERIFIED".equalsIgnoreCase(filter.getVerification())) {
            jpql.append(" AND NOT EXISTS (SELECT 1 FROM StudentGuardian sg WHERE sg.guardian = g AND sg.verifiedAt IS NOT NULL)");
        }
    }

    private void setFilterParameters(TypedQuery<?> query, GuardianFilterDTO filter) {
        if (filter.getStatus() != null && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            query.setParameter("status", filter.getStatus().toUpperCase());
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            query.setParameter("kw", "%" + filter.getKeyword().trim().toLowerCase() + "%");
        }
    }
}
