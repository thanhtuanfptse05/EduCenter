<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .timetable-nav {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        .timetable-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 12px;
            align-items: stretch;
        }
        @media (max-width: 1200px) {
            .timetable-grid { grid-template-columns: repeat(4, 1fr); }
        }
        @media (max-width: 768px) {
            .timetable-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 480px) {
            .timetable-grid { grid-template-columns: 1fr; }
        }
        .day-column {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 480px;
        }
        .day-column.today {
            border-color: var(--primary);
            box-shadow: 0 0 0 1px var(--primary);
        }
        .day-header {
            padding: 12px;
            text-align: center;
            background: var(--bg);
            border-bottom: 1px solid var(--border);
        }
        .day-column.today .day-header {
            background: var(--primary-subtle);
            color: var(--primary);
        }
        .day-title {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
        }
        .day-column.today .day-title {
            color: var(--primary);
        }
        .day-date {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
        }
        .day-content {
            padding: 10px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            flex: 1;
        }
        .session-card {
            background: var(--bg);
            border: 1px solid var(--border);
            border-left: 3px solid var(--primary);
            border-radius: var(--radius-sm);
            padding: 10px;
            font-size: 12px;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .session-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
            border-color: var(--primary);
        }
        .session-time {
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 4px;
            margin-bottom: 4px;
            font-size: 12px;
        }
        .session-class {
            font-weight: 600;
            color: var(--text);
            margin-bottom: 4px;
            line-height: 1.3;
        }
        .session-meta {
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 4px;
            margin-top: 2px;
        }
        .day-empty {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            font-size: 12px;
            font-style: italic;
            padding: 20px;
            text-align: center;
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
                        <h1 class="page-title">Thời khóa biểu giảng dạy</h1>
                        <p class="page-subtitle">Xem lịch học trực quan theo tuần của tất cả các lớp và phòng học</p>
                    </div>
                    <c:if test="${isAdmin}">
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-secondary">
                                &larr; Danh sách Lớp học
                            </a>
                        </div>
                    </c:if>
                </div>

                <!-- Điều hướng tuần -->
                <div class="timetable-nav">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <a href="?date=${prevMonday}" class="btn btn-sm btn-secondary">
                            &laquo; Tuần trước
                        </a>
                        <a href="?date=" class="btn btn-sm btn-secondary">
                            Hôm nay
                        </a>
                        <a href="?date=${nextMonday}" class="btn btn-sm btn-secondary">
                            Tuần sau &raquo;
                        </a>
                    </div>

                    <div style="font-size: 16px; font-weight: 700; color: var(--text); display: flex; align-items: center; gap: 8px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                        <span>${weekRangeLabel}</span>
                    </div>

                    <div>
                        <form method="get" action="" style="display: flex; gap: 6px;">
                            <input type="date" name="date" class="form-control" style="font-size: 13px; padding: 6px 10px;" value="${currentMonday}">
                            <button type="submit" class="btn btn-sm btn-primary">Xem tuần</button>
                        </form>
                    </div>
                </div>

                <!-- Ma trận 7 ngày trong tuần -->
                <div class="timetable-grid">
                    <c:forEach var="dayDate" items="${grid.daysOfWeek}" varStatus="loop">
                        <c:set var="daySessions" value="${grid.getSessionsForDate(dayDate)}" />
                        
                        <div class="day-column">
                            <div class="day-header">
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
                                </div>
                                <div class="day-date">
                                    <fmt:parseDate value="${dayDate}" pattern="yyyy-MM-dd" var="fDay" type="date"/>
                                    <fmt:formatDate value="${fDay}" pattern="dd/MM"/>
                                </div>
                            </div>

                            <div class="day-content">
                                <c:choose>
                                    <c:when test="${not empty daySessions}">
                                        <c:forEach var="sess" items="${daySessions}">
                                            <div class="session-card">
                                                <div class="session-time">
                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                    ${sess.formattedTime}
                                                </div>
                                                <div class="session-class">
                                                    <c:choose>
                                                        <c:when test="${isAdmin}">
                                                            <a href="${pageContext.request.contextPath}/admin/classes/detail?id=${sess.classId}" style="color: var(--text); text-decoration: none;">
                                                                <strong>[${sess.classCode}]</strong> ${sess.className}
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${sess.classId}" style="color: var(--text); text-decoration: none;">
                                                                <strong>[${sess.classCode}]</strong> ${sess.className}
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="session-meta">
                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                                    <span>${sess.roomName} (${sess.roomCode})</span>
                                                </div>
                                                <div class="session-meta">
                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                                    <span>${sess.teacherName}</span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="day-empty">Không có lịch học</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
