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
        .kpi-row {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 1200px) {
            .kpi-row { grid-template-columns: repeat(3, 1fr); }
        }
        @media (max-width: 768px) {
            .kpi-row { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 480px) {
            .kpi-row { grid-template-columns: 1fr; }
        }
        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 16px 18px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 14px;
            transition: transform var(--transition-fast), box-shadow var(--transition-fast);
        }
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .kpi-card.accent-total { border-left: 4px solid var(--primary); }
        .kpi-card.accent-new { border-left: 4px solid #3B82F6; }
        .kpi-card.accent-consulting { border-left: 4px solid var(--warning); }
        .kpi-card.accent-enrolled { border-left: 4px solid var(--success); }
        .kpi-card.accent-lost { border-left: 4px solid var(--danger); }

        .kpi-icon-wrap {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .kpi-icon-wrap.primary { background: var(--primary-subtle); color: var(--primary); }
        .kpi-icon-wrap.info { background: #EFF6FF; color: #3B82F6; }
        .kpi-icon-wrap.warning { background: var(--warning-subtle); color: var(--warning); }
        .kpi-icon-wrap.success { background: var(--success-subtle); color: var(--success); }
        .kpi-icon-wrap.danger { background: var(--danger-subtle); color: var(--danger); }

        .kpi-value {
            font-size: 1.5rem;
            font-weight: 700;
            line-height: 1.2;
            color: var(--text);
        }
        .kpi-label {
            font-size: 0.8125rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .filter-panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 18px 20px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .filter-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr auto;
            gap: 14px;
            align-items: flex-end;
        }
        @media (max-width: 992px) {
            .filter-grid { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 576px) {
            .filter-grid { grid-template-columns: 1fr; }
        }

        .modal-backdrop-custom {
            display: none;
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 1050;
            align-items: center;
            justify-content: center;
        }
        .modal-backdrop-custom.active { display: flex; }
        .modal-box {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            width: 100%;
            max-width: 560px;
            padding: 24px 28px;
            box-shadow: var(--shadow-xl);
            max-height: 90vh;
            overflow-y: auto;
        }
    </style>
</head>
<body class="dashboard-body">
<div class="dashboard-container">
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="dashboard-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <div class="dashboard-content">
            <!-- Flash Message -->
            <c:if test="${not empty flashSuccess}">
                <div class="alert alert-success" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <span>${flashSuccess}</span>
                </div>
            </c:if>
            <c:if test="${not empty flashError}">
                <div class="alert alert-danger" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>${flashError}</span>
                </div>
            </c:if>

            <!-- Page Title & Header Actions -->
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin: 0 0 4px 0;">Quản lý Khách hàng & CRM Tuyển sinh</h1>
                    <p style="font-size: 0.875rem; color: var(--text-muted); margin: 0;">Theo dõi, phân công và chăm sóc khách hàng tiềm năng từ Website, Hotline và Trực tiếp.</p>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" onclick="openCreateModal()" style="display: flex; align-items: center; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                        <span>Tiếp nhận Khách hàng mới</span>
                    </button>
                </div>
            </div>

            <!-- KPI Row -->
            <div class="kpi-row">
                <div class="kpi-card accent-total">
                    <div class="kpi-icon-wrap primary">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                    <div>
                        <div class="kpi-value">${data.stats.total != null ? data.stats.total : 0}</div>
                        <div class="kpi-label">Tổng khách hàng</div>
                    </div>
                </div>

                <div class="kpi-card accent-new">
                    <div class="kpi-icon-wrap info">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                    </div>
                    <div>
                        <div class="kpi-value">${data.stats['new'] != null ? data.stats['new'] : 0}</div>
                        <div class="kpi-label">Mới tiếp nhận</div>
                    </div>
                </div>

                <div class="kpi-card accent-consulting">
                    <div class="kpi-icon-wrap warning">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                    </div>
                    <div>
                        <div class="kpi-value">${data.stats.consulting != null ? data.stats.consulting : 0}</div>
                        <div class="kpi-label">Đang tư vấn / Test</div>
                    </div>
                </div>

                <div class="kpi-card accent-enrolled">
                    <div class="kpi-icon-wrap success">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    </div>
                    <div>
                        <div class="kpi-value">${data.stats.enrolled != null ? data.stats.enrolled : 0}</div>
                        <div class="kpi-label">Đã ghi danh</div>
                    </div>
                </div>

                <div class="kpi-card accent-lost">
                    <div class="kpi-icon-wrap danger">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    </div>
                    <div>
                        <div class="kpi-value">${data.stats.lost != null ? data.stats.lost : 0}</div>
                        <div class="kpi-label">Hủy / Thất bại</div>
                    </div>
                </div>
            </div>

            <!-- Filter Panel -->
            <div class="filter-panel">
                <form action="${pageContext.request.contextPath}/staff/leads" method="GET" class="filter-grid">
                    <div>
                        <label class="form-label" style="font-size: 0.8125rem; font-weight: 500; margin-bottom: 6px; display: block;">Tìm kiếm</label>
                        <input type="text" name="keyword" value="${filter.keyword}" class="form-control" placeholder="Tên, số điện thoại, email...">
                    </div>

                    <div>
                        <label class="form-label" style="font-size: 0.8125rem; font-weight: 500; margin-bottom: 6px; display: block;">Trạng thái</label>
                        <select name="status" class="form-control">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="NEW" ${filter.status == 'NEW' ? 'selected' : ''}>Mới tiếp nhận</option>
                            <option value="CONTACTED" ${filter.status == 'CONTACTED' ? 'selected' : ''}>Đã liên hệ</option>
                            <option value="CONSULTING" ${filter.status == 'CONSULTING' ? 'selected' : ''}>Đang tư vấn</option>
                            <option value="ASSESSED" ${filter.status == 'ASSESSED' ? 'selected' : ''}>Đã test đầu vào</option>
                            <option value="ENROLLED" ${filter.status == 'ENROLLED' ? 'selected' : ''}>Đã ghi danh</option>
                            <option value="LOST" ${filter.status == 'LOST' ? 'selected' : ''}>Hủy / Thất bại</option>
                        </select>
                    </div>

                    <div>
                        <label class="form-label" style="font-size: 0.8125rem; font-weight: 500; margin-bottom: 6px; display: block;">Nguồn tiếp nhận</label>
                        <select name="source" class="form-control">
                            <option value="">-- Tất cả nguồn --</option>
                            <option value="WEBSITE" ${filter.source == 'WEBSITE' ? 'selected' : ''}>Website</option>
                            <option value="HOTLINE" ${filter.source == 'HOTLINE' ? 'selected' : ''}>Hotline</option>
                            <option value="DIRECT" ${filter.source == 'DIRECT' ? 'selected' : ''}>Trực tiếp tại trung tâm</option>
                            <option value="FACEBOOK" ${filter.source == 'FACEBOOK' ? 'selected' : ''}>Facebook / Fanpage</option>
                            <option value="REFERRAL" ${filter.source == 'REFERRAL' ? 'selected' : ''}>Giới thiệu</option>
                        </select>
                    </div>

                    <div>
                        <label class="form-label" style="font-size: 0.8125rem; font-weight: 500; margin-bottom: 6px; display: block;">Khối lớp</label>
                        <select name="gradeLevel" class="form-control">
                            <option value="">-- Tất cả khối --</option>
                            <c:forEach var="g" begin="6" end="12">
                                <option value="${g}" ${filter.gradeLevel == g ? 'selected' : ''}>Lớp ${g}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="display: flex; gap: 8px;">
                        <button type="submit" class="btn btn-primary" style="display: flex; align-items: center; gap: 6px; height: 38px;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            <span>Lọc</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/staff/leads" class="btn btn-secondary" style="height: 38px; display: inline-flex; align-items: center;">Đặt lại</a>
                    </div>
                </form>
            </div>

            <!-- Leads Table Panel -->
            <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); box-shadow: var(--shadow-sm); overflow: hidden;">
                <div style="padding: 16px 20px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                    <div style="font-weight: 600; color: var(--text);">
                        Danh sách Khách hàng (<fmt:formatNumber value="${data.totalCount}" pattern="#,###"/> kết quả)
                    </div>
                    <div style="font-size: 0.8125rem; color: var(--text-muted);">
                        Trang ${data.currentPage} / ${data.totalPages}
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table" style="margin-bottom: 0;">
                        <thead>
                        <tr style="background: var(--bg-alt); color: var(--text-muted); font-size: 0.8125rem; text-transform: uppercase;">
                            <th style="padding: 12px 18px; width: 80px;">Mã</th>
                            <th style="padding: 12px 18px;">Khách hàng</th>
                            <th style="padding: 12px 18px;">Số điện thoại</th>
                            <th style="padding: 12px 18px; width: 100px;">Khối</th>
                            <th style="padding: 12px 18px;">Nguồn</th>
                            <th style="padding: 12px 18px;">Trạng thái</th>
                            <th style="padding: 12px 18px;">Phụ trách</th>
                            <th style="padding: 12px 18px;">Tiếp nhận</th>
                            <th style="padding: 12px 18px; text-align: right; width: 120px;">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty data.leads}">
                                <tr>
                                    <td colspan="9" style="text-align: center; padding: 48px 16px;">
                                        <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; color: var(--text-muted);">
                                            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 12px; opacity: 0.6;"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                            <div style="font-size: 1rem; font-weight: 600; color: var(--text); margin-bottom: 4px;">Không tìm thấy khách hàng nào</div>
                                            <div style="font-size: 0.875rem;">Hãy thử thay đổi điều kiện lọc hoặc bấm "Tiếp nhận Khách hàng mới".</div>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${data.leads}">
                                    <tr style="border-bottom: 1px solid var(--border);">
                                        <td style="padding: 14px 18px; font-weight: 600; color: var(--text-muted);">#LEAD-${item.id}</td>
                                        <td style="padding: 14px 18px;">
                                            <div style="font-weight: 600; color: var(--text);">${item.name}</div>
                                            <c:if test="${not empty item.email}">
                                                <div style="font-size: 0.8125rem; color: var(--text-muted);">${item.email}</div>
                                            </c:if>
                                        </td>
                                        <td style="padding: 14px 18px; font-weight: 500;">
                                            <a href="tel:${item.phone}" style="color: var(--primary); text-decoration: none;">${item.phone}</a>
                                        </td>
                                        <td style="padding: 14px 18px;">
                                            <c:choose>
                                                <c:when test="${not empty item.gradeLevel}">
                                                    <span class="badge" style="background: var(--bg-alt); border: 1px solid var(--border); color: var(--text);">Lớp ${item.gradeLevel}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--text-muted); font-size: 0.8125rem;">Chưa rõ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="padding: 14px 18px;">
                                            <span style="font-size: 0.8125rem; color: var(--text-muted);">${item.source}</span>
                                        </td>
                                        <td style="padding: 14px 18px;">
                                            <span class="badge ${item.statusBadgeClass}">${item.statusDisplayName}</span>
                                        </td>
                                        <td style="padding: 14px 18px;">
                                            <c:choose>
                                                <c:when test="${not empty item.assignedToName}">
                                                    <div style="font-size: 0.875rem; font-weight: 500; color: var(--text);">${item.assignedToName}</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color: var(--warning); font-size: 0.8125rem;">Chưa phân công</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="padding: 14px 18px; font-size: 0.8125rem; color: var(--text-muted);">
                                            ${item.createdAt.toLocalDate()}
                                        </td>
                                        <td style="padding: 14px 18px; text-align: right;">
                                            <a href="${pageContext.request.contextPath}/staff/leads/detail?id=${item.id}" class="btn btn-sm btn-secondary" style="display: inline-flex; align-items: center; gap: 4px;">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                                <span>Chi tiết</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${data.totalPages > 1}">
                    <div style="padding: 14px 20px; border-top: 1px solid var(--border); display: flex; justify-content: center; gap: 6px;">
                        <c:forEach var="p" begin="1" end="${data.totalPages}">
                            <a href="${pageContext.request.contextPath}/staff/leads?page=${p}&keyword=${filter.keyword}&status=${filter.status}&source=${filter.source}&gradeLevel=${filter.gradeLevel}&assignedToId=${filter.assignedToId}"
                               class="btn btn-sm ${data.currentPage == p ? 'btn-primary' : 'btn-secondary'}">
                                ${p}
                            </a>
                        </c:forEach>
                    </div>
                </c:if>
            </div>
        </div>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>

<!-- Modal Tạo Lead Mới -->
<div id="createLeadModal" class="modal-backdrop-custom">
    <div class="modal-box">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h3 style="margin: 0; font-size: 1.25rem; font-weight: 700; color: var(--text);">Tiếp nhận Khách hàng mới</h3>
            <button type="button" onclick="closeCreateModal()" style="background: none; border: none; cursor: pointer; color: var(--text-muted);">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/staff/leads/create" method="POST">
            <div style="margin-bottom: 14px;">
                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Họ và tên khách hàng <span style="color: var(--danger);">*</span></label>
                <input type="text" name="name" class="form-control" required placeholder="Ví dụ: Nguyễn Thị Mai">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 14px;">
                <div>
                    <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Số điện thoại <span style="color: var(--danger);">*</span></label>
                    <input type="tel" name="phone" class="form-control" required placeholder="0912345678" pattern="^(0|\+84)[0-9]{9,10}$">
                </div>
                <div>
                    <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Khối lớp</label>
                    <select name="gradeLevel" class="form-control">
                        <option value="">-- Chọn khối --</option>
                        <c:forEach var="g" begin="6" end="12">
                            <option value="${g}">Lớp ${g}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div style="margin-bottom: 14px;">
                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Email (nếu có)</label>
                <input type="email" name="email" class="form-control" placeholder="khachhang@example.com">
            </div>

            <div style="margin-bottom: 14px;">
                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Nguồn tiếp nhận</label>
                <select name="source" class="form-control">
                    <option value="HOTLINE">Hotline trung tâm</option>
                    <option value="DIRECT" selected>Trực tiếp tại quầy tuyển sinh</option>
                    <option value="FACEBOOK">Facebook / Mạng xã hội</option>
                    <option value="REFERRAL">Người quen giới thiệu</option>
                    <option value="WEBSITE">Website</option>
                </select>
            </div>

            <div style="margin-bottom: 20px;">
                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Nhu cầu / Ghi chú tư vấn</label>
                <textarea name="notes" class="form-control" rows="3" placeholder="Ghi nhận nhu cầu bồi dưỡng, thời gian rảnh, môn học quan tâm..."></textarea>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" class="btn btn-secondary" onclick="closeCreateModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu thông tin</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('createLeadModal').classList.add('active');
    }
    function closeCreateModal() {
        document.getElementById('createLeadModal').classList.remove('active');
    }
</script>
</body>
</html>
