<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Hồ sơ cá nhân & Đổi mật khẩu — EduCenter" scope="request" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="profile" scope="request" />
        <c:set var="breadcrumb" value="Hồ sơ tài khoản" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Alerts (Flash Messages) -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Profile Header Overview Panel -->
                <div class="profile-header-overview">
                    <div class="profile-header-main-row">
                        <div class="profile-identity-group">
                            <!-- Avatar with Initials Fallback -->
                            <div class="profile-avatar-wrapper">
                                <c:choose>
                                    <c:when test="${not empty userProfile.avatarUrl}">
                                        <img id="headerOverviewAvatarImg" src="<c:url value='${userProfile.avatarUrl}' />" alt="<c:out value='${userProfile.fullName}' />"
                                             onerror="this.style.display='none'; document.getElementById('headerOverviewAvatarInitial').style.display='inline-flex';">
                                        <span id="headerOverviewAvatarInitial" style="display: none;"><c:out value="${userProfile.fullName != null && !userProfile.fullName.isEmpty() ? userProfile.fullName.substring(0, 1).toUpperCase() : 'U'}" /></span>
                                    </c:when>
                                    <c:otherwise>
                                        <img id="headerOverviewAvatarImg" src="" alt="Avatar" style="display: none;">
                                        <span id="headerOverviewAvatarInitial"><c:out value="${userProfile.fullName != null && !userProfile.fullName.isEmpty() ? userProfile.fullName.substring(0, 1).toUpperCase() : 'U'}" /></span>
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

                            <!-- Identity Details -->
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
                                    <span style="display: inline-flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                        </svg>
                                        <c:out value="${userProfile.email}" />
                                    </span>
                                    <c:if test="${not empty userProfile.phone}">
                                        <span style="display: inline-flex; align-items: center; gap: 6px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                            </svg>
                                            <c:out value="${userProfile.phone}" />
                                        </span>
                                    </c:if>
                                    <span style="color: var(--text-muted);">
                                        ID tài khoản: #<c:out value="${userProfile.id}" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Balanced 2-Column Workstation: Personal Info & Password Change -->
                <div class="profile-workstation-grid">
                    <!-- LEFT COLUMN: Profile Information Form -->
                    <div class="profile-panel-card">
                        <div class="profile-panel-header">
                            <div>
                                <h2 class="profile-panel-title">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    Thông tin cá nhân &amp; Liên hệ
                                </h2>
                                <p style="font-size: var(--font-size-xs); color: var(--text-muted); margin: 4px 0 0 0;">
                                    Cập nhật thông tin định danh, số điện thoại liên lạc và ảnh đại diện.
                                </p>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/profile" method="post" id="profile-info-form">
                            <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                            <input type="hidden" name="action" value="profile">

                            <!-- Full Name & Phone -->
                            <div class="form-grid-2col" style="margin-bottom: 16px;">
                                <div class="form-group">
                                    <label for="prof-fullname" class="form-label">
                                        Họ và tên <span class="required" style="color: var(--danger);">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                        <input type="text" id="prof-fullname" name="fullName" class="form-control"
                                               required maxlength="150" value="<c:out value='${userProfile.fullName}' />">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="prof-phone" class="form-label">
                                        Số điện thoại liên lạc
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

                            <!-- Email (Read-only per BR01) -->
                            <div class="form-group" style="margin-bottom: 16px;">
                                <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
                                    <label class="form-label" style="margin-bottom: 0;">Email định danh tài khoản</label>
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
                                    <input type="email" class="form-control" style="background-color: var(--surface-muted); cursor: not-allowed;"
                                           value="<c:out value='${userProfile.email}' />" readonly>
                                </div>
                                <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-top: 4px;">
                                    Địa chỉ email được quản lý tập trung và không thể tự thay đổi qua trang hồ sơ.
                                </div>
                            </div>

                            <!-- Avatar Studio & Interactive Preset Selector -->
                            <div class="avatar-studio-container">
                                <div class="avatar-studio-top">
                                    <div class="avatar-live-preview-box" id="avatarLivePreview">
                                        <c:choose>
                                            <c:when test="${not empty userProfile.avatarUrl}">
                                                <img id="avatarPreviewImg" src="<c:url value='${userProfile.avatarUrl}' />" alt="Preview"
                                                     onerror="this.style.display='none'; document.getElementById('avatarPreviewInitials').style.display='flex';">
                                                <span id="avatarPreviewInitials" class="avatar-initials-preview" style="display: none;"><c:out value="${userProfile.fullName != null && !userProfile.fullName.isEmpty() ? userProfile.fullName.substring(0, 1).toUpperCase() : 'U'}" /></span>
                                            </c:when>
                                            <c:otherwise>
                                                <img id="avatarPreviewImg" src="" alt="Preview" style="display: none;">
                                                <span id="avatarPreviewInitials" class="avatar-initials-preview"><c:out value="${userProfile.fullName != null && !userProfile.fullName.isEmpty() ? userProfile.fullName.substring(0, 1).toUpperCase() : 'U'}" /></span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="avatar-studio-input-col">
                                        <div class="avatar-studio-label-row">
                                            <label for="prof-avatar" class="form-label" style="margin-bottom: 0; font-weight: 600;">
                                                Ảnh đại diện (Avatar URL)
                                            </label>
                                            <span id="avatarStatusBadge" class="avatar-status-pill neutral">
                                                <c:choose>
                                                    <c:when test="${not empty userProfile.avatarUrl}">Ảnh đang dùng</c:when>
                                                    <c:otherwise>Chưa có ảnh</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="input-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="18" height="18" x="3" y="3" rx="2" ry="2"></rect>
                                                <circle cx="9" cy="9" r="2"></circle>
                                                <path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"></path>
                                            </svg>
                                            <input type="text" id="prof-avatar" name="avatarUrl" class="form-control"
                                                   placeholder="Dán link ảnh bất kỳ (Google, Unsplash, Facebook...)"
                                                   value="<c:out value='${userProfile.avatarUrl}' />" maxlength="500">
                                        </div>

                                        <div class="avatar-input-action-row">
                                            <button type="button" class="avatar-action-btn" id="btnPasteAvatar" title="Dán nhanh liên kết từ khay nhớ tạm">
                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 12px; height: 12px;"><rect width="8" height="4" x="8" y="2" rx="1" ry="1"></rect><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path></svg>
                                                <span>Dán từ clipboard</span>
                                            </button>
                                            <button type="button" class="avatar-action-btn" id="btnClearAvatar" title="Đặt lại về ảnh đại diện chữ cái mặc định">
                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 12px; height: 12px;"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                <span>Xóa về mặc định</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <!-- Preset Avatar Selector -->
                                <div class="avatar-presets-wrapper">
                                    <div class="avatar-presets-title">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 13px; height: 13px; color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><path d="m10 15 5-3-5-3v6Z"></path></svg>
                                        <span>Hoặc chọn nhanh ảnh đại diện mẫu:</span>
                                    </div>
                                    <div class="avatar-presets-grid">
                                        <button type="button" class="avatar-preset-btn" data-url="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" title="Mẫu 1: Nữ hiện đại">
                                            <img src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80" alt="Mẫu 1">
                                        </button>
                                        <button type="button" class="avatar-preset-btn" data-url="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80" title="Mẫu 2: Nam thanh lịch">
                                            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80" alt="Mẫu 2">
                                        </button>
                                        <button type="button" class="avatar-preset-btn" data-url="https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&auto=format&fit=crop&q=80" title="Mẫu 3: Nữ giảng viên">
                                            <img src="https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150&auto=format&fit=crop&q=80" alt="Mẫu 3">
                                        </button>
                                        <button type="button" class="avatar-preset-btn" data-url="https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80" title="Mẫu 4: Nam học viên">
                                            <img src="https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150&auto=format&fit=crop&q=80" alt="Mẫu 4">
                                        </button>
                                        <button type="button" class="avatar-preset-btn" data-url="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80" title="Mẫu 5: Nữ năng động">
                                            <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop&q=80" alt="Mẫu 5">
                                        </button>
                                        <button type="button" class="avatar-preset-btn" data-url="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80" title="Mẫu 6: Chuyên gia tri thức">
                                            <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80" alt="Mẫu 6">
                                        </button>
                                    </div>
                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-top: 8px;">
                                        Bạn có thể dán đường dẫn ảnh bất kỳ từ Google, Imgur, Facebook... hoặc nhấp chọn một ảnh mẫu bên trên.
                                    </div>
                                </div>
                            </div>

                            <!-- Vai trò được cấp (Hiển thị thực tế từ CSDL) -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label class="form-label">Vai trò hệ thống</label>
                                <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                    <c:forEach var="role" items="${userProfile.roleCodes}">
                                        <span class="badge badge-admin" style="font-size: var(--font-size-xs); padding: 6px 12px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="margin-right: 4px;">
                                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                <polyline points="9 12 11 14 15 10"></polyline>
                                            </svg>
                                            <c:out value="${role}" />
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Submit Action -->
                            <div style="display: flex; align-items: center; justify-content: flex-end; margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--border);">
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

                    <!-- RIGHT COLUMN: Direct Password Change Card -->
                    <div class="profile-panel-card">
                        <div class="profile-panel-header">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                                <h2 class="profile-panel-title" style="margin: 0;">Đổi mật khẩu tài khoản</h2>
                            </div>
                        </div>

                        <form action="${pageContext.request.contextPath}/profile" method="post" id="profile-password-form">
                            <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                            <input type="hidden" name="action" value="password">

                            <!-- Current Password -->
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

                            <!-- New Password -->
                            <div class="form-group" style="margin-bottom: 14px;">
                                <div class="pwd-strength-header">
                                    <label for="newPassword" class="form-label" style="margin-bottom: 0;">
                                        Mật khẩu mới <span class="required" style="color: var(--danger);">*</span>
                                    </label>
                                    <span id="pwd-strength-label" style="font-size: var(--font-size-xs); font-family: monospace; color: var(--text-muted); text-transform: uppercase;">Tối thiểu 6 ký tự</span>
                                </div>
                                <div class="auth-password-wrapper">
                                    <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                    <input type="password" id="newPassword" name="newPassword" class="form-control"
                                           required minlength="6" placeholder="Tối thiểu 6 ký tự" autocomplete="new-password">
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

                            <!-- Confirm New Password -->
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
                                           required minlength="6" placeholder="Nhập lại mật khẩu mới" autocomplete="new-password">
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
                </div>
            </main>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
