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

        .guardian-cell {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .guardian-avatar {
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
        .guardian-code {
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
            font-weight: 700;
            font-size: 13px;
            color: var(--primary);
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
        .status-pill.active { background: var(--success-subtle); color: var(--success); }
        .status-pill.inactive { background: var(--bg); color: var(--text-muted); border: 1px solid var(--border); }

        .children-badge {
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

        .verify-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: var(--radius-xs);
        }
        .verify-badge.verified {
            background: var(--success-subtle);
            color: var(--success);
        }
        .verify-badge.unverified {
            background: var(--warning-subtle);
            color: var(--warning);
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
            max-width: 600px;
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
                    <a href="${pageContext.request.contextPath}/staff/students" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        Hồ sơ Học viên
                    </a>
                    <button type="button" class="btn btn-primary" onclick="openGuardianModal()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Thêm mới Phụ huynh
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
                            <label class="form-label" style="font-size: 12px; margin-bottom: 6px;">Tìm kiếm từ khóa</label>
                            <input type="text" name="q" value="${filter.keyword}" class="form-control" placeholder="Họ tên, mã PH, SĐT, email, nghề nghiệp, địa chỉ...">
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; margin-bottom: 6px;">Trạng thái hồ sơ</label>
                            <select name="status" class="form-select">
                                <option value="ALL" ${filter.status == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="ACTIVE" ${filter.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động (ACTIVE)</option>
                                <option value="INACTIVE" ${filter.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động (INACTIVE)</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin: 0;">
                            <label class="form-label" style="font-size: 12px; margin-bottom: 6px;">Xác thực giám hộ (BR15)</label>
                            <select name="verification" class="form-select">
                                <option value="ALL" ${filter.verification == 'ALL' ? 'selected' : ''}>Tất cả</option>
                                <option value="VERIFIED" ${filter.verification == 'VERIFIED' ? 'selected' : ''}>Đã có con xác thực</option>
                                <option value="UNVERIFIED" ${filter.verification == 'UNVERIFIED' ? 'selected' : ''}>Chờ xác thực / Chưa có</option>
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
                            <a href="${pageContext.request.contextPath}/staff/guardians" class="btn btn-outline">
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
                                <th style="width: 90px;">Mã PH</th>
                                <th>Phụ huynh</th>
                                <th>Liên hệ</th>
                                <th>Tài khoản Portal</th>
                                <th>Con em liên kết</th>
                                <th>Xác thực BR15</th>
                                <th style="text-align: center;">Trạng thái</th>
                                <th style="width: 90px; text-align: right;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty guardians}">
                                    <c:forEach var="g" items="${guardians}">
                                        <tr>
                                            <td>
                                                <span class="guardian-code">${g.code}</span>
                                            </td>
                                            <td>
                                                <div class="guardian-cell">
                                                    <div class="guardian-avatar">
                                                        ${g.fullName.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div style="font-weight: 700; color: var(--text);">
                                                            ${g.fullName}
                                                        </div>
                                                        <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">
                                                            <c:out value="${g.occupation != null ? g.occupation : 'Nghề nghiệp: Chưa cập nhật'}" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <div style="font-size: 13px; font-weight: 600; color: var(--text);">
                                                    ${g.phone}
                                                </div>
                                                <div style="font-size: 11px; color: var(--text-muted);">
                                                    <c:out value="${g.email != null ? g.email : '-'}" />
                                                </div>
                                                <c:if test="${not empty g.address}">
                                                    <div style="font-size: 11px; color: var(--text-muted); max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${g.address}">
                                                        ${g.address}
                                                    </div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div style="font-size: 12px; font-weight: 600; color: var(--primary);">
                                                    ${g.userEmail}
                                                </div>
                                                <div style="font-size: 11px; color: var(--text-muted);">
                                                    User ID: #${g.userId} &bull; ${g.userStatus}
                                                </div>
                                            </td>
                                            <td>
                                                <div style="display: flex; flex-direction: column; gap: 4px;">
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
                                                                <a href="${pageContext.request.contextPath}/staff/students/detail?id=${c.studentId}" style="font-size: 11px; color: var(--primary); text-decoration: none; background: var(--surface); padding: 1px 6px; border-radius: var(--radius-xs); border: 1px solid var(--border);" title="${c.studentName} (${c.relationship})">
                                                                    ${c.studentCode}
                                                                </a>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${g.verifiedChildrenCount > 0}">
                                                        <span class="verify-badge verified">
                                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                <polyline points="20 6 9 17 4 12"></polyline>
                                                            </svg>
                                                            ${g.verifiedChildrenCount}/${g.childrenCount} ĐÃ DUYỆT
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${g.childrenCount > 0}">
                                                        <span class="verify-badge unverified">
                                                            CHỜ XÁC THỰC
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="font-size: 11px; color: var(--text-muted);">Chưa gắn con</span>
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
                                                <div class="action-btns" style="justify-content: flex-end;">
                                                    <button type="button" class="btn-icon" title="Sửa thông tin phụ huynh" onclick='editGuardian(${g.id}, ${g.userId}, "${g.fullName}", "${g.phone}", "${g.email}", "${g.occupation}", "${g.address}", "${g.status}")'>
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
                                                    <c:if test="${not empty filter.keyword or filter.status != 'ALL' or filter.verification != 'ALL'}">
                                                        <a href="${pageContext.request.contextPath}/staff/guardians" class="btn btn-outline">
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
        <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/save">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="id" id="formGuardianId" value="">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">
                        Tài khoản người dùng (Vai trò PARENT) <span style="color: var(--danger);">*</span>
                    </label>
                    <select name="userId" id="formUserId" required class="form-select">
                        <option value="">-- Chọn tài khoản người dùng Phụ huynh --</option>
                        <c:forEach var="pu" items="${availableParentUsers}">
                            <option value="${pu.id}">${pu.fullName} (${pu.email})</option>
                        </c:forEach>
                    </select>
                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">
                        Mỗi phụ huynh bắt buộc gắn với một tài khoản người dùng hệ thống có vai trò PARENT để đăng nhập Parent Portal.
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Họ và tên phụ huynh <span style="color: var(--danger);">*</span></label>
                    <input type="text" name="fullName" id="formFullName" required maxlength="150" class="form-control" placeholder="Ví dụ: Trần Văn Nam">
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Số điện thoại <span style="color: var(--danger);">*</span></label>
                        <input type="tel" name="phone" id="formPhone" required maxlength="20" class="form-control" placeholder="09xxxxxxxx">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Email liên hệ</label>
                        <input type="email" name="email" id="formEmail" maxlength="255" class="form-control" placeholder="phuhuynh@gmail.com">
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Nghề nghiệp</label>
                        <input type="text" name="occupation" id="formOccupation" maxlength="150" class="form-control" placeholder="Ví dụ: Kỹ sư xây dựng">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Trạng thái hồ sơ</label>
                        <select name="status" id="formStatus" class="form-select">
                            <option value="ACTIVE">Hoạt động (ACTIVE)</option>
                            <option value="INACTIVE">Ngừng hoạt động (INACTIVE)</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Địa chỉ cư trú</label>
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
function openGuardianModal() {
    document.getElementById('guardianModalTitle').innerText = 'Thêm mới Hồ sơ Phụ huynh';
    document.getElementById('formGuardianId').value = '';
    document.getElementById('formUserId').value = '';
    document.getElementById('formFullName').value = '';
    document.getElementById('formPhone').value = '';
    document.getElementById('formEmail').value = '';
    document.getElementById('formOccupation').value = '';
    document.getElementById('formAddress').value = '';
    document.getElementById('formStatus').value = 'ACTIVE';
    document.getElementById('btnSaveGuardian').innerText = 'Tạo phụ huynh';
    document.getElementById('guardianModal').classList.add('active');
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
