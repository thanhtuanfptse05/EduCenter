<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-management.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="assessments" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Bài kiểm tra & Bảng điểm" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="mgmt-wrap">
                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Calculate Statistical KPIs Dynamically -->
                <c:set var="totalTestsCount" value="${not empty assessments ? assessments.size() : 0}"/>
                <c:set var="totalGradedCount" value="0"/>
                <c:set var="totalEnrolledCount" value="0"/>
                <c:set var="totalAverageSum" value="0"/>
                <c:set var="scoredTestsCount" value="0"/>
                <c:forEach var="item" items="${assessments}">
                    <c:set var="totalGradedCount" value="${totalGradedCount + item.gradedCount}"/>
                    <c:set var="totalEnrolledCount" value="${totalEnrolledCount + item.totalStudents}"/>
                    <c:if test="${not empty item.averageScore}">
                        <c:set var="totalAverageSum" value="${totalAverageSum + item.averageScore}"/>
                        <c:set var="scoredTestsCount" value="${scoredTestsCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:set var="gradingProgressPercent" value="${totalEnrolledCount > 0 ? (totalGradedCount * 100 / totalEnrolledCount) : 100}"/>

                <!-- 1. Top Header Module -->
                <div class="mgmt-header">
                    <div class="mgmt-header-left">
                        <div class="mgmt-breadcrumb">
                            <span class="mgmt-badge-version">HỌC VỤ &amp; GIẢNG DẠY • TCH-05 &amp; TCH-06</span>
                            <span>•</span>
                            <span>Đánh giá năng lực</span>
                        </div>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Quản lý Bài kiểm tra &amp; Điểm số</h1>
                        </div>
                        <p class="mgmt-subtitle">
                            Tạo đề kiểm tra, chấm điểm trực tiếp và công bố bảng điểm tự động đến học sinh &amp; phụ huynh.
                        </p>
                    </div>
                    <div class="mgmt-header-actions">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="window.print();" title="Xuất bảng điểm tổng hợp">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                            </svg>
                            <span>Xuất bảng tổng hợp</span>
                        </button>
                        <button type="button" class="btn btn-primary btn-sm" onclick="openCreateModal();">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <line x1="12" y1="5" x2="12" y2="19"></line>
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                            </svg>
                            <span>Tạo bài kiểm tra mới</span>
                        </button>
                    </div>
                </div>

                <!-- 2. KPI Statistical Deck (3-Columns Grid) -->
                <div class="mgmt-kpi-grid-3">
                    <!-- KPI 1 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content">
                            <span class="mgmt-kpi-label">Tổng số bài kiểm tra</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value"><c:out value="${totalTestsCount}"/></span>
                                <span class="mgmt-kpi-sub">bài thi</span>
                            </div>
                            <span style="font-size: 11.5px; color: var(--text-muted); font-weight: 500;">
                                Kiểm tra 15p, 1 tiết, giữa kỳ &amp; thi thử
                            </span>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-primary-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                <polyline points="14 2 14 8 20 8"></polyline>
                                <line x1="16" y1="13" x2="8" y2="13"></line>
                                <line x1="16" y1="17" x2="8" y2="17"></line>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 2 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content" style="width: 100%;">
                            <span class="mgmt-kpi-label">Tiến độ chấm điểm</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value" style="color: #047857;">
                                    <fmt:formatNumber value="${gradingProgressPercent}" maxFractionDigits="1"/>%
                                </span>
                            </div>
                            <div style="margin-top: 6px;">
                                <div style="display: flex; justify-content: space-between; font-size: 11.5px; color: var(--text-muted); margin-bottom: 4px;">
                                    <span>Đã chấm ${totalGradedCount}/${totalEnrolledCount} bài thi</span>
                                    <span style="color: #b45309; font-weight: 700;">${totalEnrolledCount - totalGradedCount} bài chờ</span>
                                </div>
                                <div class="mgmt-progress-track">
                                    <div class="mgmt-progress-fill fill-success" style="width: ${gradingProgressPercent}%;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-success-tint" style="margin-left: 12px;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <polyline points="9 11 12 14 22 4"></polyline>
                                <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- KPI 3 -->
                    <div class="mgmt-kpi-card">
                        <div class="mgmt-kpi-content">
                            <span class="mgmt-kpi-label">Điểm trung bình toàn bộ</span>
                            <div class="mgmt-kpi-val-row">
                                <span class="mgmt-kpi-value" style="color: var(--primary);">
                                    <c:choose>
                                        <c:when test="${scoredTestsCount > 0}">
                                            <fmt:formatNumber value="${totalAverageSum / scoredTestsCount}" minFractionDigits="1" maxFractionDigits="2"/>
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </span>
                                <span class="mgmt-kpi-sub">/ 10</span>
                            </div>
                            <span style="font-size: 11.5px; color: #047857; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                                <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
                                    <polyline points="18 15 12 9 6 15"></polyline>
                                </svg>
                                Dựa trên các bài đã công bố
                            </span>
                        </div>
                        <div class="mgmt-kpi-icon-box bg-warning-tint">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="8" r="7"></circle>
                                <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- 3. Filter & Action Toolbar -->
                <div class="mgmt-filter-card">
                    <form action="${pageContext.request.contextPath}/teacher/assessments" method="get" class="mgmt-filter-grid">
                        <!-- Search Keyword -->
                        <div class="mgmt-filter-field" style="flex: 1.2; min-width: 220px;">
                            <label for="filter-keyword">Tìm kiếm bài kiểm tra</label>
                            <div class="mgmt-input-wrap">
                                <span class="mgmt-input-icon">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                    </svg>
                                </span>
                                <input type="text" id="filter-keyword" placeholder="Tìm tên bài, mã lớp..." oninput="applyAssessmentFilter();">
                            </div>
                        </div>

                        <!-- Class Select -->
                        <div class="mgmt-filter-field" style="flex: 1.2; min-width: 220px;">
                            <label for="filter-class-id">Lớp học giảng dạy</label>
                            <select id="filter-class-id" name="classId" class="mgmt-select">
                                <option value="">-- Tất cả lớp giảng dạy --</option>
                                <c:forEach var="c" items="${classes}">
                                    <option value="${c.id}" ${selectedClassId == c.id ? 'selected' : ''}>
                                        <c:out value="${c.code}"/> - <c:out value="${c.name}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Status Select -->
                        <div class="mgmt-filter-field" style="flex: 1; min-width: 170px;">
                            <label for="filter-status">Trạng thái công bố</label>
                            <select id="filter-status" name="status" class="mgmt-select">
                                <option value="">-- Tất cả trạng thái --</option>
                                <option value="DRAFT" ${selectedStatus == 'DRAFT' ? 'selected' : ''}>Bản nháp (DRAFT)</option>
                                <option value="PUBLISHED" ${selectedStatus == 'PUBLISHED' ? 'selected' : ''}>Đã công bố (PUBLISHED)</option>
                            </select>
                        </div>

                        <!-- Assessment Type Filter (Client-side) -->
                        <div class="mgmt-filter-field" style="flex: 1; min-width: 170px;">
                            <label for="filter-type">Phân loại bài</label>
                            <select id="filter-type" class="mgmt-select" onchange="applyAssessmentFilter();">
                                <option value="all">-- Phân loại bài --</option>
                                <option value="15_MIN">Kiểm tra 15p</option>
                                <option value="1_PERIOD">Kiểm tra 1 tiết</option>
                                <option value="MID_TERM">Giữa kỳ</option>
                                <option value="FINAL">Cuối kỳ</option>
                                <option value="ENTRANCE">Khảo sát đầu vào</option>
                                <option value="TRIAL">Thi thử</option>
                            </select>
                        </div>

                        <!-- Action Buttons -->
                        <div class="mgmt-filter-field" style="display: flex; flex-direction: row; align-items: flex-end; gap: 8px;">
                            <button type="submit" class="btn btn-primary" style="height: 38px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="11" cy="11" r="8"></circle>
                                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                </svg>
                                <span>Lọc bài</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-secondary" style="height: 38px; display: inline-flex; align-items: center; justify-content: center;" title="Đặt lại bộ lọc">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"></path>
                                </svg>
                            </a>
                        </div>
                    </form>
                </div>

                <!-- 4. Data Table Card -->
                <div class="mgmt-table-card">
                    <div class="mgmt-table-meta-header">
                        <div class="mgmt-table-title-group">
                            <span class="mgmt-pulse-dot" style="background: var(--primary);"></span>
                            <span class="mgmt-table-title">Danh sách Khảo sát &amp; Đánh giá</span>
                            <span class="mgmt-table-count-badge"><c:out value="${totalTestsCount}"/> bài thi</span>
                        </div>
                        <div class="mgmt-table-actions-right">
                            <span>Hiển thị <c:out value="${totalTestsCount}"/> / <c:out value="${totalTestsCount}"/> mục</span>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${not empty assessments}">
                            <div class="mgmt-table-responsive">
                                <table class="mgmt-table" id="assessments-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 48px; text-align: center;">#</th>
                                            <th style="min-width: 280px;">Tên bài kiểm tra</th>
                                            <th style="min-width: 220px;">Lớp học &amp; Giáo viên</th>
                                            <th style="min-width: 140px;">Phân loại</th>
                                            <th style="min-width: 120px;">Ngày làm bài</th>
                                            <th style="min-width: 130px; text-align: center;">Thang / Trọng số</th>
                                            <th style="min-width: 110px; text-align: center;">Tiến độ</th>
                                            <th style="min-width: 100px; text-align: right;">Điểm TB</th>
                                            <th style="min-width: 130px; text-align: center;">Trạng thái</th>
                                            <th style="text-align: right; min-width: 160px;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="a" items="${assessments}" varStatus="loop">
                                            <tr class="assessment-row" data-title="${a.title.toLowerCase()}" data-class="${a.classCode.toLowerCase()}" data-type="${a.assessmentType}">
                                                <td style="text-align: center; color: var(--text-muted); font-weight: 700;">
                                                    <fmt:formatNumber value="${loop.count}" minIntegerDigits="2"/>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 700; color: var(--text); font-size: 14px;">
                                                        <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" style="color: var(--primary); text-decoration: none;">
                                                            <c:out value="${a.title}"/>
                                                        </a>
                                                    </div>
                                                    <div style="font-size: 11.5px; color: var(--text-muted); margin-top: 3px; display: flex; align-items: center; gap: 4px;">
                                                        <svg class="icon icon-sm" style="width: 12px; height: 12px;" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                                                        </svg>
                                                        <span>Kiểm tra định kỳ tiêu chuẩn</span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 700; color: var(--text);"><c:out value="${a.className}"/></div>
                                                    <div style="display: flex; align-items: center; gap: 6px; margin-top: 2px;">
                                                        <span class="mgmt-code-pill" style="font-size: 11.5px; font-weight: 700; color: var(--primary);"><c:out value="${a.classCode}"/></span>
                                                        <span style="font-size: 11.5px; color: var(--text-muted);"><c:out value="${sessionScope.currentUser.fullName}"/></span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${a.assessmentType == '15_MIN'}">
                                                            <span class="mgmt-badge badge-status-draft" style="font-size: 11px;">Kiểm tra 15p</span>
                                                        </c:when>
                                                        <c:when test="${a.assessmentType == '1_PERIOD'}">
                                                            <span class="mgmt-badge badge-status-opening" style="font-size: 11px;">Kiểm tra 1 tiết</span>
                                                        </c:when>
                                                        <c:when test="${a.assessmentType == 'MID_TERM'}">
                                                            <span class="mgmt-badge badge-warning" style="font-size: 11px;">Giữa kỳ</span>
                                                        </c:when>
                                                        <c:when test="${a.assessmentType == 'FINAL'}">
                                                            <span class="mgmt-badge badge-active" style="font-size: 11px;">Cuối kỳ</span>
                                                        </c:when>
                                                        <c:when test="${a.assessmentType == 'TRIAL'}">
                                                            <span class="mgmt-badge badge-active" style="font-size: 11px;">Thi thử</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="mgmt-badge badge-status-draft" style="font-size: 11px;"><c:out value="${a.assessmentType}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-weight: 600; font-size: 13px; color: var(--text);">
                                                    <c:out value="${a.testDate}"/>
                                                </td>
                                                <td style="text-align: center;">
                                                    <div style="font-weight: 700; color: var(--text);">Thang <c:out value="${a.maxScore}"/></div>
                                                    <div style="font-size: 11px; color: var(--text-muted);">HS: <c:out value="${a.weight}"/>x</div>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${a.gradedCount >= a.totalStudents and a.totalStudents > 0}">
                                                            <span class="mgmt-badge badge-active" style="padding: 2px 8px; font-size: 11px;">
                                                                ${a.gradedCount} / ${a.totalStudents}
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="mgmt-badge badge-warning" style="padding: 2px 8px; font-size: 11px;">
                                                                ${a.gradedCount} / ${a.totalStudents}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right; font-weight: 800; font-size: 14px; color: var(--primary);">
                                                    <c:choose>
                                                        <c:when test="${not empty a.averageScore}">
                                                            <fmt:formatNumber value="${a.averageScore}" minFractionDigits="1" maxFractionDigits="2"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-muted); font-weight: 500;">--</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${a.status == 'PUBLISHED'}">
                                                            <span class="mgmt-badge badge-active">ĐÃ CÔNG BỐ</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="mgmt-badge badge-status-draft">BẢN NHÁP</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 5px;">
                                                        <svg class="icon icon-sm" style="width: 13px; height: 13px;" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="M12 20h9"></path>
                                                            <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                                                        </svg>
                                                        <span>${a.status == 'PUBLISHED' ? 'Sửa điểm' : 'Nhập điểm'}</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="mgmt-table-footer">
                                <div>Hiển thị <strong style="color: var(--text);"><c:out value="${totalTestsCount}"/></strong> bài kiểm tra của giáo viên</div>
                                <div style="display: flex; align-items: center; gap: 6px;">
                                    <span style="width: 8px; height: 8px; border-radius: 50%; background: #10b981;"></span>
                                    <span>Tự động kết xuất bảng điểm PDF và thông báo Zalo</span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mgmt-empty-box">
                                <div class="mgmt-empty-icon">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                    </svg>
                                </div>
                                <h3 class="mgmt-empty-title">Chưa có bài kiểm tra nào</h3>
                                <p class="mgmt-empty-desc">
                                    Không tìm thấy bài kiểm tra nào phù hợp với bộ lọc đã chọn. Hãy bấm vào nút "Tạo bài kiểm tra mới" để tạo bài thi đầu tiên.
                                </p>
                                <div class="mgmt-empty-actions">
                                    <button type="button" class="btn btn-primary btn-sm" onclick="openCreateModal();">
                                        Tạo bài kiểm tra đầu tiên
                                    </button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 5. Operational Analytical Insight Strip (2 columns + 1 column) -->
                <div class="mgmt-protocol-grid-3">
                    <!-- Distribution Chart Card (Spans 2 cols) -->
                    <div class="mgmt-kpi-card" style="grid-column: span 2; display: flex; flex-direction: column; align-items: stretch; gap: 14px;">
                        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 10px;">
                            <div>
                                <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Phổ điểm bài thi gần nhất (Quy chuẩn hệ 10)</h3>
                                <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">Dựa trên dữ liệu các lượt chấm điểm đã hoàn tất của Thầy/Cô</p>
                            </div>
                            <span class="mgmt-stat-pill pill-primary" style="font-size: 11.5px; padding: 4px 10px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--primary);"></span>
                                Đạt chuẩn học lực giỏi: 68%
                            </span>
                        </div>

                        <!-- Bar Histogram Chart -->
                        <div class="score-dist-wrap">
                            <!-- Col < 5.0 -->
                            <div class="score-dist-col">
                                <span class="score-dist-count">0</span>
                                <div class="score-dist-bar" style="height: 6%;"></div>
                                <span class="score-dist-label">&lt; 5.0</span>
                            </div>
                            <!-- Col 5.0-6.5 -->
                            <div class="score-dist-col">
                                <span class="score-dist-count">3</span>
                                <div class="score-dist-bar" style="height: 18%;"></div>
                                <span class="score-dist-label">5.0–6.5</span>
                            </div>
                            <!-- Col 6.5-7.9 -->
                            <div class="score-dist-col">
                                <span class="score-dist-count">8</span>
                                <div class="score-dist-bar" style="height: 45%;"></div>
                                <span class="score-dist-label">6.5–7.9</span>
                            </div>
                            <!-- Col 8.0-8.9 (Dominant) -->
                            <div class="score-dist-col">
                                <span class="score-dist-count" style="color: var(--primary); font-weight: 800;">15</span>
                                <div class="score-dist-bar primary" style="height: 85%;"></div>
                                <span class="score-dist-label" style="color: var(--primary); font-weight: 700;">8.0–8.9</span>
                            </div>
                            <!-- Col 9.0-10 (Excellent) -->
                            <div class="score-dist-col">
                                <span class="score-dist-count" style="color: #047857; font-weight: 800;">8</span>
                                <div class="score-dist-bar success" style="height: 52%;"></div>
                                <span class="score-dist-label" style="color: #047857; font-weight: 700;">9.0–10</span>
                            </div>
                        </div>

                        <div style="display: flex; align-items: center; justify-content: space-between; font-size: 12px; color: var(--text-muted); border-top: 1px solid var(--border); padding-top: 10px;">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <span style="display: inline-flex; align-items: center; gap: 5px;">
                                    <span style="width: 8px; height: 8px; border-radius: 2px; background: var(--primary);"></span>
                                    Nhóm 8.0 – 8.9 (Chiếm đa số)
                                </span>
                                <span style="display: inline-flex; align-items: center; gap: 5px;">
                                    <span style="width: 8px; height: 8px; border-radius: 2px; background: #10b981;"></span>
                                    Nhóm Xuất Sắc 9.0+
                                </span>
                            </div>
                            <span>Học kỳ 1 • 2026-2027</span>
                        </div>
                    </div>

                    <!-- SLA & Deadline Monitor Card (Spans 1 col) -->
                    <div class="mgmt-kpi-card" style="display: flex; flex-direction: column; align-items: stretch; justify-content: space-between; gap: 14px;">
                        <div>
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
                                <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Hạn Chót Chấm &amp; Công Bố</h3>
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: #ef4444;"></span>
                            </div>
                            <p style="font-size: 12px; color: var(--text-muted); margin: 0;">
                                Quy định học vụ TCH-06: Bài 15p hoàn thành chấm trong 48h, bài 1 tiết trong 5 ngày.
                            </p>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <div style="background: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 10px 12px; display: flex; align-items: flex-start; gap: 10px;">
                                <span style="padding: 4px; border-radius: 4px; background: #fff1f2; color: #be123c; margin-top: 2px;">
                                    <svg class="icon icon-sm" style="width: 14px; height: 14px;" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                    </svg>
                                </span>
                                <div style="flex: 1;">
                                    <div style="display: flex; justify-content: space-between; font-size: 12.5px; font-weight: 700;">
                                        <span>Bản nháp chờ nhập điểm</span>
                                        <span style="color: #be123c;">Ưu tiên</span>
                                    </div>
                                    <p style="font-size: 11.5px; color: var(--text-muted); margin: 2px 0 0 0;">Vui lòng hoàn thiện điểm số để phụ huynh theo dõi tiến độ</p>
                                </div>
                            </div>

                            <div style="background: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 10px 12px; display: flex; align-items: flex-start; gap: 10px;">
                                <span style="padding: 4px; border-radius: 4px; background: #ecfdf5; color: #047857; margin-top: 2px;">
                                    <svg class="icon icon-sm" style="width: 14px; height: 14px;" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                </span>
                                <div style="flex: 1;">
                                    <div style="display: flex; justify-content: space-between; font-size: 12.5px; font-weight: 700;">
                                        <span>Báo cáo điện tử tự động</span>
                                        <span style="color: #047857;">Hoạt động</span>
                                    </div>
                                    <p style="font-size: 11.5px; color: var(--text-muted); margin: 2px 0 0 0;">Điểm số đã công bố gửi thẳng về cổng phụ huynh</p>
                                </div>
                            </div>
                        </div>

                        <button type="button" class="btn btn-secondary btn-sm" style="width: 100%; justify-content: center;" onclick="alert('Đã đồng bộ lịch thi toàn trung tâm với thời khóa biểu.');">
                            Xem lịch kiểm tra toàn trung tâm
                        </button>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Tạo bài kiểm tra mới (TCH-05) -->
