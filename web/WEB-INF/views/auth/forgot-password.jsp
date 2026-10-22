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
            <p class="auth-brand-subtitle">Khôi Phục Quyền Truy Cập Tài Khoản</p>
        </div>

        <div class="auth-card">
            <div class="auth-card-header">
                <h2 class="auth-card-title">Quên mật khẩu?</h2>
                <p class="auth-card-description">
                    Nhập email tài khoản của bạn để nhận liên kết xác thực đặt lại mật khẩu an toàn.
                </p>
            </div>

            <!-- Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate>
                <!-- CSRF Token -->
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">

                <div class="form-group">
                    <label for="forgot-email" class="form-label">
                        Địa chỉ Email đã đăng ký <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                        </svg>
                        <input type="email" id="forgot-email" name="email" class="form-control"
                               placeholder="email-cua-ban@educenter.vn" required autofocus>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 20px;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <line x1="22" y1="2" x2="11" y2="13"></line>
                        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                    </svg>
                    <span>Gửi yêu cầu khôi phục</span>
                </button>
            </form>

            <div class="auth-footer">
                Nhớ mật khẩu rồi? 
                <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
