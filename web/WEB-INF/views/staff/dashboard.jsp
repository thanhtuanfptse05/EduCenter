<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <title>${pageTitle}</title>
    <style>
        .staff-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 1200px) {
            .staff-kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .staff-kpi-grid { grid-template-columns: 1fr; }
        }
        .staff-kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 18px 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 16px;
            transition: transform var(--transition-fast), box-shadow var(--transition-fast);
        }
        .staff-kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .staff-kpi-card.accent-info { border-left: 4px solid #0284C7; }
        .staff-kpi-card.accent-warning { border-left: 4px solid var(--warning); }
        .staff-kpi-card.accent-success { border-left: 4px solid var(--success); }
        .staff-kpi-card.accent-primary { border-left: 4px solid var(--primary); }

        .staff-kpi-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .staff-kpi-icon.info { background: #E0F2FE; color: #0284C7; }
        .staff-kpi-icon.warning { background: var(--warning-subtle); color: var(--warning); }
        .staff-kpi-icon.success { background: var(--success-subtle); color: var(--success); }
        .staff-kpi-icon.primary { background: var(--primary-subtle); color: var(--primary); }

        .staff-kpi-val {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text);
            line-height: 1.2;
        }
        .staff-kpi-lbl {
            font-size: 0.8125rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .dashboard-grid-2 {
            display: grid;
            grid-template-columns: 3fr 2fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        @media (max-width: 1024px) {
            .dashboard-grid-2 { grid-template-columns: 1fr; }
        }

        .card-header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
        }
        .card-header-flex h2 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .class-open-card {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .class-open-card:last-child {
            border-bottom: none;
        }
        .progress-bar-wrap {
            width: 100%;
            height: 6px;
            background: var(--surface-muted);
            border-radius: 9999px;
            overflow: hidden;
            margin-top: 4px;
        }
        .progress-bar-fill {
            height: 100%;
            border-radius: 9999px;
            background: var(--primary);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="dashboard" scope="request" />
    <c:set var="breadcrumb" value="Bàn làm việc Tuyển sinh & Chăm sóc Khách hàng" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Header title & Quick Actions -->
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">Bàn làm việc Tuyển sinh & Khách hàng</h1>
                    <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Theo dõi quy trình chăm sóc lead, lớp học tuyển sinh và chỉ số chuyển đổi thực tế.</p>
                </div>
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/staff/leads" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                        <span>Tiếp nhận Lead mới</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/staff/enrollments" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
                        <span>Ghi danh học viên</span>
                    </a>
                </div>
            </div>

            <!-- Flash alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- KPI Row: CRM & Tuyển sinh -->
            <div class="staff-kpi-grid">
                <div class="staff-kpi-card accent-info">
                    <div class="staff-kpi-icon info">
                        <svg class="icon icon-md" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 14"></polyline></svg>
                    </div>
                    <div>
                        <div class="staff-kpi-val">${leadStats['NEW'] != null ? leadStats['NEW'] : 0}</div>
                        <div class="staff-kpi-lbl">Lead mới tiếp nhận</div>
                    </div>
                </div>

                <div class="staff-kpi-card accent-warning">
                    <div class="staff-kpi-icon warning">
                        <svg class="icon icon-md" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                    </div>
                    <div>
                        <div class="staff-kpi-val">${leadStats['CONSULTING'] != null ? leadStats['CONSULTING'] : 0}</div>
                        <div class="staff-kpi-lbl">Đang tư vấn & hẹn test</div>
                    </div>
                </div>

                <div class="staff-kpi-card accent-success">
                    <div class="staff-kpi-icon success">
                        <svg class="icon icon-md" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    </div>
                    <div>
                        <div class="staff-kpi-val">${leadStats['ENROLLED'] != null ? leadStats['ENROLLED'] : 0}</div>
                        <div class="staff-kpi-lbl">Đã chuyển đổi thành công</div>
                    </div>
                </div>

                <div class="staff-kpi-card accent-primary">
                    <div class="staff-kpi-icon primary">
                        <svg class="icon icon-md" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                    </div>
                    <div>
                        <div class="staff-kpi-val">${leadStats['TOTAL'] != null ? leadStats['TOTAL'] : 0}</div>
                        <div class="staff-kpi-lbl">Tổng cơ hội CRM</div>
                    </div>
                </div>
            </div>

            <!-- Main Section 2 Columns -->
            <div class="dashboard-grid-2">
                <!-- Left: Khách hàng cần chăm sóc -->
                <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden;">
                    <div class="card-header-flex">
                        <h2>
                            <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                            <span>Khách hàng phân công & Cần liên hệ</span>
                        </h2>
                        <a href="${pageContext.request.contextPath}/staff/leads" class="btn btn-secondary btn-sm" style="font-size: 12px;">Xem tất cả CRM &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="data-table" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 1px solid var(--border); background: var(--surface-muted); font-size: 12px; text-transform: uppercase; color: var(--text-muted); text-align: left;">
                                    <th style="padding: 12px 16px;">Khách hàng</th>
                                    <th style="padding: 12px 16px;">Khối lớp</th>
                                    <th style="padding: 12px 16px;">Trạng thái</th>
                                    <th style="padding: 12px 16px;">Phụ trách</th>
                                    <th style="padding: 12px 16px; text-align: right;">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty myLeads}">
                                        <c:forEach var="lead" items="${myLeads}">
                                            <tr style="border-bottom: 1px solid var(--border); font-size: 13px;">
                                                <td style="padding: 12px 16px;">
                                                    <div style="font-weight: 600; color: var(--text);"><c:out value="${empty lead.name ? lead.fullName : lead.name}" /></div>
                                                    <div style="font-size: 12px; color: var(--primary);"><c:out value="${lead.phone}" /></div>
                                                </td>
                                                <td style="padding: 12px 16px;">
                                                    <span class="badge badge-info" style="font-size: 11px;">Khối <c:out value="${lead.gradeLevel}" /></span>
                                                </td>
                                                <td style="padding: 12px 16px;">
                                                    <c:choose>
                                                        <c:when test="${lead.status == 'NEW'}"><span class="badge" style="background: #E0F2FE; color: #0284C7;">Mới tiếp nhận</span></c:when>
                                                        <c:when test="${lead.status == 'CONSULTING'}"><span class="badge" style="background: var(--warning-subtle); color: var(--warning);">Đang tư vấn</span></c:when>
                                                        <c:when test="${lead.status == 'ASSESSED'}"><span class="badge badge-info">Đã test trình độ</span></c:when>
                                                        <c:when test="${lead.status == 'ENROLLED'}"><span class="badge" style="background: var(--success-subtle); color: var(--success);">Đã nhập học</span></c:when>
                                                        <c:otherwise><span class="badge badge-neutral"><c:out value="${lead.status}" /></span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 12px 16px;">
                                                    <c:choose>
                                                        <c:when test="${not empty lead.assignedToName}">
                                                            <span style="font-size: 12px; color: var(--text);"><c:out value="${lead.assignedToName}" /></span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="font-size: 12px; color: var(--warning); font-weight: 600;">Chưa phân công</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 12px 16px; text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/staff/leads/detail?id=${lead.id}" class="btn btn-secondary btn-sm" style="font-size: 12px; padding: 4px 10px;">
                                                        Chi tiết
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" style="padding: 32px; text-align: center; color: var(--text-muted); font-size: 13px;">
                                                Hiện chưa có khách hàng nào được phân công.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Right: Lớp học đang mở tuyển sinh -->
                <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden;">
                    <div class="card-header-flex">
                        <h2>
                            <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            <span>Lớp học mở tuyển sinh</span>
                        </h2>
                        <a href="${pageContext.request.contextPath}/staff/classes" class="btn btn-secondary btn-sm" style="font-size: 12px;">Tra cứu sĩ số &rarr;</a>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${not empty openClasses}">
                                <c:forEach var="c" items="${openClasses}">
                                    <div class="class-open-card">
                                        <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 8px;">
                                            <div>
                                                <div style="font-weight: 600; font-size: 14px; color: var(--text);">
                                                    <c:out value="${c.name}" />
                                                </div>
                                                <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                                    Môn: <strong><c:out value="${c.subjectName}" /></strong> &bull; Khối ${c.gradeLevel} &bull; GV: <c:out value="${c.teacherName}" />
                                                </div>
                                            </div>
                                            <span class="badge" style="background: var(--success-subtle); color: var(--success); font-size: 11px;">Đang mở</span>
                                        </div>
                                        <div>
                                            <div style="display: flex; justify-content: space-between; font-size: 12px; color: var(--text-muted);">
                                                <span>Sĩ số: <strong>${c.currentEnrollment} / ${c.maxCapacity}</strong> học viên</span>
                                                <span>Còn trống: <strong style="color: var(--primary);">${c.maxCapacity - c.currentEnrollment}</strong> chỗ</span>
                                            </div>
                                            <div class="progress-bar-wrap">
                                                <c:set var="fillPct" value="${c.maxCapacity > 0 ? (c.currentEnrollment * 100 / c.maxCapacity) : 0}" />
                                                <div class="progress-bar-fill" style="width: ${fillPct}%;"></div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 32px; text-align: center; color: var(--text-muted); font-size: 13px;">
                                    Hiện chưa có lớp học nào ở trạng thái mở tuyển sinh.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Bottom: Ghi danh gần đây -->
            <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden;">
                <div class="card-header-flex">
                    <h2>
                        <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
                        <span>Danh sách Ghi danh mới nhất</span>
                    </h2>
                    <a href="${pageContext.request.contextPath}/staff/enrollments" class="btn btn-secondary btn-sm" style="font-size: 12px;">Xem toàn bộ ghi danh &rarr;</a>
                </div>
                <div class="table-responsive">
                    <table class="data-table" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="border-bottom: 1px solid var(--border); background: var(--surface-muted); font-size: 12px; text-transform: uppercase; color: var(--text-muted); text-align: left;">
                                <th style="padding: 12px 16px;">Học viên</th>
                                <th style="padding: 12px 16px;">Lớp đăng ký</th>
                                <th style="padding: 12px 16px;">Ngày ghi danh</th>
                                <th style="padding: 12px 16px;">Trạng thái học vụ</th>
                                <th style="padding: 12px 16px; text-align: right;">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty recentEnrollments}">
                                    <c:forEach var="enr" items="${recentEnrollments}">
                                        <tr style="border-bottom: 1px solid var(--border); font-size: 13px;">
                                            <td style="padding: 12px 16px;">
                                                <div style="font-weight: 600; color: var(--text);"><c:out value="${enr.studentName}" /></div>
                                                <div style="font-size: 12px; color: var(--text-muted);"><c:out value="${enr.studentCode}" /> &bull; <c:out value="${enr.studentPhone}" /></div>
                                            </td>
                                            <td style="padding: 12px 16px;">
                                                <div style="font-weight: 500; color: var(--text);"><c:out value="${enr.className}" /></div>
                                                <div style="font-size: 12px; color: var(--text-muted);"><c:out value="${enr.classCode}" /> &bull; Khối ${enr.gradeLevel}</div>
                                            </td>
                                            <td style="padding: 12px 16px; color: var(--text-muted); font-size: 12px;">
                                                <c:out value="${enr.enrolledAtFormatted}" />
                                            </td>
                                            <td style="padding: 12px 16px;">
                                                <c:choose>
                                                    <c:when test="${enr.status == 'ENROLLED'}">
                                                        <span class="badge" style="background: var(--success-subtle); color: var(--success);">Đang theo học</span>
                                                    </c:when>
                                                    <c:when test="${enr.status == 'RESERVED'}">
                                                        <span class="badge" style="background: var(--warning-subtle); color: var(--warning);">Đang bảo lưu</span>
                                                    </c:when>
                                                    <c:when test="${enr.status == 'DROPPED'}">
                                                        <span class="badge" style="background: #FEE2E2; color: #DC2626;">Đã thôi học</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-neutral"><c:out value="${enr.status}" /></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="padding: 12px 16px; text-align: right;">
                                                <a href="${pageContext.request.contextPath}/staff/enrollments/detail?id=${empty enr.id ? enr.enrollmentId : enr.id}" class="btn btn-secondary btn-sm" style="font-size: 12px; padding: 4px 10px;">
                                                    Xem chi tiết
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="5" style="padding: 32px; text-align: center; color: var(--text-muted); font-size: 13px;">
                                            Chưa có hồ sơ ghi danh nào được ghi nhận.
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