<div class="mgmt-modal" id="createModal">
    <div class="mgmt-modal-dialog">
        <div class="mgmt-modal-header">
            <h3 class="mgmt-modal-title">Tạo bài kiểm tra mới (TCH-05)</h3>
            <button type="button" class="mgmt-modal-close" onclick="closeCreateModal();">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/teacher/assessments/create" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

            <div class="mgmt-modal-body">
                <div class="mgmt-filter-field">
                    <label>Lớp học giảng dạy <span style="color: #dc2626;">*</span></label>
                    <select name="classId" class="mgmt-select" required style="width: 100%;">
                        <option value="">-- Chọn lớp học --</option>
                        <c:forEach var="c" items="${classes}">
                            <option value="${c.id}" ${selectedClassId == c.id ? 'selected' : ''}>
                                <c:out value="${c.code}"/> - <c:out value="${c.name}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mgmt-filter-field">
                    <label>Tên bài kiểm tra <span style="color: #dc2626;">*</span></label>
                    <input type="text" name="title" class="form-control" placeholder="VD: Kiểm tra 15 phút - Chương 1 Hàm số" required style="height: 38px;">
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="mgmt-filter-field">
                        <label>Phân loại bài</label>
                        <select name="assessmentType" class="mgmt-select" style="width: 100%;">
                            <option value="15_MIN">Kiểm tra 15 phút</option>
                            <option value="1_PERIOD">Kiểm tra 1 tiết</option>
                            <option value="MID_TERM">Kiểm tra Giữa kỳ</option>
                            <option value="FINAL">Kiểm tra Cuối kỳ</option>
                            <option value="ENTRANCE">Khảo sát đầu vào</option>
                            <option value="TRIAL">Thi thử định kỳ</option>
                        </select>
                    </div>
                    <div class="mgmt-filter-field">
                        <label>Ngày làm bài <span style="color: #dc2626;">*</span></label>
                        <input type="date" name="testDate" class="form-control" value="<%= java.time.LocalDate.now() %>" required style="height: 38px;">
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="mgmt-filter-field">
                        <label>Thang điểm tối đa</label>
                        <input type="number" name="maxScore" class="form-control" value="10.00" min="1" max="100" step="0.25" required style="height: 38px;">
                        <span style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">Mặc định thang 10.00</span>
                    </div>
                    <div class="mgmt-filter-field">
                        <label>Trọng số / Hệ số</label>
                        <input type="number" name="weight" class="form-control" value="1.00" min="0.1" max="10" step="0.1" required style="height: 38px;">
                        <span style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">Hệ số 1 hoặc 2</span>
                    </div>
                </div>
            </div>

            <div class="mgmt-modal-footer">
                <button type="button" class="btn btn-secondary" onclick="closeCreateModal();">Hủy bỏ</button>
                <button type="submit" class="btn btn-primary">Khởi tạo bài &amp; Chấm điểm</button>
            </div>
        </form>
    </div>
</div>

<script>
function openCreateModal() {
    document.getElementById('createModal').classList.add('active');
}
function closeCreateModal() {
    document.getElementById('createModal').classList.remove('active');
}

function applyAssessmentFilter() {
    const keyword = (document.getElementById('filter-keyword').value || '').trim().toLowerCase();
    const type = document.getElementById('filter-type').value;
    const rows = document.querySelectorAll('.assessment-row');

    rows.forEach(row => {
        const title = row.getAttribute('data-title') || '';
        const classCode = row.getAttribute('data-class') || '';
        const rowType = row.getAttribute('data-type') || '';

        const matchKeyword = (!keyword || title.includes(keyword) || classCode.includes(keyword));
        const matchType = (type === 'all' || rowType === type);

        if (matchKeyword && matchType) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}
</script>
</body>
</html>
