<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css?v=20261024_05">
    <title>Quản lý Ghi danh & Xếp lớp | EduCenter</title>
</head>
<body>
<c:set var="baseEnrollPath" value="${empty enrollmentBasePath ? pageContext.request.contextPath.concat(sessionScope.currentUser.admin ? '/admin/enrollments' : '/staff/enrollments') : enrollmentBasePath}" scope="request"/>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="enrollments" scope="request" />
    <c:set var="breadcrumb" value="${sessionScope.currentUser.admin ? 'Quản trị & Học vụ / Ghi danh & Xếp lớp' : 'Tuyển sinh & Khách hàng / Ghi danh & Xếp lớp'}" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Top Header Action Area -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <a href="${pageContext.request.contextPath}/${sessionScope.currentUser.admin ? 'admin/dashboard' : 'staff/dashboard'}">${sessionScope.currentUser.admin ? 'Quản trị' : 'Học vụ & CRM'}</a>
                            <span style="color: var(--text-muted); opacity: 0.6;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Ghi danh & Xếp lớp</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Quản lý Ghi danh & Xếp lớp</h1>
                            <span class="mgmt-badge-version">ADM-12</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Thực hiện ghi danh học viên, xếp lớp, quản lý chuyển lớp, bảo lưu và khởi tạo hóa đơn học phí tự động.
                        </p>
                    </div>
                    <div class="mgmt-header-actions">
                        <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="window.print()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                <polyline points="7 10 12 15 17 10"></polyline>
                                <line x1="12" y1="15" x2="12" y2="3"></line>
                            </svg>
                            <span>Xuất dữ liệu</span>
                        </button>
                        <button type="button" class="mgmt-btn mgmt-btn-primary" onclick="openEnrollModal()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <line x1="19" y1="8" x2="19" y2="14"></line>
                                <line x1="22" y1="11" x2="16" y2="11"></line>
                            </svg>
                            <span>+ Ghi danh học viên mới</span>
                        </button>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Stat Cards: 4 Column Metrics Grid -->
                <div class="mgmt-kpi-grid">
                    <!-- Active Enrollment -->
                    <div class="mgmt-kpi-card" style="border-left: 4px solid #16a34a;">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">ĐANG THEO HỌC (ACTIVE)</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #16a34a;"><c:out value="${pageData.totalActive}" /></span>
                                <span class="mgmt-kpi-subval positive">học viên chính thức</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap secondary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <polyline points="16 11 18 13 22 9"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- Reserved / On Hold -->
                    <div class="mgmt-kpi-card" style="border-left: 4px solid #d97706;">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">ĐANG BẢO LƯU (RESERVED)</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #b45309;"><c:out value="${pageData.totalReserved}" /></span>
                                <span class="mgmt-kpi-subval warning">hồ sơ bảo lưu</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap tertiary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- Transferred -->
                    <div class="mgmt-kpi-card" style="border-left: 4px solid #0284c7;">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">ĐÃ CHUYỂN LỚP (TRANSFERRED)</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #0284c7;"><c:out value="${pageData.totalTransferred}" /></span>
                                <span class="mgmt-kpi-subval">yêu cầu điều chuyển</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap primary">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="m16 3 4 4-4 4"></path>
                                <path d="M20 7H4"></path>
                                <path d="m8 21-4-4 4-4"></path>
                                <path d="M4 17h16"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Dropped -->
                    <div class="mgmt-kpi-card" style="border-left: 4px solid #dc2626;">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">ĐÃ THÔI HỌC (DROPPED)</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #dc2626;"><c:out value="${pageData.totalDropped}" /></span>
                                <span class="mgmt-kpi-subval warning">học viên dừng học</span>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-wrap" style="background: rgba(220, 38, 38, 0.1); color: #dc2626;">
                            <svg class="mgmt-kpi-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="15" y1="9" x2="9" y2="15"></line>
                                <line x1="9" y1="9" x2="15" y2="15"></line>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Filter & Search Bar -->
                <div class="mgmt-filter-card">
                    <form action="${baseEnrollPath}" method="get" class="mgmt-filter-grid">
                        <div class="mgmt-filter-item">
                            <label class="mgmt-label" for="filterKeyword">Tìm kiếm học viên</label>
                            <div class="mgmt-input-wrap">
                                <svg class="mgmt-input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="q" id="filterKeyword" class="mgmt-input" placeholder="Tìm theo tên học viên, SĐT..."
                                       value="<c:out value='${pageData.keyword}' />">
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 300px;">
                            <label class="mgmt-label" for="filterClassId">Lớp học</label>
                            <div class="mgmt-select-wrap">
                                <select name="classId" id="filterClassId" class="mgmt-select">
                                    <option value="">-- Tất cả lớp học --</option>
                                    <c:forEach var="c" items="${pageData.classOptions}">
                                        <option value="${c.classId}" ${pageData.classId == c.classId ? 'selected' : ''}>
                                            <c:out value="${c.classCode}"/> - <c:out value="${c.className}"/> (<c:out value="${c.currentEnrolled}"/>/<c:out value="${c.capacity}"/>)
                                        </option>
                                    </c:forEach>
                                </select>
                                <svg class="mgmt-select-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="6 9 12 15 18 9"></polyline>
                                </svg>
                            </div>
                        </div>

                        <div class="mgmt-filter-item" style="max-width: 220px;">
                            <label class="mgmt-label" for="filterStatus">Trạng thái ghi danh</label>
                            <div class="mgmt-select-wrap">
                                <select name="status" id="filterStatus" class="mgmt-select">
                                    <option value="">-- Trạng thái --</option>
                                    <option value="ACTIVE" ${pageData.status == 'ACTIVE' ? 'selected' : ''}>Đang học (ACTIVE)</option>
                                    <option value="RESERVED" ${pageData.status == 'RESERVED' ? 'selected' : ''}>Bảo lưu (RESERVED)</option>
                                    <option value="TRANSFERRED" ${pageData.status == 'TRANSFERRED' ? 'selected' : ''}>Đã chuyển lớp (TRANSFERRED)</option>
                                    <option value="DROPPED" ${pageData.status == 'DROPPED' ? 'selected' : ''}>Thôi học (DROPPED)</option>
                                    <option value="COMPLETED" ${pageData.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành (COMPLETED)</option>
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
                                <span>Lọc kết quả</span>
                            </button>
                            <c:if test="${not empty pageData.keyword or not empty pageData.status or not empty pageData.classId}">
                                <a href="${baseEnrollPath}" class="mgmt-btn mgmt-btn-outline" title="Xóa bộ lọc">
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

                <!-- Primary Roster & Allocation Datagrid -->
                <div class="mgmt-table-card">
                    <!-- Table Meta Header -->
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-meta-left">
                            <span class="mgmt-table-meta-title">Danh sách Ghi danh & Xếp lớp</span>
                            <span class="mgmt-table-meta-badge"><c:out value="${pageData.totalRecords}" /> bản ghi</span>
                        </div>
                        <div class="mgmt-table-meta-right">
                            <button type="button" class="mgmt-btn-tool" onclick="location.reload()">
                                <svg class="mgmt-btn-tool-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <polyline points="23 4 23 10 17 10"></polyline>
                                    <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                                </svg>
                                <span>Làm mới</span>
                            </button>
                        </div>
                    </div>

                    <!-- Datagrid -->
                    <div class="mgmt-table-responsive">
                        <table class="mgmt-table">
                            <thead>
                                <tr>
                                    <th style="width: 48px; text-align: center;">#</th>
                                    <th style="min-width: 200px;">Học viên</th>
                                    <th style="min-width: 260px;">Lớp học & Môn</th>
                                    <th style="text-align: right; width: 140px;">Học phí khóa</th>
                                    <th style="width: 160px;">Ngày bắt đầu</th>
                                    <th style="text-align: center; width: 130px;">Trạng thái</th>
                                    <th style="width: 140px;">Hóa đơn</th>
                                    <th style="text-align: center; width: 130px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty pageData.items}">
                                        <c:forEach var="item" items="${pageData.items}" varStatus="loop">
                                            <tr>
                                                <td class="align-top text-center" style="color: var(--text-muted); font-size: 12.5px;">
                                                    ${(pageData.currentPage - 1) * pageData.pageSize + loop.count}
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 14px; font-weight: 700; color: var(--text);">
                                                            <c:out value="${item.studentName}" />
                                                        </span>
                                                        <div style="font-size: 11.5px; color: var(--text-muted); display: flex; align-items: center; gap: 6px; margin-top: 2px;">
                                                            <span class="mgmt-code-badge" style="padding: 1px 6px; font-size: 11px;"><c:out value="${item.studentCode}" /></span>
                                                            <c:if test="${not empty item.studentPhone}">
                                                                <span>• <c:out value="${item.studentPhone}" /></span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-top">
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 13.5px; font-weight: 600; color: var(--text);">
                                                            <c:out value="${item.className}" />
                                                        </span>
                                                        <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                            Mã lớp: <code style="font-weight: 600; color: var(--primary);"><c:out value="${item.classCode}" /></code> • Môn: <c:out value="${item.subjectName}" />
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="align-top" style="text-align: right; font-weight: 700; color: var(--primary); font-size: 14px;">
                                                    <fmt:formatNumber value="${item.courseFee}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                                </td>
                                                <td class="align-top" style="font-size: 12.5px;">
                                                    <div style="font-weight: 600; color: var(--text);"><c:out value="${item.startDate}" /></div>
                                                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">
                                                        Ghi danh: <c:out value="${item.enrolledAtFormatted}" />
                                                    </div>
                                                </td>
                                                <td class="align-top text-center">
                                                    <c:choose>
                                                        <c:when test="${item.status == 'ACTIVE'}">
                                                            <span class="badge-status badge-enrolled-active">
                                                                <span class="mgmt-dot mgmt-dot-pulse"></span>
                                                                <span>Đang học</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'RESERVED'}">
                                                            <span class="badge-status badge-enrolled-reserved">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Bảo lưu</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'TRANSFERRED'}">
                                                            <span class="badge-status badge-enrolled-transferred">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Đã chuyển lớp</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'DROPPED'}">
                                                            <span class="badge-status badge-enrolled-dropped">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Thôi học</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'COMPLETED'}">
                                                            <span class="badge-status badge-cancelled">
                                                                <span class="mgmt-dot"></span>
                                                                <span>Hoàn thành</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status badge-empty"><c:out value="${item.status}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top">
                                                    <c:choose>
                                                        <c:when test="${not empty item.invoiceCode}">
                                                            <div style="display: flex; flex-direction: column; gap: 3px;">
                                                                <a href="${pageContext.request.contextPath}/staff/invoices/detail?id=${item.invoiceId}" style="font-size: 12px; font-weight: 600; color: var(--primary); text-decoration: none;">
                                                                    <c:out value="${item.invoiceCode}" />
                                                                </a>
                                                                <div>
                                                                    <c:choose>
                                                                        <c:when test="${item.invoiceStatus == 'PAID'}">
                                                                            <span class="badge-status badge-paid" style="font-size: 10px; padding: 1.5px 6px;">PAID</span>
                                                                        </c:when>
                                                                        <c:when test="${item.invoiceStatus == 'PARTIALLY_PAID'}">
                                                                            <span class="badge-status badge-partial" style="font-size: 10px; padding: 1.5px 6px;">PARTIAL</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge-status badge-unpaid" style="font-size: 10px; padding: 1.5px 6px;">UNPAID</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-muted); font-size: 12px; font-style: italic;">Chưa phát sinh</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="align-top text-center">
                                                    <div style="display: flex; align-items: center; justify-content: center; gap: 5px;">
                                                        <c:if test="${item.status == 'ACTIVE'}">
                                                            <!-- Nút Chuyển lớp -->
                                                            <button type="button" class="mgmt-btn-icon-sq" title="Chuyển lớp học cho học viên"
                                                                    data-id="${item.enrollmentId}"
                                                                    data-student-name="<c:out value='${item.studentName}'/>"
                                                                    data-class-id="${item.classId}"
                                                                    data-class-name="<c:out value='${item.className}'/>"
                                                                    onclick="openTransferModalFromBtn(this)">
                                                                <svg class="mgmt-btn-icon" style="color: #0284c7;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <path d="m16 3 4 4-4 4"></path>
                                                                    <path d="M20 7H4"></path>
                                                                    <path d="m8 21-4-4 4-4"></path>
                                                                    <path d="M4 17h16"></path>
                                                                </svg>
                                                            </button>
                                                            <!-- Nút Bảo lưu -->
                                                            <button type="button" class="mgmt-btn-icon-sq" title="Bảo lưu học tập"
                                                                    data-id="${item.enrollmentId}"
                                                                    data-student-name="<c:out value='${item.studentName}'/>"
                                                                    data-class-name="<c:out value='${item.className}'/>"
                                                                    onclick="openReserveModalFromBtn(this)">
                                                                <svg class="mgmt-btn-icon" style="color: #b45309;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10"></circle>
                                                                    <polyline points="12 6 12 12 16 14"></polyline>
                                                                </svg>
                                                            </button>
                                                            <!-- Nút Thôi học -->
                                                            <button type="button" class="mgmt-btn-icon-sq" title="Thôi học / Rút hồ sơ"
                                                                    data-id="${item.enrollmentId}"
                                                                    data-student-name="<c:out value='${item.studentName}'/>"
                                                                    data-class-name="<c:out value='${item.className}'/>"
                                                                    onclick="openDropModalFromBtn(this)">
                                                                <svg class="mgmt-btn-icon" style="color: #dc2626;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                    <circle cx="12" cy="12" r="10"></circle>
                                                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                                                </svg>
                                                            </button>
                                                        </c:if>

                                                        <c:if test="${item.status == 'RESERVED'}">
                                                            <!-- Nút Phục hồi học tập -->
                                                            <form action="${baseEnrollPath}/resume" method="post" style="display: inline;"
                                                                  data-student-name="<c:out value='${item.studentName}'/>"
                                                                  onsubmit="return confirm('Xác nhận phục hồi học tập cho học viên ' + this.getAttribute('data-student-name') + '? (Sẽ kiểm tra sĩ số lớp)');">
                                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                                <input type="hidden" name="enrollmentId" value="${item.enrollmentId}">
                                                                <button type="submit" class="mgmt-btn-icon-sq" style="color: #16a34a;" title="Quay lại học tập (Resume)">
                                                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                                        <polyline points="23 4 23 10 17 10"></polyline>
                                                                        <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                                                                    </svg>
                                                                </button>
                                                            </form>
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
                                                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="9" cy="7" r="4"></circle>
                                                            <polyline points="16 11 18 13 22 9"></polyline>
                                                        </svg>
                                                    </div>
                                                    <h3 class="mgmt-empty-title">Chưa có dữ liệu ghi danh</h3>
                                                    <p class="mgmt-empty-desc">
                                                        Chưa có học viên nào được ghi danh theo bộ lọc này hoặc trung tâm chưa khởi tạo lượt ghi danh nào.
                                                    </p>
                                                    <button type="button" class="mgmt-btn mgmt-btn-primary" onclick="openEnrollModal()">
                                                        <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                                        </svg>
                                                        <span>Ghi danh học viên ngay</span>
                                                    </button>
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
                                <span>Hiển thị trang <strong style="color: var(--text);">${pageData.currentPage}</strong> / <strong style="color: var(--text);">${pageData.totalPages}</strong> (Tổng số <strong style="color: var(--primary);">${pageData.totalRecords}</strong> bản ghi)</span>
                            </div>
                            <div class="mgmt-pagination">
                                <c:if test="${pageData.hasPrevious()}">
                                    <a href="${baseEnrollPath}?page=${pageData.currentPage - 1}&classId=${pageData.classId}&status=${pageData.status}&q=${pageData.keyword}" class="mgmt-page-btn">
                                        <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="15 18 9 12 15 6"></polyline>
                                        </svg>
                                    </a>
                                </c:if>
                                <c:forEach begin="1" end="${pageData.totalPages}" var="p">
                                    <a href="${baseEnrollPath}?page=${p}&classId=${pageData.classId}&status=${pageData.status}&q=${pageData.keyword}"
                                       class="mgmt-page-btn ${p == pageData.currentPage ? 'active' : ''}">${p}</a>
                                </c:forEach>
                                <c:if test="${pageData.hasNext()}">
                                    <a href="${baseEnrollPath}?page=${pageData.currentPage + 1}&classId=${pageData.classId}&status=${pageData.status}&q=${pageData.keyword}" class="mgmt-page-btn">
                                        <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <polyline points="9 18 15 12 9 6"></polyline>
                                        </svg>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>


            </div>
        </main>
    </div>
