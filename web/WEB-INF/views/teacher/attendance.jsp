<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .att-radio-group { display: flex; gap: 8px; flex-wrap: wrap; }
        .att-label {
            display: inline-flex; align-items: center; gap: 4px; padding: 6px 10px;
            border-radius: var(--radius-sm, 6px); font-size: 0.8rem; font-weight: 500;
            cursor: pointer; border: 1px solid var(--border, #cbd5e1);
            transition: all 0.15s ease;
        }
        .att-label input { margin: 0; }
        .att-present:has(input:checked) { background: #dcfce7; color: #15803d; border-color: #86efac; font-weight: 600; }
        .att-late:has(input:checked) { background: #fef9c3; color: #854d0e; border-color: #fde047; font-weight: 600; }
        .att-excused:has(input:checked) { background: #e0f2fe; color: #0369a1; border-color: #7dd3fc; font-weight: 600; }
        .att-unexcused:has(input:checked) { background: #fee2e2; color: #b91c1c; border-color: #fca5a5; font-weight: 600; }

        .session-info-card {
            background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg);
            padding: 20px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center;
            flex-wrap: wrap; gap: 16px;
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="attendance" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Điểm danh ca học" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Breadcrumb Navigation -->
            <div style="margin-bottom: 16px;">
                <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-ghost btn-sm" style="display: inline-flex; align-items: center; gap: 6px; padding-left: 0;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    <span>Quay lại danh sách ca dạy</span>
                </a>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Session Banner Info -->
            <div class="session-info-card">
                <div>
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px;">
                        <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text); margin: 0;">
                            <c:out value="${sessionData.className}" />
                        </h2>
                        <span style="font-size: 0.85rem; color: var(--text-muted); font-family: monospace;">(<c:out value="${sessionData.classCode}" />)</span>
                        <c:choose>
                            <c:when test="${sessionData.sessionStatus == 'COMPLETED'}">
                                <span class="status-badge" style="background: #dcfce7; color: #15803d;">ĐÃ HOÀN TẤT</span>
                            </c:when>
                            <c:when test="${sessionData.sessionStatus == 'IN_PROGRESS'}">
                                <span class="status-badge" style="background: #fef9c3; color: #854d0e;">ĐANG DIỄN RA</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge" style="background: #e0f2fe; color: #0369a1;">CHƯA ĐIỂM DANH</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="font-size: 0.875rem; color: var(--text-muted); display: flex; flex-wrap: wrap; gap: 16px;">
                        <span>Môn học: <strong><c:out value="${sessionData.subjectName}" /></strong></span>
                        <span>Ngày học: <strong><c:out value="${sessionData.sessionDate}" /></strong></span>
                        <span>Ca học: <strong><c:out value="${sessionData.startTime}" /> - <c:out value="${sessionData.endTime}" /></strong></span>
                        <span>Phòng: <strong><c:out value="${sessionData.roomName}" /></strong></span>
                        <span>Giáo viên: <strong><c:out value="${sessionData.teacherName}" /></strong></span>
                    </div>
                </div>

                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/teacher/journal?sessionId=${sessionData.sessionId}" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                            <path d="M6 6h10"></path>
                            <path d="M6 10h10"></path>
                        </svg>
                        <span>Sổ đầu bài & Nhật ký</span>
                    </a>
                </div>
            </div>

            <!-- Attendance Form -->
            <form action="${pageContext.request.contextPath}/teacher/attendance/save" method="post" id="attendanceForm">
                <input type="hidden" name="sessionId" value="${sessionData.sessionId}">

                <div class="admin-card">
                    <div style="padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                        <div>
                            <h3 style="font-size: 1rem; font-weight: 600; margin: 0; color: var(--text);">
                                Danh sách học sinh buổi học (${sessionData.totalStudents} học sinh)
                            </h3>
                            <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">
                                Đã ghi nhận: <span style="color: var(--success); font-weight: 600;">${sessionData.presentCount} có mặt</span>,
                                <span style="color: #b45309; font-weight: 600;">${sessionData.lateCount} đi muộn</span>,
                                <span style="color: var(--danger); font-weight: 600;">${sessionData.excusedCount + sessionData.unexcusedCount} vắng</span>
                                <c:if test="${sessionData.unrecordedCount > 0}">
                                    • <span style="color: #ef4444; font-weight: 600;">${sessionData.unrecordedCount} chưa chọn</span>
                                </c:if>
                            </div>
                        </div>

                        <c:if test="${sessionData.sessionStatus != 'COMPLETED' or sessionScope.currentUser.admin}">
                            <div style="display: flex; gap: 8px;">
                                <button type="button" class="btn btn-ghost btn-sm" onclick="setAllAttendance('PRESENT')">
                                    Đánh dấu tất cả có mặt
                                </button>
                            </div>
                        </c:if>
                    </div>

                    <c:choose>
                        <c:when test="${not empty sessionData.roster}">
                            <div class="table-responsive">
                                <table class="table" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                    <tr>
                                        <th style="width: 48px; text-align: center;">#</th>
                                        <th>Mã HV</th>
                                        <th>Họ và tên học sinh</th>
                                        <th style="width: 380px;">Trạng thái điểm danh</th>
                                        <th>Ghi chú / Nhận xét</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${sessionData.roster}" varStatus="loop">
                                        <input type="hidden" name="studentIds" value="${item.studentId}">
                                        <tr>
                                            <td style="text-align: center; color: var(--text-muted);">${loop.count}</td>
                                            <td>
                                                <code style="font-weight: 600;"><c:out value="${item.studentCode}" /></code>
                                            </td>
                                            <td>
                                                <div style="font-weight: 600; color: var(--text);"><c:out value="${item.studentName}" /></div>
                                                <div style="font-size: 0.75rem; color: var(--text-muted);"><c:out value="${item.studentPhone}" /></div>
                                            </td>
                                            <td>
                                                <div class="att-radio-group">
                                                    <label class="att-label att-present">
                                                        <input type="radio" name="status_${item.studentId}" value="PRESENT"
                                                               ${item.attendanceStatus == 'PRESENT' ? 'checked' : ''}
                                                               ${sessionData.sessionStatus == 'COMPLETED' and not sessionScope.currentUser.admin ? 'disabled' : ''}>
                                                        <span>Có mặt</span>
                                                    </label>
                                                    <label class="att-label att-late">
                                                        <input type="radio" name="status_${item.studentId}" value="LATE"
                                                               ${item.attendanceStatus == 'LATE' ? 'checked' : ''}
                                                               ${sessionData.sessionStatus == 'COMPLETED' and not sessionScope.currentUser.admin ? 'disabled' : ''}>
                                                        <span>Đi muộn</span>
                                                    </label>
                                                    <label class="att-label att-excused">
                                                        <input type="radio" name="status_${item.studentId}" value="ABSENT_EXCUSED"
                                                               ${item.attendanceStatus == 'ABSENT_EXCUSED' ? 'checked' : ''}
                                                               ${sessionData.sessionStatus == 'COMPLETED' and not sessionScope.currentUser.admin ? 'disabled' : ''}>
                                                        <span>Có phép</span>
                                                    </label>
                                                    <label class="att-label att-unexcused">
                                                        <input type="radio" name="status_${item.studentId}" value="ABSENT_UNEXCUSED"
                                                               ${item.attendanceStatus == 'ABSENT_UNEXCUSED' ? 'checked' : ''}
                                                               ${sessionData.sessionStatus == 'COMPLETED' and not sessionScope.currentUser.admin ? 'disabled' : ''}>
                                                        <span>Không phép</span>
                                                    </label>
                                                </div>
                                            </td>
                                            <td>
                                                <input type="text" name="remarks_${item.studentId}" class="form-control form-control-sm"
                                                       placeholder="Lý do đi muộn / nghỉ / thái độ..."
                                                       value="<c:out value='${item.remarks}' />"
                                                       ${sessionData.sessionStatus == 'COMPLETED' and not sessionScope.currentUser.admin ? 'disabled' : ''}>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div style="padding: 16px 20px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; background: var(--bg-subtle);">
                                <div>
                                    <c:if test="${sessionData.sessionStatus == 'COMPLETED'}">
                                        <span style="font-size: 0.85rem; color: var(--text-muted);">
                                            * Buổi học đã chốt hoàn tất. Chỉ quản trị viên mới có quyền hiệu chỉnh lại điểm danh.
                                        </span>
                                    </c:if>
                                </div>
                                <div style="display: flex; gap: 10px;">
                                    <c:if test="${sessionData.sessionStatus != 'COMPLETED' or sessionScope.currentUser.admin}">
                                        <button type="submit" class="btn btn-secondary">
                                            Lưu tạm điểm danh
                                        </button>
                                        <button type="button" class="btn btn-primary" onclick="confirmCompleteSession()">
                                            Chốt hoàn tất ca học
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="padding: 40px 20px; text-align: center;">
                                <p style="color: var(--text-muted); font-size: 0.875rem;">Lớp học này hiện chưa có học viên nào được ghi danh hợp lệ vào thời điểm buổi học.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>

            <!-- Form ẩn chốt buổi học -->
            <form id="completeForm" action="${pageContext.request.contextPath}/teacher/attendance/complete" method="post" style="display: none;">
                <input type="hidden" name="sessionId" value="${sessionData.sessionId}">
            </form>
        </main>
    </div>
</div>

<script>
    function setAllAttendance(status) {
        var radios = document.querySelectorAll('input[type="radio"][value="' + status + '"]');
        radios.forEach(function(r) {
            if (!r.disabled) {
                r.checked = true;
            }
        });
    }

    function confirmCompleteSession() {
        if (confirm('Xác nhận chốt hoàn tất điểm danh ca học? Sau khi chốt, giáo viên sẽ không thể tự ý sửa đổi lại danh sách điểm danh!')) {
            document.getElementById('completeForm').submit();
        }
    }
</script>
</body>
</html>
