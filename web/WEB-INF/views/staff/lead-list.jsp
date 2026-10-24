<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="internalShell" value="true" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css?v=20261024_05">
    <title>Quản lý Khách hàng & CRM Tuyển sinh | EduCenter ERP</title>
</head>
<body class="admin-body">
<div class="admin-layout">
    <c:set var="activeNav" value="leads" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & CRM / Khách hàng tiềm năng" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Flash Messages -->
                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        <span>${flashSuccess}</span>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-danger" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--danger);"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                        <span>${flashError}</span>
                    </div>
                </c:if>

                <!-- 1. Top Header & Primary Action Bar -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <a href="${pageContext.request.contextPath}/staff/dashboard">Tuyển sinh & CRM</a>
                            <span style="opacity: 0.5;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Khách hàng tiềm năng</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Quản lý Khách hàng & CRM Tuyển sinh</h1>
                            <span class="mgmt-badge-version">CRM-01 / ADM-02</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Theo dõi, phân bổ chỉ tiêu tư vấn và quy trình chuyển đổi khách hàng tiềm năng qua Website, Hotline và Trực tiếp.
                        </p>
                    </div>

                    <div class="mgmt-header-actions">
                        <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="window.print()" title="In danh sách hoặc lưu PDF">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M6 9V2h12v7"></path>
                                <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                                <rect width="12" height="8" x="6" y="14"></rect>
                            </svg>
                            <span>Xuất dữ liệu Excel/CSV</span>
                        </button>
                        <button type="button" class="mgmt-btn mgmt-btn-primary" onclick="openCreateModal()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            <span>+ Tiếp nhận Khách hàng mới</span>
                        </button>
                    </div>
                </div>

                <!-- 2. Operational SLA Micro-Alert -->
                <div class="crm-sla-alert">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <div style="width: 32px; height: 32px; border-radius: 50%; background: rgba(0, 83, 219, 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                        </div>
                        <div>
                            <strong style="color: var(--primary); font-weight: 600;">Chỉ số SLA Tuyển sinh:</strong> Lead mới tiếp nhận cần được chuyên viên liên hệ trong vòng 15–30 phút để bảo đảm xác suất chuyển đổi ghi danh tối đa.
                        </div>
                    </div>
                    <span style="font-size: 12px; color: var(--text-muted); font-weight: 500; white-space: nowrap;">Thời gian phản hồi TB: 18 phút</span>
                </div>

                <!-- 3. 5 Funnel Performance Cards (Matches Reference Design) -->
                <c:set var="totalVal" value="${data.stats.total != null and data.stats.total > 0 ? data.stats.total : 1}"/>
                <div class="crm-funnel-grid-5">
                    <!-- Metric 1: Tổng khách hàng -->
                    <div class="crm-funnel-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 600;">TỔNG KHÁCH HÀNG</span>
                            <div style="width: 30px; height: 30px; border-radius: 50%; background: rgba(0, 83, 219, 0.1); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                        </div>
                        <div style="margin: 4px 0 12px 0;">
                            <div style="display: flex; align-items: baseline; gap: 6px;">
                                <span style="font-size: 26px; font-weight: 700; color: var(--text);"><fmt:formatNumber value="${data.stats.total != null ? data.stats.total : 0}" pattern="#,###"/></span>
                                <span style="font-size: 12px; color: var(--text-muted);">hồ sơ toàn hệ thống</span>
                            </div>
                        </div>
                        <div style="width: 100%; height: 4px; background: var(--bg-alt); border-radius: 2px; overflow: hidden;">
                            <div style="height: 100%; width: 100%; background: var(--primary); border-radius: 2px;"></div>
                        </div>
                    </div>

                    <!-- Metric 2: Mới tiếp nhận -->
                    <div class="crm-funnel-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 600;">MỚI TIẾP NHẬN</span>
                            <div style="width: 30px; height: 30px; border-radius: 50%; background: rgba(37, 99, 235, 0.1); display: flex; align-items: center; justify-content: center; color: #2563eb;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                            </div>
                        </div>
                        <div style="margin: 4px 0 12px 0;">
                            <div style="display: flex; align-items: baseline; gap: 6px;">
                                <span style="font-size: 26px; font-weight: 700; color: #2563eb;"><fmt:formatNumber value="${data.stats['new'] != null ? data.stats['new'] : 0}" pattern="#,###"/></span>
                                <span style="font-size: 12px; color: #2563eb; font-weight: 600;">Cần xử lý &lt; 2h</span>
                            </div>
                        </div>
                        <div style="width: 100%; height: 4px; background: var(--bg-alt); border-radius: 2px; overflow: hidden;">
                            <div style="height: 100%; width: ${(data.stats['new'] * 100.0) / totalVal}%; background: #2563eb; border-radius: 2px;"></div>
                        </div>
                    </div>

                    <!-- Metric 3: Đang tư vấn / Test -->
                    <div class="crm-funnel-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 600;">ĐANG TƯ VẤN / TEST</span>
                            <div style="width: 30px; height: 30px; border-radius: 50%; background: rgba(217, 119, 6, 0.1); display: flex; align-items: center; justify-content: center; color: #d97706;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                            </div>
                        </div>
                        <div style="margin: 4px 0 12px 0;">
                            <div style="display: flex; align-items: baseline; gap: 6px;">
                                <span style="font-size: 26px; font-weight: 700; color: #d97706;"><fmt:formatNumber value="${data.stats.consulting != null ? data.stats.consulting : 0}" pattern="#,###"/></span>
                                <span style="font-size: 12px; color: var(--text-muted);"><fmt:formatNumber value="${(data.stats.consulting * 100.0) / totalVal}" maxFractionDigits="1"/>% tỷ trọng</span>
                            </div>
                        </div>
                        <div style="width: 100%; height: 4px; background: var(--bg-alt); border-radius: 2px; overflow: hidden;">
                            <div style="height: 100%; width: ${(data.stats.consulting * 100.0) / totalVal}%; background: #d97706; border-radius: 2px;"></div>
                        </div>
                    </div>

                    <!-- Metric 4: Đã ghi danh -->
                    <div class="crm-funnel-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 600;">ĐÃ GHI DANH</span>
                            <div style="width: 30px; height: 30px; border-radius: 50%; background: rgba(5, 150, 105, 0.1); display: flex; align-items: center; justify-content: center; color: #059669;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            </div>
                        </div>
                        <div style="margin: 4px 0 12px 0;">
                            <div style="display: flex; align-items: baseline; gap: 6px;">
                                <span style="font-size: 26px; font-weight: 700; color: #059669;"><fmt:formatNumber value="${data.stats.enrolled != null ? data.stats.enrolled : 0}" pattern="#,###"/></span>
                                <span style="font-size: 12px; color: #059669; font-weight: 600;"><fmt:formatNumber value="${(data.stats.enrolled * 100.0) / totalVal}" maxFractionDigits="1"/>% hoàn tất</span>
                            </div>
                        </div>
                        <div style="width: 100%; height: 4px; background: var(--bg-alt); border-radius: 2px; overflow: hidden;">
                            <div style="height: 100%; width: ${(data.stats.enrolled * 100.0) / totalVal}%; background: #059669; border-radius: 2px;"></div>
                        </div>
                    </div>

                    <!-- Metric 5: Hủy / Thất bại -->
                    <div class="crm-funnel-card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <span style="font-size: 11px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 600;">HỦY / THẤT BẠI</span>
                            <div style="width: 30px; height: 30px; border-radius: 50%; background: rgba(220, 38, 38, 0.1); display: flex; align-items: center; justify-content: center; color: #dc2626;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                            </div>
                        </div>
                        <div style="margin: 4px 0 12px 0;">
                            <div style="display: flex; align-items: baseline; gap: 6px;">
                                <span style="font-size: 26px; font-weight: 700; color: #dc2626;"><fmt:formatNumber value="${data.stats.lost != null ? data.stats.lost : 0}" pattern="#,###"/></span>
                                <span style="font-size: 12px; color: #dc2626;"><fmt:formatNumber value="${(data.stats.lost * 100.0) / totalVal}" maxFractionDigits="1"/>% tỷ lệ mất</span>
                            </div>
                        </div>
                        <div style="width: 100%; height: 4px; background: var(--bg-alt); border-radius: 2px; overflow: hidden;">
                            <div style="height: 100%; width: ${(data.stats.lost * 100.0) / totalVal}%; background: #dc2626; border-radius: 2px;"></div>
                        </div>
                    </div>
                </div>

                <!-- 4. Advanced Filter Bar Card -->
                <div class="mgmt-filter-card">
                    <form action="${pageContext.request.contextPath}/staff/leads" method="GET" class="mgmt-filter-grid">
                        <!-- Search Input -->
                        <div class="mgmt-filter-item">
                            <label class="mgmt-label" for="filterSearch">Tìm kiếm từ khóa</label>
                            <div class="mgmt-input-wrap">
                                <svg class="mgmt-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="keyword" id="filterSearch" value="<c:out value='${filter.keyword}'/>" class="mgmt-input" placeholder="Tên học sinh, số điện thoại, email...">
                            </div>
                        </div>

                        <!-- Trạng thái Dropdown -->
                        <div class="mgmt-filter-item" style="max-width: 220px;">
                            <label class="mgmt-label" for="filterStatus">Trạng thái</label>
                            <div class="mgmt-select-wrap">
                                <select name="status" id="filterStatus" class="mgmt-select">
                                    <option value="">-- Tất cả trạng thái --</option>
                                    <option value="NEW" ${filter.status == 'NEW' ? 'selected' : ''}>Mới tiếp nhận</option>
                                    <option value="CONTACTED" ${filter.status == 'CONTACTED' ? 'selected' : ''}>Đã liên hệ</option>
                                    <option value="CONSULTING" ${filter.status == 'CONSULTING' ? 'selected' : ''}>Đang tư vấn</option>
                                    <option value="ASSESSED" ${filter.status == 'ASSESSED' ? 'selected' : ''}>Đã test đầu vào</option>
                                    <option value="ENROLLED" ${filter.status == 'ENROLLED' ? 'selected' : ''}>Đã ghi danh</option>
                                    <option value="LOST" ${filter.status == 'LOST' ? 'selected' : ''}>Hủy / Thất bại</option>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                        </div>

                        <!-- Nguồn tiếp nhận Dropdown -->
                        <div class="mgmt-filter-item" style="max-width: 220px;">
                            <label class="mgmt-label" for="filterSource">Nguồn tiếp nhận</label>
                            <div class="mgmt-select-wrap">
                                <select name="source" id="filterSource" class="mgmt-select">
                                    <option value="">-- Tất cả nguồn --</option>
                                    <option value="WEBSITE" ${filter.source == 'WEBSITE' ? 'selected' : ''}>Website Form</option>
                                    <option value="HOTLINE" ${filter.source == 'HOTLINE' ? 'selected' : ''}>Tổng đài Hotline</option>
                                    <option value="DIRECT" ${filter.source == 'DIRECT' ? 'selected' : ''}>Trực tiếp (Walk-in)</option>
                                    <option value="FACEBOOK" ${filter.source == 'FACEBOOK' ? 'selected' : ''}>Facebook / Fanpage</option>
                                    <option value="REFERRAL" ${filter.source == 'REFERRAL' ? 'selected' : ''}>Giới thiệu (Referral)</option>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                        </div>

                        <!-- Khối lớp Dropdown -->
                        <div class="mgmt-filter-item" style="max-width: 180px;">
                            <label class="mgmt-label" for="filterGrade">Khối lớp THPT / THCS</label>
                            <div class="mgmt-select-wrap">
                                <select name="gradeLevel" id="filterGrade" class="mgmt-select">
                                    <option value="">-- Tất cả khối --</option>
                                    <c:forEach var="g" begin="6" end="12">
                                        <option value="${g}" ${filter.gradeLevel == g ? 'selected' : ''}>Khối ${g}</option>
                                    </c:forEach>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                        </div>

                        <!-- Filter Actions -->
                        <div class="mgmt-filter-actions">
                            <button type="submit" class="mgmt-btn mgmt-btn-primary">
                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                                </svg>
                                <span>Lọc</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/leads" class="mgmt-btn mgmt-btn-outline" title="Xóa bộ lọc">
                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                                    <path d="M3 3v5h5"></path>
                                </svg>
                                <span>Đặt lại</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- 4. Leads Data Table Card -->
                <div class="mgmt-table-card">
                    <!-- Table Header Info Bar -->
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-meta-left">
                            <span class="mgmt-table-meta-title">Danh sách Khách hàng</span>
                            <span class="mgmt-table-meta-badge">
                                <fmt:formatNumber value="${data.totalCount != null ? data.totalCount : 0}" pattern="#,###"/> hồ sơ khả dụng
                            </span>
                        </div>
                        <div class="mgmt-table-meta-right">
                            <span style="font-size: 12.5px; color: var(--text-muted);">
                                Trang <strong>${data.currentPage}</strong> / <strong>${data.totalPages}</strong>
                            </span>
                        </div>
                    </div>

                    <!-- Responsive Table -->
                    <div class="mgmt-table-responsive">
                        <table class="mgmt-table">
                            <thead>
                                <tr>
                                    <th style="width: 100px;">Mã Lead</th>
                                    <th style="min-width: 220px;">Khách hàng</th>
                                    <th style="min-width: 150px;">Số điện thoại</th>
                                    <th style="width: 100px; text-align: center;">Khối lớp</th>
                                    <th style="width: 120px;">Nguồn</th>
                                    <th style="min-width: 150px;">Trạng thái</th>
                                    <th style="min-width: 190px;">Phụ trách</th>
                                    <th style="width: 120px;">Tiếp nhận</th>
                                    <th style="width: 110px; text-align: right;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty data.leads}">
                                        <c:forEach var="item" items="${data.leads}">
                                            <c:set var="isUnassigned" value="${empty item.assignedToName or item.status == 'NEW'}" />
                                            <tr class="${isUnassigned ? 'lead-row-unassigned' : ''}">
                                                <td class="align-top">
                                                    <span class="lead-code-pill">#LEAD-${item.id}</span>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-weight: 700; color: var(--text); font-size: 13.5px;">
                                                            <c:out value="${item.name}" />
                                                        </span>
                                                        <c:if test="${not empty item.email}">
                                                            <span style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                                <c:out value="${item.email}" />
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <a href="tel:${item.phone}" class="lead-tel-link">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                                                        <span><c:out value="${item.phone}" /></span>
                                                    </a>
                                                </td>
                                                <td class="align-top text-center">
                                                    <c:choose>
                                                        <c:when test="${not empty item.gradeLevel}">
                                                            <span class="badge" style="background: var(--surface-muted); color: var(--text); font-weight: 600;">
                                                                Lớp ${item.gradeLevel}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-muted); font-size: 12px;">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top">
                                                    <span class="lead-source-tag"><c:out value="${item.source}" /></span>
                                                </td>
                                                <td class="align-top">
                                                    <span class="lead-status-pill ${item.status == 'NEW' ? 'status-new' : (item.status == 'ENROLLED' ? 'status-enrolled' : (item.status == 'LOST' ? 'status-lost' : (item.status == 'CONSULTING' ? 'status-consulting' : (item.status == 'ASSESSED' ? 'status-assessed' : 'status-contacted'))))}">
                                                        <span class="dot"></span>
                                                        <span><c:out value="${item.statusDisplayName}" /></span>
                                                    </span>
                                                </td>
                                                <td class="align-top">
                                                    <c:choose>
                                                        <c:when test="${not empty item.assignedToName}">
                                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                                <div class="mgmt-avatar color-blue" style="width: 26px; height: 26px; font-size: 10px;">
                                                                    ${item.assignedToName.substring(0, 1).toUpperCase()}
                                                                </div>
                                                                <span style="font-weight: 600; font-size: 13px; color: var(--text);">
                                                                    <c:out value="${item.assignedToName}" />
                                                                </span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="display: flex; align-items: center; gap: 6px; flex-wrap: wrap;">
                                                                <span style="color: var(--warning); font-size: 11.5px; font-weight: 600;">Chưa phân công</span>
                                                                <form action="${pageContext.request.contextPath}/staff/leads/claim" method="POST" style="margin: 0; display: inline;">
                                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                                    <input type="hidden" name="leadId" value="${item.id}">
                                                                    <button type="submit" class="mgmt-btn mgmt-btn-primary" style="padding: 2px 8px; height: 24px; font-size: 11px; gap: 3px;" title="Nhận lead này vào danh sách chăm sóc của tôi">
                                                                        <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                                                        <span>Nhận lead</span>
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top" style="font-size: 12px; color: var(--text-muted); font-family: monospace;">
                                                    ${item.createdAt != null ? item.createdAt.toLocalDate() : '--'}
                                                </td>
                                                <td class="align-top text-right">
                                                    <a href="${pageContext.request.contextPath}/staff/leads/detail?id=${item.id}" class="mgmt-btn mgmt-btn-outline" style="padding: 4px 10px; height: 28px; font-size: 11.5px; gap: 4px; text-decoration: none;">
                                                        <svg style="width: 13px; height: 13px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
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
                                                            <circle cx="11" cy="11" r="8"></circle>
                                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                                        </svg>
                                                    </div>
                                                    <h3 class="mgmt-empty-title">Không tìm thấy khách hàng nào</h3>
                                                    <p class="mgmt-empty-desc">
                                                        Không có khách hàng nào phù hợp với điều kiện tìm kiếm. Hãy thử đặt lại bộ lọc hoặc tiếp nhận hồ sơ mới.
                                                    </p>
                                                    <div style="display: flex; gap: 10px;">
                                                        <a href="${pageContext.request.contextPath}/staff/leads" class="mgmt-btn mgmt-btn-outline">
                                                            Đặt lại bộ lọc
                                                        </a>
                                                        <button type="button" class="mgmt-btn mgmt-btn-primary" onclick="openCreateModal()">
                                                            + Tiếp nhận Lead mới
                                                        </button>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Enterprise Pagination Footer -->
                    <c:if test="${data.totalPages > 1}">
                        <div class="mgmt-pagination">
                            <span class="mgmt-pagination-info">
                                Hiển thị trang <strong>${data.currentPage}</strong> trong tổng số <strong>${data.totalPages}</strong> trang
                            </span>
                            <div class="mgmt-pagination-pages">
                                <c:forEach var="p" begin="1" end="${data.totalPages}">
                                    <a href="${pageContext.request.contextPath}/staff/leads?page=${p}&keyword=${filter.keyword}&status=${filter.status}&source=${filter.source}&gradeLevel=${filter.gradeLevel}&assignedToId=${filter.assignedToId}"
                                       class="mgmt-page-btn ${data.currentPage == p ? 'is-active' : ''}">
                                        ${p}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- 5. Operational Footer Context & Activity Bar -->
                <div class="stat-tri-grid" style="margin-top: 24px;">
                    <!-- Quick Analytics Overview -->
                    <div class="content-card" style="padding: 16px; margin-bottom: 0; display: flex; flex-direction: column; justify-content: space-between;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                            <span style="font-weight: 600; font-size: 13.5px; color: var(--text);">Tỷ lệ chuyển đổi kênh tiếp cận</span>
                            <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <div>
                                <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px;">
                                    <span style="color: var(--text-muted);">Website Tuyển sinh</span>
                                    <span style="font-weight: 600; color: var(--text);">Kênh chủ lực</span>
                                </div>
                                <div style="width: 100%; height: 6px; background: var(--bg-alt); border-radius: 3px; overflow: hidden;">
                                    <div style="height: 100%; width: 52%; background: var(--primary); border-radius: 3px;"></div>
                                </div>
                            </div>
                            <div>
                                <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px;">
                                    <span style="color: var(--text-muted);">Hotline & Tổng đài</span>
                                    <span style="font-weight: 600; color: var(--text);">Chuyển đổi nhanh</span>
                                </div>
                                <div style="width: 100%; height: 6px; background: var(--bg-alt); border-radius: 3px; overflow: hidden;">
                                    <div style="height: 100%; width: 28%; background: #d97706; border-radius: 3px;"></div>
                                </div>
                            </div>
                            <div>
                                <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 4px;">
                                    <span style="color: var(--text-muted);">Trực tiếp & Giới thiệu</span>
                                    <span style="font-weight: 600; color: var(--text);">Uy tín cao</span>
                                </div>
                                <div style="width: 100%; height: 6px; background: var(--bg-alt); border-radius: 3px; overflow: hidden;">
                                    <div style="height: 100%; width: 20%; background: #059669; border-radius: 3px;"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Active Advisor Workload -->
                    <div class="content-card" style="padding: 16px; margin-bottom: 0; display: flex; flex-direction: column; justify-content: space-between;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                            <span style="font-weight: 600; font-size: 13.5px; color: var(--text);">Định biên Phụ trách tư vấn</span>
                            <span style="font-size: 11px; font-weight: 600; color: #059669; background: rgba(5, 150, 105, 0.1); padding: 2px 6px; border-radius: 4px;">Ca trực hôm nay</span>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 10px; font-size: 12.5px;">
                            <div style="display: flex; align-items: center; justify-content: space-between;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <div class="mgmt-avatar color-blue" style="width: 24px; height: 24px; font-size: 10px;">TH</div>
                                    <span style="font-weight: 500; color: var(--text);">Tư vấn viên Học vụ 01</span>
                                </div>
                                <span style="font-size: 11.5px; color: var(--text-muted); font-family: monospace;">Đang phụ trách</span>
                            </div>
                            <div style="display: flex; align-items: center; justify-content: space-between;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <div class="mgmt-avatar color-green" style="width: 24px; height: 24px; font-size: 10px;">CS</div>
                                    <span style="font-weight: 500; color: var(--text);">Chuyên viên Tuyển sinh</span>
                                </div>
                                <span style="font-size: 11.5px; color: var(--text-muted); font-family: monospace;">Sẵn sàng tiếp nhận</span>
                            </div>
                            <div style="display: flex; align-items: center; justify-content: space-between;">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <div class="mgmt-avatar color-orange" style="width: 24px; height: 24px; font-size: 10px;">QT</div>
                                    <span style="font-weight: 500; color: var(--text);">Quầy Lễ tân & Ghi danh</span>
                                </div>
                                <span style="font-size: 11.5px; color: var(--text-muted); font-family: monospace;">Hỗ trợ trực tiếp</span>
                            </div>
                        </div>
                    </div>

                    <!-- System Audit Micro-feed -->
                    <div class="content-card" style="padding: 16px; margin-bottom: 0; display: flex; flex-direction: column; justify-content: space-between;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                            <span style="font-weight: 600; font-size: 13.5px; color: var(--text);">Quy chuẩn Xử lý Lead CRM</span>
                            <span style="display: flex; align-items: center; gap: 4px; font-size: 11px; font-weight: 600; color: #059669;">
                                <span class="live-pulse-dot" style="background: #059669; width: 6px; height: 6px;"></span>
                                Chuẩn ISO
                            </span>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 8px; font-size: 12px; color: var(--text-muted);">
                            <div style="display: flex; align-items: flex-start; gap: 8px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary); margin-top: 2px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                                <span>Liên hệ khách hàng mới trong <strong>15–30 phút</strong> từ lúc ghi nhận.</span>
                            </div>
                            <div style="display: flex; align-items: flex-start; gap: 8px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: #059669; margin-top: 2px;"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Kiểm tra bài test phân lớp trước khi ghi danh khóa nâng cao.</span>
                            </div>
                            <div style="display: flex; align-items: flex-start; gap: 8px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: #d97706; margin-top: 2px;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                                <span>Bảo mật tuyệt đối thông tin liên hệ và nhật ký tư vấn theo BR18.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>

