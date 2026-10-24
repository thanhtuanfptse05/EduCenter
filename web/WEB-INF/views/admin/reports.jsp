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
    <c:set var="activeNav" value="reports" scope="request" />
    <c:set var="breadcrumb" value="Báo cáo & Thống kê Đối soát" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- 1. Top Navigation Context & Quick Actions -->
            <div class="admin-header-row">
                <div style="max-width: 820px;">
                    <div style="display: flex; align-items: center; gap: 6px; font-size: 12.5px; color: var(--text-muted); margin-bottom: 6px;">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: var(--text-muted); text-decoration: none;">Bảng điều khiển</a>
                        <span>/</span>
                        <span style="color: var(--primary); font-weight: 600;">Báo cáo &amp; Thống kê Đối soát</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                        <h1 class="page-title" style="margin: 0; letter-spacing: -0.02em;">
                            Báo Cáo Thống Kê Điều Hành Toàn Trung Tâm
                        </h1>
                        <span class="admin-badge-module">SRS v1.1 Active</span>
                    </div>
                    <p class="page-subtitle" style="margin-top: 4px;">
                        Số liệu tổng hợp đối soát theo 5 hàm thống kê SQL bắt buộc (<strong style="color: var(--primary);">SUM</strong>, <strong style="color: var(--primary);">COUNT</strong>, <strong style="color: var(--primary);">AVG</strong>, <strong style="color: var(--primary);">MIN</strong>, <strong style="color: var(--primary);">MAX</strong>) phân hệ Tài chính, Học vụ và Tuyển sinh.
                    </p>
                </div>
                <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap;">
                    <button type="button" class="btn btn-outline" onclick="window.print()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        <span>Xuất Excel</span>
                    </button>
                    <button type="button" class="btn btn-outline" onclick="window.print()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                        <span>Bản in PDF</span>
                    </button>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- 2. Operational Filter Panel -->
            <div class="report-filter-console">
                <form action="${pageContext.request.contextPath}/admin/reports" method="GET" class="report-filter-form">
                    <div class="filter-input-wrap">
                        <label>Từ ngày:</label>
                        <input type="date" name="fromDate" value="${report.fromDate}">
                    </div>

                    <div class="filter-input-wrap">
                        <label>Đến ngày:</label>
                        <input type="date" name="toDate" value="${report.toDate}">
                    </div>

                    <button type="submit" class="btn btn-primary" style="height: 34px; padding: 0 14px; font-size: 13px; display: inline-flex; align-items: center; gap: 6px;">
                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                        <span>Lọc số liệu</span>
                    </button>

                    <div class="quick-filter-group">
                        <a href="${pageContext.request.contextPath}/admin/reports" class="quick-filter-btn active">Tháng này</a>
                        <a href="${pageContext.request.contextPath}/admin/reports?fromDate=2026-07-01&toDate=2026-09-30" class="quick-filter-btn">Quý trước</a>
                        <a href="${pageContext.request.contextPath}/admin/reports?fromDate=2026-01-01&toDate=2026-12-31" class="quick-filter-btn">Cả năm</a>
                    </div>
                </form>

                <div style="font-size: 12.5px; color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
                    <svg style="width: 15px; height: 15px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                    <span>Khoảng thời gian:</span>
                    <strong style="color: var(--text); font-family: monospace; background: var(--bg-alt); padding: 2px 8px; border-radius: var(--radius-sm); border: 1px solid var(--border);">
                        ${report.fromDate} &rarr; ${report.toDate}
                    </strong>
                </div>
            </div>

            <!-- ==================== KHỐI 1: TÀI CHÍNH & HỌC PHÍ ==================== -->
            <div class="analytics-card" style="margin-bottom: 24px;">
                <div class="analytics-card-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 4px; height: 18px; border-radius: 2px; background: var(--primary); display: inline-block;"></span>
                            <h2 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin: 0;">1. Thống kê Tài chính &amp; Học phí</h2>
                        </div>
                        <p style="font-size: 0.8125rem; color: var(--text-muted); margin: 4px 0 0 12px;">
                            Tổng hợp nghĩa vụ phát sinh, dòng tiền thực thu và công nợ hiện tại qua lệnh SQL phân tích.
                        </p>
                    </div>
                    <span style="font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); background: var(--success-subtle); color: var(--success); border: 1px solid var(--success-border); display: inline-flex; align-items: center; gap: 4px;">
                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                        Phân hệ Tài chính
                    </span>
                </div>

                <!-- 4 Primary Finance KPI Cards (SUM & COUNT) -->
                <div class="stat-quad-grid">
                    <!-- Card 1: Thực thu -->
                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--success);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <span class="kpi-title-sm">Thực thu trong kỳ (SUM)</span>
                            <div class="kpi-icon-square emerald" style="width: 28px; height: 28px;">
                                <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="color: var(--success); margin: 6px 0;">
                            <fmt:formatNumber value="${report.totalRevenue != null ? report.totalRevenue : 0}" pattern="#,###"/> đ
                        </div>
                        <div style="font-size: 11.5px; color: var(--text-muted); display: flex; justify-content: space-between;">
                            <span>Từ ${report.paymentCount} phiếu thu</span>
                            <span style="color: var(--success); font-weight: 600;">Đã ghi sổ</span>
                        </div>
                    </div>

                    <!-- Card 2: Phát sinh -->
                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--primary);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <span class="kpi-title-sm">Học phí phát sinh (SUM)</span>
                            <div class="kpi-icon-square blue" style="width: 28px; height: 28px;">
                                <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="margin: 6px 0;">
                            <fmt:formatNumber value="${report.totalInvoiced != null ? report.totalInvoiced : 0}" pattern="#,###"/> đ
                        </div>
                        <div style="font-size: 11.5px; color: var(--text-muted); display: flex; justify-content: space-between;">
                            <span>Tổng nghĩa vụ học phí</span>
                            <span style="color: var(--primary); font-weight: 600;">Hóa đơn tạo</span>
                        </div>
                    </div>

                    <!-- Card 3: Công nợ tồn đọng -->
                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--warning);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <span class="kpi-title-sm">Công nợ tồn đọng (SUM)</span>
                            <div class="kpi-icon-square amber" style="width: 28px; height: 28px;">
                                <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="color: var(--warning); margin: 6px 0;">
                            <fmt:formatNumber value="${report.outstandingDebt != null ? report.outstandingDebt : 0}" pattern="#,###"/> đ
                        </div>
                        <div style="font-size: 11.5px; color: var(--text-muted); display: flex; justify-content: space-between;">
                            <span>Các khoản chưa tất toán</span>
                            <span style="color: var(--warning); font-weight: 600;">Cần đôn đốc</span>
                        </div>
                    </div>

                    <!-- Card 4: Số giao dịch thu tiền -->
                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--info);">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                            <span class="kpi-title-sm">Giao dịch thu tiền (COUNT)</span>
                            <div class="kpi-icon-square sky" style="width: 28px; height: 28px;">
                                <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="margin: 6px 0;">
                            <c:out value="${report.paymentCount}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">lượt</span>
                        </div>
                        <div style="font-size: 11.5px; color: var(--text-muted); display: flex; justify-content: space-between;">
                            <span>Thanh toán ngân hàng &amp; tiền mặt</span>
                            <span style="color: var(--info); font-weight: 600;">Hoàn tất</span>
                        </div>
                    </div>
                </div>

                <!-- Secondary Sub-Panel: Mức học phí niêm yết MIN - AVG - MAX -->
                <div style="background: var(--bg-alt); border-radius: var(--radius-md); padding: 16px 18px; border: 1px solid var(--border);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; flex-wrap: wrap; gap: 8px;">
                        <div style="display: flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>
                            <span style="font-size: 13px; font-weight: 700; color: var(--text);">Mức Học phí Khóa học Niêm yết (Toàn hệ thống theo danh mục)</span>
                        </div>
                        <code style="font-size: 11px; color: var(--text-muted); background: var(--surface); padding: 2px 6px; border-radius: 4px; border: 1px solid var(--border);">
                            SQL: MIN(fee), AVG(fee), MAX(fee)
                        </code>
                    </div>

                    <div class="stat-tri-grid">
                        <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 12px 14px;">
                            <span style="font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Khóa học thấp nhất (MIN)</span>
                            <div style="font-size: 1.15rem; font-weight: 800; color: var(--text); margin: 4px 0;">
                                <fmt:formatNumber value="${report.minCourseFee != null ? report.minCourseFee : 0}" pattern="#,###"/> đ
                            </div>
                            <span style="font-size: 11px; color: var(--text-muted);">Mức học phí cơ sở</span>
                        </div>

                        <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 12px 14px;">
                            <span style="font-size: 11px; font-weight: 700; color: var(--primary); text-transform: uppercase;">Khóa học trung bình (AVG)</span>
                            <div style="font-size: 1.15rem; font-weight: 800; color: var(--primary); margin: 4px 0;">
                                <fmt:formatNumber value="${report.avgCourseFee != null ? report.avgCourseFee : 0}" pattern="#,###"/> đ
                            </div>
                            <span style="font-size: 11px; color: var(--text-muted);">Mức học phí bình quân / khóa</span>
                        </div>

                        <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 12px 14px;">
                            <span style="font-size: 11px; font-weight: 700; color: var(--text-muted); text-transform: uppercase;">Khóa học cao nhất (MAX)</span>
                            <div style="font-size: 1.15rem; font-weight: 800; color: var(--text); margin: 4px 0;">
                                <fmt:formatNumber value="${report.maxCourseFee != null ? report.maxCourseFee : 0}" pattern="#,###"/> đ
                            </div>
                            <span style="font-size: 11px; color: var(--text-muted);">Chương trình chuyên sâu / Luyện thi</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================== KHỐI 2: HỌC VỤ & KẾT QUẢ KIỂM TRA ==================== -->
            <div class="analytics-card" style="margin-bottom: 24px;">
                <div class="analytics-card-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 4px; height: 18px; border-radius: 2px; background: var(--primary); display: inline-block;"></span>
                            <h2 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin: 0;">2. Thống kê Học vụ, Sĩ số &amp; Kết quả Kiểm tra</h2>
                        </div>
                        <p style="font-size: 0.8125rem; color: var(--text-muted); margin: 4px 0 0 12px;">
                            Quy mô mở lớp, tỷ lệ chuyên cần phân đoạn và phổ điểm bài thi đã chấm.
                        </p>
                    </div>
                    <span style="font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); background: var(--primary-subtle); color: var(--primary); border: 1px solid var(--primary-border); display: inline-flex; align-items: center; gap: 4px;">
                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                        Phân hệ Học vụ
                    </span>
                </div>

                <!-- Sĩ số 4 chỉ số -->
                <div class="stat-quad-grid" style="margin-bottom: 20px;">
                    <div class="report-kpi-box">
                        <span class="kpi-title-sm">Tổng số lớp học (COUNT)</span>
                        <div class="kpi-big-num" style="margin: 6px 0;">
                            <c:out value="${report.totalClassesCount}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">lớp</span>
                        </div>
                        <span style="font-size: 11.5px; color: var(--text-muted);">Quy mô đang vận hành</span>
                    </div>

                    <div class="report-kpi-box">
                        <span class="kpi-title-sm">Sĩ số thấp nhất (MIN)</span>
                        <div class="kpi-big-num" style="margin: 6px 0;">
                            <c:out value="${report.minClassCapacity}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">học viên</span>
                        </div>
                        <span style="font-size: 11.5px; color: var(--text-muted);">Quy mô lớp nhỏ kèm cặp</span>
                    </div>

                    <div class="report-kpi-box">
                        <span class="kpi-title-sm" style="color: var(--primary);">Sĩ số trung bình (AVG)</span>
                        <div class="kpi-big-num" style="color: var(--primary); margin: 6px 0;">
                            <fmt:formatNumber value="${report.avgClassCapacity}" pattern="0.0"/> <span style="font-size: 13px; font-weight: 600; color: var(--primary);">học viên</span>
                        </div>
                        <span style="font-size: 11.5px; color: var(--text-muted);">Trung bình mỗi lớp giảng dạy</span>
                    </div>

                    <div class="report-kpi-box">
                        <span class="kpi-title-sm">Sĩ số cao nhất (MAX)</span>
                        <div class="kpi-big-num" style="margin: 6px 0;">
                            <c:out value="${report.maxClassCapacity}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">học viên</span>
                        </div>
                        <span style="font-size: 11.5px; color: var(--text-muted);">Lớp chuyên đề quy mô lớn</span>
                    </div>
                </div>

                <!-- Dual Widget: Attendance & Exam Results -->
                <div class="recent-activity-grid">
                    <!-- Widget Trái: Chuyên cần -->
                    <div style="background: var(--bg-alt); border-radius: var(--radius-md); padding: 16px 18px; border: 1px solid var(--border);">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <div>
                                <h3 style="font-size: 0.95rem; font-weight: 700; margin: 0 0 2px 0; color: var(--text);">
                                    Chuyên cần trong kỳ (<c:out value="${report.totalAttendances}"/> lượt)
                                </h3>
                                <span style="font-size: 11.5px; color: var(--text-muted);">Đối soát nhật ký điểm danh phòng học</span>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--success); line-height: 1.1;">
                                    <fmt:formatNumber value="${report.attendanceRate}" pattern="0.0"/>%
                                </div>
                                <span style="font-size: 11px; color: var(--success); font-weight: 600;">Tỷ lệ có mặt</span>
                            </div>
                        </div>

                        <!-- Progress Bar phân đoạn chuyên cần -->
                        <c:set var="attTotal" value="${report.totalAttendances > 0 ? report.totalAttendances : 1}" />
                        <div class="attendance-segmented-bar">
                            <div style="width: ${report.presentCount * 100.0 / attTotal}%; background: var(--success);" title="Có mặt: ${report.presentCount}"></div>
                            <div style="width: ${report.lateCount * 100.0 / attTotal}%; background: var(--warning);" title="Đi muộn: ${report.lateCount}"></div>
                            <div style="width: ${report.excusedCount * 100.0 / attTotal}%; background: var(--info);" title="Vắng phép: ${report.excusedCount}"></div>
                            <div style="width: ${report.unexcusedCount * 100.0 / attTotal}%; background: var(--danger);" title="Vắng không phép: ${report.unexcusedCount}"></div>
                        </div>

                        <!-- Breakdown Badges -->
                        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-top: 10px;">
                            <div style="background: var(--surface); padding: 8px; border-radius: var(--radius-sm); border: 1px solid var(--border); font-size: 11.5px;">
                                <div style="color: var(--success); font-weight: 700;">● Có mặt</div>
                                <div style="font-weight: 800; font-size: 13px; margin-top: 2px;"><c:out value="${report.presentCount}"/></div>
                            </div>
                            <div style="background: var(--surface); padding: 8px; border-radius: var(--radius-sm); border: 1px solid var(--border); font-size: 11.5px;">
                                <div style="color: var(--warning); font-weight: 700;">● Đi muộn</div>
                                <div style="font-weight: 800; font-size: 13px; margin-top: 2px;"><c:out value="${report.lateCount}"/></div>
                            </div>
                            <div style="background: var(--surface); padding: 8px; border-radius: var(--radius-sm); border: 1px solid var(--border); font-size: 11.5px;">
                                <div style="color: var(--info); font-weight: 700;">● Vắng phép</div>
                                <div style="font-weight: 800; font-size: 13px; margin-top: 2px;"><c:out value="${report.excusedCount}"/></div>
                            </div>
                            <div style="background: var(--surface); padding: 8px; border-radius: var(--radius-sm); border: 1px solid var(--border); font-size: 11.5px;">
                                <div style="color: var(--danger); font-weight: 700;">● Vắng K.phép</div>
                                <div style="font-weight: 800; font-size: 13px; margin-top: 2px;"><c:out value="${report.unexcusedCount}"/></div>
                            </div>
                        </div>
                    </div>

                    <!-- Widget Phải: Điểm số -->
                    <div style="background: var(--bg-alt); border-radius: var(--radius-md); padding: 16px 18px; border: 1px solid var(--border);">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <div>
                                <h3 style="font-size: 0.95rem; font-weight: 700; margin: 0 0 2px 0; color: var(--text);">
                                    Kết quả Điểm thi (<c:out value="${report.totalScoresCount}"/> bài chấm)
                                </h3>
                                <span style="font-size: 11.5px; color: var(--text-muted);">Phân tích thang điểm kỳ thi chuẩn hóa</span>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--primary); line-height: 1.1;">
                                    <fmt:formatNumber value="${report.avgScore}" pattern="0.00"/>
                                </div>
                                <span style="font-size: 11px; color: var(--text-muted); font-weight: 600;">Điểm TB toàn khóa</span>
                            </div>
                        </div>

                        <!-- 3 Stat Boxes -->
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 14px;">
                            <div style="background: var(--surface); padding: 10px; border-radius: var(--radius-sm); border: 1px solid var(--border); text-align: center;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--danger); text-transform: uppercase;">Thấp nhất (MIN)</span>
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--danger); margin-top: 2px;">
                                    <fmt:formatNumber value="${report.minScore}" pattern="0.00"/>
                                </div>
                            </div>
                            <div style="background: var(--surface); padding: 10px; border-radius: var(--radius-sm); border: 1px solid var(--border); text-align: center;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--primary); text-transform: uppercase;">Trung bình (AVG)</span>
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--primary); margin-top: 2px;">
                                    <fmt:formatNumber value="${report.avgScore}" pattern="0.00"/>
                                </div>
                            </div>
                            <div style="background: var(--surface); padding: 10px; border-radius: var(--radius-sm); border: 1px solid var(--border); text-align: center;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--success); text-transform: uppercase;">Cao nhất (MAX)</span>
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--success); margin-top: 2px;">
                                    <fmt:formatNumber value="${report.maxScore}" pattern="0.00"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ==================== KHỐI 3: CRM TUYỂN SINH ==================== -->
            <div class="analytics-card" style="margin-bottom: 24px;">
                <div class="analytics-card-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="width: 4px; height: 18px; border-radius: 2px; background: var(--primary); display: inline-block;"></span>
                            <h2 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin: 0;">3. Hiệu quả Tuyển sinh &amp; Tiếp nhận Khách hàng (CRM)</h2>
                        </div>
                        <p style="font-size: 0.8125rem; color: var(--text-muted); margin: 4px 0 0 12px;">
                            Tỷ lệ chuyển đổi khách hàng tiềm năng thành học viên chính thức trong kỳ báo cáo.
                        </p>
                    </div>
                    <span style="font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); background: var(--warning-subtle); color: var(--warning); border: 1px solid var(--warning-border); display: inline-flex; align-items: center; gap: 4px;">
                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M16 16s-1.5-2-4-2-4 2-4 2"/><line x1="9" y1="9" x2="9.01" y2="9"/><line x1="15" y1="9" x2="15.01" y2="9"/></svg>
                        Phân hệ Tuyển sinh
                    </span>
                </div>

                <!-- 3 Phễu chuyển đổi Cards -->
                <div class="stat-tri-grid">
                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--primary);">
                        <span class="kpi-title-sm">Tổng Lead tiếp nhận (COUNT)</span>
                        <div class="kpi-big-num" style="margin: 6px 0;">
                            <c:out value="${report.totalLeads}"/> <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">khách hàng</span>
                        </div>
                        <span style="font-size: 11.5px; color: var(--text-muted);">Tiếp nhận trong khoảng thời gian</span>
                    </div>

                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--success);">
                        <span class="kpi-title-sm" style="color: var(--success);">Lead chuyển đổi ghi danh (COUNT)</span>
                        <div class="kpi-big-num" style="color: var(--success); margin: 6px 0;">
                            <c:out value="${report.enrolledLeads}"/> <span style="font-size: 13px; font-weight: 600; color: var(--success);">học viên</span>
                        </div>
                        <span style="font-size: 11.5px; color: var(--text-muted);">Đã hoàn tất đóng học phí &amp; xếp lớp</span>
                    </div>

                    <div class="report-kpi-box elevated" style="border-left: 4px solid var(--warning);">
                        <span class="kpi-title-sm" style="color: var(--warning);">Tỷ lệ Chuyển đổi Thành công</span>
                        <div class="kpi-big-num" style="color: var(--warning); margin: 6px 0;">
                            <fmt:formatNumber value="${report.leadConversionRate}" pattern="0.0"/>%
                        </div>
                        <span style="font-size: 11.5px; color: var(--success); font-weight: 600;">Hiệu quả tư vấn tuyển sinh vượt chỉ tiêu</span>
                    </div>
                </div>
            </div>

            <!-- Institutional System Footer Note -->
            <footer style="margin-top: 28px; padding-top: 14px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px; font-size: 12px; color: var(--text-muted);">
                <div style="display: flex; align-items: center; gap: 6px;">
                    <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><polyline points="4 17 10 11 4 5"/><line x1="12" y1="19" x2="20" y2="19"/></svg>
                    <span>Báo cáo trích xuất từ cơ sở dữ liệu Microsoft SQL Server qua JPA JPQL theo chuẩn nghiệp vụ EduCenter SRS v1.1.</span>
                </div>
                <span>Bản quyền &copy; 2026 EduCenter Enterprise System. All rights reserved.</span>
            </footer>
        </main>
    </div>
</div>
</body>
</html>
