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
    <c:set var="activeNav" value="${empty activeNav ? 'parent-progress' : activeNav}" scope="request" />
    <c:set var="breadcrumb" value="${empty breadcrumb ? 'Hồ sơ chi tiết của con' : breadcrumb}" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <div class="portal-wrap">
                <!-- Top Child Profile Header -->
                <section class="portal-profile-hero">
                    <div class="portal-hero-info">
                        <div class="portal-hero-title-row">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <div style="width: 38px; height: 38px; border-radius: 50%; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px;">
                                    <c:out value="${childDetail.studentName.substring(0, 1)}" />
                                </div>
                                <div>
                                    <div style="font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted);">Học bạ &amp; Tiến độ học tập:</div>
                                    <h1 class="portal-hero-name" style="font-size: 20px;">
                                        <c:out value="${childDetail.studentName}" />
                                    </h1>
                                </div>
                            </div>
                            <span class="portal-code-badge"><c:out value="${childDetail.studentCode}" /></span>
                            <span class="portal-status-pill ${childDetail.status == 'STUDYING' ? 'status-studying' : (childDetail.status == 'RESERVED' ? 'status-reserved' : (childDetail.status == 'GRADUATED' ? 'status-graduated' : 'status-dropped'))}">
                                <span class="portal-status-dot"></span>
                                <span><c:out value="${empty childDetail.statusVi ? 'Đang theo học' : childDetail.statusVi}" /></span>
                            </span>
                        </div>
                        <p class="portal-hero-meta">
                            <span>Khối <c:out value="${childDetail.gradeLevel}" /></span>
                            <span class="portal-meta-sep">•</span>
                            <span>Trường: <c:out value="${empty childDetail.school ? 'THPT Chu Văn An' : childDetail.school}" /></span>
                            <span class="portal-meta-sep">•</span>
                            <span style="color: var(--primary); font-weight: 600;">Mục tiêu: <c:out value="${empty childDetail.targetGoal ? 'Luyện thi THPT Quốc Gia & ĐGNL' : childDetail.targetGoal}" /></span>
                        </p>
                    </div>

                    <div class="portal-hero-actions">
                        <a href="${pageContext.request.contextPath}/parent/schedule?childId=${childDetail.studentId}" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <span>Lịch học của con</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                            <span>Quay lại cổng phụ huynh</span>
                        </a>
                    </div>
                </section>

                <!-- Section 1: Thống kê Chuyên cần của con -->
                <section class="portal-panel" style="padding: 24px;">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; flex-wrap: wrap; gap: 10px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div style="width: 36px; height: 36px; border-radius: 8px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                            </div>
                            <h2 style="font-size: 17px; font-weight: 700; color: var(--text); margin: 0;">Mức độ Chuyên cần của con</h2>
                        </div>
                        <span class="badge badge-info" style="font-size: 11.5px;">Điểm danh qua cổng barcode trung tâm</span>
                    </div>

                    <!-- 6 KPI Stat Cards Grid -->
                    <div class="attendance-6kpi-grid">
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Tổng số buổi</span>
                            <span class="attendance-mini-val"><c:out value="${childDetail.attendanceSummary.totalSessions}" /></span>
                            <span class="attendance-mini-sub">theo TKB</span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Có mặt đúng giờ</span>
                            <span class="attendance-mini-val" style="color: var(--success);"><c:out value="${childDetail.attendanceSummary.attendedSessions}" /></span>
                            <span class="attendance-mini-sub" style="color: var(--success); font-weight: 600;">
                                <c:choose>
                                    <c:when test="${childDetail.attendanceSummary.totalSessions > 0}">
                                        <fmt:formatNumber value="${childDetail.attendanceSummary.attendedSessions * 100 / childDetail.attendanceSummary.totalSessions}" maxFractionDigits="1" />%
                                    </c:when>
                                    <c:otherwise>0%</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Đi muộn</span>
                            <span class="attendance-mini-val" style="color: var(--warning);"><c:out value="${childDetail.attendanceSummary.lateSessions}" /></span>
                            <span class="attendance-mini-sub">&lt; 15 phút</span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Vắng có phép</span>
                            <span class="attendance-mini-val" style="color: var(--primary);"><c:out value="${childDetail.attendanceSummary.excusedSessions}" /></span>
                            <span class="attendance-mini-sub">phụ huynh đã báo</span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Vắng không phép</span>
                            <span class="attendance-mini-val" style="color: var(--danger);"><c:out value="${childDetail.attendanceSummary.unexcusedSessions}" /></span>
                            <span class="attendance-mini-sub" style="color: var(--danger);">cần lưu ý</span>
                        </div>
                        <div class="attendance-mini-card highlight">
                            <span class="attendance-mini-label" style="color: var(--primary); font-weight: 700;">Tỷ lệ chuyên cần</span>
                            <span class="attendance-mini-val" style="color: var(--primary);"><c:out value="${childDetail.attendanceSummary.attendanceRateFormatted}" /></span>
                            <span class="attendance-mini-sub" style="color: var(--primary); font-weight: 700;">
                                <c:choose>
                                    <c:when test="${childDetail.attendanceSummary.attendanceRate >= 80}">Đạt chuẩn</c:when>
                                    <c:otherwise>Cần cố gắng</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <!-- Attendance Progress Bar Container -->
                    <div class="attendance-track-box">
                        <div class="attendance-track-header">
                            <span>Chuyên cần tổng thể của con:</span>
                            <span style="font-size: 16px; font-weight: 800; color: var(--success);"><c:out value="${childDetail.attendanceSummary.attendanceRateFormatted}" /></span>
                        </div>

                        <!-- Multi-segment Progress Track -->
                        <c:set var="totalS" value="${childDetail.attendanceSummary.totalSessions > 0 ? childDetail.attendanceSummary.totalSessions : 1}" />
                        <div class="attendance-multi-bar">
                            <div class="attendance-bar-seg seg-present" style="width: ${childDetail.attendanceSummary.attendedSessions * 100 / totalS}%;" title="Đúng giờ: ${childDetail.attendanceSummary.attendedSessions}"></div>
                            <div class="attendance-bar-seg seg-late" style="width: ${childDetail.attendanceSummary.lateSessions * 100 / totalS}%;" title="Đi muộn: ${childDetail.attendanceSummary.lateSessions}"></div>
                            <div class="attendance-bar-seg seg-excused" style="width: ${childDetail.attendanceSummary.excusedSessions * 100 / totalS}%;" title="Có phép: ${childDetail.attendanceSummary.excusedSessions}"></div>
                            <div class="attendance-bar-seg seg-unexcused" style="width: ${childDetail.attendanceSummary.unexcusedSessions * 100 / totalS}%;" title="Không phép: ${childDetail.attendanceSummary.unexcusedSessions}"></div>
                        </div>

                        <!-- Guidance Note & Legend -->
                        <div class="attendance-track-legend">
                            <div style="display: flex; align-items: center; gap: 6px; color: var(--success); font-weight: 600;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                <span>Con duy trì tỷ lệ tham gia lớp học tốt, đủ điều kiện dự thi các kỳ khảo sát định kỳ.</span>
                            </div>
                            <div class="attendance-legend-items">
                                <span class="attendance-legend-item"><span class="legend-dot" style="background: var(--success);"></span>Đúng giờ</span>
                                <span class="attendance-legend-item"><span class="legend-dot" style="background: var(--warning);"></span>Đi muộn</span>
                                <span class="attendance-legend-item"><span class="legend-dot" style="background: var(--primary);"></span>Có phép</span>
                                <span class="attendance-legend-item"><span class="legend-dot" style="background: var(--danger);"></span>Không phép</span>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Growth & Benchmark Analytics Banner -->
                <section class="benchmark-grid">
                    <div class="benchmark-card">
                        <div>
                            <span class="portal-kpi-label">TĂNG TRƯỞNG HỌC LỰC CỦA CON</span>
                            <div style="display: flex; align-items: baseline; gap: 8px; margin-top: 6px;">
                                <span style="font-size: 26px; font-weight: 800; color: var(--primary);">+1.85</span>
                                <span style="font-size: 13px; font-weight: 700; color: var(--success);">▲ Điểm quy đổi</span>
                            </div>
                            <p style="margin: 6px 0 0 0; font-size: 12.5px; color: var(--text-muted);">
                                Điểm TB hiện tại: <strong style="color: var(--text);"><c:out value="${empty childDetail.averageScore ? '8.65' : childDetail.averageScore}" />/10</strong>
                            </p>
                        </div>
                        <div style="width: 50px; height: 50px; border-radius: 50%; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                        </div>
                    </div>

                    <div class="benchmark-card">
                        <div>
                            <span class="portal-kpi-label">XẾP HẠNG KHỐI L<c:out value="${empty childDetail.gradeLevel ? '12' : childDetail.gradeLevel}" /></span>
                            <div style="display: flex; align-items: baseline; gap: 8px; margin-top: 6px;">
                                <span style="font-size: 26px; font-weight: 800; color: var(--text);">Top 5%</span>
                                <span style="font-size: 12.5px; font-weight: 600; color: var(--text-muted);">(Hạng 14 / 280)</span>
                            </div>
                            <p style="margin: 6px 0 0 0; font-size: 12.5px; color: var(--text-muted);">
                                Kết quả đáp ứng tốt mục tiêu xét tuyển đại học nguyện vọng 1.
                            </p>
                        </div>
                        <div style="width: 50px; height: 50px; border-radius: 50%; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="6"></circle><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path></svg>
                        </div>
                    </div>

                    <div class="benchmark-card" style="flex-direction: column; align-items: stretch; justify-content: space-between;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span class="portal-kpi-label">XU HƯỚNG BÀI KIỂM TRA</span>
                            <span style="font-size: 11.5px; font-weight: 700; color: var(--success);">Tăng đều đặn</span>
                        </div>
                        <div style="width: 100%; height: 44px; margin-top: 4px;">
                            <svg class="w-full h-full" style="width: 100%; height: 100%; color: var(--primary);" fill="none" preserveAspectRatio="none" viewBox="0 0 240 48">
                                <path d="M 0 38 L 50 32 L 100 24 L 150 18 L 190 20 L 240 6" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"></path>
                                <path d="M 0 38 L 50 32 L 100 24 L 150 18 L 190 20 L 240 6 L 240 48 L 0 48 Z" fill="currentColor" fill-opacity="0.08"></path>
                                <circle cx="0" cy="38" fill="currentColor" r="3"></circle>
                                <circle cx="50" cy="32" fill="currentColor" r="3"></circle>
                                <circle cx="100" cy="24" fill="currentColor" r="3"></circle>
                                <circle cx="150" cy="18" fill="currentColor" r="3"></circle>
                                <circle cx="190" cy="20" fill="currentColor" r="3"></circle>
                                <circle cx="240" cy="6" fill="var(--success)" r="4"></circle>
                            </svg>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); font-weight: 600;">
                            <span>7.5</span>
                            <span>8.0</span>
                            <span>8.8</span>
                            <span>88.0</span>
                            <span style="color: var(--success); font-weight: 800;">94.0</span>
                        </div>
                    </div>
                </section>

                <!-- Section 2: Bảng điểm các bài kiểm tra đã công bố của con -->
                <section class="portal-table-panel">
                    <div class="portal-table-header">
                        <div class="portal-panel-header-left">
                            <div class="portal-panel-header-icon">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                </svg>
                            </div>
                            <div>
                                <h2 class="portal-panel-title">Kết quả các bài kiểm tra đã công bố của con</h2>
                                <p class="portal-panel-subtitle">Tổng cộng <c:out value="${childDetail.recentScores.size()}" /> bài kiểm tra định kỳ &amp; thi thử</p>
                            </div>
                        </div>

                        <div class="portal-pills">
                            <button type="button" class="portal-pill-btn active" onclick="filterScoreSubject('ALL', this)">Tất cả môn (<c:out value="${childDetail.recentScores.size()}" />)</button>
                            <button type="button" class="portal-pill-btn" onclick="filterScoreSubject('Toán học', this)">Toán học</button>
                            <button type="button" class="portal-pill-btn" onclick="filterScoreSubject('Vật lý', this)">Vật lý</button>
                            <button type="button" class="portal-pill-btn" onclick="filterScoreSubject('Tiếng Anh', this)">Tiếng Anh</button>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty childDetail.recentScores}">
                            <div class="empty-state" style="padding: 56px 20px; text-align: center;">
                                <div style="width: 60px; height: 60px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 14px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                                </div>
                                <h3 style="font-size: 17px; font-weight: 700; color: var(--text); margin: 0 0 8px;">Chưa có điểm kiểm tra</h3>
                                <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">Giáo viên chưa công bố điểm bài thi nào cho các lớp học của con.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="portal-table-responsive">
                                <table class="portal-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 28%;">Tên bài kiểm tra</th>
                                            <th style="width: 15%;">Môn / Lớp</th>
                                            <th style="width: 14%;">Hình thức</th>
                                            <th style="width: 12%;">Ngày làm bài</th>
                                            <th style="width: 11%; text-align: center;">Điểm số</th>
                                            <th style="width: 10%; text-align: center;">Đánh giá</th>
                                            <th style="width: 20%;">Nhận xét giáo viên</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="sc" items="${childDetail.recentScores}">
                                            <tr class="score-data-row" data-subject="<c:out value='${sc.subjectName}' />">
                                                <td>
                                                    <div style="font-weight: 700; color: var(--text); line-height: 1.35;"><c:out value="${sc.assessmentTitle}" /></div>
                                                    <div style="display: flex; align-items: center; gap: 4px; font-size: 11.5px; color: var(--text-muted); margin-top: 3px;">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                                        <span>Trọng số: <fmt:formatNumber value="${sc.weight}" maxFractionDigits="1" /></span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="portal-badge-subject ${sc.subjectName == 'Toán học' ? 'subject-toan' : (sc.subjectName == 'Vật lý' ? 'subject-ly' : (sc.subjectName == 'Tiếng Anh' ? 'subject-anh' : (sc.subjectName == 'Hóa học' ? 'subject-hoa' : 'subject-default')))}">
                                                        <c:out value="${sc.subjectName}" />
                                                    </span>
                                                    <span style="font-size: 11.5px; color: var(--text-muted); display: block; margin-top: 2px;"><c:out value="${sc.classCode}" /></span>
                                                </td>
                                                <td>
                                                    <span style="font-size: 13px; color: var(--text); font-weight: 500;"><c:out value="${sc.typeNameVi}" /></span>
                                                </td>
                                                <td>
                                                    <span style="font-size: 13px; color: var(--text-muted);"><c:out value="${sc.formattedDate}" /></span>
                                                </td>
                                                <td style="text-align: center; white-space: nowrap;">
                                                    <span style="font-size: 18px; font-weight: 800; color: var(--success);">
                                                        <fmt:formatNumber value="${sc.score}" minFractionDigits="1" maxFractionDigits="2" />
                                                    </span>
                                                    <span style="font-size: 11px; color: var(--text-muted); font-weight: 600;">/<fmt:formatNumber value="${sc.maxScore}" minFractionDigits="0" maxFractionDigits="0" /></span>
                                                </td>
                                                <td style="text-align: center;">
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
                                                </td>
                                                <td>
                                                    <p style="margin: 0; font-size: 12.5px; color: var(--text-muted); line-height: 1.45;">
                                                        <c:out value="${empty sc.remark ? 'Tư duy tốt, học sinh nắm vững phương pháp giải.' : sc.remark}" />
                                                    </p>
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
                                        <circle cx="12" cy="12" r="4"></circle>
                                    </svg>
                                    <span>Phụ huynh có thể trao đổi với giáo viên chủ nhiệm nếu cần tư vấn kết quả thi thử.</span>
                                </div>
                                <div style="display: flex; gap: 8px;">
                                    <a href="${pageContext.request.contextPath}/parent/schedule?childId=${childDetail.studentId}" class="btn btn-secondary btn-sm">Xem lịch học của con</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Support & Academic Advisory Ribbon -->
                <aside class="advisory-ribbon">
                    <div class="advisory-ribbon-left">
                        <div class="advisory-icon-circle">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
                            </svg>
                        </div>
                        <div>
                            <h3 class="advisory-title">Đồng hành cùng kết quả học tập của con</h3>
                            <p class="advisory-desc">Đội ngũ giáo viên và chuyên viên khảo thí EduCenter luôn sẵn sàng lắng nghe và phối hợp cùng quý phụ huynh.</p>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                            <span>Liên hệ ban giáo vụ</span>
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </a>
                    </div>
                </aside>
            </div>
        </main>
    </div>
</div>

<script>
function filterScoreSubject(sub, btn) {
    document.querySelectorAll('.portal-pills .portal-pill-btn').forEach(b => b.classList.remove('active'));
    if (btn) btn.classList.add('active');

    const rows = document.querySelectorAll('.score-data-row');
    rows.forEach(r => {
        const rowSub = r.getAttribute('data-subject') || '';
        if (sub === 'ALL' || rowSub.includes(sub)) {
            r.style.display = '';
        } else {
            r.style.display = 'none';
        }
    });
}
</script>
</body>
</html>
