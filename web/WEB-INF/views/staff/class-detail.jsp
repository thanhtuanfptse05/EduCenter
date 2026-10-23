<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body class="admin-body">
    <div class="admin-layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 16px;">
                    <a href="${pageContext.request.contextPath}/staff/classes" class="btn btn-sm btn-secondary">
                        &larr; Quay lại tra cứu
                    </a>
                </div>

                <div class="content-card" style="padding: 24px; margin-bottom: 24px;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <div>
                            <span style="font-family: monospace; font-size: 13px; font-weight: 700; color: var(--primary); background: var(--primary-subtle); padding: 3px 8px; border-radius: 4px;">
                                ${classDetail.code}
                            </span>
                            <h1 style="font-size: 22px; font-weight: 700; color: var(--text); margin-top: 8px; margin-bottom: 4px;">
                                ${classDetail.name}
                            </h1>
                            <p style="font-size: 14px; color: var(--text-muted);">
                                Khóa học: <strong>${classDetail.courseName}</strong> (${classDetail.courseCode}) &bull; Môn: ${classDetail.subjectName}
                            </p>
                        </div>
                        <div>
                            <span class="badge" style="font-size: 13px; padding: 6px 14px;">${classDetail.status}</span>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-top: 20px; padding-top: 20px; border-top: 1px solid var(--border);">
                        <div>
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 600;">Giáo viên phụ trách</div>
                            <div style="font-size: 14px; font-weight: 600; color: var(--text); margin-top: 2px;">${classDetail.teacherName != null ? classDetail.teacherName : 'Chưa phân công'}</div>
                            <div style="font-size: 12px; color: var(--text-muted);">${classDetail.teacherPhone}</div>
                        </div>
                        <div>
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 600;">Phòng học</div>
                            <div style="font-size: 14px; font-weight: 600; color: var(--text); margin-top: 2px;">${classDetail.roomName != null ? classDetail.roomName : 'Chưa gán'}</div>
                        </div>
                        <div>
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 600;">Sĩ số hiện tại</div>
                            <div style="font-size: 14px; font-weight: 600; color: var(--text); margin-top: 2px;">${classDetail.enrolledCount} / ${classDetail.capacity} học viên</div>
                            <div style="font-size: 12px; font-weight: 700; color: ${classDetail.remainingSlots > 0 ? 'var(--success)' : 'var(--danger)'};">
                                Còn trống ${classDetail.remainingSlots} chỗ
                            </div>
                        </div>
                        <div>
                            <div style="font-size: 11px; text-transform: uppercase; color: var(--text-muted); font-weight: 600;">Khai giảng & Bế giảng</div>
                            <div style="font-size: 14px; font-weight: 600; color: var(--text); margin-top: 2px;">
                                <fmt:parseDate value="${classDetail.startDate}" pattern="yyyy-MM-dd" var="sD" type="date"/>
                                <fmt:formatDate value="${sD}" pattern="dd/MM/yyyy"/>
                                &rarr;
                                <fmt:parseDate value="${classDetail.endDate}" pattern="yyyy-MM-dd" var="eD" type="date"/>
                                <fmt:formatDate value="${eD}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Danh sách buổi học -->
                <div class="content-card">
                    <div style="padding: 16px 20px; border-bottom: 1px solid var(--border); font-weight: 700; font-size: 16px;">
                        Lịch học chi tiết (${classDetail.sessions.size()} buổi học)
                    </div>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 60px;">#</th>
                                    <th style="width: 140px;">Ngày học</th>
                                    <th style="width: 140px;">Khung giờ</th>
                                    <th>Chủ đề bài giảng</th>
                                    <th>Phòng học</th>
                                    <th>Giáo viên</th>
                                    <th style="width: 130px;">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty classDetail.sessions}">
                                        <c:forEach var="sess" items="${classDetail.sessions}" varStatus="loop">
                                            <tr>
                                                <td style="font-weight: 600; color: var(--text-muted);">${loop.index + 1}</td>
                                                <td>
                                                    <fmt:parseDate value="${sess.sessionDate}" pattern="yyyy-MM-dd" var="sDt" type="date"/>
                                                    <fmt:formatDate value="${sDt}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>
                                                    <span style="font-weight: 600; color: var(--primary);">${sess.formattedTime}</span>
                                                </td>
                                                <td>${sess.title != null ? sess.title : 'Buổi học định kỳ'}</td>
                                                <td>${sess.roomName} (${sess.roomCode})</td>
                                                <td>${sess.teacherName}</td>
                                                <td><span class="badge">${sess.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 30px; color: var(--text-muted);">
                                                Lớp học này chưa xếp lịch cụ thể.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html>
