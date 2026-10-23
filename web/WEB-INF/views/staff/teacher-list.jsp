<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .kpi-row {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 1200px) {
            .kpi-row { grid-template-columns: repeat(3, 1fr); }
        }
        @media (max-width: 768px) {
            .kpi-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 480px) {
            .kpi-row { grid-template-columns: 1fr; }
        }
        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 18px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .kpi-icon-wrap {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-subtle);
            color: var(--primary);
            flex-shrink: 0;
        }
        .kpi-icon-wrap.success { background: var(--success-subtle); color: var(--success); }
        .kpi-icon-wrap.warning { background: var(--warning-subtle); color: var(--warning); }
        .kpi-icon-wrap.neutral { background: var(--bg); color: var(--text-muted); }
        .kpi-icon-wrap.info { background: var(--primary-subtle); color: var(--primary); }
        .kpi-val {
            font-size: 22px;
            font-weight: 700;
            color: var(--text);
            line-height: 1.2;
        }
        .kpi-lbl {
            font-size: 11px;
            color: var(--text-muted);
            font-weight: 500;
            margin-top: 2px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .content-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin-bottom: 24px;
        }
        .filter-panel {
            padding: 20px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }
        .filter-grid {
            display: grid;
            grid-template-columns: 2fr 1.2fr 1.2fr auto;
            gap: 12px;
            align-items: flex-end;
        }
        @media (max-width: 992px) {
            .filter-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px) {
            .filter-grid { grid-template-columns: 1fr; }
        }
        .teacher-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .teacher-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--primary-subtle);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            flex-shrink: 0;
            overflow: hidden;
        }
        .teacher-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .degree-badge {
            font-size: 11px;
            font-weight: 600;
            padding: 2px 8px;
            border-radius: var(--radius-xs);
            background: var(--primary-subtle);
            color: var(--primary);
            display: inline-block;
            margin-bottom: 3px;
        }
        .rate-cell {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-weight: 600;
            font-size: 13px;
            color: var(--text);
        }
        .classes-count-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text);
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 9999px;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
        .status-badge.active { background: var(--success-subtle); color: var(--success); }
        .status-badge.on_leave { background: var(--warning-subtle); color: var(--warning); }
        .status-badge.inactive { background: var(--bg); color: var(--text-muted); border: 1px solid var(--border); }
        .pagination-bar {
            padding: 14px 20px;
            border-top: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--surface);
        }
        .page-link-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 34px;
            height: 34px;
            padding: 0 8px;
            border: 1px solid var(--border);
            border-radius: var(--radius-xs);
            background: var(--surface);
            color: var(--text);
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all var(--transition-fast);
        }
        .page-link-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
        }
        .page-link-btn.active {
            background: var(--primary);
            color: #ffffff;
            border-color: var(--primary);
        }
        .page-link-btn.disabled {
            opacity: 0.4;
            pointer-events: none;
        }
        .action-btns {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .btn-icon {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-xs);
            border: 1px solid var(--border);
            background: var(--surface);
            color: var(--text);
            cursor: pointer;
            text-decoration: none;
            transition: all var(--transition-fast);
        }
        .btn-icon:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-subtle);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="teachers" scope="request" />
        <c:set var="breadcrumb" value="Đội ngũ Giáo viên" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Page Header -->
                <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                            <a href="${pageContext.request.contextPath}/staff/teachers" style="color: var(--text-muted); text-decoration: none;">Đào tạo & Học vụ</a> / <span>Đội ngũ Giáo viên</span>
                        </div>
                        <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                            Hồ sơ Giáo viên & Phân công chuyên môn
                        </h1>
                        <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                            Quản lý hồ sơ giảng viên, phân công chuyên môn môn học, định mức thù lao và theo dõi trạng thái công tác (ADM-09, UC12).
                        </p>
                    </div>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <a href="${pageContext.request.contextPath}/staff/teachers/form" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            Thêm mới Giáo viên
                        </a>
                    </div>
                </div>

                <!-- Toast Alert -->
                <c:if test="${not empty toastMessage}">
                    <div class="toast-alert ${toastType == 'success' ? 'toast-success' : 'toast-error'}" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: ${toastType == 'success' ? 'var(--success-subtle)' : 'var(--danger-subtle)'}; color: ${toastType == 'success' ? 'var(--success)' : 'var(--danger)'}; border: 1px solid ${toastType == 'success' ? 'rgba(22, 163, 74, 0.2)' : 'rgba(220, 38, 38, 0.2)'};">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <c:choose>
                                <c:when test="${toastType == 'success'}">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </c:when>
                                <c:otherwise>
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                </c:otherwise>
                            </c:choose>
                        </svg>
                        <span>${toastMessage}</span>
                    </div>
                </c:if>

                <!-- KPI Cards Row -->
                <div class="kpi-row">
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap info">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.totalTeachers}</div>
                            <div class="kpi-lbl">Tổng giáo viên</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap success">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.activeTeachers}</div>
                            <div class="kpi-lbl">Đang giảng dạy</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap warning">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.onLeaveTeachers}</div>
                            <div class="kpi-lbl">Tạm nghỉ / Nghỉ phép</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap neutral">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.inactiveTeachers}</div>
                            <div class="kpi-lbl">Ngừng công tác</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap info">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.totalActiveClasses}</div>
                            <div class="kpi-lbl">Lớp đang phụ trách</div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Card -->
                <div class="content-card">
                    <!-- Filter Panel -->
                    <div class="filter-panel">
                        <form method="get" action="${pageContext.request.contextPath}/staff/teachers" class="filter-grid">
                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="font-size: 12px; margin-bottom: 4px;">Tìm kiếm</label>
                                <input type="text" name="q" value="${filterQ}" class="form-control" placeholder="Họ tên, SĐT, email, môn giảng dạy...">
                            </div>

                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="font-size: 12px; margin-bottom: 4px;">Trạng thái công tác</label>
                                <select name="status" class="form-control">
                                    <option value="ALL" ${filterStatus == 'ALL' or empty filterStatus ? 'selected' : ''}>Tất cả trạng thái</option>
                                    <option value="ACTIVE" ${filterStatus == 'ACTIVE' ? 'selected' : ''}>Đang giảng dạy (ACTIVE)</option>
                                    <option value="ON_LEAVE" ${filterStatus == 'ON_LEAVE' ? 'selected' : ''}>Nghỉ phép (ON_LEAVE)</option>
                                    <option value="INACTIVE" ${filterStatus == 'INACTIVE' ? 'selected' : ''}>Ngừng công tác (INACTIVE)</option>
                                </select>
                            </div>

                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="font-size: 12px; margin-bottom: 4px;">Sắp xếp</label>
                                <select name="sort" class="form-control">
                                    <option value="newest" ${filterSort == 'newest' or empty filterSort ? 'selected' : ''}>Mới nhất trước</option>
                                    <option value="name_asc" ${filterSort == 'name_asc' ? 'selected' : ''}>Họ tên A → Z</option>
                                </select>
                            </div>

                            <div style="display: flex; gap: 8px;">
                                <button type="submit" class="btn btn-primary" style="height: 38px; display: inline-flex; align-items: center; gap: 6px;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                    </svg>
                                    Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/staff/teachers" class="btn btn-secondary" style="height: 38px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none;">
                                    Xóa lọc
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Data Table -->
                    <div class="table-responsive">
                        <table class="data-table" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th style="padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">GIÁO VIÊN</th>
                                    <th style="padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">LIÊN HỆ</th>
                                    <th style="padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">HỌC VỊ & CHUYÊN MÔN</th>
                                    <th style="padding: 14px 16px; text-align: right; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">THÙ LAO THAM KHẢO</th>
                                    <th style="padding: 14px 16px; text-align: center; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">LỚP PHỤ TRÁCH</th>
                                    <th style="padding: 14px 16px; text-align: center; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">TRẠNG THÁI</th>
                                    <th style="padding: 14px 16px; text-align: right; font-size: 12px; font-weight: 700; color: var(--text-muted); border-bottom: 1px solid var(--border);">THAO TÁC</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty teachers}">
                                        <c:forEach var="item" items="${teachers}">
                                            <tr style="border-bottom: 1px solid var(--border); transition: background var(--transition-fast);">
                                                <!-- Giáo viên -->
                                                <td style="padding: 14px 16px;">
                                                    <div class="teacher-cell">
                                                        <div class="teacher-avatar">
                                                            <c:choose>
                                                                <c:when test="${not empty item.avatarUrl}">
                                                                    <img src="${item.avatarUrl}" alt="${item.fullName}">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${item.fullName.substring(0, 1).toUpperCase()}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div>
                                                            <div style="font-weight: 700; color: var(--text); font-size: 14px;">${item.fullName}</div>
                                                            <div style="font-size: 12px; color: var(--text-muted);">Tài khoản: ${item.userEmail}</div>
                                                        </div>
                                                    </div>
                                                </td>

                                                <!-- Liên hệ -->
                                                <td style="padding: 14px 16px;">
                                                    <div style="font-size: 13px; color: var(--text);">${not empty item.phone ? item.phone : '—'}</div>
                                                    <div style="font-size: 12px; color: var(--text-muted);">${not empty item.email ? item.email : '—'}</div>
                                                </td>

                                                <!-- Học vị & Chuyên môn -->
                                                <td style="padding: 14px 16px;">
                                                    <c:if test="${not empty item.degree}">
                                                        <span class="degree-badge">${item.degree}</span><br>
                                                    </c:if>
                                                    <span style="font-size: 13px; color: var(--text);">${not empty item.specialization ? item.specialization : 'Chưa phân công môn'}</span>
                                                </td>

                                                <!-- Thù lao -->
                                                <td style="padding: 14px 16px; text-align: right;">
                                                    <span class="rate-cell">${item.formattedHourlyRate}</span>
                                                </td>

                                                <!-- Lớp phụ trách -->
                                                <td style="padding: 14px 16px; text-align: center;">
                                                    <span class="classes-count-badge">
                                                        <span style="color: var(--primary); font-weight: 700;">${item.activeClassesCount}</span>
                                                        <span style="color: var(--text-muted);">/ ${item.totalClassesCount} lớp</span>
                                                    </span>
                                                </td>

                                                <!-- Trạng thái -->
                                                <td style="padding: 14px 16px; text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${item.status == 'ACTIVE'}">
                                                            <span class="status-badge active">Đang dạy</span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'ON_LEAVE'}">
                                                            <span class="status-badge on_leave">Nghỉ phép</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge inactive">Ngừng dạy</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Thao tác -->
                                                <td style="padding: 14px 16px; text-align: right;">
                                                    <div class="action-btns" style="justify-content: flex-end;">
                                                        <a href="${pageContext.request.contextPath}/staff/teachers/form?id=${item.id}" class="btn-icon" title="Chỉnh sửa hồ sơ">
                                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"/>
                                                                <path d="m15 5 4 4"/>
                                                            </svg>
                                                        </a>
                                                        <button type="button" class="btn-icon" title="Cập nhật trạng thái" onclick="openStatusModal('${item.id}', '${item.fullName}', '${item.status}')">
                                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"/>
                                                            </svg>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="padding: 48px 20px; text-align: center;">
                                                <div style="max-width: 380px; margin: 0 auto;">
                                                    <div style="width: 54px; height: 54px; border-radius: 50%; background: var(--bg); display: flex; align-items: center; justify-content: center; margin: 0 auto 16px auto; color: var(--text-muted);">
                                                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round">
                                                            <circle cx="11" cy="11" r="8"></circle>
                                                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                                        </svg>
                                                    </div>
                                                    <div style="font-size: 16px; font-weight: 700; color: var(--text); margin-bottom: 6px;">Không tìm thấy giáo viên nào</div>
                                                    <p style="font-size: 13px; color: var(--text-muted); margin: 0 0 16px 0;">Không có hồ sơ giáo viên nào khớp với bộ lọc tìm kiếm hiện tại.</p>
                                                    <a href="${pageContext.request.contextPath}/staff/teachers/form" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                            <line x1="12" y1="5" x2="12" y2="19"></line>
                                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                                        </svg>
                                                        Thêm mới Giáo viên
                                                    </a>
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
                        <div class="pagination-bar">
                            <div style="font-size: 13px; color: var(--text-muted);">
                                Hiển thị trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong> (Tổng <strong>${totalItems}</strong> giáo viên)
                            </div>
                            <div style="display: flex; gap: 6px;">
                                <a href="${pageContext.request.contextPath}/staff/teachers?q=${filterQ}&status=${filterStatus}&sort=${filterSort}&page=${currentPage - 1}"
                                   class="page-link-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                    ‹
                                </a>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="${pageContext.request.contextPath}/staff/teachers?q=${filterQ}&status=${filterStatus}&sort=${filterSort}&page=${p}"
                                       class="page-link-btn ${currentPage == p ? 'active' : ''}">
                                        ${p}
                                    </a>
                                </c:forEach>
                                <a href="${pageContext.request.contextPath}/staff/teachers?q=${filterQ}&status=${filterStatus}&sort=${filterSort}&page=${currentPage + 1}"
                                   class="page-link-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                    ›
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </main>

            <%@ include file="/WEB-INF/views/common/footer.jspf" %>
        </div>
    </div>

    <!-- Status Modal -->
    <div id="statusModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
        <div style="background: var(--surface); border-radius: var(--radius-md); width: 100%; max-width: 440px; padding: 24px; box-shadow: var(--shadow-lg); border: 1px solid var(--border);">
            <h3 style="margin: 0 0 8px 0; font-size: 18px; font-weight: 700; color: var(--text);">Cập nhật trạng thái công tác</h3>
            <p id="modalTeacherName" style="margin: 0 0 16px 0; font-size: 13px; color: var(--text-muted);"></p>
            
            <form method="post" action="${pageContext.request.contextPath}/staff/teachers/status">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="id" id="modalTeacherId">

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">Chọn trạng thái mới</label>
                    <select name="status" id="modalSelectStatus" class="form-control" style="width: 100%;">
                        <option value="ACTIVE">Đang giảng dạy (ACTIVE)</option>
                        <option value="ON_LEAVE">Tạm nghỉ / Nghỉ phép (ON_LEAVE)</option>
                        <option value="INACTIVE">Ngừng công tác (INACTIVE)</option>
                    </select>
                </div>

                <div style="background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius-xs); padding: 10px 12px; margin-bottom: 20px; font-size: 12px; color: var(--text-muted); line-height: 1.4;">
                    <strong style="color: var(--text);">Lưu ý (BR05):</strong> Hệ thống sẽ tự động kiểm tra và chặn chuyển sang trạng thái <em>Nghỉ phép</em> hoặc <em>Ngừng dạy</em> nếu giáo viên còn buổi học tương lai chưa hoàn tất hoặc chưa bàn giao.
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" class="btn btn-secondary" onclick="closeStatusModal()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Xác nhận cập nhật</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openStatusModal(id, name, currentStatus) {
            document.getElementById('modalTeacherId').value = id;
            document.getElementById('modalTeacherName').textContent = 'Giáo viên: ' + name;
            document.getElementById('modalSelectStatus').value = currentStatus;
            document.getElementById('statusModal').style.display = 'flex';
        }
        function closeStatusModal() {
            document.getElementById('statusModal').style.display = 'none';
        }
        window.onclick = function(event) {
            const modal = document.getElementById('statusModal');
            if (event.target === modal) {
                closeStatusModal();
            }
        };
    </script>
</body>
</html>
