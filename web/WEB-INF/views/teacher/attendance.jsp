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
        @media print {
            .admin-sidebar, .admin-header, .ops-top-bar, .ops-toolbar, .ops-sticky-bar, .no-print {
                display: none !important;
            }
            .admin-main {
                margin: 0 !important;
                padding: 0 !important;
            }
            .admin-content {
                padding: 0 !important;
            }
            .ops-hero-card, .ops-table-card {
                box-shadow: none !important;
                border: 1px solid #000 !important;
            }
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="attendance" scope="request" />
    <c:set var="breadcrumb" value="Giảng dạy / Điểm danh ca học" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="ops-wrap">
                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- 1. Top Navigation & Quick Switcher -->
                <div class="ops-top-bar no-print">
                    <div class="ops-top-left">
                        <a href="${pageContext.request.contextPath}/teacher/attendance" class="ops-back-btn">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                            <span>Quay lại danh sách ca dạy</span>
                        </a>
                        <span class="ops-code-pill">CA-${sessionData.sessionId}</span>
                    </div>

                    <div class="ops-tabs">
                        <span class="ops-tab-item active">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                            <span>Điểm danh học sinh</span>
                        </span>
                        <a href="${pageContext.request.contextPath}/teacher/journal?sessionId=${sessionData.sessionId}" class="ops-tab-item">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                            <span>Sổ đầu bài &amp; Nhật ký</span>
                        </a>
                    </div>
                </div>

                <!-- 2. Screen Title & Session Header Card -->
                <div class="ops-hero-card">
                    <div class="ops-hero-main">
                        <div class="ops-hero-title-row">
                            <h1 class="ops-hero-title"><c:out value="${sessionData.className}" /></h1>
                            <span class="badge" style="background: var(--surface-muted); color: var(--primary); font-weight: 700;">
                                <c:out value="${sessionData.classCode}" />
                            </span>
                            <c:choose>
                                <c:when test="${sessionData.futureSession}">
                                    <span class="badge" style="background: #F1F5F9; color: #475569; font-weight: 700; display: inline-flex; align-items: center; gap: 5px;" id="sessionStatusBadge">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        <span>CHƯA TỚI NGÀY HỌC</span>
                                    </span>
                                </c:when>
                                <c:when test="${sessionData.sessionStatus == 'COMPLETED'}">
                                    <span class="badge" style="background: #DCFCE7; color: #15803D; font-weight: 700; display: inline-flex; align-items: center; gap: 5px;" id="sessionStatusBadge">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>ĐÃ HOÀN TẤT ĐIỂM DANH</span>
                                    </span>
                                </c:when>
                                <c:when test="${sessionData.sessionStatus == 'IN_PROGRESS'}">
                                    <span class="badge" style="background: #FEF9C3; color: #854D0E; font-weight: 700; display: inline-flex; align-items: center; gap: 5px;" id="sessionStatusBadge">
                                        <span class="pulse-indicator"></span>
                                        <span>ĐANG ĐIỂM DANH</span>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge" style="background: #EFF6FF; color: #1D4ED8; font-weight: 700; display: inline-flex; align-items: center; gap: 5px;" id="sessionStatusBadge">
                                        <span class="pulse-indicator"></span>
                                        <span>CHƯA ĐIỂM DANH</span>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="ops-meta-chips">
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path></svg>
                                <span>Môn: <strong><c:out value="${sessionData.subjectName}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>Ngày: <strong><c:out value="${sessionData.sessionDate}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                <span>Ca: <strong><c:out value="${sessionData.startTime}" /> - <c:out value="${sessionData.endTime}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                <span>Phòng: <strong><c:out value="${sessionData.roomName}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                <span>GV: <strong><c:out value="${sessionData.teacherName}" /></strong></span>
                            </span>
                        </div>
                    </div>

                    <div class="ops-hero-actions no-print">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="window.print()" title="In phiếu điểm danh ca học" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect width="12" height="8" x="6" y="14"></rect></svg>
                            <span>In phiếu điểm danh</span>
                        </button>
                    </div>
                </div>

                <!-- Future Session Warning Banner -->
                <c:if test="${sessionData.futureSession}">
                    <div class="alert alert-warning" style="display: flex; align-items: flex-start; gap: 12px; margin-bottom: 20px; border-radius: var(--radius-md); padding: 14px 18px; background: #FFFBEB; border: 1px solid #FDE68A; color: #92400E;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: #D97706; flex-shrink: 0; margin-top: 2px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        <div style="font-size: 13.5px; line-height: 1.5;">
                            <strong>Chưa đến ngày học:</strong> Buổi học này được xếp lịch vào ngày <strong><c:out value="${sessionData.sessionDate}" /></strong> (tương lai). Theo quy chuẩn học vụ, hệ thống chỉ mở điểm danh khi đến ngày diễn ra ca học. Các thao tác ghi nhận điểm danh tạm thời bị khóa.
                        </div>
                    </div>
                </c:if>

                <!-- 3. Live Stat Matrix Metrics Strip (6 Columns) -->
                <div class="ops-metrics-grid cols-6">
                    <!-- Sĩ số lớp -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-primary">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                        </div>
                        <div class="ops-metric-body">
                            <span class="ops-metric-label">Sĩ số lớp</span>
                            <span class="ops-metric-val" id="metric-total"><c:out value="${sessionData.totalStudents}" /></span>
                        </div>
                    </div>

                    <!-- Có mặt -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-success">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                        <div class="ops-metric-body">
                            <span class="ops-metric-label">Có mặt</span>
                            <span class="ops-metric-val text-success" id="metric-present"><c:out value="${sessionData.presentCount}" /></span>
                        </div>
                    </div>

                    <!-- Đi muộn -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-warning">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        </div>
                        <div class="ops-metric-body">
                            <span class="ops-metric-label">Đi muộn</span>
                            <span class="ops-metric-val text-warning" id="metric-late"><c:out value="${sessionData.lateCount}" /></span>
                        </div>
                    </div>

                    <!-- Có phép -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-primary">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                        </div>
                        <div class="ops-metric-body">
                            <span class="ops-metric-label">Có phép</span>
                            <span class="ops-metric-val text-primary" id="metric-excused"><c:out value="${sessionData.excusedCount}" /></span>
                        </div>
                    </div>

                    <!-- Không phép -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-danger">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                        </div>
                        <div class="ops-metric-body">
                            <span class="ops-metric-label">Không phép</span>
                            <span class="ops-metric-val text-danger" id="metric-unexcused"><c:out value="${sessionData.unexcusedCount}" /></span>
                        </div>
                    </div>

                    <!-- Chưa chọn -->
                    <div class="ops-metric-card">
                        <div class="ops-metric-icon icon-muted">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                        </div>
                        <div class="ops-metric-body">
                            <span class="ops-metric-label">Chưa chọn</span>
                            <span class="ops-metric-val" id="metric-unmarked"><c:out value="${sessionData.unrecordedCount}" /></span>
                        </div>
                    </div>
                </div>

                <!-- 4. Bulk Actions & Quick Filter Toolbar -->
                <div class="ops-toolbar no-print">
                    <div class="ops-toolbar-actions">
                        <c:choose>
                            <c:when test="${sessionData.futureSession}">
                                <span style="font-size: 13px; color: var(--text-muted); display: inline-flex; align-items: center; gap: 6px; font-weight: 500;">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                    Điểm danh chưa mở (Chưa đến ngày ca học)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="setAllAttendance('PRESENT')" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    <span>Đánh dấu tất cả CÓ MẶT</span>
                                </button>
                                <button type="button" class="btn btn-ghost btn-sm" onclick="resetAllAttendance()" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path><path d="M3 3v5h5"></path></svg>
                                    <span>Đặt lại lựa chọn</span>
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Client-side Fast Search -->
                    <div class="ops-search-box">
                        <svg class="icon icon-xs ops-search-icon" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        <input type="text" id="studentSearchInput" class="ops-search-input" placeholder="Tìm học sinh (Mã HV, Họ tên, SĐT)..." onkeyup="filterStudentsTable()">
                    </div>
                </div>

                <!-- 5. Main Attendance Table Form -->
                <form action="${pageContext.request.contextPath}/teacher/attendance/save" method="post" id="attendanceForm">
                    <input type="hidden" name="sessionId" value="${sessionData.sessionId}">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="completeAfterSave" id="completeAfterSave" value="false">

                    <div class="ops-table-card">
                        <c:choose>
                            <c:when test="${not empty sessionData.roster}">
                                <div class="table-responsive">
                                    <table class="ops-table" id="attendanceTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 52px; text-align: center;">STT</th>
                                                <th style="width: 110px;">Mã HV</th>
                                                <th style="min-width: 240px;">Học viên</th>
                                                <th style="width: 140px;">Điện thoại</th>
                                                <th style="min-width: 360px; text-align: center;">Trạng thái điểm danh</th>
                                                <th style="min-width: 260px;">Ghi chú / Nhận xét ca học</th>
                                            </tr>
                                        </thead>
                                        <tbody id="attendanceTableBody">
                                            <c:forEach var="item" items="${sessionData.roster}" varStatus="loop">
                                                <tr class="student-row" data-id="${item.studentId}" data-code="<c:out value='${item.studentCode}' />" data-name="<c:out value='${item.studentName}' />" data-phone="<c:out value='${item.studentPhone}' />">
                                                    <td style="text-align: center; color: var(--text-muted); font-weight: 500;">
                                                        <input type="hidden" name="studentIds" value="${item.studentId}">
                                                        ${loop.count}
                                                    </td>
                                                    <td>
                                                        <span class="ops-code-pill" style="color: var(--primary);"><c:out value="${item.studentCode}" /></span>
                                                    </td>
                                                    <td>
                                                        <div style="display: flex; align-items: center; gap: 10px;">
                                                            <div class="ops-avatar-initials">
                                                                ${item.studentName.substring(0, 1)}
                                                            </div>
                                                            <div style="display: flex; flex-direction: column;">
                                                                <span style="font-weight: 600; color: var(--text);"><c:out value="${item.studentName}" /></span>
                                                                <span style="font-size: 11.5px; color: var(--text-muted);">Học sinh chính khóa</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="font-family: monospace; font-size: 13px; color: var(--text-muted);">
                                                        <c:out value="${not empty item.studentPhone ? item.studentPhone : '--'}" />
                                                    </td>
                                                    <td style="text-align: center;">
                                                        <div class="att-segment-group" role="group" style="${sessionData.futureSession ? 'opacity: 0.65; pointer-events: none;' : ''}">
                                                            <!-- Có mặt -->
                                                            <label class="att-segment-btn btn-present ${item.attendanceStatus == 'PRESENT' ? 'is-active' : ''} ">
                                                                <input type="radio" name="status_${item.studentId}" value="PRESENT"
                                                                       ${item.attendanceStatus == 'PRESENT' ? 'checked' : ''}
                                                                       ${sessionData.futureSession ? 'disabled' : ''}
                                                                       onchange="onAttendanceStatusChange(this, ${item.studentId})">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                                <span>Có mặt</span>
                                                            </label>

                                                            <!-- Đi muộn -->
                                                            <label class="att-segment-btn btn-late ${item.attendanceStatus == 'LATE' ? 'is-active' : ''} ">
                                                                <input type="radio" name="status_${item.studentId}" value="LATE"
                                                                       ${item.attendanceStatus == 'LATE' ? 'checked' : ''}
                                                                       ${sessionData.futureSession ? 'disabled' : ''}
                                                                       onchange="onAttendanceStatusChange(this, ${item.studentId})">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                                                <span>Đi muộn</span>
                                                            </label>

                                                            <!-- Có phép -->
                                                            <label class="att-segment-btn btn-excused ${item.attendanceStatus == 'ABSENT_EXCUSED' ? 'is-active' : ''} ">
                                                                <input type="radio" name="status_${item.studentId}" value="ABSENT_EXCUSED"
                                                                       ${item.attendanceStatus == 'ABSENT_EXCUSED' ? 'checked' : ''}
                                                                       ${sessionData.futureSession ? 'disabled' : ''}
                                                                       onchange="onAttendanceStatusChange(this, ${item.studentId})">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                                                                <span>Có phép</span>
                                                            </label>

                                                            <!-- Không phép -->
                                                            <label class="att-segment-btn btn-unexcused ${item.attendanceStatus == 'ABSENT_UNEXCUSED' ? 'is-active' : ''} ">
                                                                <input type="radio" name="status_${item.studentId}" value="ABSENT_UNEXCUSED"
                                                                       ${item.attendanceStatus == 'ABSENT_UNEXCUSED' ? 'checked' : ''}
                                                                       ${sessionData.futureSession ? 'disabled' : ''}
                                                                       onchange="onAttendanceStatusChange(this, ${item.studentId})">
                                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                                                <span>Không phép</span>
                                                            </label>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <input type="text" name="remarks_${item.studentId}" class="form-control form-control-sm"
                                                               placeholder="Lý do đi muộn / nghỉ / thái độ học tập..."
                                                               value="<c:out value='${item.remarks}' />"
                                                               ${sessionData.futureSession ? 'disabled' : ''}
                                                               >
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Empty Search State (Hidden initially) -->
                                <div id="noSearchMatch" class="empty-state" style="display: none; padding: 48px 20px; text-align: center;">
                                    <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted); margin-bottom: 8px;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                                    <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0 0 4px;">Không tìm thấy học sinh phù hợp</h3>
                                    <p style="margin: 0; font-size: 13px; color: var(--text-muted);">Vui lòng kiểm tra lại từ khóa tìm kiếm trong danh sách ca này.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state" style="padding: 56px 20px; text-align: center;">
                                    <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 6px;">Lớp học chưa có học viên ghi danh</h3>
                                    <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">Lớp học này hiện tại chưa có học sinh nào được ghi danh vào thời điểm buổi học diễn ra.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 6. Institutional Compliance & Sticky Action Bar -->
                    <div class="ops-callout no-print">
                        <svg class="icon icon-sm ops-callout-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        <div>
                            <div class="ops-callout-title">Quy chuẩn học vụ BR08:</div>
                            Mỗi học viên có tối đa một bản ghi điểm danh/buổi học. Sau khi chốt hoàn tất, dữ liệu sẽ tự động đồng bộ tức thì lên Cổng phụ huynh, tin nhắn thông báo và bảng tính điểm chuyên cần học kỳ.
                        </div>
                    </div>

                    <!-- Sticky Bottom Action Deck -->
                    <div class="ops-sticky-bar no-print">
                        <div class="ops-sticky-left">
                            <span class="legend-dot" style="background: var(--primary);"></span>
                            <span>Giảng viên: <strong><c:out value="${sessionData.teacherName}" /></strong></span>
                            <c:if test="${sessionData.sessionStatus == 'COMPLETED'}">
                                <span style="color: var(--text-muted); font-size: 12px; margin-left: 8px;">(Ca học đã chốt — giáo viên vẫn có thể chỉnh sửa và lưu lại)</span>
                            </c:if>
                        </div>

                        <div class="ops-sticky-right">
                            <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary btn-sm">
                                Quay lại
                            </a>

                            <c:choose>
                                <c:when test="${sessionData.futureSession}">
                                    <span class="badge" style="background: #F1F5F9; color: #475569; padding: 8px 14px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                        Chưa mở điểm danh (Ngày học: <c:out value="${sessionData.sessionDate}" />)
                                    </span>
                                </c:when>
                                <c:when test="${sessionData.sessionStatus == 'COMPLETED'}">
                                    <button type="submit" class="btn btn-primary btn-sm" onclick="document.getElementById('completeAfterSave').value='false';" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                        <span>Lưu chỉnh sửa điểm danh</span>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="btn btn-secondary btn-sm" onclick="document.getElementById('completeAfterSave').value='false';" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                                        <span>Lưu tạm điểm danh</span>
                                    </button>
                                    <button type="button" class="btn btn-primary btn-sm" onclick="confirmCompleteAttendance()" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Chốt hoàn tất ca học &amp; Điểm danh</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </form>

                <!-- Hidden Complete Form -->
                <form id="completeAttendanceForm" action="${pageContext.request.contextPath}/teacher/attendance/complete" method="post" style="display: none;">
                    <input type="hidden" name="sessionId" value="${sessionData.sessionId}">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                </form>
            </div>
        </main>
    </div>
