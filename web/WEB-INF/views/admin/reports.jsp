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
        .filter-bar {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 16px 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }
        .report-section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
            padding-bottom: 12px;
            margin-bottom: 16px;
        }
        .stat-grid-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
        }
        .stat-grid-4 {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }
        @media (max-width: 992px) {
            .stat-grid-3, .stat-grid-4 { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 576px) {
            .stat-grid-3, .stat-grid-4 { grid-template-columns: 1fr; }
        }
        .stat-box {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 14px 16px;
        }
        .stat-box-title {
            font-size: 0.8125rem;
            color: var(--text-muted);
            margin-bottom: 4px;
        }
        .stat-box-num {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text);
        }
        .stat-box-sub {
            font-size: 0.75rem;
            color: var(--text-muted);
            margin-top: 2px;
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="reports" scope="request" />
    <c:set var="breadcrumb" value="Báo cáo & Thống kê" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Breadcrumb -->
            <div style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: var(--primary); text-decoration: none;">Bảng điều khiển</a>
                <span>/</span>
                <span>Báo cáo & Thống kê Đối soát</span>
            </div>

            <!-- Page Title -->
            <div style="margin-bottom: 24px;">
                <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">Báo cáo Thống kê Điều hành Toàn Trung tâm</h1>
                <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Số liệu tổng hợp đối soát theo 5 hàm thống kê SQL (SUM, COUNT, AVG, MIN, MAX) phân hệ Tài chính, Học vụ và Tuyển sinh.</p>
            </div>

            <!-- Filter Bar -->
            <div class="filter-bar">
                <form action="${pageContext.request.contextPath}/admin/reports" method="GET" style="display: flex; align-items: center; gap: 14px; flex-wrap: wrap;">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <span style="font-size: 0.875rem; font-weight: 500; color: var(--text);">Từ ngày:</span>
                        <input type="date" name="fromDate" value="${report.fromDate}" class="form-control" style="width: auto;">
                    </div>

                    <div style="display: flex; align-items: center; gap: 8px;">
                        <span style="font-size: 0.875rem; font-weight: 500; color: var(--text);">Đến ngày:</span>
                        <input type="date" name="toDate" value="${report.toDate}" class="form-control" style="width: auto;">
                    </div>

                    <div style="display: flex; gap: 8px;">
                        <button type="submit" class="btn btn-primary" style="display: flex; align-items: center; gap: 6px;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            <span>Lọc số liệu</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-secondary">Tháng này</a>
                    </div>
                </form>

                <div style="font-size: 0.8125rem; color: var(--text-muted);">
                    Khoảng thời gian: <strong>${report.fromDate}</strong> &rarr; <strong>${report.toDate}</strong>
                </div>
            </div>

            <!-- PHẦN 1: BÁO CÁO TÀI CHÍNH & HỌC PHÍ (SUM, COUNT, MIN, MAX, AVG) -->
            <div class="report-section">
                <div class="section-header">
                    <div>
                        <h2 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 4px 0;">1. Thống kê Tài chính & Học phí</h2>
                        <div style="font-size: 0.8125rem; color: var(--text-muted);">Tổng hợp nghĩa vụ phát sinh, dòng tiền thực thu và công nợ hiện tại.</div>
                    </div>
                    <span class="badge badge-success">Phân hệ Tài chính</span>
                </div>

                <div class="stat-grid-4" style="margin-bottom: 20px;">
                    <div class="stat-box" style="border-left: 3px solid var(--success);">
                        <div class="stat-box-title">Thực thu trong kỳ (SUM)</div>
                        <div class="stat-box-num" style="color: var(--success);">
                            <fmt:formatNumber value="${report.totalRevenue}" pattern="#,###"/> đ
                        </div>
                        <div class="stat-box-sub">Từ ${report.paymentCount} phiếu thu đã duyệt</div>
                    </div>

                    <div class="stat-box" style="border-left: 3px solid var(--primary);">
                        <div class="stat-box-title">Học phí phát sinh trong kỳ (SUM)</div>
                        <div class="stat-box-num">
                            <fmt:formatNumber value="${report.totalInvoiced}" pattern="#,###"/> đ
                        </div>
                        <div class="stat-box-sub">Tổng hóa đơn phát hành</div>
                    </div>

                    <div class="stat-box" style="border-left: 3px solid var(--warning);">
                        <div class="stat-box-title">Công nợ tồn đọng (SUM)</div>
                        <div class="stat-box-num" style="color: var(--warning);">
                            <fmt:formatNumber value="${report.outstandingDebt}" pattern="#,###"/> đ
                        </div>
                        <div class="stat-box-sub">Các hóa đơn chưa tất toán</div>
                    </div>

                    <div class="stat-box" style="border-left: 3px solid #3B82F6;">
                        <div class="stat-box-title">Số giao dịch thu tiền (COUNT)</div>
                        <div class="stat-box-num">
                            ${report.paymentCount} lượt
                        </div>
                        <div class="stat-box-sub">Thanh toán hoàn tất</div>
                    </div>
                </div>

                <!-- Thống kê học phí khóa học (MIN, MAX, AVG) -->
                <div style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px; margin-bottom: 16px;">
                    <div style="font-weight: 600; font-size: 0.875rem; color: var(--text); margin-bottom: 12px;">Mức Học phí Khóa học Niêm yết (Toàn hệ thống)</div>
                    <div class="stat-grid-3">
                        <div>
                            <div style="font-size: 0.8125rem; color: var(--text-muted);">Khóa học thấp nhất (MIN)</div>
                            <div style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin-top: 2px;">
                                <fmt:formatNumber value="${report.minCourseFee}" pattern="#,###"/> đ
                            </div>
                        </div>
                        <div>
                            <div style="font-size: 0.8125rem; color: var(--text-muted);">Khóa học trung bình (AVG)</div>
                            <div style="font-size: 1.125rem; font-weight: 600; color: var(--primary); margin-top: 2px;">
                                <fmt:formatNumber value="${report.avgCourseFee}" pattern="#,###"/> đ
                            </div>
                        </div>
                        <div>
                            <div style="font-size: 0.8125rem; color: var(--text-muted);">Khóa học cao nhất (MAX)</div>
                            <div style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin-top: 2px;">
                                <fmt:formatNumber value="${report.maxCourseFee}" pattern="#,###"/> đ
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- PHẦN 2: BÁO CÁO HỌC VỤ & CHUYÊN CẦN & ĐIỂM SỐ (MIN, MAX, AVG, COUNT) -->
            <div class="report-section">
                <div class="section-header">
                    <div>
                        <h2 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 4px 0;">2. Thống kê Học vụ, Sĩ số & Kết quả Kiểm tra</h2>
                        <div style="font-size: 0.8125rem; color: var(--text-muted);">Sĩ số các lớp, tỷ lệ chuyên cần và phổ điểm bài kiểm tra đã công bố.</div>
                    </div>
                    <span class="badge badge-primary">Phân hệ Học vụ</span>
                </div>

                <div class="stat-grid-4" style="margin-bottom: 20px;">
                    <div class="stat-box">
                        <div class="stat-box-title">Tổng số lớp học (COUNT)</div>
                        <div class="stat-box-num">${report.totalClassesCount} lớp</div>
                        <div class="stat-box-sub">Lớp học trong trung tâm</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-box-title">Sĩ số thấp nhất (MIN)</div>
                        <div class="stat-box-num">${report.minClassCapacity} học viên</div>
                        <div class="stat-box-sub">Quy mô lớp nhỏ nhất</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-box-title">Sĩ số trung bình (AVG)</div>
                        <div class="stat-box-num" style="color: var(--primary);">${report.avgClassCapacity} học viên</div>
                        <div class="stat-box-sub">Trung bình mỗi lớp</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-box-title">Sĩ số cao nhất (MAX)</div>
                        <div class="stat-box-num">${report.maxClassCapacity} học viên</div>
                        <div class="stat-box-sub">Quy mô lớp lớn nhất</div>
                    </div>
                </div>

                <!-- Chuyên cần & Điểm kiểm tra -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <!-- Chuyên cần -->
                    <div style="background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                            <span style="font-weight: 600; font-size: 0.875rem;">Chuyên cần trong kỳ (${report.totalAttendances} lượt)</span>
                            <span class="badge badge-success">${report.attendanceRate}% Có mặt</span>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 0.8125rem;">
                            <div>Có mặt (PRESENT): <strong>${report.presentCount}</strong></div>
                            <div>Đi muộn (LATE): <strong>${report.lateCount}</strong></div>
                            <div>Vắng có phép: <strong>${report.excusedCount}</strong></div>
                            <div>Vắng không phép: <strong>${report.unexcusedCount}</strong></div>
                        </div>
                    </div>

                    <!-- Điểm kiểm tra -->
                    <div style="background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                            <span style="font-weight: 600; font-size: 0.875rem;">Kết quả Điểm thi (${report.totalScoresCount} bài chấm)</span>
                            <span class="badge badge-primary">Điểm TB: ${report.avgScore}</span>
                        </div>
                        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; font-size: 0.8125rem;">
                            <div>Thấp nhất (MIN): <strong style="color: var(--danger);">${report.minScore}</strong></div>
                            <div>Trung bình (AVG): <strong style="color: var(--primary);">${report.avgScore}</strong></div>
                            <div>Cao nhất (MAX): <strong style="color: var(--success);">${report.maxScore}</strong></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- PHẦN 3: BÁO CÁO TUYỂN SINH & CRM (COUNT & CONVERSION RATE) -->
            <div class="report-section">
                <div class="section-header">
                    <div>
                        <h2 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 4px 0;">3. Hiệu quả Tuyển sinh & Tiếp nhận Khách hàng (CRM)</h2>
                        <div style="font-size: 0.8125rem; color: var(--text-muted);">Tỷ lệ chuyển đổi khách hàng tiềm năng thành học viên chính thức trong kỳ.</div>
                    </div>
                    <span class="badge badge-warning">Phân hệ Tuyển sinh</span>
                </div>

                <div class="stat-grid-3">
                    <div class="stat-box">
                        <div class="stat-box-title">Tổng Lead tiếp nhận (COUNT)</div>
                        <div class="stat-box-num">${report.totalLeads} khách hàng</div>
                        <div class="stat-box-sub">Tiếp nhận trong khoảng thời gian</div>
                    </div>

                    <div class="stat-box" style="border-left: 3px solid var(--success);">
                        <div class="stat-box-title">Lead đã chuyển đổi ghi danh (COUNT)</div>
                        <div class="stat-box-num" style="color: var(--success);">${report.enrolledLeads} học viên</div>
                        <div class="stat-box-sub">Đã tạo hồ sơ & lớp học</div>
                    </div>

                    <div class="stat-box" style="border-left: 3px solid var(--primary);">
                        <div class="stat-box-title">Tỷ lệ Chuyển đổi Thành công</div>
                        <div class="stat-box-num" style="color: var(--primary);">${report.leadConversionRate}%</div>
                        <div class="stat-box-sub">Hiệu quả tư vấn tuyển sinh</div>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
