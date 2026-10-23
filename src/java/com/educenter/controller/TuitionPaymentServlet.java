package com.educenter.controller;

import com.educenter.dto.*;
import com.educenter.entity.EduClass;
import com.educenter.service.PaymentService;
import com.educenter.service.PaymentServiceImpl;
import com.educenter.service.ValidationException;
import com.educenter.util.FlashMessageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TuitionPaymentServlet", urlPatterns = {
        "/staff/invoices",
        "/staff/invoices/detail",
        "/staff/invoices/payment",
        "/staff/invoices/receipt"
})
public class TuitionPaymentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TuitionPaymentServlet.class.getName());

    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        this.paymentService = new PaymentServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isStaff() && !user.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + path);
            return;
        }

        if ("/staff/invoices/detail".equals(path)) {
            handleInvoiceDetail(req, resp);
            return;
        }

        if ("/staff/invoices/receipt".equals(path)) {
            handlePaymentReceipt(req, resp);
            return;
        }

        handleInvoiceList(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        UserPrincipalDTO user = (session != null) ? (UserPrincipalDTO) session.getAttribute("currentUser") : null;

        if (user == null || (!user.isStaff() && !user.isAdmin())) {
            resp.sendRedirect(req.getContextPath() + "/login?redirect_url=" + path);
            return;
        }

        if ("/staff/invoices/payment".equals(path)) {
            handleRecordManualPayment(req, resp, user);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/staff/invoices");
    }

    private void handleInvoiceList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String classIdStr = req.getParameter("classId");
        String status = req.getParameter("status");
        String keyword = req.getParameter("keyword");
        String pageStr = req.getParameter("page");

        Long classId = null;
        if (classIdStr != null && !classIdStr.isBlank()) {
            try {
                classId = Long.parseLong(classIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        int page = 1;
        if (pageStr != null && !pageStr.isBlank()) {
            try {
                page = Integer.parseInt(pageStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        InvoicePageDTO pageData = paymentService.getInvoicesPaged(classId, status, keyword, page, 10);
        List<EduClass> classes = paymentService.getActiveClasses();

        req.setAttribute("pageData", pageData);
        req.setAttribute("classes", classes);
        req.setAttribute("selectedClassId", classId);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("keyword", keyword);
        req.setAttribute("activeNav", "invoices");

        req.getRequestDispatcher("/WEB-INF/views/staff/invoice-list.jsp").forward(req, resp);
    }

    private void handleInvoiceDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isBlank()) {
            FlashMessageUtil.setError(req, "Vui lòng chọn hóa đơn cần xem.");
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
            return;
        }

        try {
            Long invoiceId = Long.parseLong(idStr.trim());
            InvoiceDetailDTO invoice = paymentService.getInvoiceDetail(invoiceId);
            req.setAttribute("invoice", invoice);
            req.setAttribute("activeNav", "invoices");
            req.getRequestDispatcher("/WEB-INF/views/staff/invoice-detail.jsp").forward(req, resp);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã hóa đơn không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
        }
    }

    private void handlePaymentReceipt(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String paymentIdStr = req.getParameter("paymentId");
        if (paymentIdStr == null || paymentIdStr.isBlank()) {
            FlashMessageUtil.setError(req, "Vui lòng chọn phiếu thu cần in.");
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
            return;
        }

        try {
            Long paymentId = Long.parseLong(paymentIdStr.trim());
            ReceiptViewDTO receipt = paymentService.getPaymentReceipt(paymentId);
            req.setAttribute("receipt", receipt);
            req.getRequestDispatcher("/WEB-INF/views/staff/receipt.jsp").forward(req, resp);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
        } catch (NumberFormatException e) {
            FlashMessageUtil.setError(req, "Mã phiếu thu không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
        }
    }

    private void handleRecordManualPayment(HttpServletRequest req, HttpServletResponse resp, UserPrincipalDTO user)
            throws IOException {
        String invoiceIdStr = req.getParameter("invoiceId");
        String amountStr = req.getParameter("amount");
        String paymentMethod = req.getParameter("paymentMethod");
        String transactionRef = req.getParameter("transactionRef");
        String notes = req.getParameter("notes");

        Long invoiceId = null;
        try {
            if (invoiceIdStr != null && !invoiceIdStr.isBlank()) {
                invoiceId = Long.parseLong(invoiceIdStr.trim());
            }
        } catch (NumberFormatException ignored) {}

        if (invoiceId == null) {
            FlashMessageUtil.setError(req, "Mã hóa đơn không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/staff/invoices");
            return;
        }

        BigDecimal amount = null;
        if (amountStr != null && !amountStr.isBlank()) {
            try {
                // Hỗ trợ xóa dấu phân cách hàng ngàn nếu người dùng gõ kiểu 1.000.000 hoặc 1,000,000
                String cleanAmount = amountStr.replace(",", "").replace(".", "").replace(" ", "").trim();
                amount = new BigDecimal(cleanAmount);
            } catch (NumberFormatException e) {
                FlashMessageUtil.setError(req, "Số tiền nhập vào không đúng định dạng số.");
                resp.sendRedirect(req.getContextPath() + "/staff/invoices/detail?id=" + invoiceId);
                return;
            }
        }

        PaymentFormDTO form = new PaymentFormDTO();
        form.setInvoiceId(invoiceId);
        form.setAmount(amount);
        form.setPaymentMethod(paymentMethod);
        form.setTransactionRef(transactionRef != null ? transactionRef.trim() : null);
        form.setNotes(notes != null ? notes.trim() : null);

        try {
            PaymentRecordDTO record = paymentService.recordManualPayment(form, user.getUserId());
            FlashMessageUtil.setSuccess(req, "Xác nhận thu tiền thành công! Mã phiếu thu: " + record.getPaymentCode());
            resp.sendRedirect(req.getContextPath() + "/staff/invoices/detail?id=" + invoiceId);
        } catch (ValidationException e) {
            FlashMessageUtil.setError(req, e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/staff/invoices/detail?id=" + invoiceId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi không xác định khi thu tiền thủ công: " + e.getMessage(), e);
            FlashMessageUtil.setError(req, "Có lỗi xảy ra trong quá trình xử lý thu tiền. Vui lòng thử lại.");
            resp.sendRedirect(req.getContextPath() + "/staff/invoices/detail?id=" + invoiceId);
        }
    }
}
