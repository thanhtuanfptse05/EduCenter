package com.educenter.repository;

import com.educenter.dto.AssessmentListItemDTO;
import com.educenter.entity.Assessment;
import com.educenter.entity.AssessmentScore;
import com.educenter.entity.EduClass;
import com.educenter.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AssessmentRepository {

    public List<EduClass> findClassesByTeacher(EntityManager em, Long teacherUserId, boolean isAdmin) {
        if (isAdmin || teacherUserId == null) {
            return em.createQuery("SELECT c FROM EduClass c WHERE c.status IN ('OPEN', 'ONGOING') ORDER BY c.code ASC", EduClass.class)
                    .getResultList();
        }
        return em.createQuery("SELECT c FROM EduClass c WHERE c.teacher.user.id = :userId AND c.status IN ('OPEN', 'ONGOING') ORDER BY c.code ASC", EduClass.class)
                .setParameter("userId", teacherUserId)
                .getResultList();
    }

    public List<AssessmentListItemDTO> findAssessments(EntityManager em, Long teacherUserId, boolean isAdmin, Long classId, String status) {
        StringBuilder jpql = new StringBuilder(
                "SELECT a, " +
                "  (SELECT COUNT(s) FROM AssessmentScore s WHERE s.assessment.id = a.id), " +
                "  (SELECT COUNT(e) FROM Enrollment e WHERE e.eduClass.id = a.eduClass.id AND e.status = 'ACTIVE'), " +
                "  (SELECT AVG(s.score) FROM AssessmentScore s WHERE s.assessment.id = a.id) " +
                "FROM Assessment a " +
                "JOIN FETCH a.eduClass c " +
                "WHERE 1=1 "
        );

        if (!isAdmin && teacherUserId != null) {
            jpql.append("AND c.teacher.user.id = :teacherUserId ");
        }
        if (classId != null && classId > 0) {
            jpql.append("AND c.id = :classId ");
        }
        if (status != null && !status.trim().isEmpty()) {
            jpql.append("AND a.status = :status ");
        }

        jpql.append("ORDER BY a.testDate DESC, a.createdAt DESC");

        TypedQuery<Object[]> query = em.createQuery(jpql.toString(), Object[].class);
        if (!isAdmin && teacherUserId != null) {
            query.setParameter("teacherUserId", teacherUserId);
        }
        if (classId != null && classId > 0) {
            query.setParameter("classId", classId);
        }
        if (status != null && !status.trim().isEmpty()) {
            query.setParameter("status", status.trim().toUpperCase());
        }

        List<Object[]> rows = query.getResultList();
        List<AssessmentListItemDTO> list = new ArrayList<>();

        for (Object[] row : rows) {
            Assessment a = (Assessment) row[0];
            Long graded = (Long) row[1];
            Long total = (Long) row[2];
            Double avg = (Double) row[3];

            AssessmentListItemDTO dto = new AssessmentListItemDTO();
            dto.setId(a.getId());
            dto.setClassId(a.getEduClass().getId());
            dto.setClassCode(a.getEduClass().getCode());
            dto.setClassName(a.getEduClass().getName());
            dto.setTitle(a.getTitle());
            dto.setAssessmentType(a.getAssessmentType());
            dto.setMaxScore(a.getMaxScore());
            dto.setWeight(a.getWeight());
            dto.setTestDate(a.getTestDate());
            dto.setStatus(a.getStatus());
            dto.setGradedCount(graded != null ? graded.intValue() : 0);
            dto.setTotalStudents(total != null ? total.intValue() : 0);
            if (avg != null) {
                dto.setAverageScore(BigDecimal.valueOf(avg).setScale(2, RoundingMode.HALF_UP));
            }
            dto.setCreatedAt(a.getCreatedAt());

            list.add(dto);
        }
        return list;
    }

    public Optional<Assessment> findAssessmentById(EntityManager em, Long id) {
        try {
            Assessment a = em.createQuery(
                    "SELECT a FROM Assessment a " +
                    "JOIN FETCH a.eduClass c " +
                    "LEFT JOIN FETCH c.course cr " +
                    "LEFT JOIN FETCH cr.subject sub " +
                    "LEFT JOIN FETCH c.teacher t " +
                    "LEFT JOIN FETCH t.user tu " +
                    "WHERE a.id = :id", Assessment.class)
                    .setParameter("id", id)
                    .getSingleResult();
            return Optional.of(a);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<Student> findActiveStudentsInClass(EntityManager em, Long classId) {
        return em.createQuery(
                "SELECT e.student FROM Enrollment e " +
                "WHERE e.eduClass.id = :classId AND e.status = 'ACTIVE' " +
                "ORDER BY e.student.fullName ASC", Student.class)
                .setParameter("classId", classId)
                .getResultList();
    }

    public List<AssessmentScore> findScoresByAssessmentId(EntityManager em, Long assessmentId) {
        return em.createQuery(
                "SELECT s FROM AssessmentScore s " +
                "JOIN FETCH s.student st " +
                "WHERE s.assessment.id = :assessmentId " +
                "ORDER BY st.fullName ASC", AssessmentScore.class)
                .setParameter("assessmentId", assessmentId)
                .getResultList();
    }

    public Optional<AssessmentScore> findScore(EntityManager em, Long assessmentId, Long studentId) {
        try {
            AssessmentScore s = em.createQuery(
                    "SELECT s FROM AssessmentScore s " +
                    "WHERE s.assessment.id = :assessmentId AND s.student.id = :studentId", AssessmentScore.class)
                    .setParameter("assessmentId", assessmentId)
                    .setParameter("studentId", studentId)
                    .getSingleResult();
            return Optional.of(s);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public void saveAssessment(EntityManager em, Assessment assessment) {
        em.persist(assessment);
    }

    public void updateAssessment(EntityManager em, Assessment assessment) {
        em.merge(assessment);
    }

    public void saveScore(EntityManager em, AssessmentScore score) {
        em.persist(score);
    }

    public void updateScore(EntityManager em, AssessmentScore score) {
        em.merge(score);
    }
}
