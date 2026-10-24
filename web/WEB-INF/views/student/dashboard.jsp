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
    <c:set var="activeNav" value="student-dashboard" scope="request" />
    <c:set var="breadcrumb" value="Bảng điều khiển học viên" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Alert Messages -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <c:choose>
                <%-- Trạng thái chưa gắn hồ sơ học sinh --%>
                <c:when test="${empty dashboard.studentId}">
                    <div class="portal-profile-hero" style="border-style: dashed; padding: 48px 24px; text-align: center; flex-direction: column; align-items: center;">
                        <div style="width: 64px; height: 64px; border-radius: 50%; background: var(--warning-subtle); color: var(--warning); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 12px;">
                            <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                        <h2 style="font-size: 20px; font-weight: 700; color: var(--text); margin-bottom: 8px;">Hồ sơ học viên chưa được liên kết</h2>
                        <p class="text-muted" style="max-width: 520px; margin: 0 auto 20px; line-height: 1.6; font-size: 14px;">
                            Tài khoản <strong><c:out value="${sessionScope.currentUser.email}" /></strong> chưa được gắn mã hồ sơ học sinh trong cơ sở dữ liệu. Vui lòng liên hệ Phòng Giáo vụ hoặc Đăng ký khóa học mới để được xếp lớp và cấp mã học viên.
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                    <path d="M6 6h10"></path>
                                    <path d="M6 10h10"></path>
                                </svg>
                                <span>Khám phá khóa học</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">Xem hồ sơ cá nhân</a>
                        </div>
                    </div>
                </c:when>

                <%-- Trạng thái học sinh đã có hồ sơ và dữ liệu --%>
                <c:otherwise>
                    <div class="portal-wrap">
                        <!-- Top Welcome & Personal Profile Header -->
                        <section class="portal-profile-hero">
                            <div class="portal-hero-info">
                                <div class="portal-hero-title-row">
                                    <h1 class="portal-hero-name">Xin chào, <c:out value="${dashboard.studentName}" />!</h1>
                                    <span class="portal-code-badge"><c:out value="${dashboard.studentCode}" /></span>
                                    <span class="portal-status-pill ${dashboard.status == 'STUDYING' ? 'status-studying' : (dashboard.status == 'RESERVED' ? 'status-reserved' : (dashboard.status == 'GRADUATED' ? 'status-graduated' : 'status-dropped'))}">
                                        <span class="portal-status-dot"></span>
                                        <span><c:out value="${dashboard.statusVi}" /></span>
                                    </span>
                                </div>
                                <p class="portal-hero-meta">
                                    <span>Học sinh Khối <c:out value="${dashboard.gradeLevel}" /></span>
                                    <span class="portal-meta-sep">•</span>
                                    <span>Trường: <c:out value="${empty dashboard.school ? 'THPT Chu Văn An' : dashboard.school}" /></span>
                                    <span class="portal-meta-sep">•</span>
                                    <span>Niên khóa 2025 - 2026</span>
                                    <span class="portal-meta-sep">•</span>
                                    <span style="color: var(--primary); font-weight: 600;">Mục tiêu: <c:out value="${empty dashboard.targetGoal ? 'Luyện thi THPT Quốc Gia & Đánh giá năng lực' : dashboard.targetGoal}" /></span>
                                </p>
                            </div>
                            <div class="portal-hero-actions">
                                <a href="${pageContext.request.contextPath}/student/schedule" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                    <span>Xem lịch học</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/student/progress" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                    </svg>
                                    <span>Bảng điểm chi tiết</span>
                                </a>
                            </div>
                        </section>

                        <!-- Key Metrics / KPI Stat Cards (4 columns) -->
                        <section class="portal-kpi-grid">
                            <!-- Stat 1: Enrolled Classes -->
                            <div class="portal-kpi-card">
                                <div class="portal-kpi-content">
                                    <span class="portal-kpi-label">Lớp đang theo học</span>
                                    <div class="portal-kpi-val-row">
                                        <span class="portal-kpi-value"><c:out value="${dashboard.enrolledClassCount}" /></span>
                                        <span class="portal-kpi-sub">lớp chuyên sâu</span>
                                    </div>
                                </div>
                                <div class="portal-kpi-icon-box bg-primary-tint">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                        <path d="M6 6h10"></path>
                                        <path d="M6 10h10"></path>
                                    </svg>
                                </div>
                            </div>

                            <!-- Stat 2: Attendance Rate -->
                            <div class="portal-kpi-card">
                                <div class="portal-kpi-content">
                                    <span class="portal-kpi-label">Tỷ lệ chuyên cần</span>
                                    <div class="portal-kpi-val-row">
                                        <span class="portal-kpi-value text-success"><c:out value="${dashboard.attendanceSummary.attendanceRateFormatted}" /></span>
                                        <span class="portal-kpi-sub" style="color: var(--success); font-weight: 600;">
                                            <c:choose>
                                                <c:when test="${dashboard.attendanceSummary.attendanceRate >= 80}">Đạt chuẩn</c:when>
                                                <c:otherwise>Cần cố gắng</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                                <div class="portal-kpi-icon-box bg-success-tint">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                    </svg>
                                </div>
                            </div>

                            <!-- Stat 3: Average Score -->
                            <div class="portal-kpi-card">
                                <div class="portal-kpi-content">
                                    <span class="portal-kpi-label">Điểm kiểm tra TB</span>
                                    <div class="portal-kpi-val-row">
                                        <span class="portal-kpi-value text-warning">
                                            <c:choose>
                                                <c:when test="${not empty dashboard.averageScore}"><c:out value="${dashboard.averageScore}" /></c:when>
                                                <c:otherwise>--</c:otherwise>
                                            </c:choose>
                                        </span>
                                        <span class="portal-kpi-sub">/ 10</span>
                                    </div>
                                </div>
                                <div class="portal-kpi-icon-box bg-warning-tint">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="12" cy="8" r="6"></circle>
                                        <path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path>
                                    </svg>
                                </div>
                            </div>

                            <!-- Stat 4: Upcoming Sessions -->
                            <div class="portal-kpi-card">
                                <div class="portal-kpi-content">
                                    <span class="portal-kpi-label">Lịch học sắp tới</span>
                                    <div class="portal-kpi-val-row">
                                        <span class="portal-kpi-value text-primary"><c:out value="${dashboard.upcomingSessions.size()}" /></span>
                                        <span class="portal-kpi-sub">buổi kế tiếp</span>
                                    </div>
                                </div>
                                <div class="portal-kpi-icon-box bg-info-tint">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                            </div>
                        </section>

                        <!-- Main Grid: 2 Columns (Next Sessions vs Latest Test Scores) -->
                        <section class="portal-2col-grid">
                            <!-- Left Column: Upcoming Class Schedule -->
                            <div class="portal-panel">
                                <div class="portal-panel-header">
                                    <div class="portal-panel-header-left">
                                        <div class="portal-panel-header-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                        </div>
                                        <div>
                                            <h2 class="portal-panel-title">Lịch học kế tiếp</h2>
                                            <p class="portal-panel-subtitle">5 buổi học gần nhất theo thời khóa biểu</p>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/student/schedule" class="text-primary font-semibold" style="font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                                        <span>Xem tất cả</span>
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </a>
                                </div>

                                <div class="portal-panel-body">
                                    <c:choose>
                                        <c:when test="${empty dashboard.upcomingSessions}">
                                            <div class="empty-state" style="padding: 36px 16px; text-align: center;">
                                                <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                                    </svg>
                                                </div>
                                                <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">Không có ca học nào sắp diễn ra trong 7 ngày tới.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="sess" items="${dashboard.upcomingSessions}">
                                                <div class="portal-session-item ${sess.subjectName == 'Toán học' ? 'accent-toan' : (sess.subjectName == 'Vật lý' ? 'accent-ly' : (sess.subjectName == 'Tiếng Anh' ? 'accent-anh' : (sess.subjectName == 'Hóa học' ? 'accent-hoa' : 'accent-van')))}">
                                                    <div class="portal-session-left">
                                                        <div class="portal-session-title"><c:out value="${sess.className}" /></div>
                                                        <div class="portal-session-meta">
                                                            <span class="portal-badge-subject ${sess.subjectName == 'Toán học' ? 'subject-toan' : (sess.subjectName == 'Vật lý' ? 'subject-ly' : (sess.subjectName == 'Tiếng Anh' ? 'subject-anh' : (sess.subjectName == 'Hóa học' ? 'subject-hoa' : 'subject-default')))}">
                                                                <c:out value="${sess.subjectName}" />
                                                            </span>
                                                            <span class="portal-meta-sep">•</span>
                                                            <span>GV: <c:out value="${sess.teacherName}" /></span>
                                                        </div>
                                                        <div class="portal-session-room">
                                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                                <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                                <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                                            </svg>
                                                            <span><c:out value="${sess.roomName}" /></span>
                                                            <c:if test="${not empty sess.notes}">
                                                                <span class="portal-meta-sep">•</span>
                                                                <span style="font-style: italic;"><c:out value="${sess.notes}" /></span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="portal-session-right">
                                                        <span class="portal-session-date"><c:out value="${sess.dayOfWeekVi}" />, <c:out value="${sess.formattedDate}" /></span>
                                                        <span class="portal-session-time"><c:out value="${sess.timeRange}" /></span>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Right Column: Exam & Test Results -->
                            <div class="portal-panel">
                                <div class="portal-panel-header">
                                    <div class="portal-panel-header-left">
                                        <div class="portal-panel-header-icon" style="color: var(--success);">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                            </svg>
                                        </div>
                                        <div>
                                            <h2 class="portal-panel-title">Điểm kiểm tra đã công bố</h2>
                                            <p class="portal-panel-subtitle">Kết quả đánh giá định kỳ và thi thử mới nhất</p>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/student/progress" class="text-primary font-semibold" style="font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                                        <span>Xem chi tiết</span>
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </a>
                                </div>

                                <div class="portal-panel-body">
                                    <c:choose>
                                        <c:when test="${empty dashboard.recentScores}">
                                            <div class="empty-state" style="padding: 36px 16px; text-align: center;">
                                                <div style="width: 48px; height: 48px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                                    </svg>
                                                </div>
                                                <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">Chưa có bài kiểm tra nào được công bố điểm.</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="sc" items="${dashboard.recentScores}">
                                                <div class="portal-score-item">
                                                    <div class="portal-score-info">
                                                        <div class="portal-score-title" title="<c:out value='${sc.assessmentTitle}' />">
                                                            <c:out value="${sc.assessmentTitle}" />
                                                        </div>
                                                        <div class="portal-score-meta">
                                                            <span class="portal-badge-subject ${sc.subjectName == 'Toán học' ? 'subject-toan' : (sc.subjectName == 'Vật lý' ? 'subject-ly' : (sc.subjectName == 'Tiếng Anh' ? 'subject-anh' : 'subject-default'))}">
                                                                <c:out value="${sc.subjectName}" />
                                                            </span>
                                                            <span class="portal-meta-sep">•</span>
                                                            <span><c:out value="${sc.typeNameVi}" /></span>
                                                            <span class="portal-meta-sep">•</span>
                                                            <span>Ngày: <c:out value="${sc.formattedDate}" /></span>
                                                        </div>
                                                    </div>
                                                    <div class="portal-score-right">
                                                        <div class="portal-score-val">
                                                            <span class="portal-score-num"><fmt:formatNumber value="${sc.score}" minFractionDigits="1" maxFractionDigits="2" /></span>
                                                            <span class="portal-score-max">/<fmt:formatNumber value="${sc.maxScore}" minFractionDigits="0" maxFractionDigits="0" /></span>
                                                        </div>
                                                        <c:choose>
                                                            <c:when test="${sc.gradeRating == 'Xuất sắc'}">
                                                                <span class="portal-badge-rating rating-excellent">★ Xuất sắc</span>
                                                            </c:when>
                                                            <c:when test="${sc.gradeRating == 'Giỏi'}">
                                                                <span class="portal-badge-rating rating-good">Giỏi</span>
                                                            </c:when>
                                                            <c:when test="${sc.gradeRating == 'Khá'}">
                                                                <span class="portal-badge-rating rating-fair">Khá</span>
                                                            </c:when>
                                                            <c:when test="${sc.gradeRating == 'Đạt'}">
                                                                <span class="portal-badge-rating rating-pass">Đạt</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="portal-badge-rating rating-poor">Cần cố gắng</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </section>

                        <!-- Enrolled Class Roster (Data Table) -->
                        <section class="portal-table-panel">
                            <div class="portal-table-header">
                                <div class="portal-panel-header-left">
                                    <div class="portal-panel-header-icon">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                            <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <h2 class="portal-panel-title">Danh sách lớp học đang tham gia</h2>
                                        <p class="portal-panel-subtitle">Các lớp đăng ký chính thức trong học kỳ</p>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge badge-info" style="font-size: 12px; font-weight: 600;">
                                        Tổng số: <strong><c:out value="${dashboard.enrolledClasses.size()}" /> lớp</strong>
                                    </span>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${empty dashboard.enrolledClasses}">
                                    <div class="empty-state" style="padding: 40px 16px; text-align: center;">
                                        <p style="margin: 0; font-size: 14px; color: var(--text-muted);">Học sinh hiện chưa đăng ký lớp học nào.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="portal-table-responsive">
                                        <table class="portal-table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 140px;">Mã lớp</th>
                                                    <th>Tên lớp học</th>
                                                    <th>Môn học</th>
                                                    <th>Giáo viên phụ trách</th>
                                                    <th>Phòng học</th>
                                                    <th style="text-align: center; width: 130px;">Trạng thái</th>
                                                    <th style="text-align: right; width: 110px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="cl" items="${dashboard.enrolledClasses}">
                                                    <tr>
                                                        <td>
                                                            <span class="portal-code-badge"><c:out value="${cl.code}" /></span>
                                                        </td>
                                                        <td>
                                                            <div style="font-weight: 600; color: var(--text);"><c:out value="${cl.name}" /></div>
                                                            <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;"><c:out value="${cl.shiftName}" /></div>
                                                        </td>
                                                        <td>
                                                            <span class="portal-badge-subject ${cl.subjectName == 'Toán học' ? 'subject-toan' : (cl.subjectName == 'Vật lý' ? 'subject-ly' : (cl.subjectName == 'Tiếng Anh' ? 'subject-anh' : (cl.subjectName == 'Hóa học' ? 'subject-hoa' : 'subject-default')))}">
                                                                <c:out value="${empty cl.subjectName ? 'Văn hóa THPT' : cl.subjectName}" />
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                                <div style="width: 28px; height: 28px; border-radius: 50%; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 11px;">
                                                                    <c:out value="${cl.teacherName.substring(0, 1)}" />
                                                                </div>
                                                                <span style="font-weight: 500;"><c:out value="${cl.teacherName}" /></span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span style="color: var(--text-muted);"><c:out value="${cl.roomName}" /></span>
                                                        </td>
                                                        <td style="text-align: center;">
                                                            <c:choose>
                                                                <c:when test="${cl.status == 'OPEN'}">
                                                                    <span class="portal-badge-status class-open">
                                                                        <span class="pulse-indicator"></span>
                                                                        <span>Đang học</span>
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${cl.status == 'PLANNING'}">
                                                                    <span class="portal-badge-status class-planning">Sắp mở</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="portal-badge-status class-closed"><c:out value="${cl.status}" /></span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td style="text-align: right;">
                                                            <a href="${pageContext.request.contextPath}/student/schedule" class="btn btn-secondary btn-sm" title="Xem lịch học" style="display: inline-flex; align-items: center; padding: 4px 8px;">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                                                </svg>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div class="portal-table-footer">
                                        <div style="display: flex; align-items: center; gap: 6px;">
                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                            </svg>
                                            <span>Học sinh cần mang thẻ học viên khi đến trung tâm để quét mã vạch điểm danh.</span>
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/student/schedule" style="color: var(--primary); font-weight: 600; text-decoration: none;">Xem thời khóa biểu toàn khóa &rarr;</a>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </section>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>
</body>
</html>
