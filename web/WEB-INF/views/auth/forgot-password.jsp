<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Quên mật khẩu — EduCenter Cổng Xác Thực" scope="request" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="auth-page-wrapper">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="auth-main-content">
            <div class="auth-centered-box">
                <!-- Main Authentication Card -->
                <div class="auth-single-card">
                    <!-- Top Color Bar Indicator -->
                    <div class="top-accent-bar"></div>

                    <!-- Security Emblem -->
                    <div class="security-emblem-wrapper">
                        <div class="security-emblem-circle">
                            <div class="security-emblem-inner">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    <circle cx="12" cy="16" r="1"></circle>
                                </svg>
                            </div>
                            <div class="security-spark-badge">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 12px; height: 12px;">
                                    <polyline points="20 6 9 17 4 12"></polyline>
                                </svg>
                            </div>
                        </div>
                    </div>

                    <!-- Heading Group -->
                    <div style="text-align: center; margin-bottom: 24px;">
                        <h1 class="auth-main-heading" style="font-size: var(--font-size-xl);">
                            Khôi phục mật khẩu tài khoản
                        </h1>
                        <p class="auth-sub-desc" style="font-size: var(--font-size-sm);">
                            Nhập địa chỉ email liên kết với hồ sơ cán bộ hoặc học viên EduCenter. Hệ thống sẽ phát hành liên kết mã hóa có hiệu lực trong 15 phút.
                        </p>
                    </div>

                    <!-- Alerts (Success / Error / Info) -->
                    <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                    <!-- Request Form -->
                    <form action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate id="forgotPasswordForm">
                        <!-- CSRF Token -->
                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">

                        <!-- Input Field: Email -->
                        <div class="form-group" style="margin-bottom: 16px;">
                            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 6px;">
                                <label for="recoveryEmail" class="form-label" style="margin-bottom: 0;">
                                    Email định danh cổng dịch vụ <span class="required" style="color: var(--danger);">*</span>
                                </label>
                                <span style="font-size: var(--font-size-xs); font-family: monospace; color: var(--text-muted);">Bắt buộc</span>
                            </div>
                            <div class="input-wrapper">
                                <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                    <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                </svg>
                                <input type="email" id="recoveryEmail" name="email" class="form-control"
                                       placeholder="ten.nguoidung@educenter.vn" required autofocus>
                            </div>
                            <div style="display: flex; align-items: center; gap: 6px; margin-top: 6px; font-size: var(--font-size-xs); color: var(--text-muted);">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px;">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="16" x2="12" y2="12"></line>
                                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                                </svg>
                                <span>Chấp nhận email tên miền trường (@educenter.vn) hoặc email cá nhân đã xác thực.</span>
                            </div>
                        </div>

                        <!-- Enterprise Bot Shield / Sentinel Guard Box -->
                        <div class="turnstile-box">
                            <label class="auth-checkbox-label" style="cursor: default;">
                                <input type="checkbox" checked disabled style="cursor: default;">
                                <span style="display: flex; flex-direction: column;">
                                    <span style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text);">Xác thực con người bảo mật</span>
                                    <span style="font-size: 11px; color: var(--text-muted); font-family: monospace;">EduCenter Sentinel Guard 3.0</span>
                                </span>
                            </label>
                            <span class="auth-pill-badge" style="color: var(--success); background-color: var(--success-subtle); border: 1px solid var(--success-border);">
                                <span class="pulse-dot"></span>
                                Active
                            </span>
                        </div>

                        <!-- Submit Button -->
                        <button type="submit" class="btn btn-primary btn-block" style="height: 42px; font-size: var(--font-size-md);">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <line x1="22" y1="2" x2="11" y2="13"></line>
                                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                            </svg>
                            <span>Gửi liên kết khôi phục</span>
                        </button>
                    </form>

                    <!-- Auxiliary Action Links -->
                    <div style="margin-top: 24px; padding-top: 18px; border-top: 1px solid var(--border); display: flex; flex-direction: column; align-items: center; gap: 10px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/login" style="display: inline-flex; align-items: center; gap: 6px; font-size: var(--font-size-sm); font-weight: 600; color: var(--primary); text-decoration: none;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <line x1="19" y1="12" x2="5" y2="12"></line>
                                <polyline points="12 19 5 12 12 5"></polyline>
                            </svg>
                            <span>Quay lại trang Đăng nhập</span>
                        </a>
                        <div style="font-size: var(--font-size-xs); color: var(--text-muted);">
                            Gặp sự cố truy cập? 
                            <a href="mailto:hotro@educenter.vn" style="color: var(--primary); text-decoration: none; font-weight: 500;">hotro@educenter.vn</a>
                        </div>
                    </div>
                </div>

                <!-- Security & Compliance Micro Footer -->
                <div style="display: flex; align-items: center; justify-content: space-between; font-size: var(--font-size-xs); color: var(--text-muted); font-family: monospace; padding: 0 4px;">
                    <div style="display: flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px;">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <span>Mã hóa TLS 1.3 / AES-256</span>
                    </div>
                    <span>Phiên giao dịch: SEC-9182</span>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</body>
</html>
