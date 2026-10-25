<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biên lai thu học phí - <c:out value="${receipt.paymentCode}" /></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #0284c7;
            --text: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --bg: #f8fafc;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text);
            line-height: 1.5;
            padding: 24px;
        }
        .action-bar {
            max-width: 780px;
            margin: 0 auto 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            border: 1px solid transparent;
        }
        .btn-primary { background: var(--primary); color: #fff; }
        .btn-secondary { background: #fff; border-color: var(--border); color: var(--text); }
        .receipt-card {
            max-width: 780px;
            margin: 0 auto;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 36px 40px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05);
        }
        .center-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid var(--primary);
            padding-bottom: 16px;
            margin-bottom: 24px;
        }
        .brand-name { font-size: 1.25rem; font-weight: 700; color: var(--primary); text-transform: uppercase; }
        .center-info { font-size: 0.8125rem; color: var(--text-muted); margin-top: 4px; }
        .receipt-title {
            text-align: center;
            margin-bottom: 24px;
        }
        .receipt-title h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .receipt-meta {
            display: flex;
            justify-content: center;
            gap: 24px;
            font-size: 0.875rem;
            color: var(--text-muted);
            margin-top: 4px;
        }
        .receipt-section {
            margin-bottom: 20px;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9375rem;
        }
        .info-table td {
            padding: 6px 0;
            vertical-align: top;
        }
        .info-table td.label {
            width: 180px;
            color: var(--text-muted);
            font-weight: 500;
        }
        .info-table td.value {
            font-weight: 600;
            color: var(--text);
        }
        .payment-highlight {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 6px;
            padding: 16px 20px;
            margin: 20px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .amount-big {
            font-size: 1.5rem;
            font-weight: 700;
            color: #16a34a;
        }
        .signatures {
            display: grid;
            grid-template-columns: 1fr 1fr;
            margin-top: 48px;
            text-align: center;
        }
        .sig-title { font-weight: 600; font-size: 0.9375rem; margin-bottom: 4px; }
        .sig-sub { font-size: 0.8125rem; color: var(--text-muted); font-style: italic; }
        .sig-name { margin-top: 60px; font-weight: 600; font-size: 0.9375rem; }

        @media print {
            body { background: #fff; padding: 0; }
            .action-bar { display: none !important; }
            .receipt-card { border: none; box-shadow: none; padding: 0; }
        }
    </style>
</head>
<body>

<div class="action-bar">
    <a href="${pageContext.request.contextPath}/staff/invoices/detail?id=${receipt.invoiceId}" class="btn btn-secondary">
        &larr; Quay lại chi tiết hóa đơn
    </a>
    <div style="display: flex; gap: 8px;">
        <a href="${pageContext.request.contextPath}/staff/enrollments?<c:if test='${not empty returnStudentId}'>studentId=${returnStudentId}&</c:if><c:if test='${not empty param.studentId}'>studentId=${param.studentId}&</c:if><c:if test='${not empty returnLeadId}'>leadId=${returnLeadId}&</c:if><c:if test='${not empty param.leadId}'>leadId=${param.leadId}&</c:if>paid=1" 
           class="btn btn-secondary" style="border-color: #16a34a; color: #16a34a; font-weight: 600;">
            <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 14 4 9 9 4"></polyline><path d="M20 20v-7a4 4 0 0 0-4-4H4"></path></svg>
            <span>Quay lại Ghi danh & Xếp lớp</span>
        </a>
        <button onclick="window.print();" class="btn btn-primary">
            In biên lai / Lưu PDF
        </button>
    </div>
</div>

<div class="receipt-card">
    <div class="center-header">
        <div>
            <div class="brand-name">Hệ thống Đào tạo & Bồi dưỡng Văn hóa EduCenter</div>
            <div class="center-info">Cơ sở: Trung tâm Luyện thi & Bồi dưỡng Kiến thức Lớp 6–12</div>
            <div class="center-info">Hotline: 1900-EDUVN • Website: educenter.edu.vn</div>
        </div>
        <div style="text-align: right;">
            <div style="font-weight: 600; font-size: 0.875rem;">Mã phiếu thu:</div>
            <div style="font-size: 1.125rem; font-weight: 700; color: var(--primary);">
                <code><c:out value="${receipt.paymentCode}" /></code>
            </div>
        </div>
    </div>

    <div class="receipt-title">
        <h1>Biên lai thu học phí</h1>
        <div class="receipt-meta">
            <span>Ngày thu: <strong><c:out value="${receipt.paidAt}" /></strong></span>
            <span>Mã HĐ tham chiếu: <strong><code><c:out value="${receipt.invoiceCode}" /></code></strong></span>
        </div>
    </div>

    <div class="receipt-section">
        <table class="info-table">
            <tr>
                <td class="label">Họ tên học viên:</td>
                <td class="value"><c:out value="${receipt.studentName}" /> (Mã: <code><c:out value="${receipt.studentCode}" /></code>)</td>
            </tr>
            <tr>
                <td class="label">Số điện thoại / Email:</td>
                <td class="value"><c:out value="${receipt.studentPhone}" /> <c:if test="${not empty receipt.studentEmail}"> • <c:out value="${receipt.studentEmail}" /></c:if></td>
            </tr>
            <c:if test="${not empty receipt.guardianName}">
                <tr>
                    <td class="label">Phụ huynh nộp tiền:</td>
                    <td class="value"><c:out value="${receipt.guardianName}" /> <c:if test="${not empty receipt.guardianPhone}"> (SĐT: <c:out value="${receipt.guardianPhone}" />)</c:if></td>
                </tr>
            </c:if>
            <tr>
                <td class="label">Lớp học ghi danh:</td>
                <td class="value"><c:out value="${receipt.className}" /> (Mã lớp: <code><c:out value="${receipt.classCode}" /></code>)</td>
            </tr>
            <tr>
                <td class="label">Phương thức thanh toán:</td>
                <td class="value">
                    <c:choose>
                        <c:when test="${receipt.paymentMethod == 'CASH'}">
                            Tiền mặt tại quầy (CASH)
                        </c:when>
                        <c:when test="${receipt.paymentMethod == 'BANK_TRANSFER'}">
                            Chuyển khoản ngân hàng (BANK_TRANSFER)
                            <c:if test="${not empty receipt.transactionRef}">
                                • Mã GD: <code><c:out value="${receipt.transactionRef}" /></code>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <c:out value="${receipt.paymentMethod}" />
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <c:if test="${not empty receipt.notes}">
                <tr>
                    <td class="label">Nội dung ghi chú:</td>
                    <td class="value" style="font-weight: 400; font-style: italic;"><c:out value="${receipt.notes}" /></td>
                </tr>
            </c:if>
        </table>
    </div>

    <div class="payment-highlight">
        <div>
            <div style="font-size: 0.875rem; color: #166534; font-weight: 500;">SỐ TIỀN THU THỰC TẾ:</div>
            <div style="font-size: 0.8125rem; color: var(--text-muted); margin-top: 2px;">
                Tổng học phí khóa: <fmt:formatNumber value="${receipt.invoiceFinalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                • Đã nộp tổng: <fmt:formatNumber value="${receipt.totalPaidAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
            </div>
        </div>
        <div style="text-align: right;">
            <div class="amount-big">
                <fmt:formatNumber value="${receipt.paymentAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
            </div>
            <div style="font-size: 0.8125rem; font-weight: 600; color: ${receipt.remainingDebtAmount > 0 ? '#ea580c' : '#16a34a'}; margin-top: 2px;">
                <c:choose>
                    <c:when test="${receipt.remainingDebtAmount > 0}">
                        Còn nợ: <fmt:formatNumber value="${receipt.remainingDebtAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </c:when>
                    <c:otherwise>
                        Đã thanh toán đủ toàn bộ
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="signatures">
        <div>
            <div class="sig-title">Người nộp tiền</div>
            <div class="sig-sub">(Ký & ghi rõ họ tên)</div>
            <div class="sig-name"><c:out value="${not empty receipt.guardianName ? receipt.guardianName : receipt.studentName}" /></div>
        </div>
        <div>
            <div class="sig-title">Người thu tiền / Thủ quỹ</div>
            <div class="sig-sub">(Ký & ghi rõ họ tên)</div>
            <div class="sig-name"><c:out value="${receipt.cashierName}" /></div>
        </div>
    </div>
</div>

</body>
</html>
