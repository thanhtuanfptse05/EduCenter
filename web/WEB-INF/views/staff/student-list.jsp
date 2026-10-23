<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <title>Quản lý Hồ sơ Học viên | EduCenter</title>
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
            padding: 16px 18px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 14px;
            transition: transform var(--transition-fast), box-shadow var(--transition-fast);
        }
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
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
        .kpi-icon-wrap.info { background: var(--primary-subtle); color: var(--primary); }
        .kpi-icon-wrap.neutral { background: var(--bg); color: var(--text-muted); }
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
            grid-template-columns: 2fr 1fr 1.2fr auto;
            gap: 12px;
            align-items: flex-end;
        }
        @media (max-width: 992px) {
            .filter-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px) {
            .filter-grid { grid-template-columns: 1fr; }
        }

        .student-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .student-avatar {
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
            border: 1px solid rgba(37, 99, 235, 0.2);
        }
        .student-code {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-weight: 700;
            font-size: 13px;
            color: var(--primary);
            letter-spacing: 0.02em;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 600;
            padding: 3px 10px;
            border-radius: 9999px;
            letter-spacing: 0.02em;
        }
        .status-pill.studying { background: var(--success-subtle); color: var(--success); }
        .status-pill.reserved { background: var(--warning-subtle); color: var(--warning); }
        .status-pill.dropped { background: rgba(220, 38, 38, 0.1); color: var(--danger); }
        .status-pill.graduated { background: var(--primary-subtle); color: var(--primary); }

        .grade-badge {
            display: inline-block;
            padding: 2px 8px;
            font-size: 11px;
            font-weight: 600;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-xs);
            color: var(--text);
        }

        .guardians-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text);
            padding: 2px 8px;
            background: var(--bg);
            border-radius: var(--radius-xs);
            border: 1px solid var(--border);
        }

        .portal-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 11px;
            font-weight: 500;
            padding: 2px 8px;
            border-radius: var(--radius-xs);
        }
        .portal-badge.linked {
            background: var(--primary-subtle);
            color: var(--primary);
        }
        .portal-badge.unlinked {
            background: var(--bg);
            color: var(--text-muted);
            border: 1px dashed var(--border);
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

        .empty-state {
            padding: 64px 20px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .empty-icon {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: var(--bg);
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
        }

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

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 16px;
        }
        .modal-overlay.active { display: flex; }
        .modal-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 640px;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-body { padding: 24px; }
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: var(--bg);
        }
        .form-row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        @media (max-width: 576px) {
            .form-row-2 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="students" scope="request" />
    <c:set var="breadcrumb" value="Hồ sơ Học viên" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                <div>
                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                        <a href="${pageContext.request.contextPath}/staff/leads" style="color: var(--text-muted); text-decoration: none;">Tuyển sinh & Khách hàng</a> / <span>Hồ sơ Học viên</span>
                    </div>
                    <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                        Quản lý Hồ sơ & Trạng thái Học viên
                    </h1>
                    <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                        Quản lý danh sách học sinh theo khối 6–12, mục tiêu kỳ thi, theo dõi trạng thái học tập và liên kết người giám hộ.
                    </p>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <a href="${pageContext.request.contextPath}/staff/guardians" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        Phụ huynh & Giám hộ
                    </a>
                    <button type="button" class="btn btn-primary" onclick="openStudentModal()" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Thêm mới Học viên
                    </button>
                </div>
            </div>

            <!-- Flash Alerts -->
            <c:if test="${not empty flash_success}">
                <div class="toast-alert toast-success" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: var(--success-subtle); color: var(--success); border: 1px solid rgba(22, 163, 74, 0.2);">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    <span>${flash_success}</span>
                </div>
            </c:if>
            <c:if test="${not empty flash_error}">
                <div class="toast-alert toast-error" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: rgba(220, 38, 38, 0.1); color: var(--danger); border: 1px solid rgba(220, 38, 38, 0.2);">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
                    <span>${flash_error}</span>
                </div>
            </c:if>

            <!-- KPI Row -->
            <div class="kpi-row">
                <div class="kpi-card">
                    <div class="kpi-icon-wrap info">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                    </div>
                    <div>
                        <div class="kpi-val">${stats.totalStudents}</div>
                        <div class="kpi-lbl">Tổng số học viên</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap success">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 14 14"></polyline>
                        </svg>
                    </div>
                    <div>
                        <div class="kpi-val">${stats.studyingCount}</div>
                        <div class="kpi-lbl">Đang theo học</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap warning">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                            <rect x="6" y="4" width="4" height="16"></rect>
                            <rect x="14" y="4" width="4" height="16"></rect>
                        </svg>
                    </div>
                    <div>
                        <div class="kpi-val">${stats.reservedCount}</div>
                        <div class="kpi-lbl">Đang bảo lưu</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap info">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                            <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                        </svg>
                    </div>
                    <div>
                        <div class="kpi-val">${stats.graduatedCount}</div>
                        <div class="kpi-lbl">Đã tốt nghiệp</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon-wrap neutral">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                        </svg>
                    </div>
                    <div>
                        <div class="kpi-val">${stats.droppedCount}</div>
                        <div class="kpi-lbl">Đã thôi học</div>
                    </div>
                </div>
            </div>

            <!-- Content Card: Filter & Table -->
            <div class="content-card">
                <!-- Filter Panel -->
                <div class="filter-panel">
                    <form method="GET" action="${pageContext.request.contextPath}/staff/students" class="filter-grid">
                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; margin-bottom: 6px;">Tìm kiếm từ khóa</label>
                            <div class="input-with-icon" style="position: relative;">
                                <input type="text" name="q" value="${filter.keyword}" class="form-control" placeholder="Họ tên, mã HV, SĐT, trường học, mục tiêu..." style="width: 100%;">
                            </div>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; margin-bottom: 6px;">Khối lớp</label>
                            <select name="grade" class="form-select">
                                <option value="">Tất cả khối lớp</option>
                                <c:forEach var="g" begin="6" end="12">
                                    <option value="${g}" ${filter.gradeLevel == g ? 'selected' : ''}>Khối ${g}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; margin-bottom: 6px;">Trạng thái học tập</label>
                            <select name="status" class="form-select">
                                <option value="ALL" ${filter.status == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="STUDYING" ${filter.status == 'STUDYING' ? 'selected' : ''}>Đang học (STUDYING)</option>
                                <option value="RESERVED" ${filter.status == 'RESERVED' ? 'selected' : ''}>Bảo lưu (RESERVED)</option>
                                <option value="GRADUATED" ${filter.status == 'GRADUATED' ? 'selected' : ''}>Tốt nghiệp (GRADUATED)</option>
                                <option value="DROPPED" ${filter.status == 'DROPPED' ? 'selected' : ''}>Thôi học (DROPPED)</option>
                            </select>
                        </div>

                        <div style="display: flex; gap: 8px;">
                            <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                Lọc
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/students" class="btn btn-outline" title="Đặt lại bộ lọc">
                                Xóa lọc
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Table Content -->
                <div class="table-responsive">
                    <table class="data-table" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th style="width: 90px;">Mã HV</th>
                                <th>Học viên</th>
                                <th>Khối / Trường học</th>
                                <th>Liên hệ</th>
                                <th>Mục tiêu thi cử</th>
                                <th>Giám hộ</th>
                                <th>Tài khoản Portal</th>
                                <th style="text-align: center;">Trạng thái</th>
                                <th style="width: 110px; text-align: right;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty students}">
                                    <c:forEach var="s" items="${students}">
                                        <tr>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/staff/students/detail?id=${s.id}" class="student-code">
                                                    ${s.code}
                                                </a>
                                            </td>
                                            <td>
                                                <div class="student-cell">
                                                    <div class="student-avatar">
                                                        ${s.fullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/staff/students/detail?id=${s.id}" style="font-weight: 600; color: var(--text); text-decoration: none;">
                                                            ${s.fullName}
                                                        </a>
                                                        <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">
                                                            <c:choose>
                                                                <c:when test="${s.gender == 'NAM'}">Nam</c:when>
                                                                <c:when test="${s.gender == 'NU'}">Nữ</c:when>
                                                                <c:otherwise>Khác</c:otherwise>
                                                            </c:choose>
                                                            <c:if test="${not empty s.formattedDob}">
                                                                &bull; ${s.formattedDob}
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="grade-badge">Khối ${s.gradeLevel}</span>
                                                <div style="font-size: 12px; color: var(--text-muted); margin-top: 3px;">
                                                    <c:out value="${s.school != null ? s.school : 'Chưa cập nhật'}" />
                                                </div>
                                            </td>
                                            <td>
                                                <div style="font-size: 12px; font-weight: 500; color: var(--text);">
                                                    <c:out value="${s.phone != null ? s.phone : '-'}" />
                                                </div>
                                                <div style="font-size: 11px; color: var(--text-muted);">
                                                    <c:out value="${s.email != null ? s.email : '-'}" />
                                                </div>
                                            </td>
                                            <td>
                                                <div style="font-size: 12px; color: var(--text); max-width: 220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${s.targetGoal}">
                                                    <c:out value="${s.targetGoal != null && !s.targetGoal.isEmpty() ? s.targetGoal : 'Chưa thiết lập'}" />
                                                </div>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/staff/students/detail?id=${s.id}#guardians" class="guardians-badge" title="Xem người giám hộ">
                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                    </svg>
                                                    <span>${s.guardiansCount} người</span>
                                                </a>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty s.userId}">
                                                        <span class="portal-badge linked" title="User ID: ${s.userId}">
                                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                                <circle cx="12" cy="7" r="4"></circle>
                                                            </svg>
                                                            ${s.userEmail}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="portal-badge unlinked">Chưa liên kết</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${s.status == 'STUDYING'}">
                                                        <span class="status-pill studying">Đang học</span>
                                                    </c:when>
                                                    <c:when test="${s.status == 'RESERVED'}">
                                                        <span class="status-pill reserved">Bảo lưu</span>
                                                    </c:when>
                                                    <c:when test="${s.status == 'GRADUATED'}">
                                                        <span class="status-pill graduated">Tốt nghiệp</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill dropped">Thôi học</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;">
                                                <div class="action-btns" style="justify-content: flex-end;">
                                                    <a href="${pageContext.request.contextPath}/staff/students/detail?id=${s.id}" class="btn-icon" title="Xem chi tiết hồ sơ">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                            <circle cx="12" cy="12" r="3"></circle>
                                                        </svg>
                                                    </a>
                                                    <button type="button" class="btn-icon" title="Sửa thông tin nhanh" onclick='editStudent(${s.id}, "${s.fullName}", "${s.dob}", "${s.gender}", "${s.phone}", "${s.email}", "${s.school}", ${s.gradeLevel}, "${s.targetGoal}", "${s.status}", "${s.userId}")'>
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M12 20h9"></path>
                                                            <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                                        </svg>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9">
                                            <div class="empty-state">
                                                <div class="empty-icon">
                                                    <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                                        <circle cx="9" cy="7" r="4"></circle>
                                                        <line x1="17" y1="8" x2="23" y2="14"></line>
                                                        <line x1="23" y1="8" x2="17" y2="14"></line>
                                                    </svg>
                                                </div>
                                                <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 6px 0;">
                                                    Không tìm thấy hồ sơ học viên nào
                                                </h3>
                                                <p style="font-size: 13px; color: var(--text-muted); margin: 0 0 18px 0; max-width: 420px;">
                                                    Không có kết quả nào phù hợp với bộ lọc hiện tại hoặc hệ thống chưa ghi nhận học viên nào trong cơ sở dữ liệu.
                                                </p>
                                                <div style="display: flex; gap: 10px;">
                                                    <button type="button" class="btn btn-primary" onclick="openStudentModal()">
                                                        Thêm học viên mới
                                                    </button>
                                                    <c:if test="${not empty filter.keyword or (not empty filter.gradeLevel) or (filter.status != 'ALL')}">
                                                        <a href="${pageContext.request.contextPath}/staff/students" class="btn btn-outline">
                                                            Xóa bộ lọc
                                                        </a>
                                                    </c:if>
                                                </div>
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
                            Hiển thị <strong>${students.size()}</strong> / <strong>${totalItems}</strong> học viên (Trang ${currentPage} / ${totalPages})
                        </div>
                        <div style="display: flex; gap: 4px;">
                            <a href="${pageContext.request.contextPath}/staff/students?q=${filter.keyword}&grade=${filter.gradeLevel}&status=${filter.status}&page=${currentPage - 1}"
                               class="page-link-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                &laquo;
                            </a>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <a href="${pageContext.request.contextPath}/staff/students?q=${filter.keyword}&grade=${filter.gradeLevel}&status=${filter.status}&page=${p}"
                                   class="page-link-btn ${currentPage == p ? 'active' : ''}">
                                    ${p}
                                </a>
                            </c:forEach>
                            <a href="${pageContext.request.contextPath}/staff/students?q=${filter.keyword}&grade=${filter.gradeLevel}&status=${filter.status}&page=${currentPage + 1}"
                               class="page-link-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                                &raquo;
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Thêm / Sửa Học viên -->
<div class="modal-overlay" id="studentModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;" id="studentModalTitle">
                Thêm mới Hồ sơ Học viên
            </h3>
            <button type="button" class="btn-icon" onclick="closeStudentModal()">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/students/save">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="id" id="formStudentId" value="">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Họ và tên học viên <span style="color: var(--danger);">*</span></label>
                    <input type="text" name="fullName" id="formFullName" required maxlength="150" class="form-control" placeholder="Ví dụ: Nguyễn Văn An">
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Khối lớp <span style="color: var(--danger);">*</span></label>
                        <select name="gradeLevel" id="formGradeLevel" required class="form-select">
                            <c:forEach var="g" begin="6" end="12">
                                <option value="${g}" ${g == 10 ? 'selected' : ''}>Khối ${g}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Giới tính</label>
                        <select name="gender" id="formGender" class="form-select">
                            <option value="NAM">Nam</option>
                            <option value="NU">Nữ</option>
                            <option value="KHAC">Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Ngày sinh</label>
                        <input type="date" name="dob" id="formDob" class="form-control">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Trường học đang học</label>
                        <input type="text" name="school" id="formSchool" maxlength="255" class="form-control" placeholder="Ví dụ: THPT Chu Văn An">
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Số điện thoại</label>
                        <input type="tel" name="phone" id="formPhone" maxlength="20" class="form-control" placeholder="09xxxxxxxx">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Email học viên</label>
                        <input type="email" name="email" id="formEmail" maxlength="255" class="form-control" placeholder="hocvien@gmail.com">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Mục tiêu học tập & thi cử</label>
                    <textarea name="targetGoal" id="formTargetGoal" rows="2" maxlength="500" class="form-control" placeholder="Ví dụ: Luyện thi THPTQG Khối A00 đạt 27+ điểm, Đánh giá năng lực ĐHQG"></textarea>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Trạng thái học tập</label>
                        <select name="status" id="formStatus" class="form-select">
                            <option value="STUDYING">Đang theo học (STUDYING)</option>
                            <option value="RESERVED">Đang bảo lưu (RESERVED)</option>
                            <option value="GRADUATED">Đã tốt nghiệp (GRADUATED)</option>
                            <option value="DROPPED">Đã thôi học (DROPPED)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Gắn tài khoản Portal</label>
                        <select name="userId" id="formUserId" class="form-select">
                            <option value="">-- Chưa liên kết tài khoản --</option>
                            <c:forEach var="u" items="${availableUsers}">
                                <option value="${u.id}">${u.fullName} (${u.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeStudentModal()">Hủy</button>
                <button type="submit" class="btn btn-primary" id="btnSaveStudent">Lưu hồ sơ</button>
            </div>
        </form>
    </div>
</div>

<script>
function openStudentModal() {
    document.getElementById('studentModalTitle').innerText = 'Thêm mới Hồ sơ Học viên';
    document.getElementById('formStudentId').value = '';
    document.getElementById('formFullName').value = '';
    document.getElementById('formDob').value = '';
    document.getElementById('formGender').value = 'NAM';
    document.getElementById('formPhone').value = '';
    document.getElementById('formEmail').value = '';
    document.getElementById('formSchool').value = '';
    document.getElementById('formGradeLevel').value = '10';
    document.getElementById('formTargetGoal').value = '';
    document.getElementById('formStatus').value = 'STUDYING';
    document.getElementById('formUserId').value = '';
    document.getElementById('btnSaveStudent').innerText = 'Tạo học viên';
    document.getElementById('studentModal').classList.add('active');
}

function editStudent(id, fullName, dob, gender, phone, email, school, grade, goal, status, userId) {
    document.getElementById('studentModalTitle').innerText = 'Cập nhật Hồ sơ Học viên (HV' + String(id).padStart(4, '0') + ')';
    document.getElementById('formStudentId').value = id;
    document.getElementById('formFullName').value = fullName || '';
    document.getElementById('formDob').value = (dob && dob !== 'null') ? dob : '';
    document.getElementById('formGender').value = gender || 'NAM';
    document.getElementById('formPhone').value = (phone && phone !== 'null') ? phone : '';
    document.getElementById('formEmail').value = (email && email !== 'null') ? email : '';
    document.getElementById('formSchool').value = (school && school !== 'null') ? school : '';
    document.getElementById('formGradeLevel').value = grade || '10';
    document.getElementById('formTargetGoal').value = (goal && goal !== 'null') ? goal : '';
    document.getElementById('formStatus').value = status || 'STUDYING';
    document.getElementById('formUserId').value = (userId && userId !== 'null') ? userId : '';
    document.getElementById('btnSaveStudent').innerText = 'Lưu thay đổi';
    document.getElementById('studentModal').classList.add('active');
}

function closeStudentModal() {
    document.getElementById('studentModal').classList.remove('active');
}

// Close on escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeStudentModal();
    }
});
</script>
</body>
</html>
