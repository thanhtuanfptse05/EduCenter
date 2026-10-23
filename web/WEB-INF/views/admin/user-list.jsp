<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="users" scope="request" />
        <c:set var="breadcrumb" value="Quản trị người dùng & Phân quyền" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Page Title -->
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Quản lý người dùng & Phân quyền</h1>
                        <p class="page-subtitle">Quản lý tài khoản, phân quyền 5 vai trò hệ thống và kiểm soát trạng thái hoạt động</p>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- KPI Summary Cards -->
                <div class="kpi-grid">
                    <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div class="kpi-label">Tổng số người dùng</div>
                            <div class="kpi-value"><c:out value="${pageData.totalRecords}" /></div>
                        </div>
                        <div style="width: 48px; height: 48px; border-radius: 12px; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div class="kpi-label">Đang hoạt động (Active)</div>
                            <div class="kpi-value" style="color: var(--success);"><c:out value="${pageData.totalActive}" /></div>
                        </div>
                        <div style="width: 48px; height: 48px; border-radius: 12px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                            </svg>
                        </div>
                    </div>
                    <div class="kpi-card" style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div class="kpi-label">Tài khoản bị khóa</div>
                            <div class="kpi-value" style="color: var(--danger);"><c:out value="${pageData.totalLocked}" /></div>
                        </div>
                        <div style="width: 48px; height: 48px; border-radius: 12px; background: var(--danger-subtle); color: var(--danger); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                            <svg class="icon icon-md" style="width: 24px; height: 24px;" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Filter & Search Toolbar -->
                <div class="filter-toolbar">
                    <form action="${pageContext.request.contextPath}/admin/users" method="get" class="filter-form">
                        <!-- Search Keyword -->
                        <div class="filter-search input-wrapper">
                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <input type="text" name="q" class="form-control" placeholder="Tìm theo tên, email, số điện thoại..."
                                   value="<c:out value='${pageData.keyword}' />">
                        </div>

                        <!-- Role Filter -->
                        <select name="role" class="filter-select">
                            <option value="">-- Tất cả vai trò --</option>
                            <c:forEach var="role" items="${pageData.availableRoles}">
                                <option value="<c:out value='${role.code}'/>" ${pageData.roleCode == role.code ? 'selected' : ''}><c:out value="${role.name}"/> (<c:out value="${role.code}"/>)</option>
                            </c:forEach>
                        </select>

                        <!-- Status Filter -->
                        <select name="status" class="filter-select">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="ACTIVE" ${pageData.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động (ACTIVE)</option>
                            <option value="LOCKED" ${pageData.status == 'LOCKED' ? 'selected' : ''}>Tạm khóa (LOCKED)</option>
                            <option value="INACTIVE" ${pageData.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động (INACTIVE)</option>
                        </select>

                        <button type="submit" class="btn btn-primary btn-sm">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                            </svg>
                            <span>Lọc</span>
                        </button>

                        <c:if test="${not empty pageData.keyword or not empty pageData.roleCode or not empty pageData.status}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-ghost btn-sm">
                                <span>Đặt lại</span>
                            </a>
                        </c:if>
                    </form>
                </div>

                <!-- Users Data Table -->
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 50px;">ID</th>
                                <th>Người dùng & Email</th>
                                <th>Điện thoại</th>
                                <th>Vai trò hệ thống</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th style="text-align: right; width: 180px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty pageData.items}">
                                    <tr>
                                        <td colspan="7" style="text-align: center; padding: 48px 16px; color: var(--text-muted);">
                                            <svg class="icon icon-lg" style="margin-bottom: 8px; color: var(--border);" viewBox="0 0 24 24" aria-hidden="true">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                            </svg>
                                            <p style="font-weight: 550;">Không tìm thấy người dùng nào phù hợp</p>
                                            <p class="text-muted" style="font-size: var(--font-size-xs);">Thử thay đổi từ khóa tìm kiếm hoặc bỏ bộ lọc</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${pageData.items}">
                                        <tr>
                                            <td><c:out value="${user.id}" /></td>
                                            <td>
                                                <div class="user-cell">
                                                    <div class="user-avatar">
                                                        <c:choose>
                                                            <c:when test="${not empty user.avatarUrl}">
                                                                <img src="<c:out value='${user.avatarUrl}' />" alt="Avatar">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:out value="${user.fullName.substring(0, 1)}" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="user-meta">
                                                        <span class="user-name"><c:out value="${user.fullName}" /></span>
                                                        <span class="user-email"><c:out value="${user.email}" /></span>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:out value="${not empty user.phone ? user.phone : '—'}" />
                                            </td>
                                            <td>
                                                <div class="roles-cell">
                                                    <c:forEach var="rc" items="${user.roleCodes}">
                                                        <span class="badge ${rc == 'ADMIN' ? 'badge-admin' : (rc == 'STAFF' ? 'badge-staff' : (rc == 'TEACHER' ? 'badge-teacher' : (rc == 'STUDENT' ? 'badge-student' : 'badge-parent')))}">
                                                            <c:out value="${rc}" />
                                                        </span>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-pill ${user.active ? 'status-active' : (user.locked ? 'status-locked' : 'status-inactive')}">
                                                    <c:out value="${user.status}" />
                                                </span>
                                            </td>
                                            <td>
                                                <c:out value="${user.createdAt.toString().substring(0, 10)}" />
                                            </td>
                                            <td style="text-align: right; white-space: nowrap;">
                                                <!-- Assign Roles Button -->
                                                <button type="button" class="btn btn-secondary btn-sm"
                                                        data-role-editor data-user-id="${user.id}" data-user-name="<c:out value='${user.fullName}'/>" data-user-email="<c:out value='${user.email}'/>" data-user-roles="<c:forEach var='roleCode' items='${user.roleCodes}' varStatus='roleStatus'><c:out value='${roleCode}'/><c:if test='${not roleStatus.last}'>,</c:if></c:forEach>">
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                                        <circle cx="9" cy="7" r="4"></circle>
                                                        <polyline points="16 11 18 13 22 9"></polyline>
                                                    </svg>
                                                    <span>Phân vai trò</span>
                                                </button>

                                                <!-- Status Action Form (Lock / Unlock) -->
                                                <form action="${pageContext.request.contextPath}/admin/users/status" method="post" style="display: inline-block; margin-left: 4px;">
                                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                                                    <input type="hidden" name="userId" value="${user.id}">
                                                    <input type="hidden" name="q" value="<c:out value='${pageData.keyword}' />">
                                                    <input type="hidden" name="role" value="<c:out value='${pageData.roleCode}' />">
                                                    <input type="hidden" name="status" value="<c:out value='${pageData.status}' />">
                                                    <input type="hidden" name="page" value="${pageData.currentPage}">

                                                    <c:choose>
                                                        <c:when test="${user.active}">
                                                            <input type="hidden" name="actionStatus" value="LOCKED">
                                                            <button type="submit" class="btn btn-ghost btn-sm" style="color: var(--danger);"
                                                                    onclick="return confirm('Xác nhận thay đổi trạng thái tài khoản này?');"
                                                                    title="Khóa tài khoản">
                                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                                                </svg>
                                                                <span>Khóa</span>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="hidden" name="actionStatus" value="ACTIVE">
                                                            <button type="submit" class="btn btn-ghost btn-sm" style="color: var(--success);"
                                                                    onclick="return confirm('Xác nhận thay đổi trạng thái tài khoản này?');"
                                                                    title="Mở khóa tài khoản">
                                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                                                    <path d="M7 11V7a5 5 0 0 1 9.9-1"></path>
                                                                </svg>
                                                                <span>Mở</span>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${pageData.totalRecords > 0}">
                        <div class="pagination-wrapper">
                            <div>
                                Hiển thị <strong>${(pageData.currentPage - 1) * pageData.pageSize + 1}</strong> đến
                                <strong>${Math.min(pageData.currentPage * pageData.pageSize, pageData.totalRecords)}</strong>
                                trên tổng số <strong>${pageData.totalRecords}</strong> người dùng
                            </div>

                            <div class="pagination-links">
                                <c:url var="prevUrl" value="/admin/users">
                                    <c:param name="page" value="${pageData.currentPage - 1}" />
                                    <c:if test="${not empty pageData.keyword}"><c:param name="q" value="${pageData.keyword}" /></c:if>
                                    <c:if test="${not empty pageData.roleCode}"><c:param name="role" value="${pageData.roleCode}" /></c:if>
                                    <c:if test="${not empty pageData.status}"><c:param name="status" value="${pageData.status}" /></c:if>
                                </c:url>
                                <a href="${prevUrl}" class="pagination-btn ${!pageData.hasPrevious() ? 'disabled' : ''}">
                                    &larr; Trang trước
                                </a>

                                <c:forEach begin="1" end="${pageData.totalPages}" var="p">
                                    <c:url var="pageUrl" value="/admin/users">
                                        <c:param name="page" value="${p}" />
                                        <c:if test="${not empty pageData.keyword}"><c:param name="q" value="${pageData.keyword}" /></c:if>
                                        <c:if test="${not empty pageData.roleCode}"><c:param name="role" value="${pageData.roleCode}" /></c:if>
                                        <c:if test="${not empty pageData.status}"><c:param name="status" value="${pageData.status}" /></c:if>
                                    </c:url>
                                    <a href="${pageUrl}" class="pagination-btn ${p == pageData.currentPage ? 'active' : ''}">
                                        ${p}
                                    </a>
                                </c:forEach>

                                <c:url var="nextUrl" value="/admin/users">
                                    <c:param name="page" value="${pageData.currentPage + 1}" />
                                    <c:if test="${not empty pageData.keyword}"><c:param name="q" value="${pageData.keyword}" /></c:if>
                                    <c:if test="${not empty pageData.roleCode}"><c:param name="role" value="${pageData.roleCode}" /></c:if>
                                    <c:if test="${not empty pageData.status}"><c:param name="status" value="${pageData.status}" /></c:if>
                                </c:url>
                                <a href="${nextUrl}" class="pagination-btn ${!pageData.hasNext() ? 'disabled' : ''}">
                                    Trang sau &rarr;
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </div>

    <!-- Role Assignment Modal (ADM-18) -->
    <div id="roleModal" class="modal-backdrop">
        <div class="modal-dialog">
            <div class="modal-header">
                <h3 class="modal-title">Phân vai trò người dùng</h3>
                <button type="button" class="modal-close" data-modal-close="roleModal" aria-label="Đóng">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/users/roles" method="post">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                <input type="hidden" id="modal-userId" name="userId" value="">
                <input type="hidden" name="q" value="<c:out value='${pageData.keyword}' />">
                <input type="hidden" name="role" value="<c:out value='${pageData.roleCode}' />">
                <input type="hidden" name="status" value="<c:out value='${pageData.status}' />">
                <input type="hidden" name="page" value="${pageData.currentPage}">

                <div class="modal-body">
                    <p style="margin-bottom: 12px; font-size: var(--font-size-sm);">
                        Đang phân quyền cho tài khoản: <strong id="modal-userName"></strong> (<span id="modal-userEmail" class="text-muted"></span>)
                    </p>

                    <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 14px;">
                        <c:forEach var="role" items="${pageData.availableRoles}">
                            <label class="auth-checkbox-label" style="padding: 6px 0;">
                                <input type="checkbox" name="roles" value="<c:out value='${role.code}'/>" id="role-<c:out value='${role.code}'/>">
                                <span><strong><c:out value="${role.code}"/></strong> — <c:out value="${role.name}"/></span>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-modal-close="roleModal">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary">Lưu phân quyền</button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>

    <script>
    function openRoleModal(userId, name, email, roleCodesStr) {
        document.getElementById('modal-userId').value = userId;
        document.getElementById('modal-userName').textContent = name;
        document.getElementById('modal-userEmail').textContent = email;

        // Reset checkboxes
        document.querySelectorAll('#roleModal input[name="roles"]').forEach(function (checkbox) {
            checkbox.checked = false;
        });

        // Check user's assigned roles
        if (roleCodesStr) {
            var assigned = roleCodesStr.split(',');
            assigned.forEach(function (r) {
                var cb = document.getElementById('role-' + r.trim());
                if (cb) cb.checked = true;
            });
        }

        window.EduCenterModal.open('roleModal');
    }
    </script>
</body>
</html>
