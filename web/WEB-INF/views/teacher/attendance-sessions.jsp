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
    <c:set var="activeNav" value="attendance" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Điểm danh & Sổ đầu bài" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Dynamic Statistics Calculation -->
                <c:set var="totalCount" value="${not empty sessions ? sessions.size() : 0}"/>
                <c:set var="completedCount" value="0"/>
                <c:set var="pendingCount" value="0"/>
                <c:forEach var="item" items="${sessions}">
                    <c:choose>
                        <c:when test="${item.sessionStatus == 'COMPLETED'}">
                            <c:set var="completedCount" value="${completedCount + 1}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="pendingCount" value="${pendingCount + 1}"/>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <!-- 1. Top Navigation & Header Meta Block -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <div class="mgmt-breadcrumb">
                            <span class="mgmt-badge-version">M07: TCH-03 &amp; TCH-04</span>
                            <span>•</span>
                            <span>Giảng dạy &amp; Đào tạo</span>
                        </div>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Điểm danh &amp; Sổ đầu bài giảng dạy</h1>
                        </div>
                        <p class="mgmt-subtitle">
                            Chọn ca học để tiến hành kiểm diện học viên và ghi nhận nhật ký buổi học trực tiếp vào hệ thống học vụ.
                        </p>
                    </div>

                    <!-- Quick Stats Metric Pills -->
                    <div class="mgmt-pill-deck">
                        <div class="mgmt-stat-pill pill-primary">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                <line x1="16" y1="2" x2="16" y2="6"></line>
                                <line x1="8" y1="2" x2="8" y2="6"></line>
                                <line x1="3" y1="10" x2="21" y2="10"></line>
                            </svg>
                            <span>Tổng ca học: <strong style="color: var(--primary);"><c:out value="${totalCount}"/></strong> ca</span>
                        </div>
                        <div class="mgmt-stat-pill pill-warning">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            <span>Chưa điểm danh: <strong style="color: #b45309;"><c:out value="${pendingCount}"/></strong> ca</span>
                        </div>
                        <div class="mgmt-stat-pill pill-success">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                            <span>Đã hoàn tất &amp; Ghi sổ: <strong style="color: #047857;"><c:out value="${completedCount}"/></strong> ca</span>
                        </div>
                    </div>
                </div>

                <!-- 2. Advanced Filter Control Deck -->
                <div class="mgmt-filter-card">
                    <form action="${pageContext.request.contextPath}/teacher/attendance" method="get" class="mgmt-filter-grid">
                        <!-- Date Picker -->
                        <div class="mgmt-filter-field" style="flex: 1; min-width: 200px;">
                            <label for="filter-date">Lọc theo ngày giảng dạy</label>
                            <div class="mgmt-input-wrap">
                                <span class="mgmt-input-icon">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </span>
                                <input type="date" id="filter-date" name="date" value="<c:out value='${filterDate}'/>" placeholder="yyyy-mm-dd">
                            </div>
                        </div>

                        <!-- Class filter (Client-side interactive filter) -->
                        <div class="mgmt-filter-field" style="flex: 1.2; min-width: 220px;">
                            <label for="filter-class">Lớp học &amp; Chuyên đề</label>
                            <select id="filter-class" class="mgmt-select" onchange="applyTableFilter();">
                                <option value="all">-- Tất cả lớp giảng dạy --</option>
                                <c:set var="seenClasses" value="" />
                                <c:forEach var="s" items="${sessions}">
                                    <c:if test="${not seenClasses.contains(s.classCode)}">
                                        <option value="${s.classCode}"><c:out value="${s.classCode}"/> - <c:out value="${s.className}"/></option>
                                        <c:set var="seenClasses" value="${seenClasses},${s.classCode}" />
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Status filter -->
                        <div class="mgmt-filter-field" style="flex: 1; min-width: 180px;">
                            <label for="filter-status">Trạng thái kiểm diện</label>
                            <select id="filter-status" class="mgmt-select" onchange="applyTableFilter();">
                                <option value="all">-- Tất cả trạng thái --</option>
                                <option value="PENDING">Chưa điểm danh (${pendingCount})</option>
                                <option value="COMPLETED">Đã hoàn tất (${completedCount})</option>
                                <option value="IN_PROGRESS">Đang diễn ra</option>
                            </select>
                        </div>

                        <!-- Action Buttons -->
                        <div class="mgmt-filter-field" style="display: flex; flex-direction: row; align-items: flex-end; gap: 8px;">
                            <button type="submit" class="btn btn-primary" style="height: 38px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <span>Xem ca dạy</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary" style="height: 38px; display: inline-flex; align-items: center; justify-content: center;" title="Đặt lại bộ lọc ngày">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"></path>
                                </svg>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- 3. Data Table Panel Container -->
                <div class="mgmt-table-card">
                    <!-- Quick Table Context Info -->
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-title-group">
                            <span class="mgmt-pulse-dot" style="background: var(--primary);"></span>
                            <span class="mgmt-table-title">Danh mục thời khóa biểu &amp; Nhật ký giảng dạy</span>
                            <span class="mgmt-table-count-badge">Giáo viên: <c:out value="${sessionScope.currentUser.fullName}"/></span>
                        </div>
                        <div class="mgmt-table-actions-right">
                            <svg class="icon icon-sm" style="color: #047857;" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="16" x2="12" y2="12"></line>
                                <line x1="12" y1="8" x2="12.01" y2="8"></line>
                            </svg>
                            <span>Hệ thống tự động khóa sổ sau 24h kể từ khi ca học kết thúc</span>
                        </div>
                    </div>

                    <!-- Responsive Table -->
                    <c:choose>
                        <c:when test="${not empty sessions}">
                            <div class="mgmt-table-responsive">
                                <table class="mgmt-table" id="sessions-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 48px; text-align: center;">#</th>
                                            <th style="min-width: 240px;">Lớp học &amp; Môn học</th>
                                            <th style="min-width: 160px;">Thời gian ca học</th>
                                            <th style="min-width: 180px;">Phòng học &amp; Thiết bị</th>
                                            <th style="min-width: 190px;">Sĩ số &amp; Chuyên cần</th>
                                            <th style="min-width: 130px; text-align: center;">Trạng thái</th>
                                            <th style="min-width: 110px; text-align: center;">Sổ đầu bài</th>
                                            <th style="text-align: right; min-width: 170px;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="s" items="${sessions}" varStatus="loop">
                                            <tr class="session-row" data-class="${s.classCode}" data-status="${s.sessionStatus}">
                                                <td style="text-align: center; color: var(--text-muted); font-weight: 700;">
                                                    <fmt:formatNumber value="${loop.count}" minIntegerDigits="2"/>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 700; color: var(--text); font-size: 14px;">
                                                        <c:out value="${s.className}"/>
                                                    </div>
                                                    <div style="display: flex; align-items: center; gap: 6px; margin-top: 3px; font-size: 12px; color: var(--text-muted);">
                                                        <span class="mgmt-code-pill" style="font-weight: 700; color: var(--primary);">
                                                            <c:out value="${s.classCode}"/>
                                                        </span>
                                                        <span>•</span>
                                                        <span><c:out value="${empty s.subjectName ? 'Toán học' : s.subjectName}"/></span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 800; font-size: 13.5px; color: var(--primary);">
                                                        <c:out value="${s.startTime}"/> – <c:out value="${s.endTime}"/>
                                                    </div>
                                                    <div style="display: flex; align-items: center; gap: 4px; font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                        <svg class="icon icon-sm" style="width: 12px; height: 12px;" viewBox="0 0 24 24" aria-hidden="true">
                                                            <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                                        </svg>
                                                        <span><c:out value="${s.sessionDate}"/></span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);">
                                                        <c:out value="${empty s.roomName ? 'Chưa xếp phòng' : s.roomName}"/>
                                                    </div>
                                                    <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 2px;">
                                                        Cơ sở chính • Máy chiếu, Điều hòa
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-size: 12px; font-weight: 600; margin-bottom: 3px;">
                                                        Tổng: <strong style="color: var(--text);">${s.totalStudents} học sinh</strong>
                                                    </div>
                                                    <div class="att-badge-row">
                                                        <span class="att-badge present" title="Có mặt">Có: ${s.presentCount}</span>
                                                        <span class="att-badge late" title="Đi muộn">Muộn: ${s.lateCount}</span>
                                                        <span class="att-badge absent" title="Vắng mặt">Vắng: ${s.excusedCount + s.unexcusedCount}</span>
                                                    </div>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${s.sessionStatus == 'COMPLETED'}">
                                                            <span class="mgmt-badge badge-active">
                                                                <svg class="icon icon-sm" style="width: 12px; height: 12px;" viewBox="0 0 24 24" aria-hidden="true">
                                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                                </svg>
                                                                Đã hoàn tất
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${s.sessionStatus == 'IN_PROGRESS'}">
                                                            <span class="mgmt-badge badge-status-opening">
                                                                Đang diễn ra
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${s.sessionStatus == 'CANCELLED'}">
                                                            <span class="mgmt-badge badge-status-closed">
                                                                Đã hủy ca
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${s.futureSession}">
                                                            <span class="mgmt-badge badge-status-draft" style="background: #F1F5F9; color: #64748B; border: 1px solid #CBD5E1;">
                                                                Chưa tới ngày
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="mgmt-badge badge-status-draft">
                                                                Chưa điểm danh
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${s.hasJournal}">
                                                            <span style="font-size: 12px; font-weight: 700; color: #047857; display: inline-flex; align-items: center; gap: 4px;">
                                                                <svg class="icon icon-sm" style="width: 14px; height: 14px;" viewBox="0 0 24 24" aria-hidden="true">
                                                                    <polyline points="20 6 9 17 4 12"></polyline>
                                                                </svg>
                                                                Đã ghi
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 12px; color: var(--text-muted); font-weight: 500;">
                                                                Chưa ghi
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <div style="display: inline-flex; align-items: center; justify-content: flex-end; gap: 6px;">
                                                        <c:choose>
                                                            <c:when test="${s.futureSession}">
                                                                <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${s.sessionId}" class="btn btn-secondary btn-sm" title="Ca học tương lai (${s.sessionDate}) — Chưa mở điểm danh" style="opacity: 0.85;">
                                                                    <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
                                                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                                                    </svg>
                                                                    <span>Chưa mở</span>
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${s.sessionId}" class="btn btn-primary btn-sm" title="Tiến hành điểm danh">
                                                                    <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
                                                                        <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                                        <circle cx="9" cy="7" r="4"></circle>
                                                                        <polyline points="16 11 18 13 22 9"></polyline>
                                                                    </svg>
                                                                    <span>${s.sessionStatus == 'COMPLETED' ? 'Xem lại' : 'Điểm danh'}</span>
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <a href="${pageContext.request.contextPath}/teacher/journal?sessionId=${s.sessionId}" class="btn btn-secondary btn-sm" title="Ghi sổ đầu bài &amp; Nhật ký dạy">
                                                            <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
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
                            <div class="mgmt-table-footer">
                                <div>Hiển thị <strong style="color: var(--text);"><c:out value="${totalCount}"/></strong> ca học trong danh sách</div>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <span style="font-size: 11.5px; color: var(--text-muted);">Dữ liệu thời gian thực từ CSDL</span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mgmt-empty-box">
                                <div class="mgmt-empty-icon">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                                <h3 class="mgmt-empty-title">Không tìm thấy ca dạy nào</h3>
                                <p class="mgmt-empty-desc">
                                    Không có ca dạy nào phù hợp với bộ lọc ngày hoặc phân công của Thầy/Cô. Vui lòng chọn ngày khác hoặc xóa bộ lọc để xem toàn bộ ca dạy.
                                </p>
                                <div class="mgmt-empty-actions">
                                    <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary btn-sm">Xem tất cả ca dạy</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 4. Module Guide / Teacher Protocol Card -->
                <div class="mgmt-protocol-box">
                    <div class="mgmt-protocol-left">
                        <div class="mgmt-protocol-icon">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M9 11l3 3L22 4"></path>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                            </svg>
                        </div>
                        <div>
                            <div class="mgmt-protocol-title-row">
                                <h4 class="mgmt-protocol-title">Quy chuẩn Điểm Danh (TCH-03) &amp; Ghi Sổ Đầu Bài (TCH-04)</h4>
                                <span class="mgmt-protocol-tag">SLA KHÓA SỔ 24H</span>
                            </div>
                            <p class="mgmt-protocol-desc">
                                Giáo viên phụ trách bắt buộc hoàn thành điểm danh trong 15 phút đầu giờ học. Nội dung bài giảng, nhận xét thái độ học tập và bài tập về nhà phải được ghi nhận vào Sổ đầu bài trước 23:59 cùng ngày.
                            </p>
                        </div>
                    </div>
                    <div style="flex-shrink: 0;">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="alert('Quy chuẩn đào tạo: 1. Kiểm diện đúng sĩ số.\n2. Báo cáo vắng không phép qua tin nhắn phụ huynh.\n3. Ghi rõ số trang giáo trình và bài tập về nhà.');">
                            Xem quy chế đào tạo
                        </button>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
function applyTableFilter() {
    const classVal = document.getElementById('filter-class').value;
    const statusVal = document.getElementById('filter-status').value;
    const rows = document.querySelectorAll('.session-row');

    rows.forEach(row => {
        const rowClass = row.getAttribute('data-class');
        const rowStatus = row.getAttribute('data-status');

        let matchClass = (classVal === 'all' || rowClass === classVal);
        let matchStatus = true;
        if (statusVal === 'PENDING') {
            matchStatus = (rowStatus !== 'COMPLETED');
        } else if (statusVal === 'COMPLETED') {
            matchStatus = (rowStatus === 'COMPLETED');
        } else if (statusVal === 'IN_PROGRESS') {
            matchStatus = (rowStatus === 'IN_PROGRESS');
        }

        if (matchClass && matchStatus) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>
</body>
</html>
