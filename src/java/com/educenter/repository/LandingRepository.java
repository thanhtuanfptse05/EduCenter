package com.educenter.repository;

import com.educenter.entity.Course;
import com.educenter.entity.EduClass;
import com.educenter.entity.Lead;
import com.educenter.entity.Subject;
import com.educenter.entity.Teacher;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

/**
 * JPA Repository for public landing portal metrics, courses, teachers, and lead generation.
 */
public class LandingRepository {

    public long countActiveStudents(EntityManager em) {
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(u) FROM User u JOIN u.roles r WHERE r.code = 'STUDENT' AND u.status = 'ACTIVE'", Long.class);
            Long count = query.getSingleResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            throw e;
        }
    }

    public long countOpenClasses(EntityManager em) {
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM EduClass c WHERE c.status = 'OPEN'", Long.class);
            Long count = query.getSingleResult();
            return (count != null) ? count : 0L;
        } catch (Exception e) { throw e; }
    }

    public long countActiveTeachers(EntityManager em) {
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(t) FROM Teacher t WHERE t.status = 'ACTIVE'", Long.class);
            Long count = query.getSingleResult();
            return (count != null) ? count : 0L;
        } catch (Exception e) { throw e; }
    }

    public long countClassesByGrade(EntityManager em, int gradeLevel) {
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM EduClass c JOIN c.course cr WHERE cr.gradeLevel = :grade AND c.status = 'OPEN'", Long.class);
            query.setParameter("grade", gradeLevel);
            Long count = query.getSingleResult();
            return (count != null) ? count : 0L;
        } catch (Exception e) { throw e; }
    }

    public List<Course> findFeaturedCourses(EntityManager em) {
        TypedQuery<Course> query = em.createQuery(
                "SELECT c FROM Course c JOIN FETCH c.subject s WHERE c.isFeatured = true AND c.status = 'OPEN' ORDER BY c.gradeLevel ASC, c.id ASC", Course.class);
        return query.getResultList();
    }

    public List<EduClass> findOpenClassesForCourses(EntityManager em, List<Long> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return List.of();
        }
        TypedQuery<EduClass> query = em.createQuery(
                "SELECT cl FROM EduClass cl JOIN FETCH cl.teacher t WHERE cl.course.id IN :courseIds AND cl.status = 'OPEN'", EduClass.class);
        query.setParameter("courseIds", courseIds);
        return query.getResultList();
    }

    public List<Teacher> findFacultyTeachers(EntityManager em) {
        TypedQuery<Teacher> query = em.createQuery(
                "SELECT t FROM Teacher t LEFT JOIN FETCH t.user WHERE t.status = 'ACTIVE' ORDER BY t.id ASC", Teacher.class);
        return query.setMaxResults(8).getResultList();
    }

    public List<Subject> findAllActiveSubjects(EntityManager em) {
        TypedQuery<Subject> query = em.createQuery(
                "SELECT s FROM Subject s WHERE s.status = 'ACTIVE' ORDER BY s.id ASC", Subject.class);
        return query.getResultList();
    }

    public long countCoursesBySubject(EntityManager em, Long subjectId) {
        try {
            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(c) FROM Course c WHERE c.subject.id = :subjectId AND c.status = 'OPEN'", Long.class);
            query.setParameter("subjectId", subjectId);
            Long count = query.getSingleResult();
            return (count != null) ? count : 0L;
        } catch (Exception e) { throw e; }
    }

    public String findRepresentativeImageBySubject(EntityManager em, Long subjectId) {
        try {
            TypedQuery<String> query = em.createQuery(
                    "SELECT c.imageUrl FROM Course c WHERE c.subject.id = :subjectId AND c.imageUrl IS NOT NULL ORDER BY c.id ASC", String.class);
            query.setParameter("subjectId", subjectId);
            List<String> list = query.setMaxResults(1).getResultList();
            return list.isEmpty() ? null : list.get(0);
        } catch (Exception e) { throw e; }
    }

    public Lead saveLead(EntityManager em, Lead lead) {
        if (lead.getId() == null) {
            em.persist(lead);
            return lead;
        } else {
            return em.merge(lead);
        }
    }
}
