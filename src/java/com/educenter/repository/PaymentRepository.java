package com.educenter.repository;

import com.educenter.dto.InvoiceItemViewDTO;
import com.educenter.dto.InvoiceViewDTO;
import com.educenter.dto.PaymentRecordDTO;
import com.educenter.entity.EduClass;
import com.educenter.entity.Invoice;
import com.educenter.entity.InvoiceItem;
import com.educenter.entity.Payment;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class PaymentRepository {

    public List<InvoiceViewDTO> findInvoices(EntityManager em, Long classId, String status, String keyword, int page, int pageSize) {
        StringBuilder jpql = new StringBuilder(
                "SELECT i, (SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.invoice.id = i.id AND p.status = 'CONFIRMED') " +
                "FROM Invoice i " +
                "JOIN FETCH i.student s " +
                "JOIN FETCH i.enrollment e " +
                "JOIN FETCH e.eduClass c " +
                "WHERE 1=1 "
        );

        appendFilters(jpql, classId, status, keyword);
        jpql.append("ORDER BY i.createdAt DESC");

        TypedQuery<Object[]> query = em.createQuery(jpql.toString(), Object[].class);
        setParameters(query, classId, status, keyword);

        query.setFirstResult((page - 1) * pageSize);
        query.setMaxResults(pageSize);

        List<Object[]> rows = query.getResultList();
        List<InvoiceViewDTO> list = new ArrayList<>();
        LocalDate today = LocalDate.now();

        for (Object[] row : rows) {
            Invoice inv = (Invoice) row[0];
            BigDecimal paid = (BigDecimal) row[1];
            if (paid == null) paid = BigDecimal.ZERO;

            BigDecimal debt = inv.getFinalAmount().subtract(paid);
            if (debt.compareTo(BigDecimal.ZERO) < 0) {
                debt = BigDecimal.ZERO;
            }

            boolean isOverdue = inv.getDueDate().isBefore(today)
                    && !"PAID".equals(inv.getStatus())
                    && !"CANCELLED".equals(inv.getStatus());

            InvoiceViewDTO dto = new InvoiceViewDTO();
            dto.setId(inv.getId());
            dto.setInvoiceCode(inv.getInvoiceCode());
            dto.setStudentCode(inv.getStudent().getCode());
            dto.setStudentName(inv.getStudent().getFullName());
            dto.setStudentPhone(inv.getStudent().getPhone());
            dto.setClassCode(inv.getEnrollment().getEduClass().getCode());
            dto.setClassName(inv.getEnrollment().getEduClass().getName());
            dto.setTotalAmount(inv.getTotalAmount());
            dto.setDiscountAmount(inv.getDiscountAmount());
            dto.setFinalAmount(inv.getFinalAmount());
            dto.setPaidAmount(paid);
            dto.setDebtAmount(debt);
            dto.setDueDate(inv.getDueDate());
            dto.setStatus(inv.getStatus());
            dto.setOverdue(isOverdue);
            dto.setCreatedAt(inv.getCreatedAt());

            list.add(dto);
        }
        return list;
    }

    public long countInvoices(EntityManager em, Long classId, String status, String keyword) {
        StringBuilder jpql = new StringBuilder(
                "SELECT COUNT(i) FROM Invoice i " +
                "JOIN i.student s " +
                "JOIN i.enrollment e " +
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
        if (status != null && !status.trim().isEmpty()) {
            if ("OVERDUE".equalsIgnoreCase(status.trim())) {
                jpql.append("AND i.dueDate < CURRENT_DATE AND i.status NOT IN ('PAID', 'CANCELLED') ");
            } else {
                jpql.append("AND i.status = :status ");
            }
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            jpql.append("AND (LOWER(s.fullName) LIKE :keyword OR LOWER(s.code) LIKE :keyword OR LOWER(s.phone) LIKE :keyword OR LOWER(i.invoiceCode) LIKE :keyword) ");
        }
    }

    private void setParameters(TypedQuery<?> query, Long classId, String status, String keyword) {
        if (classId != null && classId > 0) {
            query.setParameter("classId", classId);
        }
        if (status != null && !status.trim().isEmpty() && !"OVERDUE".equalsIgnoreCase(status.trim())) {
            query.setParameter("status", status.trim().toUpperCase());
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
        }
    }

    public Optional<Invoice> findInvoiceById(EntityManager em, Long invoiceId) {
        try {
            Invoice inv = em.createQuery(
                    "SELECT i FROM Invoice i " +
                    "JOIN FETCH i.student s " +
                    "JOIN FETCH i.enrollment e " +
                    "JOIN FETCH e.eduClass c " +
                    "WHERE i.id = :id", Invoice.class)
                    .setParameter("id", invoiceId)
                    .getSingleResult();
            return Optional.of(inv);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<InvoiceItemViewDTO> findItemsByInvoiceId(EntityManager em, Long invoiceId) {
        List<InvoiceItem> items = em.createQuery(
                "SELECT it FROM InvoiceItem it WHERE it.invoice.id = :invoiceId ORDER BY it.id ASC",
                InvoiceItem.class)
                .setParameter("invoiceId", invoiceId)
                .getResultList();

        List<InvoiceItemViewDTO> dtoList = new ArrayList<>();
        for (InvoiceItem it : items) {
            InvoiceItemViewDTO dto = new InvoiceItemViewDTO();
            dto.setId(it.getId());
            dto.setDescription(it.getDescription());
            dto.setUnitPrice(it.getUnitPrice());
            dto.setQuantity(it.getQuantity());
            dto.setAmount(it.getAmount());
            dtoList.add(dto);
        }
        return dtoList;
    }

    public List<PaymentRecordDTO> findPaymentsByInvoiceId(EntityManager em, Long invoiceId) {
        List<Payment> payments = em.createQuery(
                "SELECT p FROM Payment p " +
                "JOIN FETCH p.confirmedBy u " +
                "WHERE p.invoice.id = :invoiceId " +
                "ORDER BY p.paidAt DESC", Payment.class)
                .setParameter("invoiceId", invoiceId)
                .getResultList();

        List<PaymentRecordDTO> dtoList = new ArrayList<>();
        for (Payment p : payments) {
            PaymentRecordDTO dto = new PaymentRecordDTO();
            dto.setId(p.getId());
            dto.setPaymentCode(p.getPaymentCode());
            dto.setAmount(p.getAmount());
            dto.setPaymentMethod(p.getPaymentMethod());
            dto.setTransactionRef(p.getTransactionRef());
            dto.setPaidAt(p.getPaidAt());
            dto.setConfirmedById(p.getConfirmedBy().getId());
            dto.setConfirmedByName(p.getConfirmedBy().getFullName());
            dto.setNotes(p.getNotes());
            dto.setStatus(p.getStatus());
            dtoList.add(dto);
        }
        return dtoList;
    }

    public Optional<Payment> findPaymentById(EntityManager em, Long paymentId) {
        try {
            Payment p = em.createQuery(
                    "SELECT p FROM Payment p " +
                    "JOIN FETCH p.invoice i " +
                    "JOIN FETCH i.student s " +
                    "JOIN FETCH i.enrollment e " +
                    "JOIN FETCH e.eduClass c " +
                    "JOIN FETCH p.confirmedBy u " +
                    "WHERE p.id = :id", Payment.class)
                    .setParameter("id", paymentId)
                    .getSingleResult();
            return Optional.of(p);
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public BigDecimal calculateInvoicePaidAmount(EntityManager em, Long invoiceId) {
        BigDecimal sum = em.createQuery(
                "SELECT COALESCE(SUM(p.amount), 0) FROM Payment p " +
                "WHERE p.invoice.id = :invoiceId AND p.status = 'CONFIRMED'", BigDecimal.class)
                .setParameter("invoiceId", invoiceId)
                .getSingleResult();
        return sum != null ? sum : BigDecimal.ZERO;
    }

    public Object[] getInvoiceStats(EntityManager em) {
        BigDecimal totalFinal = em.createQuery(
                "SELECT COALESCE(SUM(i.finalAmount), 0) FROM Invoice i WHERE i.status != 'CANCELLED'",
                BigDecimal.class).getSingleResult();

        BigDecimal totalPaid = em.createQuery(
                "SELECT COALESCE(SUM(p.amount), 0) FROM Payment p WHERE p.status = 'CONFIRMED'",
                BigDecimal.class).getSingleResult();

        Long overdueCount = em.createQuery(
                "SELECT COUNT(i) FROM Invoice i " +
                "WHERE i.dueDate < CURRENT_DATE AND i.status NOT IN ('PAID', 'CANCELLED')",
                Long.class).getSingleResult();

        if (totalFinal == null) totalFinal = BigDecimal.ZERO;
        if (totalPaid == null) totalPaid = BigDecimal.ZERO;
        if (overdueCount == null) overdueCount = 0L;

        BigDecimal totalDebt = totalFinal.subtract(totalPaid);
        if (totalDebt.compareTo(BigDecimal.ZERO) < 0) totalDebt = BigDecimal.ZERO;

        return new Object[] { totalFinal, totalPaid, totalDebt, overdueCount };
    }

    public void savePayment(EntityManager em, Payment payment) {
        em.persist(payment);
    }

    public void updateInvoice(EntityManager em, Invoice invoice) {
        em.merge(invoice);
    }

    public List<EduClass> findAllActiveClasses(EntityManager em) {
        return em.createQuery("SELECT c FROM EduClass c ORDER BY c.code ASC", EduClass.class)
                .getResultList();
    }

    public String[] findPrimaryGuardianInfo(EntityManager em, Long studentId) {
        try {
            Object[] row = em.createQuery(
                    "SELECT g.fullName, g.phone FROM StudentGuardian sg " +
                    "JOIN sg.guardian g " +
                    "WHERE sg.student.id = :studentId " +
                    "ORDER BY sg.isPrimary DESC", Object[].class)
                    .setParameter("studentId", studentId)
                    .setMaxResults(1)
                    .getSingleResult();
            return new String[] { (String) row[0], (String) row[1] };
        } catch (NoResultException e) {
            return new String[] { null, null };
        }
    }

    public boolean existsByTransactionRef(EntityManager em, String transactionRef) {
        if (transactionRef == null || transactionRef.trim().isEmpty()) {
            return false;
        }
        Long count = em.createQuery(
                "SELECT COUNT(p) FROM Payment p WHERE LOWER(p.transactionRef) = :ref", Long.class)
                .setParameter("ref", transactionRef.trim().toLowerCase())
                .getSingleResult();
        return count != null && count > 0;
    }

    public boolean existsRecentDuplicatePayment(EntityManager em, Long invoiceId, BigDecimal amount, Long actorId) {
        LocalDateTime recentThreshold = LocalDateTime.now().minusSeconds(15);
        Long count = em.createQuery(
                "SELECT COUNT(p) FROM Payment p WHERE p.invoice.id = :invoiceId AND p.amount = :amount AND p.confirmedBy.id = :actorId AND p.paidAt >= :threshold", Long.class)
                .setParameter("invoiceId", invoiceId)
                .setParameter("amount", amount)
                .setParameter("actorId", actorId)
                .setParameter("threshold", recentThreshold)
                .getSingleResult();
        return count != null && count > 0;
    }
}
