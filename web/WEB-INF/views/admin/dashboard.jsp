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
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 1200px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .kpi-grid { grid-template-columns: 1fr; }
        }
        .kpi-card {
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
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .kpi-card.accent-primary { border-left: 4px solid var(--primary); }
        .kpi-card.accent-success { border-left: 4px solid var(--success); }
        .kpi-card.accent-warning { border-left: 4px solid var(--warning); }
        .kpi-card.accent-info { border-left: 4px solid #3B82F6; }

        .kpi-icon-wrap {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .kpi-icon-wrap.primary { background: var(--primary-subtle); color: var(--primary); }
        .kpi-icon-wrap.success { background: var(--success-subtle); color: var(--success); }
        .kpi-icon-wrap.warning { background: var(--warning-subtle); color: var(--warning); }
        .kpi-icon-wrap.info { background: #EFF6FF; color: #3B82F6; }

        .kpi-val {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text);
            line-height: 1.2;
        }
        .kpi-lbl {
            font-size: 0.8125rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .charts-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            margin-bottom: 24px;
        }
        @media (max-width: 992px) {
            .charts-row { grid-template-columns: 1fr; }
        }

        .tables-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .tables-row { grid-template-columns: 1fr; }
        }

        /* SVG Bar Chart Styling */
        .chart-container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            box-shadow: var(--shadow-sm);
        }
        .bar-chart-wrap {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            height: 220px;
            padding-top: 20px;
            border-bottom: 1px solid var(--border);
            gap: 12px;
        }
        .bar-col {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100%;
            justify-content: flex-end;
        }
        .bar-fill {
            width: 100%;
            max-width: 44px;
            background: linear-gradient(180deg, var(--primary) 0%, rgba(13, 148, 136, 0.6) 100%);
            border-radius: var(--radius-sm) var(--radius-sm) 0 0;
            transition: height 0.5s ease;
            position: relative;
        }
        .bar-col:hover .bar-fill {
            background: var(--primary-hover);
        }
        .bar-label {
            margin-top: 8px;
            font-size: 0.75rem;
            font-weight: 500;
            color: var(--text-muted);
        }
        .bar-tooltip {
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 4px;
            color: var(--text);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="dashboard" scope="request" />
    <c:set var="breadcrumb" value="Bảng điều khiển Giám đốc & Quản trị" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Header title & Action -->
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">Bảng điều khiển Giám đốc & Quản trị</h1>
                    <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Tổng quan tình hình tài chính học phí, tuyển sinh và vận hành đào tạo.</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <span>Xem Báo cáo Thống kê Chi tiết</span>
                    </a>
                </div>
            </div>

            <!-- KPI Row 1: Tài chính & Học vụ -->
            <div class="kpi-grid">
                <div class="kpi-card accent-success">
                    <div class="kpi-icon-wrap success">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><fmt:formatNumber value="${dashboard.monthRevenue}" pattern="#,###"/> đ</div>
                        <div class="kpi-lbl">Thực thu tháng này</div>
                    </div>
                </div>

                <div class="kpi-card accent-warning">
                    <div class="kpi-icon-wrap warning">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><fmt:formatNumber value="${dashboard.outstandingDebt}" pattern="#,###"/> đ</div>
                        <div class="kpi-lbl">Công nợ học phí chưa thu</div>
                    </div>
                </div>

                <div class="kpi-card accent-primary">
                    <div class="kpi-icon-wrap primary">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><fmt:formatNumber value="${dashboard.activeStudentsCount}" pattern="#,###"/></div>
                        <div class="kpi-lbl">Học viên đang học</div>
                    </div>
                </div>

                <div class="kpi-card accent-info">
                    <div class="kpi-icon-wrap info">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><fmt:formatNumber value="${dashboard.openClassesCount}" pattern="#,###"/></div>
                        <div class="kpi-lbl">Lớp học đang vận hành</div>
                    </div>
                </div>
            </div>

            <!-- KPI Row 2: Chuyên cần & Tuyển sinh -->
            <div class="kpi-grid">
                <div class="kpi-card accent-primary">
                    <div class="kpi-icon-wrap primary">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 11 12 14 22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val">${dashboard.attendanceRate}%</div>
                        <div class="kpi-lbl">Tỷ lệ chuyên cần trung tâm</div>
                    </div>
                </div>

                <div class="kpi-card accent-info">
                    <div class="kpi-icon-wrap info">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><fmt:formatNumber value="${dashboard.newLeadsThisMonth}" pattern="#,###"/></div>
                        <div class="kpi-lbl">Lead mới tháng này</div>
                    </div>
                </div>

                <div class="kpi-card accent-success">
                    <div class="kpi-icon-wrap success">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val"><fmt:formatNumber value="${dashboard.enrolledLeadsCount}" pattern="#,###"/></div>
                        <div class="kpi-lbl">Lead chuyển đổi ghi danh</div>
                    </div>
                </div>

                <div class="kpi-card accent-warning">
                    <div class="kpi-icon-wrap warning">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                    </div>
                    <div>
                        <div class="kpi-val">${dashboard.leadConversionRate}%</div>
                        <div class="kpi-lbl">Tỷ lệ chuyển đổi Lead</div>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="charts-row">
                <!-- Monthly Revenue Chart -->
                <div class="chart-container">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <div>
                            <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 4px 0;">Xu hướng Doanh thu Học phí (6 tháng)</h3>
                            <p style="font-size: 0.8125rem; color: var(--text-muted); margin: 0;">Số tiền thực thu theo từng tháng dựa trên các phiếu thu đã xác nhận.</p>
                        </div>
                    </div>

                    <!-- Pure Dynamic CSS Bar Chart -->
                    <div class="bar-chart-wrap">
                        <c:set var="maxRev" value="1" />
                        <c:forEach var="item" items="${dashboard.monthlyRevenues}">
                            <c:if test="${item.revenue > maxRev}">
                                <c:set var="maxRev" value="${item.revenue}" />
                            </c:if>
                        </c:forEach>

                        <c:forEach var="item" items="${dashboard.monthlyRevenues}">
                            <c:set var="hPercent" value="${(item.revenue / maxRev) * 100}" />
                            <div class="bar-col">
                                <div class="bar-tooltip">
                                    <c:choose>
                                        <c:when test="${item.revenue > 0}">
                                            <fmt:formatNumber value="${item.revenue / 1000000}" maxFractionDigits="1"/>Tr
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="bar-fill" style="height: ${hPercent > 5 ? hPercent : 5}%;"></div>
                                <div class="bar-label">${item.label}</div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Lead Source Distribution Card -->
                <div class="chart-container">
                    <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 4px 0;">Nguồn Tuyển sinh & Lead</h3>
                    <p style="font-size: 0.8125rem; color: var(--text-muted); margin: 0 0 16px 0;">Phân bố kênh tiếp cận khách hàng tiềm năng.</p>

                    <c:choose>
                        <c:when test="${empty dashboard.leadSources}">
                            <div style="text-align: center; padding: 40px 0; color: var(--text-muted); font-size: 0.875rem;">
                                Chưa có dữ liệu nguồn khách hàng.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="display: flex; flex-direction: column; gap: 14px;">
                                <c:forEach var="src" items="${dashboard.leadSources}">
                                    <div>
                                        <div style="display: flex; justify-content: space-between; font-size: 0.875rem; margin-bottom: 6px;">
                                            <span style="font-weight: 500; color: var(--text);">${src.source}</span>
                                            <span style="color: var(--text-muted);">${src.enrolledCount}/${src.totalLeads} (${src.conversionRate}%)</span>
                                        </div>
                                        <div style="width: 100%; height: 8px; background: var(--bg-alt); border-radius: 4px; overflow: hidden;">
                                            <div style="width: ${src.conversionRate}%; height: 100%; background: var(--primary); border-radius: 4px;"></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Recent Activities Tables -->
            <div class="tables-row">
                <!-- Recent Payments Table -->
                <div class="chart-container" style="padding: 0; overflow: hidden;">
                    <div style="padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                        <h3 style="font-size: 1rem; font-weight: 600; color: var(--text); margin: 0;">Giao dịch Thu học phí Gần đây</h3>
                        <a href="${pageContext.request.contextPath}/staff/invoices" style="font-size: 0.8125rem; color: var(--primary); text-decoration: none;">Xem tất cả &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table" style="margin-bottom: 0;">
                            <thead>
                            <tr style="background: var(--bg-alt); color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">
                                <th style="padding: 10px 16px;">Mã phiếu</th>
                                <th style="padding: 10px 16px;">Học viên</th>
                                <th style="padding: 10px 16px;">Số tiền</th>
                                <th style="padding: 10px 16px;">Thời gian</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty dashboard.recentPayments}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 24px; color: var(--text-muted); font-size: 0.875rem;">Chưa có giao dịch thu học phí nào.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${dashboard.recentPayments}">
                                        <tr style="border-bottom: 1px solid var(--border);">
                                            <td style="padding: 10px 16px; font-weight: 600; font-size: 0.8125rem; color: var(--text);">${p.paymentCode}</td>
                                            <td style="padding: 10px 16px; font-size: 0.875rem;">${p.studentName != null ? p.studentName : 'N/A'}</td>
                                            <td style="padding: 10px 16px; font-weight: 600; color: var(--success); font-size: 0.875rem;">
                                                +<fmt:formatNumber value="${p.amount}" pattern="#,###"/> đ
                                            </td>
                                            <td style="padding: 10px 16px; font-size: 0.8125rem; color: var(--text-muted);">
                                                ${p.paidAt.toLocalDate()}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Recent Enrollments Table -->
                <div class="chart-container" style="padding: 0; overflow: hidden;">
                    <div style="padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                        <h3 style="font-size: 1rem; font-weight: 600; color: var(--text); margin: 0;">Học viên Mới Ghi danh Gần đây</h3>
                        <a href="${pageContext.request.contextPath}/staff/students" style="font-size: 0.8125rem; color: var(--primary); text-decoration: none;">Xem tất cả &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table" style="margin-bottom: 0;">
                            <thead>
                            <tr style="background: var(--bg-alt); color: var(--text-muted); font-size: 0.75rem; text-transform: uppercase;">
                                <th style="padding: 10px 16px;">Học viên</th>
                                <th style="padding: 10px 16px;">Lớp học</th>
                                <th style="padding: 10px 16px;">Khóa học</th>
                                <th style="padding: 10px 16px;">Ngày ghi danh</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty dashboard.recentEnrollments}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 24px; color: var(--text-muted); font-size: 0.875rem;">Chưa có lượt ghi danh học viên nào.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="e" items="${dashboard.recentEnrollments}">
                                        <tr style="border-bottom: 1px solid var(--border);">
                                            <td style="padding: 10px 16px; font-weight: 600; font-size: 0.875rem; color: var(--text);">${e.studentName}</td>
                                            <td style="padding: 10px 16px; font-size: 0.8125rem;">${e.className}</td>
                                            <td style="padding: 10px 16px; font-size: 0.8125rem; color: var(--text-muted);">${e.courseName}</td>
                                            <td style="padding: 10px 16px; font-size: 0.8125rem; color: var(--text-muted);">
                                                ${e.enrolledAt.toLocalDate()}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
