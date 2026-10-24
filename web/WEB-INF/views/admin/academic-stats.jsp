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
    <c:set var="activeNav" value="academic-stats" scope="request" />
    <c:set var="breadcrumb" value="Thống kê Giảng dạy & Học vụ" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <h1 class="page-title">Thống kê Giảng dạy &amp; Học vụ</h1>
                    <p class="page-subtitle">Theo dõi tỷ lệ chuyên cần, điểm kiểm tra và tiến độ các lớp học trên toàn trung tâm</p>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        <span>Quản lý lớp học</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/timetable" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span>Thời khóa biểu tuần</span>
                    </a>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Filter Bar -->
            <div class="card" style="padding: 16px 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); margin-bottom: 24px;">
                <form action="${pageContext.request.contextPath}/admin/academic-stats" method="get" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 180px;">
                        <label class="form-label" for="fromDate" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Từ ngày:</label>
                        <input type="date" id="fromDate" name="fromDate" class="form-control" value="<c:out value='${filter.fromDate}' />">
                    </div>
                    <div style="flex: 1; min-width: 180px;">
                        <label class="form-label" for="toDate" style="font-size: 12px; font-weight: 600; margin-bottom: 6px; display: block;">Đến ngày:</label>
                        <input type="date" id="toDate" name="toDate" class="form-control" value="<c:out value='${filter.toDate}' />">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary" style="height: 38px; display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            <span>Lọc dữ liệu thống kê</span>
                        </button>
                    </div>
                </form>
            </div>

            <!-- 4 Top KPI Cards Grid -->
            <div class="kpi-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; margin-bottom: 24px;">
                <!-- KPI 1: Chuyên cần -->
                <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <div>
                            <div style="font-size: 13px; color: var(--text-muted); font-weight: 500;">Tỷ lệ Chuyên cần toàn hệ thống</div>
                            <div style="font-size: 28px; font-weight: 700; color: var(--text); margin: 6px 0;">
                                <c:out value="${report.attendanceRate}" />%
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted);">
                                <span style="color: var(--success); font-weight: 600;"><c:out value="${report.presentCount}" /></span> đúng giờ &bull;
                                <span style="color: var(--warning); font-weight: 600;"><c:out value="${report.lateCount}" /></span> muộn
                            </div>
                        </div>
                        <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                        </div>
                    </div>
                </div>

                <!-- KPI 2: Điểm TB bài kiểm tra -->
                <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <div>
                            <div style="font-size: 13px; color: var(--text-muted); font-weight: 500;">Điểm kiểm tra trung bình</div>
                            <div style="font-size: 28px; font-weight: 700; color: var(--primary); margin: 6px 0;">
                                <c:out value="${report.avgScore}" /> <span style="font-size: 14px; font-weight: 500; color: var(--text-muted);">/ 10</span>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted);">
                                Min: <strong><c:out value="${report.minScore}" /></strong> &bull; Max: <strong><c:out value="${report.maxScore}" /></strong> (Tổng <c:out value="${report.totalScoresCount}" /> bài)
                            </div>
                        </div>
                        <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                        </div>
                    </div>
                </div>

                <!-- KPI 3: Quy mô Lớp học -->
                <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <div>
                            <div style="font-size: 13px; color: var(--text-muted); font-weight: 500;">Quy mô &amp; Lớp học</div>
                            <div style="font-size: 28px; font-weight: 700; color: var(--text); margin: 6px 0;">
                                <c:out value="${classStats.ongoingClasses}" /> <span style="font-size: 14px; font-weight: 500; color: var(--text-muted);">/ <c:out value="${classStats.totalClasses}" /> lớp</span>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted);">
                                <c:out value="${classStats.openClasses}" /> lớp đang tuyển &bull; Sĩ số TB: <strong><c:out value="${report.avgClassCapacity}" /></strong> HV/lớp
                            </div>
                        </div>
                        <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--info-subtle); color: var(--info); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        </div>
                    </div>
                </div>

                <!-- KPI 4: Nghỉ học cần lưu ý -->
                <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <div>
                            <div style="font-size: 13px; color: var(--text-muted); font-weight: 500;">Lượt vắng học trong kỳ</div>
                            <div style="font-size: 28px; font-weight: 700; color: ${report.unexcusedCount > 0 ? 'var(--danger)' : 'var(--text)'}; margin: 6px 0;">
                                <c:out value="${report.excusedCount + report.unexcusedCount}" /> <span style="font-size: 14px; font-weight: 500; color: var(--text-muted);">buổi</span>
                            </div>
                            <div style="font-size: 12px; color: var(--text-muted);">
                                <span style="color: var(--warning);"><c:out value="${report.excusedCount}" /></span> có phép &bull;
                                <span style="color: var(--danger); font-weight: 600;"><c:out value="${report.unexcusedCount}" /></span> không phép
                            </div>
                        </div>
                        <div style="width: 44px; height: 44px; border-radius: 10px; background: var(--danger-subtle); color: var(--danger); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Breakdown & Class Status Table Grid -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 24px;">
                <!-- Table: Danh sách Giảng dạy theo Lớp học -->
                <div class="card" style="padding: 20px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <div>
                            <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">Danh sách Lớp học &amp; Đội ngũ Giáo viên phụ trách</h2>
                            <p style="font-size: 13px; color: var(--text-muted); margin: 4px 0 0;">Tổng hợp phân công giảng dạy, địa điểm phòng học và sĩ số hiện hành của từng lớp</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-ghost btn-sm" style="font-size: 12px; display: inline-flex; align-items: center; gap: 4px;">
                            <span>Chi tiết hồ sơ lớp</span>
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${empty classes}">
                            <div class="empty-state" style="padding: 40px 16px; text-align: center;">
                                <p class="text-muted" style="margin: 0;">Chưa có lớp học nào trong hệ thống.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="data-table" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr style="border-bottom: 1px solid var(--border); text-align: left; font-size: 12px; color: var(--text-muted); text-transform: uppercase;">
                                            <th style="padding: 12px;">Mã &amp; Tên lớp</th>
                                            <th style="padding: 12px;">Khóa học &amp; Môn</th>
                                            <th style="padding: 12px;">Giáo viên giảng dạy</th>
                                            <th style="padding: 12px;">Phòng học</th>
                                            <th style="padding: 12px;">Sĩ số / Sức chứa</th>
                                            <th style="padding: 12px;">Thời gian</th>
                                            <th style="padding: 12px;">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cl" items="${classes}">
                                            <tr style="border-bottom: 1px solid var(--border); font-size: 13px;">
                                                <td style="padding: 12px;">
                                                    <div style="font-weight: 600; color: var(--text);"><c:out value="${cl.code}" /></div>
                                                    <div class="text-muted" style="font-size: 12px;"><c:out value="${cl.name}" /></div>
                                                </td>
                                                <td style="padding: 12px;">
                                                    <div style="color: var(--text); font-weight: 500;"><c:out value="${cl.courseName}" /></div>
                                                    <div class="text-muted" style="font-size: 11px;">Mã: <c:out value="${cl.courseCode}" /></div>
                                                </td>
                                                <td style="padding: 12px;">
                                                    <c:choose>
                                                        <c:when test="${not empty cl.teacherName}">
                                                            <div style="font-weight: 500; color: var(--text); display: flex; align-items: center; gap: 6px;">
                                                                <svg class="icon icon-xs" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                                                <span><c:out value="${cl.teacherName}" /></span>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-warning" style="font-size: 11px;">Chưa phân công</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 12px;">
                                                    <c:out value="${empty cl.roomName ? 'Chưa phân phòng' : cl.roomName}" />
                                                </td>
                                                <td style="padding: 12px;">
                                                    <div style="font-weight: 600; color: var(--text);">
                                                        <c:out value="${cl.enrolledCount}" /> / <c:out value="${cl.capacity}" />
                                                    </div>
                                                    <c:if test="${cl.capacity > 0}">
                                                        <div style="height: 4px; background: var(--border); border-radius: 2px; width: 80px; margin-top: 4px; overflow: hidden;">
                                                            <div style="height: 100%; background: var(--primary); width: ${cl.enrolledCount * 100 / cl.capacity}%;"></div>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td style="padding: 12px; font-size: 12px; color: var(--text-muted);">
                                                    <c:out value="${cl.startDate}" /> &rarr; <c:out value="${cl.endDate}" />
                                                </td>
                                                <td style="padding: 12px;">
                                                    <c:choose>
                                                        <c:when test="${cl.status == 'OPEN'}">
                                                            <span class="badge badge-info">Đang tuyển</span>
                                                        </c:when>
                                                        <c:when test="${cl.status == 'ONGOING'}">
                                                            <span class="badge badge-success">Đang giảng dạy</span>
                                                        </c:when>
                                                        <c:when test="${cl.status == 'CLOSED'}">
                                                            <span class="badge badge-neutral">Đã kết thúc</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-danger"><c:out value="${cl.status}" /></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
