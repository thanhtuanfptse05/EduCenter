<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student-portal.css?v=20261024_01">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="parent-schedule" scope="request" />
    <c:set var="breadcrumb" value="Thời khóa biểu của con" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <div class="portal-wrap">
                <!-- Top Navigation & Header Row -->
                <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <div style="display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--primary); margin-bottom: 6px;">
                            <span>Cổng Phụ Huynh</span>
                            <span class="portal-meta-sep">/</span>
                            <span style="color: var(--text-muted);">Lịch học &amp; Ca học của con</span>
                        </div>
                        <h1 class="page-title" style="margin: 0; font-size: 24px;">Thời khóa biểu của con</h1>
                        <p class="page-subtitle" style="margin: 4px 0 0 0;">Theo dõi chi tiết lịch học, phòng học và giáo viên phụ trách các lớp học của con tại trung tâm.</p>
                    </div>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <a href="${pageContext.request.contextPath}/parent/progress?childId=${selectedChildId}" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                            <span>Xem kết quả học tập</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                            <span>Bảng điều khiển</span>
                        </a>
                    </div>
                </div>

                <!-- Filter & Controls Toolbar -->
                <div class="portal-filter-card">
                    <form action="${pageContext.request.contextPath}/parent/schedule" method="get" id="parent-schedule-form">
                        <div class="portal-filter-grid">
                            <!-- Chọn con nếu phụ huynh có con -->
                            <c:if test="${parentSummary.hasChildren()}">
                                <div>
                                    <label class="form-label" for="childIdSelect" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Chọn học sinh (con):</label>
                                    <select id="childIdSelect" name="childId" class="form-control" onchange="this.form.submit()">
                                        <c:forEach var="ch" items="${parentSummary.verifiedChildren}">
                                            <option value="${ch.id}" ${ch.id == selectedChildId ? 'selected' : ''}>
                                                <c:out value="${ch.fullName}"/> (${ch.gradeLevel == null ? 'Chưa phân khối' : 'Khối '.concat(ch.gradeLevel)})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </c:if>

                            <!-- Từ ngày -->
                            <div>
                                <label class="form-label" for="filter-date-from" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Từ ngày:</label>
                                <input type="date" id="filter-date-from" name="fromDate" class="form-control" value="<c:out value='${fromDate}' />">
                            </div>

                            <!-- Đến ngày -->
                            <div>
                                <label class="form-label" for="filter-date-to" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Đến ngày:</label>
                                <input type="date" id="filter-date-to" name="toDate" class="form-control" value="<c:out value='${toDate}' />">
                            </div>

                            <!-- Môn học -->
                            <div>
                                <label class="form-label" for="filter-subject" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Môn học:</label>
                                <select id="filter-subject" name="subject" class="form-control" onchange="applyClientFilter()">
                                    <option value="ALL">Tất cả môn</option>
                                    <option value="Toán học">Toán học</option>
                                    <option value="Vật lý">Vật lý</option>
                                    <option value="Tiếng Anh">Tiếng Anh</option>
                                    <option value="Hóa học">Hóa học</option>
                                    <option value="Sinh học">Sinh học</option>
                                </select>
                            </div>

                            <!-- CTA Button -->
                            <div>
                                <button type="submit" class="btn btn-primary" style="width: 100%; height: 38px; display: inline-flex; align-items: center; justify-content: center; gap: 8px;">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                    <span>Lọc thời khóa biểu</span>
                                </button>
                            </div>
                        </div>

                        <!-- Row 2: Quick Filter Pills & Counts -->
                        <div class="portal-pill-row">
                            <div class="portal-pills">
                                <span style="font-size: 12px; color: var(--text-muted); font-weight: 600; margin-right: 4px;">Khoảng thời gian:</span>
                                <button type="button" class="portal-pill-btn" onclick="setDateRange('this-week', this)">Tuần này</button>
                                <button type="button" class="portal-pill-btn" onclick="setDateRange('next-week', this)">Tuần tới</button>
                                <button type="button" class="portal-pill-btn" onclick="setDateRange('this-month', this)">Tháng này</button>
                            </div>
                            <div style="display: flex; align-items: center; gap: 14px; font-size: 12.5px; color: var(--text-muted);">
                                <c:set var="completedCount" value="0" />
                                <c:set var="upcomingCount" value="0" />
                                <c:forEach var="item" items="${scheduleList}">
                                    <c:choose>
                                        <c:when test="${item.status == 'COMPLETED'}">
                                            <c:set var="completedCount" value="${completedCount + 1}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="upcomingCount" value="${upcomingCount + 1}" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span style="display: inline-flex; align-items: center; gap: 6px;">
                                    <span class="legend-dot" style="background: var(--success);"></span>
                                    <span>Đã hoàn thành: <strong><c:out value="${completedCount}" /></strong></span>
                                </span>
                                <span style="display: inline-flex; align-items: center; gap: 6px;">
                                    <span class="legend-dot" style="background: var(--primary);"></span>
                                    <span>Sắp diễn ra: <strong><c:out value="${upcomingCount}" /></strong></span>
                                </span>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Summary Statistics Bar (4 columns - Above Timetable) -->
                <section class="portal-kpi-grid">
                    <div class="portal-kpi-card">
                        <div class="portal-kpi-content">
                            <span class="portal-kpi-label">Tổng ca trong kỳ lọc</span>
                            <div class="portal-kpi-val-row">
                                <span class="portal-kpi-value"><c:out value="${scheduleList.size()}" /></span>
                                <span class="portal-kpi-sub">buổi học</span>
                            </div>
                        </div>
                        <div class="portal-kpi-icon-box bg-primary-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        </div>
                    </div>

                    <div class="portal-kpi-card">
                        <div class="portal-kpi-content">
                            <span class="portal-kpi-label">Đã hoàn thành</span>
                            <div class="portal-kpi-val-row">
                                <span class="portal-kpi-value text-success"><c:out value="${completedCount}" /></span>
                                <span class="portal-kpi-sub">buổi học</span>
                            </div>
                        </div>
                        <div class="portal-kpi-icon-box bg-success-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                    </div>

                    <div class="portal-kpi-card">
                        <div class="portal-kpi-content">
                            <span class="portal-kpi-label">Sắp diễn ra</span>
                            <div class="portal-kpi-val-row">
                                <span class="portal-kpi-value text-primary"><c:out value="${upcomingCount}" /></span>
                                <span class="portal-kpi-sub">buổi học</span>
                            </div>
                        </div>
                        <div class="portal-kpi-icon-box bg-info-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        </div>
                    </div>

                    <div class="portal-kpi-card">
                        <div class="portal-kpi-content">
                            <span class="portal-kpi-label">Tiến độ kỳ học</span>
                            <div class="portal-kpi-val-row">
                                <span class="portal-kpi-value text-warning">
                                    <fmt:formatNumber value="${scheduleList.size() > 0 ? (completedCount * 100.0 / scheduleList.size()) : 0}" maxFractionDigits="0"/>%
                                </span>
                                <span class="portal-kpi-sub" style="color: var(--text-muted); font-weight: 500;">
                                    Đã học <c:out value="${completedCount}"/>/<c:out value="${scheduleList.size()}"/> buổi
                                </span>
                            </div>
                        </div>
                        <div class="portal-kpi-icon-box bg-warning-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>
                    </div>
                </section>

                <!-- Detailed Timetable Table Container -->
                <section class="portal-table-panel">
                    <c:choose>
                        <c:when test="${empty scheduleList}">
                            <div class="empty-state" style="padding: 56px 20px; text-align: center;">
                                <div style="width: 60px; height: 60px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 14px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                                <h3 style="font-size: 17px; font-weight: 700; color: var(--text); margin: 0 0 8px;">Không có ca học nào trong khoảng thời gian này</h3>
                                <p style="margin: 0; font-size: 13.5px; color: var(--text-muted); max-width: 480px; margin: 0 auto;">Không có ca học nào được tìm thấy hoặc học sinh hiện chưa tham gia lớp học nào.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="portal-table-responsive">
                                <table class="portal-table" id="parent-schedule-table">
                                    <thead>
                                        <tr>
                                            <th style="min-width: 170px;">Thời gian / Ngày</th>
                                            <th style="min-width: 260px;">Lớp học &amp; Môn</th>
                                            <th style="min-width: 200px;">Phòng học</th>
                                            <th style="min-width: 180px;">Giáo viên giảng dạy</th>
                                            <th style="min-width: 140px; text-align: center;">Trạng thái</th>
                                            <th style="min-width: 260px;">Nội dung bài học</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${scheduleList}">
                                            <tr class="schedule-row" data-subject="<c:out value='${item.subjectName}' />">
                                                <td style="vertical-align: top;">
                                                    <div style="font-weight: 700; color: var(--text);"><c:out value="${item.dayOfWeekVi}" />, <c:out value="${item.formattedDate}" /></div>
                                                    <div style="display: inline-flex; align-items: center; gap: 4px; font-size: 12px; font-weight: 600; color: var(--text-muted); background: var(--surface-muted); padding: 2px 8px; border-radius: 6px; margin-top: 4px;">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                        <span><c:out value="${item.timeRange}" /></span>
                                                    </div>
                                                </td>
                                                <td style="vertical-align: top;">
                                                    <div style="font-weight: 600; font-size: 14px; color: var(--text); line-height: 1.35;"><c:out value="${item.className}" /></div>
                                                    <div style="display: flex; align-items: center; gap: 6px; margin-top: 4px;">
                                                        <span class="portal-badge-subject ${item.subjectName == 'Toán học' ? 'subject-toan' : (item.subjectName == 'Vật lý' ? 'subject-ly' : (item.subjectName == 'Tiếng Anh' ? 'subject-anh' : (item.subjectName == 'Hóa học' ? 'subject-hoa' : 'subject-default')))}">
                                                            <c:out value="${item.subjectName}" />
                                                        </span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted);">Mã: <c:out value="${item.classCode}" /></span>
                                                    </div>
                                                </td>
                                                <td style="vertical-align: top;">
                                                    <div style="display: flex; align-items: center; gap: 5px; font-weight: 600; color: var(--text);">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                                        </svg>
                                                        <span><c:out value="${item.roomName}" /></span>
                                                    </div>
                                                    <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">Trang thiết bị giảng dạy chuẩn</div>
                                                </td>
                                                <td style="vertical-align: top;">
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <div style="width: 28px; height: 28px; border-radius: 50%; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 11px;">
                                                            <c:out value="${item.teacherName.substring(0, 1)}" />
                                                        </div>
                                                        <div>
                                                            <div style="font-weight: 600; color: var(--text);"><c:out value="${item.teacherName}" /></div>
                                                            <div style="font-size: 11px; color: var(--text-muted);">Giáo viên bộ môn</div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td style="vertical-align: top; text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${item.status == 'COMPLETED'}">
                                                            <span class="portal-badge-status status-completed">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                                <span>Đã hoàn thành</span>
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${item.status == 'CANCELLED'}">
                                                            <span class="portal-badge-status status-cancelled">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                                                                <span>Đã nghỉ / Hủy</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="portal-badge-status status-scheduled">
                                                                <span class="pulse-indicator"></span>
                                                                <span>Sắp diễn ra</span>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="vertical-align: top;">
                                                    <p style="margin: 0; font-size: 13px; color: var(--text); line-height: 1.45;">
                                                        <c:out value="${empty item.notes ? 'Theo khung giáo án của tổ bộ môn' : item.notes}" />
                                                    </p>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>
        </main>
    </div>
