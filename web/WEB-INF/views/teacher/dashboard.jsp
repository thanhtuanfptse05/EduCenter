<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: var(--shadow-sm);
        }
        .kpi-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .kpi-icon.blue { background: var(--primary-subtle); color: var(--primary); }
        .kpi-icon.green { background: var(--success-subtle); color: var(--success); }
        .kpi-icon.amber { background: var(--warning-subtle); color: var(--warning); }
        .kpi-icon.sky { background: var(--info-subtle); color: var(--info); }
        .kpi-val { font-size: 26px; font-weight: 700; color: var(--text); line-height: 1.2; }
        .kpi-lbl { font-size: 13px; color: var(--text-muted); margin-top: 2px; }

        .dashboard-section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }
        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }
        .session-card {
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 16px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            background: var(--bg);
        }
        .session-card:hover {
            border-color: var(--primary);
        }
        .empty-state {
            padding: 32px 16px;
            text-align: center;
            color: var(--text-muted);
            font-size: 14px;
        }
        .badge-draft { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; padding: 2px 8px; border-radius: var(--radius-xs); font-size: 12px; font-weight: 600; }
        .badge-published { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; padding: 2px 8px; border-radius: var(--radius-xs); font-size: 12px; font-weight: 600; }
        .status-pill { display: inline-flex; align-items: center; gap: 4px; padding: 3px 10px; border-radius: var(--radius-full); font-size: 12px; font-weight: 600; }
        .status-completed { background: #dcfce7; color: #15803d; }
        .status-scheduled { background: #eff6ff; color: #1d4ed8; }
        .status-cancelled { background: #fee2e2; color: #b91c1c; }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="teacher-dashboard" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Bàn làm việc giảng dạy" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Page Header -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <h1 class="page-title" style="margin: 0;">Bàn Làm Việc Giảng Dạy</h1>
                    <p class="page-subtitle" style="margin-top: 4px;">Xin chào Thầy/Cô <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong> · Quản lý lịch dạy, điểm danh và đánh giá học tập</p>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                        <span>Sổ điểm danh</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Bài kiểm tra</span>
                    </a>
                </div>
            </div>

            <!-- KPI Cards -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-icon blue">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><c:out value="${totalClassesCount}"/></div>
                        <div class="kpi-lbl">Lớp học phụ trách</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon sky">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><c:out value="${todaySessionsCount}"/></div>
                        <div class="kpi-lbl">Ca dạy hôm nay</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon green">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><c:out value="${completedSessionsCount}"/></div>
                        <div class="kpi-lbl">Buổi dạy đã hoàn thành</div>
                    </div>
                </div>

                <div class="kpi-card">
                    <div class="kpi-icon amber">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><c:out value="${assessmentsCount}"/></div>
                        <div class="kpi-lbl">Bài kiểm tra & Bảng điểm</div>
                    </div>
                </div>
            </div>

            <!-- Section 1: Ca dạy hôm nay -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        Lịch dạy hôm nay &amp; Thao tác nhanh
                    </h2>
                    <span style="font-size: 13px; color: var(--text-muted);">
                        Hôm nay: <c:out value="${todaySessionsCount}"/> ca dạy
                    </span>
                </div>

                <c:choose>
                    <c:when test="${not empty todaySessions}">
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <c:forEach var="s" items="${todaySessions}">
                                <div class="session-card">
                                    <div>
                                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                                            <span style="font-weight: 700; font-size: 15px; color: var(--text);"><c:out value="${s.classCode}"/></span>
                                            <span style="color: var(--text-muted);">—</span>
                                            <span style="font-weight: 500; font-size: 14px; color: var(--text);"><c:out value="${s.className}"/></span>
                                            <c:choose>
                                                <c:when test="${s.status == 'COMPLETED'}">
                                                    <span class="status-pill status-completed">Đã hoàn thành</span>
                                                </c:when>
                                                <c:when test="${s.status == 'CANCELLED'}">
                                                    <span class="status-pill status-cancelled">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill status-scheduled">Lên lịch</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div style="font-size: 13px; color: var(--text-muted); display: flex; align-items: center; gap: 16px; flex-wrap: wrap;">
                                            <span>
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" style="vertical-align: -2px;" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                                <c:out value="${s.startTime}"/> – <c:out value="${s.endTime}"/>
                                            </span>
                                            <span>
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" style="vertical-align: -2px;" aria-hidden="true"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                                Phòng: <c:out value="${empty s.roomName ? 'Chưa xếp phòng' : s.roomName}"/>
                                            </span>
                                            <span>
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" style="vertical-align: -2px;" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                                Sĩ số: <c:out value="${s.presentCount + s.lateCount + s.excusedCount + s.unexcusedCount}"/> HV
                                            </span>
                                        </div>
                                    </div>
                                    <div style="display: flex; gap: 8px;">
                                        <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${s.sessionId}" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                                            <span>Điểm danh</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/teacher/journal?sessionId=${s.sessionId}" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path></svg>
                                            <span>Nhật ký</span>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <svg class="icon icon-lg text-muted" viewBox="0 0 24 24" style="margin-bottom: 8px;" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                            <p style="margin: 0; font-weight: 500;">Hôm nay bạn không có ca dạy nào theo thời khóa biểu.</p>
                            <span style="font-size: 12px; color: var(--text-muted);">Kiểm tra lại toàn bộ lịch dạy trong tuần tại sổ điểm danh.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Section 2: Lớp học đang phụ trách -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                        Lớp học được phân công phụ trách
                    </h2>
                    <span style="font-size: 13px; color: var(--text-muted);"><c:out value="${totalClassesCount}"/> lớp</span>
                </div>

                <c:choose>
                    <c:when test="${not empty assignedClasses}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mã lớp</th>
                                        <th>Tên lớp học</th>
                                        <th>Khóa học / Môn học</th>
                                        <th>Phòng học</th>
                                        <th>Sức chứa</th>
                                        <th>Trạng thái</th>
                                        <th style="text-align: right;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${assignedClasses}">
                                        <tr>
                                            <td><strong><c:out value="${c.code}"/></strong></td>
                                            <td><c:out value="${c.name}"/></td>
                                            <td>
                                                <c:out value="${c.course != null ? c.course.name : '—'}"/>
                                                <c:if test="${c.course != null and c.course.subject != null}">
                                                    <span style="font-size: 12px; color: var(--text-muted);"> (<c:out value="${c.course.subject.name}"/>)</span>
                                                </c:if>
                                            </td>
                                            <td><c:out value="${c.room != null ? c.room.name : 'Chưa xếp phòng'}"/></td>
                                            <td><c:out value="${c.capacity}"/> học viên</td>
                                            <td>
                                                <span class="status-pill status-scheduled"><c:out value="${c.status}"/></span>
                                            </td>
                                            <td style="text-align: right;">
                                                <a href="${pageContext.request.contextPath}/teacher/assessments?classId=${c.id}" class="btn btn-secondary btn-sm" title="Quản lý bài kiểm tra của lớp">
                                                    Bài kiểm tra
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p style="margin: 0; font-weight: 500;">Chưa có lớp học nào được phân công cho tài khoản của bạn.</p>
                            <span style="font-size: 12px; color: var(--text-muted);">Vui lòng liên hệ Bộ phận Giáo vụ để nhận lịch phân công lớp mới.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Section 3: Bài kiểm tra gần đây & Bảng điểm -->
            <div class="dashboard-section">
                <div class="section-header">
                    <h2 class="section-title">
                        <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                        Bài kiểm tra gần đây
                    </h2>
                    <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-ghost btn-sm" style="font-size: 13px;">Xem tất cả</a>
                </div>

                <c:choose>
                    <c:when test="${not empty assessments}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Tên bài kiểm tra</th>
                                        <th>Lớp học</th>
                                        <th>Ngày thi</th>
                                        <th>Trọng số</th>
                                        <th>Trạng thái</th>
                                        <th style="text-align: right;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="a" items="${assessments}">
                                        <tr>
                                            <td><strong><c:out value="${a.name}"/></strong></td>
                                            <td><c:out value="${a.className}"/> (<c:out value="${a.classCode}"/>)</td>
                                            <td><c:out value="${a.testDate}"/></td>
                                            <td><c:out value="${a.weight}"/>x (Thang <c:out value="${a.maxScore}"/>)</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${a.status == 'PUBLISHED'}">
                                                        <span class="badge-published">ĐÃ CÔNG BỐ</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-draft">BẢN NHÁP</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align: right;">
                                                <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" class="btn btn-secondary btn-sm">
                                                    <c:choose>
                                                        <c:when test="${a.status == 'PUBLISHED'}">Xem bảng điểm</c:when>
                                                        <c:otherwise>Nhập điểm</c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p style="margin: 0; font-weight: 500;">Chưa có bài kiểm tra nào được tạo.</p>
                            <span style="font-size: 12px; color: var(--text-muted);">Bấm vào nút "Tạo bài kiểm tra" ở đầu trang để lập bảng điểm cho lớp của bạn.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
</body>
</html>
