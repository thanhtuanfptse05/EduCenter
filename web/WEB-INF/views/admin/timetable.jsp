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
        .timetable-nav {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 16px 20px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 16px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }
        .legend-bar {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 12px 18px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            font-size: 13px;
        }
        .legend-items {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }
        .legend-dot {
            width: 12px;
            height: 12px;
            border-radius: 3px;
            display: inline-block;
        }
        .dot-math { background: #2563eb; }
        .dot-eng  { background: #059669; }
        .dot-phys { background: #d97706; }
        .dot-lit  { background: #db2777; }
        .dot-vip  { background: #7c3aed; }
        
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
            border-radius: var(--radius-md);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 520px;
            transition: box-shadow 0.2s;
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
            background: var(--bg);
            border-bottom: 1px solid var(--border);
        }
        .day-column.today .day-header {
            background: var(--primary-subtle);
        }
        .day-title {
            font-size: 14px;
            font-weight: 700;
            color: var(--text);
        }
        .day-column.today .day-title {
            color: var(--primary);
        }
        .day-date {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 600;
        }
        .session-count-badge {
            font-size: 11px;
            background: var(--border);
            color: var(--text-muted);
            padding: 1px 6px;
            border-radius: 999px;
            font-weight: 600;
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
        
        /* THEMES CHO TỪNG MÔN HỌC */
        .card-session {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
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
        
        /* Toán học */
        .card-session.theme-math {
            border-left: 4px solid #2563eb;
            background: linear-gradient(to right, #eff6ff 0%, var(--surface) 20%);
        }
        .card-session.theme-math .subject-badge {
            background: #dbeafe;
            color: #1e40af;
        }
        .card-session.theme-math .time-highlight {
            color: #1d4ed8;
        }

        /* Tiếng Anh */
        .card-session.theme-eng {
            border-left: 4px solid #059669;
            background: linear-gradient(to right, #ecfdf5 0%, var(--surface) 20%);
        }
        .card-session.theme-eng .subject-badge {
            background: #d1fae5;
            color: #065f46;
        }
        .card-session.theme-eng .time-highlight {
            color: #047857;
        }

        /* Vật Lý */
        .card-session.theme-phys {
            border-left: 4px solid #d97706;
            background: linear-gradient(to right, #fffbeb 0%, var(--surface) 20%);
        }
        .card-session.theme-phys .subject-badge {
            background: #fef3c7;
            color: #92400e;
        }
        .card-session.theme-phys .time-highlight {
            color: #b45309;
        }

        /* Ngữ Văn */
        .card-session.theme-lit {
            border-left: 4px solid #db2777;
            background: linear-gradient(to right, #fdf2f8 0%, var(--surface) 20%);
        }
        .card-session.theme-lit .subject-badge {
            background: #fce7f3;
            color: #9d174d;
        }
        .card-session.theme-lit .time-highlight {
            color: #be185d;
        }

        /* VIP 1-1 */
        .card-session.theme-vip {
            border-left: 4px solid #7c3aed;
            background: linear-gradient(to right, #f5f3ff 0%, var(--surface) 20%);
        }
        .card-session.theme-vip .subject-badge {
            background: #ede9fe;
            color: #5b21b6;
        }
        .card-session.theme-vip .time-highlight {
            color: #6d28d9;
        }

        /* Default fallback */
        .card-session.theme-default {
            border-left: 4px solid var(--primary);
            background: var(--surface);
        }
        .card-session.theme-default .subject-badge {
            background: var(--primary-subtle);
            color: var(--primary);
        }

        /* Đã hoàn thành */
        .card-session.status-completed {
            opacity: 0.85;
            background: #f8fafc;
        }

        .card-session-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .time-highlight {
            font-size: 13px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .subject-badge {
            font-size: 11px;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 4px;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }
        .class-title-link {
            font-size: 13px;
            font-weight: 700;
            color: var(--text);
            text-decoration: none;
            line-height: 1.35;
            display: block;
            margin-top: 2px;
        }
        .class-title-link:hover {
            color: var(--primary);
        }
        .session-topic {
            font-size: 12px;
            color: var(--text-muted);
            line-height: 1.3;
            font-style: italic;
        }
        .card-meta-chips {
            display: flex;
            flex-direction: column;
            gap: 4px;
            margin-top: 4px;
            padding-top: 6px;
            border-top: 1px dashed var(--border);
            font-size: 11.5px;
        }
        .meta-chip {
            display: flex;
            align-items: center;
            gap: 5px;
            color: var(--text);
        }
        .meta-chip svg {
            color: var(--text-muted);
            flex-shrink: 0;
        }
        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 10.5px;
            font-weight: 600;
            margin-top: 2px;
        }
        .status-pill.scheduled { color: #0284c7; }
        .status-pill.completed { color: #059669; }

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
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div class="content-header">
                    <div>
                        <h1 class="page-title">Thời khóa biểu giảng dạy & học tập</h1>
                        <p class="page-subtitle">Ma trận lịch học trực quan theo tuần, phân biệt rõ ràng màu sắc từng môn học và phòng học</p>
                    </div>
                    <c:if test="${isAdmin}">
                        <div style="display: flex; gap: 10px;">
                            <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-secondary">
                                &larr; Danh sách Lớp học
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/classes/create" class="btn btn-primary">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                Tạo lớp mới
                            </a>
                        </div>
                    </c:if>
                </div>

                <!-- Điều hướng tuần -->
                <div class="timetable-nav">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <a href="?date=${prevMonday}" class="btn btn-sm btn-secondary" title="Xem tuần trước">
                            &laquo; Tuần trước
                        </a>
                        <a href="?date=" class="btn btn-sm btn-secondary" title="Về tuần hiện tại">
                            Tuần hiện tại
                        </a>
                        <a href="?date=${nextMonday}" class="btn btn-sm btn-secondary" title="Xem tuần tiếp theo">
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
                            <button type="submit" class="btn btn-sm btn-primary">Chọn tuần</button>
                        </form>
                    </div>
                </div>

                <!-- Thanh Chú thích màu sắc môn học (Legend Ribbon) -->
                <div class="legend-bar">
                    <div class="legend-items">
                        <span style="font-weight: 700; color: var(--text-muted); font-size: 12px; text-transform: uppercase;">Phân loại môn:</span>
                        <div class="legend-item"><span class="legend-dot dot-math"></span> <span>Toán học</span></div>
                        <div class="legend-item"><span class="legend-dot dot-eng"></span> <span>Tiếng Anh</span></div>
                        <div class="legend-item"><span class="legend-dot dot-phys"></span> <span>Vật Lý</span></div>
                        <div class="legend-item"><span class="legend-dot dot-lit"></span> <span>Ngữ Văn</span></div>
                        <div class="legend-item"><span class="legend-dot dot-vip"></span> <span>Lớp kèm VIP 1-1</span></div>
                    </div>
                    <div style="font-size: 12px; color: var(--text-muted); display: flex; gap: 12px;">
                        <span>&bull; Khung giờ sáng: <strong>08:00 - 10:00</strong></span>
                        <span>&bull; Khung giờ chiều: <strong>14:00 - 16:00</strong></span>
                        <span>&bull; Khung giờ tối: <strong>18:00 - 20:00</strong></span>
                    </div>
                </div>

                <!-- Ma trận 7 ngày trong tuần -->
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
                                        <fmt:parseDate value="${dayDate}" pattern="yyyy-MM-dd" var="fDay" type="date"/>
                                        <fmt:formatDate value="${fDay}" pattern="dd/MM/yyyy"/>
                                    </div>
                                </div>
                                <span class="session-count-badge" title="Số lượng buổi học trong ngày">
                                    ${daySessions.size()} buổi
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
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                                        ${sess.formattedTime}
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

                                                <!-- Tên lớp học -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${isAdmin}">
                                                            <a href="${pageContext.request.contextPath}/admin/classes/detail?id=${sess.classId}" class="class-title-link" title="Bấm để xem chi tiết lớp">
                                                                ${sess.className}
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${sess.classId}" class="class-title-link" title="Bấm để xem chi tiết lớp">
                                                                ${sess.className}
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Tiêu đề buổi học -->
                                                <c:if test="${not empty sess.title}">
                                                    <div class="session-topic">${sess.title}</div>
                                                </c:if>

                                                <!-- Metadata: Phòng & Giáo viên -->
                                                <div class="card-meta-chips">
                                                    <div class="meta-chip">
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                                        <span><strong>${sess.roomCode}</strong> &bull; ${sess.roomName}</span>
                                                    </div>
                                                    <div class="meta-chip">
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                                        <span>${sess.teacherName}</span>
                                                    </div>
                                                </div>

                                                <!-- Trạng thái -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${sess.status == 'COMPLETED'}">
                                                            <span class="status-pill completed">&#10003; Đã hoàn thành</span>
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
                                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 6px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                            Không có lịch học
                                        </div>
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
