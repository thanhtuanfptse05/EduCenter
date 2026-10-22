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
            <p class="auth-brand-subtitle">Hệ Thống Quản Trị Trung Tâm Gia Sư & Luyện Thi</p>
        </div>

        <!-- Register Card -->
        <div class="auth-card">
            <div class="auth-card-header">
                <h2 class="auth-card-title">Đăng ký tài khoản</h2>
                <p class="auth-card-description">Tạo tài khoản mới để tra cứu tiến độ học tập và khóa học</p>
            </div>

            <!-- Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
                <!-- CSRF Token -->
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">

                <!-- Full Name -->
                <div class="form-group">
                    <label for="reg-name" class="form-label">
                        Họ và tên <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                            <circle cx="12" cy="7" r="4"></circle>
                        </svg>
                        <input type="text" id="reg-name" name="fullName" class="form-control"
                               placeholder="Ví dụ: Nguyễn Văn An" required
                               value="<c:out value='${not empty sessionScope.preserved_fullName ? sessionScope.preserved_fullName : ""}' />">
                    </div>
                    <c:remove var="preserved_fullName" scope="session" />
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="reg-email" class="form-label">
                        Địa chỉ Email <span class="required">*</span>
                    </label>
                    <div class="input-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                            <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                        </svg>
                        <input type="email" id="reg-email" name="email" class="form-control"
                               placeholder="email-hoc-vien@gmail.com" required
                               value="<c:out value='${not empty sessionScope.preserved_email ? sessionScope.preserved_email : ""}' />">
                    </div>
                    <c:remove var="preserved_email" scope="session" />
                </div>

                <!-- Phone -->
                <div class="form-group">
                    <label for="reg-phone" class="form-label">Số điện thoại liên hệ</label>
                    <div class="input-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                        </svg>
                        <input type="tel" id="reg-phone" name="phone" class="form-control"
                               placeholder="0912345678"
                               value="<c:out value='${not empty sessionScope.preserved_phone ? sessionScope.preserved_phone : ""}' />">
                    </div>
                    <c:remove var="preserved_phone" scope="session" />
                </div>

                <!-- Role Selector (STUDENT or PARENT per spec) -->
                <div class="form-group">
                    <label class="form-label">Bạn đăng ký tài khoản với tư cách <span class="required">*</span></label>
                    <div class="role-selector-grid">
                        <label class="role-selector-card selected">
                            <input type="radio" name="roleCode" value="STUDENT" checked>
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                            </svg>
                            <span class="role-card-title">Học viên (Student)</span>
                            <span class="role-card-desc">Luyện thi, xem lịch & điểm</span>
                        </label>
                        <label class="role-selector-card">
                            <input type="radio" name="roleCode" value="PARENT">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning);">
                                <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                            <span class="role-card-title">Phụ huynh (Parent)</span>
                            <span class="role-card-desc">Theo dõi chuyên cần & học phí</span>
                        </label>
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="reg-pass" class="form-label">
                        Mật khẩu (tối thiểu 6 ký tự) <span class="required">*</span>
                    </label>
                    <div class="auth-password-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="reg-pass" name="password" class="form-control"
                               placeholder="Nhập mật khẩu an toàn" required autocomplete="new-password">
                        <button type="button" class="auth-password-toggle" data-password-toggle="reg-pass"
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

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="reg-confirm-pass" class="form-label">
                        Xác nhận mật khẩu <span class="required">*</span>
                    </label>
                    <div class="auth-password-wrapper">
                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="reg-confirm-pass" name="confirmPassword" class="form-control"
                               placeholder="Nhập lại mật khẩu" required autocomplete="new-password">
                        <button type="button" class="auth-password-toggle" data-password-toggle="reg-confirm-pass"
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

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 20px;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <line x1="19" y1="8" x2="19" y2="14"></line>
                        <line x1="22" y1="11" x2="16" y2="11"></line>
                    </svg>
                    <span>Hoàn tất đăng ký tài khoản</span>
                </button>
            </form>

            <div class="auth-footer">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