</div>

<!-- Modal 1: Ghi danh mới (Save Enrollment) -->
<div class="mgmt-modal-overlay" id="enrollModal">
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
                    <h3 class="mgmt-modal-title">Ghi danh & Xếp lớp học viên</h3>
                    <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">Cấp mã lớp và khởi tạo hóa đơn thu phí</p>
                </div>
            </div>
            <button type="button" class="mgmt-btn-icon-sq" onclick="closeModal('enrollModal')">
                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form action="${baseEnrollPath}/save" method="post" id="enrollForm" onsubmit="return validateEnrollSubmit(event);">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="leadId" value="<c:out value='${preselectedLeadId}' />">
            <div class="mgmt-modal-body">
                <div class="mgmt-callout primary" style="margin-bottom: 16px;">
                    <svg class="mgmt-callout-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="16" x2="12" y2="12"></line>
                        <line x1="12" y1="8" x2="12.01" y2="8"></line>
                    </svg>
                    <div>
                        <strong>Quy tắc nghiệp vụ:</strong> Học viên bắt buộc phải nộp học phí trước khi ghi danh (BR12). Hệ thống tự động kiểm tra sĩ số (BR04), đối soát xung đột TKB (BR07) và đồng bộ trạng thái trong cùng một giao dịch.
                    </div>
                </div>

                <!-- Chọn học sinh -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label" for="enrollStudentSelect">Chọn học viên tiếp nhận <span style="color: #dc2626;">*</span></label>
                    <select name="studentId" id="enrollStudentSelect" class="mgmt-select" required onchange="handleStudentChange(this)">
                        <option value="">-- Chọn học viên từ danh sách hồ sơ --</option>
                        <c:forEach var="s" items="${pageData.studentOptions}">
                            <option value="${s.id}" ${preselectedStudentId == s.id ? 'selected' : ''}>
                                <c:out value="${s.fullName}"/> - Mã: <c:out value="${s.code}"/> (<c:out value="${s.phone}"/>)
                            </option>
                        </c:forEach>
                    </select>
                    <!-- Badge nhận diện khóa học đã đăng ký -->
                    <div id="studentRegistrationBadge" style="display:none; margin-top: 6px; font-size: 12px; color: var(--primary); background: rgba(37, 99, 235, 0.08); padding: 6px 10px; border-radius: 6px; align-items: center; gap: 6px;">
                        <svg style="width: 14px; height: 14px; flex-shrink: 0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="20 6 9 17 4 12"></polyline>
                        </svg>
                        <span id="studentRegistrationText">Học viên đã đăng ký khóa học</span>
                    </div>
                </div>

                <!-- Chọn khóa học -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label" for="enrollCourseSelect">Khóa học đăng ký tiếp nhận <span style="color: #dc2626;">*</span></label>
                    <select name="courseId" id="enrollCourseSelect" class="mgmt-select" required onchange="handleCourseChange(this.value)">
                        <option value="">-- Chọn khóa học tiếp nhận --</option>
                        <c:forEach var="crs" items="${pageData.courseOptions}">
                            <option value="${crs.id}" data-code="${crs.code}" data-name="${crs.name}" data-fee="${crs.tuitionFee}">
                                [<c:out value="${crs.code}"/>] <c:out value="${crs.name}"/> - <fmt:formatNumber value="${crs.tuitionFee}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Chọn lớp học tiếp nhận -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label" for="enrollClassSelect">Chọn lớp học tiếp nhận <span style="color: #dc2626;">*</span></label>
                    <select name="classId" id="enrollClassSelect" class="mgmt-select" required onchange="handleClassSelectChange(this)">
                        <option value="" data-fee="0" data-start="">-- Vui lòng chọn khóa học trước --</option>
                    </select>

                    <!-- Alert thông báo khi không có lớp phù hợp hoặc hết chỗ / không có lịch trống -->
                    <div id="noClassAlert" style="display:none; margin-top: 8px; border-left: 4px solid #f59e0b; background: rgba(245, 158, 11, 0.08); padding: 10px 12px; border-radius: 6px;">
                        <div style="display: flex; gap: 8px; align-items: flex-start;">
                            <svg style="width: 18px; height: 18px; color: #d97706; flex-shrink: 0; margin-top: 2px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                            <div>
                                <strong style="color: #b45309; font-size: 13px;">Không có lớp học phù hợp còn lịch trống hoặc còn chỗ!</strong>
                                <p style="margin: 3px 0 6px 0; font-size: 12px; color: var(--text-muted); line-height: 1.4;">
                                    Hiện không tìm thấy lớp học nào thuộc khóa học này có lịch trống hoặc còn chỗ trống để tiếp nhận học viên. Vui lòng tạo thêm lớp mới hoặc sắp xếp lại thời khóa biểu trước khi ghi danh.
                                </p>
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.admin}">
                                        <a href="${pageContext.request.contextPath}/admin/classes" target="_blank" class="mgmt-btn mgmt-btn-outline" style="padding: 4px 10px; font-size: 12px; display: inline-flex; align-items: center; gap: 5px;">
                                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                                            <span>+ Mở trang tạo lớp học mới</span>
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="font-size: 12px; color: #b45309; font-weight: 500;">(Vui lòng liên hệ Quản trị viên/Học vụ để mở thêm lớp học)</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Ngày bắt đầu học -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label" for="enrollStartDate">Ngày bắt đầu học <span style="color: #dc2626;">*</span></label>
                    <input type="date" name="startDate" id="enrollStartDate" class="mgmt-input" required onchange="validateEnrollFormState()">
                    <small style="color: var(--text-muted); font-size: 11.5px; margin-top: 4px; display: block;">
                        Ngày bắt đầu phải nằm trong khoảng thời gian khai giảng và kết thúc của lớp.
                    </small>
                </div>

                <!-- Thẻ Xác nhận nộp tiền (Bắt buộc) -->
                <div style="margin-top: 16px; border: 1px solid var(--border); border-radius: 8px; padding: 14px; background: var(--surface);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <span style="font-weight: 700; font-size: 13.5px; color: var(--text); display: flex; align-items: center; gap: 6px;">
                            <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"></rect><line x1="2" x2="22" y1="10" y2="10"></line></svg>
                            HỌC PHÍ & THANH TOÁN (BẮT BUỘC)
                        </span>
                        <span id="feeAmountBadge" style="font-weight: 700; font-size: 15px; color: var(--primary);">0 đ</span>
                    </div>
                    <input type="hidden" name="paymentAmount" id="paymentAmountInput" value="0">

                    <div style="margin-bottom: 10px;">
                        <label style="display: flex; align-items: center; gap: 8px; cursor: pointer; user-select: none;">
                            <input type="checkbox" name="paymentConfirmed" id="paymentConfirmed" value="true" style="width: 17px; height: 17px; cursor: pointer;" onchange="handlePaymentConfirmedChange(this)">
                            <span style="font-weight: 600; font-size: 13px; color: var(--text);">
                                Xác nhận học viên đã nộp đủ tiền học phí <span style="color: #dc2626;">*</span>
                            </span>
                        </label>
                    </div>

                    <!-- Cảnh báo nếu chưa nộp tiền -->
                    <div id="unpaidNotice" style="border-left: 4px solid #dc2626; background: rgba(220, 38, 38, 0.08); padding: 8px 12px; border-radius: 4px;">
                        <span style="color: #dc2626; font-size: 12.5px; font-weight: 600; display: flex; align-items: center; gap: 6px;">
                            <svg style="width: 16px; height: 16px; flex-shrink: 0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            Chưa nộp tiền: Học viên bắt buộc phải nộp tiền học phí mới được ghi danh vào lớp!
                        </span>
                    </div>

                    <!-- Khối thông tin thanh toán khi đã tick xác nhận -->
                    <div id="paymentDetailsSection" style="display: none; margin-top: 12px; padding-top: 10px; border-top: 1px dashed var(--border);">
                        <div class="mgmt-form-group" style="margin-bottom: 10px;">
                            <label class="mgmt-label" style="font-size: 12px;">Phương thức nộp tiền <span style="color: #dc2626;">*</span></label>
                            <div style="display: flex; gap: 16px; font-size: 13px;">
                                <label style="display: flex; align-items: center; gap: 6px; cursor: pointer;">
                                    <input type="radio" name="paymentMethod" value="CASH" checked onchange="handlePaymentMethodChange(this.value)">
                                    <span>Tiền mặt tại quầy</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 6px; cursor: pointer;">
                                    <input type="radio" name="paymentMethod" value="BANK_TRANSFER" onchange="handlePaymentMethodChange(this.value)">
                                    <span>Chuyển khoản ngân hàng / QR</span>
                                </label>
                            </div>
                        </div>

                        <div class="mgmt-form-group" id="bankTransferGroup" style="display: none; margin-bottom: 0;">
                            <label class="mgmt-label" for="transactionRefInput" style="font-size: 12px;">Mã giao dịch / Mã tham chiếu ngân hàng <span style="color: #dc2626;">*</span></label>
                            <input type="text" name="transactionRef" id="transactionRefInput" class="mgmt-input" placeholder="Ví dụ: VCB-9823482, MB-192842..." oninput="validateEnrollFormState()">
                        </div>
                    </div>
                </div>

                <!-- Ghi chú -->
                <div class="mgmt-form-group" style="margin-top: 14px;">
                    <label class="mgmt-label" for="enrollNotes">Ghi chú ghi danh</label>
                    <textarea name="notes" id="enrollNotes" class="mgmt-textarea" rows="2" placeholder="Ví dụ: Đăng ký đợt 1, đã tư vấn lộ trình..."></textarea>
                </div>
            </div>
            <div class="mgmt-modal-footer">
                <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="closeModal('enrollModal')">Hủy bỏ</button>
                <button type="submit" id="btnSubmitEnroll" class="mgmt-btn mgmt-btn-primary" disabled>Xác nhận ghi danh</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 2: Chuyển lớp (Transfer Class) -->
