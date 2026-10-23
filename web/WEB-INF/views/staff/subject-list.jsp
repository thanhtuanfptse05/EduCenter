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
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 24px;
        }
        @media (max-width: 992px) {
            .kpi-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .kpi-row { grid-template-columns: 1fr; }
        }
        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .kpi-icon-wrap {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-subtle);
            color: var(--primary);
            flex-shrink: 0;
        }
        .kpi-icon-wrap.success {
            background: var(--success-subtle);
            color: var(--success);
        }
        .kpi-icon-wrap.warning {
            background: var(--warning-subtle);
            color: var(--warning);
        }
        .kpi-icon-wrap.neutral {
            background: var(--bg);
            color: var(--text-muted);
        }
        .kpi-val {
            font-size: 24px;
            font-weight: 700;
            color: var(--text);
            line-height: 1.2;
        }
        .kpi-lbl {
            font-size: var(--font-size-xs);
            color: var(--text-muted);
            font-weight: 500;
            margin-top: 2px;
        }
        .content-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
        }
        .table-toolbar {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }
        .table-title {
            font-size: var(--font-size-md);
            font-weight: 700;
            color: var(--text);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
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
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 600;
        }
        .status-badge.active {
            background: var(--success-subtle);
            color: var(--success);
        }
        .status-badge.inactive {
            background: var(--warning-subtle);
            color: var(--warning);
        }
        /* Modal dialog styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.45);
            backdrop-filter: blur(4px);
            z-index: 1050;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }
        .modal-overlay.open {
            display: flex;
        }
        .modal-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            width: 100%;
            max-width: 520px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-12px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .modal-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-title {
            font-size: var(--font-size-md);
            font-weight: 700;
            color: var(--text);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .modal-body {
            padding: 24px;
        }
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--border);
            background: var(--bg);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="subjects" scope="request" />
        <c:set var="breadcrumb" value="Danh mục môn học" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <main class="admin-main">
            <%@ include file="/WEB-INF/views/common/navbar.jspf" %>

            <div class="admin-content">
                <!-- Page Header -->
                <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                            <a href="${pageContext.request.contextPath}/staff/dashboard" style="color: var(--text-muted); text-decoration: none;">Học vụ</a> / <span>Danh mục môn học</span>
                        </div>
                        <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                            Quản lý Môn học
                        </h1>
                        <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                            Danh mục bộ môn đào tạo thống nhất làm nền tảng cho Khóa học, Lớp học và Tuyển sinh.
                        </p>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <a href="${pageContext.request.contextPath}/staff/courses" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                                <path d="M6 6h10"/>
                                <path d="M6 10h10"/>
                            </svg>
                            Xem Khóa học
                        </a>
                        <button type="button" class="btn btn-primary" onclick="openCreateModal()" style="display: inline-flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            Thêm môn học mới
                        </button>
                    </div>
                </div>

                <!-- Toast Notification Container -->
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
                        <div class="kpi-icon-wrap">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="m16 6 4 14"/>
                                <path d="M12 6v14"/>
                                <path d="M8 8v12"/>
                                <path d="M4 4v16"/>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${totalSubjects}</div>
                            <div class="kpi-lbl">Tổng số môn học</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap success">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${activeCount}</div>
                            <div class="kpi-lbl">Môn đang giảng dạy</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap warning">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${inactiveCount}</div>
                            <div class="kpi-lbl">Môn tạm dừng</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap neutral">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                            </svg>
                        </div>
                        <div>
                            <div class="kpi-val">${totalCourses}</div>
                            <div class="kpi-lbl">Tổng khóa học liên kết</div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Table Card -->
                <div class="content-card">
                    <div class="table-toolbar">
                        <div class="table-title">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="8" y1="6" x2="21" y2="6"></line>
                                <line x1="8" y1="12" x2="21" y2="12"></line>
                                <line x1="8" y1="18" x2="21" y2="18"></line>
                                <line x1="3" y1="6" x2="3.01" y2="6"></line>
                                <line x1="3" y1="12" x2="3.01" y2="12"></line>
                                <line x1="3" y1="18" x2="3.01" y2="18"></line>
                            </svg>
                            Danh sách Môn học (${totalSubjects})
                        </div>
                        <div style="font-size: var(--font-size-xs); color: var(--text-muted);">
                            Hệ thống bảo vệ BR16: Không thể tắt môn học đang có khóa học mở tuyển sinh.
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty subjects}">
                            <!-- Empty State -->
                            <div style="padding: 60px 20px; text-align: center;">
                                <div style="width: 64px; height: 64px; margin: 0 auto 16px; border-radius: 50%; background: var(--bg); display: flex; align-items: center; justify-content: center; color: var(--text-muted);">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                                        <line x1="9" y1="9" x2="15" y2="9"></line>
                                        <line x1="9" y1="13" x2="13" y2="13"></line>
                                    </svg>
                                </div>
                                <h3 style="font-size: var(--font-size-lg); font-weight: 700; color: var(--text); margin: 0 0 8px 0;">Chưa có môn học nào</h3>
                                <p style="font-size: var(--font-size-sm); color: var(--text-muted); max-width: 400px; margin: 0 auto 20px auto;">
                                    Bắt đầu xây dựng chương trình đào tạo bằng cách thêm môn học đầu tiên.
                                </p>
                                <button type="button" class="btn btn-primary" onclick="openCreateModal()">
                                    Thêm môn học ngay
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="overflow-x: auto;">
                                <table class="table" style="width: 100%; border-collapse: collapse; text-align: left;">
                                    <thead>
                                        <tr style="border-bottom: 1px solid var(--border); background: var(--bg); font-size: var(--font-size-xs); font-weight: 600; color: var(--text-muted); text-transform: uppercase;">
                                            <th style="padding: 12px 20px;">Mã môn</th>
                                            <th style="padding: 12px 16px;">Tên môn học</th>
                                            <th style="padding: 12px 16px;">Mô tả / Mục tiêu</th>
                                            <th style="padding: 12px 16px; text-align: center;">Khóa học trực thuộc</th>
                                            <th style="padding: 12px 16px; text-align: center;">Trạng thái</th>
                                            <th style="padding: 12px 20px; text-align: right;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="s" items="${subjects}">
                                            <tr style="border-bottom: 1px solid var(--border); font-size: var(--font-size-sm); transition: background var(--transition-fast);">
                                                <td style="padding: 14px 20px;">
                                                    <span class="code-badge">${s.code}</span>
                                                </td>
                                                <td style="padding: 14px 16px; font-weight: 600; color: var(--text);">
                                                    ${s.name}
                                                </td>
                                                <td style="padding: 14px 16px; color: var(--text-muted); max-width: 320px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                    <c:out value="${empty s.description ? '—' : s.description}" />
                                                </td>
                                                <td style="padding: 14px 16px; text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/staff/courses?subjectId=${s.id}" style="color: var(--primary); text-decoration: none; font-weight: 600;">
                                                        ${s.totalCourses} khóa
                                                    </a>
                                                    <c:if test="${s.openCourses > 0}">
                                                        <span style="font-size: 11px; color: var(--success); display: block; font-weight: 500;">
                                                            (${s.openCourses} đang mở)
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td style="padding: 14px 16px; text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${s.status == 'ACTIVE'}">
                                                            <span class="status-badge active">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--success);"></span>
                                                                Đang mở
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge inactive">
                                                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--warning);"></span>
                                                                Tạm dừng
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 14px 20px; text-align: right;">
                                                    <div style="display: inline-flex; align-items: center; gap: 8px;">
                                                        <!-- Edit Button -->
                                                        <button type="button" class="btn btn-sm btn-secondary"
                                                                onclick="openEditModal('${s.id}', '${s.code}', '${s.name}', '${s.description}', '${s.status}')"
                                                                title="Chỉnh sửa thông tin môn học"
                                                                style="padding: 6px 10px; display: inline-flex; align-items: center; gap: 4px;">
                                                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                <path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"/>
                                                            </svg>
                                                            Sửa
                                                        </button>

                                                        <!-- Toggle Status Form -->
                                                        <form method="POST" action="${pageContext.request.contextPath}/staff/subjects/status" style="margin: 0;" onsubmit="return confirmToggleStatus('${s.name}', '${s.status}', ${s.openCourses});">
                                                            <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                                                            <input type="hidden" name="id" value="${s.id}">
                                                            <c:choose>
                                                                <c:when test="${s.status == 'ACTIVE'}">
                                                                    <button type="submit" class="btn btn-sm" style="padding: 6px 10px; background: none; border: 1px solid var(--border); color: var(--warning); display: inline-flex; align-items: center; gap: 4px;" title="Tạm ngừng môn học">
                                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                            <circle cx="12" cy="12" r="10"></circle>
                                                                            <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line>
                                                                        </svg>
                                                                        Dừng
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="submit" class="btn btn-sm" style="padding: 6px 10px; background: none; border: 1px solid var(--border); color: var(--success); display: inline-flex; align-items: center; gap: 4px;" title="Kích hoạt lại môn học">
                                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                                            <polyline points="20 6 9 17 4 12"></polyline>
                                                                        </svg>
                                                                        Mở lại
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Subject Create/Edit Modal -->
            <div id="subjectModal" class="modal-overlay" onclick="handleBackdropClick(event)">
                <div class="modal-container" onclick="event.stopPropagation()">
                    <div class="modal-header">
                        <h3 class="modal-title" id="modalHeaderTitle">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                            </svg>
                            <span id="modalTitleText">Thêm môn học mới</span>
                        </h3>
                        <button type="button" class="btn btn-sm btn-ghost" onclick="closeSubjectModal()" style="border: none; background: none; cursor: pointer; color: var(--text-muted);">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="18" y1="6" x2="6" y2="18"></line>
                                <line x1="6" y1="6" x2="18" y2="18"></line>
                            </svg>
                        </button>
                    </div>
                    <form method="POST" action="${pageContext.request.contextPath}/staff/subjects/save">
                        <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                        <input type="hidden" id="modalSubjectId" name="id" value="">

                        <div class="modal-body">
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="modalSubjectCode" class="form-label" style="display: block; font-size: var(--font-size-sm); font-weight: 600; color: var(--text); margin-bottom: 6px;">
                                    Mã môn học <span style="color: var(--danger);">*</span>
                                </label>
                                <input type="text" id="modalSubjectCode" name="code" class="form-control" required
                                       placeholder="Ví dụ: MATH, PHYS, CHEM, ENG"
                                       maxlength="20"
                                       style="width: 100%; text-transform: uppercase; font-family: monospace;">
                                <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-top: 4px;">
                                    Mã duy nhất, viết hoa, không dấu cách. Dùng làm tiền tố mã lớp và mã khóa.
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="modalSubjectName" class="form-label" style="display: block; font-size: var(--font-size-sm); font-weight: 600; color: var(--text); margin-bottom: 6px;">
                                    Tên môn học <span style="color: var(--danger);">*</span>
                                </label>
                                <input type="text" id="modalSubjectName" name="name" class="form-control" required
                                       placeholder="Ví dụ: Toán học, Vật lý, Hóa học..."
                                       maxlength="100" style="width: 100%;">
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label for="modalSubjectDesc" class="form-label" style="display: block; font-size: var(--font-size-sm); font-weight: 600; color: var(--text); margin-bottom: 6px;">
                                    Mô tả / Đề cương tóm tắt
                                </label>
                                <textarea id="modalSubjectDesc" name="description" class="form-control" rows="3"
                                          placeholder="Mô tả định hướng đào tạo của bộ môn..."
                                          maxlength="500" style="width: 100%;"></textarea>
                            </div>

                            <div class="form-group" style="margin-bottom: 8px;">
                                <label for="modalSubjectStatus" class="form-label" style="display: block; font-size: var(--font-size-sm); font-weight: 600; color: var(--text); margin-bottom: 6px;">
                                    Trạng thái hoạt động
                                </label>
                                <select id="modalSubjectStatus" name="status" class="form-control" style="width: 100%;">
                                    <option value="ACTIVE">Đang giảng dạy (ACTIVE)</option>
                                    <option value="INACTIVE">Tạm ngừng nhận lớp mới (INACTIVE)</option>
                                </select>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeSubjectModal()">Hủy bỏ</button>
                            <button type="submit" class="btn btn-primary" id="btnSaveSubject">Lưu môn học</button>
                        </div>
                    </form>
                </div>
            </div>

            <%@ include file="/WEB-INF/views/common/footer.jspf" %>
        </main>
    </div>

    <script>
        function openCreateModal() {
            document.getElementById('modalTitleText').textContent = 'Thêm môn học mới';
            document.getElementById('modalSubjectId').value = '';
            document.getElementById('modalSubjectCode').value = '';
            document.getElementById('modalSubjectName').value = '';
            document.getElementById('modalSubjectDesc').value = '';
            document.getElementById('modalSubjectStatus').value = 'ACTIVE';
            document.getElementById('btnSaveSubject').textContent = 'Tạo môn học';
            document.getElementById('subjectModal').classList.add('open');
            setTimeout(() => document.getElementById('modalSubjectCode').focus(), 100);
        }

        function openEditModal(id, code, name, desc, status) {
            document.getElementById('modalTitleText').textContent = 'Chỉnh sửa môn học: ' + name;
            document.getElementById('modalSubjectId').value = id;
            document.getElementById('modalSubjectCode').value = code;
            document.getElementById('modalSubjectName').value = name;
            document.getElementById('modalSubjectDesc').value = (desc && desc !== 'null') ? desc : '';
            document.getElementById('modalSubjectStatus').value = status;
            document.getElementById('btnSaveSubject').textContent = 'Lưu thay đổi';
            document.getElementById('subjectModal').classList.add('open');
            setTimeout(() => document.getElementById('modalSubjectName').focus(), 100);
        }

        function closeSubjectModal() {
            document.getElementById('subjectModal').classList.remove('open');
        }

        function handleBackdropClick(event) {
            if (event.target === document.getElementById('subjectModal')) {
                closeSubjectModal();
            }
        }

        function confirmToggleStatus(subjectName, currentStatus, openCourses) {
            if (currentStatus === 'ACTIVE' && openCourses > 0) {
                alert('Không thể tạm ngừng môn học "' + subjectName + '" vì hiện có ' + openCourses + ' khóa học đang mở tuyển sinh!\nVui lòng đóng hoặc chuyển lưu trữ các khóa học trực thuộc trước (Quy tắc BR16).');
                return false;
            }
            const actionText = (currentStatus === 'ACTIVE') ? 'tạm ngừng giảng dạy' : 'kích hoạt lại';
            return confirm('Bạn có chắc chắn muốn ' + actionText + ' môn học "' + subjectName + '"?');
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeSubjectModal();
            }
        });
    </script>
</body>
</html>
