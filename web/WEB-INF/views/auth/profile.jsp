<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="admin-layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div class="page-header">
                    <div>
                        <h1 class="page-title">Hồ sơ cá nhân & Bảo mật</h1>
                        <p class="page-subtitle">Quản lý thông tin định danh và cập nhật mật khẩu tài khoản</p>
                    </div>
                </div>

                <!-- Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <div class="profile-grid">
                    <!-- Card 1: Personal Info -->
                    <div class="card">
                        <div class="card-header">
                            <h2 style="font-size: var(--font-size-md); font-weight: 650; display: flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="12" cy="7" r="4"></circle>
                                </svg>
                                <span>Thông tin tài khoản</span>
                            </h2>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/profile" method="post">
                                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                                <input type="hidden" name="action" value="profile">

                                <!-- Email (Readonly) -->
                                <div class="form-group">
                                    <label class="form-label">Địa chỉ Email (Định danh hệ thống)</label>
                                    <div class="input-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                        </svg>
                                        <input type="email" class="form-control" style="background-color: var(--surface-muted); cursor: not-allowed;"
                                               value="<c:out value='${userProfile.email}' />" readonly>
                                    </div>
                                    <div class="form-hint">Email là khóa chính định danh, không thể thay đổi sau khi đăng ký.</div>
                                </div>

                                <!-- Current Roles & Status -->
                                <div class="form-group">
                                    <label class="form-label">Vai trò & Trạng thái hiện tại</label>
                                    <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                                        <c:forEach var="role" items="${userProfile.roleCodes}">
                                            <span class="badge badge-admin"><c:out value="${role}" /></span>
                                        </c:forEach>
                                        <span class="status-pill ${userProfile.active ? 'status-active' : 'status-locked'}">
                                            <c:out value="${userProfile.status}" />
                                        </span>
                                    </div>
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
                                    <label for="prof-phone" class="form-label">Số điện thoại</label>
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
                                    <span>Lưu thông tin cá nhân</span>
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Card 2: Security & Change Password -->
                    <div class="card">
                        <div class="card-header">
                            <h2 style="font-size: var(--font-size-md); font-weight: 650; display: flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--danger);">
                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                                <span>Đổi mật khẩu tài khoản</span>
                            </h2>
                        </div>
                        <div class="card-body">
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
                                    <label for="chg-new" class="form-label">
                                        Mật khẩu mới (tối thiểu 6 ký tự) <span class="required">*</span>
                                    </label>
                                    <div class="auth-password-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password" id="chg-new" name="newPassword" class="form-control"
                                               required placeholder="Tối thiểu 6 ký tự" autocomplete="new-password">
                                        <button type="button" class="auth-password-toggle" data-password-toggle="chg-new"
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
                                </div>

                                <button type="submit" class="btn btn-secondary" style="margin-top: 10px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                    <span>Cập nhật mật khẩu mới</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
