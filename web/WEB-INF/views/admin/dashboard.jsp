<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261025_01">
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
                <div style="max-width: 780px;">
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px;">
                        <span class="admin-badge-module">
                            <span class="live-pulse-dot"></span>
                            Module M11 • ADM-01
                        </span>
                        <span style="font-size: 12.5px; color: var(--text-muted);">Đồng bộ tự động • Trực tuyến</span>
                    </div>
                    <h1 class="page-title" style="margin: 0 0 4px 0; letter-spacing: -0.02em;">
                        Bảng Điều Khiển Giám Đốc &amp; Quản Trị
                    </h1>
                    <p class="page-subtitle" style="margin: 0;">
                        Tổng quan thời gian thực về tình hình tài chính học phí, chuyển đổi tuyển sinh, quy mô đào tạo và vận hành trung tâm.
                    </p>
                </div>
                <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                    <button type="button" class="btn btn-outline" onclick="window.print()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        <span>Xuất báo cáo PDF</span>
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                        <span>+ Xem Báo Cáo Thống Kê Chi Tiết</span>
                    </a>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- 2. KPI Grid (8 Cards: 4 Cols x 2 Rows) -->
            <div class="kpi-grid-4">
                <!-- KPI 1: Thực thu tháng này -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top emerald"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Thực thu tháng này</div>
                            <div class="kpi-big-num" style="color: var(--success);">
                                <fmt:formatNumber value="${dashboard.monthRevenue != null ? dashboard.monthRevenue : 0}" pattern="#,###"/> đ
                            </div>
                        </div>
                        <div class="kpi-icon-square emerald">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Tổng thu học phí thực tế</span>
                        <span style="color: var(--success); font-weight: 600; font-size: 11.5px;">Đã duyệt</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill emerald" style="width: 75%;"></div>
                    </div>
                </div>

                <!-- KPI 2: Công nợ học phí chưa thu -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top amber"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Công nợ học phí chưa thu</div>
                            <div class="kpi-big-num" style="color: var(--warning);">
                                <fmt:formatNumber value="${dashboard.outstandingDebt != null ? dashboard.outstandingDebt : 0}" pattern="#,###"/> đ
                            </div>
                        </div>
                        <div class="kpi-icon-square amber">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Hóa đơn quá hạn &amp; chưa thu</span>
                        <span style="color: var(--warning); font-weight: 600; font-size: 11.5px;">Cần thu hồi</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill amber" style="width: 60%;"></div>
                    </div>
                </div>

                <!-- KPI 3: Học viên đang học -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top blue"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Học viên đang học</div>
                            <div class="kpi-big-num">
                                <c:out value="${dashboard.activeStudentsCount}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">học viên</span>
                            </div>
                        </div>
                        <div class="kpi-icon-square blue">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Quy mô đào tạo hiện hành</span>
                        <span style="color: var(--primary); font-weight: 600; font-size: 11.5px;">Đang hoạt động</span>
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
                            <div class="kpi-big-num">
                                <c:out value="${dashboard.openClassesCount}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">lớp</span>
                            </div>
                        </div>
                        <div class="kpi-icon-square blue">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Lớp mở &amp; đang diễn ra</span>
                        <span style="color: var(--success); font-weight: 600; font-size: 11.5px;">Ổn định</span>
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
                            <div class="kpi-title-sm">Tỷ lệ chuyên cần</div>
                            <div class="kpi-big-num" style="color: var(--success);">
                                <fmt:formatNumber value="${dashboard.attendanceRate}" pattern="0.0"/>%
                            </div>
                        </div>
                        <div class="kpi-icon-square emerald">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Mục tiêu vận hành &ge; 90%</span>
                        <span style="color: var(--success); font-weight: 600; font-size: 11.5px;">Đạt chuẩn</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill emerald" style="width: ${dashboard.attendanceRate > 100 ? 100 : dashboard.attendanceRate}%;"></div>
                    </div>
                </div>

                <!-- KPI 6: Lead mới tháng này -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top sky"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Lead mới tháng này</div>
                            <div class="kpi-big-num">
                                <c:out value="${dashboard.newLeadsThisMonth}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">khách hàng</span>
                            </div>
                        </div>
                        <div class="kpi-icon-square sky">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Website, Hotline &amp; Trực tiếp</span>
                        <span style="color: var(--primary); font-weight: 600; font-size: 11.5px;">Tiếp nhận</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill sky" style="width: 70%;"></div>
                    </div>
                </div>

                <!-- KPI 7: Lead chuyển đổi ghi danh -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top emerald"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Lead chuyển đổi ghi danh</div>
                            <div class="kpi-big-num" style="color: var(--success);">
                                <c:out value="${dashboard.enrolledLeadsCount}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">học viên</span>
                            </div>
                        </div>
                        <div class="kpi-icon-square emerald">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><polyline points="16 11 18 13 22 9"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Chốt xếp lớp &amp; xuất biên lai</span>
                        <span style="color: var(--success); font-weight: 600; font-size: 11.5px;">Thành công</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill emerald" style="width: 65%;"></div>
                    </div>
                </div>

                <!-- KPI 8: Tỷ lệ chuyển đổi Lead -->
                <div class="kpi-card-enterprise">
                    <div class="kpi-accent-top amber"></div>
                    <div class="kpi-header-row">
                        <div>
                            <div class="kpi-title-sm">Tỷ lệ chuyển đổi Lead</div>
                            <div class="kpi-big-num" style="color: var(--warning);">
                                <fmt:formatNumber value="${dashboard.leadConversionRate}" pattern="0.0"/>%
                            </div>
                        </div>
                        <div class="kpi-icon-square amber">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                        </div>
                    </div>
                    <div class="kpi-sub-row">
                        <span style="color: var(--text-muted); font-size: 11.5px;">Chỉ tiêu tuyển sinh CRM</span>
                        <span style="color: var(--warning); font-weight: 600; font-size: 11.5px;">Vượt chỉ tiêu</span>
                    </div>
                    <div class="kpi-bar-track">
                        <div class="kpi-bar-fill amber" style="width: ${dashboard.leadConversionRate > 100 ? 100 : dashboard.leadConversionRate}%;"></div>
                    </div>
                </div>
            </div>

            <!-- 3. Analytics Section (2 Columns: Left 7fr / Right 5fr) -->
            <div class="analytics-grid-7-5">
                <!-- Revenue Trend Chart (7fr) -->
                <div class="analytics-card">
                    <div>
                        <div class="analytics-card-header">
                            <div>
                                <h2 style="font-size: 1.05rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">
                                    Xu hướng Doanh thu Học phí (6 tháng gần nhất)
                                </h2>
                                <span style="font-size: 12px; color: var(--text-muted);">
                                    Số tiền thực thu theo từng tháng dựa trên các phiếu thu đã xác nhận
                                </span>
                            </div>
                            <span style="font-size: 11.5px; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); background: var(--primary-subtle); color: var(--primary); border: 1px solid var(--primary-border);">
                                Đơn vị: VNĐ
                            </span>
                        </div>

                        <!-- Bar Chart Container -->
                        <div class="chart-visual-box">
                            <div class="chart-grid-lines">
                                <div class="chart-grid-line"></div>
                                <div class="chart-grid-line"></div>
                                <div class="chart-grid-line"></div>
                                <div class="chart-grid-line"></div>
                            </div>

                            <c:choose>
                                <c:when test="${not empty dashboard.monthlyRevenues}">
                                    <div class="chart-bars-wrap">
                                        <c:forEach var="item" items="${dashboard.monthlyRevenues}" varStatus="status">
                                            <%-- Dynamic scale height calculation --%>
                                            <c:set var="revVal" value="${item.revenue != null ? item.revenue.doubleValue() : 0.0}" />
                                            <c:set var="barHeight" value="${revVal > 0 ? (revVal / 60000000.0 * 150) : 10}" />
                                            <c:if test="${barHeight > 165}">
                                                <c:set var="barHeight" value="165" />
                                            </c:if>
                                            <c:if test="${barHeight < 14 && revVal > 0}">
                                                <c:set var="barHeight" value="14" />
                                            </c:if>

                                            <div class="chart-bar-item ${status.last ? 'is-peak' : ''}">
                                                <span class="chart-bar-val">
                                                    <c:choose>
                                                        <c:when test="${revVal >= 1000000}">
                                                            <fmt:formatNumber value="${revVal / 1000000.0}" pattern="0.#"/> Tr
                                                        </c:when>
                                                        <c:otherwise>
                                                            <fmt:formatNumber value="${revVal}" pattern="#,###"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <div class="chart-bar-pillar" style="height: ${barHeight}px;" title="<fmt:formatNumber value='${revVal}' pattern='#,###'/> VNĐ"></div>
                                                <span class="chart-bar-month"><c:out value="${item.monthName}"/></span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="text-align: center; padding: 40px 0; color: var(--text-muted); font-size: 13px;">
                                        Chưa có số liệu phát sinh doanh thu trong 6 tháng gần nhất.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="chart-footer-strip">
                        <div style="display: flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                            <span>Thực thu tháng hiện tại: <strong style="color: var(--primary);"><fmt:formatNumber value="${dashboard.monthRevenue != null ? dashboard.monthRevenue : 0}" pattern="#,###"/> VNĐ</strong></span>
                        </div>
                        <span style="color: var(--text-muted);">Tự động đối soát từ CSDL</span>
                    </div>
                </div>

                <!-- Lead Channels Structure (5fr) -->
                <div class="analytics-card">
                    <div>
                        <div class="analytics-card-header">
                            <div>
                                <h2 style="font-size: 1.05rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">
                                    Cơ cấu Nguồn Tuyển sinh &amp; Lead
                                </h2>
                                <span style="font-size: 12px; color: var(--text-muted);">
                                    Phân bổ kênh tiếp cận khách hàng tiềm năng
                                </span>
                            </div>
                            <span style="font-size: 11.5px; font-weight: 700; padding: 3px 8px; border-radius: var(--radius-sm); background: var(--bg-alt); color: var(--text); border: 1px solid var(--border);">
                                <c:out value="${dashboard.newLeadsThisMonth}"/> Leads
                            </span>
                        </div>

                        <!-- Channel Progress Bars List -->
                        <c:choose>
                            <c:when test="${not empty dashboard.leadSources}">
                                <div class="channel-list">
                                    <c:forEach var="src" items="${dashboard.leadSources}" varStatus="status">
                                        <div class="channel-row">
                                            <div class="channel-header">
                                                <span class="channel-name">
                                                    <span class="channel-dot" style="background: ${status.index == 0 ? 'var(--primary)' : (status.index == 1 ? 'var(--success)' : (status.index == 2 ? 'var(--warning)' : '#8B5CF6'))};"></span>
                                                    <c:out value="${src.source}"/>
                                                </span>
                                                <div>
                                                    <span class="channel-count"><c:out value="${src.count}"/></span>
                                                    <span style="font-size: 11.5px; color: var(--text-muted); margin-left: 4px;">
                                                        (<fmt:formatNumber value="${src.percentage}" pattern="0.0"/>%)
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="channel-bar-track">
                                                <div class="channel-bar-fill" style="width: ${src.percentage}%; background: ${status.index == 0 ? 'var(--primary)' : (status.index == 1 ? 'var(--success)' : (status.index == 2 ? 'var(--warning)' : '#8B5CF6'))};"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 48px 0; color: var(--text-muted); font-size: 13px;">
                                    Chưa có dữ liệu kênh tiếp nhận tuyển sinh trong tháng.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="chart-footer-strip">
                        <span style="font-size: 12px; color: var(--text-muted);">Đã chuyển đổi thành công:</span>
                        <strong style="color: var(--success); font-size: 12.5px;"><c:out value="${dashboard.enrolledLeadsCount}"/> học viên</strong>
                    </div>
                </div>
            </div>

            <!-- 4. Recent Tables Section (2 Columns) -->
            <div class="recent-activity-grid">
                <!-- Left Table: Recent Transactions -->
                <div class="recent-table-card">
                    <div class="recent-table-header">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                            <h3 style="font-size: 0.95rem; font-weight: 700; margin: 0; color: var(--text);">Giao dịch Thu học phí Gần đây</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/staff/invoices" style="font-size: 12px; font-weight: 600; color: var(--primary); text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                            <span>Xem tất cả</span>
                            <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty dashboard.recentPayments}">
                            <div class="table-responsive" style="margin: 0; border: none;">
                                <table class="table" style="margin: 0;">
                                    <thead>
                                        <tr style="background: var(--bg-alt);">
                                            <th>Mã phiếu</th>
                                            <th>Học viên &amp; Khóa học</th>
                                            <th style="text-align: right;">Số tiền</th>
                                            <th style="text-align: right;">Thời gian</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${dashboard.recentPayments}">
                                            <tr>
                                                <td style="font-family: monospace; font-weight: 700; color: var(--primary); font-size: 12px;">
                                                    <c:out value="${p.receiptNumber}"/>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);"><c:out value="${p.studentName}"/></div>
                                                    <div style="font-size: 11.5px; color: var(--text-muted);"><c:out value="${p.courseName}"/></div>
                                                </td>
                                                <td style="text-align: right; font-family: monospace; font-weight: 700; color: var(--success); font-size: 13px;">
                                                    +<fmt:formatNumber value="${p.amount}" pattern="#,###"/> đ
                                                </td>
                                                <td style="text-align: right; font-size: 12px; color: var(--text-muted); font-family: monospace;">
                                                    <c:out value="${p.paymentDate}"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 36px 20px; color: var(--text-muted); font-size: 13px;">
                                Chưa có giao dịch thanh toán học phí nào gần đây.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Right Table: Recent Enrolled Students -->
                <div class="recent-table-card">
                    <div class="recent-table-header">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                            <h3 style="font-size: 0.95rem; font-weight: 700; margin: 0; color: var(--text);">Học viên Mới Ghi danh Gần đây</h3>
                        </div>
                        <a href="${pageContext.request.contextPath}/staff/enrollments" style="font-size: 12px; font-weight: 600; color: var(--primary); text-decoration: none; display: inline-flex; align-items: center; gap: 4px;">
                            <span>Xem toàn bộ</span>
                            <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg>
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty dashboard.recentEnrollments}">
                            <div class="table-responsive" style="margin: 0; border: none;">
                                <table class="table" style="margin: 0;">
                                    <thead>
                                        <tr style="background: var(--bg-alt);">
                                            <th>Học viên</th>
                                            <th>Lớp học tiếp nhận</th>
                                            <th style="text-align: right;">Ngày ghi danh</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="e" items="${dashboard.recentEnrollments}">
                                            <tr>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 10px;">
                                                        <div style="width: 32px; height: 32px; border-radius: var(--radius-sm); background: var(--primary-subtle); color: var(--primary); font-weight: 700; font-size: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                                            <c:out value="${e.studentName != null && e.studentName.length() > 0 ? e.studentName.substring(0, 1) : 'H'}"/>
                                                        </div>
                                                        <div>
                                                            <div style="font-weight: 600; color: var(--text);"><c:out value="${e.studentName}"/></div>
                                                            <div style="font-size: 11px; color: var(--text-muted); font-family: monospace;">Mã: <c:out value="${e.studentCode}"/></div>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 500; color: var(--text); font-size: 12.5px;"><c:out value="${e.className}"/></div>
                                                    <div style="font-size: 11px; color: var(--text-muted);">GV: <c:out value="${e.teacherName != null ? e.teacherName : 'Chưa phân công'}"/></div>
                                                </td>
                                                <td style="text-align: right; font-size: 12px; color: var(--text-muted); font-family: monospace;">
                                                    <c:out value="${e.enrollmentDate}"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 36px 20px; color: var(--text-muted); font-size: 13px;">
                                Chưa có học viên ghi danh mới nào gần đây.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 5. Realtime Footer Status Bar -->
            <div style="margin-top: 24px; padding-top: 14px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; font-size: 12px; color: var(--text-muted);">
                <div style="display: flex; align-items: center; gap: 6px;">
                    <span class="live-pulse-dot"></span>
                    <span>Dữ liệu hệ thống tự động cập nhật thời gian thực từ CSDL Microsoft SQL Server</span>
                </div>
                <div style="display: flex; align-items: center; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/admin/settings?tab=audit" style="color: var(--text-muted); text-decoration: none;">Nhật ký kiểm toán (Audit Logs)</a>
                    <span>•</span>
                    <a href="${pageContext.request.contextPath}/admin/settings" style="color: var(--text-muted); text-decoration: none;">Cấu hình hệ thống</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
