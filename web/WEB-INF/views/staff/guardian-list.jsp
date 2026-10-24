<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css">
    <title>Quản lý Phụ huynh & Giám hộ | EduCenter</title>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="guardians" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & Khách hàng / Phụ huynh & Giám hộ" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Top Breadcrumb & Header Bar -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <a href="${pageContext.request.contextPath}/staff/students">Tuyển sinh & Khách hàng</a>
                            <span style="color: var(--text-muted); opacity: 0.6;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Phụ huynh & Giám hộ</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Quản lý Phụ huynh & Quyền Giám hộ</h1>
                            <span class="mgmt-badge-version">ISO 27001 / BR15 Ver.4</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Quản lý hồ sơ nhân thân phụ huynh, thiết lập ma trận liên kết con cái đa chiều (nhiều-nhiều) và phân quyền bảo hộ pháp lý theo Business Rule BR15.
                        </p>
                    </div>
                    <div class="mgmt-header-actions">
                        <a class="mgmt-btn mgmt-btn-outline" href="${pageContext.request.contextPath}/staff/students">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            <span>Hồ sơ Học viên</span>
                        </a>
                        <button class="mgmt-btn mgmt-btn-primary" type="button" onclick="openGuardianModal()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            <span>Thêm mới Phụ huynh</span>
                        </button>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <c:if test="${not empty flash_success}">
                    <div class="toast-alert toast-success" style="padding: 12px 18px; border-radius: var(--radius-md); display: flex; align-items: center; gap: 10px; font-weight: 500; font-size: 13.5px; background: rgba(22, 163, 74, 0.1); color: #16a34a; border: 1px solid rgba(22, 163, 74, 0.25);">
                        <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                        </svg>
                        <span>${flash_success}</span>
                    </div>
                </c:if>
                <c:if test="${not empty flash_error}">
                    <div class="toast-alert toast-error" style="padding: 12px 18px; border-radius: var(--radius-md); display: flex; align-items: center; gap: 10px; font-weight: 500; font-size: 13.5px; background: rgba(220, 38, 38, 0.1); color: #dc2626; border: 1px solid rgba(220, 38, 38, 0.25);">
                        <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                            <line x1="9" y1="9" x2="15" y2="15"></line>
                        </svg>
                        <span>${flash_error}</span>
                    </div>
                </c:if>

                <!-- Compute Dynamic Operational KPIs from Backend List -->
                <c:set var="totalCount" value="${not empty totalItems ? totalItems : (not empty guardians ? guardians.size() : 0)}" />
                <c:set var="verifiedFullCount" value="0" />
                <c:set var="activePortalCount" value="0" />
                <c:set var="pendingVerifyCount" value="0" />
                <c:forEach var="item" items="${guardians}">
                    <c:if test="${item.verifiedChildrenCount > 0 && item.verifiedChildrenCount == item.childrenCount}">
                        <c:set var="verifiedFullCount" value="${verifiedFullCount + 1}" />
                    </c:if>
                    <c:if test="${item.userStatus == 'ACTIVE'}">
                        <c:set var="activePortalCount" value="${activePortalCount + 1}" />
                    </c:if>
                    <c:if test="${item.childrenCount > 0 && item.verifiedChildrenCount < item.childrenCount}">
                        <c:set var="pendingVerifyCount" value="${pendingVerifyCount + 1}" />
                    </c:if>
                </c:forEach>

                <!-- Operational Stat KPI Strip -->
                <div class="mgmt-kpi-grid">
                    <!-- KPI 1: Tổng số Phụ huynh -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Tổng số Phụ huynh</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val">${totalCount}</span>
                                <span class="mgmt-kpi-subval positive">Hồ sơ toàn hệ thống</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap primary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 2: Xác thực BR15 Hoàn tất -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Xác thực BR15 Hoàn tất</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #0d9488;">
                                    <c:choose>
                                        <c:when test="${not empty guardians && guardians.size() > 0}">
                                            <fmt:formatNumber value="${(verifiedFullCount * 100.0) / guardians.size()}" maxFractionDigits="1"/>%
                                        </c:when>
                                        <c:otherwise>100%</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="mgmt-kpi-subval positive">${verifiedFullCount} / ${guardians != null ? guardians.size() : 0} đã duyệt</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap secondary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 3: Tài khoản Portal Active -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Tài khoản Portal Active</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val">${activePortalCount}</span>
                                <span class="mgmt-kpi-subval">
                                    <c:choose>
                                        <c:when test="${not empty guardians && guardians.size() > 0}">
                                            <fmt:formatNumber value="${(activePortalCount * 100.0) / guardians.size()}" maxFractionDigits="1"/>% kích hoạt
                                        </c:when>
                                        <c:otherwise>Sẵn sàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap primary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect width="20" height="14" x="2" y="3" rx="2"></rect>
                                <line x1="8" y1="21" x2="16" y2="21"></line>
                                <line x1="12" y1="17" x2="12" y2="21"></line>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 4: Cần bổ sung giấy tờ -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Cần bổ sung giấy tờ</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #b45309;">${pendingVerifyCount}</span>
                                <span class="mgmt-kpi-subval warning">Chờ đối soát BR15</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap tertiary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Advanced Search & Filter Bar -->
                <div class="mgmt-filter-card">
                    <form method="GET" action="${pageContext.request.contextPath}/staff/guardians" class="mgmt-filter-grid">
                        <div class="mgmt-filter-item">
                            <label class="mgmt-label" for="search-input">Tìm kiếm từ khóa</label>
                            <div class="mgmt-input-wrap">
                                <svg class="mgmt-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="q" id="search-input" value="<c:out value='${filter.keyword}'/>" class="mgmt-input" placeholder="Họ tên, mã PH, SĐT, email, nghề nghiệp, địa chỉ...">
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 240px;">
                            <label class="mgmt-label" for="filter-status">Trạng thái hồ sơ</label>
                            <div class="mgmt-select-wrap">
                                <select name="status" id="filter-status" class="mgmt-select">
                                    <option value="ALL" ${empty filter.status or filter.status == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${filter.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động (ACTIVE)</option>
                                    <option value="INACTIVE" ${filter.status == 'INACTIVE' ? 'selected' : ''}>Tạm khóa (INACTIVE)</option>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 260px;">
                            <label class="mgmt-label" for="filter-br15">Xác thực giám hộ (BR15)</label>
                            <div class="mgmt-select-wrap">
                                <select name="verification" id="filter-br15" class="mgmt-select">
                                    <option value="ALL" ${empty filter.verification or filter.verification == 'ALL' ? 'selected' : ''}>Tất cả trạng thái duyệt</option>
                                    <option value="VERIFIED" ${filter.verification == 'VERIFIED' ? 'selected' : ''}>Đã duyệt xác thực 100%</option>
                                    <option value="UNVERIFIED" ${filter.verification == 'UNVERIFIED' ? 'selected' : ''}>Chờ bổ sung giấy tờ</option>
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
                                <span>Lọc</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/guardians" class="mgmt-btn mgmt-btn-outline" title="Xóa bộ lọc">
                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                                    <path d="M3 3v5h5"></path>
                                </svg>
                                <span>Xóa lọc</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Enterprise Guardian Data Grid Container -->
                <div class="mgmt-table-card">
                    <!-- Quick Table Metadata Header -->
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-meta-left">
                            <span class="mgmt-table-meta-title">Danh sách Phụ huynh & Giám hộ</span>
                            <span class="mgmt-table-meta-badge">Hiển thị ${guardians != null ? guardians.size() : 0} / ${totalCount}</span>
                        </div>
                        <div class="mgmt-table-meta-right">
                            <button type="button" class="mgmt-btn-tool" onclick="window.print()">
                                <svg class="mgmt-btn-tool-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                    <polyline points="7 10 12 15 17 10"></polyline>
                                    <line x1="12" y1="15" x2="12" y2="3"></line>
                                </svg>
                                <span>Xuất Excel</span>
                            </button>
                            <div class="mgmt-divider-v"></div>
                            <button type="button" class="mgmt-btn-tool">
                                <svg class="mgmt-btn-tool-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="4" y1="21" x2="4" y2="14"></line>
                                    <line x1="4" y1="10" x2="4" y2="3"></line>
                                    <line x1="12" y1="21" x2="12" y2="12"></line>
                                    <line x1="12" y1="8" x2="12" y2="3"></line>
                                    <line x1="20" y1="21" x2="20" y2="16"></line>
                                    <line x1="20" y1="12" x2="20" y2="3"></line>
                                    <line x1="1" y1="14" x2="7" y2="14"></line>
                                    <line x1="9" y1="8" x2="15" y2="8"></line>
                                    <line x1="17" y1="16" x2="23" y2="16"></line>
                                </svg>
                                <span>Cột hiển thị</span>
                            </button>
                        </div>
                    </div>

                    <!-- Data Table -->
                    <div class="mgmt-table-responsive">
                        <table class="mgmt-table">
                            <thead>
                                <tr>
                                    <th style="width: 100px;">Mã PH</th>
                                    <th style="min-width: 220px;">Phụ huynh</th>
                                    <th style="min-width: 260px;">Liên hệ</th>
                                    <th style="min-width: 220px;">Tài khoản Portal</th>
                                    <th style="min-width: 200px;">Con em liên kết</th>
                                    <th style="width: 150px;">Xác thực BR15</th>
                                    <th style="width: 130px; text-align: center;">Trạng thái</th>
                                    <th style="width: 90px; text-align: center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty guardians}">
                                        <c:forEach var="g" items="${guardians}">
                                            <tr>
                                                <td class="align-top">
                                                    <span class="mgmt-code-badge">${g.code}</span>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; align-items: flex-start; gap: 12px;">
                                                        <div class="mgmt-avatar ${g.fullName.hashCode() % 2 == 0 ? 'color-blue' : 'color-teal'}">
                                                            ${g.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div style="display: flex; flex-direction: column; min-width: 0;">
                                                            <span style="font-size: 14px; font-weight: 700; color: var(--text); line-height: 1.3;">
                                                                <c:out value="${g.fullName}" />
                                                            </span>
                                                            <span style="font-size: 12px; color: var(--text-muted); margin-top: 3px; line-height: 1.35;">
                                                                <c:out value="${not empty g.occupation ? g.occupation : 'Chưa cập nhật nghề nghiệp'}" />
                                                            </span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column; gap: 5px; font-size: 12.5px;">
                                                        <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; color: var(--text);">
                                                            <svg class="mgmt-btn-icon" style="color: var(--text-muted); width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                                            </svg>
                                                            <span><c:out value="${g.phone}" /></span>
                                                        </div>
                                                        <div style="display: flex; align-items: center; gap: 6px; color: var(--text-muted);">
                                                            <svg class="mgmt-btn-icon" style="color: var(--text-muted); width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                                                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                                            </svg>
                                                            <span style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                                <c:out value="${not empty g.email ? g.email : 'Chưa có email'}" />
                                                            </span>
                                                        </div>
                                                        <c:if test="${not empty g.address}">
                                                            <div style="display: flex; align-items: center; gap: 6px; color: var(--text-muted); font-size: 11.5px;" title="<c:out value='${g.address}'/>">
                                                                <svg class="mgmt-btn-icon" style="color: var(--text-muted); width: 14px; height: 14px; flex-shrink: 0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"></path>
                                                                    <circle cx="12" cy="10" r="3"></circle>
                                                                </svg>
                                                                <span style="max-width: 220px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                                    <c:out value="${g.address}" />
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column; gap: 4px;">
                                                        <span style="font-size: 13px; font-weight: 600; color: var(--primary); display: flex; align-items: center; gap: 5px;">
                                                            <svg class="mgmt-btn-icon" style="width: 14px; height: 14px; flex-shrink: 0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <circle cx="12" cy="12" r="10"></circle>
                                                                <path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"></path>
                                                                <path d="M2 12h20"></path>
                                                            </svg>
                                                            <span style="max-width: 180px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                                <c:out value="${g.userEmail}" />
                                                            </span>
                                                        </span>
                                                        <div style="display: flex; align-items: center; gap: 6px; font-size: 11px; color: var(--text-muted);">
                                                            <span>User ID: #${g.userId}</span>
                                                            <span>•</span>
                                                            <span style="color: ${g.userStatus == 'ACTIVE' ? '#0d9488' : '#e11d48'}; font-weight: 700; text-transform: uppercase;">
                                                                <c:out value="${g.userStatus}" />
                                                            </span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column; gap: 6px;">
                                                        <span class="mgmt-count-badge">
                                                            <svg style="width: 13px; height: 13px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                                <circle cx="9" cy="7" r="4"></circle>
                                                            </svg>
                                                            <span>${g.childrenCount} con em</span>
                                                        </span>
                                                        <c:if test="${not empty g.children}">
                                                            <div style="display: flex; gap: 5px; flex-wrap: wrap;">
                                                                <c:forEach var="c" items="${g.children}">
                                                                    <a href="${pageContext.request.contextPath}/staff/students/detail?id=${c.studentId}" class="mgmt-child-chip" title="<c:out value='${c.studentName}' /> (<c:out value='${c.relationship}' />)">
                                                                        <svg style="width: 12px; height: 12px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                                                            <circle cx="12" cy="7" r="4"></circle>
                                                                        </svg>
                                                                        <span><c:out value="${c.studentCode}" /></span>
                                                                    </a>
                                                                </c:forEach>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <c:choose>
                                                        <c:when test="${g.verifiedChildrenCount > 0 && g.verifiedChildrenCount == g.childrenCount}">
                                                            <span class="badge-status badge-verified-all badge-br15-approved">
                                                                <svg class="badge-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                                    <polyline points="9 12 11 14 15 10"></polyline>
                                                                </svg>
                                                                <span>${g.verifiedChildrenCount}/${g.childrenCount} ĐÃ DUYỆT</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${g.childrenCount > 0}">
                                                            <span class="badge-status badge-verified-pending badge-br15-pending">
                                                                <svg class="badge-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10"></circle>
                                                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                                                </svg>
                                                                <span>${g.verifiedChildrenCount}/${g.childrenCount} CHỜ DUYỆT</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-empty">Chưa gắn con</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top text-center">
                                                    <c:choose>
                                                        <c:when test="${g.status == 'ACTIVE'}">
                                                            <span class="badge-status badge-active">
                                                                <span class="mgmt-dot mgmt-dot-pulse"></span>
                                                                <span>Hoạt động</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-locked">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Tạm khóa</span>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top text-center">
                                                    <div style="display: flex; align-items: center; justify-content: center; gap: 4px;">
                                                        <button type="button" class="mgmt-btn-icon-sq" title="Chỉnh sửa thông tin phụ huynh"
                                                                data-id="${g.id}"
                                                                data-userid="${g.userId}"
                                                                data-fullname="<c:out value='${g.fullName}'/>"
                                                                data-phone="<c:out value='${g.phone}'/>"
                                                                data-email="<c:out value='${g.email}'/>"
                                                                data-occupation="<c:out value='${g.occupation}'/>"
                                                                data-address="<c:out value='${g.address}'/>"
                                                                data-status="<c:out value='${g.status}'/>"
                                                                onclick="editGuardianFromBtn(this)">
                                                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                                            </svg>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8">
                                                <div class="mgmt-empty-state">
                                                    <div class="mgmt-empty-icon-wrap">
                                                        <svg class="mgmt-empty-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="9" cy="7" r="4"></circle>
                                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                        </svg>
                                                    </div>
                                                    <h3 class="mgmt-empty-title">Không tìm thấy hồ sơ phụ huynh nào</h3>
                                                    <p class="mgmt-empty-desc">
                                                        Chưa có hồ sơ người giám hộ hoặc phụ huynh nào phù hợp với điều kiện tìm kiếm. Hãy kiểm tra từ khóa hoặc tạo mới.
                                                    </p>
                                                    <button type="button" class="mgmt-btn mgmt-btn-primary" onclick="openGuardianModal()">
                                                        <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                                        </svg>
                                                        <span>Thêm phụ huynh mới</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination Bar -->
                    <c:if test="${totalPages > 1}">
                        <div class="mgmt-table-footer">
                            <div class="mgmt-table-footer-left">
                                <span>Hiển thị trang <strong style="color: var(--text);">${currentPage}</strong> / <strong style="color: var(--text);">${totalPages}</strong> (Tổng số <strong style="color: var(--primary);">${totalItems}</strong> phụ huynh)</span>
                            </div>
                            <div class="mgmt-pagination">
                                <a href="${pageContext.request.contextPath}/staff/guardians?q=${filter.keyword}&status=${filter.status}&verification=${filter.verification}&page=${currentPage - 1}"
                                   class="mgmt-page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                    <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="15 18 9 12 15 6"></polyline>
                                    </svg>
                                </a>
                                <c:forEach var="p" begin="1" end="${totalPages}">
                                    <a href="${pageContext.request.contextPath}/staff/guardians?q=${filter.keyword}&status=${filter.status}&verification=${filter.verification}&page=${p}"
                                       class="mgmt-page-btn ${currentPage == p ? 'active' : ''}">
                                        ${p}
                                    </a>
                                </c:forEach>
                                <a href="${pageContext.request.contextPath}/staff/guardians?q=${filter.keyword}&status=${filter.status}&verification=${filter.verification}&page=${currentPage + 1}"
                                   class="mgmt-page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="9 18 15 12 9 6"></polyline>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Business Rule BR15 Protocol Reference Drawer -->
                <div class="mgmt-protocol-box">
                    <div class="mgmt-protocol-left">
                        <div class="mgmt-protocol-icon-wrap">
                            <svg class="mgmt-protocol-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                        </div>
                        <div class="mgmt-protocol-text">
                            <div class="mgmt-protocol-title-row">
                                <span class="mgmt-protocol-title">Quy chuẩn định danh & Xác thực Giám hộ BR15</span>
                                <span class="mgmt-protocol-tag">BẮT BUỘC</span>
                            </div>
                            <p class="mgmt-protocol-desc">
                                Một học viên có thể có tối đa 2 người giám hộ hợp pháp (Cha/Mẹ/Người bảo trợ). Tất cả giao dịch học phí, kết quả thi định kỳ và thông báo điểm danh sẽ được đồng bộ trực tiếp tới tài khoản Portal đã xác thực đủ hồ sơ công chứng (CCCD + Giấy khai sinh/Giấy ủy quyền).
                            </p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/staff/rules/br15" class="mgmt-protocol-link">
                        <span>Xem chi tiết quy chuẩn</span>
                        <svg style="width: 16px; height: 16px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Thêm / Sửa Phụ huynh -->
<div class="mgmt-modal-overlay" id="guardianModal">
    <div class="mgmt-modal-card">
        <div class="mgmt-modal-header">
            <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 34px; height: 34px; border-radius: 8px; background: rgba(37, 99, 235, 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center;">
                    <svg style="width: 18px; height: 18px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <line x1="19" y1="8" x2="19" y2="14"></line>
                        <line x1="22" y1="11" x2="16" y2="11"></line>
                    </svg>
                </div>
                <div>
                    <h3 class="mgmt-modal-title" id="guardianModalTitle">Thêm mới Hồ sơ Phụ huynh</h3>
                    <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">Cập nhật thông tin nhân thân & quyền giám hộ BR15</p>
                </div>
            </div>
            <button type="button" class="mgmt-btn-icon-sq" onclick="closeGuardianModal()">
                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/save" id="guardianForm">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="id" id="formGuardianId" value="">

            <div class="mgmt-modal-body">
                <!-- Smart Account Provisioning Mode -->
                <div id="accountModeContainer" style="margin-bottom: 18px; padding: 14px 16px; background: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="font-size: 13px; font-weight: 700; color: var(--text); margin-bottom: 8px;">
                        Tài khoản Portal Phụ huynh:
                    </div>
                    <div style="display: flex; gap: 20px; flex-wrap: wrap;">
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer;">
                            <input type="radio" name="accountMode" id="modeAuto" value="AUTO" checked onchange="toggleAccountMode()">
                            <span><strong>Tự động cấp tài khoản</strong> (Khuyên dùng)</span>
                        </label>
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer;">
                            <input type="radio" name="accountMode" id="modeManual" value="MANUAL" onchange="toggleAccountMode()">
                            <span>Gắn tài khoản người dùng có sẵn</span>
                        </label>
                    </div>
                    <div id="autoAccountNote" style="font-size: 12px; color: var(--text-muted); margin-top: 10px; padding: 8px 12px; background: var(--surface); border-radius: var(--radius-xs); border-left: 3px solid var(--primary); display: flex; align-items: center; gap: 8px;">
                        <svg style="width: 15px; height: 15px; color: var(--primary); flex-shrink: 0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="16" x2="12" y2="12"></line>
                            <line x1="12" y1="8" x2="12.01" y2="8"></line>
                        </svg>
                        <span>Hệ thống tự động kích hoạt tài khoản vai trò Phụ huynh với tên đăng nhập là Email (hoặc SĐT), mật khẩu khởi tạo bằng SĐT.</span>
                    </div>
                    <div id="manualAccountGroup" style="display: none; margin-top: 12px;">
                        <select name="userId" id="formUserId" class="mgmt-select">
                            <option value="">-- Chọn tài khoản người dùng có vai trò PARENT --</option>
                            <c:forEach var="pu" items="${availableParentUsers}">
                                <option value="${pu.id}"><c:out value="${pu.fullName}"/> (<c:out value="${pu.email}"/>)</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="mgmt-form-group">
                    <label class="mgmt-label" for="formFullName">
                        Họ và tên phụ huynh <span style="color: #dc2626;">*</span>
                    </label>
                    <input type="text" name="fullName" id="formFullName" required maxlength="150" class="mgmt-input" placeholder="Ví dụ: Trần Văn Nam">
                </div>

                <div class="mgmt-modal-row-2">
                    <div class="mgmt-form-group">
                        <label class="mgmt-label" for="formPhone">
                            Số điện thoại <span style="color: #dc2626;">*</span>
                        </label>
                        <input type="tel" name="phone" id="formPhone" required maxlength="20" class="mgmt-input" placeholder="Ví dụ: 0912345678">
                    </div>

                    <div class="mgmt-form-group">
                        <label class="mgmt-label" for="formEmail">
                            Email liên hệ
                        </label>
                        <input type="email" name="email" id="formEmail" maxlength="255" class="mgmt-input" placeholder="Ví dụ: phuhuynh@gmail.com">
                    </div>
                </div>

                <div class="mgmt-modal-row-2">
                    <div class="mgmt-form-group">
                        <label class="mgmt-label" for="formOccupation">
                            Nghề nghiệp
                        </label>
                        <input type="text" name="occupation" id="formOccupation" maxlength="150" class="mgmt-input" placeholder="Ví dụ: Bác sĩ, Kỹ sư, Kinh doanh...">
                    </div>

                    <div class="mgmt-form-group">
                        <label class="mgmt-label" for="formStatus">
                            Trạng thái hồ sơ
                        </label>
                        <select name="status" id="formStatus" class="mgmt-select">
                            <option value="ACTIVE">Hoạt động (ACTIVE)</option>
                            <option value="INACTIVE">Ngừng hoạt động (INACTIVE)</option>
                        </select>
                    </div>
                </div>

                <div class="mgmt-form-group">
                    <label class="mgmt-label" for="formAddress">
                        Địa chỉ cư trú
                    </label>
                    <input type="text" name="address" id="formAddress" maxlength="255" class="mgmt-input" placeholder="Ví dụ: Số 123 Đường Cầu Giấy, Hà Nội">
                </div>
            </div>

            <div class="mgmt-modal-footer">
                <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="closeGuardianModal()">Hủy</button>
                <button type="submit" class="mgmt-btn mgmt-btn-primary" id="btnSaveGuardian">Lưu phụ huynh</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleAccountMode() {
    var isAuto = document.getElementById('modeAuto').checked;
    document.getElementById('autoAccountNote').style.display = isAuto ? 'flex' : 'none';
    document.getElementById('manualAccountGroup').style.display = isAuto ? 'none' : 'block';
    if (isAuto) {
        document.getElementById('formUserId').value = '';
    }
}

function openGuardianModal() {
    document.getElementById('guardianModalTitle').innerText = 'Thêm mới Hồ sơ Phụ huynh';
    document.getElementById('formGuardianId').value = '';
    document.getElementById('modeAuto').checked = true;
    toggleAccountMode();
    document.getElementById('formFullName').value = '';
    document.getElementById('formPhone').value = '';
    document.getElementById('formEmail').value = '';
    document.getElementById('formOccupation').value = '';
    document.getElementById('formAddress').value = '';
    document.getElementById('formStatus').value = 'ACTIVE';
    document.getElementById('btnSaveGuardian').innerText = 'Tạo phụ huynh';
    document.getElementById('guardianModal').classList.add('active');
}

function editGuardianFromBtn(btn) {
    if (!btn) return;
    editGuardian(
        btn.getAttribute('data-id'),
        btn.getAttribute('data-userid'),
        btn.getAttribute('data-fullname'),
        btn.getAttribute('data-phone'),
        btn.getAttribute('data-email'),
        btn.getAttribute('data-occupation'),
        btn.getAttribute('data-address'),
        btn.getAttribute('data-status')
    );
}

function editGuardian(id, userId, fullName, phone, email, occupation, address, status) {
    document.getElementById('guardianModalTitle').innerText = 'Cập nhật Hồ sơ Phụ huynh (PH' + String(id).padStart(4, '0') + ')';
    document.getElementById('formGuardianId').value = id;
    
    var userSelect = document.getElementById('formUserId');
    var found = false;
    for (var i = 0; i < userSelect.options.length; i++) {
        if (userSelect.options[i].value == userId) {
            userSelect.selectedIndex = i;
            found = true;
            break;
        }
    }
    if (!found && userId) {
        var opt = document.createElement('option');
        opt.value = userId;
        opt.innerText = fullName + ' (ID #' + userId + ')';
        opt.selected = true;
        userSelect.appendChild(opt);
    }

    if (userId) {
        document.getElementById('modeManual').checked = true;
    } else {
        document.getElementById('modeAuto').checked = true;
    }
    toggleAccountMode();

    document.getElementById('formFullName').value = fullName || '';
    document.getElementById('formPhone').value = (phone && phone !== 'null') ? phone : '';
    document.getElementById('formEmail').value = (email && email !== 'null') ? email : '';
    document.getElementById('formOccupation').value = (occupation && occupation !== 'null') ? occupation : '';
    document.getElementById('formAddress').value = (address && address !== 'null') ? address : '';
    document.getElementById('formStatus').value = status || 'ACTIVE';
    document.getElementById('btnSaveGuardian').innerText = 'Lưu thay đổi';
    document.getElementById('guardianModal').classList.add('active');
}

function closeGuardianModal() {
    document.getElementById('guardianModal').classList.remove('active');
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeGuardianModal();
    }
});
</script>
</body>
</html>