<div class="mgmt-modal-overlay" id="transferModal">
    <div class="mgmt-modal-card">
        <div class="mgmt-modal-header">
            <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 34px; height: 34px; border-radius: 8px; background: rgba(2, 132, 199, 0.1); color: #0284c7; display: flex; align-items: center; justify-content: center;">
                    <svg style="width: 18px; height: 18px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="m16 3 4 4-4 4"></path>
                        <path d="M20 7H4"></path>
                        <path d="m8 21-4-4 4-4"></path>
                        <path d="M4 17h16"></path>
                    </svg>
                </div>
                <div>
                    <h3 class="mgmt-modal-title">Chuyển lớp học cho học viên</h3>
                    <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">Điều chuyển học sinh sang lớp cùng học phần</p>
                </div>
            </div>
            <button type="button" class="mgmt-btn-icon-sq" onclick="closeModal('transferModal')">
                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form action="${baseEnrollPath}/transfer" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="enrollmentId" id="transferEnrollmentId">
            <div class="mgmt-modal-body">
                <div class="mgmt-callout primary" style="margin-bottom: 16px;">
                    <div>
                        Học viên: <strong id="transferStudentName" style="color: var(--text);"></strong><br>
                        Lớp học hiện tại: <span id="transferCurrentClass" style="color: var(--text-muted);"></span>
                    </div>
                </div>

                <!-- Chọn lớp mới -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label">Lớp học chuyển đến <span style="color: #dc2626;">*</span></label>
                    <select name="newClassId" id="transferNewClassSelect" class="mgmt-select" required>
                        <option value="">-- Chọn lớp học mới còn chỗ --</option>
                        <c:forEach var="c" items="${pageData.classOptions}">
                            <option value="${c.classId}" ${c.full ? 'disabled' : ''}>
                                <c:out value="${c.classCode}"/> - <c:out value="${c.className}"/>
                                [Sĩ số: <c:out value="${c.currentEnrolled}"/>/<c:out value="${c.capacity}"/>]
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <!-- Ngày chuyển -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label">Ngày hiệu lực chuyển lớp</label>
                    <input type="date" name="transferDate" id="transferDate" class="mgmt-input">
                </div>

                <!-- Ghi chú lý do chuyển -->
                <div class="mgmt-form-group">
                    <label class="mgmt-label">Lý do chuyển lớp</label>
                    <textarea name="notes" class="mgmt-textarea" rows="2" placeholder="Nhập lý do chuyển lớp..."></textarea>
                </div>
            </div>
            <div class="mgmt-modal-footer">
                <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="closeModal('transferModal')">Đóng</button>
                <button type="submit" class="mgmt-btn mgmt-btn-primary">Xác nhận chuyển lớp</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 3: Bảo lưu học tập (Reserve) -->
