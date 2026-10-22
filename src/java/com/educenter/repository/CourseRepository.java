package com.educenter.repository;

import com.educenter.dto.CourseFilterDTO;
import com.educenter.entity.Course;
import com.educenter.entity.EduClass;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class CourseRepository {

    public List<Course> searchCourses(EntityManager em, CourseFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT c FROM Course c JOIN FETCH c.subject s WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        if ("fee_asc".equalsIgnoreCase(filter.getSort())) {
            jpql.append(" ORDER BY c.fee ASC, c.id DESC");
        } else if ("fee_desc".equalsIgnoreCase(filter.getSort())) {
            jpql.append(" ORDER BY c.fee DESC, c.id DESC");
        } else if ("name_asc".equalsIgnoreCase(filter.getSort())) {
            jpql.append(" ORDER BY c.name ASC, c.id DESC");
        } else {
            // Default "newest" with featured on top
            jpql.append(" ORDER BY c.isFeatured DESC, c.id DESC");
        }

        TypedQuery<Course> query = em.createQuery(jpql.toString(), Course.class);
        setFilterParameters(query, filter);

        query.setFirstResult(filter.getOffset());
        query.setMaxResults(filter.getPageSize());

        return query.getResultList();
    }

    public long countCourses(EntityManager em, CourseFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(c) FROM Course c JOIN c.subject s WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setFilterParameters(query, filter);

        return query.getSingleResult();
    }

    public Optional<Course> findById(EntityManager em, Long id) {
        if (id == null) {
            return Optional.empty();
        }
        try {
            TypedQuery<Course> query = em.createQuery(
                    "SELECT c FROM Course c JOIN FETCH c.subject s WHERE c.id = :id",
                    Course.class
            );
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<EduClass> findOpenClassesByCourseId(EntityManager em, Long courseId) {
        if (courseId == null) {
            return List.of();
        }
        TypedQuery<EduClass> query = em.createQuery(
                "SELECT cl FROM EduClass cl JOIN FETCH cl.teacher t WHERE cl.course.id = :courseId AND cl.status = 'OPEN' ORDER BY cl.startDate ASC, cl.id ASC",
                EduClass.class
        );
        query.setParameter("courseId", courseId);
        return query.getResultList();
    }

    public List<Course> findRelatedCourses(EntityManager em, Long subjectId, Integer gradeLevel, Long excludeCourseId, int limit) {
        StringBuilder jpql = new StringBuilder(
                "SELECT c FROM Course c JOIN FETCH c.subject s WHERE c.status = 'OPEN' "
        );
        if (excludeCourseId != null) {
            jpql.append("AND c.id <> :excludeId ");
        }
        if (subjectId != null && gradeLevel != null) {
            jpql.append("AND (c.subject.id = :subjectId OR c.gradeLevel = :gradeLevel) ");
        } else if (subjectId != null) {
            jpql.append("AND c.subject.id = :subjectId ");
        } else if (gradeLevel != null) {
            jpql.append("AND c.gradeLevel = :gradeLevel ");
        }
        jpql.append("ORDER BY c.isFeatured DESC, c.id DESC");

        TypedQuery<Course> query = em.createQuery(jpql.toString(), Course.class);
        if (excludeCourseId != null) {
            query.setParameter("excludeId", excludeCourseId);
        }
        if (subjectId != null) {
            query.setParameter("subjectId", subjectId);
        }
        if (gradeLevel != null) {
            query.setParameter("gradeLevel", gradeLevel);
        }
        query.setMaxResults(Math.max(1, limit));
        return query.getResultList();
    }

    private void appendFilterConditions(StringBuilder jpql, CourseFilterDTO filter) {
        if (filter.getStatus() != null && !"all".equalsIgnoreCase(filter.getStatus())) {
            jpql.append("AND UPPER(c.status) = :status ");
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            jpql.append("AND (LOWER(c.name) LIKE :kw OR LOWER(c.code) LIKE :kw OR LOWER(c.targetExam) LIKE :kw OR LOWER(s.name) LIKE :kw) ");
        }
        if (filter.getSubjectId() != null) {
            jpql.append("AND c.subject.id = :subjectId ");
        }
        if (filter.getGradeLevel() != null) {
            jpql.append("AND c.gradeLevel = :gradeLevel ");
        }
        if (filter.getMinFee() != null) {
            jpql.append("AND c.fee >= :minFee ");
        }
        if (filter.getMaxFee() != null) {
            jpql.append("AND c.fee <= :maxFee ");
        }
    }

    private void setFilterParameters(TypedQuery<?> query, CourseFilterDTO filter) {
        if (filter.getStatus() != null && !"all".equalsIgnoreCase(filter.getStatus())) {
            query.setParameter("status", filter.getStatus().toUpperCase());
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            query.setParameter("kw", "%" + filter.getKeyword().trim().toLowerCase() + "%");
        }
        if (filter.getSubjectId() != null) {
            query.setParameter("subjectId", filter.getSubjectId());
        }
        if (filter.getGradeLevel() != null) {
            query.setParameter("gradeLevel", filter.getGradeLevel());
        }
        if (filter.getMinFee() != null) {
            query.setParameter("minFee", filter.getMinFee());
        }
        if (filter.getMaxFee() != null) {
            query.setParameter("maxFee", filter.getMaxFee());
        }
    }
}
