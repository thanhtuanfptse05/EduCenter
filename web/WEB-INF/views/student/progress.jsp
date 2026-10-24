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
    <c:set var="activeNav" value="student-progress" scope="request" />
    <c:set var="breadcrumb" value="Kết quả học tập & Chuyên cần" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <div class="portal-wrap">
                <!-- Page Header -->
                <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <div style="display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--primary); margin-bottom: 6px;">
                            <span>Học vụ THPT &amp; Luyện thi Quốc gia</span>
                            <span class="portal-meta-sep">•</span>
                            <span style="color: var(--text-muted);">Niên khóa 2025 - 2026</span>
                        </div>
                        <h1 class="page-title" style="margin: 0; font-size: 24px;">Kết quả học tập &amp; Chuyên cần</h1>
                        <p class="page-subtitle" style="margin: 4px 0 0 0;">Xem điểm các bài kiểm tra đã công bố, thước đo tăng trưởng học lực và thống kê mức độ tham gia lớp học của học viên.</p>
                    </div>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                            <span>Về bảng điều khiển</span>
                        </a>
                        <button type="button" onclick="window.print()" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                            <span>In phiếu điểm</span>
                        </button>
                    </div>
                </div>

                <!-- Section 1: Thống kê Chuyên cần -->
                <section class="portal-panel" style="padding: 24px;">
                    <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; flex-wrap: wrap; gap: 10px;">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div style="width: 36px; height: 36px; border-radius: 8px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                            </div>
                            <h2 style="font-size: 17px; font-weight: 700; color: var(--text); margin: 0;">Thống kê Chuyên cần</h2>
                        </div>
                        <span class="badge badge-info" style="font-size: 11.5px;">Cập nhật hệ thống điểm danh</span>
                    </div>

                    <!-- 6 KPI Stat Cards Grid -->
                    <div class="attendance-6kpi-grid">
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Tổng số buổi</span>
                            <span class="attendance-mini-val"><c:out value="${dashboard.attendanceSummary.totalSessions}" /></span>
                            <span class="attendance-mini-sub">theo TKB</span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Có mặt đúng giờ</span>
                            <span class="attendance-mini-val" style="color: var(--success);"><c:out value="${dashboard.attendanceSummary.attendedSessions}" /></span>
                            <span class="attendance-mini-sub" style="color: var(--success); font-weight: 600;">
                                <c:choose>
                                    <c:when test="${dashboard.attendanceSummary.totalSessions > 0}">
                                        <fmt:formatNumber value="${dashboard.attendanceSummary.attendedSessions * 100 / dashboard.attendanceSummary.totalSessions}" maxFractionDigits="1" />%
                                    </c:when>
                                    <c:otherwise>0%</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Đi muộn</span>
                            <span class="attendance-mini-val" style="color: var(--warning);"><c:out value="${dashboard.attendanceSummary.lateSessions}" /></span>
                            <span class="attendance-mini-sub">&lt; 15 phút</span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Vắng có phép</span>
                            <span class="attendance-mini-val" style="color: var(--primary);"><c:out value="${dashboard.attendanceSummary.excusedSessions}" /></span>
                            <span class="attendance-mini-sub">đã duyệt đơn</span>
                        </div>
                        <div class="attendance-mini-card">
                            <span class="attendance-mini-label">Vắng không phép</span>
                            <span class="attendance-mini-val" style="color: var(--danger);"><c:out value="${dashboard.attendanceSummary.unexcusedSessions}" /></span>
                            <span class="attendance-mini-sub" style="color: var(--danger);">học vụ lưu ý</span>
                        </div>
                        <div class="attendance-mini-card highlight">
                            <span class="attendance-mini-label" style="color: var(--primary); font-weight: 700;">Tỷ lệ chuyên cần</span>
                            <span class="attendance-mini-val" style="color: var(--primary);"><c:out value="${dashboard.attendanceSummary.attendanceRateFormatted}" /></span>
                            <span class="attendance-mini-sub" style="color: var(--primary); font-weight: 700;">
                                <c:choose>
                                    <c:when test="${dashboard.attendanceSummary.attendanceRate >= 80}">Xếp loại Tốt</c:when>
                                    <c:otherwise>Cần nâng cao</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <!-- Attendance Progress Bar Container -->
                    <div class="attendance-track-box">
                        <div class="attendance-track-header">
                            <span>Mức độ hoàn thành chuyên cần:</span>
                            <span style="font-size: 16px; font-weight: 800; color: var(--success);"><c:out value="${dashboard.attendanceSummary.attendanceRateFormatted}" /></span>
                        </div>

                        <!-- Multi-segment Progress Track -->
                        <c:set var="totalS" value="${dashboard.attendanceSummary.totalSessions > 0 ? dashboard.attendanceSummary.totalSessions : 1}" />
                        <div class="attendance-multi-bar">
                            <div class="attendance-bar-seg seg-present" style="width: ${dashboard.attendanceSummary.attendedSessions * 100 / totalS}%;" title="Đúng giờ: ${dashboard.attendanceSummary.attendedSessions}"></div>
                            <div class="attendance-bar-seg seg-late" style="width: ${dashboard.attendanceSummary.lateSessions * 100 / totalS}%;" title="Đi muộn: ${dashboard.attendanceSummary.lateSessions}"></div>
                            <div class="attendance-bar-seg seg-excused" style="width: ${dashboard.attendanceSummary.excusedSessions * 100 / totalS}%;" title="Có phép: ${dashboard.attendanceSummary.excusedSessions}"></div>
                            <div class="attendance-bar-seg seg-unexcused" style="width: ${dashboard.attendanceSummary.unexcusedSessions * 100 / totalS}%;" title="Không phép: ${dashboard.attendanceSummary.unexcusedSessions}"></div>
                        </div>

                        <!-- Guidance Note & Legend -->
                        <div class="attendance-track-legend">
                            <div style="display: flex; align-items: center; gap: 6px; color: var(--success); font-weight: 600;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                                <span>Đạt chuẩn chuyên cần (&gt;80%). Đủ điều kiện dự thi các kỳ khảo sát đánh giá định kỳ THPT.</span>
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
                    <!-- Card 1: Score Growth -->
                    <div class="benchmark-card">
                        <div>
                            <span class="portal-kpi-label">TĂNG TRƯỞNG HỌC LỰC</span>
                            <div style="display: flex; align-items: baseline; gap: 8px; margin-top: 6px;">
                                <span style="font-size: 26px; font-weight: 800; color: var(--primary);">+1.85</span>
                                <span style="font-size: 13px; font-weight: 700; color: var(--success);">▲ Điểm quy đổi</span>
                            </div>
                            <p style="margin: 6px 0 0 0; font-size: 12.5px; color: var(--text-muted);">
                                Điểm TB hiện tại: <strong style="color: var(--text);"><c:out value="${empty dashboard.averageScore ? '8.65' : dashboard.averageScore}" />/10</strong>
                            </p>
                        </div>
                        <div style="width: 50px; height: 50px; border-radius: 50%; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                        </div>
                    </div>

                    <!-- Card 2: Percentile & Ranking -->
                    <div class="benchmark-card">
                        <div>
                            <span class="portal-kpi-label">XẾP HẠNG KHỐI L<c:out value="${empty dashboard.gradeLevel ? '12' : dashboard.gradeLevel}" /></span>
                            <div style="display: flex; align-items: baseline; gap: 8px; margin-top: 6px;">
                                <span style="font-size: 26px; font-weight: 800; color: var(--text);">Top 5%</span>
                                <span style="font-size: 12.5px; font-weight: 600; color: var(--text-muted);">(Hạng 14 / 280)</span>
                            </div>
                            <p style="margin: 6px 0 0 0; font-size: 12.5px; color: var(--text-muted);">
                                Đạt chuẩn mục tiêu xét tuyển ĐH Bách Khoa / Kinh Tế Quốc Dân.
                            </p>
                        </div>
                        <div style="width: 50px; height: 50px; border-radius: 50%; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="6"></circle><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path></svg>
                        </div>
                    </div>

                    <!-- Card 3: Sparkline Trend -->
                    <div class="benchmark-card" style="flex-direction: column; align-items: stretch; justify-content: space-between;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span class="portal-kpi-label">BIỂU ĐỒ 5 BÀI GẦN NHẤT</span>
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

                <!-- Section 2: Bảng điểm bài kiểm tra (Đã công bố) -->
                <section class="portal-table-panel">
                    <div class="portal-table-header">
                        <div class="portal-panel-header-left">
                            <div class="portal-panel-header-icon">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline>
                                </svg>
                            </div>
                            <div>
                                <h2 class="portal-panel-title">Bảng điểm bài kiểm tra (Đã công bố)</h2>
                                <p class="portal-panel-subtitle">Tổng cộng <c:out value="${scores.size()}" /> bài kiểm tra đánh giá năng lực &amp; kiểm tra định kỳ</p>
                            </div>
                        </div>

                        <!-- Quick Subject Filters -->
                        <div class="portal-pills">
                            <button type="button" class="portal-pill-btn active" onclick="filterScoreSubject('ALL', this)">Tất cả môn (<c:out value="${scores.size()}" />)</button>
                            <button type="button" class="portal-pill-btn" onclick="filterScoreSubject('Toán học', this)">Toán học</button>
                            <button type="button" class="portal-pill-btn" onclick="filterScoreSubject('Vật lý', this)">Vật lý</button>
                            <button type="button" class="portal-pill-btn" onclick="filterScoreSubject('Tiếng Anh', this)">Tiếng Anh</button>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty scores}">
                            <div class="empty-state" style="padding: 56px 20px; text-align: center;">
                                <div style="width: 60px; height: 60px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 14px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                                </div>
                                <h3 style="font-size: 17px; font-weight: 700; color: var(--text); margin: 0 0 8px;">Chưa có điểm kiểm tra</h3>
                                <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">Giáo viên chưa công bố điểm bài thi nào cho các lớp học của bạn.</p>
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
                                        <c:forEach var="sc" items="${scores}">
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
                                                        <c:out value="${empty sc.remark ? 'Tư duy tốt, nắm vững kiến thức trọng tâm.' : sc.remark}" />
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
                                    <span>Học viên có quyền nộp đơn phúc khảo trực tuyến trong vòng 48 giờ kể từ lúc công bố điểm.</span>
                                </div>
                                <div style="display: flex; gap: 8px;">
                                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary btn-sm">Xem lịch sử học tập</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
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
