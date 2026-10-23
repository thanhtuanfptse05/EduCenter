<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="student-dashboard" scope="request" />
    <c:set var="breadcrumb" value="Tổng quan học tập" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Alert Messages -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <c:choose>
                <%-- Trạng thái chưa gắn hồ sơ học sinh --%>
                <c:when test="${empty dashboard.studentId}">
                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Chào mừng bạn đến với EduCenter!</h1>
                            <p class="page-subtitle">Tài khoản học viên đang chờ kết nối hồ sơ học vụ</p>
                        </div>
                    </div>
                    <div class="empty-state-card" style="background: var(--surface); border: 1px dashed var(--border); border-radius: var(--radius-lg); padding: 48px 24px; text-align: center; margin-top: 16px;">
                        <div style="width: 64px; height: 64px; border-radius: 50%; background: var(--warning-subtle); color: var(--warning); display: inline-flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                            <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                        </div>
                        <h2 style="font-size: 18px; font-weight: 700; color: var(--text); margin-bottom: 8px;">Hồ sơ học viên chưa được liên kết</h2>
                        <p class="text-muted" style="max-width: 520px; margin: 0 auto 20px; line-height: 1.5; font-size: 14px;">
                            Tài khoản <strong><c:out value="${sessionScope.currentUser.email}" /></strong> chưa được gắn mã hồ sơ học sinh trong cơ sở dữ liệu. Vui lòng liên hệ Phòng Giáo vụ hoặc Đăng ký khóa học mới để được xếp lớp và cấp mã học viên.
                        </p>
                        <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                    <path d="M6 6h10"></path>
                                    <path d="M6 10h10"></path>
                                </svg>
                                <span>Khám phá khóa học</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">Xem hồ sơ cá nhân</a>
                        </div>
                    </div>
                </c:when>

                <%-- Trạng thái học sinh đã có hồ sơ và dữ liệu --%>
                <c:otherwise>
                    <!-- Page Title & Student Badge -->
                    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                        <div>
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
                                <h1 class="page-title" style="margin: 0;">Xin chào, <c:out value="${dashboard.studentName}" />!</h1>
                                <span class="badge badge-info" style="font-size: 12px; font-weight: 600;"><c:out value="${dashboard.studentCode}" /></span>
                            </div>
                            <p class="page-subtitle" style="margin: 0;">
                                Học sinh Khối <c:out value="${dashboard.gradeLevel}" /> &bull; Trường: <c:out value="${empty dashboard.school ? 'EduCenter Academy' : dashboard.school}" />
                            </p>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <a href="${pageContext.request.contextPath}/student/schedule" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                <span>Xem lịch học</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/student/progress" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                                <span>Bảng điểm chi tiết</span>
                            </a>
                        </div>
                    </div>

                    <!-- KPI Summary Cards -->
                    <div class="kpi-grid">
                        <!-- Card 1: Số lớp đang học -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Lớp đang theo học</div>
                                <div class="kpi-value"><c:out value="${dashboard.enrolledClassCount}" /></div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                    <path d="M6 6h10"></path>
                                    <path d="M6 10h10"></path>
                                </svg>
                            </div>
                        </div>

                        <!-- Card 2: Chuyên cần -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Tỷ lệ chuyên cần</div>
                                <div class="kpi-value" style="color: var(--success);"><c:out value="${dashboard.attendanceSummary.attendanceRateFormatted}" /></div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                        </div>

                        <!-- Card 3: Điểm trung bình -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Điểm kiểm tra TB</div>
                                <div class="kpi-value" style="color: var(--primary);">
                                    <c:choose>
                                        <c:when test="${not empty dashboard.averageScore}"><c:out value="${dashboard.averageScore}" />/10</c:when>
                                        <c:otherwise>Chưa có</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--warning-subtle); color: var(--warning); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="8" r="6"></circle>
                                    <path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path>
                                </svg>
                            </div>
                        </div>

                        <!-- Card 4: Ca học sắp tới -->
                        <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <div class="kpi-label">Lịch học sắp tới</div>
                                <div class="kpi-value"><c:out value="${dashboard.upcomingSessions.size()}" /> buổi</div>
                            </div>
                            <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--info-subtle); color: var(--info); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <!-- 2-Column Dashboard Grid -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 24px; margin-top: 24px;">
                        <!-- Col 1: Lịch học sắp tới -->
                        <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0; display: flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                    <span>Lịch học kế tiếp</span>
                                </h2>
                                <a href="${pageContext.request.contextPath}/student/schedule" style="font-size: 13px; font-weight: 600; color: var(--primary); text-decoration: none;">Xem tất cả &rarr;</a>
                            </div>

                            <c:choose>
                                <c:when test="${empty dashboard.upcomingSessions}">
                                    <div class="empty-state" style="padding: 32px 16px; text-align: center;">
                                        <p class="text-muted" style="margin: 0; font-size: 13px;">Bạn chưa có buổi học nào sắp diễn ra trong tuần này.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; flex-direction: column; gap: 12px;">
                                        <c:forEach var="sessionItem" items="${dashboard.upcomingSessions}">
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

                        <!-- Col 2: Kết quả bài kiểm tra gần nhất -->
                        <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                                <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0; display: flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>
                                    <span>Điểm kiểm tra đã công bố</span>
                                </h2>
                                <a href="${pageContext.request.contextPath}/student/progress" style="font-size: 13px; font-weight: 600; color: var(--primary); text-decoration: none;">Xem chi tiết &rarr;</a>
                            </div>

                            <c:choose>
                                <c:when test="${empty dashboard.recentScores}">
                                    <div class="empty-state" style="padding: 32px 16px; text-align: center;">
                                        <p class="text-muted" style="margin: 0; font-size: 13px;">Chưa có bài kiểm tra nào được công bố điểm.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="display: flex; flex-direction: column; gap: 12px;">
                                        <c:forEach var="scoreItem" items="${dashboard.recentScores}">
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

                    <!-- Section: Lớp học đang tham gia -->
                    <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-top: 24px;">
                        <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0 0 16px 0; display: flex; align-items: center; gap: 8px;">
                            <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <span>Danh sách lớp học đang tham gia</span>
                        </h2>
                        <c:choose>
                            <c:when test="${empty dashboard.enrolledClasses}">
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
                                            <c:forEach var="cl" items="${dashboard.enrolledClasses}">
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
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>
</body>
</html>
