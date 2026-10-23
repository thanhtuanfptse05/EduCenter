package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.EduClass;
import com.educenter.entity.Invoice;
import com.educenter.entity.Payment;
import com.educenter.entity.User;
import com.educenter.repository.PaymentRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PaymentServiceImpl implements PaymentService {

    private static final Logger LOGGER = Logger.getLogger(PaymentServiceImpl.class.getName());

    private final PaymentRepository paymentRepository;

    public PaymentServiceImpl() {
        this.paymentRepository = new PaymentRepository();
    }

    public PaymentServiceImpl(PaymentRepository paymentRepository) {
        this.paymentRepository = paymentRepository;
    }

    protected EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }

    @Override
    public InvoicePageDTO getInvoicesPaged(Long classId, String status, String keyword, int page, int pageSize) {
        EntityManager em = getEntityManager();
        try {
            int validPage = Math.max(1, page);
            int validPageSize = (pageSize <= 0) ? 10 : pageSize;

            List<InvoiceViewDTO> items = paymentRepository.findInvoices(em, classId, status, keyword, validPage, validPageSize);
            long totalItems = paymentRepository.countInvoices(em, classId, status, keyword);
            int totalPages = (int) Math.ceil((double) totalItems / validPageSize);
            if (totalPages == 0) totalPages = 1;

            Object[] stats = paymentRepository.getInvoiceStats(em);

            InvoicePageDTO pageDTO = new InvoicePageDTO();
            pageDTO.setItems(items);
            pageDTO.setCurrentPage(validPage);
            pageDTO.setPageSize(validPageSize);
            pageDTO.setTotalItems(totalItems);
            pageDTO.setTotalPages(totalPages);

            pageDTO.setTotalAmountSum((BigDecimal) stats[0]);
            pageDTO.setTotalPaidSum((BigDecimal) stats[1]);
            pageDTO.setTotalDebtSum((BigDecimal) stats[2]);
            pageDTO.setOverdueCount((Long) stats[3]);

            return pageDTO;
        } finally {
            em.close();
        }
    }

    @Override
    public InvoiceDetailDTO getInvoiceDetail(Long invoiceId) {
        if (invoiceId == null || invoiceId <= 0) {
            throw new ValidationException("Mã định danh hóa đơn không hợp lệ.");
        }

        EntityManager em = getEntityManager();
        try {
            Invoice inv = paymentRepository.findInvoiceById(em, invoiceId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy hóa đơn có ID: " + invoiceId));

            List<InvoiceItemViewDTO> items = paymentRepository.findItemsByInvoiceId(em, invoiceId);
            List<PaymentRecordDTO> payments = paymentRepository.findPaymentsByInvoiceId(em, invoiceId);

            BigDecimal paid = paymentRepository.calculateInvoicePaidAmount(em, invoiceId);
            BigDecimal debt = inv.getFinalAmount().subtract(paid);
            if (debt.compareTo(BigDecimal.ZERO) < 0) {
                debt = BigDecimal.ZERO;
            }

            LocalDate today = LocalDate.now();
            boolean isOverdue = inv.getDueDate().isBefore(today)
                    && !"PAID".equals(inv.getStatus())
                    && !"CANCELLED".equals(inv.getStatus());

            String[] guardianInfo = paymentRepository.findPrimaryGuardianInfo(em, inv.getStudent().getId());

            InvoiceDetailDTO dto = new InvoiceDetailDTO();
            dto.setId(inv.getId());
            dto.setInvoiceCode(inv.getInvoiceCode());
            dto.setEnrollmentId(inv.getEnrollment().getId());
            dto.setStudentId(inv.getStudent().getId());
            dto.setStudentCode(inv.getStudent().getCode());
            dto.setStudentName(inv.getStudent().getFullName());
            dto.setStudentPhone(inv.getStudent().getPhone());
            dto.setStudentEmail(inv.getStudent().getEmail());
            dto.setGuardianName(guardianInfo[0]);
            dto.setGuardianPhone(guardianInfo[1]);

            dto.setClassId(inv.getEnrollment().getEduClass().getId());
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
            dto.setNotes(inv.getNotes());
            dto.setCreatedAt(inv.getCreatedAt());
            dto.setUpdatedAt(inv.getUpdatedAt());

            dto.setItems(items);
            dto.setPayments(payments);

            return dto;
        } finally {
            em.close();
        }
    }

    @Override
    public PaymentRecordDTO recordManualPayment(PaymentFormDTO form, Long actorUserId) {
        if (form == null || form.getInvoiceId() == null) {
            throw new ValidationException("Dữ liệu thanh toán không hợp lệ.");
        }
        if (form.getAmount() == null || form.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException("Số tiền thu phải lớn hơn 0 đồng.");
        }
        String method = form.getPaymentMethod();
        if (method == null || (!"CASH".equalsIgnoreCase(method.trim()) && !"BANK_TRANSFER".equalsIgnoreCase(method.trim()))) {
            throw new ValidationException("Phương thức thanh toán chỉ chấp nhận Tiền mặt (CASH) hoặc Chuyển khoản (BANK_TRANSFER).");
        }
        method = method.trim().toUpperCase();

        if (actorUserId == null || actorUserId <= 0) {
            throw new ValidationException("Người thực hiện giao dịch thu tiền không hợp lệ.");
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            User actor = em.find(User.class, actorUserId);
            if (actor == null) {
                throw new ValidationException("Không tìm thấy thông tin nhân viên thu tiền.");
            }

            Invoice invoice = paymentRepository.findInvoiceById(em, form.getInvoiceId())
                    .orElseThrow(() -> new ValidationException("Không tìm thấy hóa đơn cần thu tiền."));

            if ("CANCELLED".equals(invoice.getStatus())) {
                throw new ValidationException("Hóa đơn đã bị hủy, không thể thu tiền.");
            }
            if ("PAID".equals(invoice.getStatus())) {
                throw new ValidationException("Hóa đơn đã được thanh toán đầy đủ trước đó.");
            }

            BigDecimal currentPaid = paymentRepository.calculateInvoicePaidAmount(em, invoice.getId());
            BigDecimal debt = invoice.getFinalAmount().subtract(currentPaid);
            if (debt.compareTo(BigDecimal.ZERO) <= 0) {
                throw new ValidationException("Hóa đơn không còn dư nợ để thu thêm.");
            }

            if (form.getAmount().compareTo(debt) > 0) {
                throw new ValidationException("Số tiền thu (" + form.getAmount().stripTrailingZeros().toPlainString() +
                        " đ) vượt quá số nợ còn lại (" + debt.stripTrailingZeros().toPlainString() + " đ).");
            }

            String datePart = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            String suffix = UUID.randomUUID().toString().substring(0, 5).toUpperCase();
            String paymentCode = "PAY-" + datePart + "-" + suffix;

            Payment payment = new Payment();
            payment.setPaymentCode(paymentCode);
            payment.setInvoice(invoice);
            payment.setAmount(form.getAmount());
            payment.setPaymentMethod(method);
            payment.setTransactionRef(form.getTransactionRef());
            payment.setPaidAt(LocalDateTime.now());
            payment.setConfirmedBy(actor);
            payment.setNotes(form.getNotes());
            payment.setStatus("CONFIRMED");
            payment.setCreatedAt(LocalDateTime.now());

            paymentRepository.savePayment(em, payment);

            BigDecimal newPaid = currentPaid.add(form.getAmount());
            if (newPaid.compareTo(invoice.getFinalAmount()) >= 0) {
                invoice.setStatus("PAID");
            } else {
                invoice.setStatus("PARTIALLY_PAID");
            }
            invoice.setUpdatedAt(LocalDateTime.now());
            paymentRepository.updateInvoice(em, invoice);

            tx.commit();

            PaymentRecordDTO dto = new PaymentRecordDTO();
            dto.setId(payment.getId());
            dto.setPaymentCode(payment.getPaymentCode());
            dto.setAmount(payment.getAmount());
            dto.setPaymentMethod(payment.getPaymentMethod());
            dto.setTransactionRef(payment.getTransactionRef());
            dto.setPaidAt(payment.getPaidAt());
            dto.setConfirmedById(actor.getId());
            dto.setConfirmedByName(actor.getFullName());
            dto.setNotes(payment.getNotes());
            dto.setStatus(payment.getStatus());

            LOGGER.info("Recorded manual payment: " + paymentCode + " for invoice: " + invoice.getInvoiceCode() + " by staff: " + actor.getEmail());
            return dto;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            if (e instanceof ValidationException) {
                throw (ValidationException) e;
            }
            LOGGER.log(Level.SEVERE, "Error recording manual payment: " + e.getMessage(), e);
            throw new ValidationException("Lỗi hệ thống khi ghi nhận phiếu thu: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public ReceiptViewDTO getPaymentReceipt(Long paymentId) {
        if (paymentId == null || paymentId <= 0) {
            throw new ValidationException("Mã phiếu thu không hợp lệ.");
        }

        EntityManager em = getEntityManager();
        try {
            Payment p = paymentRepository.findPaymentById(em, paymentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy phiếu thu có ID: " + paymentId));

            Invoice inv = p.getInvoice();
            BigDecimal totalPaid = paymentRepository.calculateInvoicePaidAmount(em, inv.getId());
            BigDecimal debt = inv.getFinalAmount().subtract(totalPaid);
            if (debt.compareTo(BigDecimal.ZERO) < 0) {
                debt = BigDecimal.ZERO;
            }

            String[] guardianInfo = paymentRepository.findPrimaryGuardianInfo(em, inv.getStudent().getId());

            ReceiptViewDTO dto = new ReceiptViewDTO();
            dto.setPaymentId(p.getId());
            dto.setPaymentCode(p.getPaymentCode());
            dto.setPaidAt(p.getPaidAt());
            dto.setPaymentMethod(p.getPaymentMethod());
            dto.setTransactionRef(p.getTransactionRef());
            dto.setCashierName(p.getConfirmedBy() != null ? p.getConfirmedBy().getFullName() : "Nhân viên thu ngân");
            dto.setNotes(p.getNotes());

            dto.setInvoiceId(inv.getId());
            dto.setInvoiceCode(inv.getInvoiceCode());
            dto.setStudentCode(inv.getStudent().getCode());
            dto.setStudentName(inv.getStudent().getFullName());
            dto.setStudentPhone(inv.getStudent().getPhone());
            dto.setStudentEmail(inv.getStudent().getEmail());
            dto.setGuardianName(guardianInfo[0]);
            dto.setGuardianPhone(guardianInfo[1]);

            dto.setClassCode(inv.getEnrollment().getEduClass().getCode());
            dto.setClassName(inv.getEnrollment().getEduClass().getName());

            dto.setInvoiceFinalAmount(inv.getFinalAmount());
            dto.setPaymentAmount(p.getAmount());
            dto.setTotalPaidAmount(totalPaid);
            dto.setRemainingDebtAmount(debt);
            dto.setInvoiceStatus(inv.getStatus());

            return dto;
        } finally {
            em.close();
        }
    }

    @Override
    public List<EduClass> getActiveClasses() {
        EntityManager em = getEntityManager();
        try {
            return paymentRepository.findAllActiveClasses(em);
        } finally {
            em.close();
        }
    }
}