<div class="mgmt-modal-overlay" id="reserveModal">
    <div class="mgmt-modal-card" style="max-width: 500px;">
        <div class="mgmt-modal-header">
            <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 34px; height: 34px; border-radius: 8px; background: rgba(180, 83, 9, 0.1); color: #b45309; display: flex; align-items: center; justify-content: center;">
                    <svg style="width: 18px; height: 18px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                </div>
                <div>
                    <h3 class="mgmt-modal-title">Bảo lưu học tập</h3>
                    <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">Tạm ngưng khóa học và giải phóng chỗ</p>
                </div>
            </div>
            <button type="button" class="mgmt-btn-icon-sq" onclick="closeModal('reserveModal')">
                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form action="${baseEnrollPath}/reserve" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="enrollmentId" id="reserveEnrollmentId">
            <div class="mgmt-modal-body">
                <p style="font-size: 13.5px; color: var(--text-muted); line-height: 1.5; margin: 0 0 14px 0;">
                    Xác nhận bảo lưu cho học viên <strong id="reserveStudentName" style="color: var(--text);"></strong> tại lớp <span id="reserveClassName" style="color: var(--primary); font-weight: 600;"></span>. Chỗ học trong lớp sẽ được giải phóng cho học viên khác.
                </p>
                <div class="mgmt-form-group">
                    <label class="mgmt-label">Lý do bảo lưu <span style="color: #dc2626;">*</span></label>
                    <textarea name="reason" class="mgmt-textarea" rows="3" required placeholder="Nhập lý do bảo lưu theo đơn yêu cầu..."></textarea>
                </div>
            </div>
            <div class="mgmt-modal-footer">
                <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="closeModal('reserveModal')">Hủy bỏ</button>
                <button type="submit" class="mgmt-btn" style="background: #eab308; color: #ffffff;">Bảo lưu ngay</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal 4: Thôi học / Hủy ghi danh (Drop) -->
