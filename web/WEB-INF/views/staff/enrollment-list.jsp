<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .badge-active { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .badge-reserved { background: #fef9c3; color: #854d0e; border: 1px solid #fef08a; }
        .badge-transferred { background: #e0f2fe; color: #0369a1; border: 1px solid #bae6fd; }
        .badge-dropped { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
        .badge-completed { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }

        .modal {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(4px);
            z-index: 1050;
            align-items: center;
            justify-content: center;
            padding: 16px;
        }
        .modal.show { display: flex; }
        .modal-dialog {
            background: var(--surface, #ffffff);
            border-radius: var(--radius-lg, 12px);
            width: 100%;
            max-width: 620px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border, #e2e8f0);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-10px) scale(0.98); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .modal-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border, #e2e8f0);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-title { font-size: 1.125rem; font-weight: 600; color: var(--text, #0f172a); margin: 0; }
        .modal-close {
            background: none; border: none; font-size: 1.25rem; color: var(--text-muted, #64748b);
            cursor: pointer; padding: 4px; border-radius: var(--radius-sm, 6px);
            display: flex; align-items: center; justify-content: center;
        }
        .modal-close:hover { color: var(--text, #0f172a); background: var(--bg-hover, #f1f5f9); }
        .modal-body { padding: 20px; max-height: calc(85vh - 120px); overflow-y: auto; }
        .modal-footer {
            padding: 14px 20px;
            border-top: 1px solid var(--border, #e2e8f0);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: var(--bg-subtle, #f8fafc);
        }
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 0.875rem; font-weight: 500; color: var(--text, #0f172a); margin-bottom: 6px; }
        .form-label .required { color: var(--danger, #ef4444); }
        .form-control, .form-select {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid var(--border, #cbd5e1);
            border-radius: var(--radius-md, 8px);
            background: var(--surface, #ffffff);
            color: var(--text, #0f172a);
            font-size: 0.875rem;
            transition: border-color 0.15s ease, box-shadow 0.15s ease;
        }
        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: var(--primary, #2563eb);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }
        .info-callout {
            background: #eff6ff;
            border-left: 4px solid var(--primary, #2563eb);
            padding: 12px 14px;
            border-radius: 4px;
            font-size: 0.85rem;
            color: #1e40af;
            margin-bottom: 16px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="enrollments" scope="request" />
    <c:set var="breadcrumb" value="Tuyển sinh & Khách hàng / Ghi danh & Xếp lớp" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Page Header -->
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h1 class="page-title">Quản lý Ghi danh & Xếp lớp</h1>
                    <p class="page-subtitle">Thực hiện ghi danh học viên, xếp lớp, quản lý chuyển lớp, bảo lưu và khởi tạo hóa đơn học phí (ADM-12)</p>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" onclick="openEnrollModal()" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="stroke-width: 2.5;">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Ghi danh học viên mới</span>
                    </button>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- KPI Summary Cards -->
            <div class="kpi-grid">
                <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div class="kpi-label">Đang theo học (Active)</div>
                        <div class="kpi-value" style="color: var(--success, #16a34a);"><c:out value="${pageData.totalActive}" /></div>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: var(--success-subtle, #dcfce7); color: var(--success, #16a34a); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <polyline points="16 11 18 13 22 9"></polyline>
                        </svg>
                    </div>
                </div>
                <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div class="kpi-label">Đang bảo lưu (Reserved)</div>
                        <div class="kpi-value" style="color: #b45309;"><c:out value="${pageData.totalReserved}" /></div>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #fef9c3; color: #b45309; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                    </div>
                </div>
                <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div class="kpi-label">Đã chuyển lớp (Transferred)</div>
                        <div class="kpi-value" style="color: #0284c7;"><c:out value="${pageData.totalTransferred}" /></div>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #e0f2fe; color: #0284c7; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="m16 3 4 4-4 4"></path>
                            <path d="M20 7H4"></path>
                            <path d="m8 21-4-4 4-4"></path>
                            <path d="M4 17h16"></path>
                        </svg>
                    </div>
                </div>
                <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div class="kpi-label">Đã thôi học (Dropped)</div>
                        <div class="kpi-value" style="color: var(--danger, #dc2626);"><c:out value="${pageData.totalDropped}" /></div>
                    </div>
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="15" y1="9" x2="9" y2="15"></line>
                            <line x1="9" y1="9" x2="15" y2="15"></line>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Filter & Search Toolbar -->
            <div class="filter-toolbar">
                <form action="${pageContext.request.contextPath}/staff/enrollments" method="get" class="filter-form" style="display: flex; flex-wrap: wrap; gap: 12px; align-items: center;">
                    <!-- Search Keyword -->
                    <div class="filter-search input-wrapper" style="flex: 1; min-width: 260px;">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <input type="text" name="q" class="form-control" placeholder="Tìm theo tên học viên, SĐT..."
                               value="<c:out value='${pageData.keyword}' />">
                    </div>

                    <!-- Class Filter -->
                    <select name="classId" class="filter-select" style="min-width: 220px;">
                        <option value="">-- Tất cả lớp học --</option>
                        <c:forEach var="c" items="${pageData.classOptions}">
                            <option value="${c.classId}" ${pageData.classId == c.classId ? 'selected' : ''}>
                                <c:out value="${c.classCode}"/> - <c:out value="${c.className}"/> (<c:out value="${c.currentEnrolled}"/>/<c:out value="${c.capacity}"/>)
                            </option>
                        </c:forEach>
                    </select>

                    <!-- Status Filter -->
                    <select name="status" class="filter-select" style="min-width: 170px;">
                        <option value="">-- Trạng thái --</option>
                        <option value="ACTIVE" ${pageData.status == 'ACTIVE' ? 'selected' : ''}>Đang học (ACTIVE)</option>
                        <option value="RESERVED" ${pageData.status == 'RESERVED' ? 'selected' : ''}>Bảo lưu (RESERVED)</option>
                        <option value="TRANSFERRED" ${pageData.status == 'TRANSFERRED' ? 'selected' : ''}>Đã chuyển lớp (TRANSFERRED)</option>
                        <option value="DROPPED" ${pageData.status == 'DROPPED' ? 'selected' : ''}>Thôi học (DROPPED)</option>
                        <option value="COMPLETED" ${pageData.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành (COMPLETED)</option>
                    </select>

                    <button type="submit" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                        </svg>
                        <span>Lọc kết quả</span>
                    </button>
                    <c:if test="${not empty pageData.keyword or not empty pageData.status or not empty pageData.classId}">
                        <a href="${pageContext.request.contextPath}/staff/enrollments" class="btn btn-ghost" style="color: var(--text-muted);">Xóa lọc</a>
                    </c:if>
                </form>
            </div>

            <!-- Enrollment List Table -->
            <div class="admin-card">
                <c:choose>
                    <c:when test="${not empty pageData.items}">
                        <div class="table-responsive">
                            <table class="table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="width: 48px; text-align: center;">#</th>
                                    <th>Học viên</th>
                                    <th>Lớp học & Môn</th>
                                    <th>Học phí khóa</th>
                                    <th>Ngày bắt đầu</th>
                                    <th>Trạng thái</th>
                                    <th>Hóa đơn</th>
                                    <th style="text-align: right; width: 150px;">Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${pageData.items}" varStatus="loop">
                                    <tr>
                                        <td style="text-align: center; color: var(--text-muted); font-size: 0.85rem;">
                                            ${(pageData.currentPage - 1) * pageData.pageSize + loop.count}
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: var(--text);">
                                                <c:out value="${item.studentName}" />
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted); display: flex; gap: 8px; margin-top: 2px;">
                                                <span>Mã: <strong><c:out value="${item.studentCode}" /></strong></span>
                                                <c:if test="${not empty item.studentPhone}">
                                                    <span>• SĐT: <c:out value="${item.studentPhone}" /></span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500; color: var(--text);">
                                                <c:out value="${item.className}" />
                                            </div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                Mã lớp: <code><c:out value="${item.classCode}" /></code> • Môn: <c:out value="${item.subjectName}" />
                                            </div>
                                        </td>
                                        <td style="font-weight: 600; color: var(--primary);">
                                            <fmt:formatNumber value="${item.courseFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                        </td>
                                        <td>
                                            <div style="font-size: 0.875rem;"><c:out value="${item.startDate}" /></div>
                                            <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                Ghi danh: <c:out value="${item.enrolledAtFormatted}" />
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.status == 'ACTIVE'}">
                                                    <span class="status-badge badge-active">Đang học</span>
                                                </c:when>
                                                <c:when test="${item.status == 'RESERVED'}">
                                                    <span class="status-badge badge-reserved">Bảo lưu</span>
                                                </c:when>
                                                <c:when test="${item.status == 'TRANSFERRED'}">
                                                    <span class="status-badge badge-transferred">Đã chuyển lớp</span>
                                                </c:when>
                                                <c:when test="${item.status == 'DROPPED'}">
                                                    <span class="status-badge badge-dropped">Thôi học</span>
                                                </c:when>
                                                <c:when test="${item.status == 'COMPLETED'}">
                                                    <span class="status-badge badge-completed">Hoàn thành</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge badge-neutral"><c:out value="${item.status}" /></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.invoiceCode}">
                                                    <div style="font-family: monospace; font-size: 0.85rem; font-weight: 500;">
                                                        <c:out value="${item.invoiceCode}" />
                                                    </div>
                                                    <span style="font-size: 0.75rem; color: ${item.invoiceStatus == 'PAID' ? 'var(--success)' : '#eab308'}; font-weight: 600;">
                                                        <c:out value="${item.invoiceStatus}" />
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--text-muted); font-size: 0.8rem;">Chưa có</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: right;">
                                            <div style="display: inline-flex; gap: 4px;">
                                                <c:if test="${item.status == 'ACTIVE'}">
                                                    <!-- Nút Chuyển lớp -->
                                                    <button type="button" class="btn btn-ghost btn-sm" title="Chuyển lớp cho học viên"
                                                            data-id="${item.enrollmentId}"
                                                            data-student-name="<c:out value='${item.studentName}'/>"
                                                            data-class-id="${item.classId}"
                                                            data-class-name="<c:out value='${item.className}'/>"
                                                            onclick="openTransferModalFromBtn(this)">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <path d="m16 3 4 4-4 4"></path>
                                                            <path d="M20 7H4"></path>
                                                            <path d="m8 21-4-4 4-4"></path>
                                                            <path d="M4 17h16"></path>
                                                        </svg>
                                                    </button>
                                                    <!-- Nút Bảo lưu -->
                                                    <button type="button" class="btn btn-ghost btn-sm" title="Bảo lưu học tập"
                                                            data-id="${item.enrollmentId}"
                                                            data-student-name="<c:out value='${item.studentName}'/>"
                                                            data-class-name="<c:out value='${item.className}'/>"
                                                            onclick="openReserveModalFromBtn(this)">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                    </button>
                                                    <!-- Nút Thôi học -->
                                                    <button type="button" class="btn btn-ghost btn-sm" style="color: var(--danger);" title="Thôi học / Rút hồ sơ"
                                                            data-id="${item.enrollmentId}"
                                                            data-student-name="<c:out value='${item.studentName}'/>"
                                                            data-class-name="<c:out value='${item.className}'/>"
                                                            onclick="openDropModalFromBtn(this)">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <line x1="15" y1="9" x2="9" y2="15"></line>
                                                            <line x1="9" y1="9" x2="15" y2="15"></line>
                                                        </svg>
                                                    </button>
                                                </c:if>

                                                <c:if test="${item.status == 'RESERVED'}">
                                                    <!-- Nút Phục hồi học tập -->
                                                    <form action="${pageContext.request.contextPath}/staff/enrollments/resume" method="post" style="display: inline;"
                                                          data-student-name="<c:out value='${item.studentName}'/>"
                                                          onsubmit="return confirm('Xác nhận phục hồi học tập cho học viên ' + this.getAttribute('data-student-name') + '? (Sẽ kiểm tra sĩ số lớp)');">
                                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                                        <input type="hidden" name="enrollmentId" value="${item.enrollmentId}">
                                                        <button type="submit" class="btn btn-ghost btn-sm" style="color: var(--success);" title="Quay lại học">
                                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                                <polyline points="23 4 23 10 17 10"></polyline>
                                                                <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path>
                                                            </svg>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${pageData.totalPages > 1}">
                            <div class="pagination-wrapper" style="display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; border-top: 1px solid var(--border);">
                                <div style="font-size: 0.875rem; color: var(--text-muted);">
                                    Hiển thị trang <strong>${pageData.currentPage}</strong> / ${pageData.totalPages} (Tổng số <strong>${pageData.totalRecords}</strong> bản ghi)
                                </div>
                                <div class="pagination" style="display: flex; gap: 6px;">
                                    <c:if test="${pageData.hasPrevious()}">
                                        <a href="${pageContext.request.contextPath}/staff/enrollments?page=${pageData.currentPage - 1}&classId=${pageData.classId}&status=${pageData.status}&q=${pageData.keyword}" class="btn btn-secondary btn-sm">Trước</a>
                                    </c:if>
                                    <c:forEach begin="1" end="${pageData.totalPages}" var="p">
                                        <a href="${pageContext.request.contextPath}/staff/enrollments?page=${p}&classId=${pageData.classId}&status=${pageData.status}&q=${pageData.keyword}"
                                           class="btn btn-sm ${p == pageData.currentPage ? 'btn-primary' : 'btn-ghost'}">${p}</a>
                                    </c:forEach>
                                    <c:if test="${pageData.hasNext()}">
                                        <a href="${pageContext.request.contextPath}/staff/enrollments?page=${pageData.currentPage + 1}&classId=${pageData.classId}&status=${pageData.status}&q=${pageData.keyword}" class="btn btn-secondary btn-sm">Sau</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="empty-state" style="padding: 60px 20px; text-align: center;">
                            <div style="width: 64px; height: 64px; border-radius: 50%; background: var(--bg-subtle); display: flex; align-items: center; justify-content: center; margin: 0 auto 16px; color: var(--text-muted);">
                                <svg class="icon icon-lg" style="width: 32px; height: 32px;" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <polyline points="16 11 18 13 22 9"></polyline>
                                </svg>
                            </div>
                            <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin-bottom: 6px;">Chưa có dữ liệu ghi danh</h3>
                            <p style="font-size: 0.875rem; color: var(--text-muted); max-width: 420px; margin: 0 auto 20px;">
                                Chưa có học viên nào được ghi danh theo bộ lọc này hoặc trung tâm chưa khởi tạo lượt ghi danh nào.
                            </p>
                            <button type="button" class="btn btn-primary" onclick="openEnrollModal()">
                                Ghi danh học viên ngay
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<!-- Modal 1: Ghi danh mới (Save Enrollment) -->
<div class="modal" id="enrollModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Ghi danh học viên vào lớp học</h3>
                <button type="button" class="modal-close" onclick="closeModal('enrollModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/enrollments/save" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <div class="modal-body">
                    <div class="info-callout">
                        <strong>Quy tắc nghiệp vụ:</strong> Hệ thống sẽ tự động kiểm tra sĩ số lớp học (BR04), xung đột thời khóa biểu buổi học (BR07), và đồng thời khởi tạo hóa đơn học phí tương ứng (BR12) trong cùng một giao dịch.
                    </div>

                    <!-- Chọn học sinh -->
                    <div class="form-group">
                        <label class="form-label">Chọn học viên <span class="required">*</span></label>
                        <select name="studentId" class="form-select" required>
                            <option value="">-- Chọn học viên từ danh sách hồ sơ --</option>
                            <c:forEach var="s" items="${pageData.studentOptions}">
                                <option value="${s.id}">
                                    <c:out value="${s.fullName}"/> - Mã: <c:out value="${s.code}"/> (<c:out value="${s.phone}"/>)
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Chọn lớp học -->
                    <div class="form-group">
                        <label class="form-label">Chọn lớp học tiếp nhận <span class="required">*</span></label>
                        <select name="classId" id="enrollClassSelect" class="form-select" required onchange="handleClassSelectChange(this)">
                            <option value="" data-fee="0" data-start="">-- Chọn lớp học mở (OPEN/ONGOING) --</option>
                            <c:forEach var="c" items="${pageData.classOptions}">
                                <option value="${c.classId}" data-fee="${c.fee}" data-start="${c.startDate}" ${c.full ? 'disabled' : ''}>
                                    <c:out value="${c.classCode}"/> - <c:out value="${c.className}"/>
                                    [Sĩ số: <c:out value="${c.currentEnrolled}"/>/<c:out value="${c.capacity}"/>]
                                    <c:if test="${c.full}"> - ĐÃ ĐẦY</c:if>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Ngày bắt đầu học -->
                    <div class="form-group">
                        <label class="form-label">Ngày bắt đầu học <span class="required">*</span></label>
                        <input type="date" name="startDate" id="enrollStartDate" class="form-control" required value="<%= java.time.LocalDate.now() %>">
                        <small style="color: var(--text-muted); font-size: 0.75rem; margin-top: 4px; display: block;">
                            Ngày bắt đầu phải nằm trong khoảng thời gian khai giảng và kết thúc của lớp.
                        </small>
                    </div>

                    <!-- Ghi chú -->
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Ghi chú ghi danh</label>
                        <textarea name="notes" class="form-control" rows="2" placeholder="Ví dụ: Đăng ký đợt 1, đã tư vấn lộ trình..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('enrollModal')">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary">Xác nhận ghi danh</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 2: Chuyển lớp (Transfer Class) -->
<div class="modal" id="transferModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Chuyển lớp học cho học viên</h3>
                <button type="button" class="modal-close" onclick="closeModal('transferModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/enrollments/transfer" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="enrollmentId" id="transferEnrollmentId">
                <div class="modal-body">
                    <div class="info-callout">
                        Học viên: <strong id="transferStudentName"></strong><br>
                        Lớp học hiện tại: <span id="transferCurrentClass"></span>
                    </div>

                    <!-- Chọn lớp mới -->
                    <div class="form-group">
                        <label class="form-label">Lớp học chuyển đến <span class="required">*</span></label>
                        <select name="newClassId" id="transferNewClassSelect" class="form-select" required>
                            <option value="">-- Chọn lớp học mới còn chỗ --</option>
                            <c:forEach var="c" items="${pageData.classOptions}">
                                <option value="${c.classId}" ${c.full ? 'disabled' : ''}>
                                    <c:out value="${c.classCode}"/> - <c:out value="${c.className}"/>
                                    [Sĩ số: <c:out value="${c.currentEnrolled}"/>/<c:out value="${c.capacity}"/>]
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Ngày chuyển -->
                    <div class="form-group">
                        <label class="form-label">Ngày hiệu lực chuyển lớp</label>
                        <input type="date" name="transferDate" class="form-control" value="<%= java.time.LocalDate.now() %>">
                    </div>

                    <!-- Ghi chú lý do chuyển -->
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Lý do chuyển lớp</label>
                        <textarea name="notes" class="form-control" rows="2" placeholder="Nhập lý do chuyển lớp..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('transferModal')">Đóng</button>
                    <button type="submit" class="btn btn-primary">Xác nhận chuyển lớp</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 3: Bảo lưu học tập (Reserve) -->
<div class="modal" id="reserveModal">
    <div class="modal-dialog" style="max-width: 480px;">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Bảo lưu học tập</h3>
                <button type="button" class="modal-close" onclick="closeModal('reserveModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/enrollments/reserve" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="enrollmentId" id="reserveEnrollmentId">
                <div class="modal-body">
                    <p style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 12px;">
                        Xác nhận bảo lưu cho học viên <strong id="reserveStudentName"></strong> tại lớp <span id="reserveClassName"></span>. Chỗ học trong lớp sẽ được giải phóng cho học viên khác.
                    </p>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Lý do bảo lưu <span class="required">*</span></label>
                        <textarea name="reason" class="form-control" rows="3" required placeholder="Nhập lý do bảo lưu theo đơn yêu cầu..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('reserveModal')">Hủy bỏ</button>
                    <button type="submit" class="btn btn-warning" style="background: #eab308; color: #fff; border: none;">Bảo lưu ngay</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal 4: Thôi học / Hủy ghi danh (Drop) -->
<div class="modal" id="dropModal">
    <div class="modal-dialog" style="max-width: 480px;">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" style="color: var(--danger);">Thôi học / Rút khỏi lớp</h3>
                <button type="button" class="modal-close" onclick="closeModal('dropModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/staff/enrollments/status" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="enrollmentId" id="dropEnrollmentId">
                <input type="hidden" name="newStatus" value="DROPPED">
                <div class="modal-body">
                    <p style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 12px;">
                        Bạn có chắc chắn muốn cập nhật trạng thái <strong>THÔI HỌC (DROPPED)</strong> cho học viên <strong id="dropStudentName"></strong> tại lớp <span id="dropClassName"></span>?
                    </p>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Lý do thôi học</label>
                        <textarea name="reason" class="form-control" rows="2" placeholder="Nhập lý do học viên dừng học..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost" onclick="closeModal('dropModal')">Hủy</button>
                    <button type="submit" class="btn btn-danger">Xác nhận thôi học</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openModal(id) {
        var el = document.getElementById(id);
        if (el) el.classList.add('show');
    }
    function closeModal(id) {
        var el = document.getElementById(id);
        if (el) el.classList.remove('show');
    }

    function openEnrollModal() {
        openModal('enrollModal');
    }

    function handleClassSelectChange(select) {
        var option = select.options[select.selectedIndex];
        var startDate = option.getAttribute('data-start');
        if (startDate && startDate !== "") {
            document.getElementById('enrollStartDate').value = startDate;
        }
    }

    function openTransferModalFromBtn(btn) {
        if (!btn) return;
        openTransferModal(
            btn.getAttribute('data-id'),
            btn.getAttribute('data-student-name'),
            btn.getAttribute('data-class-id'),
            btn.getAttribute('data-class-name')
        );
    }

    function openReserveModalFromBtn(btn) {
        if (!btn) return;
        openReserveModal(
            btn.getAttribute('data-id'),
            btn.getAttribute('data-student-name'),
            btn.getAttribute('data-class-name')
        );
    }

    function openDropModalFromBtn(btn) {
        if (!btn) return;
        openDropModal(
            btn.getAttribute('data-id'),
            btn.getAttribute('data-student-name'),
            btn.getAttribute('data-class-name')
        );
    }

    function openTransferModal(id, studentName, classId, className) {
        document.getElementById('transferEnrollmentId').value = id;
        document.getElementById('transferStudentName').textContent = studentName;
        document.getElementById('transferCurrentClass').textContent = className;

        // Vô hiệu hóa lớp hiện tại trong danh sách chọn lớp mới
        var select = document.getElementById('transferNewClassSelect');
        for (var i = 0; i < select.options.length; i++) {
            if (select.options[i].value === classId) {
                select.options[i].disabled = true;
            }
        }
        openModal('transferModal');
    }

    function openReserveModal(id, studentName, className) {
        document.getElementById('reserveEnrollmentId').value = id;
        document.getElementById('reserveStudentName').textContent = studentName;
        document.getElementById('reserveClassName').textContent = className;
        openModal('reserveModal');
    }

    function openDropModal(id, studentName, className) {
        document.getElementById('dropEnrollmentId').value = id;
        document.getElementById('dropStudentName').textContent = studentName;
        document.getElementById('dropClassName').textContent = className;
        openModal('dropModal');
    }

    // Đóng modal khi click ra ngoài dialog
    window.addEventListener('click', function(event) {
        var modals = document.querySelectorAll('.modal.show');
        modals.forEach(function(modal) {
            if (event.target === modal) {
                modal.classList.remove('show');
            }
        });
    });
</script>
</body>
</html>
