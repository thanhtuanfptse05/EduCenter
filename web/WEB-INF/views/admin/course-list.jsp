<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
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
            grid-template-columns: 2fr 1.2fr 1fr 1fr 1.2fr auto;
            gap: 12px;
            align-items: flex-end;
        }
        @media (max-width: 1024px) {
            .filter-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px) {
            .filter-grid { grid-template-columns: 1fr; }
        }
        .code-badge {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-size: 12px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: var(--radius-xs);
            background: var(--primary-subtle);
            color: var(--primary);
            display: inline-block;
        }
        .grade-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: var(--radius-xs);
            background: var(--bg);
            color: var(--text);
            border: 1px solid var(--border);
        }
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 600;
        }
        .status-badge.open { background: var(--success-subtle); color: var(--success); }
        .status-badge.closed { background: var(--warning-subtle); color: var(--warning); }
        .status-badge.archived { background: var(--bg); color: var(--text-muted); border: 1px solid var(--border); }
        .featured-tag {
            display: inline-flex;
            align-items: center;
            gap: 3px;
            font-size: 10px;
            font-weight: 700;
            padding: 1px 6px;
            border-radius: var(--radius-xs);
            background: rgba(245, 158, 11, 0.15);
            color: #d97706;
            margin-left: 6px;
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
        .tab-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            text-decoration: none;
            background: var(--bg);
            border: 1px solid var(--border);
            transition: all var(--transition-fast);
        }
        .tab-pill:hover {
            color: var(--text);
            border-color: var(--primary);
            background: var(--surface);
        }
        .tab-pill.active {
            color: var(--primary);
            background: var(--primary-subtle);
            border-color: var(--primary);
            font-weight: 700;
        }
        .tab-badge {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 1px 6px;
            border-radius: var(--radius-full);
            background: rgba(0, 0, 0, 0.06);
            color: inherit;
        }
        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }
        .dot-success { background: var(--success); }
        .dot-warning { background: var(--warning); }
        .dot-archived { background: var(--text-muted); }
        .kpi-card-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            cursor: pointer;
            transition: all var(--transition-fast);
        }
        .kpi-card-link:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .kpi-card-link.active .kpi-card {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px var(--primary-subtle);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="courses" scope="request" />
        <c:set var="breadcrumb" value="Quản lý khóa học" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Page Header -->
                <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                            <a href="${pageContext.request.contextPath}/admin/courses" style="color: var(--text-muted); text-decoration: none;">Đào tạo & Học vụ</a> / <span>Quản lý khóa học</span>
                        </div>
                        <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                            Chương trình & Khóa học
                        </h1>
                        <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                            Quản lý biểu phí niêm yết, mục tiêu kỳ thi và trạng thái tuyển sinh các khóa học lớp 6–12.
                        </p>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <a href="${pageContext.request.contextPath}/admin/subjects" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="m16 6 4 14"/>
                                <path d="M12 6v14"/>
                                <path d="M8 8v12"/>
                                <path d="M4 4v16"/>
                            </svg>
                            Danh mục môn học
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/courses/form" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            Thêm khóa học mới
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
                    <a href="${pageContext.request.contextPath}/admin/courses?status=all" class="kpi-card-link ${empty filterStatus || filterStatus == 'all' ? 'active' : ''}">
                        <div class="kpi-card" style="width: 100%;">
                            <div class="kpi-icon-wrap info">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                                    <path d="M6 6h10"/>
                                    <path d="M6 10h10"/>
                                </svg>
                            </div>
                            <div>
                                <div class="kpi-val">${stats.totalCourses}</div>
                                <div class="kpi-lbl">Tổng khóa học</div>
                            </div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/courses?status=OPEN" class="kpi-card-link ${filterStatus == 'OPEN' ? 'active' : ''}">
                        <div class="kpi-card" style="width: 100%;">
                            <div class="kpi-icon-wrap success">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </div>
                            <div>
                                <div class="kpi-val">${stats.openCourses}</div>
                                <div class="kpi-lbl">Đang mở tuyển sinh</div>
                            </div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/courses?status=CLOSED" class="kpi-card-link ${filterStatus == 'CLOSED' ? 'active' : ''}">
                        <div class="kpi-card" style="width: 100%;">
                            <div class="kpi-icon-wrap warning">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                            </div>
                            <div>
                                <div class="kpi-val">${stats.closedCourses}</div>
                                <div class="kpi-lbl">Tạm đóng</div>
                            </div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/courses?status=ARCHIVED" class="kpi-card-link ${filterStatus == 'ARCHIVED' ? 'active' : ''}">
                        <div class="kpi-card" style="width: 100%;">
                            <div class="kpi-icon-wrap neutral">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                    <line x1="2" y1="10" x2="22" y2="10"></line>
                                </svg>
                            </div>
                            <div>
                                <div class="kpi-val">${stats.archivedCourses}</div>
                                <div class="kpi-lbl">Đã lưu trữ</div>
                            </div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/subjects" class="kpi-card-link">
                        <div class="kpi-card" style="width: 100%;">
                            <div class="kpi-icon-wrap neutral">
                                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="m16 6 4 14"/>
                                    <path d="M12 6v14"/>
                                    <path d="M8 8v12"/>
                                    <path d="M4 4v16"/>
                                </svg>
                            </div>
                            <div>
                                <div class="kpi-val">${stats.totalSubjects}</div>
                                <div class="kpi-lbl">Số bộ môn</div>
                            </div>
                        </div>
                    </a>
                </div>

                <!-- Main Content & Filter Card -->
                <div class="content-card">
                    <!-- Filter Toolbar -->
                    <div class="filter-panel">
                        <!-- Quick Status Tabs -->
                        <div class="status-tab-bar" style="display: flex; gap: 8px; margin-bottom: 18px; flex-wrap: wrap; padding-bottom: 14px; border-bottom: 1px solid var(--border);">
                            <a href="${pageContext.request.contextPath}/admin/courses?status=all<c:if test='${not empty filterQ}'>&q=<c:out value="${filterQ}"/></c:if><c:if test='${not empty filterSubjectId}'>&subjectId=${filterSubjectId}</c:if><c:if test='${not empty filterGrade}'>&grade=${filterGrade}</c:if><c:if test='${not empty filterSort}'>&sort=${filterSort}</c:if>"
                               class="tab-pill ${empty filterStatus || filterStatus == 'all' ? 'active' : ''}">
                                <span>Tất cả trạng thái</span>
                                <span class="tab-badge">${stats.totalCourses}</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/courses?status=OPEN<c:if test='${not empty filterQ}'>&q=<c:out value="${filterQ}"/></c:if><c:if test='${not empty filterSubjectId}'>&subjectId=${filterSubjectId}</c:if><c:if test='${not empty filterGrade}'>&grade=${filterGrade}</c:if><c:if test='${not empty filterSort}'>&sort=${filterSort}</c:if>"
                               class="tab-pill ${filterStatus == 'OPEN' ? 'active' : ''}">
                                <span class="status-dot dot-success"></span>
                                <span>Đang mở</span>
                                <span class="tab-badge">${stats.openCourses}</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/courses?status=CLOSED<c:if test='${not empty filterQ}'>&q=<c:out value="${filterQ}"/></c:if><c:if test='${not empty filterSubjectId}'>&subjectId=${filterSubjectId}</c:if><c:if test='${not empty filterGrade}'>&grade=${filterGrade}</c:if><c:if test='${not empty filterSort}'>&sort=${filterSort}</c:if>"
                               class="tab-pill ${filterStatus == 'CLOSED' ? 'active' : ''}">
                                <span class="status-dot dot-warning"></span>
                                <span>Tạm đóng</span>
                                <span class="tab-badge">${stats.closedCourses}</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/courses?status=ARCHIVED<c:if test='${not empty filterQ}'>&q=<c:out value="${filterQ}"/></c:if><c:if test='${not empty filterSubjectId}'>&subjectId=${filterSubjectId}</c:if><c:if test='${not empty filterGrade}'>&grade=${filterGrade}</c:if><c:if test='${not empty filterSort}'>&sort=${filterSort}</c:if>"
                               class="tab-pill ${filterStatus == 'ARCHIVED' ? 'active' : ''}">
                                <span class="status-dot dot-archived"></span>
                                <span>Đã lưu trữ</span>
                                <span class="tab-badge">${stats.archivedCourses}</span>
                            </a>
                        </div>

                        <form method="GET" action="${pageContext.request.contextPath}/admin/courses" class="filter-grid">
                            <!-- Keyword Input -->
                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="display: block; font-size: 11px; font-weight: 600; text-transform: uppercase; color: var(--text-muted); margin-bottom: 6px;">
                                    Tìm kiếm
                                </label>
                                <div style="position: relative;">
                                    <input type="text" name="q" value="<c:out value='${filterQ}' />" class="form-control"
                                           placeholder="Nhập mã, tên khóa, mục tiêu..."
                                           style="width: 100%; padding-left: 36px;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
                                         style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                    </svg>
                                </div>
                            </div>

                            <!-- Subject Filter -->
                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="display: block; font-size: 11px; font-weight: 600; text-transform: uppercase; color: var(--text-muted); margin-bottom: 6px;">
                                    Môn học
                                </label>
                                <select name="subjectId" class="form-control" style="width: 100%;">
                                    <option value="">Tất cả môn học</option>
                                    <c:forEach var="sub" items="${subjects}">
                                        <option value="${sub.id}" ${filterSubjectId == sub.id ? 'selected' : ''}>
                                            ${sub.name} (${sub.code})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Grade Filter -->
                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="display: block; font-size: 11px; font-weight: 600; text-transform: uppercase; color: var(--text-muted); margin-bottom: 6px;">
                                    Khối lớp
                                </label>
                                <select name="grade" class="form-control" style="width: 100%;">
                                    <option value="">Tất cả khối</option>
                                    <c:forEach var="g" begin="6" end="12">
                                        <option value="${g}" ${filterGrade == g ? 'selected' : ''}>Khối ${g}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Status Filter -->
                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="display: block; font-size: 11px; font-weight: 600; text-transform: uppercase; color: var(--text-muted); margin-bottom: 6px;">
                                    Trạng thái
                                </label>
                                <select name="status" class="form-control" style="width: 100%;">
                                    <option value="all" ${empty filterStatus || filterStatus == 'all' ? 'selected' : ''}>Tất cả trạng thái (${stats.totalCourses})</option>
                                    <option value="OPEN" ${filterStatus == 'OPEN' ? 'selected' : ''}>Đang mở tuyển sinh (${stats.openCourses})</option>
                                    <option value="CLOSED" ${filterStatus == 'CLOSED' ? 'selected' : ''}>Tạm đóng (${stats.closedCourses})</option>
                                    <option value="ARCHIVED" ${filterStatus == 'ARCHIVED' ? 'selected' : ''}>Đã lưu trữ (${stats.archivedCourses})</option>
                                </select>
                            </div>

                            <!-- Sort Filter -->
                            <div class="form-group" style="margin: 0;">
                                <label class="form-label" style="display: block; font-size: 11px; font-weight: 600; text-transform: uppercase; color: var(--text-muted); margin-bottom: 6px;">
                                    Sắp xếp
                                </label>
                                <select name="sort" class="form-control" style="width: 100%;">
                                    <option value="newest" ${empty filterSort || filterSort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                                    <option value="fee_asc" ${filterSort == 'fee_asc' ? 'selected' : ''}>Học phí thấp đến cao</option>
                                    <option value="fee_desc" ${filterSort == 'fee_desc' ? 'selected' : ''}>Học phí cao đến thấp</option>
                                    <option value="name_asc" ${filterSort == 'name_asc' ? 'selected' : ''}>Tên khóa học A-Z</option>
                                </select>
                            </div>

                            <!-- Submit Buttons -->
                            <div style="display: flex; gap: 8px;">
                                <button type="submit" class="btn btn-primary" style="height: 38px; display: inline-flex; align-items: center; gap: 6px;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                                    </svg>
                                    Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary" style="height: 38px; display: inline-flex; align-items: center;" title="Xóa bộ lọc">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/>
                                        <path d="M3 3v5h5"/>
                                    </svg>
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Courses Table -->
                    <c:choose>
                        <c:when test="${empty courses}">
                            <!-- Empty State -->
                            <div style="padding: 60px 20px; text-align: center;">
                                <div style="width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%; background: var(--bg); display: flex; align-items: center; justify-content: center; color: var(--text-muted);">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                    </svg>
                                </div>
                                <h3 style="font-size: var(--font-size-lg); font-weight: 700; color: var(--text); margin: 0 0 8px 0;">
                                    Không tìm thấy khóa học phù hợp
                                </h3>
                                <p style="font-size: var(--font-size-sm); color: var(--text-muted); max-width: 440px; margin: 0 auto 20px auto;">
                                    Không có bản ghi nào khớp với điều kiện lọc hiện tại. Thử thay đổi từ khóa tìm kiếm hoặc đặt lại bộ lọc.
                                </p>
                                <div style="display: inline-flex; gap: 12px;">
                                    <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary">
                                        Đặt lại bộ lọc
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/courses/form" class="btn btn-primary">
                                        Thêm khóa học mới
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="overflow-x: auto;">
                                <table class="table" style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg); font-size: var(--font-size-xs); font-weight: 600; color: var(--text-muted); text-transform: uppercase;">
                                            <th style="padding: 12px 18px;">Mã khóa</th>
                                            <th style="padding: 12px 16px;">Tên khóa & Môn học</th>
                                            <th style="padding: 12px 14px; text-align: center;">Khối</th>
                                            <th style="padding: 12px 16px; text-align: right;">Học phí niêm yết</th>
                                            <th style="padding: 12px 16px;">Thời lượng & Lớp</th>
                                            <th style="padding: 12px 16px; text-align: center;">Trạng thái</th>
                                            <th style="padding: 12px 18px; text-align: right;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="c" items="${courses}">
                                            <tr style="border-bottom: 1px solid var(--border); font-size: var(--font-size-sm); transition: background var(--transition-fast);">
                                                <!-- Code -->
                                                <td style="padding: 14px 18px;">
                                                    <span class="code-badge">${c.code}</span>
                                                </td>

                                                <!-- Name, Subject, Featured -->
                                                <td style="padding: 14px 16px; max-width: 280px;">
                                                    <div style="font-weight: 600; color: var(--text); display: flex; align-items: center; flex-wrap: wrap;">
                                                        <span>${c.name}</span>
                                                        <c:if test="${c.isFeatured}">
                                                            <span class="featured-tag" title="Khóa học nổi bật trang chủ">
                                                                <svg width="11" height="11" viewBox="0 0 24 24" fill="currentColor">
                                                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                                                </svg>
                                                                Nổi bật
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-top: 2px;">
                                                        Môn: <strong style="color: var(--text);">${c.subjectName}</strong>
                                                        <c:if test="${not empty c.targetExam}">
                                                            · Mục tiêu: <c:out value="${c.targetExam}" />
                                                        </c:if>
                                                    </div>
                                                </td>

                                                <!-- Grade Level -->
                                                <td style="padding: 14px 14px; text-align: center;">
                                                    <span class="grade-badge">Lớp ${c.gradeLevel}</span>
                                                </td>

                                                <!-- Fee -->
                                                <td style="padding: 14px 16px; text-align: right;">
                                                    <span style="font-weight: 700; color: var(--primary); font-size: var(--font-size-sm);">
                                                        ${c.formattedFee}
                                                    </span>
                                                </td>

                                                <!-- Duration & Sessions & Classes -->
                                                <td style="padding: 14px 16px;">
                                                    <div style="font-size: var(--font-size-xs); color: var(--text);">
                                                        ${c.durationWeeks} tuần · ${c.totalSessions} buổi (tối đa ${c.maxCapacity} hs)
                                                    </div>
                                                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">
                                                        Đang có: <strong style="color: var(--success);">${c.openClassCount} lớp mở</strong> / ${c.totalClassCount} tổng
                                                    </div>
                                                </td>

                                                <!-- Status -->
                                                <td style="padding: 14px 16px; text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${c.status == 'OPEN'}">
                                                            <span class="status-badge open">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--success);"></span>
                                                                Đang mở
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${c.status == 'CLOSED'}">
                                                            <span class="status-badge closed">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--warning);"></span>
                                                                Tạm đóng
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge archived">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--text-muted);"></span>
                                                                Lưu trữ
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Actions -->
                                                <td style="padding: 14px 18px; text-align: right;">
                                                    <div style="display: inline-flex; align-items: center; gap: 8px;">
                                                        <!-- Edit Button -->
                                                        <a href="${pageContext.request.contextPath}/admin/courses/form?id=${c.id}" class="btn btn-sm btn-secondary" style="padding: 6px 10px; display: inline-flex; align-items: center; gap: 4px;" title="Chỉnh sửa thông tin khóa học">
                                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"/>
                                                            </svg>
                                                            Sửa
                                                        </a>

                                                        <!-- Quick Status Toggle Dropdown / Form -->
                                                        <form method="POST" action="${pageContext.request.contextPath}/admin/courses/status" style="margin: 0;" onsubmit="return confirmStatusChange('${c.name}', this.status.value);">
                                                            <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                                                            <input type="hidden" name="id" value="${c.id}">
                                                            <select name="status" onchange="this.form.submit()" style="font-size: 11px; padding: 5px 8px; border: 1px solid var(--border); border-radius: var(--radius-xs); background: var(--surface); color: var(--text); cursor: pointer;">
                                                                <option value="OPEN" ${c.status == 'OPEN' ? 'selected' : ''}>Mở tuyển sinh</option>
                                                                <option value="CLOSED" ${c.status == 'CLOSED' ? 'selected' : ''}>Tạm đóng</option>
                                                                <option value="ARCHIVED" ${c.status == 'ARCHIVED' ? 'selected' : ''}>Lưu trữ</option>
                                                            </select>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination Controls -->
                            <div class="pagination-bar">
                                <div style="font-size: var(--font-size-xs); color: var(--text-muted);">
                                    Hiển thị trang <strong>${currentPage}</strong> trên tổng số <strong>${totalPages}</strong> trang (Tổng <strong>${totalItems}</strong> khóa học)
                                </div>
                                <div style="display: flex; gap: 6px;">
                                    <c:if test="${currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/admin/courses?q=${filterQ}&subjectId=${filterSubjectId}&grade=${filterGrade}&status=${filterStatus}&sort=${filterSort}&page=${currentPage - 1}" class="page-link-btn" title="Trang trước">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"></polyline></svg>
                                        </a>
                                    </c:if>

                                    <c:forEach var="p" begin="1" end="${totalPages}">
                                        <c:if test="${p == 1 || p == totalPages || (p >= currentPage - 2 && p <= currentPage + 2)}">
                                            <a href="${pageContext.request.contextPath}/admin/courses?q=${filterQ}&subjectId=${filterSubjectId}&grade=${filterGrade}&status=${filterStatus}&sort=${filterSort}&page=${p}" class="page-link-btn ${p == currentPage ? 'active' : ''}">
                                                ${p}
                                            </a>
                                        </c:if>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="${pageContext.request.contextPath}/admin/courses?q=${filterQ}&subjectId=${filterSubjectId}&grade=${filterGrade}&status=${filterStatus}&sort=${filterSort}&page=${currentPage + 1}" class="page-link-btn" title="Trang tiếp">
                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>

            <%@ include file="/WEB-INF/views/common/footer.jspf" %>
        </div>
    </div>

    <script>
        function confirmStatusChange(courseName, newStatus) {
            let label = (newStatus === 'OPEN') ? 'MỞ TUYỂN SINH' : (newStatus === 'CLOSED' ? 'TẠM ĐÓNG' : 'LƯU TRỮ (ARCHIVE)');
            return confirm('Xác nhận đổi trạng thái khóa học "' + courseName + '" sang ' + label + '?');
        }
    </script>
</body>
</html>
