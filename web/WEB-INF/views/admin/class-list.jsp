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
        .kpi-icon-wrap.info { background: #e0f2fe; color: #0284c7; }
        .kpi-icon-wrap.warning { background: var(--warning-subtle); color: var(--warning); }
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
            grid-template-columns: 2fr 1.5fr 1.2fr auto;
            gap: 12px;
            align-items: flex-end;
        }
        @media (max-width: 992px) {
            .filter-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px) {
            .filter-grid { grid-template-columns: 1fr; }
        }
        .class-code-badge {
            font-family: monospace;
            font-weight: 600;
            color: var(--primary);
            background: var(--primary-subtle);
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: 12px;
            display: inline-block;
        }
        .capacity-bar-wrap {
            width: 100%;
            background: var(--border);
            height: 6px;
            border-radius: 3px;
            overflow: hidden;
            margin-top: 4px;
        }
        .capacity-bar-fill {
            height: 100%;
            background: var(--primary);
            border-radius: 3px;
        }
        .capacity-bar-fill.warning { background: var(--warning); }
        .capacity-bar-fill.danger { background: var(--danger); }
        .badge-planning { background: var(--bg); color: var(--text-muted); border: 1px solid var(--border); }
        .badge-open { background: var(--success-subtle); color: var(--success); }
        .badge-ongoing { background: #e0f2fe; color: #0284c7; }
        .badge-closed { background: #f1f5f9; color: #64748b; }
        .badge-cancelled { background: var(--danger-subtle); color: var(--danger); }
        .empty-state {
            padding: 48px 24px;
            text-align: center;
        }
        .empty-state-icon {
            width: 56px;
            height: 56px;
            margin: 0 auto 16px;
            color: var(--text-muted);
            opacity: 0.5;
        }
    </style>
</head>
<body class="admin-body">
    <div class="admin-layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div class="content-header">
                    <div>
                        <h1 class="page-title">Quản lý Lớp học & Lịch giảng dạy</h1>
                        <p class="page-subtitle">Tạo lớp học, phân công giáo viên, gán phòng học và xếp lịch chi tiết</p>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/admin/timetable" class="btn btn-secondary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            Thời khóa biểu tuần
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-secondary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                            Quản lý Phòng học
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/classes/create" class="btn btn-primary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Tạo lớp học mới
                        </a>
                    </div>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        <span>${flashSuccess}</span>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span>${flashError}</span>
                    </div>
                </c:if>

                <!-- KPI Thống kê -->
                <div class="kpi-row">
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.totalClasses}</div>
                            <div class="kpi-lbl">Tổng số lớp học</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap success">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.openClasses}</div>
                            <div class="kpi-lbl">Đang mở tuyển sinh</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap info">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.ongoingClasses}</div>
                            <div class="kpi-lbl">Đang diễn ra</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap neutral">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="9" y1="9" x2="15" y2="15"/><line x1="15" y1="9" x2="9" y2="15"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.closedClasses}</div>
                            <div class="kpi-lbl">Đã kết thúc</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap warning">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.availableRooms} / ${stats.totalRooms}</div>
                            <div class="kpi-lbl">Phòng khả dụng</div>
                        </div>
                    </div>
                </div>

                <!-- Bảng danh sách & Bộ lọc -->
                <div class="content-card">
                    <div class="filter-panel">
                        <form method="get" action="${pageContext.request.contextPath}/admin/classes" class="filter-grid">
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Tìm kiếm lớp học</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Nhập mã hoặc tên lớp..." value="${filter.keyword}">
                            </div>
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Khóa học</label>
                                <select name="courseId" class="form-control">
                                    <option value="">-- Tất cả khóa học --</option>
                                    <c:forEach var="crs" items="${courses}">
                                        <option value="${crs.id}" ${filter.courseId == crs.id ? 'selected' : ''}>${crs.code} - ${crs.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group" style="margin-bottom: 0;">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-control">
                                    <option value="ALL">-- Tất cả trạng thái --</option>
                                    <option value="PLANNING" ${filter.status == 'PLANNING' ? 'selected' : ''}>Kế hoạch (PLANNING)</option>
                                    <option value="OPEN" ${filter.status == 'OPEN' ? 'selected' : ''}>Mở tuyển sinh (OPEN)</option>
                                    <option value="ONGOING" ${filter.status == 'ONGOING' ? 'selected' : ''}>Đang diễn ra (ONGOING)</option>
                                    <option value="CLOSED" ${filter.status == 'CLOSED' ? 'selected' : ''}>Đã đóng (CLOSED)</option>
                                    <option value="CANCELLED" ${filter.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy (CANCELLED)</option>
                                </select>
                            </div>
                            <div style="display: flex; gap: 8px;">
                                <button type="submit" class="btn btn-primary">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                    Lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-secondary">Đặt lại</a>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 130px;">Mã lớp</th>
                                    <th>Tên lớp học & Khóa học</th>
                                    <th>Giáo viên phụ trách</th>
                                    <th>Phòng học</th>
                                    <th style="width: 140px;">Sĩ số</th>
                                    <th style="width: 160px;">Thời gian học</th>
                                    <th style="width: 130px;">Trạng thái</th>
                                    <th style="width: 140px; text-align: right;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty classes}">
                                        <c:forEach var="cItem" items="${classes}">
                                            <tr>
                                                <td>
                                                    <span class="class-code-badge">${cItem.code}</span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);">${cItem.name}</div>
                                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                                        Khóa: <span style="color: var(--primary);">${cItem.courseName}</span> (${cItem.courseCode})
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                                        <span style="font-weight: 500;">${cItem.teacherName != null ? cItem.teacherName : 'Chưa phân công'}</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty cItem.roomName}">
                                                            <div style="display: flex; align-items: center; gap: 6px;">
                                                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--text-muted);"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                                                                <span>${cItem.roomName}</span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-muted); font-style: italic;">Chưa gán</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div style="display: flex; justify-content: space-between; font-size: 12px; font-weight: 600;">
                                                        <span>${cItem.enrolledCount} / ${cItem.capacity}</span>
                                                        <span style="color: ${cItem.remainingSlots > 0 ? 'var(--success)' : 'var(--danger)'};">
                                                            Còn ${cItem.remainingSlots}
                                                        </span>
                                                    </div>
                                                    <div class="capacity-bar-wrap">
                                                        <c:set var="pct" value="${(cItem.enrolledCount * 100) / cItem.capacity}" />
                                                        <div class="capacity-bar-fill ${pct >= 100 ? 'danger' : (pct >= 80 ? 'warning' : '')}" 
                                                             style="width: ${pct > 100 ? 100 : pct}%;"></div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-size: 13px;">
                                                        <fmt:parseDate value="${cItem.startDate}" pattern="yyyy-MM-dd" var="sDate" type="date"/>
                                                        <fmt:formatDate value="${sDate}" pattern="dd/MM/yyyy"/>
                                                        <span style="color: var(--text-muted);"> &rarr; </span>
                                                        <fmt:parseDate value="${cItem.endDate}" pattern="yyyy-MM-dd" var="eDate" type="date"/>
                                                        <fmt:formatDate value="${eDate}" pattern="dd/MM/yyyy"/>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${cItem.status == 'PLANNING'}">
                                                            <span class="badge badge-planning">Kế hoạch</span>
                                                        </c:when>
                                                        <c:when test="${cItem.status == 'OPEN'}">
                                                            <span class="badge badge-open">Mở tuyển sinh</span>
                                                        </c:when>
                                                        <c:when test="${cItem.status == 'ONGOING'}">
                                                            <span class="badge badge-ongoing">Đang học</span>
                                                        </c:when>
                                                        <c:when test="${cItem.status == 'CLOSED'}">
                                                            <span class="badge badge-closed">Đã đóng</span>
                                                        </c:when>
                                                        <c:when test="${cItem.status == 'CANCELLED'}">
                                                            <span class="badge badge-cancelled">Đã hủy</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge">${cItem.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <div style="display: inline-flex; gap: 6px;">
                                                        <a href="${pageContext.request.contextPath}/admin/classes/detail?id=${cItem.id}" 
                                                           class="btn btn-sm btn-secondary" title="Xem chi tiết & Lịch học">
                                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                            Chi tiết
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin/classes/edit?id=${cItem.id}" 
                                                           class="btn btn-sm btn-secondary" title="Chỉnh sửa thông tin">
                                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8">
                                                <div class="empty-state">
                                                    <svg class="empty-state-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                                                    <h3 style="font-size: 16px; font-weight: 600; color: var(--text); margin-bottom: 6px;">Không tìm thấy lớp học nào</h3>
                                                    <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">Chưa có lớp học nào phù hợp với điều kiện tìm kiếm hoặc chưa có dữ liệu trong hệ thống.</p>
                                                    <a href="${pageContext.request.contextPath}/admin/classes/create" class="btn btn-primary btn-sm">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                                        Tạo lớp học đầu tiên
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-wrapper" style="padding: 16px 20px; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border);">
                            <div style="font-size: 13px; color: var(--text-muted);">
                                Hiển thị trang ${currentPage} / ${totalPages} (Tổng cộng ${totalItems} lớp học)
                            </div>
                            <div class="pagination" style="display: flex; gap: 4px;">
                                <c:if test="${currentPage > 1}">
                                    <a href="?page=${currentPage - 1}&keyword=${filter.keyword}&courseId=${filter.courseId}&status=${filter.status}" class="btn btn-sm btn-secondary">&laquo; Trước</a>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <a href="?page=${p}&keyword=${filter.keyword}&courseId=${filter.courseId}&status=${filter.status}" 
                                       class="btn btn-sm ${p == currentPage ? 'btn-primary' : 'btn-secondary'}">${p}</a>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <a href="?page=${currentPage + 1}&keyword=${filter.keyword}&courseId=${filter.courseId}&status=${filter.status}" class="btn btn-sm btn-secondary">Sau &raquo;</a>
                                </c:if>
                            </div>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
