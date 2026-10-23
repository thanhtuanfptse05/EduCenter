package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.EduClass;
import java.util.List;

public interface PaymentService {

    InvoicePageDTO getInvoicesPaged(Long classId, String status, String keyword, int page, int pageSize);

    InvoiceDetailDTO getInvoiceDetail(Long invoiceId);

    PaymentRecordDTO recordManualPayment(PaymentFormDTO form, Long actorUserId);

    ReceiptViewDTO getPaymentReceipt(Long paymentId);

    List<EduClass> getActiveClasses();
}
