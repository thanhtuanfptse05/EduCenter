<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="teacher-dashboard" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Bàn làm việc giảng dạy" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- 1. Top Command & Action Bar -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <div class="mgmt-breadcrumb">
                            <span class="mgmt-badge-version">TCH-01 • GIẢNG VIÊN CƠ HỮU</span>
                            <span>•</span>
                            <span>Niên khóa 2026 – 2027</span>
                        </div>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Bàn Làm Việc Giảng Dạy</h1>
                        </div>
                        <p class="mgmt-subtitle">
                            Xin chào Thầy/Cô <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong> — Quản lý lịch dạy, điểm danh lớp học và theo dõi đánh giá học tập cá nhân.
                        </p>
                    </div>
                    <div class="mgmt-header-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="window.print();" title="In hoặc lưu lịch giảng dạy">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <rect height="18" rx="2" ry="2" width="18" x="3" y="4"></rect>
                                <line x1="16" x2="16" y1="2" y2="6"></line>
                                <line x1="8" x2="8" y1="2" y2="6"></line>
                                <line x1="3" x2="21" y1="10" y2="10"></line>
                            </svg>
                            <span>Xuất lịch iCal</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary btn-sm">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <polyline points="9 11 12 14 22 4"></polyline>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                            </svg>
                            <span>Sổ điểm danh</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-primary btn-sm">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <line x1="12" x2="12" y1="5" y2="19"></line>
                                <line x1="5" x2="19" y1="12" y2="12"></line>
                            </svg>
                            <span>Tạo bài kiểm tra mới</span>
                        </a>
                    </div>
                </div>

                <!-- 2. Metric KPI Cards Row (4 Columns) -->
                <div class="mgmt-kpi-grid">
                    <!-- KPI 1 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content">
                            <span class="mgmt-kpi-label">Lớp học phụ trách</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value"><c:out value="${totalClassesCount}"/></span>
                                <span class="mgmt-kpi-sub">lớp</span>
                            </div>
                            <span style="font-size: 11.5px; color: #047857; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: #10b981;"></span>
                                Lớp đang hoạt động trong kỳ
                            </span>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-primary-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 2 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content">
                            <span class="mgmt-kpi-label">Ca dạy hôm nay</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value" style="color: var(--primary);"><c:out value="${todaySessionsCount}"/></span>
                                <span class="mgmt-kpi-sub">ca trọng điểm</span>
                            </div>
                            <span style="font-size: 11.5px; color: var(--text-muted); font-weight: 500;">
                                <c:choose>
                                    <c:when test="${todaySessionsCount > 0}">Cần hoàn thành điểm danh</c:when>
                                    <c:otherwise>Không có lịch dạy hôm nay</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-info-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 3 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content">
                            <span class="mgmt-kpi-label">Buổi dạy đã hoàn thành</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value" style="color: #047857;"><c:out value="${completedSessionsCount}"/></span>
                                <span class="mgmt-kpi-sub">buổi thực dạy</span>
                            </div>
                            <span style="font-size: 11.5px; color: #047857; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                                <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                                Đã chốt sổ và điểm danh
                            </span>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-success-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 4 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content">
                            <span class="mgmt-kpi-label">Bài kiểm tra & Đánh giá</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value"><c:out value="${assessmentsCount}"/></span>
                                <span class="mgmt-kpi-sub">đợt thi</span>
                            </div>
                            <span style="font-size: 11.5px; color: var(--text-muted); font-weight: 500;">
                                Bảng điểm & phổ điểm định kỳ
                            </span>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-warning-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <polyline points="14 2 14 8 20 8"></polyline>
                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                <line x1="16" y1="17" x2="8" y2="17"></line>
                                <polyline points="10 9 9 9 8 9"></polyline>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- 3. Section 1: Lịch dạy hôm nay & Thao tác nhanh -->
                <div class="teacher-hero-card">
                    <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div class="mgmt-pulse-dot" style="background: var(--primary);"></div>
                            <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">Lịch dạy hôm nay &amp; Thao tác nhanh</h2>
                        </div>
                        <div class="mgmt-stat-pill pill-primary">
                            <svg class="icon icon-sm" style="width: 14px; height: 14px;" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>Hôm nay: <c:out value="${todaySessionsCount}"/> ca dạy</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty todaySessions}">
                            <div style="display: flex; flex-direction: column; gap: 14px;">
                                <c:forEach var="s" items="${todaySessions}">
                                    <div class="teacher-hero-inner">
                                        <div style="display: flex; flex-direction: column; gap: 12px; flex: 1; min-width: 0;">
                                            <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                                                <span class="mgmt-code-pill" style="font-size: 13px; font-weight: 800; padding: 3px 10px; background: var(--primary); color: #fff;">
                                                    <c:out value="${s.classCode}"/>
                                                </span>
                                                <span style="font-size: 16px; font-weight: 700; color: var(--text);">
                                                    <c:out value="${s.className}"/>
                                                </span>
                                                <c:if test="${not empty s.subjectName}">
                                                    <span style="font-size: 13px; color: var(--text-muted);">• <c:out value="${s.subjectName}"/></span>
                                                </c:if>
                                                <c:choose>
                                                    <c:when test="${s.sessionStatus == 'COMPLETED'}">
                                                        <span class="mgmt-badge badge-active">ĐÃ HOÀN TẤT</span>
                                                    </c:when>
                                                    <c:when test="${s.sessionStatus == 'IN_PROGRESS'}">
                                                        <span class="mgmt-badge badge-status-opening">ĐANG DIỄN RA</span>
                                                    </c:when>
                                                    <c:when test="${s.sessionStatus == 'CANCELLED'}">
                                                        <span class="mgmt-badge badge-status-closed">ĐÃ HỦY</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="mgmt-badge badge-status-draft">LÊN LỊCH</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <div class="teacher-hero-grid">
                                                <!-- Time -->
                                                <div class="teacher-meta-item">
                                                    <div class="teacher-meta-icon" style="color: var(--primary);">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                    </div>
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--text-muted);">Thời gian ca</span>
                                                        <span style="font-size: 14px; font-weight: 700; color: var(--text);"><c:out value="${s.startTime}"/> – <c:out value="${s.endTime}"/></span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted);">Ngày: <c:out value="${s.sessionDate}"/></span>
                                                    </div>
                                                </div>

                                                <!-- Room -->
                                                <div class="teacher-meta-item">
                                                    <div class="teacher-meta-icon" style="color: #047857;">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                                        </svg>
                                                    </div>
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--text-muted);">Phòng học</span>
                                                        <span style="font-size: 14px; font-weight: 700; color: var(--text);"><c:out value="${empty s.roomName ? 'Chưa xếp phòng' : s.roomName}"/></span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted);">Cơ sở trung tâm</span>
                                                    </div>
                                                </div>

                                                <!-- Attendance Counts -->
                                                <div class="teacher-meta-item">
                                                    <div class="teacher-meta-icon" style="color: #b45309;">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                            <circle cx="9" cy="7" r="4"></circle>
                                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                        </svg>
                                                    </div>
                                                    <div style="display: flex; flex-direction: column;">
                                                        <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--text-muted);">Sĩ số & Chuyên cần</span>
                                                        <div class="att-badge-row" style="margin-top: 2px;">
                                                            <span class="att-badge present" title="Có mặt">Có: ${s.presentCount}</span>
                                                            <span class="att-badge late" title="Đi muộn">Muộn: ${s.lateCount}</span>
                                                            <span class="att-badge absent" title="Vắng mặt">Vắng: ${s.excusedCount + s.unexcusedCount}</span>
                                                            <span class="att-badge muted">Tổng: ${s.totalStudents}</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Action Cluster -->
                                        <div style="display: flex; align-items: center; gap: 8px; flex-shrink: 0; flex-wrap: wrap;">
                                            <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${s.sessionId}" class="btn btn-primary btn-sm">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                    <polyline points="16 11 18 13 22 9"></polyline>
                                                </svg>
                                                <span>Điểm danh ngay</span>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/teacher/journal?sessionId=${s.sessionId}" class="btn btn-secondary btn-sm">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M12 20h9"></path>
                                                    <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                                </svg>
                                                <span>Ghi nhật ký dạy</span>
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mgmt-empty-box" style="padding: 36px 20px;">
                                <div class="mgmt-empty-icon" style="width: 48px; height: 48px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                </div>
                                <h3 class="mgmt-empty-title" style="font-size: 15px;">Hôm nay bạn không có ca dạy nào</h3>
                                <p class="mgmt-empty-desc" style="font-size: 13px;">Thời khóa biểu hôm nay trống. Thầy/Cô có thể xem toàn bộ ca dạy trong tuần hoặc chuẩn bị bài giảng tại Sổ điểm danh.</p>
                                <div class="mgmt-empty-actions">
                                    <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary btn-sm">Xem toàn bộ lịch dạy</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 4. Section 2: Lớp học được phân công phụ trách -->
                <div class="mgmt-table-card">
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-title-group">
                            <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                            </svg>
                            <span class="mgmt-table-title">Lớp học được phân công phụ trách</span>
                            <span class="mgmt-table-count-badge"><c:out value="${totalClassesCount}"/> lớp</span>
                        </div>
                        <div class="mgmt-table-actions-right">
                            <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-ghost btn-sm" style="color: var(--primary); font-weight: 600;">
                                <span>Xem toàn bộ thời khóa biểu</span>
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <polyline points="9 18 15 12 9 6"></polyline>
                                </svg>
                            </a>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty assignedClasses}">
                            <div class="mgmt-table-responsive">
                                <table class="mgmt-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 120px;">Mã lớp</th>
                                            <th>Tên lớp học &amp; Cấp độ</th>
                                            <th>Khóa học / Bộ môn</th>
                                            <th>Phòng học &amp; Cơ sở</th>
                                            <th style="min-width: 140px;">Sĩ số / Sức chứa</th>
                                            <th style="text-align: center;">Trạng thái</th>
                                            <th style="text-align: right; width: 170px;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="c" items="${assignedClasses}">
                                            <tr>
                                                <td>
                                                    <span class="mgmt-code-pill" style="font-size: 12px; font-weight: 800; color: var(--primary);">
                                                        <c:out value="${c.code}"/>
                                                    </span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 700; color: var(--text);"><c:out value="${c.name}"/></div>
                                                    <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                        Giảng viên: <c:out value="${sessionScope.currentUser.fullName}"/>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);"><c:out value="${c.course != null ? c.course.name : '—'}"/></div>
                                                    <c:if test="${c.course != null and c.course.subject != null}">
                                                        <div style="font-size: 11.5px; color: var(--text-muted);"><c:out value="${c.course.subject.name}"/></div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);"><c:out value="${c.room != null ? c.room.name : 'Chưa xếp phòng'}"/></div>
                                                    <div style="font-size: 11.5px; color: var(--text-muted);">EduCenter Central</div>
                                                </td>
                                                <td>
                                                    <div style="display: flex; justify-content: space-between; font-size: 12px; font-weight: 600; margin-bottom: 4px;">
                                                        <span><c:out value="${c.capacity}"/> học viên</span>
                                                        <span style="color: var(--text-muted);">Sức chứa tối đa</span>
                                                    </div>
                                                    <div class="mgmt-progress-track">
                                                        <div class="mgmt-progress-fill" style="width: 75%;"></div>
                                                    </div>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${c.status == 'OPENING'}">
                                                            <span class="mgmt-badge badge-status-opening">ĐANG MỞ</span>
                                                        </c:when>
                                                        <c:when test="${c.status == 'ONGOING'}">
                                                            <span class="mgmt-badge badge-active">ONGOING</span>
                                                        </c:when>
                                                        <c:when test="${c.status == 'CLOSED' || c.status == 'COMPLETED'}">
                                                            <span class="mgmt-badge badge-status-closed">KẾT THÚC</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="mgmt-badge badge-status-draft"><c:out value="${c.status}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <div style="display: inline-flex; align-items: center; gap: 6px;">
                                                        <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary btn-sm" title="Xem ca học & điểm danh">
                                                            Điểm danh
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/teacher/assessments?classId=${c.id}" class="btn btn-secondary btn-sm" style="color: var(--primary);" title="Quản lý bài kiểm tra của lớp">
                                                            Bài thi
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
                            <div class="mgmt-empty-box">
                                <div class="mgmt-empty-icon">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                </div>
                                <h3 class="mgmt-empty-title">Chưa có lớp học được phân công</h3>
                                <p class="mgmt-empty-desc">Tài khoản của Thầy/Cô hiện chưa được phân công lớp học nào trong học kỳ này. Vui lòng liên hệ Bộ phận Giáo vụ để nhận lịch phân công.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 5. Section 3: Bài kiểm tra gần đây & Bảng điểm -->
                <div class="mgmt-table-card">
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-title-group">
                            <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M9 11l3 3L22 4"></path>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                            </svg>
                            <span class="mgmt-table-title">Bài kiểm tra gần đây &amp; Bảng điểm</span>
                        </div>
                        <div class="mgmt-table-actions-right">
                            <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-ghost btn-sm" style="color: var(--primary); font-weight: 600;">
                                <span>Xem tất cả <c:out value="${assessmentsCount}"/> bài kiểm tra</span>
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <line x1="5" x2="19" y1="12" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </a>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty assessments}">
                            <div class="mgmt-table-responsive">
                                <table class="mgmt-table">
                                    <thead>
                                        <tr>
                                            <th>Tên bài kiểm tra</th>
                                            <th>Lớp học</th>
                                            <th>Ngày thi</th>
                                            <th>Trọng số / Thang điểm</th>
                                            <th style="text-align: center;">Trạng thái</th>
                                            <th>Kết quả / Tiến độ</th>
                                            <th style="text-align: right; width: 150px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="a" items="${assessments}" varStatus="loop">
                                            <c:if test="${loop.count <= 6}">
                                                <tr>
                                                    <td>
                                                        <div style="font-weight: 700; color: var(--text);">
                                                            <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" style="color: var(--primary); text-decoration: none;">
                                                                <c:out value="${empty a.title ? a.name : a.title}"/>
                                                            </a>
                                                        </div>
                                                        <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                            Phân loại: <c:out value="${a.assessmentType}"/>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <span class="mgmt-code-pill" style="font-size: 12px; font-weight: 700; color: var(--primary);"><c:out value="${a.classCode}"/></span>
                                                        <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;"><c:out value="${a.className}"/></div>
                                                    </td>
                                                    <td style="font-size: 13px; font-weight: 600; color: var(--text);">
                                                        <c:out value="${a.testDate}"/>
                                                    </td>
                                                    <td>
                                                        <span style="font-weight: 700; color: var(--text);"><c:out value="${a.weight}"/>x</span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted); display: block;">Thang <c:out value="${a.maxScore}"/></span>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <c:choose>
                                                            <c:when test="${a.status == 'PUBLISHED'}">
                                                                <span class="mgmt-badge badge-active">ĐÃ CÔNG BỐ</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="mgmt-badge badge-status-draft">BẢN NHÁP</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div style="font-size: 12.5px; font-weight: 700; color: var(--text);">
                                                            <c:choose>
                                                                <c:when test="${not empty a.averageScore}">
                                                                    Điểm TB: <fmt:formatNumber value="${a.averageScore}" minFractionDigits="1" maxFractionDigits="2"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span style="color: var(--text-muted); font-weight: 500;">Chưa chốt điểm</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div style="font-size: 11.5px; color: var(--text-muted);">
                                                            Đã chấm: ${a.gradedCount} / ${a.totalStudents} HV
                                                        </div>
                                                    </td>
                                                    <td style="text-align: right;">
                                                        <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 5px;">
                                                            <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
                                                                <path d="M12 20h9"></path>
                                                                <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                                            </svg>
                                                            <span>${a.status == 'PUBLISHED' ? 'Xem bảng điểm' : 'Nhập điểm'}</span>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="mgmt-table-footer">
                                <div>Hiển thị tối đa 6 bài kiểm tra gần nhất trong học kỳ</div>
                                <div style="display: flex; align-items: center; gap: 6px;">
                                    <span style="width: 8px; height: 8px; border-radius: 50%; background: #10b981;"></span>
                                    <span>Tự động đồng bộ lên Cổng Học Viên &amp; Phụ Huynh</span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mgmt-empty-box">
                                <div class="mgmt-empty-icon">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <h3 class="mgmt-empty-title">Chưa có bài kiểm tra nào được tạo</h3>
                                <p class="mgmt-empty-desc">Thầy/Cô hãy bắt đầu tạo các bài kiểm tra 15 phút, 1 tiết hoặc thi thử định kỳ cho các lớp học phụ trách.</p>
                                <div class="mgmt-empty-actions">
                                    <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-primary btn-sm">Tạo bài kiểm tra đầu tiên</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
