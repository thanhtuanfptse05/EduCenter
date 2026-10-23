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
    <c:set var="activeNav" value="parent-dashboard" scope="request" />
    <c:set var="breadcrumb" value="Hồ sơ chi tiết của con" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                <div>
                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
                        <h1 class="page-title" style="margin: 0;">Hồ sơ học tập: <c:out value="${childDetail.studentName}" /></h1>
                        <span class="badge badge-info" style="font-size: 12px; font-weight: 600;"><c:out value="${childDetail.studentCode}" /></span>
                    </div>
                    <p class="page-subtitle" style="margin: 0;">
                        Khối <c:out value="${childDetail.gradeLevel}" /> &bull; Trường: <c:out value="${empty childDetail.school ? 'EduCenter Academy' : childDetail.school}" />
                    </p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/parent/dashboard" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                        <span>Quay lại cổng phụ huynh</span>
                    </a>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Chuyên cần Section -->
            <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-bottom: 24px;">
                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 16px; display: flex; align-items: center; gap: 8px;">
                    <svg class="icon icon-sm" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    <span>Mức độ Chuyên cần của con</span>
                </h2>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 16px; margin-bottom: 16px;">
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Tổng số buổi học</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--text); margin-top: 4px;"><c:out value="${childDetail.attendanceSummary.totalSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Đi học đúng giờ</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--success); margin-top: 4px;"><c:out value="${childDetail.attendanceSummary.attendedSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Đi muộn</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--warning); margin-top: 4px;"><c:out value="${childDetail.attendanceSummary.lateSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Vắng có phép</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--info); margin-top: 4px;"><c:out value="${childDetail.attendanceSummary.excusedSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Vắng không phép</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--danger); margin-top: 4px;"><c:out value="${childDetail.attendanceSummary.unexcusedSessions}" /></div>
                    </div>
                    <div style="background: var(--surface-muted); padding: 12px; border-radius: var(--radius-sm); text-align: center;">
                        <div class="text-muted" style="font-size: 12px;">Tỷ lệ chuyên cần</div>
                        <div style="font-size: 20px; font-weight: 700; color: var(--primary); margin-top: 4px;"><c:out value="${childDetail.attendanceSummary.attendanceRateFormatted}" /></div>
                    </div>
                </div>

                <!-- Progress Bar -->
                <div>
                    <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 6px;">
                        <span class="text-muted">Chuyên cần tổng thể:</span>
                        <span style="font-weight: 700; color: var(--text);"><c:out value="${childDetail.attendanceSummary.attendanceRateFormatted}" /></span>
                    </div>
                    <div style="width: 100%; height: 8px; background: var(--surface-muted); border-radius: 9999px; overflow: hidden;">
                        <div style="width: ${childDetail.attendanceSummary.attendanceRate}%; height: 100%; background: var(--success); border-radius: 9999px;"></div>
                    </div>
                </div>
            </div>

            <!-- Bảng điểm chi tiết của con -->
            <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-bottom: 24px;">
                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 16px; display: flex; align-items: center; gap: 8px;">
                    <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                    <span>Kết quả các bài kiểm tra đã công bố của con</span>
                </h2>

                <c:choose>
                    <c:when test="${empty childDetail.recentScores}">
                        <div class="empty-state" style="padding: 32px 16px; text-align: center;">
                            <p class="text-muted" style="margin: 0; font-size: 13px;">Chưa có bài kiểm tra nào được công bố điểm.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr style="border-bottom: 1px solid var(--border); text-align: left; font-size: 12px; color: var(--text-muted); text-transform: uppercase;">
                                        <th style="padding: 12px;">Bài kiểm tra</th>
                                        <th style="padding: 12px;">Môn / Lớp</th>
                                        <th style="padding: 12px;">Hình thức</th>
                                        <th style="padding: 12px;">Ngày làm bài</th>
                                        <th style="padding: 12px; text-align: center;">Điểm số</th>
                                        <th style="padding: 12px;">Đánh giá</th>
                                        <th style="padding: 12px;">Nhận xét giáo viên</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sc" items="${childDetail.recentScores}">
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
                                                <c:out value="${empty sc.remark ? 'Tốt, tiếp tục rèn luyện' : sc.remark}" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Danh sách lớp con đang học -->
            <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 16px; display: flex; align-items: center; gap: 8px;">
                    <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    <span>Các lớp học con đang tham gia</span>
                </h2>

                <c:choose>
                    <c:when test="${empty childDetail.enrolledClasses}">
                        <div class="empty-state" style="padding: 24px; text-align: center;">
                            <p class="text-muted" style="margin: 0; font-size: 13px;">Học sinh hiện chưa đăng ký lớp học nào.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="data-table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr style="border-bottom: 1px solid var(--border); text-align: left; font-size: 12px; color: var(--text-muted); text-transform: uppercase;">
                                        <th style="padding: 10px 12px;">Mã lớp</th>
                                        <th style="padding: 10px 12px;">Tên lớp học</th>
                                        <th style="padding: 10px 12px;">Giáo viên phụ trách</th>
                                        <th style="padding: 10px 12px;">Phòng học</th>
                                        <th style="padding: 10px 12px;">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cl" items="${childDetail.enrolledClasses}">
                                        <tr style="border-bottom: 1px solid var(--border); font-size: 13px;">
                                            <td style="padding: 12px;"><span class="badge badge-info"><c:out value="${cl.code}" /></span></td>
                                            <td style="padding: 12px; font-weight: 600;"><c:out value="${cl.name}" /></td>
                                            <td style="padding: 12px;"><c:out value="${cl.teacherName}" /></td>
                                            <td style="padding: 12px;"><c:out value="${cl.roomName}" /></td>
                                            <td style="padding: 12px;"><span class="badge badge-success"><c:out value="${cl.status}" /></span></td>
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
