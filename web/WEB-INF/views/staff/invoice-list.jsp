<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .badge-unpaid { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; }
        .badge-partially { background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; }
        .badge-paid { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .badge-cancelled { background: #f1f5f9; color: #64748b; border: 1px solid #e2e8f0; }
        .badge-overdue { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; font-weight: 600; font-size: 0.75rem; padding: 2px 6px; border-radius: 4px; }
        .kpi-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 24px; }
        .kpi-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px 20px; box-shadow: var(--shadow-sm); }
        .kpi-title { font-size: 0.8125rem; font-weight: 500; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.025em; margin-bottom: 8px; }
        .kpi-value { font-size: 1.5rem; font-weight: 700; color: var(--text); }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="invoices" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & Khách hàng / Quản lý Hóa đơn & Học phí" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px;">
                <div>
                    <h1 class="page-title">Quản lý Hóa đơn & Thu học phí</h1>
                    <p class="page-subtitle">Theo dõi công nợ học phí, thu tiền mặt hoặc chuyển khoản và in biên lai (ADM-14, ADM-15)</p>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- KPI Cards Overview -->
            <div class="kpi-grid">
                <div class="kpi-card">
                    <div class="kpi-title">Tổng phát sinh học phí</div>
                    <div class="kpi-value" style="color: var(--primary);">
                        <fmt:formatNumber value="${pageData.totalAmountSum}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-title">Đã thu thực tế</div>
                    <div class="kpi-value" style="color: #16a34a;">
                        <fmt:formatNumber value="${pageData.totalPaidSum}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-title">Dư nợ cần thu</div>
                    <div class="kpi-value" style="color: #ea580c;">
                        <fmt:formatNumber value="${pageData.totalDebtSum}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                    </div>
                </div>
                <div class="kpi-card">
                    <div class="kpi-title">Hóa đơn quá hạn nộp</div>
                    <div class="kpi-value" style="color: #dc2626;">
                        <c:out value="${pageData.overdueCount}" />
                    </div>
                </div>
            </div>

            <!-- Filter Toolbar -->
            <div class="filter-toolbar" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px; margin-bottom: 20px;">
                <form action="${pageContext.request.contextPath}/staff/invoices" method="get" class="filter-form" style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                    <div style="flex: 1; min-width: 200px;">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm theo mã HĐ, tên, SĐT học viên..." value="<c:out value='${keyword}' />">
                    </div>
                    <div style="min-width: 180px;">
                        <select name="classId" class="form-control">
                            <option value="">-- Tất cả lớp học --</option>
                            <c:forEach var="c" items="${classes}">
                                <option value="${c.id}" ${selectedClassId == c.id ? 'selected' : ''}>
                                    <c:out value="${c.code}" /> - <c:out value="${c.name}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="min-width: 160px;">
                        <select name="status" class="form-control">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="UNPAID" ${selectedStatus == 'UNPAID' ? 'selected' : ''}>Chưa đóng (UNPAID)</option>
                            <option value="PARTIALLY_PAID" ${selectedStatus == 'PARTIALLY_PAID' ? 'selected' : ''}>Đóng một phần (PARTIALLY)</option>
                            <option value="PAID" ${selectedStatus == 'PAID' ? 'selected' : ''}>Đã thanh toán (PAID)</option>
                            <option value="OVERDUE" ${selectedStatus == 'OVERDUE' ? 'selected' : ''}>Quá hạn đóng tiền (OVERDUE)</option>
                            <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy (CANCELLED)</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <span>Lọc hóa đơn</span>
                    </button>
                    <c:if test="${not empty keyword or not empty selectedClassId or not empty selectedStatus}">
                        <a href="${pageContext.request.contextPath}/staff/invoices" class="btn btn-ghost">Xóa bộ lọc</a>
                    </c:if>
                </form>
            </div>

            <!-- Invoices Table -->
            <div class="admin-card">
                <c:choose>
                    <c:when test="${not empty pageData.items}">
                        <div class="table-responsive">
                            <table class="table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="width: 140px;">Mã hóa đơn</th>
                                    <th>Học viên</th>
                                    <th>Lớp học</th>
                                    <th style="text-align: right;">Tổng học phí</th>
                                    <th style="text-align: right;">Đã thu</th>
                                    <th style="text-align: right;">Còn nợ</th>
                                    <th>Hạn nộp</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: right; width: 140px;">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${pageData.items}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/staff/invoices/detail?id=${item.id}" style="font-weight: 600; color: var(--primary); text-decoration: none;">
                                                <code><c:out value="${item.invoiceCode}" /></code>
                                            </a>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: var(--text);"><c:out value="${item.studentName}" /></div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                <code><c:out value="${item.studentCode}" /></code> • <c:out value="${item.studentPhone}" />
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;"><c:out value="${item.className}" /></div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                <code><c:out value="${item.classCode}" /></code>
                                            </div>
                                        </td>
                                        <td style="text-align: right; font-weight: 600;">
                                            <fmt:formatNumber value="${item.finalAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td style="text-align: right; color: #16a34a; font-weight: 600;">
                                            <fmt:formatNumber value="${item.paidAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td style="text-align: right; color: ${item.debtAmount > 0 ? '#ea580c' : 'var(--text-muted)'}; font-weight: 700;">
                                            <fmt:formatNumber value="${item.debtAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                        </td>
                                        <td>
                                            <div><c:out value="${item.dueDate}" /></div>
                                            <c:if test="${item.overdue}">
                                                <span class="badge-overdue">Quá hạn</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.status == 'PAID'}">
                                                    <span class="badge badge-paid">Đã thanh toán</span>
                                                </c:when>
                                                <c:when test="${item.status == 'PARTIALLY_PAID'}">
                                                    <span class="badge badge-partially">Đóng 1 phần</span>
                                                </c:when>
                                                <c:when test="${item.status == 'CANCELLED'}">
                                                    <span class="badge badge-cancelled">Đã hủy</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-unpaid">Chưa đóng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: right; white-space: nowrap;">
                                            <a href="${pageContext.request.contextPath}/staff/invoices/detail?id=${item.id}" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                    <circle cx="12" cy="12" r="3"></circle>
                                                </svg>
                                                <span>Chi tiết</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${pageData.totalPages > 1}">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-top: 16px; border-top: 1px solid var(--border); flex-wrap: wrap; gap: 12px;">
                                <div style="font-size: 0.875rem; color: var(--text-muted);">
                                    Hiển thị trang <strong>${pageData.currentPage}</strong> / <strong>${pageData.totalPages}</strong> (Tổng cộng <strong>${pageData.totalItems}</strong> hóa đơn)
                                </div>
                                <div style="display: flex; gap: 6px;">
                                    <c:if test="${pageData.currentPage > 1}">
                                        <a href="${pageContext.request.contextPath}/staff/invoices?page=${pageData.currentPage - 1}&classId=${selectedClassId}&status=${selectedStatus}&keyword=${keyword}" class="btn btn-secondary btn-sm">Trước</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${pageData.totalPages}" var="p">
                                        <c:if test="${p == pageData.currentPage || p == 1 || p == pageData.totalPages || (p >= pageData.currentPage - 1 && p <= pageData.currentPage + 1)}">
                                            <a href="${pageContext.request.contextPath}/staff/invoices?page=${p}&classId=${selectedClassId}&status=${selectedStatus}&keyword=${keyword}" class="btn ${p == pageData.currentPage ? 'btn-primary' : 'btn-secondary'} btn-sm">${p}</a>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${pageData.currentPage < pageData.totalPages}">
                                        <a href="${pageContext.request.contextPath}/staff/invoices?page=${pageData.currentPage + 1}&classId=${selectedClassId}&status=${selectedStatus}&keyword=${keyword}" class="btn btn-secondary btn-sm">Sau</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="empty-state" style="text-align: center; padding: 48px 24px;">
                            <div style="display: inline-flex; align-items: center; justify-content: center; width: 64px; height: 64px; border-radius: 50%; background: var(--bg); margin-bottom: 16px; color: var(--text-muted);">
                                <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true" style="width: 32px; height: 32px;">
                                    <rect width="20" height="14" x="2" y="5" rx="2"></rect>
                                    <line x1="2" x2="22" y1="10" y2="10"></line>
                                </svg>
                            </div>
                            <h3 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 8px;">Không tìm thấy hóa đơn học phí nào</h3>
                            <p style="color: var(--text-muted); max-width: 460px; margin: 0 auto 20px;">
                                <c:choose>
                                    <c:when test="${not empty keyword or not empty selectedClassId or not empty selectedStatus}">
                                        Không có hóa đơn nào phù hợp với điều kiện tìm kiếm và bộ lọc đã chọn. Hãy thử xóa bộ lọc để xem toàn bộ danh sách.
                                    </c:when>
                                    <c:otherwise>
                                        Chưa có hóa đơn học phí nào được phát hành. Hóa đơn sẽ được tạo tự động khi có học viên đăng ký ghi danh vào các lớp học.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <c:if test="${not empty keyword or not empty selectedClassId or not empty selectedStatus}">
                                <a href="${pageContext.request.contextPath}/staff/invoices" class="btn btn-secondary btn-sm">Xóa bộ lọc</a>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
</body>
</html>
