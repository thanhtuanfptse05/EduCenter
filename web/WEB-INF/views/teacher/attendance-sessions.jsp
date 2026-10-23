<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .badge-scheduled { background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; }
        .badge-progress { background: #fef9c3; color: #854d0e; border: 1px solid #fef08a; }
        .badge-completed { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .badge-cancelled { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="attendance" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Điểm danh & Sổ đầu bài" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h1 class="page-title">Điểm danh & Sổ đầu bài giảng dạy</h1>
                    <p class="page-subtitle">Chọn ca học để tiến hành điểm danh học viên và ghi nhận nhật ký buổi học (TCH-03, TCH-04)</p>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Filter Toolbar -->
            <div class="filter-toolbar">
                <form action="${pageContext.request.contextPath}/teacher/attendance" method="get" class="filter-form" style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                    <label style="font-weight: 500; font-size: 0.875rem;">Lọc theo ngày:</label>
                    <input type="date" name="date" class="form-control" style="width: auto;" value="<c:out value='${filterDate}' />">
                    <button type="submit" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <span>Xem ca dạy</span>
                    </button>
                    <c:if test="${not empty filterDate}">
                        <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-ghost btn-sm">Xem tất cả</a>
                    </c:if>
                </form>
            </div>

            <!-- Sessions Table -->
            <div class="admin-card">
                <c:choose>
                    <c:when test="${not empty sessions}">
                        <div class="table-responsive">
                            <table class="table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="width: 48px; text-align: center;">#</th>
                                    <th>Lớp học & Môn</th>
                                    <th>Thời gian ca học</th>
                                    <th>Phòng học</th>
                                    <th>Sĩ số & Chuyên cần</th>
                                    <th>Trạng thái</th>
                                    <th>Sổ đầu bài</th>
                                    <th style="text-align: right; width: 180px;">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="s" items="${sessions}" varStatus="loop">
                                    <tr>
                                        <td style="text-align: center; color: var(--text-muted);">${loop.count}</td>
                                        <td>
                                            <div style="font-weight: 600; color: var(--text);"><c:out value="${s.className}" /></div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                Mã lớp: <code><c:out value="${s.classCode}" /></code> • Môn: <c:out value="${s.subjectName}" />
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500; font-size: 0.875rem;">
                                                <c:out value="${s.startTime}" /> - <c:out value="${s.endTime}" />
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                Ngày: <strong><c:out value="${s.sessionDate}" /></strong>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="font-size: 0.875rem;"><c:out value="${s.roomName}" /></span>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.85rem; font-weight: 500;">
                                                Tổng: ${s.totalStudents} học sinh
                                            </div>
                                            <div style="font-size: 0.75rem; color: var(--text-muted); display: flex; gap: 6px; margin-top: 2px;">
                                                <span style="color: var(--success);">Có mặt: ${s.presentCount}</span>
                                                <span style="color: #b45309;">Muộn: ${s.lateCount}</span>
                                                <span style="color: var(--danger);">Vắng: ${s.excusedCount + s.unexcusedCount}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${s.sessionStatus == 'COMPLETED'}">
                                                    <span class="status-badge badge-completed">Đã hoàn tất</span>
                                                </c:when>
                                                <c:when test="${s.sessionStatus == 'IN_PROGRESS'}">
                                                    <span class="status-badge badge-progress">Đang diễn ra</span>
                                                </c:when>
                                                <c:when test="${s.sessionStatus == 'CANCELLED'}">
                                                    <span class="status-badge badge-cancelled">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge badge-scheduled">Chưa điểm danh</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${s.hasJournal}">
                                                    <span style="font-size: 0.8rem; color: var(--success); font-weight: 500; display: inline-flex; align-items: center; gap: 4px;">
                                                        <svg class="icon icon-sm" style="width: 14px; height: 14px;" viewBox="0 0 24 24" aria-hidden="true">
                                                            <polyline points="20 6 9 17 4 12"></polyline>
                                                        </svg>
                                                        Đã ghi
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="font-size: 0.8rem; color: var(--text-muted);">Chưa ghi</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: right;">
                                            <div style="display: inline-flex; gap: 6px;">
                                                <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${s.sessionId}"
                                                   class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                        <polyline points="9 11 12 14 22 4"></polyline>
                                                        <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                                                    </svg>
                                                    <span>Điểm danh</span>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/teacher/journal?sessionId=${s.sessionId}"
                                                   class="btn btn-secondary btn-sm" title="Sổ đầu bài & Nhật ký">
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                                        <path d="M6 6h10"></path>
                                                        <path d="M6 10h10"></path>
                                                    </svg>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state" style="padding: 60px 20px; text-align: center;">
                            <div style="width: 64px; height: 64px; border-radius: 50%; background: var(--bg-subtle); display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; color: var(--text-muted);">
                                <svg class="icon icon-lg" style="width: 32px; height: 32px;" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin-bottom: 6px;">Không có ca dạy nào</h3>
                            <p style="font-size: 0.875rem; color: var(--text-muted); max-width: 420px; margin: 0 auto;">
                                Bạn hiện không có ca dạy nào được phân công theo ngày đã chọn. Vui lòng kiểm tra lại thời khóa biểu hoặc liên hệ quản trị học vụ.
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
</body>
</html>
