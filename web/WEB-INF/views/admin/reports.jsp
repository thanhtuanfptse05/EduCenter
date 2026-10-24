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
                        <span style="color: var(--primary); font-weight: 600;">Báo cáo & Thống kê Đối soát</span>
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
                        <a href="${pageContext.request.contextPath}/admin/reports" class="quick-filter-btn">Quý này</a>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="quick-filter-btn">Năm nay</a>
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
                            <h2 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin: 0;">1. Thống kê Tài chính & Học phí</h2>
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

                <!-- 4 Primary Finance KPI Cards -->
                <div class="kpi-grid-4" style="margin-bottom: 18px;">
                    <!-- Card 1: Thực thu -->
                    <div class="kpi-card-enterprise">
                        <div class="kpi-accent-top emerald"></div>
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm">Thực thu trong kỳ (SUM)</span>
                            <div class="kpi-icon-square emerald">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="color: var(--success);">
                            <fmt:formatNumber value="${report.totalRevenue}" pattern="#,###"/> đ
                        </div>
                        <div class="kpi-sub-row">
                            <span style="color: var(--text-muted);">Từ ${report.paymentCount} phiếu thu đã duyệt</span>
                            <span style="color: var(--success); font-weight: 600;">Hoàn tất 100%</span>
                        </div>
                    </div>

                    <!-- Card 2: Phát sinh -->
                    <div class="kpi-card-enterprise">
                        <div class="kpi-accent-top blue"></div>
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm">Học phí phát sinh (SUM)</span>
                            <div class="kpi-icon-square blue">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num">
                            <fmt:formatNumber value="${report.totalInvoiced}" pattern="#,###"/> đ
                        </div>
                        <div class="kpi-sub-row">
                            <span style="color: var(--text-muted);">Tổng hóa đơn ghi nhận</span>
                            <span style="font-family: monospace; color: var(--primary); font-weight: 700;">Hóa đơn hợp lệ</span>
                        </div>
                    </div>

                    <!-- Card 3: Công nợ tồn đọng -->
                    <div class="kpi-card-enterprise">
                        <div class="kpi-accent-top amber"></div>
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm">Công nợ tồn đọng (SUM)</span>
                            <div class="kpi-icon-square amber">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="color: var(--warning);">
                            <fmt:formatNumber value="${report.outstandingDebt}" pattern="#,###"/> đ
                        </div>
                        <div class="kpi-sub-row">
                            <span style="color: var(--text-muted);">Các hóa đơn chưa tất toán</span>
                            <span style="color: var(--warning); font-weight: 700;">Cần đôn đốc</span>
                        </div>
                    </div>

                    <!-- Card 4: Số giao dịch thu tiền -->
                    <div class="kpi-card-enterprise">
                        <div class="kpi-accent-top blue"></div>
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm">Giao dịch thu tiền (COUNT)</span>
                            <div class="kpi-icon-square blue">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num">
                            ${report.paymentCount} <span style="font-size: 1rem; font-weight: 500; color: var(--text-muted);">lượt</span>
                        </div>
                        <div class="kpi-sub-row">
                            <span style="color: var(--text-muted);">Thanh toán đối soát</span>
                            <span style="color: var(--success); font-weight: 600;">Thành công</span>
                        </div>
                    </div>
                </div>

                <!-- Secondary Panel: Mức học phí niêm yết MIN - AVG - MAX -->
                <div style="background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px 18px;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; flex-wrap: wrap; gap: 8px;">
                        <div style="display: flex; align-items: center; gap: 6px;">
                            <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="21" x2="4" y2="14"/><line x1="4" y1="10" x2="4" y2="3"/><line x1="12" y1="21" x2="12" y2="12"/><line x1="12" y1="8" x2="12" y2="3"/><line x1="20" y1="21" x2="20" y2="16"/><line x1="20" y1="12" x2="20" y2="3"/><line x1="1" y1="14" x2="7" y2="14"/><line x1="9" y1="8" x2="15" y2="8"/><line x1="17" y1="16" x2="23" y2="16"/></svg>
                            <span style="font-size: 13.5px; font-weight: 700; color: var(--text);">Mức Học phí Khóa học Niêm yết (Toàn hệ thống theo danh mục)</span>
                        </div>
                        <span style="font-size: 11.5px; font-family: monospace; color: var(--text-muted);">
                            SQL Query: <code>SELECT MIN(fee), AVG(fee), MAX(fee) FROM courses</code>
                        </span>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px;">
                        <!-- Min Fee -->
                        <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 14px 16px;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 11.5px; font-weight: 700; text-transform: uppercase; color: var(--text-muted);">Khóa học thấp nhất (MIN)</span>
                                <span style="font-size: 10px; font-weight: 800; padding: 2px 6px; border-radius: 4px; background: var(--bg-alt); color: var(--text-muted); font-family: monospace;">MIN</span>
                            </div>
                            <div style="font-size: 1.3rem; font-weight: 800; color: var(--text); margin: 4px 0;">
                                <fmt:formatNumber value="${report.minCourseFee}" pattern="#,###"/> đ
                            </div>
                            <div style="font-size: 11.5px; color: var(--text-muted); display: flex; align-items: center; gap: 4px;">
                                <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                                Khóa học nền tảng cơ bản
                            </div>
                        </div>

                        <!-- Avg Fee -->
                        <div style="background: var(--surface); border: 1px solid var(--primary-border); border-radius: var(--radius-md); padding: 14px 16px;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 11.5px; font-weight: 700; text-transform: uppercase; color: var(--primary);">Khóa học trung bình (AVG)</span>
                                <span style="font-size: 10px; font-weight: 800; padding: 2px 6px; border-radius: 4px; background: var(--primary-subtle); color: var(--primary); font-family: monospace;">AVG</span>
                            </div>
                            <div style="font-size: 1.3rem; font-weight: 800; color: var(--primary); margin: 4px 0;">
                                <fmt:formatNumber value="${report.avgCourseFee}" pattern="#,###"/> đ
                            </div>
                            <div style="font-size: 11.5px; color: var(--text-muted); display: flex; align-items: center; gap: 4px;">
                                <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                                Mức học phí bình quân / khóa chuẩn
                            </div>
                        </div>

                        <!-- Max Fee -->
                        <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 14px 16px;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-size: 11.5px; font-weight: 700; text-transform: uppercase; color: var(--text-muted);">Khóa học cao nhất (MAX)</span>
                                <span style="font-size: 10px; font-weight: 800; padding: 2px 6px; border-radius: 4px; background: var(--bg-alt); color: var(--text-muted); font-family: monospace;">MAX</span>
                            </div>
                            <div style="font-size: 1.3rem; font-weight: 800; color: var(--text); margin: 4px 0;">
                                <fmt:formatNumber value="${report.maxCourseFee}" pattern="#,###"/> đ
                            </div>
                            <div style="font-size: 11.5px; color: var(--text-muted); display: flex; align-items: center; gap: 4px;">
                                <svg style="width: 12px; height: 12px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                                Lớp Chuyên sâu & Luyện thi Tuyển thẳng
                            </div>
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
                            <h2 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin: 0;">2. Thống kê Học vụ, Sĩ số & Kết quả Kiểm tra</h2>
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
                <div class="kpi-grid-4" style="margin-bottom: 18px;">
                    <div class="kpi-card-enterprise">
                        <span class="kpi-title-sm">Tổng số lớp học (COUNT)</span>
                        <div class="kpi-big-num" style="margin-top: 6px;">
                            ${report.totalClassesCount} <span style="font-size: 0.95rem; font-weight: 500; color: var(--text-muted);">lớp</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Quy mô đang vận hành</div>
                    </div>

                    <div class="kpi-card-enterprise">
                        <span class="kpi-title-sm">Sĩ số thấp nhất (MIN)</span>
                        <div class="kpi-big-num" style="margin-top: 6px;">
                            ${report.minClassCapacity} <span style="font-size: 0.95rem; font-weight: 500; color: var(--text-muted);">học viên</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Quy mô lớp nhỏ kèm cặp</div>
                    </div>

                    <div class="kpi-card-enterprise">
                        <span class="kpi-title-sm" style="color: var(--primary);">Sĩ số trung bình (AVG)</span>
                        <div class="kpi-big-num" style="color: var(--primary); margin-top: 6px;">
                            ${report.avgClassCapacity} <span style="font-size: 0.95rem; font-weight: 500; color: var(--primary);">học viên</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Trung bình mỗi lớp giảng dạy</div>
                    </div>

                    <div class="kpi-card-enterprise">
                        <span class="kpi-title-sm">Sĩ số cao nhất (MAX)</span>
                        <div class="kpi-big-num" style="margin-top: 6px;">
                            ${report.maxClassCapacity} <span style="font-size: 0.95rem; font-weight: 500; color: var(--text-muted);">học viên</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Lớp chuẩn quy mô phòng lớn</div>
                    </div>
                </div>

                <!-- Dual Widget: Attendance & Exam Results -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <!-- Widget Trái: Chuyên cần -->
                    <div style="background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px 18px;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <div>
                                <h3 style="font-size: 13.5px; font-weight: 700; color: var(--text); margin: 0 0 2px 0;">
                                    Chuyên cần trong kỳ (COUNT: ${report.totalAttendances} lượt)
                                </h3>
                                <span style="font-size: 11.5px; color: var(--text-muted);">Đối soát nhật ký điểm danh phòng học</span>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--success);">${report.attendanceRate}%</div>
                                <div style="font-size: 11px; font-weight: 600; color: var(--success);">Tỷ lệ có mặt</div>
                            </div>
                        </div>

                        <!-- Progress Bar phân đoạn chuyên cần -->
                        <c:set var="totalAtt" value="${report.totalAttendances > 0 ? report.totalAttendances : 1}" />
                        <div class="attendance-segmented-bar">
                            <div style="width: ${(report.presentCount * 100.0) / totalAtt}%; background: var(--success);" title="Có mặt: ${report.presentCount}"></div>
                            <div style="width: ${(report.lateCount * 100.0) / totalAtt}%; background: var(--warning);" title="Đi muộn: ${report.lateCount}"></div>
                            <div style="width: ${(report.excusedCount * 100.0) / totalAtt}%; background: #94a3b8;" title="Vắng có phép: ${report.excusedCount}"></div>
                            <div style="width: ${(report.unexcusedCount * 100.0) / totalAtt}%; background: var(--danger);" title="Vắng không phép: ${report.unexcusedCount}"></div>
                        </div>

                        <!-- Breakdown badges -->
                        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; margin-top: 10px;">
                            <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 8px 10px;">
                                <div style="font-size: 11px; font-weight: 700; color: var(--success); display: flex; align-items: center; gap: 4px;">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--success);"></span> Có mặt
                                </div>
                                <div style="font-size: 13.5px; font-weight: 700; font-family: monospace; color: var(--text); margin-top: 2px;">
                                    ${report.presentCount} lượt
                                </div>
                            </div>
                            <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 8px 10px;">
                                <div style="font-size: 11px; font-weight: 700; color: var(--warning); display: flex; align-items: center; gap: 4px;">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--warning);"></span> Đi muộn
                                </div>
                                <div style="font-size: 13.5px; font-weight: 700; font-family: monospace; color: var(--text); margin-top: 2px;">
                                    ${report.lateCount} lượt
                                </div>
                            </div>
                            <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 8px 10px;">
                                <div style="font-size: 11px; font-weight: 700; color: var(--text-muted); display: flex; align-items: center; gap: 4px;">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: #94a3b8;"></span> Vắng phép
                                </div>
                                <div style="font-size: 13.5px; font-weight: 700; font-family: monospace; color: var(--text); margin-top: 2px;">
                                    ${report.excusedCount} lượt
                                </div>
                            </div>
                            <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 8px 10px;">
                                <div style="font-size: 11px; font-weight: 700; color: var(--danger); display: flex; align-items: center; gap: 4px;">
                                    <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--danger);"></span> Vắng ko phép
                                </div>
                                <div style="font-size: 13.5px; font-weight: 700; font-family: monospace; color: var(--text); margin-top: 2px;">
                                    ${report.unexcusedCount} lượt
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Widget Phải: Điểm số -->
                    <div style="background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px 18px;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px;">
                            <div>
                                <h3 style="font-size: 13.5px; font-weight: 700; color: var(--text); margin: 0 0 2px 0;">
                                    Kết quả Điểm thi (COUNT: ${report.totalScoresCount} bài chấm)
                                </h3>
                                <span style="font-size: 11.5px; color: var(--text-muted);">Phân tích phổ điểm kiểm tra định kỳ</span>
                            </div>
                            <div style="text-align: right;">
                                <div style="font-size: 1.25rem; font-weight: 800; color: var(--primary);">${report.avgScore}</div>
                                <div style="font-size: 11px; font-weight: 600; color: var(--text-muted);">Điểm TB toàn khóa</div>
                            </div>
                        </div>

                        <!-- Visual Scale Track -->
                        <div class="score-scale-track">
                            <div class="score-scale-fill" style="left: 0; right: 0;"></div>
                            <c:set var="pinPos" value="${report.avgScore > 10 ? report.avgScore : report.avgScore * 10}" />
                            <div class="score-scale-pin" style="left: ${pinPos > 95 ? 95 : (pinPos < 5 ? 5 : pinPos)}%;"></div>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 10.5px; font-family: monospace; color: var(--text-muted);">
                            <span>Thang điểm 0.00</span>
                            <span style="color: var(--primary); font-weight: 700;">TB: ${report.avgScore}</span>
                            <span>Thang 100.00</span>
                        </div>

                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px; margin-top: 10px;">
                            <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 8px 10px; text-align: center;">
                                <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--text-muted);">Thấp nhất (MIN)</span>
                                <div style="font-size: 14px; font-weight: 800; font-family: monospace; color: var(--danger); margin-top: 2px;">
                                    ${report.minScore}
                                </div>
                            </div>
                            <div style="background: var(--surface); border: 1px solid var(--primary-border); border-radius: var(--radius-sm); padding: 8px 10px; text-align: center;">
                                <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--primary);">Trung bình (AVG)</span>
                                <div style="font-size: 14px; font-weight: 800; font-family: monospace; color: var(--primary); margin-top: 2px;">
                                    ${report.avgScore}
                                </div>
                            </div>
                            <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 8px 10px; text-align: center;">
                                <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--success);">Cao nhất (MAX)</span>
                                <div style="font-size: 14px; font-weight: 800; font-family: monospace; color: var(--success); margin-top: 2px;">
                                    ${report.maxScore}
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
                            <h2 style="font-size: 1.15rem; font-weight: 700; color: var(--text); margin: 0;">3. Hiệu quả Tuyển sinh & Tiếp nhận Khách hàng (CRM)</h2>
                        </div>
                        <p style="font-size: 0.8125rem; color: var(--text-muted); margin: 4px 0 0 12px;">
                            Tỷ lệ chuyển đổi khách hàng tiềm năng thành học viên chính thức trong kỳ báo cáo.
                        </p>
                    </div>
                    <span style="font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: var(--radius-sm); background: var(--warning-subtle); color: var(--warning); border: 1px solid var(--warning-border); display: inline-flex; align-items: center; gap: 4px;">
                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        Phân hệ Tuyển sinh
                    </span>
                </div>

                <!-- 3 Phễu chuyển đổi Cards -->
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;">
                    <div class="kpi-card-enterprise">
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm">Tổng Lead tiếp nhận (COUNT)</span>
                            <div class="kpi-icon-square blue">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/><path d="M11 8v6M8 11h6"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num">
                            ${report.totalLeads} <span style="font-size: 0.95rem; font-weight: 500; color: var(--text-muted);">khách hàng</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Tiếp nhận trong khoảng thời gian</div>
                    </div>

                    <div class="kpi-card-enterprise">
                        <div class="kpi-accent-top emerald"></div>
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm" style="color: var(--success);">Lead chuyển đổi ghi danh (COUNT)</span>
                            <div class="kpi-icon-square emerald">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="color: var(--success);">
                            ${report.enrolledLeads} <span style="font-size: 0.95rem; font-weight: 500; color: var(--success);">học viên</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Đã hoàn tất đóng học phí & xếp lớp</div>
                    </div>

                    <div class="kpi-card-enterprise">
                        <div class="kpi-accent-top blue"></div>
                        <div class="kpi-header-row">
                            <span class="kpi-title-sm" style="color: var(--primary);">Tỷ lệ Chuyển đổi Thành công</span>
                            <div class="kpi-icon-square blue">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                            </div>
                        </div>
                        <div class="kpi-big-num" style="color: var(--primary);">
                            ${report.leadConversionRate}% <span style="font-size: 0.85rem; font-weight: 600; color: var(--success);">(Mục tiêu: 15.0%)</span>
                        </div>
                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 8px;">Hiệu quả tư vấn tuyển sinh vượt chỉ tiêu</div>
                    </div>
                </div>
            </div>

            <!-- Contextual Photo Strip: Cơ sở vật chất & Hoạt động đào tạo -->
            <div class="facility-grid-3">
                <div class="facility-card">
                    <div class="facility-card-img" style="background-image: url('https://images.unsplash.com/photo-1580582932707-520aed937b7b?auto=format&fit=crop&w=800&q=80');"></div>
                    <div class="facility-card-body">
                        <div class="facility-card-title">Không gian Lớp học Tiêu chuẩn</div>
                        <div class="facility-card-sub">Cơ sở vật chất đạt chuẩn kiểm định đào tạo</div>
                    </div>
                </div>

                <div class="facility-card">
                    <div class="facility-card-img" style="background-image: url('https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80');"></div>
                    <div class="facility-card-body">
                        <div class="facility-card-title">Phòng Thi Máy tính HSA & Khảo thí</div>
                        <div class="facility-card-sub">Hạ tầng khảo thí độc lập cho 80 thí sinh/kíp</div>
                    </div>
                </div>

                <div class="facility-card">
                    <div class="facility-card-img" style="background-image: url('https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=800&q=80');"></div>
                    <div class="facility-card-body">
                        <div class="facility-card-title">Quầy Tư vấn Tuyển sinh CRM</div>
                        <div class="facility-card-sub">Đón tiếp và phân loại hồ sơ ứng viên đầu vào</div>
                    </div>
                </div>
            </div>

            <!-- Institutional System Footer Note -->
            <div class="realtime-footer-bar">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <svg style="width: 15px; height: 15px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="4 17 10 11 4 5"/><line x1="12" y1="19" x2="20" y2="19"/></svg>
                    <span>Báo cáo trích xuất từ cơ sở dữ liệu SQL Server qua JPA JPQL theo chuẩn nghiệp vụ EduCenter SRS v1.1.</span>
                </div>
                <span>Bản quyền © 2026 EduCenter Enterprise System. All rights reserved.</span>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
