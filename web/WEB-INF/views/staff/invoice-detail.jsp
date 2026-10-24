<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
    <style>
        .badge-unpaid { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; }
        .badge-partially { background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; }
        .badge-paid { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .badge-cancelled { background: #f1f5f9; color: #64748b; border: 1px solid #e2e8f0; }
        .badge-overdue { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; font-weight: 600; font-size: 0.75rem; padding: 2px 6px; border-radius: 4px; }
        .invoice-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 24px; }
        @media (max-width: 992px) { .invoice-grid { grid-template-columns: 1fr; } }
        .info-label { font-size: 0.8125rem; color: var(--text-muted); font-weight: 500; margin-bottom: 2px; }
        .info-value { font-size: 0.9375rem; color: var(--text); font-weight: 600; }
        .payment-box { background: #f8fafc; border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px; }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="invoices" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & Khách hàng / Chi tiết hóa đơn ${invoice.invoiceCode}" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/staff/invoices" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Quay lại danh sách</span>
                    </a>
                    <div>
                        <h1 class="page-title" style="margin: 0; font-size: 1.5rem;">
                            Hóa đơn <code><c:out value="${invoice.invoiceCode}" /></code>
                        </h1>
                        <span style="font-size: 0.85rem; color: var(--text-muted);">
                            Khởi tạo ngày: <c:out value="${invoice.createdAt}" />
                        </span>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <c:choose>
                        <c:when test="${invoice.status == 'PAID'}">
                            <span class="badge badge-paid" style="font-size: 0.875rem; padding: 6px 12px;">Đã thanh toán đủ</span>
                        </c:when>
                        <c:when test="${invoice.status == 'PARTIALLY_PAID'}">
                            <span class="badge badge-partially" style="font-size: 0.875rem; padding: 6px 12px;">Đóng một phần</span>
                        </c:when>
                        <c:when test="${invoice.status == 'CANCELLED'}">
                            <span class="badge badge-cancelled" style="font-size: 0.875rem; padding: 6px 12px;">Đã hủy</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-unpaid" style="font-size: 0.875rem; padding: 6px 12px;">Chưa thanh toán</span>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${invoice.overdue}">
                        <span class="badge-overdue" style="font-size: 0.875rem; padding: 6px 12px;">Quá hạn nộp</span>
                    </c:if>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <div class="invoice-grid">
                <!-- Cột trái: Thông tin học viên, khoản mục và lịch sử thanh toán -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <!-- Thông tin đối tượng -->
                    <div class="admin-card">
                        <h3 style="font-size: 1rem; font-weight: 600; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 8px; color: var(--primary);">
                            Thông tin Học viên & Lớp học
                        </h3>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                            <div>
                                <div class="info-label">Họ tên học viên:</div>
                                <div class="info-value"><c:out value="${invoice.studentName}" /></div>
                                <div style="font-size: 0.8rem; color: var(--text-muted);">Mã: <code><c:out value="${invoice.studentCode}" /></code></div>
                            </div>
                            <div>
                                <div class="info-label">Số điện thoại / Email:</div>
                                <div class="info-value"><c:out value="${invoice.studentPhone}" /></div>
                                <div style="font-size: 0.8rem; color: var(--text-muted);"><c:out value="${invoice.studentEmail}" /></div>
                            </div>
                            <div>
                                <div class="info-label">Phụ huynh bảo hộ:</div>
                                <div class="info-value">
                                    <c:out value="${not empty invoice.guardianName ? invoice.guardianName : 'Chưa cập nhật'}" />
                                </div>
                                <c:if test="${not empty invoice.guardianPhone}">
                                    <div style="font-size: 0.8rem; color: var(--text-muted);">SĐT: <c:out value="${invoice.guardianPhone}" /></div>
                                </c:if>
                            </div>
                            <div>
                                <div class="info-label">Lớp học ghi danh:</div>
                                <div class="info-value"><c:out value="${invoice.className}" /></div>
                                <div style="font-size: 0.8rem; color: var(--text-muted);">Mã lớp: <code><c:out value="${invoice.classCode}" /></code></div>
                            </div>
                        </div>
                    </div>

                    <!-- Bảng các khoản mục học phí -->
                    <div class="admin-card">
                        <h3 style="font-size: 1rem; font-weight: 600; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">
                            Chi tiết Khoản mục Hóa đơn
                        </h3>
                        <div class="table-responsive">
                            <table class="table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="width: 48px; text-align: center;">#</th>
                                    <th>Nội dung thu</th>
                                    <th style="text-align: right; width: 140px;">Đơn giá</th>
                                    <th style="text-align: center; width: 80px;">SL</th>
                                    <th style="text-align: right; width: 150px;">Thành tiền</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="it" items="${invoice.items}" varStatus="loop">
                                    <tr>
                                        <td style="text-align: center; color: var(--text-muted);">${loop.count}</td>
                                        <td style="font-weight: 500;"><c:out value="${it.description}" /></td>
                                        <td style="text-align: right;">
                                            <fmt:formatNumber value="${it.unitPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td style="text-align: center;">${it.quantity}</td>
                                        <td style="text-align: right; font-weight: 600;">
                                            <fmt:formatNumber value="${it.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border); display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                            <div style="display: flex; justify-content: space-between; width: 260px; font-size: 0.9375rem;">
                                <span style="color: var(--text-muted);">Tổng tiền gốc:</span>
                                <span style="font-weight: 600;">
                                    <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </div>
                            <div style="display: flex; justify-content: space-between; width: 260px; font-size: 0.9375rem;">
                                <span style="color: var(--text-muted);">Miễn giảm / Học bổng:</span>
                                <span style="color: #16a34a; font-weight: 600;">
                                    - <fmt:formatNumber value="${invoice.discountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </div>
                            <div style="display: flex; justify-content: space-between; width: 260px; font-size: 1.125rem; font-weight: 700; color: var(--primary); padding-top: 8px; border-top: 1px dashed var(--border);">
                                <span>Phải thanh toán:</span>
                                <span>
                                    <fmt:formatNumber value="${invoice.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Lịch sử các phiếu thu đã xác nhận -->
                    <div class="admin-card">
                        <h3 style="font-size: 1rem; font-weight: 600; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">
                            Lịch sử Thu tiền & Phiếu thu
                        </h3>
                        <c:choose>
                            <c:when test="${not empty invoice.payments}">
                                <div class="table-responsive">
                                    <table class="table" style="width: 100%; border-collapse: collapse;">
                                        <thead>
                                        <tr>
                                            <th>Mã phiếu thu</th>
                                            <th>Thời gian thu</th>
                                            <th>Hình thức</th>
                                            <th>Mã GD tham chiếu</th>
                                            <th>Người thu tiền</th>
                                            <th style="text-align: right;">Số tiền thu</th>
                                            <th style="text-align: right; width: 110px;">Biên lai</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="p" items="${invoice.payments}">
                                            <tr>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--primary);">
                                                        <code><c:out value="${p.paymentCode}" /></code>
                                                    </span>
                                                </td>
                                                <td><c:out value="${p.paidAt}" /></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.paymentMethod == 'CASH'}">
                                                            <span style="display: inline-flex; align-items: center; gap: 4px; color: #16a34a; font-weight: 500;">
                                                                Tiền mặt tại quầy
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${p.paymentMethod == 'BANK_TRANSFER'}">
                                                            <span style="display: inline-flex; align-items: center; gap: 4px; color: #0284c7; font-weight: 500;">
                                                                Chuyển khoản NH
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:out value="${p.paymentMethod}" />
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:out value="${not empty p.transactionRef ? p.transactionRef : '-'}" />
                                                </td>
                                                <td><c:out value="${p.confirmedByName}" /></td>
                                                <td style="text-align: right; font-weight: 700; color: #16a34a;">
                                                    + <fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/staff/invoices/receipt?paymentId=${p.id}" target="_blank" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <polyline points="6 9 6 2 18 2 18 9"></polyline>
                                                            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                                                            <rect width="12" height="8" x="6" y="14"></rect>
                                                        </svg>
                                                        <span>In biên lai</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 24px; color: var(--text-muted); font-size: 0.9rem;">
                                    Chưa có giao dịch thu tiền nào cho hóa đơn này.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Cột phải: Hộp công nợ & Form DUYỆT TAY THU TIỀN THỦ CÔNG (ADM-15) -->
                <div>
                    <!-- Hộp tổng quan công nợ -->
                    <div class="admin-card" style="margin-bottom: 20px;">
                        <h3 style="font-size: 1rem; font-weight: 600; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">
                            Tổng hợp Công nợ
                        </h3>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div style="display: flex; justify-content: space-between; font-size: 0.9375rem;">
                                <span style="color: var(--text-muted);">Phải đóng:</span>
                                <span style="font-weight: 600;">
                                    <fmt:formatNumber value="${invoice.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 0.9375rem;">
                                <span style="color: var(--text-muted);">Đã nộp:</span>
                                <span style="color: #16a34a; font-weight: 600;">
                                    <fmt:formatNumber value="${invoice.paidAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 1.125rem; font-weight: 700; padding-top: 10px; border-top: 1px solid var(--border);">
                                <span style="color: ${invoice.debtAmount > 0 ? '#ea580c' : 'var(--text-muted)'};">Số nợ còn lại:</span>
                                <span style="color: ${invoice.debtAmount > 0 ? '#ea580c' : '#16a34a'};">
                                    <fmt:formatNumber value="${invoice.debtAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 0.875rem; color: var(--text-muted); padding-top: 4px;">
                                <span>Hạn chót thanh toán:</span>
                                <span style="font-weight: 500;"><c:out value="${invoice.dueDate}" /></span>
                            </div>
                        </div>
                    </div>

                    <!-- Hộp Form Thu tiền duyệt tay thủ công -->
                    <div class="admin-card" style="border: 2px solid ${invoice.debtAmount > 0 ? 'var(--primary)' : 'var(--border)'};">
                        <h3 style="font-size: 1.0625rem; font-weight: 700; margin-bottom: 12px; display: flex; align-items: center; gap: 8px; color: var(--primary);">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                <line x1="2" x2="22" y1="10" y2="10"></line>
                            </svg>
                            <span>Duyệt thu tiền thủ công (ADM-15)</span>
                        </h3>

                        <c:choose>
                            <c:when test="${invoice.status == 'CANCELLED'}">
                                <div style="padding: 16px; background: #fef2f2; border: 1px solid #fee2e2; border-radius: var(--radius-sm); color: #991b1b; font-size: 0.875rem;">
                                    Hóa đơn này đã bị hủy bỏ. Không thể tiến hành ghi nhận thu tiền.
                                </div>
                            </c:when>
                            <c:when test="${invoice.debtAmount <= 0 || invoice.status == 'PAID'}">
                                <div style="padding: 16px; background: #f0fdf4; border: 1px solid #dcfce7; border-radius: var(--radius-sm); color: #166534; font-size: 0.875rem; text-align: center;">
                                    <div style="font-weight: 700; margin-bottom: 4px;">Hóa đơn đã hoàn thành!</div>
                                    Học viên đã nộp đủ toàn bộ học phí. Không còn công nợ cần thu thêm.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/staff/invoices/payment" method="post" id="manualPaymentForm" onsubmit="return confirmPaymentSubmit();">
                                    <input type="hidden" name="invoiceId" value="${invoice.id}">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                                    <div class="form-group" style="margin-bottom: 16px;">
                                        <label class="form-label" style="font-weight: 600;">
                                            Số tiền thu đợt này (VNĐ) <span style="color: #dc2626;">*</span>
                                        </label>
                                        <div style="position: relative;">
                                            <input type="number" id="payAmountInput" name="amount" class="form-control"
                                                   style="font-size: 1.125rem; font-weight: 700; color: var(--primary);"
                                                   min="1000" max="${invoice.debtAmount}" step="1000"
                                                   value="${invoice.debtAmount}" required>
                                            <div style="display: flex; gap: 8px; margin-top: 6px;">
                                                <button type="button" class="btn btn-ghost btn-sm" onclick="setPayAmount(${invoice.debtAmount});" style="font-size: 0.75rem; padding: 2px 8px;">
                                                    Đóng hết (${invoice.debtAmount.toPlainString()} đ)
                                                </button>
                                                <c:if test="${invoice.debtAmount >= 1000000}">
                                                    <button type="button" class="btn btn-ghost btn-sm" onclick="setPayAmount(1000000);" style="font-size: 0.75rem; padding: 2px 8px;">
                                                        Đóng 1.000.000 đ
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group" style="margin-bottom: 16px;">
                                        <label class="form-label" style="font-weight: 600;">
                                            Phương thức thanh toán <span style="color: #dc2626;">*</span>
                                        </label>
                                        <div style="display: flex; flex-direction: column; gap: 8px;">
                                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 8px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg);">
                                                <input type="radio" name="paymentMethod" value="CASH" checked onchange="toggleRefInput(false);">
                                                <span style="font-weight: 600;">Tiền mặt tại quầy (CASH)</span>
                                            </label>
                                            <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 8px 12px; border: 1px solid var(--border); border-radius: var(--radius-sm); background: var(--bg);">
                                                <input type="radio" name="paymentMethod" value="BANK_TRANSFER" onchange="toggleRefInput(true);">
                                                <span style="font-weight: 600;">Chuyển khoản ngân hàng (BANK_TRANSFER)</span>
                                            </label>
                                        </div>
                                    </div>

                                    <div class="form-group" id="refGroup" style="margin-bottom: 16px; display: none;">
                                        <label class="form-label" style="font-weight: 600;">
                                            Mã giao dịch / Mã chuẩn chi ngân hàng
                                        </label>
                                        <input type="text" name="transactionRef" id="transactionRefInput" class="form-control" placeholder="VD: MB-261024-9988 hoặc FT2410...">
                                        <small style="color: var(--text-muted); font-size: 0.75rem;">Nhập mã giao dịch để dễ dàng đối soát với sao kê tài khoản ngân hàng</small>
                                    </div>

                                    <div class="form-group" style="margin-bottom: 20px;">
                                        <label class="form-label" style="font-weight: 500;">Ghi chú phiếu thu</label>
                                        <textarea name="notes" class="form-control" rows="2" placeholder="Ghi chú chi tiết đợt nộp tiền (nếu có)..."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <polyline points="20 6 9 17 4 12"></polyline>
                                        </svg>
                                        <span>Xác nhận thu tiền & Xuất biên lai</span>
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function setPayAmount(amount) {
    document.getElementById('payAmountInput').value = amount;
}

