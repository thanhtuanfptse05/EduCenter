<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher-ops.css?v=20261024_01">
    <style>
        .modal-reopen {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(2px);
        }
        .modal-reopen.is-active {
            display: flex;
        }
        .modal-reopen-card {
            background: var(--surface);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 480px;
            padding: 24px;
            box-shadow: var(--shadow-lg);
            border: 1px solid var(--border);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="assessments" scope="request" />
    <c:set var="breadcrumb" value="Giảng dạy / Bảng điểm bài kiểm tra" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="ops-wrap">
                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- 1. Top Navigation & Header Meta Block -->
                <div class="ops-top-bar">
                    <div class="ops-top-left">
                        <a href="${pageContext.request.contextPath}/teacher/assessments" class="ops-back-btn">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                            <span>Danh sách bài kiểm tra</span>
                        </a>
                        <span class="ops-code-pill"><c:out value="${gradeView.classCode}" /></span>
                    </div>

                    <div style="display: flex; align-items: center; gap: 8px;">
                        <c:choose>
                            <c:when test="${gradeView.status == 'PUBLISHED'}">
                                <span class="badge" style="background: #DCFCE7; color: #15803D; font-weight: 700; padding: 6px 14px; font-size: 13px;">
                                    ĐÃ CÔNG BỐ (PUBLISHED)
                                </span>
                                <c:if test="${sessionScope.currentUser.admin}">
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="openReopenModal();" style="display: inline-flex; align-items: center; gap: 4px; color: var(--warning);">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 20h9"></path><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path></svg>
                                        <span>Chuyển về Bản nháp (DRAFT)</span>
                                    </button>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <span class="badge" style="background: #FEF9C3; color: #854D0E; font-weight: 700; padding: 6px 14px; font-size: 13px;">
                                    BẢN NHÁP (DRAFT)
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 2. Screen Title & Session Header Card -->
                <div class="ops-hero-card">
                    <div class="ops-hero-main">
                        <div class="ops-hero-title-row">
                            <h1 class="ops-hero-title">Bảng Điểm &amp; Đánh Giá: <c:out value="${gradeView.title}" /></h1>
                        </div>
                        <div class="ops-meta-chips" style="margin-top: 4px;">
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path></svg>
                                <span>Mã lớp: <strong><c:out value="${gradeView.className}" /> (<c:out value="${gradeView.classCode}" />)</strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                                <span>Môn học: <strong><c:out value="${gradeView.subjectName}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                <span>Giảng viên: <strong><c:out value="${sessionScope.currentUser.fullName}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>Ngày kiểm tra: <strong><c:out value="${gradeView.testDate}" /></strong></span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 3. KPI / Stats Summary Cards (3 Cards) -->
                <div class="ops-metrics-grid cols-3">
                    <!-- Card 1: Thang điểm & Trọng số -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-primary">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><line x1="2" y1="12" x2="22" y2="12"></line><line x1="6" y1="8" x2="6" y2="12"></line><line x1="10" y1="6" x2="10" y2="12"></line><line x1="14" y1="8" x2="14" y2="12"></line><line x1="18" y1="6" x2="18" y2="12"></line></svg>
                        </div>
                        <div class="ops-metric-body" style="width: 100%;">
                            <span class="ops-metric-label">Thang Điểm &amp; Trọng Số</span>
                            <div style="display: flex; align-items: baseline; gap: 4px; margin-top: 2px;">
                                <span class="ops-metric-val"><c:out value="${gradeView.maxScore}" /></span>
                                <span style="font-size: 12px; color: var(--text-muted);">điểm tối đa</span>
                            </div>
                            <span style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                Hệ số điểm: <strong style="color: var(--text);">${gradeView.weight}</strong>
                            </span>
                        </div>
                    </div>

                    <!-- Card 2: Tiến độ chấm điểm -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-success">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                        </div>
                        <div class="ops-metric-body" style="width: 100%;">
                            <span class="ops-metric-label">Tiến Độ Chấm Điểm</span>
                            <div style="display: flex; align-items: baseline; gap: 4px; margin-top: 2px;">
                                <span class="ops-metric-val text-primary" id="stat-completed-count">${gradeView.gradedCount}</span>
                                <span style="font-size: 13px; color: var(--text-muted);">/ ${gradeView.totalStudents} học sinh</span>
                            </div>
                            <div style="width: 100%; height: 6px; background: var(--surface-muted); border-radius: var(--radius-full); overflow: hidden; margin-top: 6px;">
                                <div id="stat-progress-bar" style="height: 100%; background: var(--primary); border-radius: var(--radius-full); width: ${gradeView.totalStudents > 0 ? (gradeView.gradedCount * 100 / gradeView.totalStudents) : 0}%; transition: width 0.3s ease;"></div>
                            </div>
                            <div style="display: flex; justify-content: space-between; font-size: 11px; color: var(--text-muted); margin-top: 3px;">
                                <span>Tỷ lệ hoàn thành</span>
                                <strong id="stat-progress-percent" style="color: var(--text);">${gradeView.totalStudents > 0 ? (gradeView.gradedCount * 100 / gradeView.totalStudents) : 0}%</strong>
                            </div>
                        </div>
                    </div>

                    <!-- Card 3: Điểm trung bình cả lớp -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-warning">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                        </div>
                        <div class="ops-metric-body" style="width: 100%;">
                            <span class="ops-metric-label">Điểm Trung Bình Dự Kiến</span>
                            <div style="display: flex; align-items: baseline; gap: 4px; margin-top: 2px;">
                                <span class="ops-metric-val text-warning" id="stat-avg-score">
                                    <c:choose>
                                        <c:when test="${not empty gradeView.averageScore}">
                                            <fmt:formatNumber value="${gradeView.averageScore}" minFractionDigits="1" maxFractionDigits="2"/>
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </span>
                                <span style="font-size: 12px; color: var(--text-muted);">/ <c:out value="${gradeView.maxScore}" /></span>
                            </div>
                            <span style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;" id="stat-score-summary">
                                <c:choose>
                                    <c:when test="${gradeView.gradedCount > 0}">Đã nhập điểm cho ${gradeView.gradedCount} học sinh</c:when>
                                    <c:otherwise>Chưa ghi nhận điểm số học viên</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 4. Operational Action Toolbar -->
                <div class="ops-toolbar">
                    <div class="ops-search-box">
                        <svg class="icon icon-xs ops-search-icon" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <input type="text" id="filter-input" class="ops-search-input" placeholder="Tìm theo tên học sinh, mã HV hoặc số điện thoại..." onkeyup="filterGradingTable()">
                    </div>

                    <div class="ops-toolbar-actions">
                        <button type="button" class="btn btn-secondary btn-sm" id="btn-batch-fill" onclick="batchFillDefaultRemarks()" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M12 20h9"></path><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path></svg>
                            <span>Điền nhanh nhận xét mặc định</span>
                        </button>
                    </div>
                </div>

                <!-- 5. Main Grading Form & Table -->
                <form action="${pageContext.request.contextPath}/teacher/scores/save" method="post" id="gradingForm">
                    <input type="hidden" name="assessmentId" value="${gradeView.assessmentId}">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="action" id="formActionInput" value="DRAFT">

                    <div class="ops-table-card">
                        <c:choose>
                            <c:when test="${not empty gradeView.students}">
                                <div class="table-responsive">
                                    <table class="ops-table" id="gradingTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 52px; text-align: center;">STT</th>
                                                <th style="width: 110px;">Mã HV</th>
                                                <th style="min-width: 240px;">Học Viên &amp; Liên Hệ</th>
                                                <th style="width: 140px; text-align: center;">Điểm Số (0 - ${gradeView.maxScore})</th>
                                                <th style="width: 130px; text-align: center;">Xếp Loại</th>
                                                <th style="min-width: 320px;">Lời Phê &amp; Đánh Giá Năng Lực Giáo Viên</th>
                                            </tr>
                                        </thead>
                                        <tbody id="gradingTableBody">
                                            <c:forEach var="st" items="${gradeView.students}" varStatus="loop">
                                                <tr class="grading-row" data-id="${st.studentId}" data-code="<c:out value='${st.studentCode}' />" data-name="<c:out value='${st.studentName}' />" data-phone="<c:out value='${st.studentPhone}' />">
                                                    <td style="text-align: center; color: var(--text-muted); font-weight: 500;">${loop.count}</td>
                                                    <td>
                                                        <span class="ops-code-pill" style="color: var(--primary);"><c:out value="${st.studentCode}" /></span>
                                                    </td>
                                                    <td>
                                                        <div style="display: flex; align-items: center; gap: 10px;">
                                                            <div class="ops-avatar-initials">
                                                                ${st.studentName.substring(0, 1)}
                                                            </div>
                                                            <div style="display: flex; flex-direction: column;">
                                                                <span style="font-weight: 600; color: var(--text);"><c:out value="${st.studentName}" /></span>
                                                                <span style="font-size: 11.5px; color: var(--text-muted); font-family: monospace;">
                                                                    <c:out value="${not empty st.studentPhone ? st.studentPhone : '--'}" />
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <input type="number" name="score_${st.studentId}" class="ops-score-input score-input"
                                                               min="0" max="${gradeView.maxScore}" step="0.25"
                                                               placeholder="-"
                                                               value="${st.score}"
                                                               oninput="onScoreInputChange(this, ${gradeView.maxScore})">
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <span class="ops-rank-badge rank-none rank-badge">Chưa nhập</span>
                                                    </td>
                                                    <td>
                                                        <div style="display: flex; flex-direction: column; gap: 6px;">
                                                            <input type="text" name="remarks_${st.studentId}" class="form-control form-control-sm comment-input"
                                                                   placeholder="Nhận xét bài làm, lỗi sai kiến thức, thái độ..."
                                                                   value="<c:out value='${st.remarks}' />">
                                                            <div class="ops-quick-tags" style="margin-top: 0;">
                                                                <button type="button" class="ops-quick-tag" onclick="appendRowTag(this, 'Nắm chắc lý thuyết và đồ thị')">Nắm chắc lý thuyết</button>
                                                                <button type="button" class="ops-quick-tag" onclick="appendRowTag(this, 'Cần cẩn thận điều kiện nghiệm')">Cần cẩn thận điều kiện</button>
                                                                <button type="button" class="ops-quick-tag" onclick="appendRowTag(this, 'Tốt, tốc độ làm bài nhanh')">Tốt, tốc độ nhanh</button>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Empty Search State -->
                                <div id="noGradingMatch" class="empty-state" style="display: none; padding: 48px 20px; text-align: center;">
                                    <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted); margin-bottom: 8px;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                    <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0 0 4px;">Không tìm thấy học sinh phù hợp</h3>
                                    <p style="margin: 0; font-size: 13px; color: var(--text-muted);">Vui lòng thử lại với tên khác hoặc xoá bộ lọc tìm kiếm.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 56px 20px; text-align: center;">
                                    <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 6px;">Lớp học chưa có học viên chính thức</h3>
                                    <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">Lớp học này hiện tại chưa có học viên nào được xếp lớp để nhập điểm.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 6. Information Callout Box -->
                    <div class="ops-callout" style="margin-top: 20px;">
                        <svg class="icon icon-sm ops-callout-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        <div>
                            <div class="ops-callout-title">Chính sách bảo mật &amp; Thông báo điểm (BR11):</div>
                            Học sinh và phụ huynh sẽ nhận được bảng phân tích chi tiết ngay sau khi giảng viên bấm <strong>"Công bố điểm"</strong>. Mọi thao tác lưu bản nháp sẽ không gửi thông báo qua Zalo ZNS hoặc SMS.
                        </div>
                    </div>

                    <!-- 7. Fixed Bottom Operational Sticky Action Bar -->
                    <div class="ops-sticky-bar">
                        <div class="ops-sticky-left">
                            <span class="legend-dot" style="background: var(--warning);"></span>
                            <span id="save-status-msg">Tất cả thay đổi chưa được lưu vào hệ thống</span>
                        </div>

                        <div class="ops-sticky-right">
                            <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-secondary btn-sm">
                                Hủy bỏ
                            </a>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="submitScores('DRAFT');" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                                <span>Lưu nháp (DRAFT)</span>
                            </button>
                            <button type="button" class="btn btn-primary btn-sm" onclick="submitScores('PUBLISH');" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>${gradeView.status == 'PUBLISHED' ? 'Cập nhật & Công bố điểm' : 'Công bố điểm cho Học viên & Phụ huynh (PUBLISH)'}</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<!-- Modal Reopen bài kiểm tra (Admin Correction - BR18) -->
