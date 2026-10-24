<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css">
    <title>Quản lý Hóa đơn & Thu học phí | EduCenter</title>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="invoices" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & Khách hàng / Quản lý Hóa đơn & Học phí" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Top Action & Context Header -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <a href="${pageContext.request.contextPath}/staff/dashboard">Học vụ & CRM</a>
                            <span style="color: var(--text-muted); opacity: 0.6;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Hóa đơn & Thu học phí</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Quản lý Hóa đơn & Thu học phí</h1>
                            <span class="mgmt-badge-version">ADM-14 / ADM-15</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Theo dõi công nợ học phí, thu tiền mặt hoặc chuyển khoản và in biên lai điện tử chuẩn Bộ GD&ĐT.
                        </p>
                    </div>
                    <div class="mgmt-header-actions">
                        <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="window.print()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                <polyline points="7 10 12 15 17 10"></polyline>
                                <line x1="12" y1="15" x2="12" y2="3"></line>
                            </svg>
                            <span>Xuất báo cáo công nợ</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/staff/enrollments" class="mgmt-btn mgmt-btn-primary">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="16"></line>
                                <line x1="8" y1="12" x2="16" y2="12"></line>
                            </svg>
                            <span>Tạo hóa đơn từ Ghi danh</span>
                        </a>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Calculate collection rate percentage -->
                <c:set var="collectionRate" value="0" />
                <c:if test="${pageData.totalAmountSum > 0}">
                    <c:set var="collectionRate" value="${(pageData.totalPaidSum * 100.0) / pageData.totalAmountSum}" />
                </c:if>

                <!-- Financial KPI Metrics Grid -->
                <div class="mgmt-kpi-grid">
                    <!-- Metric 1: Tổng phát sinh -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Tổng phát sinh học phí</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: var(--primary);">
                                    <fmt:formatNumber value="${pageData.totalAmountSum}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                                <span class="mgmt-kpi-subval positive">Kỳ học vụ hiện hành</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap primary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 21h18"></path>
                                <path d="M3 10h18"></path>
                                <path d="M5 6l7-3 7 3"></path>
                                <path d="M4 10v11"></path>
                                <path d="M20 10v11"></path>
                                <path d="M8 14v4"></path>
                                <path d="M12 14v4"></path>
                                <path d="M16 14v4"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Metric 2: Đã thu thực tế -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Đã thu thực tế</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #16a34a;">
                                    <fmt:formatNumber value="${pageData.totalPaidSum}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                                <span class="mgmt-kpi-subval positive">
                                    <fmt:formatNumber value="${collectionRate}" maxFractionDigits="1"/>% đạt tỷ lệ
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap secondary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                <line x1="2" y1="10" x2="22" y2="10"></line>
                            </svg>
                        </div>
                    </div>

                    <!-- Metric 3: Dư nợ cần thu -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Dư nợ cần thu</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #ea580c;">
                                    <fmt:formatNumber value="${pageData.totalDebtSum}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </span>
                                <span class="mgmt-kpi-subval warning">
                                    <c:choose>
                                        <c:when test="${pageData.totalAmountSum > 0}">
                                            <fmt:formatNumber value="${(pageData.totalDebtSum * 100.0) / pageData.totalAmountSum}" maxFractionDigits="1"/>% chưa hoàn tất
                                        </c:when>
                                        <c:otherwise>0% dư nợ</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap tertiary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- Metric 4: Hóa đơn quá hạn -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Hóa đơn quá hạn nộp</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: ${pageData.overdueCount > 0 ? '#dc2626' : '#16a34a'};">
                                    <c:out value="${pageData.overdueCount}" />
                                </span>
                                <span class="mgmt-kpi-subval ${pageData.overdueCount > 0 ? 'warning' : 'positive'}">
                                    <c:choose>
                                        <c:when test="${pageData.overdueCount > 0}">Cần gửi thông báo nhắc phí</c:when>
                                        <c:otherwise>Toàn bộ đúng kỳ hạn thanh toán</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap" style="background: ${pageData.overdueCount > 0 ? 'rgba(220, 38, 38, 0.1)' : 'rgba(22, 163, 74, 0.1)'}; color: ${pageData.overdueCount > 0 ? '#dc2626' : '#16a34a'};">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Filter & Query Control Center -->
                <div class="mgmt-filter-card">
                    <form action="${pageContext.request.contextPath}/staff/invoices" method="get" class="mgmt-filter-grid">
                        <div class="mgmt-filter-item">
                            <label class="mgmt-label" for="searchKeyword">Tìm kiếm hóa đơn</label>
                            <div class="mgmt-input-wrap">
                                <svg class="mgmt-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="keyword" id="searchKeyword" class="mgmt-input" placeholder="Tìm theo mã HĐ, tên, SĐT học viên..." value="<c:out value='${keyword}' />">
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 280px;">
                            <label class="mgmt-label" for="filterClass">Lớp học</label>
                            <div class="mgmt-select-wrap">
                                <select name="classId" id="filterClass" class="mgmt-select">
                                    <option value="">-- Tất cả lớp học --</option>
                                    <c:forEach var="c" items="${classes}">
                                        <option value="${c.id}" ${selectedClassId == c.id ? 'selected' : ''}>
                                            <c:out value="${c.code}" /> - <c:out value="${c.name}" />
                                        </option>
                                    </c:forEach>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 220px;">
                            <label class="mgmt-label" for="filterStatus">Trạng thái thanh toán</label>
                            <div class="mgmt-select-wrap">
                                <select name="status" id="filterStatus" class="mgmt-select">
                                    <option value="">-- Tất cả trạng thái --</option>
                                    <option value="PAID" ${selectedStatus == 'PAID' ? 'selected' : ''}>Đã thanh toán (PAID)</option>
                                    <option value="UNPAID" ${selectedStatus == 'UNPAID' ? 'selected' : ''}>Chưa đóng (UNPAID)</option>
                                    <option value="PARTIALLY_PAID" ${selectedStatus == 'PARTIALLY_PAID' ? 'selected' : ''}>Đóng một phần (PARTIALLY)</option>
                                    <option value="OVERDUE" ${selectedStatus == 'OVERDUE' ? 'selected' : ''}>Quá hạn đóng tiền (OVERDUE)</option>
                                    <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy (CANCELLED)</option>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                        </div>

                        <div class="mgmt-filter-actions">
                            <button type="submit" class="mgmt-btn mgmt-btn-primary">
                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                                </svg>
                                <span>Lọc hóa đơn</span>
                            </button>
                            <c:if test="${not empty keyword or not empty selectedClassId or not empty selectedStatus}">
                                <a href="${pageContext.request.contextPath}/staff/invoices" class="mgmt-btn mgmt-btn-outline" title="Xóa bộ lọc">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                                        <path d="M3 3v5h5"></path>
                                    </svg>
                                    <span>Xóa lọc</span>
                                </a>
                            </c:if>
                        </div>
                    </form>
                </div>

                <!-- Invoices Master Table Canvas -->
                <div class="mgmt-table-card">
                    <!-- Quick Table Metadata Header -->
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-meta-left">
                            <span class="mgmt-table-meta-title">Danh sách Hóa đơn Phát sinh & Công nợ</span>
                            <span class="mgmt-table-meta-badge"><c:out value="${pageData.totalItems}" /> bản ghi</span>
                        </div>
                        <div class="mgmt-table-meta-right">
                            <button type="button" class="mgmt-btn-tool" onclick="window.print()">
                                <svg class="mgmt-btn-tool-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                    <polyline points="7 10 12 15 17 10"></polyline>
                                    <line x1="12" y1="15" x2="12" y2="3"></line>
                                </svg>
                                <span>In danh sách</span>
                            </button>
                        </div>
                    </div>

                    <!-- Data Grid -->
                    <div class="mgmt-table-responsive">
                        <table class="mgmt-table">
                            <thead>
                                <tr>
                                    <th style="width: 140px;">Mã hóa đơn</th>
                                    <th style="min-width: 180px;">Học viên</th>
                                    <th style="min-width: 250px;">Lớp học</th>
                                    <th style="text-align: right; width: 130px;">Tổng học phí</th>
                                    <th style="text-align: right; width: 120px;">Đã thu</th>
                                    <th style="text-align: right; width: 120px;">Còn nợ</th>
                                    <th style="text-align: center; width: 120px;">Hạn nộp</th>
                                    <th style="text-align: center; width: 140px;">Trạng thái</th>
                                    <th style="text-align: center; width: 100px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty pageData.items}">
                                        <c:forEach var="item" items="${pageData.items}">
                                            <tr style="${item.overdue ? 'background: rgba(239, 68, 68, 0.03);' : ''}">
                                                <td class="align-top">
                                                    <a href="${pageContext.request.contextPath}/staff/invoices/detail?id=${item.id}" class="mgmt-code-badge" style="text-decoration: none;">
                                                        <c:out value="${item.invoiceCode}" />
                                                    </a>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 14px; font-weight: 700; color: var(--text);">
                                                            <c:out value="${item.studentName}" />
                                                        </span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                            <c:out value="${item.studentCode}" /> • <c:out value="${item.studentPhone}" />
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column; max-width: 320px;">
                                                        <span style="font-size: 13.5px; font-weight: 600; color: var(--text); overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                            <c:out value="${item.className}" />
                                                        </span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                            Mã lớp: <c:out value="${item.classCode}" />
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="align-top" style="text-align: right; font-weight: 700; color: var(--text); font-size: 13.5px;">
                                                    <fmt:formatNumber value="${item.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td class="align-top" style="text-align: right; font-weight: 700; color: #16a34a; font-size: 13.5px;">
                                                    <fmt:formatNumber value="${item.paidAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td class="align-top" style="text-align: right; font-weight: 700; color: ${item.debtAmount > 0 ? '#ea580c' : 'var(--text-muted)'}; font-size: 13.5px;">
                                                    <fmt:formatNumber value="${item.debtAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td class="align-top text-center" style="font-size: 12.5px;">
                                                    <div style="font-weight: 500; color: ${item.overdue ? '#dc2626' : 'var(--text)'};">
                                                        <c:out value="${item.dueDate}" />
                                                    </div>
                                                    <c:if test="${item.overdue}">
                                                        <span style="display: inline-block; margin-top: 3px; font-size: 10px; font-weight: 700; padding: 1.5px 6px; border-radius: 4px; background: rgba(220, 38, 38, 0.1); color: #dc2626; border: 1px solid rgba(220, 38, 38, 0.2);">
                                                            QUÁ HẠN
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td class="align-top text-center">
                                                    <c:choose>
                                                        <c:when test="${item.status == 'PAID'}">
                                                            <span class="badge-status badge-paid">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Đã thanh toán</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'PARTIALLY_PAID'}">
                                                            <span class="badge-status badge-partial">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Đóng 1 phần</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'CANCELLED'}">
                                                            <span class="badge-status badge-cancelled">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Đã hủy</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-unpaid">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Chưa đóng</span>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top text-center">
                                                    <a href="${pageContext.request.contextPath}/staff/invoices/detail?id=${item.id}" class="mgmt-btn mgmt-btn-outline" style="padding: 4px 10px; height: 30px; font-size: 12px; gap: 4px; text-decoration: none;">
                                                        <svg style="width: 14px; height: 14px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                            <circle cx="12" cy="12" r="3"></circle>
                                                        </svg>
                                                        <span>Chi tiết</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="9">
                                                <div class="mgmt-empty-state">
                                                    <div class="mgmt-empty-icon-wrap">
                                                        <svg class="mgmt-empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                                            <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                                            <line x1="2" x2="22" y1="10" y2="10"></line>
                                                        </svg>
                                                    </div>
                                                    <h3 class="mgmt-empty-title">Không tìm thấy hóa đơn học phí nào</h3>
                                                    <p class="mgmt-empty-desc">
                                                        <c:choose>
                                                            <c:when test="${not empty keyword or not empty selectedClassId or not empty selectedStatus}">
                                                                Không có hóa đơn nào phù hợp với điều kiện tìm kiếm và bộ lọc đã chọn. Hãy thử xóa bộ lọc để xem toàn bộ danh sách.
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa có hóa đơn học phí nào được phát hành. Hóa đơn sẽ được tạo tự động khi có học viên ghi danh vào các lớp học.
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                    <c:if test="${not empty keyword or not empty selectedClassId or not empty selectedStatus}">
                                                        <a href="${pageContext.request.contextPath}/staff/invoices" class="mgmt-btn mgmt-btn-outline">
                                                            Xóa bộ lọc
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${pageData.totalPages > 1}">
                        <div class="mgmt-table-footer">
                            <div class="mgmt-table-footer-left">
                                <span>Hiển thị trang <strong style="color: var(--text);">${pageData.currentPage}</strong> / <strong style="color: var(--text);">${pageData.totalPages}</strong> (Tổng cộng <strong style="color: var(--primary);">${pageData.totalItems}</strong> hóa đơn)</span>
                            </div>
                            <div class="mgmt-pagination">
                                <c:if test="${pageData.currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/staff/invoices?page=${pageData.currentPage - 1}&classId=${selectedClassId}&status=${selectedStatus}&keyword=${keyword}" class="mgmt-page-btn">
                                        <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                    </a>
                                </c:if>
                                <c:forEach begin="1" end="${pageData.totalPages}" var="p">
                                    <c:if test="${p == pageData.currentPage || p == 1 || p == pageData.totalPages || (p >= pageData.currentPage - 1 && p <= pageData.currentPage + 1)}">
                                        <a href="${pageContext.request.contextPath}/staff/invoices?page=${p}&classId=${selectedClassId}&status=${selectedStatus}&keyword=${keyword}" class="mgmt-page-btn ${p == pageData.currentPage ? 'active' : ''}">
                                            ${p}
                                        </a>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${pageData.currentPage < pageData.totalPages}">
                                    <a href="${pageContext.request.contextPath}/staff/invoices?page=${pageData.currentPage + 1}&classId=${selectedClassId}&status=${selectedStatus}&keyword=${keyword}" class="mgmt-page-btn">
                                        <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Quick Operational Assist Drawer / Footer Insights -->
                <div class="mgmt-protocol-grid-3">
                    <div class="mgmt-protocol-card">
                        <div class="mgmt-protocol-card-icon primary">
                            <svg style="width: 20px; height: 20px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect width="5" height="5" x="3" y="3" rx="1"></rect>
                                <rect width="5" height="5" x="16" y="3" rx="1"></rect>
                                <rect width="5" height="5" x="3" y="16" rx="1"></rect>
                                <path d="M21 16h-3a2 2 0 0 0-2 2v3"></path>
                                <path d="M21 21v.01"></path>
                                <path d="M12 7v3a2 2 0 0 1-2 2H7"></path>
                                <path d="M3 12h.01"></path>
                                <path d="M12 3h.01"></path>
                                <path d="M12 16v.01"></path>
                                <path d="M16 12h1"></path>
                                <path d="M21 12v.01"></path>
                                <path d="M12 21v-1"></path>
                            </svg>
                        </div>
                        <div>
                            <h4 class="mgmt-protocol-card-title">Tự động gạch nợ VietQR Pro</h4>
                            <p class="mgmt-protocol-card-desc">
                                Biên lai ngân hàng khớp theo cú pháp nội dung <code style="color: var(--primary); font-weight: 600;">[Mã HĐ]</code> sẽ được tự động chuyển trạng thái gạch nợ trong vòng 30 giây.
                            </p>
                        </div>
                    </div>

                    <div class="mgmt-protocol-card">
                        <div class="mgmt-protocol-card-icon secondary">
                            <svg style="width: 20px; height: 20px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
                            </svg>
                        </div>
                        <div>
                            <h4 class="mgmt-protocol-card-title">Nhắc phí qua Zalo ZNS & SMS</h4>
                            <p class="mgmt-protocol-card-desc">
                                Hệ thống kích hoạt gửi thông báo tự động tới phụ huynh trước thời hạn nộp 03 ngày theo tiêu chuẩn vận hành CRM EduCenter.
                            </p>
                        </div>
                    </div>

                    <div class="mgmt-protocol-card">
                        <div class="mgmt-protocol-card-icon tertiary">
                            <svg style="width: 20px; height: 20px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="6 9 6 2 18 2 18 9"></polyline>
                                <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                                <rect width="12" height="8" x="6" y="14"></rect>
                            </svg>
                        </div>
                        <div>
                            <h4 class="mgmt-protocol-card-title">In phiếu thu hàng loạt (ADM-15)</h4>
                            <p class="mgmt-protocol-card-desc">
                                Hỗ trợ kết xuất định dạng PDF chuẩn A5 hoặc biên lai nhiệt 80mm có chữ ký điện tử xác thực trung tâm và mã vạch tra cứu.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