function toggleRefInput(show) {
    var refGroup = document.getElementById('refGroup');
    if (refGroup) {
        refGroup.style.display = show ? 'block' : 'none';
        if (show) {
            document.getElementById('transactionRefInput').focus();
        }
    }
}

function confirmPaymentSubmit() {
    var amount = document.getElementById('payAmountInput').value;
    var maxDebt = ${invoice.debtAmount != null ? invoice.debtAmount : 0};
    if (!amount || amount <= 0) {
        alert('Vui lòng nhập số tiền thu lớn hơn 0 đồng!');
        return false;
    }
    if (parseFloat(amount) > parseFloat(maxDebt)) {
        alert('Số tiền thu không được vượt quá số nợ còn lại (' + maxDebt + ' đ)!');
        return false;
    }

    var method = document.querySelector('input[name="paymentMethod"]:checked').value;
    var methodLabel = method === 'CASH' ? 'Tiền mặt' : 'Chuyển khoản';

    return confirm('XÁC NHẬN DUYỆT THU TIỀN THỦ CÔNG:\n\n' +
        '- Số tiền thu: ' + Number(amount).toLocaleString('vi-VN') + ' VNĐ\n' +
        '- Hình thức: ' + methodLabel + '\n\n' +
        'Bạn có chắc chắn muốn ghi nhận giao dịch thu tiền này vào hệ thống?');
}
</script>
</body>
</html>
