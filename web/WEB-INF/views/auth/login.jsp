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
            <a href="${pageContext.request.contextPath}/" style="display: inline-flex; flex-direction: column; align-items: center; text-decoration: none;">
                <div class="auth-brand-logo">
                    <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true" style="color: #ffffff;">
                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                    </svg>
                </div>
                <h1 class="auth-brand-title">EduCenter</h1>
                <p class="auth-brand-subtitle">Hệ Thống Quản Trị Trung Tâm Gia Sư & Luyện Thi Chất Lượng Cao</p>
            </a>
        </div>

        <!-- Login Card -->
        <div class="auth-card">
            <div class="auth-card-header">
                <h2 class="auth-card-title">Đăng nhập hệ thống</h2>
                <p class="auth-card-description">Nhập thông tin tài khoản để truy cập cổng thông tin đào tạo</p>
            </div>

            <!-- Alerts (Success / Error / Info) -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
                <!-- CSRF Token -->
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                
                <c:if test="${not empty param.redirect_url}">
                    <input type="hidden" name="redirect_url" value="<c:out value='${param.redirect_url}' />">
                </c:if>

                <!-- Email Input -->
                <div class="form-group">
                    <label for="login-email" class="form-label">
                        Địa chỉ Email <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                        </svg>
                        <input type="email" id="login-email" name="email" class="form-control"
                               placeholder="name@educenter.vn" required autofocus
                               value="<c:out value='${not empty sessionScope.preserved_email ? sessionScope.preserved_email : param.email}' />">
                    </div>
                    <c:remove var="preserved_email" scope="session" />
                </div>

                <!-- Password Input -->
                <div class="form-group">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                        <label for="login-password" class="form-label" style="margin-bottom: 0;">
                            Mật khẩu <span class="required">*</span>
                        </label>
                        <a href="${pageContext.request.contextPath}/forgot-password" style="font-size: var(--font-size-xs); font-weight: 500; color: var(--primary);">
                            Quên mật khẩu?
                        </a>
                    </div>
                    <div class="auth-password-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="login-password" name="password" class="form-control"
                               placeholder="••••••••" required autocomplete="current-password">
                        <button type="button" class="auth-password-toggle" data-password-toggle="login-password"
                                aria-label="Hiện hoặc ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
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

                <!-- Remember Me -->
                <div class="auth-auxiliary" style="margin-bottom: 20px;">
                    <label class="auth-checkbox-label">
                        <input type="checkbox" name="rememberMe" value="true">
                        <span>Ghi nhớ đăng nhập trên thiết bị này</span>
                    </label>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary btn-block" style="padding: 11px 16px; font-size: var(--font-size-md);">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                        <polyline points="10 17 15 12 10 7"></polyline>
                        <line x1="15" y1="12" x2="3" y2="12"></line>
                    </svg>
                    <span>Đăng nhập hệ thống</span>
                </button>
            </form>

            <!-- Trust Badge -->
            <div class="auth-trust-badge">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    <polyline points="9 12 11 14 15 10"></polyline>
                </svg>
                <span>Hệ thống bảo mật TLS 1.3 & Mã hóa mật khẩu BCrypt (SEC-01)</span>
            </div>

            <!-- Footer Links -->
            <div class="auth-footer">
                Chưa có tài khoản học viên? 
                <a href="${pageContext.request.contextPath}/register">Đăng ký tài khoản mới</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
