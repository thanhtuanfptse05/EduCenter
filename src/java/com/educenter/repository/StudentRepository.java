package com.educenter.repository;

import com.educenter.dto.StudentFilterDTO;
import com.educenter.dto.StudentStatsDTO;
import com.educenter.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class StudentRepository {

    public Optional<Student> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        try {
            TypedQuery<Student> query = em.createQuery(
                    "SELECT s FROM Student s LEFT JOIN FETCH s.user u WHERE s.id = :id",
                    Student.class
            );
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Student> findByUserId(EntityManager em, Long userId) {
        if (userId == null) return Optional.empty();
        try {
            TypedQuery<Student> query = em.createQuery(
                    "SELECT s FROM Student s WHERE s.user.id = :userId",
                    Student.class
            );
            query.setParameter("userId", userId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public Optional<Student> findByEmail(EntityManager em, String email) {
        if (email == null || email.trim().isEmpty()) return Optional.empty();
        try {
            TypedQuery<Student> query = em.createQuery(
                    "SELECT s FROM Student s LEFT JOIN FETCH s.user u WHERE LOWER(TRIM(s.email)) = :email OR (s.user IS NOT NULL AND LOWER(TRIM(s.user.email)) = :email)",
                    Student.class
            );
            query.setParameter("email", email.trim().toLowerCase());
            List<Student> results = query.getResultList();
            if (results.isEmpty()) {
                return Optional.empty();
            }
            return Optional.of(results.get(0));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    public boolean existsByUserId(EntityManager em, Long userId, Long excludeStudentId) {
        if (userId == null) return false;
        StringBuilder jpql = new StringBuilder("SELECT COUNT(s) FROM Student s WHERE s.user.id = :userId");
        if (excludeStudentId != null) {
            jpql.append(" AND s.id <> :excludeStudentId");
        }
        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        query.setParameter("userId", userId);
        if (excludeStudentId != null) {
            query.setParameter("excludeStudentId", excludeStudentId);
        }
        Long count = query.getSingleResult();
        return count != null && count > 0;
    }

    public Student save(EntityManager em, Student student) {
        if (student.getId() == null) {
            em.persist(student);
            return student;
        } else {
            return em.merge(student);
        }
    }

    public Student update(EntityManager em, Student student) {
        return em.merge(student);
    }

    public List<Student> searchStudents(EntityManager em, StudentFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT s FROM Student s LEFT JOIN FETCH s.user u WHERE 1=1 ");
        appendFilterConditions(jpql, filter);
        jpql.append(" ORDER BY s.id DESC");

        TypedQuery<Student> query = em.createQuery(jpql.toString(), Student.class);
        setFilterParameters(query, filter);

        query.setFirstResult(filter.getOffset());
        query.setMaxResults(filter.getPageSize());

        return query.getResultList();
    }

    public long countStudents(EntityManager em, StudentFilterDTO filter) {
        StringBuilder jpql = new StringBuilder("SELECT COUNT(s) FROM Student s WHERE 1=1 ");
        appendFilterConditions(jpql, filter);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setFilterParameters(query, filter);

        Long count = query.getSingleResult();
        return count != null ? count : 0L;
    }

    public StudentStatsDTO getStudentStats(EntityManager em) {
        long total = em.createQuery("SELECT COUNT(s) FROM Student s", Long.class).getSingleResult();
        long studying = em.createQuery("SELECT COUNT(s) FROM Student s WHERE s.status = 'STUDYING'", Long.class).getSingleResult();
        long reserved = em.createQuery("SELECT COUNT(s) FROM Student s WHERE s.status = 'RESERVED'", Long.class).getSingleResult();
        long graduated = em.createQuery("SELECT COUNT(s) FROM Student s WHERE s.status = 'GRADUATED'", Long.class).getSingleResult();
        long dropped = em.createQuery("SELECT COUNT(s) FROM Student s WHERE s.status = 'DROPPED'", Long.class).getSingleResult();

        return new StudentStatsDTO(total, studying, reserved, graduated, dropped);
    }

    public List<Student> findAllActive(EntityManager em) {
        return em.createQuery(
                "SELECT s FROM Student s WHERE s.status = 'STUDYING' ORDER BY s.fullName ASC",
                Student.class
        ).getResultList();
    }

    public long countGuardiansByStudentId(EntityManager em, Long studentId) {
        if (studentId == null) return 0L;
        Long count = em.createQuery(
                "SELECT COUNT(sg) FROM StudentGuardian sg WHERE sg.student.id = :studentId",
                Long.class
        ).setParameter("studentId", studentId).getSingleResult();
        return count != null ? count : 0L;
    }

    public long countEnrollmentsByStudentId(EntityManager em, Long studentId) {
        if (studentId == null) return 0L;
        try {
            Object result = em.createNativeQuery(
                    "SELECT COUNT(*) FROM Enrollments WHERE student_id = ?1"
            ).setParameter(1, studentId).getSingleResult();
            if (result instanceof Number) {
                return ((Number) result).longValue();
            }
        } catch (Exception e) {
            // Table might not exist or empty
        }
        return 0L;
    }

    private void appendFilterConditions(StringBuilder jpql, StudentFilterDTO filter) {
        if (filter.getStatus() != null && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            jpql.append(" AND s.status = :status");
        }
        if (filter.getGradeLevel() != null) {
            jpql.append(" AND s.gradeLevel = :gradeLevel");
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            jpql.append(" AND (LOWER(s.fullName) LIKE :kw OR LOWER(s.phone) LIKE :kw OR LOWER(s.email) LIKE :kw OR LOWER(s.school) LIKE :kw OR LOWER(s.targetGoal) LIKE :kw)");
        }
    }

    private void setFilterParameters(TypedQuery<?> query, StudentFilterDTO filter) {
        if (filter.getStatus() != null && !"ALL".equalsIgnoreCase(filter.getStatus())) {
            query.setParameter("status", filter.getStatus().toUpperCase());
        }
        if (filter.getGradeLevel() != null) {
            query.setParameter("gradeLevel", filter.getGradeLevel());
        }
        if (filter.getKeyword() != null && !filter.getKeyword().trim().isEmpty()) {
            query.setParameter("kw", "%" + filter.getKeyword().trim().toLowerCase() + "%");
        }
    }
}
