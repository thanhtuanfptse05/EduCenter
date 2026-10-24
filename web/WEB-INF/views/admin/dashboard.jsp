<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_06">
    <title>${pageTitle} | EduCenter ERP</title>
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
            <!-- 1. Top Level Header / Context Area -->
            <div class="admin-header-row">
                <div style="max-width: 760px;">
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px;">
                        <span class="admin-badge-module">
                            <span class="live-pulse-dot"></span>
                            Module M11 • ADM-01
                        </span>
                        <span style="font-size: 12.5px; color: var(--text-muted);">Đồng bộ tự động • Trực tuyến</span>
                    </div>
                    <h1 class="page-title" style="margin: 0 0 4px 0; letter-spacing: -0.02em;">
                        Bảng Điều Khiển Giám Đốc & Quản Trị
                    </h1>
                    <p class="page-subtitle" style="margin: 0;">
                        Tổng quan thời gian thực về tình hình tài chính học phí, chuyển đổi tuyển sinh, quy mô đào tạo và vận hành trung tâm.
                    </p>
                </div>
                <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                    <button type="button" class="btn btn-outline" onclick="window.print()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        <span>Xuất báo cáo PDF/Excel</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <span>+ Xem Báo Cáo Thống Kê Chi Tiết</span>
                    </a>
                </div>
            </div>

            <!-- 2. KPI Grid (8 Cards: 4 Cols x 2 Rows) -->
            <div class="kpi-grid-4">
                <!-- KPI 1: Thực thu tháng này -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top emerald"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Thực thu tháng này</div>
                            <div class="kpi-big-num"><fmt:formatNumber value="${dashboard.monthRevenue}" pattern="#,###"/> đ</div>
                        </div>
                        <div class="kpi-icon-square emerald">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--success); font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                            +14.2%
                        </span>
                        <span style="color: var(--text-muted);">so với tháng trước</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill emerald" style="width: 74%;"></div>
                    </div>
                </div>

                <!-- KPI 2: Công nợ học phí chưa thu -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top amber"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Công nợ học phí chưa thu</div>
                            <div class="kpi-big-num" style="color: var(--warning);"><fmt:formatNumber value="${dashboard.outstandingDebt}" pattern="#,###"/> đ</div>
                        </div>
                        <div class="kpi-icon-square amber">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="display: inline-flex; align-items: center; gap: 4px; padding: 2px 8px; border-radius: 4px; background: var(--warning-subtle); color: var(--warning); font-size: 11px; font-weight: 700;">
                            Cần thu hồi trước 15/11
                        </span>
                        <span style="color: var(--text-muted);">Tồn đọng</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill amber" style="width: 62%;"></div>
                    </div>
                </div>

                <!-- KPI 3: Học viên đang học -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top blue"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Học viên đang học</div>
                            <div class="kpi-big-num"><fmt:formatNumber value="${dashboard.activeStudentsCount}" pattern="#,###"/> học viên</div>
                        </div>
                        <div class="kpi-icon-square blue">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted);">Tỷ lệ lấp đầy quy mô</span>
                        <span style="color: var(--primary); font-weight: 700;">85% định mức</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill blue" style="width: 85%;"></div>
                    </div>
                </div>

                <!-- KPI 4: Lớp học đang vận hành -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top blue"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Lớp học đang vận hành</div>
                            <div class="kpi-big-num"><fmt:formatNumber value="${dashboard.openClassesCount}" pattern="#,###"/> lớp</div>
                        </div>
                        <div class="kpi-icon-square blue">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--success); font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                            Hoạt động ổn định
                        </span>
                        <span style="font-family: monospace; color: var(--text-muted);">100% phòng</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill blue" style="width: 100%;"></div>
                    </div>
                </div>

                <!-- KPI 5: Tỷ lệ chuyên cần trung tâm -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top emerald"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Tỷ lệ chuyên cần trung tâm</div>
                            <div class="kpi-big-num">${dashboard.attendanceRate}%</div>
                        </div>
                        <div class="kpi-icon-square emerald">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><polyline points="17 11 19 13 23 9"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--success); font-weight: 700;">Mục tiêu > 90%</span>
                        <span style="padding: 2px 8px; border-radius: 4px; background: var(--bg-alt); color: var(--text); font-weight: 600; font-size: 11px;">Đạt xuất sắc</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill emerald" style="width: ${dashboard.attendanceRate}%;"></div>
                    </div>
                </div>

                <!-- KPI 6: Lead mới tháng này -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top blue"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Lead mới tháng này</div>
                            <div class="kpi-big-num"><fmt:formatNumber value="${dashboard.newLeadsThisMonth}" pattern="#,###"/> khách hàng</div>
                        </div>
                        <div class="kpi-icon-square blue">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><path d="M11 8v6M8 11h6"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--primary); font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="7" y1="17" x2="17" y2="7"/><polyline points="7 7 17 7 17 17"/></svg>
                            +22%
                        </span>
                        <span style="color: var(--text-muted);">so với chu kỳ trước</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill blue" style="width: 68%;"></div>
                    </div>
                </div>

                <!-- KPI 7: Lead chuyển đổi ghi danh -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top emerald"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Lead chuyển đổi ghi danh</div>
                            <div class="kpi-big-num"><fmt:formatNumber value="${dashboard.enrolledLeadsCount}" pattern="#,###"/> học viên</div>
                        </div>
                        <div class="kpi-icon-square emerald">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted);">Tỷ lệ hoàn tất tư vấn</span>
                        <span style="font-family: monospace; color: var(--success); font-weight: 700;">${dashboard.leadConversionRate}%</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill emerald" style="width: ${dashboard.leadConversionRate}%;"></div>
                    </div>
                </div>

                <!-- KPI 8: Tỷ lệ chuyển đổi Lead -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top amber"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Tỷ lệ chuyển đổi Lead</div>
                            <div class="kpi-big-num">${dashboard.leadConversionRate}%</div>
                        </div>
                        <div class="kpi-icon-square amber">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 3v18h18"/><path d="m19 9-5 5-4-4-3 3"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--warning); font-weight: 600;">Hiệu quả tư vấn xuất sắc</span>
                        <span style="color: var(--warning); font-size: 14px;">★</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill amber" style="width: ${dashboard.leadConversionRate}%;"></div>
                    </div>
                </div>
            </div>

            <!-- 3. Analytics Section (2 Columns: Left 70% / Right 30%) -->
            <div class="analytics-grid-7-5">
                <!-- Revenue Trend Chart -->
                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <h2 style="font-size: 1.05rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">Xu hướng Doanh thu Học phí (6 tháng gần nhất)</h2>
                            <span style="font-size: 0.8125rem; color: var(--text-muted);">Số tiền thực thu theo từng tháng dựa trên các phiếu thu đã xác nhận</span>
                        </div>
                        <span style="font-size: 11.5px; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); background: var(--primary-subtle); color: var(--primary);">
                            VND Triệu
                        </span>
                    </div>

                    <!-- Dynamic CSS Bar Chart -->
                    <div class="chart-visual-box">
                        <div class="chart-grid-lines">
                            <div class="chart-grid-line"></div>
                            <div class="chart-grid-line"></div>
                            <div class="chart-grid-line"></div>
                            <div class="chart-grid-line"></div>
                        </div>

                        <c:set var="maxRev" value="1" />
                        <c:forEach var="item" items="${dashboard.monthlyRevenues}">
                            <c:if test="${item.revenue > maxRev}">
                                <c:set var="maxRev" value="${item.revenue}" />
                            </c:if>
                        </c:forEach>

                        <div class="chart-bars-wrap">
                            <c:forEach var="item" items="${dashboard.monthlyRevenues}">
                                <c:set var="hPercent" value="${(item.revenue / maxRev) * 100}" />
                                <c:set var="isPeak" value="${item.revenue == maxRev and item.revenue > 0}" />
                                <div class="chart-bar-item ${isPeak ? 'is-peak' : ''}">
                                    <c:if test="${isPeak}">
                                        <div class="chart-peak-tag">Đỉnh vụ hè</div>
                                    </c:if>
                                    <div class="chart-bar-val">
                                        <c:choose>
                                            <c:when test="${item.revenue > 0}">
                                                <fmt:formatNumber value="${item.revenue / 1000000}" maxFractionDigits="1"/> Tr
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="chart-bar-pillar" style="height: ${hPercent > 6 ? hPercent : 6}%;"></div>
                                    <div class="chart-bar-month">${item.label}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="chart-footer-strip">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/></svg>
                            <span>Mức tăng trưởng trung bình: <strong style="color: var(--primary);">+18.5%/tháng</strong></span>
                        </div>
                        <span style="color: var(--text-muted); font-size: 12px;">Dữ liệu đối soát tự động</span>
                    </div>
                </div>

                <!-- Lead Channels Structure -->
                <div class="analytics-card">
                    <div class="analytics-card-header">
                        <div>
                            <h2 style="font-size: 1.05rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">Cơ cấu Nguồn Tuyển sinh & Lead</h2>
                            <span style="font-size: 0.8125rem; color: var(--text-muted);">Phân bổ kênh tiếp cận khách hàng tiềm năng</span>
                        </div>
                        <span style="font-size: 12px; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); background: var(--bg-alt); color: var(--text); font-family: monospace;">
                            ${dashboard.newLeadsThisMonth} Leads
                        </span>
                    </div>

                    <div class="channel-list">
                        <c:choose>
                            <c:when test="${empty dashboard.leadSources}">
                                <div style="text-align: center; padding: 30px 0; color: var(--text-muted); font-size: 13px;">
                                    Chưa có dữ liệu nguồn khách hàng.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="src" items="${dashboard.leadSources}">
                                    <div class="channel-row">
                                        <div class="channel-header">
                                            <span class="channel-name">
                                                <span class="channel-dot" style="background: ${src.source == 'WEBSITE' ? 'var(--primary)' : (src.source == 'FACEBOOK' ? 'var(--success)' : (src.source == 'WALK_IN' ? 'var(--warning)' : '#8b5cf6'))};"></span>
                                                ${src.source}
                                            </span>
                                            <div style="display: flex; align-items: center; gap: 6px;">
                                                <span class="channel-count">${src.enrolledCount}/${src.totalLeads}</span>
                                                <span style="font-size: 11.5px; color: var(--text-muted);">(${src.conversionRate}%)</span>
                                            </div>
                                        </div>
                                        <div class="channel-bar-track">
                                            <div class="channel-bar-fill" style="width: ${src.conversionRate}%; background: ${src.source == 'WEBSITE' ? 'var(--primary)' : (src.source == 'FACEBOOK' ? 'var(--success)' : (src.source == 'WALK_IN' ? 'var(--warning)' : '#8b5cf6'))};"></div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="chart-footer-strip">
                        <span style="color: var(--text-muted);">Chi phí bình quân / Lead</span>
                        <span style="font-family: monospace; font-weight: 700; color: var(--text);">145.000 đ</span>
                    </div>
                </div>
            </div>

            <!-- 4. Recent Tables Section (2 Columns) -->
            <div class="tables-grid-2">
                <!-- Left Table: Recent Transactions -->
                <div class="recent-table-card">
                    <div class="recent-table-header">
                        <h2>
                            <svg style="width: 18px; height: 18px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                            <span>Giao dịch Thu học phí Gần đây</span>
                        </h2>
                        <a href="${pageContext.request.contextPath}/staff/invoices">
                            <span>Xem tất cả hóa đơn</span>
                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table" style="margin-bottom: 0;">
                            <thead>
                            <tr style="background: var(--bg-alt); color: var(--text-muted); font-size: 11.5px; text-transform: uppercase; letter-spacing: 0.04em;">
                                <th style="padding: 10px 16px;">Mã phiếu</th>
                                <th style="padding: 10px 16px;">Học viên & Khóa học</th>
                                <th style="padding: 10px 16px; text-align: right;">Số tiền</th>
                                <th style="padding: 10px 16px; text-align: right;">Thời gian</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty dashboard.recentPayments}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 28px; color: var(--text-muted); font-size: 13px;">Chưa có giao dịch thu học phí nào.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="p" items="${dashboard.recentPayments}">
                                        <tr style="border-bottom: 1px solid var(--border);">
                                            <td style="padding: 12px 16px; font-weight: 700; font-family: monospace; font-size: 12.5px; color: var(--primary);">
                                                ${p.paymentCode}
                                            </td>
                                            <td style="padding: 12px 16px;">
                                                <div style="font-weight: 600; font-size: 13.5px; color: var(--text);">${p.studentName != null ? p.studentName : 'Học viên'}</div>
                                                <div style="font-size: 11.5px; color: var(--text-muted);">Phiếu thu xác nhận hoàn tất</div>
                                            </td>
                                            <td style="padding: 12px 16px; text-align: right; font-weight: 700; font-family: monospace; color: var(--success); font-size: 13.5px;">
                                                +<fmt:formatNumber value="${p.amount}" pattern="#,###"/> đ
                                            </td>
                                            <td style="padding: 12px 16px; text-align: right; font-size: 12px; font-family: monospace; color: var(--text-muted);">
                                                ${p.paidAt != null ? p.paidAt.toLocalDate() : '--'}
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Right Table: Recent Enrolled Students -->
                <div class="recent-table-card">
                    <div class="recent-table-header">
                        <h2>
                            <svg style="width: 18px; height: 18px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><line x1="20" y1="8" x2="20" y2="14"/><line x1="23" y1="11" x2="17" y2="11"/></svg>
                            <span>Học viên Mới Ghi danh Gần đây</span>
                        </h2>
                        <a href="${pageContext.request.contextPath}/staff/students">
                            <span>Xem toàn bộ học viên</span>
                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table" style="margin-bottom: 0;">
                            <thead>
                            <tr style="background: var(--bg-alt); color: var(--text-muted); font-size: 11.5px; text-transform: uppercase; letter-spacing: 0.04em;">
                                <th style="padding: 10px 16px;">Học viên</th>
                                <th style="padding: 10px 16px;">Lớp học & Khóa học</th>
                                <th style="padding: 10px 16px; text-align: right;">Ngày ghi danh</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty dashboard.recentEnrollments}">
                                    <tr>
                                        <td colspan="3" style="text-align: center; padding: 28px; color: var(--text-muted); font-size: 13px;">Chưa có lượt ghi danh học viên nào.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="e" items="${dashboard.recentEnrollments}" varStatus="loop">
                                        <tr style="border-bottom: 1px solid var(--border);">
                                            <td style="padding: 12px 16px;">
                                                <div style="display: flex; align-items: center; gap: 10px;">
                                                    <div class="avatar-initials-sm ${loop.index % 4 == 0 ? 'blue' : (loop.index % 4 == 1 ? 'emerald' : (loop.index % 4 == 2 ? 'amber' : 'purple'))}">
                                                        ${e.studentName != null and e.studentName.length() > 0 ? e.studentName.substring(0, 1).toUpperCase() : 'H'}
                                                    </div>
                                                    <div>
                                                        <div style="font-weight: 700; font-size: 13.5px; color: var(--text);">${e.studentName}</div>
                                                        <div style="font-size: 11px; font-family: monospace; color: var(--text-muted);">Mã HV: #HV-00${e.studentId != null ? e.studentId : loop.index + 1}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td style="padding: 12px 16px;">
                                                <div style="font-weight: 600; font-size: 13px; color: var(--text);">${e.className}</div>
                                                <div style="font-size: 11.5px; color: var(--text-muted);">${e.courseName}</div>
                                            </td>
                                            <td style="padding: 12px 16px; text-align: right; font-size: 12px; font-family: monospace; color: var(--text-muted);">
                                                ${e.enrolledAt != null ? e.enrolledAt.toLocalDate() : '--'}
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

            <!-- 5. Realtime Footer Status Bar -->
            <div class="realtime-footer-bar">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <span class="live-pulse-dot"></span>
                    <span>Dữ liệu hệ thống tự động cập nhật trực tuyến • Đồng bộ dữ liệu tập trung qua Transaction Bus</span>
                </div>
                <div style="display: flex; align-items: center; gap: 16px;">
                    <a href="${pageContext.request.contextPath}/admin/settings" style="color: var(--text-muted); text-decoration: none;">Cấu hình hệ thống</a>
                    <span>•</span>
                    <a href="${pageContext.request.contextPath}/admin/settings?tab=audit" style="color: var(--primary); text-decoration: none; font-weight: 600;">Nhật ký kiểm toán (Audit Logs)</a>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
