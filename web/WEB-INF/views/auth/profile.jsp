<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Hồ sơ tài khoản & Cài đặt bảo mật — EduCenter" scope="request" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="admin-layout">
        <c:set var="activeNav" value="profile" scope="request" />
        <c:set var="breadcrumb" value="Cài đặt tài khoản & Bảo mật" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Account Header Overview Panel -->
                <div class="profile-header-overview">
                    <div class="profile-header-main-row">
                        <div class="profile-identity-group">
                            <!-- Avatar Wrapper with Change Overlay -->
                            <div class="profile-avatar-wrapper">
                                <c:choose>
                                    <c:when test="${not empty userProfile.avatarUrl}">
                                        <img src="<c:out value='${userProfile.avatarUrl}' />" alt="<c:out value='${userProfile.fullName}' />"
                                             onerror="this.style.display='none'; this.nextElementSibling.style.display='inline-flex';">
                                        <span style="display: none;"><c:out value="${userProfile.fullName != null && !userProfile.fullName.isEmpty() ? userProfile.fullName.substring(0, 1).toUpperCase() : 'U'}" /></span>
                                    </c:when>
                                    <c:otherwise>
                                        <span><c:out value="${userProfile.fullName != null && !userProfile.fullName.isEmpty() ? userProfile.fullName.substring(0, 1).toUpperCase() : 'U'}" /></span>
                                    </c:otherwise>
                                </c:choose>
                                <button type="button" class="profile-avatar-overlay" title="Cập nhật ảnh đại diện" onclick="document.getElementById('prof-avatar').focus();">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: #ffffff;">
                                        <path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
                                        <circle cx="12" cy="13" r="4"></circle>
                                    </svg>
                                    <span style="margin-top: 2px;">Thay đổi</span>
                                </button>
                            </div>

                            <!-- Identity and Badges Block -->
                            <div class="profile-identity-info">
                                <h1>
                                    <c:out value="${userProfile.fullName}" />
                                    <c:forEach var="role" items="${userProfile.roleCodes}">
                                        <span class="badge badge-admin"><c:out value="${role}" /></span>
                                    </c:forEach>
                                    <span class="status-pill ${userProfile.active ? 'status-active' : 'status-locked'}">
                                        <c:out value="${userProfile.status}" />
                                    </span>
                                </h1>
                                <div class="profile-identity-meta">
                                    <span style="display: inline-flex; align-items: center; gap: 6px; font-family: monospace;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                        </svg>
                                        <c:out value="${userProfile.email}" />
                                    </span>
                                    <span style="display: inline-flex; align-items: center; gap: 6px; color: var(--success); font-weight: 500;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        Đã kích hoạt 2FA (TOTP)
                                    </span>
                                    <span style="font-family: monospace; color: var(--text-muted);">
                                        UID: ADM-2024-00<c:out value="${userProfile.id}" />
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Status Metric Chips -->
                        <div class="profile-metric-chips-row">
                            <div class="profile-metric-chip">
                                <span class="profile-metric-chip-label">Cấp độ an ninh</span>
                                <span class="profile-metric-chip-value" style="color: var(--success);">
                                    Tier-4
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                </span>
                            </div>
                            <div class="profile-metric-chip">
                                <span class="profile-metric-chip-label">Bảo mật mật khẩu</span>
                                <span class="profile-metric-chip-value" style="color: var(--primary); font-family: monospace; font-size: var(--font-size-sm);">
                                    BCrypt (10 rounds)
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Inner Segmented Tab Navigation -->
                    <div class="profile-tabs-nav">
                        <button type="button" class="profile-tab-pill active" data-tab-target="tab-info">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                            <span>Thông tin cá nhân</span>
                        </button>
                        <button type="button" class="profile-tab-pill" data-tab-target="tab-security">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                            <span>Mật khẩu &amp; Bảo mật 2FA</span>
                        </button>
                        <button type="button" class="profile-tab-pill" data-tab-target="tab-rbac">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                            <span>Quyền hạn &amp; Vai trò RBAC</span>
                        </button>
                        <button type="button" class="profile-tab-pill" data-tab-target="tab-sessions">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="20" height="14" x="2" y="3" rx="2"></rect>
                                <line x1="8" y1="21" x2="16" y2="21"></line>
                                <line x1="12" y1="17" x2="12" y2="21"></line>
                            </svg>
                            <span>Lịch sử đăng nhập &amp; Thiết bị</span>
                            <span class="badge" style="background-color: var(--primary-subtle); color: var(--primary); font-size: 10px; padding: 2px 6px;">2</span>
                        </button>
                    </div>
                </div>

                <!-- Primary Configuration Workstation: Balanced 2-Column Grid -->
                <div class="profile-workstation-grid">
                    <!-- LEFT COLUMN: Profile Form Information & RBAC Summary -->
                    <div>
                        <!-- Tab 1: Profile Information -->
                        <div id="tab-info" class="tab-pane active">
                            <div class="profile-panel-card">
                                <div class="profile-panel-header">
                                    <div>
                                        <h2 class="profile-panel-title">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                            Thông tin nhân sự &amp; Chuyên môn
                                        </h2>
                                        <p style="font-size: var(--font-size-xs); color: var(--text-muted); margin: 4px 0 0 0;">
                                            Cập nhật danh bạ học thuật nội bộ và thông tin liên hệ giảng dạy.
                                        </p>
                                    </div>
                                    <span class="auth-pill-badge" style="font-family: monospace;">REQ: BR-ADM-01</span>
                                </div>

                                <form action="${pageContext.request.contextPath}/profile" method="post" id="profile-info-form">
                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                                    <input type="hidden" name="action" value="profile">

                                    <!-- Full Name & Prefix Grid -->
                                    <div class="form-grid-2col" style="margin-bottom: 16px;">
                                        <div class="form-group">
                                            <label for="prof-fullname" class="form-label">
                                                Họ và tên đầy đủ <span class="required" style="color: var(--danger);">*</span>
                                            </label>
                                            <div class="input-wrapper">
                                                <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="12" cy="7" r="4"></circle>
                                                </svg>
                                                <input type="text" id="prof-fullname" name="fullName" class="form-control"
                                                       required value="<c:out value='${userProfile.fullName}' />">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="prof-phone" class="form-label">
                                                Số điện thoại liên lạc <span class="required" style="color: var(--danger);">*</span>
                                            </label>
                                            <div class="input-wrapper">
                                                <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                                </svg>
                                                <input type="tel" id="prof-phone" name="phone" class="form-control"
                                                       placeholder="0912 345 678" value="<c:out value='${userProfile.phone}' />">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Email (Read-only BR01) -->
                                    <div class="form-group" style="margin-bottom: 16px;">
                                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
                                            <label class="form-label" style="margin-bottom: 0;">Email định danh tài khoản (SSO)</label>
                                            <span style="font-size: var(--font-size-xs); color: var(--text-muted); display: inline-flex; align-items: center; gap: 4px;">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 12px; height: 12px;">
                                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                                </svg>
                                                Khóa an toàn theo BR01
                                            </span>
                                        </div>
                                        <div class="input-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                            </svg>
                                            <input type="email" class="form-control" style="background-color: var(--surface-muted); cursor: not-allowed; font-family: monospace;"
                                                   value="<c:out value='${userProfile.email}' />" readonly>
                                        </div>
                                        <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-top: 4px;">
                                            Để cập nhật địa chỉ hòm thư tên miền tổ chức, vui lòng gửi văn bản qua phòng Đào tạo &amp; CNTT.
                                        </div>
                                    </div>

                                    <!-- Avatar URL -->
                                    <div class="form-group" style="margin-bottom: 16px;">
                                        <label for="prof-avatar" class="form-label">Đường dẫn ảnh đại diện (Avatar URL)</label>
                                        <div class="input-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="18" height="18" x="3" y="3" rx="2" ry="2"></rect>
                                                <circle cx="9" cy="9" r="2"></circle>
                                                <path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"></path>
                                            </svg>
                                            <input type="url" id="prof-avatar" name="avatarUrl" class="form-control"
                                                   placeholder="https://example.com/avatar.jpg" value="<c:out value='${userProfile.avatarUrl}' />">
                                        </div>
                                    </div>

                                    <!-- Action Bar -->
                                    <div style="display: flex; align-items: center; justify-content: space-between; margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--border);">
                                        <span style="font-size: var(--font-size-xs); color: var(--text-muted); display: inline-flex; align-items: center; gap: 6px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 14 14"></polyline>
                                            </svg>
                                            Cập nhật tức thì vào CSDL
                                        </span>
                                        <button type="submit" class="btn btn-primary" style="padding: 9px 24px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                                <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                                <polyline points="7 3 7 8 15 8"></polyline>
                                            </svg>
                                            <span>Lưu thay đổi hồ sơ</span>
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Quick RBAC Capability Summary Card -->
                            <div class="profile-panel-card">
                                <div class="profile-panel-header">
                                    <div style="display: flex; align-items: center; gap: 8px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                            <polyline points="9 12 11 14 15 10"></polyline>
                                        </svg>
                                        <h3 class="profile-panel-title" style="margin: 0;">Đặc quyền phân bổ (RBAC M-02)</h3>
                                    </div>
                                    <span class="auth-pill-badge" style="color: var(--primary);"><c:out value="${userProfile.roleCodes.size()}" /> vai trò gán</span>
                                </div>
                                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
                                    <c:forEach var="role" items="${userProfile.roleCodes}">
                                        <div style="background-color: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 14px;">
                                            <div style="font-size: 11px; font-weight: 700; color: var(--primary); text-transform: uppercase; letter-spacing: 0.05em;">VAI TRÒ CHÍNH</div>
                                            <div style="font-size: var(--font-size-sm); font-weight: 700; color: var(--text); margin: 2px 0;"><c:out value="${role}" /></div>
                                            <div style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.4;">
                                                <c:choose>
                                                    <c:when test="${role == 'ADMIN'}">Toàn quyền cấu hình, nhân sự và kiểm soát hệ thống ERP.</c:when>
                                                    <c:when test="${role == 'TEACHER'}">Chấm điểm, phụ trách lớp học và duyệt ngân hàng đề thi.</c:when>
                                                    <c:when test="${role == 'STUDENT'}">Tra cứu điểm số, thời khóa biểu và luyện thi trực tuyến.</c:when>
                                                    <c:when test="${role == 'PARENT'}">Giám sát chuyên cần, theo dõi học bạ và đối soát học phí.</c:when>
                                                    <c:otherwise>Quyền tác nghiệp theo phân hệ quản trị.</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Tab 3: Full RBAC Permissions View -->
                        <div id="tab-rbac" class="tab-pane">
                            <div class="profile-panel-card">
                                <div class="profile-panel-header">
                                    <h2 class="profile-panel-title">Chi tiết phân quyền tác nghiệp (RBAC)</h2>
                                    <span class="auth-pill-badge">Bảo mật ISO/IEC 27001</span>
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 12px;">
                                    <div style="padding: 14px; background-color: var(--surface-muted); border-radius: var(--radius-md); border: 1px solid var(--border);">
                                        <div style="font-weight: 600; font-size: var(--font-size-sm); color: var(--text);">Mô hình kiểm soát truy cập dựa trên vai trò (RBAC)</div>
                                        <div style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.5; margin-top: 4px;">
                                            Hệ thống EduCenter phân bổ quyền hạn tác nghiệp theo từng vai trò đã được phê duyệt. Mọi hành vi cập nhật điểm thi, xuất hóa đơn hoặc thay đổi hồ sơ đều được ghi nhận vào nhật ký kiểm toán hệ thống.
                                        </div>
                                    </div>
                                    <table class="table" style="width: 100%; font-size: var(--font-size-xs);">
                                        <thead>
                                            <tr>
                                                <th>Phân hệ</th>
                                                <th>Mã vai trò</th>
                                                <th>Phạm vi dữ liệu</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="role" items="${userProfile.roleCodes}">
                                                <tr>
                                                    <td><strong>Đào Tạo &amp; Quản Trị</strong></td>
                                                    <td><span class="badge badge-admin"><c:out value="${role}" /></span></td>
                                                    <td>Theo phân công cơ sở trung tâm</td>
                                                    <td><span class="status-pill status-active">Đang áp dụng</span></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Tab 4: Login History & Devices -->
                        <div id="tab-sessions" class="tab-pane">
                            <div class="profile-panel-card">
                                <div class="profile-panel-header">
                                    <h2 class="profile-panel-title">Lịch sử đăng nhập &amp; Thiết bị hoạt động</h2>
                                    <span class="auth-pill-badge">TLS 1.3 Audit</span>
                                </div>
                                <div style="display: flex; flex-direction: column; gap: 12px;">
                                    <div class="session-device-row">
                                        <div style="display: flex; align-items: flex-start; gap: 12px;">
                                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary); margin-top: 2px;">
                                                <rect width="20" height="14" x="2" y="3" rx="2"></rect>
                                                <line x1="8" y1="21" x2="16" y2="21"></line>
                                                <line x1="12" y1="17" x2="12" y2="21"></line>
                                            </svg>
                                            <div>
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <span style="font-weight: 600; font-size: var(--font-size-sm); color: var(--text);">Chrome trên Windows / macOS</span>
                                                    <span class="auth-pill-badge" style="background-color: var(--success-subtle); color: var(--success); font-size: 10px;">Phiên hiện tại</span>
                                                </div>
                                                <div style="font-size: var(--font-size-xs); color: var(--text-muted); font-family: monospace; margin-top: 2px;">
                                                    113.160.224.19 · Hà Nội, Việt Nam · <span style="color: var(--success);">Đang trực tuyến</span>
                                                </div>
                                            </div>
                                        </div>
                                        <span class="pulse-dot"></span>
                                    </div>

                                    <div class="session-device-row">
                                        <div style="display: flex; align-items: flex-start; gap: 12px;">
                                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted); margin-top: 2px;">
                                                <rect width="14" height="20" x="5" y="2" rx="2"></rect>
                                                <line x1="12" y1="18" x2="12.01" y2="18"></line>
                                            </svg>
                                            <div>
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <span style="font-weight: 600; font-size: var(--font-size-sm); color: var(--text);">Safari trên iPhone 15 Pro</span>
                                                </div>
                                                <div style="font-size: var(--font-size-xs); color: var(--text-muted); font-family: monospace; margin-top: 2px;">
                                                    14.238.12.88 · Cầu Giấy, Hà Nội · Hoạt động 32 phút trước
                                                </div>
                                            </div>
                                        </div>
                                        <button type="button" class="btn btn-secondary btn-sm" style="font-size: var(--font-size-xs); color: var(--danger);">Đăng xuất</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- RIGHT COLUMN: Security, 2FA, Password Change & Danger Zone -->
                    <div>
                        <!-- Module 1: Direct Password Change (Tab 2 or Right Column) -->
                        <div class="profile-panel-card" id="tab-security">
                            <div class="profile-panel-header">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                    <h3 class="profile-panel-title" style="margin: 0;">Đổi mật khẩu tài khoản</h3>
                                </div>
                                <span style="font-size: var(--font-size-xs); font-family: monospace; color: var(--success); font-weight: 600;">BCrypt 10</span>
                            </div>

                            <form action="${pageContext.request.contextPath}/profile" method="post" id="profile-password-form">
                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                                <input type="hidden" name="action" value="password">

                                <div class="form-group" style="margin-bottom: 14px;">
                                    <label for="chg-curr" class="form-label">
                                        Mật khẩu hiện tại <span class="required" style="color: var(--danger);">*</span>
                                    </label>
                                    <div class="auth-password-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password" id="chg-curr" name="currentPassword" class="form-control"
                                               required placeholder="••••••••••••" autocomplete="current-password">
                                        <button type="button" class="auth-password-toggle" data-password-toggle="chg-curr"
                                                aria-label="Hiện/Ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
                                            <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display: none;">
                                                <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"></path>
                                                <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"></path>
                                                <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"></path>
                                                <line x1="2" y1="2" x2="22" y2="22"></line>
                                            </svg>
                                        </button>
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom: 14px;">
                                    <div class="pwd-strength-header">
                                        <label for="newPassword" class="form-label" style="margin-bottom: 0;">
                                            Mật khẩu mới <span class="required" style="color: var(--danger);">*</span>
                                        </label>
                                        <span id="pwd-strength-label" style="font-size: var(--font-size-xs); font-family: monospace; color: var(--text-muted); text-transform: uppercase;">Chưa đánh giá</span>
                                    </div>
                                    <div class="auth-password-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password" id="newPassword" name="newPassword" class="form-control"
                                               required placeholder="Tối thiểu 6 ký tự" autocomplete="new-password">
                                        <button type="button" class="auth-password-toggle" data-password-toggle="newPassword"
                                                aria-label="Hiện/Ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
                                            <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display: none;">
                                                <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"></path>
                                                <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"></path>
                                                <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"></path>
                                                <line x1="2" y1="2" x2="22" y2="22"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    <!-- 4-Bar Password Strength Meter -->
                                    <div class="pwd-strength-bars-grid" style="margin-top: 6px;">
                                        <div class="pwd-bar-segment" id="bar-1"></div>
                                        <div class="pwd-bar-segment" id="bar-2"></div>
                                        <div class="pwd-bar-segment" id="bar-3"></div>
                                        <div class="pwd-bar-segment" id="bar-4"></div>
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom: 18px;">
                                    <div class="pwd-strength-header">
                                        <label for="chg-conf" class="form-label" style="margin-bottom: 0;">
                                            Xác nhận mật khẩu mới <span class="required" style="color: var(--danger);">*</span>
                                        </label>
                                        <span id="match-indicator" class="match-status-text matched" style="opacity: 0;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                            Mật khẩu trùng khớp
                                        </span>
                                    </div>
                                    <div class="auth-password-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password" id="chg-conf" name="confirmNewPassword" class="form-control"
                                               required placeholder="Nhập lại mật khẩu mới" autocomplete="new-password">
                                        <button type="button" class="auth-password-toggle" data-password-toggle="chg-conf"
                                                aria-label="Hiện/Ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
                                            <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display: none;">
                                                <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"></path>
                                                <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"></path>
                                                <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"></path>
                                                <line x1="2" y1="2" x2="22" y2="22"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    <div id="match-error" class="match-status-text mismatch" style="display: none;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                        Mật khẩu xác nhận không khớp
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block" style="padding: 10px 16px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                        <polyline points="9 12 11 14 15 10"></polyline>
                                    </svg>
                                    <span>Cập nhật mật khẩu mới</span>
                                </button>
                            </form>
                        </div>

                        <!-- Module 2: Two-Factor Authentication (TOTP) -->
                        <div class="profile-panel-card">
                            <div class="profile-panel-header">
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                                        <rect width="14" height="20" x="5" y="2" rx="2"></rect>
                                        <line x1="12" y1="18" x2="12.01" y2="18"></line>
                                    </svg>
                                    <h3 class="profile-panel-title" style="margin: 0;">Xác thực hai yếu tố (2FA)</h3>
                                </div>
                                <span class="auth-pill-badge" style="background-color: var(--success-subtle); color: var(--success);">Đang bật</span>
                            </div>
                            <p style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.5; margin-bottom: 14px;">
                                Bảo vệ tài khoản bằng mã TOTP 6 số từ Google Authenticator hoặc Microsoft Authenticator mỗi lần đăng nhập.
                            </p>
                            <div style="background-color: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 12px; display: flex; align-items: center; justify-content: space-between; margin-bottom: 14px;">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                    <div>
                                        <div style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text);">Google Authenticator</div>
                                        <div style="font-size: 11px; color: var(--text-muted); font-family: monospace;">Kích hoạt bảo mật 2 lớp</div>
                                    </div>
                                </div>
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <button type="button" class="btn btn-secondary btn-sm" style="flex: 1;" onclick="alert('Đã tạo mã QR bí mật TOTP mới gửi tới email của bạn.');">
                                    Cấu hình 2FA
                                </button>
                                <button type="button" class="btn btn-secondary btn-sm" style="flex: 1;" onclick="alert('Mã khôi phục dự phòng:\nEC-9921-X9A\nEC-4412-B2D\nEC-1094-Z7F');">
                                    Mã dự phòng
                                </button>
                            </div>
                        </div>

                        <!-- Module 3: Danger Zone -->
                        <div class="danger-zone-card">
                            <div class="danger-zone-header">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path>
                                    <line x1="12" y1="9" x2="12" y2="13"></line>
                                    <line x1="12" y1="17" x2="12.01" y2="17"></line>
                                </svg>
                                <span>Vùng nguy hiểm (Danger Zone)</span>
                            </div>
                            <div class="danger-action-row" style="border-bottom: 1px solid var(--border); padding-bottom: 12px; margin-bottom: 10px;">
                                <div>
                                    <div style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text);">Đăng xuất tất cả thiết bị khác</div>
                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted);">Hủy bỏ mọi phiên làm việc ngoài thiết bị này.</div>
                                </div>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="if(confirm('Bạn có chắc chắn muốn đăng xuất trên tất cả các thiết bị khác?')) alert('Đã hủy tất cả các phiên làm việc ngoài thiết bị này.');">
                                    Đăng xuất tất cả
                                </button>
                            </div>
                            <div class="danger-action-row">
                                <div>
                                    <div style="font-size: var(--font-size-sm); font-weight: 600; color: var(--danger);">Trích xuất hồ sơ cá nhân (GDPR)</div>
                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted);">Tải gói tệp dữ liệu hoạt động cá nhân.</div>
                                </div>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="alert('EduCenter đang kết xuất gói dữ liệu cá nhân vào email của bạn.');">
                                    Trích xuất
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
