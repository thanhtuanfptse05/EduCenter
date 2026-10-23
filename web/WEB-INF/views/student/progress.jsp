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
    <c:set var="activeNav" value="student-progress" scope="request" />
    <c:set var="breadcrumb" value="Kết quả học tập & Chuyên cần" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h1 class="page-title">Kết quả học tập &amp; Chuyên cần</h1>
                    <p class="page-subtitle">Xem điểm các bài kiểm tra đã công bố và thống kê mức độ tham gia lớp học</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                        <span>Về bảng điều khiển</span>
                    </a>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Chuyên cần Section -->
            <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-bottom: 24px;">
                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 16px; display: flex; align-items: center; gap: 8px;">
                    <svg class="icon icon-sm" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Thống kê Chuyên cần</span>
                </h2>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 16px; margin-bottom: 20px;">
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Tổng số buổi</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--text); margin-top: 4px;"><c:out value="${dashboard.attendanceSummary.totalSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Có mặt đúng giờ</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--success); margin-top: 4px;"><c:out value="${dashboard.attendanceSummary.attendedSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Đi muộn</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--warning); margin-top: 4px;"><c:out value="${dashboard.attendanceSummary.lateSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Vắng có phép</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--info); margin-top: 4px;"><c:out value="${dashboard.attendanceSummary.excusedSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Vắng không phép</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--danger); margin-top: 4px;"><c:out value="${dashboard.attendanceSummary.unexcusedSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Tỷ lệ chuyên cần</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--primary); margin-top: 4px;"><c:out value="${dashboard.attendanceSummary.attendanceRateFormatted}" /></div>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div>
                    <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 6px;">
                        <span class="text-muted">Mức độ hoàn thành chuyên cần:</span>
                        <span style="font-weight: 700; color: var(--text);"><c:out value="${dashboard.attendanceSummary.attendanceRateFormatted}" /></span>
                    </div>
                    <div style="width: 100%; height: 8px; background: var(--surface-muted); border-radius: 9999px; overflow: hidden;">
                        <div style="width: ${dashboard.attendanceSummary.attendanceRate}%; height: 100%; background: var(--success); border-radius: 9999px;"></div>
                    </div>
                </div>
            </div>

            <!-- Bảng điểm chi tiết -->
            <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 16px; display: flex; align-items: center; gap: 8px;">
                    <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                    <span>Bảng điểm bài kiểm tra (Đã công bố)</span>
                </h2>

                <c:choose>
                    <c:when test="${empty scores}">
                        <div class="empty-state" style="padding: 48px 16px; text-align: center;">
                            <div style="width: 56px; height: 56px; border-radius: 50%; background: var(--surface-muted); color: var(--text-muted); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 12px;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                            </div>
                            <h3 style="font-size: 16px; font-weight: 600; color: var(--text); margin: 0 0 6px;">Chưa có điểm kiểm tra</h3>
                            <p class="text-muted" style="margin: 0; font-size: 13px;">Giáo viên chưa công bố điểm bài thi nào cho các lớp học của bạn.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr style="border-bottom: 1px solid var(--border); text-align: left; font-size: 12px; color: var(--text-muted); text-transform: uppercase;">
                                        <th style="padding: 12px;">Tên bài kiểm tra</th>
                                        <th style="padding: 12px;">Môn / Lớp</th>
                                        <th style="padding: 12px;">Hình thức</th>
                                        <th style="padding: 12px;">Ngày làm bài</th>
                                        <th style="padding: 12px; text-align: center;">Điểm số</th>
                                        <th style="padding: 12px;">Đánh giá</th>
                                        <th style="padding: 12px;">Nhận xét giáo viên</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sc" items="${scores}">
                                        <tr style="border-bottom: 1px solid var(--border); font-size: 13px;">
                                            <td style="padding: 12px; font-weight: 600; color: var(--text);">
                                                <c:out value="${sc.assessmentTitle}" />
                                            </td>
                                            <td style="padding: 12px;">
                                                <span class="badge badge-info"><c:out value="${sc.subjectName}" /></span>
                                                <span class="text-muted" style="font-size: 11px; margin-left: 4px;"><c:out value="${sc.classCode}" /></span>
                                            </td>
                                            <td style="padding: 12px;">
                                                <c:out value="${sc.typeNameVi}" />
                                            </td>
                                            <td style="padding: 12px;">
                                                <c:out value="${sc.formattedDate}" />
                                            </td>
                                            <td style="padding: 12px; text-align: center;">
                                                <span style="font-size: 16px; font-weight: 800; color: ${sc.passed ? 'var(--success)' : 'var(--danger)'};">
                                                    <c:out value="${sc.score}" />
                                                </span>
                                                <span class="text-muted" style="font-size: 11px;">/<c:out value="${sc.maxScore}" /></span>
                                            </td>
                                            <td style="padding: 12px;">
                                                <span class="badge ${sc.passed ? 'badge-success' : 'badge-danger'}">
                                                    <c:out value="${sc.passed ? 'Đạt' : 'Chưa đạt'}" />
                                                </span>
                                            </td>
                                            <td style="padding: 12px; color: var(--text-muted); font-size: 12px; max-width: 250px;">
                                                <c:out value="${empty sc.remark ? 'Tốt, tiếp tục phát huy' : sc.remark}" />
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