<div class="mgmt-modal-overlay" id="dropModal">
    <div class="mgmt-modal-card" style="max-width: 500px;">
        <div class="mgmt-modal-header">
            <div style="display: flex; align-items: center; gap: 10px;">
                <div style="width: 34px; height: 34px; border-radius: 8px; background: rgba(220, 38, 38, 0.1); color: #dc2626; display: flex; align-items: center; justify-content: center;">
                    <svg style="width: 18px; height: 18px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
                </div>
                <div>
                    <h3 class="mgmt-modal-title" style="color: #dc2626;">Thôi học / Rút khỏi lớp</h3>
                    <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">Cập nhật trạng thái ngừng học tập</p>
                </div>
            </div>
            <button type="button" class="mgmt-btn-icon-sq" onclick="closeModal('dropModal')">
                <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form action="${baseEnrollPath}/status" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="enrollmentId" id="dropEnrollmentId">
            <input type="hidden" name="newStatus" value="DROPPED">
            <div class="mgmt-modal-body">
                <p style="font-size: 13.5px; color: var(--text-muted); line-height: 1.5; margin: 0 0 14px 0;">
                    Bạn có chắc chắn muốn cập nhật trạng thái <strong style="color: #dc2626;">THÔI HỌC (DROPPED)</strong> cho học viên <strong id="dropStudentName" style="color: var(--text);"></strong> tại lớp <span id="dropClassName" style="color: var(--primary); font-weight: 600;"></span>?
                </p>
                <div class="mgmt-form-group">
                    <label class="mgmt-label">Lý do thôi học</label>
                    <textarea name="reason" class="mgmt-textarea" rows="2" placeholder="Nhập lý do học viên dừng học..."></textarea>
                </div>
            </div>
            <div class="mgmt-modal-footer">
                <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="closeModal('dropModal')">Hủy</button>
                <button type="submit" class="mgmt-btn mgmt-btn-danger">Xác nhận thôi học</button>
            </div>
        </form>
    </div>