<div class="modal-reopen" id="reopenModal">
    <div class="modal-reopen-card">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 10px;">
            <h3 style="font-size: 16px; font-weight: 700; margin: 0; color: var(--warning);">Mở lại bài kiểm tra (Admin Correction - BR18)</h3>
            <button type="button" onclick="closeReopenModal();" style="background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-muted);">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/teacher/scores/reopen" method="post">
            <input type="hidden" name="assessmentId" value="${gradeView.assessmentId}">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label" style="font-weight: 600; font-size: 13px;">Lý do mở lại bài kiểm tra <span style="color: var(--danger);">*</span></label>
                <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do đính chính / phúc khảo điểm số..." required></textarea>
                <small style="color: var(--text-muted); font-size: 12px; margin-top: 4px; display: block;">Hành động này sẽ tạm thời chuyển trạng thái về DRAFT và ẩn điểm số trên Portal cho đến khi được giáo viên công bố lại.</small>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" class="btn btn-secondary btn-sm" onclick="closeReopenModal();">Hủy</button>
                <button type="submit" class="btn btn-primary btn-sm" style="background: var(--warning); border-color: var(--warning);">Xác nhận mở lại</button>
            </div>
        </form>
    </div>
</div>

<script>
    function updateClassStats(maxScore) {
        const rows = document.querySelectorAll('.grading-row');
        let completedCount = 0;
        let sumScore = 0;

        rows.forEach(row => {
            const input = row.querySelector('.score-input');
            const badge = row.querySelector('.rank-badge');
            const val = parseFloat(input.value);

            if (!isNaN(val) && input.value.trim() !== '') {
                completedCount++;
                sumScore += val;

                // Academic Rank calculation
                if (val >= 8.5) {
                    badge.className = 'ops-rank-badge rank-gioi rank-badge';
                    badge.textContent = 'Giỏi (' + val.toFixed(1) + ')';
                } else if (val >= 7.0) {
                    badge.className = 'ops-rank-badge rank-kha rank-badge';
                    badge.textContent = 'Khá (' + val.toFixed(1) + ')';
                } else if (val >= 5.0) {
                    badge.className = 'ops-rank-badge rank-tb rank-badge';
                    badge.textContent = 'Trung Bình (' + val.toFixed(1) + ')';
                } else {
                    badge.className = 'ops-rank-badge rank-yeu rank-badge';
                    badge.textContent = 'Yếu (' + val.toFixed(1) + ')';
                }
            } else {
                badge.className = 'ops-rank-badge rank-none rank-badge';
                badge.textContent = 'Chưa nhập';
            }
        });

        const totalStudents = rows.length;
        const percent = totalStudents > 0 ? Math.round((completedCount / totalStudents) * 100) : 0;

        const elCompleted = document.getElementById('stat-completed-count');
        const elProgress = document.getElementById('stat-progress-bar');
        const elPercent = document.getElementById('stat-progress-percent');
        const elAvg = document.getElementById('stat-avg-score');
        const elSummary = document.getElementById('stat-score-summary');

        if (elCompleted) elCompleted.textContent = completedCount;
        if (elProgress) elProgress.style.width = percent + '%';
        if (elPercent) elPercent.textContent = percent + '%';

        if (completedCount > 0) {
            const avg = (sumScore / completedCount).toFixed(2);
            if (elAvg) elAvg.textContent = avg;
            if (elSummary) elSummary.textContent = 'Điểm trung bình của ' + completedCount + ' học sinh đã nhập';
        } else {
            if (elAvg) elAvg.textContent = '--';
            if (elSummary) elSummary.textContent = 'Chưa ghi nhận điểm số học viên';
        }

        const msg = document.getElementById('save-status-msg');
        if (msg) msg.textContent = 'Có thay đổi chưa lưu...';
    }

    function onScoreInputChange(input, maxScore) {
        let val = parseFloat(input.value);
        if (val > maxScore) input.value = maxScore;
        if (val < 0) input.value = 0;
        updateClassStats(maxScore);
    }

    function appendRowTag(btn, tagText) {
        const row = btn.closest('.grading-row');
        if (!row) return;
        const commentInput = row.querySelector('.comment-input');
        if (!commentInput) return;
        const current = commentInput.value.trim();
        if (!current) {
            commentInput.value = tagText;
        } else {
            commentInput.value = current + '; ' + tagText;
        }
        commentInput.focus();
        const msg = document.getElementById('save-status-msg');
        if (msg) msg.textContent = 'Có thay đổi chưa lưu...';
    }

    function batchFillDefaultRemarks() {
        const rows = document.querySelectorAll('.grading-row');
        rows.forEach(row => {
            const commentInput = row.querySelector('.comment-input');
            if (commentInput && commentInput.value.trim() === '') {
                commentInput.value = 'Nắm vững kiến thức trọng tâm';
            }
        });
        const msg = document.getElementById('save-status-msg');
        if (msg) msg.textContent = 'Đã điền nhận xét mặc định';
    }

    function filterGradingTable() {
        const query = (document.getElementById('filter-input').value || '').toLowerCase().trim();
        const rows = document.querySelectorAll('.grading-row');
        let matched = 0;

        rows.forEach(row => {
            const code = (row.getAttribute('data-code') || '').toLowerCase();
            const name = (row.getAttribute('data-name') || '').toLowerCase();
            const phone = (row.getAttribute('data-phone') || '').toLowerCase();

            if (!query || code.includes(query) || name.includes(query) || phone.includes(query)) {
                row.style.display = '';
                matched++;
            } else {
                row.style.display = 'none';
            }
        });

        const noMatch = document.getElementById('noGradingMatch');
        if (noMatch) {
            noMatch.style.display = (matched === 0 && rows.length > 0) ? 'block' : 'none';
        }
    }

    function submitScores(action) {
        document.getElementById('formActionInput').value = action;
        const maxScore = ${gradeView.maxScore != null ? gradeView.maxScore : 10};

        const inputs = document.querySelectorAll('.score-input');
        let hasScore = false;
        for (let i = 0; i < inputs.length; i++) {
            const val = inputs[i].value;
            if (val !== '') {
                const num = parseFloat(val);
                if (num < 0 || num > maxScore) {
                    alert('Điểm số không hợp lệ: ' + val + '. Điểm phải từ 0 đến ' + maxScore + '!');
                    inputs[i].focus();
                    return false;
                }
                hasScore = true;
            }
        }

        if (action === 'PUBLISH') {
            if (!hasScore) {
                alert('Không thể công bố bài kiểm tra khi chưa nhập điểm cho bất kỳ học sinh nào (BR11)!');
                return false;
            }
            if (!confirm('XÁC NHẬN CÔNG BỐ ĐIỂM:\n\nSau khi công bố (PUBLISHED), toàn bộ học sinh và phụ huynh sẽ xem được kết quả kiểm tra trên Portal.\n\nBạn có chắc chắn muốn công bố bảng điểm này?')) {
                return false;
            }
        }

        document.getElementById('gradingForm').submit();
    }

    function openReopenModal() {
        document.getElementById('reopenModal').classList.add('is-active');
    }

    function closeReopenModal() {
        document.getElementById('reopenModal').classList.remove('is-active');
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateClassStats(${gradeView.maxScore != null ? gradeView.maxScore : 10});
    });
</script>
</body>
</html>
