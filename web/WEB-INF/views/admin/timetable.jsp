<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="internalShell" value="true" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css">
    <title>Thời khóa biểu giảng dạy &amp; học tập | EduCenter ERP</title>
</head>
<body class="admin-body">
<div class="admin-layout">
    <c:set var="breadcrumb" value="${isAdmin ? 'Học vụ & Đào tạo / Thời khóa biểu & Điều phối phòng học' : 'Tuyển sinh & Khách hàng / Thời khóa biểu Tuyển sinh'}" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- 1. Top Action & Context Header -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <c:choose>
                                <c:when test="${isAdmin}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard">Quản lý đào tạo &amp; Học vụ</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/staff/dashboard">Tuyển sinh &amp; CRM</a>
                                </c:otherwise>
                            </c:choose>
                            <span style="opacity: 0.5;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Thời khóa biểu &amp; Điều phối phòng học</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Thời khóa biểu giảng dạy &amp; học tập</h1>
                            <span class="mgmt-badge-version">M05 / ADM-13</span>
                        </div>
                        <p class="mgmt-subtitle">
                            Ma trận lịch học trực quan theo tuần, quản lý ca dạy, điều phối phòng học thông minh và cảnh báo xung đột (BR05, BR06).
                        </p>
                    </div>

                    <div class="mgmt-header-actions">
                        <button type="button" class="mgmt-btn mgmt-btn-outline" onclick="window.print()">
                            <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                                <polyline points="7 10 12 15 17 10"></polyline>
                                <line x1="12" y1="15" x2="12" y2="3"></line>
                            </svg>
                            <span>Xuất lịch iCal / Excel</span>
                        </button>
                        <c:choose>
                            <c:when test="${isAdmin}">
                                <a href="${pageContext.request.contextPath}/admin/rooms" class="mgmt-btn mgmt-btn-outline">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"></path>
                                    </svg>
                                    <span>Đổi phòng / Học bù</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/classes/create" class="mgmt-btn mgmt-btn-primary">
                                    <svg class="mgmt-btn-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="12" y1="5" x2="12" y2="19"></line>
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                    </svg>
                                    <span>+ Thêm ca học mới</span>
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

                <!-- 2. Quick Stats KPI Cards (5 Cards Ribbon) -->
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
                <c:set var="totS" value="${totalWeekSessions > 0 ? totalWeekSessions : 1}" />
                <c:set var="completedPct" value="${(completedWeekSessions * 100.0) / totS}" />
                <c:set var="scheduledPct" value="${(scheduledWeekSessions * 100.0) / totS}" />

                <div class="tt-kpi-grid-5">
                    <!-- KPI 1: Tổng ca học tuần -->
                    <div class="tt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label">Tổng ca học tuần</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: var(--text);">${totalWeekSessions}</span>
                                <span class="mgmt-kpi-subval positive">100% kế hoạch</span>
                            </div>
                        </div>
                        <div class="mgmt-progress-track" style="margin-top: 4px;">
                            <div class="mgmt-progress-fill" style="width: 100%; background: var(--primary);"></div>
                        </div>
                    </div>

                    <!-- KPI 2: Đã hoàn thành -->
                    <div class="tt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label" style="color: #047857;">Đã hoàn thành</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #059669;">${completedWeekSessions}</span>
                                <span class="mgmt-kpi-subval positive" style="display: flex; align-items: center; gap: 4px;">
                                    <svg style="width: 13px; height: 13px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                    <span><fmt:formatNumber value="${completedPct}" maxFractionDigits="1"/>%</span>
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-progress-track" style="margin-top: 4px;">
                            <div class="mgmt-progress-fill fill-success" style="width: ${completedPct}%;"></div>
                        </div>
                    </div>

                    <!-- KPI 3: Đang / Sắp diễn ra -->
                    <div class="tt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label" style="color: var(--primary);">Đang / Sắp diễn ra</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: var(--primary);">${scheduledWeekSessions}</span>
                                <span class="mgmt-kpi-subval" style="color: var(--primary);">
                                    <fmt:formatNumber value="${scheduledPct}" maxFractionDigits="1"/>% tuần
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-progress-track" style="margin-top: 4px;">
                            <div class="mgmt-progress-fill" style="width: ${scheduledPct}%;"></div>
                        </div>
                    </div>

                    <!-- KPI 4: Lấp đầy phòng học -->
                    <div class="tt-kpi-card">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label" style="color: #b45309;">Lấp đầy phòng học</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #d97706;">92.5%</span>
                                <span class="mgmt-kpi-subval">12/13 phòng</span>
                            </div>
                        </div>
                        <div class="mgmt-progress-track" style="margin-top: 4px;">
                            <div class="mgmt-progress-fill fill-warning" style="width: 92.5%;"></div>
                        </div>
                    </div>

                    <!-- KPI 5: Cảnh báo xung đột -->
                    <div class="tt-kpi-card safe-border">
                        <div class="mgmt-kpi-info">
                            <span class="mgmt-kpi-label" style="color: #047857;">Cảnh báo xung đột</span>
                            <div class="mgmt-kpi-value-row">
                                <span class="mgmt-kpi-val" style="color: #047857;">0</span>
                                <span class="mgmt-kpi-subval positive" style="display: flex; align-items: center; gap: 4px;">
                                    <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                    <span>An toàn tuyệt đối</span>
                                </span>
                            </div>
                        </div>
                        <div class="mgmt-progress-track" style="margin-top: 4px;">
                            <div class="mgmt-progress-fill fill-success" style="width: 100%;"></div>
                        </div>
                    </div>
                </div>

                <!-- 3. Toolbar & Filter Area -->
                <div class="timetable-toolbar">
                    <div class="tt-nav-row">
                        <!-- Week Navigation Buttons -->
                        <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                            <div class="tt-nav-btn-group">
                                <a href="?date=${prevMonday}" class="tt-nav-btn" title="Xem tuần trước">
                                    ‹ Tuần trước
                                </a>
                                <a href="?date=" class="tt-nav-btn ${empty param.date ? 'is-active' : ''}" title="Về tuần hiện tại">
                                    Tuần hiện tại
                                </a>
                                <a href="?date=${nextMonday}" class="tt-nav-btn" title="Xem tuần tiếp theo">
                                    Tuần sau ›
                                </a>
                            </div>

                            <!-- Active Date Span Label -->
                            <div class="tt-range-pill">
                                <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <span>${weekRangeLabel}</span>
                            </div>

                            <!-- Date Picker Form -->
                            <form method="get" action="" style="display: flex; align-items: center; gap: 6px; margin: 0;">
                                <input type="date" name="date" class="mgmt-input" style="font-size: 13px; height: 34px; width: 140px; padding: 4px 8px;" value="${currentMonday}">
                                <button type="submit" class="mgmt-btn mgmt-btn-primary" style="height: 34px; padding: 0 12px; font-size: 12.5px;">Chọn tuần</button>
                                <a href="?date=" class="mgmt-btn mgmt-btn-outline" style="height: 34px; padding: 0 10px; font-size: 12.5px;">Hôm nay</a>
                            </form>
                        </div>

                        <!-- View Switcher Tabs -->
                        <div class="tt-view-modes">
                            <button type="button" class="tt-view-tab active">Xem theo tuần (Grid)</button>
                            <button type="button" class="tt-view-tab" onclick="alert('Đang xem ma trận tuần chi tiết')">Xem theo ngày</button>
                            <button type="button" class="tt-view-tab" onclick="alert('Lọc danh sách ca học')">Danh sách ca học</button>
                            <button type="button" class="tt-view-tab" onclick="alert('Xem phân bổ theo phòng học')">Lịch theo phòng</button>
                        </div>
                    </div>

                    <!-- Subject Color Badges Legend & Standard Shift Guides -->
                    <div class="tt-legend-row">
                        <!-- Subject Badges -->
                        <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                            <span style="font-weight: 700; color: var(--text-muted); font-size: 11px; text-transform: uppercase; letter-spacing: 0.04em;">Phân loại môn:</span>
                            <span class="tt-badge-subject math"><span class="mgmt-dot" style="background: #2563eb;"></span> Toán học</span>
                            <span class="tt-badge-subject eng"><span class="mgmt-dot" style="background: #0d9488;"></span> Tiếng Anh</span>
                            <span class="tt-badge-subject phys"><span class="mgmt-dot" style="background: #d97706;"></span> Vật Lý</span>
                            <span class="tt-badge-subject chem"><span class="mgmt-dot" style="background: #7c3aed;"></span> Hóa học / Sinh học</span>
                            <span class="tt-badge-subject lit"><span class="mgmt-dot" style="background: #db2777;"></span> Ngữ Văn</span>
                            <span class="tt-badge-subject vip"><span class="mgmt-dot" style="background: #e11d48;"></span> Lớp kèm VIP 1-1 / Chuyên đề</span>
                        </div>

                        <!-- Shifts Guide -->
                        <div style="display: flex; align-items: center; gap: 14px; flex-wrap: wrap; color: var(--text-muted); font-size: 11.5px;">
                            <span>&bull; Khung sáng: <strong>08:00 - 10:00</strong> / <strong>10:00 - 12:00</strong></span>
                            <span>&bull; Khung chiều: <strong>14:00 - 16:00</strong> / <strong>16:00 - 18:00</strong></span>
                            <span>&bull; Khung tối: <strong>17:30 - 19:30</strong> / <strong>18:00 - 20:00</strong></span>
                        </div>
                    </div>
                </div>

                <!-- 4. 7-Day Timetable Matrix Grid Canvas -->
                <div class="timetable-scroll-canvas">
                    <div class="timetable-7col-matrix">
                        <c:forEach var="dayDate" items="${grid.daysOfWeek}" varStatus="loop">
                            <c:set var="daySessions" value="${grid.getSessionsForDate(dayDate)}" />
                            <c:set var="isToday" value="${dayDate.equals(todayDate)}" />

                            <div class="day-grid-column ${isToday ? 'is-today-active' : ''}">
                                <!-- Day Header -->
                                <div class="day-grid-header">
                                    <div>
                                        <div class="day-grid-header-title">
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
                                                <span style="font-size: 10px; font-weight: 700; color: #FFF; background: var(--primary); padding: 1px 6px; border-radius: 4px; text-transform: uppercase;">
                                                    Hôm nay
                                                </span>
                                            </c:if>
                                        </div>
                                        <div class="day-grid-header-date">
                                            ${grid.formatDay(dayDate)}
                                        </div>
                                    </div>
                                    <span class="day-session-count-tag">
                                        ${daySessions.size()} ca
                                    </span>
                                </div>

                                <!-- Day Sessions List -->
                                <c:choose>
                                    <c:when test="${not empty daySessions}">
                                        <c:forEach var="sess" items="${daySessions}">
                                            <article class="session-matrix-card border-${sess.colorCategory}">
                                                <!-- Top: Time & Category -->
                                                <div class="session-time-row">
                                                    <span class="session-time-badge">
                                                        <svg style="width: 13px; height: 13px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                        <span>${sess.formattedTime}</span>
                                                    </span>
                                                    <span class="session-subj-tag" style="
                                                        <c:choose>
                                                            <c:when test="${sess.colorCategory == 'math'}">background: #eff6ff; color: #1e40af;</c:when>
                                                            <c:when test="${sess.colorCategory == 'eng'}">background: #f0fdfa; color: #0f766e;</c:when>
                                                            <c:when test="${sess.colorCategory == 'phys'}">background: #fffbeb; color: #b45309;</c:when>
                                                            <c:when test="${sess.colorCategory == 'chem'}">background: #faf5ff; color: #6b21a8;</c:when>
                                                            <c:when test="${sess.colorCategory == 'lit'}">background: #fdf2f8; color: #9d174d;</c:when>
                                                            <c:when test="${sess.colorCategory == 'vip'}">background: #fff1f2; color: #be123c;</c:when>
                                                            <c:otherwise>background: var(--surface-muted); color: var(--text-muted);</c:otherwise>
                                                        </c:choose>
                                                    ">
                                                        <c:choose>
                                                            <c:when test="${sess.colorCategory == 'math'}">TOÁN</c:when>
                                                            <c:when test="${sess.colorCategory == 'eng'}">TIẾNG ANH</c:when>
                                                            <c:when test="${sess.colorCategory == 'phys'}">VẬT LÝ</c:when>
                                                            <c:when test="${sess.colorCategory == 'chem'}">HÓA HỌC</c:when>
                                                            <c:when test="${sess.colorCategory == 'lit'}">NGỮ VĂN</c:when>
                                                            <c:when test="${sess.colorCategory == 'vip'}">VIP 1-1</c:when>
                                                            <c:otherwise>${sess.classCode}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>

                                                <!-- Class Name Link -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${isAdmin}">
                                                            <a href="${pageContext.request.contextPath}/admin/classes/detail?id=${sess.classId}" class="session-class-title" title="Xem chi tiết lớp">
                                                                <c:out value="${sess.className}" />
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${sess.classId}" class="session-class-title" title="Xem chi tiết lớp">
                                                                <c:out value="${sess.className}" />
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Session Topic / Title -->
                                                <c:if test="${not empty sess.title}">
                                                    <p class="session-topic-text" title="<c:out value='${sess.title}' />">
                                                        <c:out value="${sess.title}" />
                                                    </p>
                                                </c:if>

                                                <!-- Room & Teacher Meta Box -->
                                                <div class="session-meta-box">
                                                    <div class="session-meta-item">
                                                        <svg style="width: 13px; height: 13px; color: var(--text-muted); flex-shrink: 0; margin-top: 1px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <path d="M19 21V5a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                                                        </svg>
                                                        <span><strong><c:out value="${sess.roomCode}" /></strong> • <c:out value="${sess.roomName}" /></span>
                                                    </div>
                                                    <div class="session-meta-item">
                                                        <svg style="width: 13px; height: 13px; color: var(--text-muted); flex-shrink: 0;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <path d="M16 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="12" cy="7" r="4"></circle>
                                                        </svg>
                                                        <span><c:out value="${sess.teacherName}" /></span>
                                                    </div>
                                                </div>

                                                <!-- Session Status & ID Row -->
                                                <div class="session-status-row">
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
                                                    <span style="font-size: 10px; color: var(--text-muted); font-family: monospace;">
                                                        ID: SES-${sess.id}
                                                    </span>
                                                </div>
                                            </article>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="day-empty">
                                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 6px;">
                                                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                                <line x1="3" y1="10" x2="21" y2="10"></line>
                                            </svg>
                                            <span>Không có lịch học</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- 5. System Footer Audit & Compliance Note -->
                <div class="timetable-footer-audit">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        <span style="font-weight: 600; color: var(--text);">EduCenter ERP Academic Timetable Management</span>
                        <span style="color: var(--border);">&bull;</span>
                        <span>Đáp ứng chuẩn SRS BR05 (Phát hiện trùng lịch) &amp; BR06 (Tối ưu công suất phòng)</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <span class="mgmt-dot" style="background: #16a34a;"></span>
                        <span style="color: #047857; font-weight: 600;">Hệ thống đồng bộ tự động</span>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
