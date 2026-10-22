<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <style>
        .profile-layout-grid {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 900px) {
            .profile-layout-grid {
                grid-template-columns: 1fr;
            }
        }
        .user-identity-card {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 32px 24px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .user-avatar-circle {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, #1e40af 100%);
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 16px;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
            border: 3px solid var(--surface);
            overflow: hidden;
        }
        .user-avatar-circle img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .user-identity-name {
            font-size: var(--font-size-lg);
            font-weight: 700;
            color: var(--text);
            margin-bottom: 4px;
        }
        .user-identity-email {
            font-size: var(--font-size-sm);
            color: var(--text-muted);
            margin-bottom: 16px;
            word-break: break-all;
        }
        .profile-nav-tabs {
            display: flex;
            gap: 8px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 24px;
        }
        .profile-tab-button {
            padding: 10px 18px;
            font-size: var(--font-size-sm);
            font-weight: 600;
            color: var(--text-muted);
            background: none;
            border: none;
            border-bottom: 2px solid transparent;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all var(--transition-fast);
        }
        .profile-tab-button:hover {
            color: var(--text);
        }
        .profile-tab-button.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }
        .tab-pane {
            display: none;
        }
        .tab-pane.active {
            display: block;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <c:set var="activeNav" value="profile" scope="request" />
        <c:set var="breadcrumb" value="Hồ sơ tài khoản & Cài đặt bảo mật" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Hồ sơ cá nhân & Bảo mật</h1>
                        <p class="page-subtitle">Quản lý thông tin định danh, số điện thoại và cập nhật mật khẩu tài khoản</p>
                    </div>
                </div>

                <!-- Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <div class="profile-layout-grid">
                    <!-- Left Column: User Identity Card -->
                    <div class="user-identity-card">
                        <div class="user-avatar-circle">
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
                        </div>

                        <div class="user-identity-name"><c:out value="${userProfile.fullName}" /></div>
                        <div class="user-identity-email"><c:out value="${userProfile.email}" /></div>

                        <div style="display: flex; justify-content: center; gap: 6px; flex-wrap: wrap; margin-bottom: 20px;">
                            <c:forEach var="role" items="${userProfile.roleCodes}">
                                <span class="badge badge-admin"><c:out value="${role}" /></span>
                            </c:forEach>
                            <span class="status-pill ${userProfile.active ? 'status-active' : 'status-locked'}">
                                <c:out value="${userProfile.status}" />
                            </span>
                        </div>

                        <div style="border-top: 1px solid var(--border); padding-top: 16px; text-align: left; font-size: var(--font-size-xs); color: var(--text-muted); display: flex; flex-direction: column; gap: 10px;">
                            <div style="display: flex; justify-content: space-between;">
                                <span>Mã ID tài khoản:</span>
                                <strong>#<c:out value="${userProfile.id}" /></strong>
                            </div>
                            <div style="display: flex; justify-content: space-between;">
                                <span>Bảo mật mật khẩu:</span>
                                <span style="color: var(--success); font-weight: 600;">BCrypt (10 rounds)</span>
                            </div>
                            <div style="display: flex; justify-content: space-between;">
                                <span>Phiên hoạt động:</span>
                                <span>SSL / TLS 1.3</span>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Settings Card with Tabs -->
                    <div class="card">
                        <div class="card-body">
                            <!-- Tabs Navigation -->
                            <div class="profile-nav-tabs">
                                <button type="button" class="profile-tab-button active" data-tab-target="tab-info">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    <span>Thông tin tài khoản</span>
                                </button>
                                <button type="button" class="profile-tab-button" data-tab-target="tab-password">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                    <span>Bảo mật & Đổi mật khẩu</span>
                                </button>
                            </div>

                            <!-- Tab 1: Personal Information -->
                            <div id="tab-info" class="tab-pane active">
                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                                    <input type="hidden" name="action" value="profile">

                                    <!-- Email (Readonly) -->
                                    <div class="form-group">
                                        <label class="form-label">Địa chỉ Email định danh</label>
                                        <div class="input-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                            </svg>
                                            <input type="email" class="form-control" style="background-color: var(--surface-muted); cursor: not-allowed;"
                                                   value="<c:out value='${userProfile.email}' />" readonly>
                                        </div>
                                        <div class="form-hint">Email là khóa chính định danh tài khoản, không thể thay đổi sau khi tạo.</div>
                                    </div>

                                    <!-- Full Name -->
                                    <div class="form-group">
                                        <label for="prof-name" class="form-label">
                                            Họ và tên <span class="required">*</span>
                                        </label>
                                        <div class="input-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                                <circle cx="12" cy="7" r="4"></circle>
                                            </svg>
                                            <input type="text" id="prof-name" name="fullName" class="form-control"
                                                   required value="<c:out value='${userProfile.fullName}' />">
                                        </div>
                                    </div>

                                    <!-- Phone -->
                                    <div class="form-group">
                                        <label for="prof-phone" class="form-label">Số điện thoại liên lạc</label>
                                        <div class="input-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                            </svg>
                                            <input type="tel" id="prof-phone" name="phone" class="form-control"
                                                   placeholder="0912345678" value="<c:out value='${userProfile.phone}' />">
                                        </div>
                                    </div>

                                    <!-- Avatar URL -->
                                    <div class="form-group">
                                        <label for="prof-avatar" class="form-label">Đường dẫn ảnh đại diện (URL)</label>
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

                                    <button type="submit" class="btn btn-primary" style="margin-top: 10px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                            <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                            <polyline points="7 3 7 8 15 8"></polyline>
                                        </svg>
                                        <span>Lưu thay đổi hồ sơ</span>
                                    </button>
                                </form>
                            </div>

                            <!-- Tab 2: Change Password -->
                            <div id="tab-password" class="tab-pane">
                                <form action="${pageContext.request.contextPath}/profile" method="post">
                                    <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                                    <input type="hidden" name="action" value="password">

                                    <!-- Current Password -->
                                    <div class="form-group">
                                        <label for="chg-curr" class="form-label">
                                            Mật khẩu hiện tại <span class="required">*</span>
                                        </label>
                                        <div class="auth-password-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                            </svg>
                                            <input type="password" id="chg-curr" name="currentPassword" class="form-control"
                                                   required placeholder="Nhập mật khẩu đang dùng" autocomplete="current-password">
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
                                    <div class="form-group">
                                        <label for="newPassword" class="form-label">
                                            Mật khẩu mới (tối thiểu 6 ký tự) <span class="required">*</span>
                                        </label>
                                        <div class="auth-password-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                            </svg>
                                            <input type="password" id="newPassword" name="newPassword" class="form-control"
                                                   required placeholder="Nhập mật khẩu mới an toàn" autocomplete="new-password">
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
                                        <div class="password-strength-container">
                                            <div class="password-strength-track">
                                                <div id="password-strength-bar" class="password-strength-bar"></div>
                                            </div>
                                            <div id="password-strength-text" class="password-strength-text"></div>
                                        </div>
                                    </div>

                                    <!-- Confirm New Password -->
                                    <div class="form-group">
                                        <label for="chg-conf" class="form-label">
                                            Xác nhận mật khẩu mới <span class="required">*</span>
                                        </label>
                                        <div class="auth-password-wrapper">
                                            <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                                <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                            </svg>
                                            <input type="password" id="chg-conf" name="confirmNewPassword" class="form-control"
                                                   required placeholder="Nhập lại chính xác mật khẩu mới" autocomplete="new-password">
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
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="margin-top: 10px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                        </svg>
                                        <span>Cập nhật mật khẩu mới</span>
                                    </button>
                                </form>
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