</div>

<script>
    function updateMetrics() {
        const rows = document.querySelectorAll('.student-row');
        let present = 0, late = 0, excused = 0, unexcused = 0, unmarked = 0;

        rows.forEach(row => {
            const checkedRadio = row.querySelector('input[type="radio"]:checked');
            if (!checkedRadio) {
                unmarked++;
            } else {
                const val = checkedRadio.value;
                if (val === 'PRESENT') present++;
                else if (val === 'LATE') late++;
                else if (val === 'ABSENT_EXCUSED') excused++;
                else if (val === 'ABSENT_UNEXCUSED') unexcused++;
                else unmarked++;
            }
        });

        const elPresent = document.getElementById('metric-present');
        const elLate = document.getElementById('metric-late');
        const elExcused = document.getElementById('metric-excused');
        const elUnexcused = document.getElementById('metric-unexcused');
        const elUnmarked = document.getElementById('metric-unmarked');

        if (elPresent) elPresent.textContent = present;
        if (elLate) elLate.textContent = late;
        if (elExcused) elExcused.textContent = excused;
        if (elUnexcused) elUnexcused.textContent = unexcused;
        if (elUnmarked) elUnmarked.textContent = unmarked;
    }

    function onAttendanceStatusChange(radioInput, studentId) {
        const group = radioInput.closest('.att-segment-group');
        if (group) {
            group.querySelectorAll('.att-segment-btn').forEach(btn => btn.classList.remove('is-active'));
            const activeLabel = radioInput.closest('.att-segment-btn');
            if (activeLabel && radioInput.checked) {
                activeLabel.classList.add('is-active');
            }
        }
        updateMetrics();
    }

    function setAllAttendance(status) {
        const radios = document.querySelectorAll('input[type="radio"][value="' + status + '"]');
        radios.forEach(radio => {
            if (!radio.disabled) {
                radio.checked = true;
                const group = radio.closest('.att-segment-group');
                if (group) {
                    group.querySelectorAll('.att-segment-btn').forEach(b => b.classList.remove('is-active'));
                    const activeLabel = radio.closest('.att-segment-btn');
                    if (activeLabel) activeLabel.classList.add('is-active');
                }
            }
        });
        updateMetrics();
    }

    function resetAllAttendance() {
        const checkedRadios = document.querySelectorAll('.att-segment-group input[type="radio"]:checked');
        checkedRadios.forEach(radio => {
            if (!radio.disabled) {
                radio.checked = false;
                const group = radio.closest('.att-segment-group');
                if (group) {
                    group.querySelectorAll('.att-segment-btn').forEach(b => b.classList.remove('is-active'));
                }
            }
        });
        updateMetrics();
    }

    function filterStudentsTable() {
        const query = (document.getElementById('studentSearchInput').value || '').toLowerCase().trim();
        const rows = document.querySelectorAll('.student-row');
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

        const noMatch = document.getElementById('noSearchMatch');
        if (noMatch) {
            noMatch.style.display = (matched === 0 && rows.length > 0) ? 'block' : 'none';
        }
    }

    function confirmCompleteAttendance() {
        const unmarked = parseInt(document.getElementById('metric-unmarked').textContent || '0', 10);
        if (unmarked > 0) {
            alert('Còn ' + unmarked + ' học sinh chưa được ghi nhận điểm danh.\nVui lòng điểm danh đầy đủ trước khi chốt buổi học!');
            return;
        }
        if (!confirm('XÁC NHẬN CHỐT HOÀN TẤT ĐIỂM DANH:\n\nSau khi chốt hoàn tất, ca học sẽ chuyển sang trạng thái COMPLETED và đồng bộ tức thì sang Cổng phụ huynh. Giáo viên vẫn có thể chỉnh sửa lại sau khi chốt.\n\nBạn có chắc chắn muốn chốt ca học này?')) {
            return;
        }
        document.getElementById('completeAfterSave').value = 'true';
        document.getElementById('attendanceForm').submit();
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateMetrics();
    });
</script>
</body>
</html>
