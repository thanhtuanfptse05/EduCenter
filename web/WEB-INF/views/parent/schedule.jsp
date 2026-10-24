<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="parent-schedule" scope="request" />
    <c:set var="breadcrumb" value="Thời khóa biểu của con" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px;">
                <div>
                    <h1 class="page-title">Thời khóa biểu của con</h1>
                    <p class="page-subtitle">Theo dõi lịch học chi tiết, giáo viên phụ trách và phòng học theo từng buổi của con</p>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/parent/progress?childId=${selectedChildId}" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path><path d="m9 12 2 2 4-4"></path></svg>
                        <span>Xem kết quả học tập</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                        <span>Bảng điều khiển</span>
                    </a>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Child Selector & Date Filter Card -->
            <div class="card" style="padding: 18px 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-bottom: 20px;">
                <form action="${pageContext.request.contextPath}/parent/schedule" method="get" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
                    <!-- Child Selector (If multiple children) -->
                    <c:if test="${parentSummary.hasChildren()}">
                        <div style="flex: 1; min-width: 220px;">
                            <label class="form-label" for="childIdSelect" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Chọn học sinh (con):</label>
                            <select id="childIdSelect" name="childId" class="form-control" onchange="this.form.submit()">
                                <c:forEach var="ch" items="${parentSummary.verifiedChildren}">
                                    <option value="${ch.id}" ${ch.id == selectedChildId ? 'selected' : ''}>
                                        <c:out value="${ch.fullName}"/> (${ch.gradeLevel == null ? 'Chưa phân khối' : 'Lớp '.concat(ch.gradeLevel)})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>

                    <div style="flex: 1; min-width: 170px;">
                        <label class="form-label" for="fromDate" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Từ ngày:</label>
                        <input type="date" id="fromDate" name="fromDate" class="form-control" value="<c:out value='${fromDate}' />">
                    </div>
                    <div style="flex: 1; min-width: 170px;">
                        <label class="form-label" for="toDate" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Đến ngày:</label>
                        <input type="date" id="toDate" name="toDate" class="form-control" value="<c:out value='${toDate}' />">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary" style="height: 38px; display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            <span>Lọc lịch học</span>
                        </button>
                    </div>
                </form>
            </div>

            <!-- Schedule Table / Empty State -->
            <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                <c:choose>
                    <c:when test="${empty scheduleList}">
                        <div class="empty-state" style="padding: 48px 16px; text-align: center;">
                            <div style="width: 56px; height: 56px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 12px;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 16 14"></polyline>
                                </svg>
                            </div>
                            <h3 style="font-size: 16px; font-weight: 600; color: var(--text); margin: 0 0 6px;">Chưa có ca học nào trong khoảng thời gian này</h3>
                            <p class="text-muted" style="margin: 0; font-size: 13px;">Không có ca học nào được tìm thấy hoặc học sinh hiện chưa tham gia lớp học nào.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr style="border-bottom: 1px solid var(--border); text-align: left; font-size: 12px; color: var(--text-muted); text-transform: uppercase;">
                                        <th style="padding: 12px;">Thời gian / Ngày</th>
                                        <th style="padding: 12px;">Lớp học &amp; Môn</th>
                                        <th style="padding: 12px;">Phòng học</th>
                                        <th style="padding: 12px;">Giáo viên giảng dạy</th>
                                        <th style="padding: 12px;">Trạng thái buổi</th>
                                        <th style="padding: 12px;">Nội dung bài học</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${scheduleList}">
                                        <tr style="border-bottom: 1px solid var(--border); font-size: 13px;">
                                            <td style="padding: 12px;">
                                                <div style="font-weight: 700; color: var(--text);"><c:out value="${item.dayOfWeekVi}" />, <c:out value="${item.formattedDate}" /></div>
                                                <div class="text-muted" style="font-size: 12px;"><c:out value="${item.timeRange}" /></div>
                                            </td>
                                            <td style="padding: 12px;">
                                                <div style="font-weight: 600; color: var(--text);"><c:out value="${item.className}" /></div>
                                                <span class="badge badge-info" style="font-size: 11px;"><c:out value="${item.subjectName}" /></span>
                                            </td>
                                            <td style="padding: 12px;">
                                                <span style="font-weight: 500; color: var(--text);"><c:out value="${item.roomName}" /></span>
                                            </td>
                                            <td style="padding: 12px;">
                                                <c:out value="${item.teacherName}" />
                                            </td>
                                            <td style="padding: 12px;">
                                                <c:choose>
                                                    <c:when test="${item.status == 'COMPLETED'}">
                                                        <span class="badge badge-success">Đã hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${item.status == 'CANCELLED'}">
                                                        <span class="badge badge-danger">Đã nghỉ / Hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-info">Sắp diễn ra</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 12px; color: var(--text-muted); font-size: 12px;">
                                                <c:out value="${empty item.notes ? 'Theo giáo án' : item.notes}" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
</body>
</html>
