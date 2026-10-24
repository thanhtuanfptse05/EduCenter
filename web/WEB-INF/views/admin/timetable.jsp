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
    <title>Thời khóa biểu giảng dạy &amp; học tập | EduCenter ERP</title>
    <style>
        .timetable-wrap {
            display: flex;
            flex-direction: column;
            gap: 20px;
            width: 100%;
        }

        .timetable-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 12px;
            align-items: stretch;
        }
        @media (max-width: 1400px) {
            .timetable-grid { grid-template-columns: repeat(4, 1fr); }
        }
        @media (max-width: 992px) {
            .timetable-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .timetable-grid { grid-template-columns: 1fr; }
        }

        .day-column {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 540px;
            box-shadow: var(--shadow-sm);
            transition: box-shadow 0.2s, border-color 0.2s;
        }
        .day-column:hover {
            box-shadow: var(--shadow-md);
        }
        .day-column.today {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px var(--primary-subtle);
        }

        .day-header {
            padding: 12px 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--surface-muted);
            border-bottom: 1px solid var(--border);
        }
        .day-column.today .day-header {
            background: var(--primary-subtle);
        }
        .day-title {
            font-size: 13.5px;
            font-weight: 700;
            color: var(--text);
        }
        .day-column.today .day-title {
            color: var(--primary);
        }
        .day-date {
            font-size: 11.5px;
            color: var(--text-muted);
            font-weight: 600;
        }
        .session-count-badge {
            font-size: 11px;
            background: var(--border);
            color: var(--text-muted);
            padding: 2px 7px;
            border-radius: 999px;
            font-weight: 700;
        }
        .day-column.today .session-count-badge {
            background: var(--primary);
            color: #FFF;
        }

        .day-content {
            padding: 10px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            flex: 1;
            background: var(--surface);
        }

        /* Session Cards */
        .card-session {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 12px;
            position: relative;
            box-shadow: var(--shadow-sm);
            transition: transform 0.15s, box-shadow 0.15s, border-color 0.15s;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .card-session:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .card-session.theme-math { border-left: 4px solid #2563eb; }
        .card-session.theme-eng  { border-left: 4px solid #059669; }
        .card-session.theme-phys { border-left: 4px solid #d97706; }
        .card-session.theme-lit  { border-left: 4px solid #db2777; }
        .card-session.theme-vip  { border-left: 4px solid #7c3aed; }
        .card-session.theme-default { border-left: 4px solid var(--primary); }

        .card-session.status-completed {
            opacity: 0.9;
            background: var(--surface-muted);
        }

        .card-session-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .time-highlight {
            font-size: 12.5px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 4px;
            color: var(--text);
            font-family: monospace;
        }
        .subject-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 4px;
            background: var(--surface-muted);
            color: var(--text-muted);
        }
        .card-session.theme-math .subject-badge { background: #dbeafe; color: #1e40af; }
        .card-session.theme-eng  .subject-badge { background: #d1fae5; color: #065f46; }
        .card-session.theme-phys .subject-badge { background: #fef3c7; color: #92400e; }
        .card-session.theme-lit  .subject-badge { background: #fce7f3; color: #9d174d; }
        .card-session.theme-vip  .subject-badge { background: #ede9fe; color: #5b21b6; }

        .class-title-link {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
            text-decoration: none;
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            transition: color 0.15s;
        }
        .class-title-link:hover {
            color: var(--primary);
        }

        .session-topic {
            font-size: 11.5px;
            color: var(--text-muted);
            line-height: 1.3;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .card-meta-chips {
            display: flex;
            flex-direction: column;
            gap: 3px;
            margin-top: 2px;
            padding-top: 6px;
            border-top: 1px dashed var(--border);
        }
        .meta-chip {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            color: var(--text-muted);
        }
        .meta-chip svg {
            color: var(--primary);
            flex-shrink: 0;
            width: 13px;
            height: 13px;
        }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 10.5px;
            font-weight: 700;
            margin-top: 4px;
        }
        .status-pill.scheduled { color: #0284c7; }
        .status-pill.completed { color: #059669; }
        .status-pill.past      { color: var(--text-muted); }
        .status-pill.happening { color: #059669; font-weight: 800; }
        .status-pill.cancelled { color: #dc2626; }

        .day-empty {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            font-size: 12px;
            padding: 30px 10px;
            text-align: center;
            opacity: 0.6;
        }
    </style>
</head>
<body class="admin-body">
<div class="admin-layout">
    <c:set var="breadcrumb" value="Học vụ &amp; Đào tạo / Thời khóa biểu giảng dạy" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="timetable-wrap">
                <!-- 1. Header & Actions -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <c:choose>
                                <c:when test="${isAdmin}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard">Trung tâm điều hành</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/staff/dashboard">Tuyển sinh &amp; CRM</a>
                                </c:otherwise>
                            </c:choose>
                            <span style="opacity: 0.5;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Thời khóa biểu tuần</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Thời khóa biểu giảng dạy &amp; học tập</h1>
                            <span class="mgmt-badge-version">WF-02 / UC19</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Ma trận lịch học trực quan theo tuần, phân biệt rõ ràng màu sắc từng môn học, giáo viên phụ trách và phòng lab tiêu chuẩn.
                        </p>
                    </div>

                    <div class="mgmt-header-actions">
                        <c:choose>
                            <c:when test="${isAdmin}">
                                <a href="${pageContext.request.contextPath}/admin/classes" class="mgmt-btn mgmt-btn-outline">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="19" y1="12" x2="5" y2="12"></line>
                                        <polyline points="12 19 5 12 12 5"></polyline>
                                    </svg>
                                    <span>Danh sách Lớp học</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/classes/create" class="mgmt-btn mgmt-btn-primary">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19"></line>
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                    </svg>
                                    <span>Tạo lớp mới</span>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/staff/classes" class="mgmt-btn mgmt-btn-outline">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                    </svg>
                                    <span>Tra cứu lớp tuyển sinh</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/staff/enrollments" class="mgmt-btn mgmt-btn-primary">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <line x1="19" y1="8" x2="19" y2="14"></line>
                                        <line x1="22" y1="11" x2="16" y2="11"></line>
                                    </svg>
                                    <span>Ghi danh học viên</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 2. Top KPI Metrics Ribbon (Statistics ON TOP of the timetable) -->
                <c:set var="totalWeekSessions" value="0" />
                <c:set var="scheduledWeekSessions" value="0" />
                <c:set var="completedWeekSessions" value="0" />
                <c:forEach var="dayD" items="${grid.daysOfWeek}">
                    <c:forEach var="s" items="${grid.getSessionsForDate(dayD)}">
                        <c:set var="totalWeekSessions" value="${totalWeekSessions + 1}" />
                        <c:choose>
                            <c:when test="${s.status == 'COMPLETED' or s.displayStatusBadge == 'COMPLETED' or s.displayStatusBadge == 'PAST'}">
                                <c:set var="completedWeekSessions" value="${completedWeekSessions + 1}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="scheduledWeekSessions" value="${scheduledWeekSessions + 1}" />
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </c:forEach>

                <div class="tt-kpi-grid-4">
                    <div class="crm-kpi-card">
                        <div class="crm-kpi-header">
                            <span class="crm-kpi-label">Tổng ca học trong tuần</span>
                            <div class="crm-kpi-icon-wrap primary">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </div>
                        </div>
                        <div class="crm-kpi-val-row">
                            <span class="crm-kpi-val">${totalWeekSessions}</span>
                            <span class="crm-kpi-sub">buổi học / tuần</span>
                        </div>
                        <div class="crm-kpi-bar">
                            <div class="crm-kpi-bar-fill" style="width: 100%; background: var(--primary);"></div>
                        </div>
                    </div>

                    <div class="crm-kpi-card">
                        <div class="crm-kpi-header">
                            <span class="crm-kpi-label">Sắp &amp; Đang diễn ra</span>
                            <div class="crm-kpi-icon-wrap info">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </div>
                        </div>
                        <div class="crm-kpi-val-row">
                            <span class="crm-kpi-val" style="color: #0284c7;">${scheduledWeekSessions}</span>
                            <span class="crm-kpi-sub" style="color: #0284c7;">ca học cần phục vụ</span>
                        </div>
                        <div class="crm-kpi-bar">
                            <c:set var="totS" value="${totalWeekSessions > 0 ? totalWeekSessions : 1}" />
                            <div class="crm-kpi-bar-fill" style="width: ${(scheduledWeekSessions * 100.0) / totS}%; background: #0284c7;"></div>
                        </div>
                    </div>

                    <div class="crm-kpi-card">
                        <div class="crm-kpi-header">
                            <span class="crm-kpi-label">Đã hoàn tất</span>
                            <div class="crm-kpi-icon-wrap success">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            </div>
                        </div>
                        <div class="crm-kpi-val-row">
                            <span class="crm-kpi-val" style="color: #059669;">${completedWeekSessions}</span>
                            <span class="crm-kpi-sub" style="color: #059669;">buổi có sổ đầu bài</span>
                        </div>
                        <div class="crm-kpi-bar">
                            <div class="crm-kpi-bar-fill" style="width: ${(completedWeekSessions * 100.0) / totS}%; background: #059669;"></div>
                        </div>
                    </div>

                    <div class="crm-kpi-card">
                        <div class="crm-kpi-header">
                            <span class="crm-kpi-label">Khung ca học chuẩn</span>
                            <div class="crm-kpi-icon-wrap warning">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><path d="M12 6v6l4 2"></path></svg>
                            </div>
                        </div>
                        <div class="crm-kpi-val-row">
                            <span class="crm-kpi-val" style="color: #d97706;">3</span>
                            <span class="crm-kpi-sub">Khung ca/ngày (Sáng-Chiều-Tối)</span>
                        </div>
                        <div class="crm-kpi-bar">
                            <div class="crm-kpi-bar-fill" style="width: 100%; background: #d97706;"></div>
                        </div>
                    </div>
                </div>

                <!-- 3. Navigation Bar (Week Switcher & Date Picker) -->
                <div class="tt-nav-bar">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <a href="?date=${prevMonday}" class="mgmt-btn mgmt-btn-outline" title="Xem tuần trước">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="15 18 9 12 15 6"></polyline>
                            </svg>
                            <span>Tuần trước</span>
                        </a>
                        <a href="?date=" class="mgmt-btn mgmt-btn-outline" title="Về tuần hiện tại">
                            <span>Tuần hiện tại</span>
                        </a>
                        <a href="?date=${nextMonday}" class="mgmt-btn mgmt-btn-outline" title="Xem tuần tiếp theo">
                            <span>Tuần sau</span>
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="9 18 15 12 9 6"></polyline>
                            </svg>
                        </a>
                    </div>

                    <div class="tt-week-range-pill">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                            <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                            <line x1="16" y1="2" x2="16" y2="6"></line>
                            <line x1="8" y1="2" x2="8" y2="6"></line>
                            <line x1="3" y1="10" x2="21" y2="10"></line>
                        </svg>
                        <span>${weekRangeLabel}</span>
                    </div>

                    <div>
                        <form method="get" action="" style="display: flex; align-items: center; gap: 8px; margin: 0;">
                            <input type="date" name="date" class="mgmt-input" style="font-size: 13px; height: 34px; width: 150px;" value="${currentMonday}">
                            <button type="submit" class="mgmt-btn mgmt-btn-primary" style="height: 34px; padding: 0 12px;">Chọn tuần</button>
                        </form>
                    </div>
                </div>

                <!-- 4. Legend Ribbon & Time Slot Hints -->
                <div class="tt-legend-card">
                    <div style="display: flex; align-items: center; gap: 14px; flex-wrap: wrap;">
                        <span style="font-weight: 700; color: var(--text-muted); font-size: 11.5px; text-transform: uppercase; letter-spacing: 0.03em;">Môn học:</span>
                        <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 12.5px;">
                            <span class="mgmt-dot" style="background: #2563eb;"></span> <span>Toán học</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 12.5px;">
                            <span class="mgmt-dot" style="background: #059669;"></span> <span>Tiếng Anh</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 12.5px;">
                            <span class="mgmt-dot" style="background: #d97706;"></span> <span>Vật Lý</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 12.5px;">
                            <span class="mgmt-dot" style="background: #db2777;"></span> <span>Ngữ Văn</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; font-size: 12.5px;">
                            <span class="mgmt-dot" style="background: #7c3aed;"></span> <span>Lớp kèm VIP 1-1</span>
                        </div>
                    </div>

                    <div style="font-size: 12px; color: var(--text-muted); display: flex; gap: 14px; flex-wrap: wrap;">
                        <span>&bull; Ca sáng: <strong>08:00 - 10:00</strong></span>
                        <span>&bull; Ca chiều: <strong>14:00 - 16:00</strong></span>
                        <span>&bull; Ca tối: <strong>18:00 - 20:00</strong></span>
                    </div>
                </div>

                <!-- 5. 7-Day Timetable Grid Matrix -->
                <div class="timetable-grid">
                    <c:forEach var="dayDate" items="${grid.daysOfWeek}" varStatus="loop">
                        <c:set var="daySessions" value="${grid.getSessionsForDate(dayDate)}" />
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate var="todayStr" value="${now}" pattern="yyyy-MM-dd" />
                        <c:set var="isToday" value="${dayDate.toString() == todayStr}" />
                        
                        <div class="day-column ${isToday ? 'today' : ''}">
                            <div class="day-header">
                                <div>
                                    <div class="day-title">
                                        <c:choose>
                                            <c:when test="${loop.index == 0}">Thứ 2</c:when>
                                            <c:when test="${loop.index == 1}">Thứ 3</c:when>
                                            <c:when test="${loop.index == 2}">Thứ 4</c:when>
                                            <c:when test="${loop.index == 3}">Thứ 5</c:when>
                                            <c:when test="${loop.index == 4}">Thứ 6</c:when>
                                            <c:when test="${loop.index == 5}">Thứ 7</c:when>
                                            <c:when test="${loop.index == 6}">Chủ nhật</c:when>
                                        </c:choose>
                                        <c:if test="${isToday}">
                                            <span style="font-size: 11px; font-weight: 700; color: var(--primary); margin-left: 4px;">(Hôm nay)</span>
                                        </c:if>
                                    </div>
                                    <div class="day-date">
                                        ${grid.formatDay(dayDate)}
                                    </div>
                                </div>
                                <span class="session-count-badge" title="Số lượng ca học trong ngày">
                                    ${daySessions.size()} ca
                                </span>
                            </div>

                            <div class="day-content">
                                <c:choose>
                                    <c:when test="${not empty daySessions}">
                                        <c:forEach var="sess" items="${daySessions}">
                                            <div class="card-session theme-${sess.colorCategory} ${sess.status == 'COMPLETED' ? 'status-completed' : ''}">
                                                <!-- Top: Giờ học & Badge môn -->
                                                <div class="card-session-top">
                                                    <div class="time-highlight">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                                        <span>${sess.formattedTime}</span>
                                                    </div>
                                                    <span class="subject-badge">
                                                        <c:choose>
                                                            <c:when test="${sess.colorCategory == 'math'}">Toán</c:when>
                                                            <c:when test="${sess.colorCategory == 'eng'}">Tiếng Anh</c:when>
                                                            <c:when test="${sess.colorCategory == 'phys'}">Vật Lý</c:when>
                                                            <c:when test="${sess.colorCategory == 'lit'}">Ngữ Văn</c:when>
                                                            <c:when test="${sess.colorCategory == 'vip'}">VIP 1-1</c:when>
                                                            <c:otherwise>${sess.classCode}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>

                                                <!-- Tên lớp học Link -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${isAdmin}">
                                                            <a href="${pageContext.request.contextPath}/admin/classes/detail?id=${sess.classId}" class="class-title-link" title="Bấm để xem chi tiết lớp">
                                                                <c:out value="${sess.className}" />
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${sess.classId}" class="class-title-link" title="Bấm để xem chi tiết lớp">
                                                                <c:out value="${sess.className}" />
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Tiêu đề / Nội dung buổi học -->
                                                <c:if test="${not empty sess.title}">
                                                    <div class="session-topic" title="<c:out value='${sess.title}' />">
                                                        <c:out value="${sess.title}" />
                                                    </div>
                                                </c:if>

                                                <!-- Metadata: Phòng & Giáo viên -->
                                                <div class="card-meta-chips">
                                                    <div class="meta-chip">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                                        <span><strong><c:out value="${sess.roomCode}" /></strong> &bull; <c:out value="${sess.roomName}" /></span>
                                                    </div>
                                                    <div class="meta-chip">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                                        <span><c:out value="${sess.teacherName}" /></span>
                                                    </div>
                                                </div>

                                                <!-- Trạng thái ca học -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${sess.status == 'COMPLETED' or sess.displayStatusBadge == 'COMPLETED'}">
                                                            <span class="status-pill completed">&#10003; Đã hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${sess.status == 'CANCELLED' or sess.displayStatusBadge == 'CANCELLED'}">
                                                            <span class="status-pill cancelled">&#10005; Đã hủy</span>
                                                        </c:when>
                                                        <c:when test="${sess.displayStatusBadge == 'PAST'}">
                                                            <span class="status-pill past">&#10003; Đã kết thúc</span>
                                                        </c:when>
                                                        <c:when test="${sess.displayStatusBadge == 'HAPPENING'}">
                                                            <span class="status-pill happening">&bull; Đang diễn ra</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-pill scheduled">&bull; Sắp diễn ra</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="day-empty">
                                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 6px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                            Không có lịch học
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
