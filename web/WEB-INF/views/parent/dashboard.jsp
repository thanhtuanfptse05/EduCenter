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
    <c:set var="breadcrumb" value="Giám sát con học" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <c:choose>
                <%-- Trạng thái phụ huynh chưa có con nào được liên kết --%>
                <c:when test="${not dashboard.hasChildren()}">
                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Chào mừng Phụ huynh đến với EduCenter!</h1>
                            <p class="page-subtitle">Cổng thông tin giám sát và đồng hành cùng tiến độ học tập của con</p>
                        </div>
                    </div>
                    <div class="empty-state-card" style="background: var(--surface); border: 1px dashed var(--border); border-radius: var(--radius-lg); padding: 48px 24px; text-align: center; margin-top: 16px;">
                        <div style="width: 64px; height: 64px; border-radius: 50%; background: var(--warning-subtle); color: var(--warning); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                            <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            </svg>
                        </div>
                        <h2 style="font-size: 18px; font-weight: 700; color: var(--text); margin-bottom: 8px;">Chưa có học sinh nào được liên kết</h2>
                        <p class="text-muted" style="max-width: 520px; margin: 0 auto 20px; line-height: 1.5; font-size: 14px;">
                            Tài khoản phụ huynh <strong><c:out value="${sessionScope.currentUser.email}" /></strong> hiện chưa liên kết với hồ sơ học sinh nào hoặc liên kết đang chờ ban giáo vụ xác minh.
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                <span>Cập nhật hồ sơ cá nhân</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-secondary">Xem danh mục khóa học</a>
                        </div>
                    </div>
                </c:when>

                <%-- Trạng thái phụ huynh đã có con được liên kết --%>
                <c:otherwise>
                    <!-- Child Selector Bar -->
                    <div class="card" style="padding: 16px 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: 50%; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                            <div>
                                <div style="font-size: 12px; color: var(--text-muted); font-weight: 500;">Đang theo dõi học sinh:</div>
                                <div style="font-size: 16px; font-weight: 700; color: var(--text);">
                                    <c:out value="${dashboard.selectedChildSummary.studentName}" />
                                    <span class="badge badge-info" style="font-size: 11px; margin-left: 6px;"><c:out value="${dashboard.selectedChildSummary.studentCode}" /></span>
                                </div>
                            </div>
                        </div>

                        <!-- Dropdown chọn con khác nếu có nhiều hơn 1 con -->
                        <div style="display: flex; align-items: center; gap: 12px;">
                            <c:if test="${dashboard.verifiedChildren.size() > 1}">
                                <form action="${pageContext.request.contextPath}/parent/dashboard" method="get" style="display: flex; align-items: center; gap: 8px;">
                                    <label class="form-label" for="childSelect" style="margin: 0; font-size: 12px; white-space: nowrap;">Đổi con:</label>
                                    <select id="childSelect" name="childId" class="form-control" onchange="this.form.submit()" style="height: 36px; padding: 0 12px; font-size: 13px;">
                                        <c:forEach var="ch" items="${dashboard.verifiedChildren}">
                                            <option value="${ch.id}" ${ch.id == dashboard.selectedChildId ? 'selected' : ''}>
                                                <c:out value="${ch.fullName}" /> (Khối <c:out value="${ch.gradeLevel}" />)
                                            </option>
                                        </c:forEach>
                                    </select>
                                </form>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/parent/children/detail?id=${dashboard.selectedChildId}" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                <span>Xem toàn bộ học bạ</span>
                            </a>
                        </div>
                    </div>

                    <!-- KPI Summary Cards of Selected Child -->
                    <div class="kpi-grid">
                        <!-- KPI 1 -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Số lớp con đang học</div>
                                <div class="kpi-value"><c:out value="${dashboard.selectedChildSummary.enrolledClassCount}" /></div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                            </div>
                        </div>

                        <!-- KPI 2 -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Tỷ lệ chuyên cần của con</div>
                                <div class="kpi-value" style="color: var(--success);"><c:out value="${dashboard.selectedChildSummary.attendanceSummary.attendanceRateFormatted}" /></div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            </div>
                        </div>

                        <!-- KPI 3 -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Điểm kiểm tra TB</div>
                                <div class="kpi-value" style="color: var(--primary);">
                                    <c:choose>
                                        <c:when test="${not empty dashboard.selectedChildSummary.averageScore}"><c:out value="${dashboard.selectedChildSummary.averageScore}" />/10</c:when>
                                        <c:otherwise>Chưa có</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--warning-subtle); color: var(--warning); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="8" r="6"></circle><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path></svg>
                            </div>
                        </div>

                        <!-- KPI 4 -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Lịch học sắp tới</div>
                                <div class="kpi-value"><c:out value="${dashboard.selectedChildSummary.upcomingSessions.size()}" /> buổi</div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--info-subtle); color: var(--info); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </div>
                        </div>
                    </div>

                    <!-- 2-Column Dashboard Grid -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 24px; margin-top: 24px;">
                        <!-- Col 1: Lịch học của con -->
                        <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0; display: flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    <span>Lịch học sắp tới của con</span>
                                </h2>
                            </div>

                            <c:choose>
                                <c:when test="${empty dashboard.selectedChildSummary.upcomingSessions}">
                                    <div class="empty-state" style="padding: 32px 16px; text-align: center;">
                                        <p class="text-muted" style="margin: 0; font-size: 13px;">Con chưa có buổi học nào sắp diễn ra.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; flex-direction: column; gap: 12px;">
                                        <c:forEach var="sessionItem" items="${dashboard.selectedChildSummary.upcomingSessions}">
                                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 14px; background: var(--surface-muted); border-radius: var(--radius-sm); border-left: 3px solid var(--primary);">
                                                <div>
                                                    <div style="font-weight: 600; font-size: 14px; color: var(--text);"><c:out value="${sessionItem.className}" /></div>
                                                    <div class="text-muted" style="font-size: 12px; margin-top: 2px;">
                                                        Môn: <strong><c:out value="${sessionItem.subjectName}" /></strong> &bull; Phòng: <c:out value="${sessionItem.roomName}" />
                                                    </div>
                                                    <div class="text-muted" style="font-size: 12px;">
                                                        GV: <c:out value="${sessionItem.teacherName}" />
                                                    </div>
                                                </div>
                                                <div style="text-align: right; flex-shrink: 0;">
                                                    <span class="badge badge-info" style="font-size: 11px; margin-bottom: 4px; display: inline-block;">
                                                        <c:out value="${sessionItem.dayOfWeekVi}" />, <c:out value="${sessionItem.formattedDate}" />
                                                    </span>
                                                    <div style="font-weight: 700; font-size: 13px; color: var(--text);"><c:out value="${sessionItem.timeRange}" /></div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Col 2: Điểm thi của con -->
                        <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0; display: flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                                    <span>Điểm kiểm tra gần đây của con</span>
                                </h2>
                            </div>

                            <c:choose>
                                <c:when test="${empty dashboard.selectedChildSummary.recentScores}">
                                    <div class="empty-state" style="padding: 32px 16px; text-align: center;">
                                        <p class="text-muted" style="margin: 0; font-size: 13px;">Chưa có bài kiểm tra nào được công bố điểm.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; flex-direction: column; gap: 12px;">
                                        <c:forEach var="scoreItem" items="${dashboard.selectedChildSummary.recentScores}">
                                            <div style="display: flex; justify-content: space-between; align-items: center; padding: 12px 14px; background: var(--surface-muted); border-radius: var(--radius-sm); border-left: 3px solid ${scoreItem.passed ? 'var(--success)' : 'var(--danger)'};">
                                                <div>
                                                    <div style="font-weight: 600; font-size: 14px; color: var(--text);"><c:out value="${scoreItem.assessmentTitle}" /></div>
                                                    <div class="text-muted" style="font-size: 12px; margin-top: 2px;">
                                                        Môn: <c:out value="${scoreItem.subjectName}" /> &bull; <c:out value="${scoreItem.typeNameVi}" />
                                                    </div>
                                                    <div class="text-muted" style="font-size: 11px;">
                                                        Ngày thi: <c:out value="${scoreItem.formattedDate}" />
                                                    </div>
                                                </div>
                                                <div style="text-align: right; flex-shrink: 0;">
                                                    <div style="font-size: 20px; font-weight: 800; color: ${scoreItem.passed ? 'var(--success)' : 'var(--danger)'};">
                                                        <c:out value="${scoreItem.score}" />
                                                        <span style="font-size: 12px; font-weight: 500; color: var(--text-muted);">/<c:out value="${scoreItem.maxScore}" /></span>
                                                    </div>
                                                    <span class="badge ${scoreItem.passed ? 'badge-success' : 'badge-danger'}" style="font-size: 10px;">
                                                        <c:out value="${scoreItem.passed ? 'Đạt' : 'Cần cố gắng'}" />
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>
</body>
</html>
