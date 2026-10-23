<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="internalShell" value="true" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .class-header-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
        }
        @media (max-width: 768px) {
            .class-header-card { flex-direction: column; }
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }
        @media (max-width: 992px) {
            .info-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .info-grid { grid-template-columns: 1fr; }
        }
        .info-block-lbl {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 4px;
        }
        .info-block-val {
            font-size: 14px;
            font-weight: 600;
            color: var(--text);
        }
        .sessions-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin-bottom: 24px;
        }
        .card-header-flex {
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            background: var(--surface);
        }
        .day-pills {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 6px;
        }
        .day-pill-label {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 13px;
            cursor: pointer;
            background: var(--surface);
            transition: all 0.2s;
            user-select: none;
        }
        .day-pill-label:hover {
            border-color: var(--primary);
            background: var(--primary-subtle);
        }
        .day-pill-label input:checked + span {
            font-weight: 700;
            color: var(--primary);
        }
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 20px;
        }
        .modal-overlay.active {
            display: flex;
        }
        .modal-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            width: 100%;
            max-width: 600px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }
        .modal-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-body {
            padding: 20px;
            max-height: 80vh;
            overflow-y: auto;
        }
        .modal-footer {
            padding: 14px 20px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            background: var(--bg);
        }
        .badge-status {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-SCHEDULED { background: #e0f2fe; color: #0369a1; }
        .status-IN_PROGRESS { background: var(--warning-subtle); color: var(--warning); }
        .status-COMPLETED { background: var(--success-subtle); color: var(--success); }
        .status-CANCELLED { background: var(--danger-subtle); color: var(--danger); }
        .status-RESCHEDULED { background: #f3e8ff; color: #7e22ce; }
    </style>
</head>
<body class="admin-body">
    <div class="admin-layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px;">
                    <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-sm btn-secondary">
                        &larr; Danh sách lớp học
                    </a>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        <span>${flashSuccess}</span>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span>${flashError}</span>
                    </div>
                </c:if>

                <!-- Thẻ thông tin tổng quan lớp học -->
                <div class="class-header-card">
                    <div style="flex: 1;">
                        <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px;">
                            <span style="font-family: monospace; font-size: 13px; font-weight: 700; color: var(--primary); background: var(--primary-subtle); padding: 3px 8px; border-radius: 4px;">
                                ${classDetail.code}
                            </span>
                            <span class="badge-status status-${classDetail.status}">
                                <c:choose>
                                    <c:when test="${classDetail.status == 'PLANNING'}">Kế hoạch (PLANNING)</c:when>
                                    <c:when test="${classDetail.status == 'OPEN'}">Mở tuyển sinh (OPEN)</c:when>
                                    <c:when test="${classDetail.status == 'ONGOING'}">Đang diễn ra (ONGOING)</c:when>
                                    <c:when test="${classDetail.status == 'CLOSED'}">Đã đóng (CLOSED)</c:when>
                                    <c:when test="${classDetail.status == 'CANCELLED'}">Đã hủy (CANCELLED)</c:when>
                                    <c:otherwise>${classDetail.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <h1 style="font-size: 22px; font-weight: 700; color: var(--text); margin-bottom: 4px;">
                            ${classDetail.name}
                        </h1>
                        <p style="font-size: 14px; color: var(--text-muted);">
                            Khóa học: <strong style="color: var(--text);">${classDetail.courseName}</strong> (${classDetail.courseCode}) &bull; Môn: ${classDetail.subjectName}
                        </p>

                        <!-- Thông tin chi tiết 4 cột -->
                        <div class="info-grid">
                            <div>
                                <div class="info-block-lbl">Giáo viên phụ trách</div>
                                <div class="info-block-val">${classDetail.teacherName != null ? classDetail.teacherName : 'Chưa phân công'}</div>
                                <div style="font-size: 12px; color: var(--text-muted);">${classDetail.teacherEmail}</div>
                            </div>
                            <div>
                                <div class="info-block-lbl">Phòng học mặc định</div>
                                <div class="info-block-val">${classDetail.roomName != null ? classDetail.roomName : 'Chưa gán'}</div>
                                <div style="font-size: 12px; color: var(--text-muted);">
                                    <c:if test="${not empty classDetail.roomCapacity}">Sức chứa: ${classDetail.roomCapacity} chỗ</c:if>
                                </div>
                            </div>
                            <div>
                                <div class="info-block-lbl">Sĩ số học viên</div>
                                <div class="info-block-val">${classDetail.enrolledCount} / ${classDetail.capacity} học viên</div>
                                <div style="font-size: 12px; color: ${classDetail.remainingSlots > 0 ? 'var(--success)' : 'var(--danger)'}; font-weight: 600;">
                                    Còn trống ${classDetail.remainingSlots} chỗ
                                </div>
                            </div>
                            <div>
                                <div class="info-block-lbl">Thời gian khai giảng & bế giảng</div>
                                <div class="info-block-val">
                                    ${classDetail.formattedStartDate} &rarr; ${classDetail.formattedEndDate}
                                </div>
                                <div style="font-size: 12px; color: var(--text-muted);">Số buổi quy định: ${classDetail.totalCourseSessions} buổi</div>
                            </div>
                        </div>
                    </div>

                    <!-- Panel nút hành động -->
                    <div style="display: flex; flex-direction: column; gap: 8px; min-width: 200px;">
                        <button type="button" class="btn btn-primary" onclick="openScheduleModal()" ${classDetail.status == 'CLOSED' || classDetail.status == 'CANCELLED' ? 'disabled' : ''}>
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="12" y1="14" x2="12" y2="18"/><line x1="10" y1="16" x2="14" y2="16"/></svg>
                            Sinh lịch tự động
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/classes/edit?id=${classDetail.id}" class="btn btn-secondary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            Sửa thông tin lớp
                        </a>
                        <!-- Form chuyển trạng thái nhanh -->
                        <form method="post" action="${pageContext.request.contextPath}/admin/classes/status" style="margin-top: 4px;">
                            <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">
                            <input type="hidden" name="classId" value="${classDetail.id}">
                            <div style="display: flex; gap: 4px;">
                                <select name="status" class="form-control" style="font-size: 12px; padding: 6px 8px;">
                                    <option value="OPEN" ${classDetail.status == 'OPEN' ? 'selected' : ''}>Mở (OPEN)</option>
                                    <option value="ONGOING" ${classDetail.status == 'ONGOING' ? 'selected' : ''}>Đang học (ONGOING)</option>
                                    <option value="CLOSED" ${classDetail.status == 'CLOSED' ? 'selected' : ''}>Đóng lớp (CLOSED)</option>
                                    <option value="CANCELLED" ${classDetail.status == 'CANCELLED' ? 'selected' : ''}>Hủy (CANCELLED)</option>
                                </select>
                                <button type="submit" class="btn btn-sm btn-secondary" onclick="return confirm('Bạn có chắc chắn muốn đổi trạng thái lớp học này?');">Đổi</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Danh sách các buổi học chi tiết -->
                <div class="sessions-card">
                    <div class="card-header-flex">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">Danh sách buổi học (${classDetail.sessions.size()} buổi)</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/timetable" class="btn btn-sm btn-secondary">
                            Xem trên Thời khóa biểu tuần &rarr;
                        </a>
                    </div>

                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">#</th>
                                    <th style="width: 140px;">Ngày học</th>
                                    <th style="width: 140px;">Khung giờ</th>
                                    <th>Chủ đề / Bài giảng</th>
                                    <th>Phòng học</th>
                                    <th>Giáo viên giảng dạy</th>
                                    <th style="width: 140px;">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty classDetail.sessions}">
                                        <c:forEach var="sess" items="${classDetail.sessions}" varStatus="loop">
                                            <tr>
                                                <td style="font-weight: 600; color: var(--text-muted);">${loop.index + 1}</td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);">
                                                        ${sess.formattedSessionDate}
                                                    </div>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--primary); background: var(--primary-subtle); padding: 2px 6px; border-radius: 4px; font-size: 12px;">
                                                        ${sess.formattedTime}
                                                    </span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 500; color: var(--text);">
                                                        ${sess.title != null ? sess.title : 'Buổi học định kỳ'}
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 6px;">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--text-muted);"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                                        <span>${sess.roomName} (${sess.roomCode})</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 6px;">
                                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                                        <span>${sess.teacherName}</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge-status status-${sess.status}">${sess.status}</span>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7">
                                                <div style="padding: 40px; text-align: center;">
                                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="color: var(--text-muted); opacity: 0.5; margin-bottom: 12px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                                    <h4 style="font-size: 15px; font-weight: 600; color: var(--text); margin-bottom: 4px;">Lớp học chưa có lịch học nào</h4>
                                                    <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">Vui lòng dùng công cụ sinh lịch tự động để thiết lập các buổi học theo thứ trong tuần.</p>
                                                    <button type="button" class="btn btn-primary btn-sm" onclick="openScheduleModal()">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                                        Sinh lịch học ngay
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Modal Sinh lịch tự động (Schedule Generator) -->
                <div id="scheduleModal" class="modal-overlay">
                    <div class="modal-card">
                        <div class="modal-header">
                            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0; display: flex; align-items: center; gap: 8px;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                Tự động sinh lịch học định kỳ (FR-004)
                            </h3>
                            <button type="button" class="btn-close" onclick="closeScheduleModal()" style="background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-muted);">&times;</button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin/classes/generate-schedule">
                            <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">
                            <input type="hidden" name="classId" value="${classDetail.id}">

                            <div class="modal-body">
                                <div style="background: var(--primary-subtle); padding: 12px; border-radius: var(--radius-sm); margin-bottom: 16px; font-size: 13px; color: var(--primary); line-height: 1.4;">
                                    Thuật toán sẽ tự động kiểm tra xung đột lịch giảng dạy của giáo viên (BR05) và phòng học (BR06) trên toàn hệ thống trước khi sinh lịch.
                                </div>

                                <div class="form-group">
                                    <label class="form-label required">Chọn các thứ học trong tuần</label>
                                    <div class="day-pills">
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="2" checked> <span>Thứ 2</span></label>
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="3"> <span>Thứ 3</span></label>
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="4" checked> <span>Thứ 4</span></label>
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="5"> <span>Thứ 5</span></label>
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="6" checked> <span>Thứ 6</span></label>
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="7"> <span>Thứ 7</span></label>
                                        <label class="day-pill-label"><input type="checkbox" name="daysOfWeek" value="8"> <span>Chủ nhật</span></label>
                                    </div>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                    <div class="form-group">
                                        <label class="form-label required">Giờ bắt đầu</label>
                                        <input type="time" name="startAt" class="form-control" value="18:00" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label required">Giờ kết thúc</label>
                                        <input type="time" name="endAt" class="form-control" value="20:00" required>
                                    </div>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                    <div class="form-group">
                                        <label class="form-label required">Phòng học</label>
                                        <select name="roomId" class="form-control" required>
                                            <option value="">-- Chọn phòng học --</option>
                                            <c:forEach var="rm" items="${availableRooms}">
                                                <option value="${rm.id}" ${classDetail.roomId == rm.id ? 'selected' : ''}>
                                                    ${rm.code} — ${rm.name} (${rm.capacity} chỗ)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label required">Giáo viên giảng dạy</label>
                                        <select name="teacherId" class="form-control" required>
                                            <option value="">-- Chọn giáo viên --</option>
                                            <c:forEach var="tc" items="${teachers}">
                                                <option value="${tc.id}" ${classDetail.teacherId == tc.id ? 'selected' : ''}>
                                                    ${tc.fullName} (${tc.code})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label required">Ngày bắt đầu sinh</label>
                                        <input type="date" name="startDate" class="form-control" value="${classDetail.startDate}" required>
                                    </div>
                                    <div class="form-group" style="margin-bottom: 0;">
                                        <label class="form-label required">Tổng số buổi cần sinh</label>
                                        <input type="number" name="totalSessions" class="form-control" min="1" max="100" 
                                               value="${classDetail.totalCourseSessions != null ? classDetail.totalCourseSessions : 12}" required>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeScheduleModal()">Đóng</button>
                                <button type="submit" class="btn btn-primary">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                                    Bắt đầu sinh lịch
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function openScheduleModal() {
                        document.getElementById('scheduleModal').classList.add('active');
                    }
                    function closeScheduleModal() {
                        document.getElementById('scheduleModal').classList.remove('active');
                    }
                </script>
            </main>
        </div>
    </div>
</body>
</html>
