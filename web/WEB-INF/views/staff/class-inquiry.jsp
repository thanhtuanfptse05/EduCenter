<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="internalShell" value="true" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css?v=20261024_02">
    <title>Tra cứu Lớp học Tuyển sinh | EduCenter ERP</title>
</head>
<body class="admin-body">
<div class="admin-layout">
    <c:set var="activeNav" value="staff-classes" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & CRM / Tra cứu lớp tuyển sinh" scope="request" />
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

                <!-- 1. Top Command & Action Bar -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <a href="${pageContext.request.contextPath}/staff/dashboard">Tuyển sinh & CRM</a>
                            <span style="opacity: 0.5;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Tra cứu lớp tuyển sinh</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Tra cứu Lớp học Tuyển sinh</h1>
                            <span class="mgmt-badge-version">ADM-03 / CRM-08</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Kiểm tra sĩ số thực tế, tỷ lệ lấp đầy phòng học và lịch biểu học phần để tư vấn ghi danh tức thì cho phụ huynh & học viên.
                        </p>
                    </div>

                    <div class="mgmt-header-actions">
                        <a href="${pageContext.request.contextPath}/staff/timetable" class="mgmt-btn mgmt-btn-outline">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span>Tra cứu TKB tuần</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/enrollments" class="mgmt-btn mgmt-btn-primary">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <line x1="19" y1="8" x2="19" y2="14"></line>
                                <line x1="22" y1="11" x2="16" y2="11"></line>
                            </svg>
                            <span>Ghi danh vào lớp</span>
                        </a>
                    </div>
                </div>

                <!-- 2. Key Metrics (KPI Summary Cards) -->
                <div class="mgmt-kpi-grid-3">
                    <!-- Card 1: Open Classes -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Lớp đang mở tuyển sinh (Open)</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #059669;">
                                    <fmt:formatNumber value="${stats.openClasses != null ? stats.openClasses : 0}" minIntegerDigits="2"/>
                                </span>
                                <span class="mgmt-kpi-subval positive">
                                    / ${stats.totalClasses != null ? stats.totalClasses : 0} lớp hệ thống
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap secondary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- Card 2: Ongoing Classes -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Lớp đang diễn ra (Ongoing)</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: var(--primary);">
                                    <fmt:formatNumber value="${stats.ongoingClasses != null ? stats.ongoingClasses : 0}" minIntegerDigits="2"/>
                                </span>
                                <span class="mgmt-kpi-subval positive">
                                    Lớp học phần chính khóa
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap primary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                <path d="M6 6h10"></path>
                                <path d="M6 10h10"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Card 3: Total System Classes -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Tổng số lớp trong hệ thống</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: var(--text);">
                                    <fmt:formatNumber value="${stats.totalClasses != null ? stats.totalClasses : 0}" minIntegerDigits="2"/>
                                </span>
                                <span class="mgmt-kpi-subval">
                                    Quy chuẩn THPT &amp; ĐGNL
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap tertiary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- 3. Filter & Criteria Panel -->
                <div class="mgmt-filter-card">
                    <form method="get" action="${pageContext.request.contextPath}/staff/classes" class="mgmt-filter-grid">
                        <div class="mgmt-filter-item">
                            <label class="mgmt-label" for="filterKeyword">Tìm theo mã hoặc tên lớp</label>
                            <div class="mgmt-input-wrap">
                                <svg class="mgmt-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="keyword" id="filterKeyword" class="mgmt-input" placeholder="Nhập mã lớp (L12-...), tên môn, giáo viên..." value="<c:out value='${filter.keyword}'/>">
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 280px;">
                            <label class="mgmt-label" for="filterCourseId">Khóa học / Khối thi</label>
                            <div class="mgmt-select-wrap">
                                <select name="courseId" id="filterCourseId" class="mgmt-select">
                                    <option value="">-- Tất cả khóa học --</option>
                                    <c:forEach var="crs" items="${courses}">
                                        <option value="${crs.id}" ${filter.courseId == crs.id ? 'selected' : ''}>
                                            <c:out value="${crs.code}"/> - <c:out value="${crs.name}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 220px;">
                            <label class="mgmt-label" for="filterStatus">Trạng thái tuyển sinh</label>
                            <div class="mgmt-select-wrap">
                                <select name="status" id="filterStatus" class="mgmt-select">
                                    <option value="ALL">-- Tất cả trạng thái --</option>
                                    <option value="OPEN" ${filter.status == 'OPEN' ? 'selected' : ''}>Mở tuyển sinh (OPEN)</option>
                                    <option value="ONGOING" ${filter.status == 'ONGOING' ? 'selected' : ''}>Đang diễn ra (ONGOING)</option>
                                    <option value="PLANNING" ${filter.status == 'PLANNING' ? 'selected' : ''}>Kế hoạch (PLANNING)</option>
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
                                <span>Tìm kiếm</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/classes" class="mgmt-btn mgmt-btn-outline" title="Đặt lại bộ lọc">
                                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                                    <path d="M3 3v5h5"></path>
                                </svg>
                                <span>Đặt lại</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- 4. Data Grid Container -->
                <div class="mgmt-table-card">
                    <!-- Table Header Info Bar -->
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-meta-left">
                            <span class="mgmt-table-meta-title">Danh sách Lớp học Tuyển sinh</span>
                            <span class="mgmt-table-meta-badge">
                                <c:out value="${totalItems != null ? totalItems : (classes != null ? classes.size() : 0)}"/> lớp phù hợp
                            </span>
                        </div>
                        <div class="mgmt-table-meta-right">
                            <div style="display: flex; align-items: center; gap: 14px; font-size: 12px; color: var(--text-muted);">
                                <span style="display: inline-flex; align-items: center; gap: 5px;">
                                    <span class="mgmt-dot" style="background: #16a34a;"></span> Còn chỗ (&gt; 3 ghế)
                                </span>
                                <span style="display: inline-flex; align-items: center; gap: 5px;">
                                    <span class="mgmt-dot" style="background: #ea580c;"></span> Sắp đầy (&le; 3 ghế)
                                </span>
                                <span style="display: inline-flex; align-items: center; gap: 5px;">
                                    <span class="mgmt-dot" style="background: #dc2626;"></span> Đã đủ sĩ số
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Table -->
                    <div class="mgmt-table-responsive">
                        <table class="mgmt-table">
                            <thead>
                                <tr>
                                    <th style="width: 120px;">Mã lớp</th>
                                    <th style="min-width: 260px;">Tên lớp học &amp; Khóa học</th>
                                    <th style="min-width: 180px;">Giáo viên phụ trách</th>
                                    <th style="min-width: 180px;">Phòng học &amp; CSVC</th>
                                    <th style="text-align: center; width: 140px;">Sĩ số hiện tại</th>
                                    <th style="text-align: center; width: 130px;">Chỗ còn trống</th>
                                    <th style="width: 160px;">Thời gian học</th>
                                    <th style="text-align: right; min-width: 140px;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty classes}">
                                        <c:forEach var="cItem" items="${classes}">
                                            <tr>
                                                <td class="align-top">
                                                    <span class="mgmt-code-badge">${cItem.code}</span>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 14px; font-weight: 700; color: var(--text); line-height: 1.35;">
                                                            <c:out value="${cItem.name}" />
                                                        </span>
                                                        <span style="font-size: 12px; color: var(--text-muted); margin-top: 3px;">
                                                            Khóa: <strong style="color: var(--text);"><c:out value="${cItem.courseName}" /></strong> (<c:out value="${cItem.courseCode}" />)
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; align-items: center; gap: 10px;">
                                                        <div class="mgmt-avatar color-teal" style="width: 32px; height: 32px; font-size: 12px;">
                                                            <c:choose>
                                                                <c:when test="${not empty cItem.teacherName}">
                                                                    ${cItem.teacherName.substring(0, 1).toUpperCase()}
                                                                </c:when>
                                                                <c:otherwise>?</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div style="display: flex; flex-direction: column;">
                                                            <span style="font-size: 13px; font-weight: 600; color: var(--text);">
                                                                <c:out value="${cItem.teacherName != null ? cItem.teacherName : 'Chưa phân công'}" />
                                                            </span>
                                                            <span style="font-size: 11px; color: var(--text-muted);">
                                                                Giáo viên bộ môn
                                                            </span>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column; gap: 2px;">
                                                        <span style="font-size: 13px; font-weight: 600; color: var(--text);">
                                                            <c:out value="${cItem.roomName != null ? cItem.roomName : 'Chưa gán'}" />
                                                        </span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted); display: flex; align-items: center; gap: 4px;">
                                                            <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="m22 8-6 4 6 4V8Z"></path>
                                                                <rect width="14" height="12" x="2" y="6" rx="2"></rect>
                                                            </svg>
                                                            Phòng học tiêu chuẩn
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="align-top text-center">
                                                    <div style="display: flex; flex-direction: column; align-items: center; gap: 4px;">
                                                        <span style="font-size: 13.5px; font-weight: 700; color: var(--text);">
                                                            ${cItem.enrolledCount} / ${cItem.capacity}
                                                        </span>
                                                        <div class="cap-bar-wrap">
                                                            <div class="cap-bar-fill" style="background: ${cItem.remainingSlots > 3 ? '#16a34a' : (cItem.remainingSlots > 0 ? '#ea580c' : '#dc2626')}; width: ${(cItem.enrolledCount * 100.0) / (cItem.capacity > 0 ? cItem.capacity : 1)}%;"></div>
                                                        </div>
                                                        <span style="font-size: 10.5px; color: var(--text-muted);">
                                                            <fmt:formatNumber value="${(cItem.enrolledCount * 100.0) / (cItem.capacity > 0 ? cItem.capacity : 1)}" maxFractionDigits="0"/>% sĩ số
                                                        </span>
                                                    </div>
                                                </td>
                                                <td class="align-top text-center">
                                                    <c:choose>
                                                        <c:when test="${cItem.remainingSlots > 3}">
                                                            <span class="badge-status badge-slots-avail">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Còn ${cItem.remainingSlots} chỗ</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${cItem.remainingSlots > 0}">
                                                            <span class="badge-status badge-slots-low">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Sắp đầy (${cItem.remainingSlots})</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-slots-full">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Đã đủ sĩ số</span>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top" style="font-size: 12px; color: var(--text);">
                                                    <div style="font-weight: 600;"><c:out value="${cItem.formattedStartDate}" /> &rarr; <c:out value="${cItem.formattedEndDate}" /></div>
                                                    <div style="font-size: 11px; color: var(--text-muted); display: flex; align-items: center; gap: 4px; margin-top: 2px;">
                                                        <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                        Ca học tiêu chuẩn
                                                    </div>
                                                </td>
                                                <td class="align-top text-right">
                                                    <div style="display: inline-flex; align-items: center; gap: 6px;">
                                                        <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${cItem.id}" class="mgmt-btn mgmt-btn-outline" style="padding: 4px 8px; height: 28px; font-size: 11.5px; gap: 4px; text-decoration: none;" title="Xem lịch học & chi tiết lớp">
                                                            <svg style="width: 13px; height: 13px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                                <circle cx="12" cy="12" r="3"></circle>
                                                            </svg>
                                                            <span>Xem lịch</span>
                                                        </a>
                                                        <c:if test="${cItem.remainingSlots > 0}">
                                                            <a href="${pageContext.request.contextPath}/staff/enrollments?classId=${cItem.id}" class="mgmt-btn mgmt-btn-primary" style="padding: 4px 8px; height: 28px; font-size: 11.5px; gap: 3px; text-decoration: none;" title="Ghi danh học viên vào lớp này">
                                                                <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                                                    <circle cx="9" cy="7" r="4"></circle>
                                                                    <line x1="19" y1="8" x2="19" y2="14"></line>
                                                                    <line x1="22" y1="11" x2="16" y2="11"></line>
                                                                </svg>
                                                                <span>Ghi danh</span>
                                                            </a>
                                                        </c:if>
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
                                                            <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                                        </svg>
                                                    </div>
                                                    <h3 class="mgmt-empty-title">Không tìm thấy lớp học nào phù hợp</h3>
                                                    <p class="mgmt-empty-desc">
                                                        Không có lớp học nào phù hợp với điều kiện tìm kiếm hoặc bộ lọc khóa học đã chọn. Hãy thử đặt lại bộ lọc.
                                                    </p>
                                                    <a href="${pageContext.request.contextPath}/staff/classes" class="mgmt-btn mgmt-btn-outline">
                                                        Đặt lại bộ lọc
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination Footer -->
                    <c:if test="${totalPages > 1}">
                        <div class="mgmt-pagination">
                            <span class="mgmt-pagination-info">
                                Hiển thị trang <strong>${currentPage}</strong> trong tổng số <strong>${totalPages}</strong> trang
                            </span>
                            <div class="mgmt-pagination-pages">
                                <c:forEach var="p" begin="1" end="${totalPages}">
                                    <a href="${pageContext.request.contextPath}/staff/classes?page=${p}&keyword=${filter.keyword}&courseId=${filter.courseId}&status=${filter.status}"
                                       class="mgmt-page-btn ${currentPage == p ? 'is-active' : ''}">
                                        ${p}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
