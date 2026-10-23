package com.educenter.repository;

import com.educenter.dto.CourseFilterDTO;
import com.educenter.dto.ClassFactsDTO;
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

    public Optional<Course> findByIdForUpdate(EntityManager em, Long id) {
        Course course = em.find(Course.class, id, jakarta.persistence.LockModeType.PESSIMISTIC_WRITE);
        // Cart queries may already have loaded this entity before another transaction changed its fee.
        if (course != null) em.refresh(course, jakarta.persistence.LockModeType.PESSIMISTIC_WRITE);
        return Optional.ofNullable(course);
    }

    public List<EduClass> findOpenClassesByCourseId(EntityManager em, Long courseId) {
        if (courseId == null) {
            return List.of();
        }
        TypedQuery<EduClass> query = em.createQuery(
                "SELECT cl FROM EduClass cl LEFT JOIN FETCH cl.teacher t WHERE cl.course.id = :courseId AND cl.status IN ('OPEN', 'PLANNING') ORDER BY cl.startDate ASC, cl.id ASC",
                EduClass.class
        );
        query.setParameter("courseId", courseId);
        return query.getResultList();
    }

    public ClassFactsDTO findClassFacts(EntityManager em, Long classId) {
        Object[] row = (Object[]) em.createNativeQuery("SELECT "
                + "(SELECT COUNT(*) FROM dbo.Enrollments e WHERE e.class_id = cl.id AND e.status IN ('ACTIVE','RESERVED')), "
                + "r.name, (SELECT TOP 1 CONVERT(varchar(10), cs.session_date, 103) + ' · ' "
                + "+ CONVERT(varchar(5), cs.start_at, 108) + '–' + CONVERT(varchar(5), cs.end_at, 108) "
                + "FROM dbo.ClassSessions cs WHERE cs.class_id = cl.id AND cs.status = 'SCHEDULED' "
                + "AND cs.session_date >= CAST(GETDATE() AS date) ORDER BY cs.session_date, cs.start_at) "
                + "FROM dbo.Classes cl LEFT JOIN dbo.Rooms r ON r.id = cl.room_id WHERE cl.id = :classId")
                .setParameter("classId", classId).getSingleResult();
        return new ClassFactsDTO(((Number) row[0]).longValue(), (String) row[1], (String) row[2]);
    }

    public long countOpenBySubject(EntityManager em, Long subjectId) {
        return em.createQuery("SELECT COUNT(c) FROM Course c WHERE c.subject.id = :sid AND c.status = 'OPEN'", Long.class)
                .setParameter("sid", subjectId).getSingleResult();
    }

    public List<Integer> findAvailableGrades(EntityManager em) {
        return em.createQuery("SELECT DISTINCT c.gradeLevel FROM Course c WHERE c.status = 'OPEN' "
                + "AND c.gradeLevel BETWEEN 6 AND 12 ORDER BY c.gradeLevel", Integer.class).getResultList();
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
            jpql.append("AND (LOWER(c.name) LIKE :kw OR LOWER(c.code) LIKE :kw OR LOWER(c.targetExam) LIKE :kw OR LOWER(s.name) LIKE :kw OR LOWER(c.description) LIKE :kw) ");
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
