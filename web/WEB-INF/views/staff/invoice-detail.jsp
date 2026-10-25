<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css?v=20261024_05">
    <title>Hóa đơn ${invoice.invoiceCode} — EduCenter ERP</title>
    <style>
        /* Dedicated Invoice Detail Custom Styling */
        .inv-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
        }

        .inv-header-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg, 12px);
            padding: 20px 24px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .inv-title-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .inv-code-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .inv-main-code {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text);
            letter-spacing: -0.02em;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .inv-meta-row {
            display: flex;
            align-items: center;
            gap: 16px;
            font-size: 0.8125rem;
            color: var(--text-muted);
            flex-wrap: wrap;
        }

        .inv-meta-item {
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        /* 2-Column Grid Layout */
        .inv-main-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 1080px) {
            .inv-main-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Cards */
        .inv-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg, 12px);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            overflow: hidden;
            margin-bottom: 24px;
        }

        .inv-card:last-child {
            margin-bottom: 0;
        }

        .inv-card-header {
            padding: 16px 20px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .inv-card-title-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .inv-card-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(37, 99, 235, 0.08);
            color: var(--primary);
            flex-shrink: 0;
        }

        .inv-card-title {
            font-size: 0.9375rem;
            font-weight: 700;
            color: var(--text);
            margin: 0;
        }

        .inv-card-subtitle {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin: 2px 0 0 0;
        }

        .inv-card-body {
            padding: 20px;
        }

        /* Info Tiles Grid */
        .inv-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
        }

        @media (max-width: 640px) {
            .inv-info-grid {
                grid-template-columns: 1fr;
            }
        }

        .inv-info-box {
            background: var(--surface-muted, #f8fafc);
            border: 1px solid var(--border);
            border-radius: var(--radius-md, 8px);
            padding: 14px 16px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
            transition: all 0.15s ease;
        }

        .inv-info-box:hover {
            border-color: rgba(37, 99, 235, 0.3);
            background: rgba(37, 99, 235, 0.02);
        }

        .inv-info-icon-sq {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .inv-info-content {
            display: flex;
            flex-direction: column;
            gap: 2px;
            min-width: 0;
            flex: 1;
        }

        .inv-info-label {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--text-muted);
        }

        .inv-info-val-primary {
            font-size: 0.9375rem;
            font-weight: 700;
            color: var(--text);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .inv-info-val-secondary {
            font-size: 0.8125rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 2px;
        }

        /* Items Table */
        .inv-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
        }

        .inv-table th {
            background: var(--surface-muted, #f8fafc);
            color: var(--text-muted);
            font-weight: 600;
            text-align: left;
            padding: 10px 14px;
            border-bottom: 1px solid var(--border);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .inv-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border);
            color: var(--text);
            vertical-align: middle;
        }

        .inv-table tbody tr:last-child td {
            border-bottom: none;
        }

        .inv-table tbody tr:hover td {
            background: rgba(0, 0, 0, 0.015);
        }

        /* Summary Total Block */
        .inv-summary-wrap {
            padding-top: 16px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
        }

        .inv-summary-table {
            width: 320px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .inv-summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.875rem;
            color: var(--text-muted);
        }

        .inv-summary-row.total {
            padding-top: 10px;
            border-top: 2px dashed var(--border);
            font-size: 1.125rem;
            font-weight: 800;
            color: var(--text);
        }

        .inv-summary-row.total .amount {
            color: var(--primary);
            font-size: 1.25rem;
        }

        /* Debt & Summary Widget (Right) */
        .debt-widget-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .debt-progress-wrap {
            margin-bottom: 16px;
        }

        .debt-progress-label-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .debt-progress-bar-bg {
            width: 100%;
            height: 8px;
            background: var(--surface-muted, #e2e8f0);
            border-radius: 9999px;
            overflow: hidden;
        }

        .debt-progress-bar-fill {
            height: 100%;
            border-radius: 9999px;
            background: linear-gradient(90deg, #10b981 0%, #059669 100%);
            transition: width 0.3s ease;
        }

        .debt-stats-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 16px;
        }

        .debt-stat-card {
            background: var(--surface-muted, #f8fafc);
            border: 1px solid var(--border);
            border-radius: var(--radius-md, 8px);
            padding: 12px;
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .debt-stat-label {
            font-size: 0.6875rem;
            font-weight: 600;
            text-transform: uppercase;
            color: var(--text-muted);
            letter-spacing: 0.03em;
        }

        .debt-stat-val {
            font-size: 1.0625rem;
            font-weight: 700;
            color: var(--text);
        }

        /* Outstanding Debt Banner */
        .debt-alert-banner {
            border-radius: var(--radius-md, 8px);
            padding: 14px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 1px solid;
            margin-bottom: 16px;
        }

        .debt-alert-banner.unpaid {
            background: #fff7ed;
            border-color: #ffedd5;
            color: #9a3412;
        }

        .debt-alert-banner.paid {
            background: #f0fdf4;
            border-color: #dcfce7;
            color: #166534;
        }

        /* Payment Manual Card */
        .payment-card {
            background: var(--surface);
            border: 2px solid rgba(37, 99, 235, 0.4);
            border-radius: var(--radius-lg, 12px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.06);
            overflow: hidden;
        }

        .payment-card-header {
            padding: 16px 20px;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.06) 0%, rgba(37, 99, 235, 0.01) 100%);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Method Picker Cards */
        .method-picker-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 6px;
        }

        .method-picker-label {
            cursor: pointer;
            position: relative;
        }

        .method-picker-label input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .method-picker-box {
            border: 1.5px solid var(--border);
            background: var(--surface);
            border-radius: var(--radius-md, 8px);
            padding: 10px 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8125rem;
            font-weight: 600;
            color: var(--text);
            transition: all 0.15s ease;
            user-select: none;
        }

        .method-picker-label input:checked + .method-picker-box {
            border-color: var(--primary);
            background: rgba(37, 99, 235, 0.06);
            color: var(--primary);
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);
        }

        /* Quick Amount Chips */
        .amount-chips-wrap {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 8px;
        }

        .amount-chip {
            border: 1px solid var(--border);
            background: var(--surface-muted, #f8fafc);
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.15s ease;
        }

        .amount-chip:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--surface);
        }

        /* Badge Status */
        .badge-status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 9999px;
            font-size: 0.8125rem;
            font-weight: 700;
            letter-spacing: 0.02em;
        }

        .badge-status-pill.unpaid {
            background: #fffbeb;
            color: #b45309;
            border: 1px solid #fde68a;
        }

        .badge-status-pill.partially {
            background: #f0f9ff;
            color: #0369a1;
            border: 1px solid #bae6fd;
        }

        .badge-status-pill.paid {
            background: #f0fdf4;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }

        .badge-status-pill.cancelled {
            background: #f8fafc;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .badge-status-pill.overdue {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }
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
            <div class="inv-container">

                <!-- 1. Top Bar / Action Header -->
                <div class="inv-header-card">
                    <div style="display: flex; align-items: center; gap: 16px;">
                        <a href="${pageContext.request.contextPath}/staff/invoices" class="mgmt-btn mgmt-btn-outline" title="Trở lại danh sách">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="19" y1="12" x2="5" y2="12"></line>
                                <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            <span>Danh sách hóa đơn</span>
                        </a>

                        <div class="inv-title-group">
                            <div class="inv-code-row">
                                <h1 class="inv-main-code">
                                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" style="color: var(--primary);">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                    <span>Hóa đơn ${invoice.invoiceCode}</span>
                                </h1>

                                <c:choose>
                                    <c:when test="${invoice.status == 'PAID'}">
                                        <span class="badge-status-pill paid">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                            <span>Đã thanh toán đủ</span>
                                        </span>
                                    </c:when>
                                    <c:when test="${invoice.status == 'PARTIALLY_PAID'}">
                                        <span class="badge-status-pill partially">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                            <span>Đã đóng một phần</span>
                                        </span>
                                    </c:when>
                                    <c:when test="${invoice.status == 'CANCELLED'}">
                                        <span class="badge-status-pill cancelled">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                            <span>Đã hủy bỏ</span>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-status-pill unpaid">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                            <span>Chưa thanh toán</span>
                                        </span>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${invoice.overdue}">
                                    <span class="badge-status-pill overdue">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                        <span>Quá hạn thanh toán</span>
                                    </span>
                                </c:if>
                            </div>

                            <div class="inv-meta-row">
                                <span class="inv-meta-item">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    <span>Khởi tạo: <strong>${invoice.createdAt.toLocalDate()} ${invoice.createdAt.toLocalTime().toString().substring(0, 5)}</strong></span>
                                </span>
                                <span class="inv-meta-item">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    <span>Hạn thanh toán: <strong>${invoice.dueDate}</strong></span>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div style="display: flex; gap: 8px;">
                        <a href="${pageContext.request.contextPath}/staff/enrollments?<c:if test='${not empty returnStudentId}'>studentId=${returnStudentId}&</c:if><c:if test='${not empty param.studentId}'>studentId=${param.studentId}&</c:if><c:if test='${empty returnStudentId && empty param.studentId && not empty invoice.student.id}'>studentId=${invoice.student.id}&</c:if><c:if test='${not empty returnLeadId}'>leadId=${returnLeadId}&</c:if><c:if test='${not empty param.leadId}'>leadId=${param.leadId}&</c:if>paid=1" 
                           class="mgmt-btn mgmt-btn-primary" style="background: #16a34a; border-color: #16a34a; font-weight: 600;" 
                           title="Quay lại Ghi danh & Xếp lớp">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="9 14 4 9 9 4"></polyline>
                                <path d="M20 20v-7a4 4 0 0 0-4-4H4"></path>
                            </svg>
                            <span>Quay lại Ghi danh</span>
                        </a>
                        <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="window.print()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="6 9 6 2 18 2 18 9"></polyline>
                                <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                                <rect width="12" height="8" x="6" y="14"></rect>
                            </svg>
                            <span>In hóa đơn</span>
                        </button>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <c:if test="${fromEnrollment || not empty returnStudentId || not empty param.fromEnrollment}">
                    <div class="mgmt-callout primary" style="margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; background: rgba(37, 99, 235, 0.08); border-left: 4px solid var(--primary); padding: 12px 16px; border-radius: 6px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <svg class="mgmt-callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 20px; height: 20px; color: var(--primary);">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <div>
                                <strong style="color: var(--primary); font-size: 13.5px;">Chuyển tiếp từ quy trình Ghi danh:</strong>
                                <p style="margin: 2px 0 0 0; font-size: 12.5px; color: var(--text-muted);">
                                    Thu tiền hoặc kiểm tra hóa đơn học phí của học viên, sau đó nhấn nút "Quay lại Ghi danh & Xếp lớp" để hoàn tất xếp lớp.
                                </p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/staff/enrollments?<c:if test='${not empty returnStudentId}'>studentId=${returnStudentId}&</c:if><c:if test='${not empty param.studentId}'>studentId=${param.studentId}&</c:if><c:if test='${empty returnStudentId && empty param.studentId && not empty invoice.student.id}'>studentId=${invoice.student.id}&</c:if><c:if test='${not empty returnLeadId}'>leadId=${returnLeadId}&</c:if><c:if test='${not empty param.leadId}'>leadId=${param.leadId}&</c:if>paid=1" class="mgmt-btn mgmt-btn-primary" style="white-space: nowrap; font-weight: 600; background: #16a34a; border-color: #16a34a;">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="9 14 4 9 9 4"></polyline>
                                <path d="M20 20v-7a4 4 0 0 0-4-4H4"></path>
                            </svg>
                            <span>Quay lại Ghi danh & Xếp lớp</span>
                        </a>
                    </div>
                </c:if>

                <!-- 2. Main Two-Column Layout -->
                <div class="inv-main-grid">

                    <!-- LEFT COLUMN: Thông tin, Khoản mục, Lịch sử -->
                    <div>
                        <!-- Card 1: Thông tin Học viên & Lớp học -->
                        <div class="inv-card">
                            <div class="inv-card-header">
                                <div class="inv-card-title-group">
                                    <div class="inv-card-icon">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                    </div>
                                    <div>
                                        <h3 class="inv-card-title">Thông tin Học viên & Lớp học</h3>
                                        <p class="inv-card-subtitle">Hồ sơ đối tượng thụ hưởng và phân bổ lớp học</p>
                                    </div>
                                </div>
                            </div>
                            <div class="inv-card-body">
                                <div class="inv-info-grid">
                                    <!-- Tile 1: Học viên -->
                                    <div class="inv-info-box">
                                        <div class="inv-info-icon-sq">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="8.5" cy="7" r="4"></circle>
                                                <line x1="20" y1="8" x2="20" y2="14"></line>
                                                <line x1="23" y1="11" x2="17" y2="11"></line>
                                            </svg>
                                        </div>
                                        <div class="inv-info-content">
                                            <span class="inv-info-label">Họ tên học viên</span>
                                            <div class="inv-info-val-primary"><c:out value="${invoice.studentName}" /></div>
                                            <div class="inv-info-val-secondary">
                                                <span>Mã học viên:</span>
                                                <span class="mgmt-code-badge"><c:out value="${invoice.studentCode}" /></span>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tile 2: Liên hệ -->
                                    <div class="inv-info-box">
                                        <div class="inv-info-icon-sq">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                            </svg>
                                        </div>
                                        <div class="inv-info-content">
                                            <span class="inv-info-label">Điện thoại / Email</span>
                                            <div class="inv-info-val-primary">
                                                <a href="tel:${invoice.studentPhone}" style="color: inherit; text-decoration: none;">
                                                    <c:out value="${invoice.studentPhone}" />
                                                </a>
                                            </div>
                                            <div class="inv-info-val-secondary">
                                                <c:out value="${not empty invoice.studentEmail ? invoice.studentEmail : 'Chưa có email'}" />
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tile 3: Phụ huynh -->
                                    <div class="inv-info-box">
                                        <div class="inv-info-icon-sq">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="9" cy="7" r="4"></circle>
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                            </svg>
                                        </div>
                                        <div class="inv-info-content">
                                            <span class="inv-info-label">Phụ huynh bảo hộ</span>
                                            <div class="inv-info-val-primary">
                                                <c:out value="${not empty invoice.guardianName ? invoice.guardianName : 'Chưa cập nhật'}" />
                                            </div>
                                            <div class="inv-info-val-secondary">
                                                <c:choose>
                                                    <c:when test="${not empty invoice.guardianPhone}">
                                                        <span>SĐT: <a href="tel:${invoice.guardianPhone}" style="color: inherit; text-decoration: none;"><c:out value="${invoice.guardianPhone}" /></a></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>Chưa có SĐT phụ huynh</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Tile 4: Lớp học -->
                                    <div class="inv-info-box">
                                        <div class="inv-info-icon-sq">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                            </svg>
                                        </div>
                                        <div class="inv-info-content">
                                            <span class="inv-info-label">Lớp học ghi danh</span>
                                            <div class="inv-info-val-primary"><c:out value="${invoice.className}" /></div>
                                            <div class="inv-info-val-secondary">
                                                <span>Mã lớp:</span>
                                                <span class="mgmt-code-badge"><c:out value="${invoice.classCode}" /></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Card 2: Chi tiết Khoản mục Hóa đơn -->
                        <div class="inv-card">
                            <div class="inv-card-header">
                                <div class="inv-card-title-group">
                                    <div class="inv-card-icon">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                            <line x1="2" x2="22" y1="10" x2="10"></line>
                                        </svg>
                                    </div>
                                    <div>
                                        <h3 class="inv-card-title">Chi tiết Khoản mục Học phí</h3>
                                        <p class="inv-card-subtitle">Bảng kê định mức học phí khóa học và các khoản thu</p>
                                    </div>
                                </div>
                                <span class="mgmt-table-meta-badge"><c:out value="${invoice.items.size()}" /> khoản mục</span>
                            </div>

                            <div style="padding: 0 20px 20px 20px;">
                                <div class="mgmt-table-responsive" style="margin-top: 10px; border: 1px solid var(--border); border-radius: var(--radius-md);">
                                    <table class="inv-table">
                                        <thead>
                                        <tr>
                                            <th style="width: 48px; text-align: center;">#</th>
                                            <th>Nội dung thu</th>
                                            <th style="text-align: right; width: 140px;">Đơn giá</th>
                                            <th style="text-align: center; width: 70px;">SL</th>
                                            <th style="text-align: right; width: 150px;">Thành tiền</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="it" items="${invoice.items}" varStatus="loop">
                                            <tr>
                                                <td style="text-align: center; color: var(--text-muted); font-size: 12px;">${loop.count}</td>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--text);"><c:out value="${it.description}" /></span>
                                                </td>
                                                <td style="text-align: right; color: var(--text-muted);">
                                                    <fmt:formatNumber value="${it.unitPrice}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td style="text-align: center; font-weight: 600;">${it.quantity}</td>
                                                <td style="text-align: right; font-weight: 700; color: var(--text);">
                                                    <fmt:formatNumber value="${it.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Summary calculation table -->
                                <div class="inv-summary-wrap">
                                    <div class="inv-summary-table">
                                        <div class="inv-summary-row">
                                            <span>Tổng học phí gốc:</span>
                                            <span style="font-weight: 600; color: var(--text);">
                                                <fmt:formatNumber value="${invoice.totalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </span>
                                        </div>
                                        <div class="inv-summary-row">
                                            <span>Miễn giảm / Học bổng:</span>
                                            <span style="font-weight: 600; color: #16a34a;">
                                                - <fmt:formatNumber value="${invoice.discountAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </span>
                                        </div>
                                        <div class="inv-summary-row total">
                                            <span>Tổng phải thanh toán:</span>
                                            <span class="amount">
                                                <fmt:formatNumber value="${invoice.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Card 3: Lịch sử Thu tiền & Phiếu thu -->
                        <div class="inv-card">
                            <div class="inv-card-header">
                                <div class="inv-card-title-group">
                                    <div class="inv-card-icon">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10"></circle>
                                            <polyline points="12 6 12 12 16 14"></polyline>
                                        </svg>
                                    </div>
                                    <div>
                                        <h3 class="inv-card-title">Lịch sử Giao dịch & Phiếu thu</h3>
                                        <p class="inv-card-subtitle">Nhật ký các đợt đã thu tiền và phiếu biên lai bàn giao</p>
                                    </div>
                                </div>
                                <span class="mgmt-table-meta-badge"><c:out value="${invoice.payments.size()}" /> đợt thu</span>
                            </div>

                            <div style="padding: 0 20px 20px 20px;">
                                <c:choose>
                                    <c:when test="${not empty invoice.payments}">
                                        <div class="mgmt-table-responsive" style="margin-top: 10px; border: 1px solid var(--border); border-radius: var(--radius-md);">
                                            <table class="inv-table">
                                                <thead>
                                                <tr>
                                                    <th>Mã phiếu thu</th>
                                                    <th>Thời gian thu</th>
                                                    <th>Hình thức</th>
                                                    <th>Mã GD tham chiếu</th>
                                                    <th>Người thu</th>
                                                    <th style="text-align: right;">Số tiền thu</th>
                                                    <th style="text-align: center; width: 120px;">Biên lai</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="p" items="${invoice.payments}">
                                                    <tr>
                                                        <td>
                                                            <span class="mgmt-code-badge" style="font-weight: 700; color: var(--primary);">
                                                                <c:out value="${p.paymentCode}" />
                                                            </span>
                                                        </td>
                                                        <td style="font-size: 0.8125rem; color: var(--text-muted);"><c:out value="${p.paidAt}" /></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${p.paymentMethod == 'CASH'}">
                                                                    <span style="display: inline-flex; align-items: center; gap: 4px; color: #16a34a; font-weight: 600; font-size: 0.8125rem;">
                                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="12" x="2" y="6" rx="2"></rect><circle cx="12" cy="12" r="2"></circle><path d="M6 12h.01M18 12h.01"></path></svg>
                                                                        <span>Tiền mặt tại quầy</span>
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${p.paymentMethod == 'BANK_TRANSFER'}">
                                                                    <span style="display: inline-flex; align-items: center; gap: 4px; color: #0284c7; font-weight: 600; font-size: 0.8125rem;">
                                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"></rect><line x1="2" x2="22" y1="10" x2="10"></line></svg>
                                                                        <span>Chuyển khoản NH</span>
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="mgmt-code-badge"><c:out value="${p.paymentMethod}" /></span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="font-size: 0.8125rem;">
                                                            <c:choose>
                                                                <c:when test="${not empty p.transactionRef}">
                                                                    <code><c:out value="${p.transactionRef}" /></code>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span style="color: var(--text-muted);">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="font-size: 0.8125rem; font-weight: 500;"><c:out value="${p.confirmedByName}" /></td>
                                                        <td style="text-align: right; font-weight: 700; color: #16a34a;">
                                                            + <fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <a href="${pageContext.request.contextPath}/staff/invoices/receipt?paymentId=${p.id}" target="_blank" class="mgmt-btn mgmt-btn-outline" style="height: 30px; padding: 4px 10px; font-size: 12px; gap: 4px;">
                                                                <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                                                                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                                                                    <rect width="12" height="8" x="6" y="14"></rect>
                                                                </svg>
                                                                <span>In phiếu</span>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mgmt-empty-state" style="padding: 32px 16px;">
                                            <div class="mgmt-empty-icon-wrap" style="width: 52px; height: 52px;">
                                                <svg class="mgmt-empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                                    <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                                    <line x1="2" x2="22" y1="10" x2="10"></line>
                                                </svg>
                                            </div>
                                            <h4 class="mgmt-empty-title" style="font-size: 14px; margin-top: 8px;">Chưa có giao dịch thu tiền nào</h4>
                                            <p class="mgmt-empty-desc" style="font-size: 12.5px; max-width: 400px;">
                                                Hóa đơn này hiện chưa ghi nhận bất kỳ lần đóng học phí nào từ học viên hoặc phụ huynh.
                                            </p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- RIGHT COLUMN: Công nợ & Form duyệt thu tiền -->
                    <div>
                        <!-- Card 4: Tổng hợp công nợ & Tiến độ -->
                        <div class="inv-card">
                            <div class="inv-card-header">
                                <div class="inv-card-title-group">
                                    <div class="inv-card-icon" style="background: rgba(16, 185, 129, 0.08); color: #10b981;">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <h3 class="inv-card-title">Tổng hợp Công nợ</h3>
                                        <p class="inv-card-subtitle">Đối soát thực thu và số dư còn lại</p>
                                    </div>
                                </div>
                            </div>
                            <div class="inv-card-body">
                                <!-- Calculate % collected -->
                                <c:set var="pctPaid" value="0" />
                                <c:if test="${invoice.finalAmount > 0}">
                                    <c:set var="pctPaid" value="${(invoice.paidAmount * 100) / invoice.finalAmount}" />
                                </c:if>

                                <div class="debt-progress-wrap">
                                    <div class="debt-progress-label-row">
                                        <span>Tiến độ thanh toán</span>
                                        <span><fmt:formatNumber value="${pctPaid}" maxFractionDigits="1"/>%</span>
                                    </div>
                                    <div class="debt-progress-bar-bg">
                                        <div class="debt-progress-bar-fill" style="width: ${pctPaid > 100 ? 100 : pctPaid}%;"></div>
                                    </div>
                                </div>

                                <div class="debt-stats-grid">
                                    <div class="debt-stat-card">
                                        <span class="debt-stat-label">Tổng phải đóng</span>
                                        <span class="debt-stat-val">
                                            <fmt:formatNumber value="${invoice.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                    <div class="debt-stat-card">
                                        <span class="debt-stat-label">Đã thanh toán</span>
                                        <span class="debt-stat-val" style="color: #16a34a;">
                                            <fmt:formatNumber value="${invoice.paidAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </span>
                                    </div>
                                </div>

                                <!-- Outstanding Debt Highlight -->
                                <c:choose>
                                    <c:when test="${invoice.debtAmount > 0}">
                                        <div class="debt-alert-banner unpaid">
                                            <div>
                                                <div style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em;">Số nợ còn lại</div>
                                                <div style="font-size: 1.375rem; font-weight: 800; color: #ea580c; margin-top: 2px;">
                                                    <fmt:formatNumber value="${invoice.debtAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </div>
                                            </div>
                                            <div style="width: 36px; height: 36px; border-radius: 50%; background: #fed7aa; display: flex; align-items: center; justify-content: center; color: #c2410c;">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                                                    <circle cx="12" cy="12" r="10"></circle>
                                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                                </svg>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="debt-alert-banner paid">
                                            <div>
                                                <div style="font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.04em;">Số nợ còn lại</div>
                                                <div style="font-size: 1.375rem; font-weight: 800; color: #16a34a; margin-top: 2px;">
                                                    0 đ
                                                </div>
                                            </div>
                                            <div style="width: 36px; height: 36px; border-radius: 50%; background: #bbf7d0; display: flex; align-items: center; justify-content: center; color: #15803d;">
                                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                </svg>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div style="display: flex; align-items: center; justify-content: space-between; font-size: 0.8125rem; color: var(--text-muted); padding-top: 4px;">
                                    <span>Hạn chót thanh toán:</span>
                                    <span style="font-weight: 600; color: var(--text);"><c:out value="${invoice.dueDate}" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- Card 5: Duyệt thu tiền thủ công (ADM-15) -->
                        <div class="payment-card">
                            <div class="payment-card-header">
                                <div style="width: 32px; height: 32px; border-radius: 8px; background: var(--primary); color: #ffffff; display: flex; align-items: center; justify-content: center;">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                        <line x1="2" x2="22" y1="10" x2="10"></line>
                                    </svg>
                                </div>
                                <div>
                                    <h3 style="font-size: 0.9375rem; font-weight: 700; color: var(--text); margin: 0;">Duyệt thu tiền học phí</h3>
                                    <p style="font-size: 0.75rem; color: var(--text-muted); margin: 2px 0 0 0;">Nghiệp vụ thu ngân & Xuất biên lai (ADM-15)</p>
                                </div>
                            </div>

                            <div style="padding: 20px;">
                                <c:choose>
                                    <c:when test="${invoice.status == 'CANCELLED'}">
                                        <div class="mgmt-callout danger">
                                            <svg class="mgmt-callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                                            <div>
                                                <strong>Hóa đơn đã bị hủy!</strong> Không thể ghi nhận thêm giao dịch thu tiền.
                                            </div>
                                        </div>
                                    </c:when>

                                    <c:when test="${invoice.debtAmount <= 0 || invoice.status == 'PAID'}">
                                        <div class="mgmt-callout success">
                                            <svg class="mgmt-callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                            <div>
                                                <strong>Hóa đơn đã hoàn thành!</strong> Học viên đã nộp đủ toàn bộ học phí.
                                            </div>
                                        </div>
                                        <div style="margin-top: 14px;">
                                            <a href="${pageContext.request.contextPath}/staff/enrollments?<c:if test='${not empty returnStudentId}'>studentId=${returnStudentId}&</c:if><c:if test='${not empty param.studentId}'>studentId=${param.studentId}&</c:if><c:if test='${empty returnStudentId && empty param.studentId && not empty invoice.student.id}'>studentId=${invoice.student.id}&</c:if><c:if test='${not empty returnLeadId}'>leadId=${returnLeadId}&</c:if><c:if test='${not empty param.leadId}'>leadId=${param.leadId}&</c:if>paid=1" 
                                               class="mgmt-btn mgmt-btn-primary" style="width: 100%; justify-content: center; font-weight: 600; padding: 10px; background: #16a34a; border-color: #16a34a; display: inline-flex; align-items: center; gap: 8px;">
                                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <polyline points="9 14 4 9 9 4"></polyline>
                                                    <path d="M20 20v-7a4 4 0 0 0-4-4H4"></path>
                                                </svg>
                                                <span>Quay lại Ghi danh & Xếp lớp</span>
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <!-- Format debtAmount cleanly without decimals for input value -->
                                        <fmt:formatNumber value="${invoice.debtAmount}" pattern="#0" var="debtIntVal" />

                                        <form action="${pageContext.request.contextPath}/staff/invoices/payment" method="post" id="manualPaymentForm" onsubmit="return confirmPaymentSubmit();">
                                            <input type="hidden" name="invoiceId" value="${invoice.id}">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                            <input type="hidden" name="fromEnrollment" value="${fromEnrollment ? '1' : param.fromEnrollment}">
                                            <input type="hidden" name="studentId" value="${not empty returnStudentId ? returnStudentId : (not empty param.studentId ? param.studentId : invoice.student.id)}">
                                            <input type="hidden" name="leadId" value="${not empty returnLeadId ? returnLeadId : param.leadId}">

                                            <!-- Số tiền thu -->
                                            <div class="mgmt-form-group" style="margin-bottom: 16px;">
                                                <label class="mgmt-label">
                                                    Số tiền thu đợt này (VNĐ) <span style="color: #dc2626;">*</span>
                                                </label>
                                                <div style="position: relative;">
                                                    <input type="number" id="payAmountInput" name="amount" class="mgmt-input"
                                                           style="font-size: 1.125rem; font-weight: 700; color: var(--primary); padding-right: 50px;"
                                                           min="1000" max="${debtIntVal}" step="1000"
                                                           value="${debtIntVal}" required>
                                                    <span style="position: absolute; right: 14px; top: 50%; transform: translateY(-50%); font-weight: 700; color: var(--text-muted); font-size: 0.8125rem;">
                                                        VNĐ
                                                    </span>
                                                </div>

                                                <!-- Quick Fill Chips -->
                                                <div class="amount-chips-wrap">
                                                    <button type="button" class="amount-chip" onclick="setPayAmount(${debtIntVal});">
                                                        Đóng hết (<fmt:formatNumber value="${invoice.debtAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>)
                                                    </button>
                                                    <c:if test="${invoice.debtAmount >= 1000000}">
                                                        <button type="button" class="amount-chip" onclick="setPayAmount(1000000);">
                                                            Đóng 1.000.000 đ
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${invoice.debtAmount >= 2000000}">
                                                        <button type="button" class="amount-chip" onclick="setPayAmount(2000000);">
                                                            Đóng 2.000.000 đ
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${invoice.debtAmount >= 500000 && invoice.debtAmount < 1000000}">
                                                        <button type="button" class="amount-chip" onclick="setPayAmount(500000);">
                                                            Đóng 500.000 đ
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <!-- Phương thức thanh toán -->
                                            <div class="mgmt-form-group" style="margin-bottom: 16px;">
                                                <label class="mgmt-label">
                                                    Phương thức thanh toán <span style="color: #dc2626;">*</span>
                                                </label>
                                                <div class="method-picker-grid">
                                                    <label class="method-picker-label">
                                                        <input type="radio" name="paymentMethod" value="CASH" checked onchange="toggleRefInput(false);">
                                                        <div class="method-picker-box">
                                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <rect width="20" height="12" x="2" y="6" rx="2"></rect>
                                                                <circle cx="12" cy="12" r="2"></circle>
                                                                <path d="M6 12h.01M18 12h.01"></path>
                                                            </svg>
                                                            <span>Tiền mặt</span>
                                                        </div>
                                                    </label>

                                                    <label class="method-picker-label">
                                                        <input type="radio" name="paymentMethod" value="BANK_TRANSFER" onchange="toggleRefInput(true);">
                                                        <div class="method-picker-box">
                                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                                                <line x1="2" x2="22" y1="10" x2="10"></line>
                                                            </svg>
                                                            <span>Chuyển khoản</span>
                                                        </div>
                                                    </label>
                                                </div>
                                            </div>

                                            <!-- Mã giao dịch ngân hàng -->
                                            <div class="mgmt-form-group" id="refGroup" style="margin-bottom: 16px; display: none;">
                                                <label class="mgmt-label">
                                                    Mã GD / Mã chuẩn chi ngân hàng
                                                </label>
                                                <input type="text" name="transactionRef" id="transactionRefInput" class="mgmt-input"
                                                       placeholder="VD: FT2410... hoặc MB-8899...">
                                                <small style="color: var(--text-muted); font-size: 11px; margin-top: 4px; display: block;">
                                                    Nhập mã tham chiếu từ app ngân hàng để dễ dàng đối soát sao kê.
                                                </small>
                                            </div>

                                            <!-- Ghi chú phiếu thu -->
                                            <div class="mgmt-form-group" style="margin-bottom: 20px;">
                                                <label class="mgmt-label">Ghi chú phiếu thu</label>
                                                <textarea name="notes" class="mgmt-textarea" rows="2"
                                                          placeholder="Ví dụ: Phụ huynh chuyển khoản đợt 1, đã cấp biên lai..."></textarea>
                                            </div>

                                            <button type="submit" class="mgmt-btn mgmt-btn-primary" style="width: 100%; height: 42px; font-size: 14px; font-weight: 700;">
                                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
        alert('Số tiền thu không được vượt quá số nợ còn lại (' + Number(maxDebt).toLocaleString('vi-VN') + ' đ)!');
        return false;
    }

    var method = document.querySelector('input[name="paymentMethod"]:checked').value;
    var methodLabel = method === 'CASH' ? 'Tiền mặt tại quầy' : 'Chuyển khoản ngân hàng';

    return confirm('XÁC NHẬN DUYỆT THU TIỀN HỌC PHÍ:\n\n' +
        '• Số tiền thực thu: ' + Number(amount).toLocaleString('vi-VN') + ' VNĐ\n' +
        '• Hình thức: ' + methodLabel + '\n\n' +
        'Bạn có chắc chắn muốn xác nhận giao dịch này và xuất biên lai điện tử?');
}
</script>
</body>
</html>