<!-- Modal Tạo Lead Mới (Modal Backdrop Component) -->
<div id="createLeadModal" class="mgmt-modal-backdrop">
    <div class="mgmt-modal-card">
        <div class="mgmt-modal-header">
            <h3 class="mgmt-modal-title">Tiếp nhận Khách hàng mới (Lead CRM)</h3>
            <button type="button" class="mgmt-modal-close" onclick="closeCreateModal()" aria-label="Đóng modal">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/staff/leads/create" method="POST">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <div class="mgmt-modal-body">
                <div>
                    <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; display: block; margin-bottom: 6px;">
                        Họ và tên khách hàng / Học viên <span style="color: var(--danger);">*</span>
                    </label>
                    <input type="text" name="name" class="form-control" required placeholder="Ví dụ: Hoàng Minh Trí">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
                    <div>
                        <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; display: block; margin-bottom: 6px;">
                            Số điện thoại liên hệ <span style="color: var(--danger);">*</span>
                        </label>
                        <input type="tel" name="phone" class="form-control" required placeholder="0935445566" pattern="^(0|\+84)[0-9]{9,10}$">
                    </div>
                    <div>
                        <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; display: block; margin-bottom: 6px;">
                            Khối lớp THPT / THCS
                        </label>
                        <select name="gradeLevel" class="form-control">
                            <option value="">-- Chọn khối --</option>
                            <c:forEach var="g" begin="6" end="12">
                                <option value="${g}">Lớp ${g}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; display: block; margin-bottom: 6px;">
                        Email liên hệ (nếu có)
                    </label>
                    <input type="email" name="email" class="form-control" placeholder="khachhang@example.com">
                </div>

                <div>
                    <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; display: block; margin-bottom: 6px;">
                        Nguồn tiếp nhận
                    </label>
                    <select name="source" class="form-control">
                        <option value="HOTLINE">Tổng đài Hotline</option>
                        <option value="DIRECT" selected>Trực tiếp tại quầy tuyển sinh</option>
                        <option value="FACEBOOK">Facebook / Mạng xã hội</option>
                        <option value="REFERRAL">Người quen giới thiệu (Referral)</option>
                        <option value="WEBSITE">Website Form</option>
                    </select>
                </div>

                <div>
                    <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; display: block; margin-bottom: 6px;">
                        Nhu cầu học tập &amp; Ghi chú ban đầu
                    </label>
                    <textarea name="notes" class="form-control" rows="3" placeholder="Ghi nhận môn học quan tâm, mục tiêu kỳ thi ĐGNL/Tốt nghiệp, khung giờ rảnh..."></textarea>
                </div>
            </div>

            <div class="mgmt-modal-footer">
                <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="closeCreateModal()">Hủy</button>
                <button type="submit" class="mgmt-btn mgmt-btn-primary">Lưu hồ sơ khách hàng</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('createLeadModal').classList.add('is-active');
    }
    function closeCreateModal() {
        document.getElementById('createLeadModal').classList.remove('is-active');
    }
</script>
</body>
</html>
