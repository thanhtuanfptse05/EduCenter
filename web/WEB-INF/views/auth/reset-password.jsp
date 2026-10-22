<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="auth-container">
        <!-- Brand Header -->
        <div class="auth-brand">
            <div class="auth-brand-logo">
                <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                    <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                </svg>
            </div>
            <h1 class="auth-brand-title">EduCenter ERP</h1>
            <p class="auth-brand-subtitle">Thiết Lập Mật Khẩu Mới</p>
        </div>

        <div class="auth-card">
            <div class="auth-card-header">
                <h2 class="auth-card-title">Đặt lại mật khẩu</h2>
                <p class="auth-card-description">Nhập mật khẩu mới cho tài khoản của bạn (tối thiểu 6 ký tự)</p>
            </div>

            <!-- Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <form action="${pageContext.request.contextPath}/reset-password" method="post" novalidate>
                <!-- CSRF Token -->
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                <input type="hidden" name="token" value="<c:out value='${token}' />">

                <!-- New Password -->
                <div class="form-group">
                    <label for="reset-pass" class="form-label">
                        Mật khẩu mới <span class="required">*</span>
                    </label>
                    <div class="auth-password-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="reset-pass" name="newPassword" class="form-control"
                               placeholder="Tối thiểu 6 ký tự" required autocomplete="new-password" autofocus>
                        <button type="button" class="auth-password-toggle" data-password-toggle="reset-pass"
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
                    <label for="reset-confirm" class="form-label">
                        Xác nhận mật khẩu mới <span class="required">*</span>
                    </label>
                    <div class="auth-password-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="reset-confirm" name="confirmNewPassword" class="form-control"
                               placeholder="Nhập lại mật khẩu mới" required autocomplete="new-password">
                        <button type="button" class="auth-password-toggle" data-password-toggle="reset-confirm"
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

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 20px;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    <span>Lưu mật khẩu mới & Đăng nhập</span>
                </button>
            </form>

            <div class="auth-footer">
                <a href="${pageContext.request.contextPath}/login">Quay lại trang Đăng nhập</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