</div>

<script>
    window.INITIAL_CLASSES = [
        <c:forEach var="c" items="${pageData.classOptions}" varStatus="st">
        {
            classId: ${c.classId},
            classCode: "<c:out value='${c.classCode}'/>",
            className: "<c:out value='${c.className}'/>",
            courseId: ${c.courseId != null ? c.courseId : 'null'},
            courseCode: "<c:out value='${c.courseCode}'/>",
            fee: ${c.fee != null ? c.fee : 0},
            startDate: "<c:out value='${c.startDate}'/>",
            currentEnrolled: ${c.currentEnrolled},
            capacity: ${c.capacity},
            isFull: ${c.full},
            hasScheduleConflict: ${c.hasScheduleConflict},
            conflictReason: "<c:out value='${c.conflictReason}'/>"
        }${!st.last ? ',' : ''}
        </c:forEach>
    ];
    window.CURRENT_STUDENT_CLASSES = null;

    function openModal(id) {
        var el = document.getElementById(id);
        if (el) el.classList.add('active');
    }
    function closeModal(id) {
        var el = document.getElementById(id);
        if (el) el.classList.remove('active');
    }

    function formatCurrencyVND(amount) {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount || 0);
    }

    function openEnrollModal() {
        var startInput = document.getElementById('enrollStartDate');
        if (startInput && !startInput.value) {
            startInput.value = new Date().toISOString().split('T')[0];
        }
        var studentSelect = document.getElementById('enrollStudentSelect');
        if (studentSelect && studentSelect.value) {
            handleStudentChange(studentSelect);
        } else {
            validateEnrollFormState();
        }
        openModal('enrollModal');
    }

    function handleStudentChange(select) {
        var studentId = select.value;
        var badge = document.getElementById('studentRegistrationBadge');
        var badgeText = document.getElementById('studentRegistrationText');

        if (!studentId) {
            if (badge) badge.style.display = 'none';
            window.CURRENT_STUDENT_CLASSES = null;
            var courseSelect = document.getElementById('enrollCourseSelect');
            handleCourseChange(courseSelect ? courseSelect.value : '');
            return;
        }

        fetch('${baseEnrollPath}/student-options?studentId=' + encodeURIComponent(studentId))
            .then(function(res) {
                if (!res.ok) throw new Error('Network error');
                return res.json();
            })
            .then(function(data) {
                window.CURRENT_STUDENT_CLASSES = data.classes || [];
                var courseSelect = document.getElementById('enrollCourseSelect');
                if (data.registeredCourseIds && data.registeredCourseIds.length > 0) {
                    var regCourseId = data.registeredCourseIds[0];
                    if (courseSelect) {
                        courseSelect.value = regCourseId;
                        var opt = courseSelect.options[courseSelect.selectedIndex];
                        if (badge && badgeText) {
                            badgeText.textContent = 'Học viên đã đăng ký khóa học: ' + (opt ? opt.text : '');
                            badge.style.display = 'flex';
                        }
                    }
                } else {
                    if (badge) badge.style.display = 'none';
                }
                handleCourseChange(courseSelect ? courseSelect.value : '');
            })
            .catch(function(err) {
                console.warn('Could not load student options:', err);
                if (badge) badge.style.display = 'none';
                window.CURRENT_STUDENT_CLASSES = null;
                var courseSelect = document.getElementById('enrollCourseSelect');
                handleCourseChange(courseSelect ? courseSelect.value : '');
            });
    }

    function handleCourseChange(courseId) {
        var classSelect = document.getElementById('enrollClassSelect');
        var noClassAlert = document.getElementById('noClassAlert');
        var feeBadge = document.getElementById('feeAmountBadge');
        var feeInput = document.getElementById('paymentAmountInput');
        var courseSelect = document.getElementById('enrollCourseSelect');

        var courseFee = 0;
        if (courseSelect && courseSelect.selectedIndex > 0) {
            var selectedCourseOpt = courseSelect.options[courseSelect.selectedIndex];
            courseFee = parseFloat(selectedCourseOpt.getAttribute('data-fee') || '0');
        }
        if (feeBadge) feeBadge.textContent = formatCurrencyVND(courseFee);
        if (feeInput) feeInput.value = courseFee;

        classSelect.innerHTML = '';

        if (!courseId) {
            var opt = document.createElement('option');
            opt.value = '';
            opt.textContent = '-- Vui lòng chọn khóa học trước --';
            classSelect.appendChild(opt);
            if (noClassAlert) noClassAlert.style.display = 'none';
            validateEnrollFormState();
            return;
        }

        var sourceClasses = window.CURRENT_STUDENT_CLASSES || window.INITIAL_CLASSES;
        var matched = sourceClasses.filter(function(c) {
            return String(c.courseId) === String(courseId);
        });
        var available = matched.filter(function(c) {
            return !c.isFull && !c.hasScheduleConflict;
        });

        if (available.length === 0) {
            if (noClassAlert) noClassAlert.style.display = 'block';

            var emptyOpt = document.createElement('option');
            emptyOpt.value = '';
            emptyOpt.textContent = '-- Không có lớp phù hợp còn lịch trống hoặc còn chỗ --';
            classSelect.appendChild(emptyOpt);

            matched.forEach(function(c) {
                var opt = document.createElement('option');
                opt.value = c.classId;
                opt.disabled = true;
                var reason = c.isFull ? 'ĐÃ ĐẦY SĨ SỐ' : (c.hasScheduleConflict ? ('TRÙNG LỊCH: ' + (c.conflictReason || '')) : 'KHÔNG KHẢ DỤNG');
                opt.textContent = c.classCode + ' - ' + c.className + ' [' + c.currentEnrolled + '/' + c.capacity + '] (' + reason + ')';
                classSelect.appendChild(opt);
            });
        } else {
            if (noClassAlert) noClassAlert.style.display = 'none';

            var defaultOpt = document.createElement('option');
            defaultOpt.value = '';
            defaultOpt.setAttribute('data-fee', courseFee);
            defaultOpt.setAttribute('data-start', '');
            defaultOpt.textContent = '-- Chọn lớp học phù hợp (' + available.length + ' lớp khả dụng) --';
            classSelect.appendChild(defaultOpt);

            matched.forEach(function(c) {
                var opt = document.createElement('option');
                opt.value = c.classId;
                opt.setAttribute('data-fee', c.fee || courseFee);
                opt.setAttribute('data-start', c.startDate || '');
                var statusText = '';
                if (c.isFull) {
                    opt.disabled = true;
                    statusText = ' - ĐÃ ĐẦY';
                } else if (c.hasScheduleConflict) {
                    opt.disabled = true;
                    statusText = ' - TRÙNG LỊCH: ' + (c.conflictReason || '');
                }
                opt.textContent = c.classCode + ' - ' + c.className + ' [Sĩ số: ' + c.currentEnrolled + '/' + c.capacity + ']' + statusText;
                classSelect.appendChild(opt);
            });
        }

        handleClassSelectChange(classSelect);
    }

    function handleClassSelectChange(select) {
        if (!select || select.selectedIndex < 0) {
            validateEnrollFormState();
            return;
        }
        var option = select.options[select.selectedIndex];
        var startDate = option.getAttribute('data-start');
        if (startDate && startDate !== "") {
            var startInput = document.getElementById('enrollStartDate');
            if (startInput) startInput.value = startDate;
        }
        var fee = option.getAttribute('data-fee');
        if (fee && parseFloat(fee) > 0) {
            var feeBadge = document.getElementById('feeAmountBadge');
            var feeInput = document.getElementById('paymentAmountInput');
            if (feeBadge) feeBadge.textContent = formatCurrencyVND(parseFloat(fee));
            if (feeInput) feeInput.value = fee;
        }
        validateEnrollFormState();
    }

    function handlePaymentConfirmedChange(cb) {
        var unpaidNotice = document.getElementById('unpaidNotice');
        var paymentDetails = document.getElementById('paymentDetailsSection');
        if (cb.checked) {
            if (unpaidNotice) unpaidNotice.style.display = 'none';
            if (paymentDetails) paymentDetails.style.display = 'block';
        } else {
            if (unpaidNotice) unpaidNotice.style.display = 'block';
            if (paymentDetails) paymentDetails.style.display = 'none';
        }
        validateEnrollFormState();
    }

    function handlePaymentMethodChange(val) {
        var bankGroup = document.getElementById('bankTransferGroup');
        if (bankGroup) {
            bankGroup.style.display = (val === 'BANK_TRANSFER') ? 'block' : 'none';
        }
        validateEnrollFormState();
    }

    function validateEnrollFormState() {
        var studentSelect = document.getElementById('enrollStudentSelect');
        var courseSelect = document.getElementById('enrollCourseSelect');
        var classSelect = document.getElementById('enrollClassSelect');
        var startInput = document.getElementById('enrollStartDate');
        var paymentCb = document.getElementById('paymentConfirmed');
        var submitBtn = document.getElementById('btnSubmitEnroll');

        var studentId = studentSelect ? studentSelect.value : '';
        var courseId = courseSelect ? courseSelect.value : '';
        var classId = classSelect ? classSelect.value : '';
        var startDate = startInput ? startInput.value : '';
        var paymentConfirmed = paymentCb ? paymentCb.checked : false;

        var methodEl = document.querySelector('input[name="paymentMethod"]:checked');
        var method = methodEl ? methodEl.value : 'CASH';
        var txRefInput = document.getElementById('transactionRefInput');
        var txRef = txRefInput ? txRefInput.value.trim() : '';

        var validPayment = paymentConfirmed;
        if (method === 'BANK_TRANSFER' && !txRef) {
            validPayment = false;
        }

        var isComplete = (studentId !== '' && courseId !== '' && classId !== '' && startDate !== '' && validPayment);
        if (submitBtn) {
            submitBtn.disabled = !isComplete;
        }
        return isComplete;
    }

    function validateEnrollSubmit(event) {
        var paymentCb = document.getElementById('paymentConfirmed');
        if (!paymentCb || !paymentCb.checked) {
            alert('Học viên chưa nộp tiền học phí! Bắt buộc phải nộp tiền trước khi thực hiện ghi danh.');
            event.preventDefault();
            return false;
        }
        var classSelect = document.getElementById('enrollClassSelect');
        if (!classSelect || !classSelect.value) {
            alert('Vui lòng chọn lớp học tiếp nhận phù hợp còn chỗ và lịch trống.');
            event.preventDefault();
            return false;
        }
        var methodEl = document.querySelector('input[name="paymentMethod"]:checked');
        var method = methodEl ? methodEl.value : 'CASH';
        var txRefInput = document.getElementById('transactionRefInput');
        if (method === 'BANK_TRANSFER' && (!txRefInput || !txRefInput.value.trim())) {
            alert('Vui lòng nhập Mã giao dịch / Mã tham chiếu ngân hàng khi nộp bằng chuyển khoản.');
            if (txRefInput) txRefInput.focus();
            event.preventDefault();
            return false;
        }
        return true;
    }

    function openTransferModalFromBtn(btn) {
        if (!btn) return;
        openTransferModal(
            btn.getAttribute('data-id'),
            btn.getAttribute('data-student-name'),
            btn.getAttribute('data-class-id'),
            btn.getAttribute('data-class-name')
        );
    }

    function openReserveModalFromBtn(btn) {
        if (!btn) return;
        openReserveModal(
            btn.getAttribute('data-id'),
            btn.getAttribute('data-student-name'),
            btn.getAttribute('data-class-name')
        );
    }

    function openDropModalFromBtn(btn) {
        if (!btn) return;
        openDropModal(
            btn.getAttribute('data-id'),
            btn.getAttribute('data-student-name'),
            btn.getAttribute('data-class-name')
        );
    }

    function openTransferModal(id, studentName, classId, className) {
        document.getElementById('transferEnrollmentId').value = id;
        document.getElementById('transferStudentName').textContent = studentName;
        document.getElementById('transferCurrentClass').textContent = className;

        var transferDateInput = document.getElementById('transferDate');
        if (transferDateInput && !transferDateInput.value) {
            transferDateInput.value = new Date().toISOString().split('T')[0];
        }

        var select = document.getElementById('transferNewClassSelect');
        for (var i = 0; i < select.options.length; i++) {
            if (select.options[i].value === classId) {
                select.options[i].disabled = true;
            }
        }
        openModal('transferModal');
    }

    function openReserveModal(id, studentName, className) {
        document.getElementById('reserveEnrollmentId').value = id;
        document.getElementById('reserveStudentName').textContent = studentName;
        document.getElementById('reserveClassName').textContent = className;
        openModal('reserveModal');
    }

    function openDropModal(id, studentName, className) {
        document.getElementById('dropEnrollmentId').value = id;
        document.getElementById('dropStudentName').textContent = studentName;
        document.getElementById('dropClassName').textContent = className;
        openModal('dropModal');
    }

    window.addEventListener('click', function(event) {
        var modals = document.querySelectorAll('.mgmt-modal-overlay.active');
        modals.forEach(function(modal) {
            if (event.target === modal) {
                modal.classList.remove('active');
            }
        });
    });

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            var activeModals = document.querySelectorAll('.mgmt-modal-overlay.active');
            activeModals.forEach(function(m) { m.classList.remove('active'); });
        }
    });

    <c:if test="${autoOpenModal}">
    document.addEventListener('DOMContentLoaded', function() {
        openEnrollModal();
    });
    </c:if>
</script>
</body>
</html>