</div>

<script>
function setDateRange(type, btn) {
    document.querySelectorAll('.portal-pill-btn').forEach(b => b.classList.remove('active'));
    if (btn) btn.classList.add('active');

    const today = new Date();
    const fromInput = document.getElementById('filter-date-from');
    const toInput = document.getElementById('filter-date-to');

    function formatDate(d) {
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return year + '-' + month + '-' + day;
    }

    if (type === 'this-week') {
        const firstDay = new Date(today);
        const day = today.getDay();
        const diff = today.getDate() - day + (day === 0 ? -6 : 1);
        firstDay.setDate(diff);
        const lastDay = new Date(firstDay);
        lastDay.setDate(firstDay.getDate() + 6);
        fromInput.value = formatDate(firstDay);
        toInput.value = formatDate(lastDay);
    } else if (type === 'next-week') {
        const firstDay = new Date(today);
        const day = today.getDay();
        const diff = today.getDate() - day + (day === 0 ? -6 : 1) + 7;
        firstDay.setDate(diff);
        const lastDay = new Date(firstDay);
        lastDay.setDate(firstDay.getDate() + 6);
        fromInput.value = formatDate(firstDay);
        toInput.value = formatDate(lastDay);
    } else if (type === 'this-month') {
        const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
        const lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
        fromInput.value = formatDate(firstDay);
        toInput.value = formatDate(lastDay);
    }
    document.getElementById('parent-schedule-form').submit();
}

function applyClientFilter() {
    const sub = document.getElementById('filter-subject').value;
    const rows = document.querySelectorAll('.schedule-row');

    rows.forEach(r => {
        const rowSub = r.getAttribute('data-subject') || '';
        const matchSub = (sub === 'ALL' || rowSub.includes(sub));
        r.style.display = matchSub ? '' : 'none';
    });
}
</script>
</body>
</html>
