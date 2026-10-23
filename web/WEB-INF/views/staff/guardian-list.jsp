<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <title>Quản lý Phụ huynh & Giám hộ | EduCenter</title>
    <style>
        .content-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
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
            gap: 14px;
            align-items: flex-end;
        }
        @media (max-width: 992px) {
            .filter-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px) {
            .filter-grid { grid-template-columns: 1fr; }
        }

        .guardian-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .guardian-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.15) 0%, rgba(37, 99, 235, 0.05) 100%);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 15px;
            flex-shrink: 0;
            border: 1px solid rgba(37, 99, 235, 0.25);
        }
        .guardian-name {
            font-size: 14px;
            font-weight: 600;
            color: var(--text);
            line-height: 1.3;
        }
        .guardian-sub {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .contact-phone {
            font-size: 13px;
            font-weight: 600;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .contact-email {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .contact-address {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .portal-email {
            font-size: 13px;
            font-weight: 600;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .portal-meta {
            font-size: 11px;
            color: var(--text-muted);
            margin-top: 2px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .children-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            font-weight: 600;
            color: var(--text);
            padding: 3px 8px;
            background: var(--bg);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border);
            white-space: nowrap;
        }
        .child-chip {
            font-size: 11px;
            font-weight: 600;
            color: var(--primary);
            text-decoration: none;
            background: var(--surface);
            padding: 2px 7px;
            border-radius: var(--radius-xs);
            border: 1px solid var(--border);
            transition: all var(--transition-fast);
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .child-chip:hover {
            border-color: var(--primary);
            background: var(--primary-subtle);
        }

        .verify-tag {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: var(--radius-xs);
            white-space: nowrap;
            letter-spacing: 0.02em;
        }
        .verify-tag.verified {
            background: var(--success-subtle);
            color: var(--success);
            border: 1px solid rgba(22, 163, 74, 0.25);
        }
        .verify-tag.unverified {
            background: var(--warning-subtle);
            color: var(--warning);
            border: 1px solid rgba(217, 119, 6, 0.25);
        }

        .action-btns {
            display: flex;
            align-items: center;
            gap: 6px;
            justify-content: flex-end;
        }
        .btn-icon {
            width: 32px;
            height: 32px;
            border-radius: var(--radius-sm);
            display: inline-flex;
            align-items: center;
            justify-content: center;
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
            font-size: 13px;
        }
        .page-link-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 34px;
            height: 34px;
            padding: 0 8px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
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
            background: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(6px);
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
            border-radius: var(--radius-lg);
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
    <c:set var="activeNav" value="guardians" scope="request" />
    <c:set var="breadcrumb" value="Phụ huynh & Giám hộ" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                <div>
                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                        <a href="${pageContext.request.contextPath}/staff/students" style="color: var(--text-muted); text-decoration: none;">Tuyển sinh & Khách hàng</a> / <span>Phụ huynh & Giám hộ</span>
                    </div>
                    <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                        Quản lý Phụ huynh & Quyền Giám hộ
                    </h1>
                    <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                        Quản lý thông tin phụ huynh, thiết lập liên kết con cái nhiều-nhiều và xác thực quyền giám hộ theo Business Rule BR15.
                    </p>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <a href="${pageContext.request.contextPath}/staff/students" class="btn btn-outline" style="height: 40px; display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <span>Hồ sơ Học viên</span>
                    </a>
                    <button type="button" class="btn btn-primary" onclick="openGuardianModal()" style="height: 40px; display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Thêm mới Phụ huynh</span>
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

            <!-- Content Card: Filter & Table -->
            <div class="content-card">
                <!-- Filter Panel -->
                <div class="filter-panel">
                    <form method="GET" action="${pageContext.request.contextPath}/staff/guardians" class="filter-grid">
                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Tìm kiếm từ khóa</label>
                            <div class="search-input-wrap">
                                <svg class="search-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <input type="text" name="q" value="${filter.keyword}" class="form-control" placeholder="Họ tên, mã PH, SĐT, email, nghề nghiệp, địa chỉ...">
                            </div>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Trạng thái hồ sơ</label>
                            <select name="status" class="form-select" style="width: 100%;">
                                <option value="ALL" ${empty filter.status or filter.status == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="ACTIVE" ${filter.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động (ACTIVE)</option>
                                <option value="INACTIVE" ${filter.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động (INACTIVE)</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Xác thực giám hộ (BR15)</label>
                            <select name="verification" class="form-select" style="width: 100%;">
                                <option value="ALL" ${empty filter.verification or filter.verification == 'ALL' ? 'selected' : ''}>Tất cả trạng thái duyệt</option>
                                <option value="VERIFIED" ${filter.verification == 'VERIFIED' ? 'selected' : ''}>Đã duyệt xác thực</option>
                                <option value="UNVERIFIED" ${filter.verification == 'UNVERIFIED' ? 'selected' : ''}>Chờ duyệt xác thực</option>
                            </select>
                        </div>

                        <div style="display: flex; gap: 8px;">
                            <button type="submit" class="btn btn-primary" style="height: 40px; display: inline-flex; align-items: center; gap: 6px; padding: 0 16px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <span>Lọc</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/staff/guardians" class="btn btn-outline" style="height: 40px; display: inline-flex; align-items: center; gap: 6px; padding: 0 14px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                                    <path d="M3 3v5h5"></path>
                                </svg>
                                <span>Xóa lọc</span>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Table Content -->
                <div class="table-responsive">
                    <table class="data-table" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th style="width: 95px;">Mã PH</th>
                                <th>Phụ huynh</th>
                                <th>Liên hệ</th>
                                <th>Tài khoản Portal</th>
                                <th>Con em liên kết</th>
                                <th style="width: 140px;">Xác thực BR15</th>
                                <th style="width: 110px; text-align: center;">Trạng thái</th>
                                <th style="width: 90px; text-align: right;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty guardians}">
                                    <c:forEach var="g" items="${guardians}">
                                        <tr>
                                            <td>
                                                <span class="code-badge">${g.code}</span>
                                            </td>
                                            <td>
                                                <div class="guardian-cell">
                                                    <div class="guardian-avatar">
                                                        ${g.fullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div class="guardian-name">
                                                            ${g.fullName}
                                                        </div>
                                                        <div class="guardian-sub">
                                                            <c:out value="${not empty g.occupation ? g.occupation : 'Chưa cập nhật nghề nghiệp'}" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="contact-phone">
                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" style="color: var(--text-muted);" aria-hidden="true">
                                                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                                    </svg>
                                                    <span>${g.phone}</span>
                                                </div>
                                                <div class="contact-email">
                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" style="color: var(--text-muted);" aria-hidden="true">
                                                        <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                                        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                                    </svg>
                                                    <span><c:out value="${not empty g.email ? g.email : 'Chưa có email'}" /></span>
                                                </div>
                                                <c:if test="${not empty g.address}">
                                                    <div class="contact-address" title="${g.address}">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" style="color: var(--text-muted); flex-shrink: 0;" aria-hidden="true">
                                                            <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"></path>
                                                            <circle cx="12" cy="10" r="3"></circle>
                                                        </svg>
                                                        <span>${g.address}</span>
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="portal-email">
                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                        <circle cx="12" cy="12" r="10"></circle>
                                                        <path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"></path>
                                                        <path d="M2 12h20"></path>
                                                    </svg>
                                                    <span>${g.userEmail}</span>
                                                </div>
                                                <div class="portal-meta">
                                                    <span>User ID: #${g.userId}</span>
                                                    <span>&bull;</span>
                                                    <span style="color: var(--success); font-weight: 600;">${g.userStatus}</span>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; flex-direction: column; gap: 6px;">
                                                    <div class="children-badge">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="9" cy="7" r="4"></circle>
                                                        </svg>
                                                        <span>${g.childrenCount} con em</span>
                                                    </div>
                                                    <c:if test="${not empty g.children}">
                                                        <div style="display: flex; gap: 4px; flex-wrap: wrap;">
                                                            <c:forEach var="c" items="${g.children}">
                                                                <a href="${pageContext.request.contextPath}/staff/students/detail?id=${c.studentId}" class="child-chip" title="${c.studentName} (${c.relationship})">
                                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                                                        <circle cx="9" cy="7" r="4"></circle>
                                                                    </svg>
                                                                    <span>${c.studentCode}</span>
                                                                </a>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${g.verifiedChildrenCount > 0}">
                                                        <span class="verify-tag verified">
                                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                                <polyline points="9 12 11 14 15 10"></polyline>
                                                            </svg>
                                                            <span>${g.verifiedChildrenCount}/${g.childrenCount} ĐÃ DUYỆT</span>
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${g.childrenCount > 0}">
                                                        <span class="verify-tag unverified">
                                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                <circle cx="12" cy="12" r="10"></circle>
                                                                <polyline points="12 6 12 12 14 14"></polyline>
                                                            </svg>
                                                            <span>CHỜ DUYỆT</span>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="font-size: 12px; color: var(--text-muted); font-style: italic;">Chưa gắn con</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: center;">
                                                <c:choose>
                                                    <c:when test="${g.status == 'ACTIVE'}">
                                                        <span class="status-pill active">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-pill inactive">Ngừng HĐ</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;">
                                                <div class="action-btns">
                                                    <button type="button" class="btn-icon" title="Sửa thông tin phụ huynh"
                                                            data-id="${g.id}"
                                                            data-userid="${g.userId}"
                                                            data-fullname="<c:out value='${g.fullName}'/>"
                                                            data-phone="<c:out value='${g.phone}'/>"
                                                            data-email="<c:out value='${g.email}'/>"
                                                            data-occupation="<c:out value='${g.occupation}'/>"
                                                            data-address="<c:out value='${g.address}'/>"
                                                            data-status="<c:out value='${g.status}'/>"
                                                            onclick="editGuardianFromBtn(this)">
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
                                        <td colspan="8">
                                            <div class="empty-state">
                                                <div class="empty-icon">
                                                    <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                    </svg>
                                                </div>
                                                <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 6px 0;">
                                                    Không tìm thấy hồ sơ phụ huynh nào
                                                </h3>
                                                <p style="font-size: 13px; color: var(--text-muted); margin: 0 0 18px 0; max-width: 420px;">
                                                    Chưa có hồ sơ người giám hộ hoặc phụ huynh nào phù hợp với điều kiện tìm kiếm.
                                                </p>
                                                <div style="display: flex; gap: 10px;">
                                                    <button type="button" class="btn btn-primary" onclick="openGuardianModal()">
                                                        Thêm phụ huynh mới
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

                <!-- Pagination Bar -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-bar">
                        <div style="color: var(--text-muted);">
                            Hiển thị <strong>${guardians.size()}</strong> / <strong>${totalItems}</strong> phụ huynh (Trang ${currentPage} / ${totalPages})
                        </div>
                        <div style="display: flex; gap: 4px;">
                            <a href="${pageContext.request.contextPath}/staff/guardians?q=${filter.keyword}&status=${filter.status}&verification=${filter.verification}&page=${currentPage - 1}"
                               class="page-link-btn ${currentPage <= 1 ? 'disabled' : ''}">
                                &laquo;
                            </a>
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <a href="${pageContext.request.contextPath}/staff/guardians?q=${filter.keyword}&status=${filter.status}&verification=${filter.verification}&page=${p}"
                                   class="page-link-btn ${currentPage == p ? 'active' : ''}">
                                    ${p}
                                </a>
                            </c:forEach>
                            <a href="${pageContext.request.contextPath}/staff/guardians?q=${filter.keyword}&status=${filter.status}&verification=${filter.verification}&page=${currentPage + 1}"
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

<!-- Modal: Thêm / Sửa Phụ huynh -->
<div class="modal-overlay" id="guardianModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;" id="guardianModalTitle">
                Thêm mới Hồ sơ Phụ huynh
            </h3>
            <button type="button" class="btn-icon" onclick="closeGuardianModal()">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/save" id="guardianForm">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="id" id="formGuardianId" value="">

            <div class="modal-body">
                <!-- Smart Account Provisioning Mode -->
                <div id="accountModeContainer" style="margin-bottom: 20px; padding: 14px; background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 10px;">
                        Tài khoản Portal Phụ huynh (Đăng nhập theo dõi con):
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
                        <svg class="icon icon-xs" viewBox="0 0 24 24" style="color: var(--primary); flex-shrink: 0;" aria-hidden="true">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="16" x2="12" y2="12"></line>
                            <line x1="12" y1="8" x2="12.01" y2="8"></line>
                        </svg>
                        <span>Hệ thống tự động kích hoạt tài khoản vai trò Phụ huynh với tên đăng nhập là Email (hoặc SĐT), mật khẩu khởi tạo bằng SĐT.</span>
                    </div>
                    <div id="manualAccountGroup" style="display: none; margin-top: 12px;">
                        <select name="userId" id="formUserId" class="form-select" style="width: 100%;">
                            <option value="">-- Chọn tài khoản người dùng có vai trò PARENT --</option>
                            <c:forEach var="pu" items="${availableParentUsers}">
                                <option value="${pu.id}">${pu.fullName} (${pu.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">
                        Họ và tên phụ huynh <span style="color: var(--danger);">*</span>
                    </label>
                    <input type="text" name="fullName" id="formFullName" required maxlength="150" class="form-control" placeholder="Ví dụ: Trần Văn Nam">
                </div>

                <div class="form-row-2" style="margin-bottom: 16px;">
                    <div class="form-group" style="margin: 0;">
                        <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">
                            Số điện thoại <span style="color: var(--danger);">*</span>
                        </label>
                        <input type="tel" name="phone" id="formPhone" required maxlength="20" class="form-control" placeholder="Ví dụ: 0912345678">
                    </div>

                    <div class="form-group" style="margin: 0;">
                        <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">
                            Email liên hệ
                        </label>
                        <input type="email" name="email" id="formEmail" maxlength="255" class="form-control" placeholder="Ví dụ: phuhuynh@gmail.com">
                    </div>
                </div>

                <div class="form-row-2" style="margin-bottom: 16px;">
                    <div class="form-group" style="margin: 0;">
                        <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">
                            Nghề nghiệp
                        </label>
                        <input type="text" name="occupation" id="formOccupation" maxlength="150" class="form-control" placeholder="Ví dụ: Kỹ sư xây dựng">
                    </div>

                    <div class="form-group" style="margin: 0;">
                        <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">
                            Trạng thái hồ sơ
                        </label>
                        <select name="status" id="formStatus" class="form-select" style="width: 100%;">
                            <option value="ACTIVE">Hoạt động (ACTIVE)</option>
                            <option value="INACTIVE">Ngừng hoạt động (INACTIVE)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group" style="margin: 0;">
                    <label class="form-label" style="font-size: 13px; font-weight: 600; margin-bottom: 6px; display: block;">
                        Địa chỉ cư trú
                    </label>
                    <input type="text" name="address" id="formAddress" maxlength="255" class="form-control" placeholder="Ví dụ: Số 123 Đường Cầu Giấy, Hà Nội">
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeGuardianModal()">Hủy</button>
                <button type="submit" class="btn btn-primary" id="btnSaveGuardian">Lưu phụ huynh</button>
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
    
    // Check if option for userId exists, if not add it dynamically so it can be selected
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
