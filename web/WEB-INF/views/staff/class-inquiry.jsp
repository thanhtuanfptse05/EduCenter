<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="internalShell" value="true" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .kpi-row-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 768px) {
            .kpi-row-3 { grid-template-columns: 1fr; }
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
        .kpi-val { font-size: 24px; font-weight: 700; color: var(--text); line-height: 1.2; }
        .kpi-lbl { font-size: 11px; color: var(--text-muted); font-weight: 500; text-transform: uppercase; margin-top: 2px; }

        .slots-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 3px 8px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }
        .slots-available { background: var(--success-subtle); color: var(--success); }
        .slots-full { background: var(--danger-subtle); color: var(--danger); }
        .slots-low { background: var(--warning-subtle); color: var(--warning); }
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
                        <h1 class="page-title">Tra cứu Lớp học Tuyển sinh</h1>
                        <p class="page-subtitle">Kiểm tra sĩ số còn trống, thời gian học và thời khóa biểu để tư vấn phụ huynh / học viên</p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/staff/timetable" class="btn btn-secondary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            Tra cứu Thời khóa biểu tuần
                        </a>
                    </div>
                </div>

                <!-- KPI Tuyển sinh -->
                <div class="kpi-row-3">
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap success">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.openClasses}</div>
                            <div class="kpi-lbl">Lớp học đang mở tuyển sinh (OPEN)</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap info">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.ongoingClasses}</div>
                            <div class="kpi-lbl">Lớp đang diễn ra (ONGOING)</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap">
                            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${stats.totalClasses}</div>
                            <div class="kpi-lbl">Tổng số lớp học trong hệ thống</div>
                        </div>
                    </div>
                </div>

                <!-- Bảng tra cứu & Bộ lọc -->
                <div class="content-card">
                    <div class="filter-panel" style="padding: 16px 20px; border-bottom: 1px solid var(--border);">
                        <form method="get" action="${pageContext.request.contextPath}/staff/classes" style="display: flex; gap: 12px; flex-wrap: wrap; align-items: flex-end;">
                            <div class="form-group" style="margin-bottom: 0; min-width: 220px; flex: 1;">
                                <label class="form-label">Tìm theo mã hoặc tên lớp</label>
                                <input type="text" name="keyword" class="form-control" placeholder="Nhập từ khóa..." value="${filter.keyword}">
                            </div>
                            <div class="form-group" style="margin-bottom: 0; min-width: 200px;">
                                <label class="form-label">Khóa học</label>
                                <select name="courseId" class="form-control">
                                    <option value="">-- Tất cả khóa học --</option>
                                    <c:forEach var="crs" items="${courses}">
                                        <option value="${crs.id}" ${filter.courseId == crs.id ? 'selected' : ''}>${crs.code} - ${crs.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group" style="margin-bottom: 0; min-width: 160px;">
                                <label class="form-label">Trạng thái</label>
                                <select name="status" class="form-control">
                                    <option value="ALL">-- Tất cả --</option>
                                    <option value="OPEN" ${filter.status == 'OPEN' ? 'selected' : ''}>Mở tuyển sinh (OPEN)</option>
                                    <option value="ONGOING" ${filter.status == 'ONGOING' ? 'selected' : ''}>Đang diễn ra (ONGOING)</option>
                                    <option value="PLANNING" ${filter.status == 'PLANNING' ? 'selected' : ''}>Kế hoạch (PLANNING)</option>
                                </select>
                            </div>
                            <div style="display: flex; gap: 8px;">
                                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                                <a href="${pageContext.request.contextPath}/staff/classes" class="btn btn-secondary">Đặt lại</a>
                            </div>
                        </form>
                    </div>

                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 120px;">Mã lớp</th>
                                    <th>Tên lớp học & Khóa học</th>
                                    <th>Giáo viên phụ trách</th>
                                    <th>Phòng học</th>
                                    <th style="width: 130px;">Sĩ số hiện tại</th>
                                    <th style="width: 140px;">Chỗ còn trống</th>
                                    <th style="width: 150px;">Thời gian học</th>
                                    <th style="width: 110px; text-align: right;">Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty classes}">
                                        <c:forEach var="cItem" items="${classes}">
                                            <tr>
                                                <td>
                                                    <span style="font-family: monospace; font-weight: 700; color: var(--primary); background: var(--primary-subtle); padding: 2px 6px; border-radius: 4px; font-size: 12px;">
                                                        ${cItem.code}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);">${cItem.name}</div>
                                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                                        Khóa: <strong>${cItem.courseName}</strong> (${cItem.courseCode})
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-size: 13px; font-weight: 500;">
                                                        ${cItem.teacherName != null ? cItem.teacherName : 'Chưa phân công'}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-size: 13px;">
                                                        ${cItem.roomName != null ? cItem.roomName : 'Chưa gán'}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-size: 13px; font-weight: 600;">
                                                        ${cItem.enrolledCount} / ${cItem.capacity}
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${cItem.remainingSlots > 3}">
                                                            <span class="slots-badge slots-available">Còn ${cItem.remainingSlots} chỗ</span>
                                                        </c:when>
                                                        <c:when test="${cItem.remainingSlots > 0}">
                                                            <span class="slots-badge slots-low">Sắp đầy (${cItem.remainingSlots})</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="slots-badge slots-full">Đã đủ sĩ số</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div style="font-size: 12px; color: var(--text-muted);">
                                                        <c:out value="${cItem.formattedStartDate}" /> &rarr; <c:out value="${cItem.formattedEndDate}" />
                                                    </div>
                                                </td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${cItem.id}" class="btn btn-sm btn-secondary">
                                                        Xem lịch
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8">
                                                <div style="padding: 40px; text-align: center; color: var(--text-muted);">
                                                    Không tìm thấy lớp học nào phù hợp với điều kiện tìm kiếm.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
