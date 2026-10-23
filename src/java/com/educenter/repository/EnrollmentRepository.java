package com.educenter.repository;

import com.educenter.dto.ClassEnrollmentOptionDTO;
import com.educenter.dto.EnrollmentViewDTO;
import com.educenter.entity.EduClass;
import com.educenter.entity.Enrollment;
import com.educenter.entity.Invoice;
import com.educenter.entity.Student;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class EnrollmentRepository {

    public List<EnrollmentViewDTO> findEnrollments(EntityManager em, Long classId, String status, String keyword, int page, int pageSize) {
        StringBuilder jpql = new StringBuilder(
                "SELECT e, i.id, i.invoiceCode, i.status FROM Enrollment e " +
                "JOIN FETCH e.student s " +
                "JOIN FETCH e.eduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "LEFT JOIN Invoice i ON i.enrollment.id = e.id " +
                "WHERE 1=1 "
        );

        appendFilters(jpql, classId, status, keyword);
        jpql.append("ORDER BY e.enrolledAt DESC");

        TypedQuery<Object[]> query = em.createQuery(jpql.toString(), Object[].class);
        setParameters(query, classId, status, keyword);

        query.setFirstResult((page - 1) * pageSize);
        query.setMaxResults(pageSize);

        List<Object[]> rows = query.getResultList();
        List<EnrollmentViewDTO> list = new ArrayList<>();
        for (Object[] row : rows) {
            Enrollment e = (Enrollment) row[0];
            Long invId = (Long) row[1];
            String invCode = (String) row[2];
            String invStatus = (String) row[3];

            EnrollmentViewDTO dto = new EnrollmentViewDTO();
            dto.setEnrollmentId(e.getId());
            dto.setStudentId(e.getStudent().getId());
            dto.setStudentCode(e.getStudent().getCode());
            dto.setStudentName(e.getStudent().getFullName());
            dto.setStudentPhone(e.getStudent().getPhone());

            dto.setClassId(e.getEduClass().getId());
            dto.setClassCode(e.getEduClass().getCode());
            dto.setClassName(e.getEduClass().getName());
            dto.setSubjectName(e.getEduClass().getCourse().getSubject().getName());
            dto.setCourseFee(e.getEduClass().getCourse().getFee());

            dto.setStatus(e.getStatus());
            dto.setEnrolledAt(e.getEnrolledAt());
            dto.setStartDate(e.getStartDate());
            dto.setEndDate(e.getEndDate());
            dto.setNotes(e.getNotes());

            dto.setInvoiceId(invId);
            dto.setInvoiceCode(invCode);
            dto.setInvoiceStatus(invStatus);

            list.add(dto);
        }
        return list;
    }

    public long countEnrollments(EntityManager em, Long classId, String status, String keyword) {
        StringBuilder jpql = new StringBuilder(
                "SELECT COUNT(e) FROM Enrollment e " +
                "JOIN e.student s " +
                "JOIN e.eduClass c " +
                "WHERE 1=1 "
        );

        appendFilters(jpql, classId, status, keyword);

        TypedQuery<Long> query = em.createQuery(jpql.toString(), Long.class);
        setParameters(query, classId, status, keyword);

        return query.getSingleResult();
    }

    private void appendFilters(StringBuilder jpql, Long classId, String status, String keyword) {
        if (classId != null && classId > 0) {
            jpql.append("AND e.eduClass.id = :classId ");
        }
        if (status != null && !status.isBlank() && !status.equalsIgnoreCase("ALL")) {
            jpql.append("AND e.status = :status ");
        }
        if (keyword != null && !keyword.isBlank()) {
            jpql.append("AND (LOWER(s.fullName) LIKE :kw OR s.phone LIKE :kw) ");
        }
    }

    private void setParameters(TypedQuery<?> query, Long classId, String status, String keyword) {
        if (classId != null && classId > 0) {
            query.setParameter("classId", classId);
        }
        if (status != null && !status.isBlank() && !status.equalsIgnoreCase("ALL")) {
            query.setParameter("status", status.toUpperCase());
        }
        if (keyword != null && !keyword.isBlank()) {
            query.setParameter("kw", "%" + keyword.trim().toLowerCase() + "%");
        }
    }

    public Optional<Enrollment> findById(EntityManager em, Long id) {
        if (id == null) return Optional.empty();
        try {
            TypedQuery<Enrollment> query = em.createQuery(
                    "SELECT e FROM Enrollment e " +
                    "JOIN FETCH e.student s " +
                    "JOIN FETCH e.eduClass c " +
                    "JOIN FETCH c.course cr " +
                    "WHERE e.id = :id",
                    Enrollment.class
            );
            query.setParameter("id", id);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public long countActiveByClassId(EntityManager em, Long classId) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM Enrollment e " +
                "WHERE e.eduClass.id = :classId AND e.status = 'ACTIVE'",
                Long.class
        );
        query.setParameter("classId", classId);
        return query.getSingleResult();
    }

    public boolean isStudentActiveOrReservedInClass(EntityManager em, Long studentId, Long classId) {
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(e) FROM Enrollment e " +
                "WHERE e.student.id = :studentId AND e.eduClass.id = :classId " +
                "AND e.status IN ('ACTIVE', 'RESERVED')",
                Long.class
        );
        query.setParameter("studentId", studentId);
        query.setParameter("classId", classId);
        return query.getSingleResult() > 0;
    }

    public boolean hasScheduleConflict(EntityManager em, Long studentId, Long newClassId) {
        // Kiểm tra xem có buổi học nào trong tương lai của lớp mới trùng ngày và thời gian với các lớp ACTIVE khác của học sinh không
        TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(s1) FROM ClassSession s1, ClassSession s2 " +
                "JOIN s2.eduClass c2 " +
                "JOIN Enrollment e ON e.eduClass.id = c2.id " +
                "WHERE s1.eduClass.id = :newClassId " +
                "AND e.student.id = :studentId " +
                "AND e.status = 'ACTIVE' " +
                "AND e.eduClass.id != :newClassId " +
                "AND s1.sessionDate = s2.sessionDate " +
                "AND s1.sessionDate >= :today " +
                "AND s1.startAt < s2.endAt AND s1.endAt > s2.startAt " +
                "AND s1.status != 'CANCELLED' AND s2.status != 'CANCELLED'",
                Long.class
        );
        query.setParameter("newClassId", newClassId);
        query.setParameter("studentId", studentId);
        query.setParameter("today", LocalDate.now());
        return query.getSingleResult() > 0;
    }

    public List<ClassEnrollmentOptionDTO> findOpenClassOptions(EntityManager em) {
        TypedQuery<EduClass> query = em.createQuery(
                "SELECT c FROM EduClass c " +
                "JOIN FETCH c.course cr " +
                "JOIN FETCH cr.subject sub " +
                "WHERE c.status IN ('OPEN', 'ONGOING') " +
                "ORDER BY c.startDate ASC, c.name ASC",
                EduClass.class
        );
        List<EduClass> classes = query.getResultList();

        List<ClassEnrollmentOptionDTO> options = new ArrayList<>();
        for (EduClass c : classes) {
            long activeCount = countActiveByClassId(em, c.getId());
            ClassEnrollmentOptionDTO dto = new ClassEnrollmentOptionDTO();
            dto.setClassId(c.getId());
            dto.setClassCode(c.getCode());
            dto.setClassName(c.getName());
            dto.setCourseName(c.getCourse().getName());
            dto.setSubjectName(c.getCourse().getSubject().getName());
            dto.setCurrentEnrolled((int) activeCount);
            dto.setCapacity(c.getCapacity());
            dto.setFee(c.getCourse().getFee());
            dto.setStartDate(c.getStartDate());
            dto.setEndDate(c.getEndDate());
            dto.setStatus(c.getStatus());
            options.add(dto);
        }
        return options;
    }

    public List<Student> findActiveStudents(EntityManager em) {
        TypedQuery<Student> query = em.createQuery(
                "SELECT s FROM Student s " +
                "WHERE s.status = 'ACTIVE' " +
                "ORDER BY s.fullName ASC",
                Student.class
        );
        return query.getResultList();
    }

    public Optional<Invoice> findInvoiceByEnrollmentId(EntityManager em, Long enrollmentId) {
        try {
            TypedQuery<Invoice> query = em.createQuery(
                    "SELECT i FROM Invoice i WHERE i.enrollment.id = :enrollmentId",
                    Invoice.class
            );
            query.setParameter("enrollmentId", enrollmentId);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public void save(EntityManager em, Enrollment enrollment) {
        if (enrollment.getId() == null) {
            em.persist(enrollment);
        } else {
            em.merge(enrollment);
        }
    }

    public void saveInvoice(EntityManager em, Invoice invoice) {
        if (invoice.getId() == null) {
            em.persist(invoice);
        } else {
            em.merge(invoice);
        }
    }
}
