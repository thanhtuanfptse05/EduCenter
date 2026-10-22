<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Đăng nhập — EduCenter Cổng Xác Thực & Quản Trị" scope="request" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="auth-page-wrapper">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="auth-main-content">
            <div class="auth-split-card">
                <!-- Left Column: Authentication Form -->
                <div class="auth-split-form">
                    <div>
                        <!-- Header & Badges -->
                        <div class="auth-split-header-badges">
                            <div class="auth-badge-group">
                                <span class="auth-pill-badge">
                                    <span class="pulse-dot"></span>
                                    AUTH-01
                                </span>
                                <span class="auth-pill-badge" style="color: var(--text-muted); font-weight: 500;">
                                    SSO &amp; RBAC Active
                                </span>
                            </div>
                            <div class="auth-security-tag">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    <polyline points="9 12 11 14 15 10"></polyline>
                                </svg>
                                <span>TLS 1.3 / AES-256</span>
                            </div>
                        </div>

                        <!-- Page Heading -->
                        <div class="auth-title-block">
                            <h1 class="auth-main-heading">Đăng nhập vào EduCenter</h1>
                            <p class="auth-sub-desc">
                                Nền tảng quản lý gia sư &amp; luyện thi THPT chuẩn hóa mô hình phân quyền tác nghiệp.
                            </p>
                        </div>

                        <!-- Alerts (Success / Error / Info) -->
                        <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                        <!-- Form Element -->
                        <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
                            <!-- CSRF Token -->
                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">

                            <c:if test="${not empty param.redirect_url}">
                                <input type="hidden" name="redirect_url" value="<c:out value='${param.redirect_url}' />">
                            </c:if>

                            <!-- Email / Username Input -->
                            <div class="form-group">
                                <label for="login-email" class="form-label">
                                    Tài khoản hoặc Email tổ chức <span class="required" style="color: var(--danger);">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                    </svg>
                                    <input type="email" id="login-email" name="email" class="form-control"
                                           placeholder="gv.hoanglong@educenter.vn" required autofocus
                                           value="<c:out value='${not empty sessionScope.preserved_email ? sessionScope.preserved_email : param.email}' />">
                                </div>
                                <c:remove var="preserved_email" scope="session" />
                            </div>

                            <!-- Password Input -->
                            <div class="form-group" style="margin-top: 16px;">
                                <label for="login-password" class="form-label">
                                    Mật khẩu hệ thống <span class="required" style="color: var(--danger);">*</span>
                                </label>
                                <div class="auth-password-wrapper">
                                    <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    </svg>
                                    <input type="password" id="login-password" name="password" class="form-control"
                                           placeholder="••••••••••••" required autocomplete="current-password">
                                    <button type="button" class="auth-password-toggle" data-password-toggle="login-password"
                                            aria-label="Ẩn hiện mật khẩu" title="Ẩn/Hiện mật khẩu">
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

                            <!-- Remember Me & Forgot Password Row -->
                            <div class="auth-aux-row">
                                <label class="auth-checkbox-label" for="remember-me">
                                    <input type="checkbox" id="remember-me" name="rememberMe" value="true" checked>
                                    <span>Duy trì phiên đăng nhập 30 ngày</span>
                                </label>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="auth-forgot-link">
                                    Quên mật khẩu?
                                </a>
                            </div>

                            <!-- Primary Login Button -->
                            <button type="submit" class="btn btn-primary btn-block" style="height: 42px; font-size: var(--font-size-md);">
                                <span>Đăng nhập vào hệ thống</span>
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                    <polyline points="12 5 19 12 12 19"></polyline>
                                </svg>
                            </button>
                        </form>

                        <!-- Divider -->
                        <div class="auth-divider-line">
                            <span class="auth-divider-text">Hoặc tiếp tục với</span>
                        </div>

                        <!-- SSO Button -->
                        <a href="${pageContext.request.contextPath}/login" class="btn-sso-google" title="Đăng nhập Google Workspace">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path>
                                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path>
                                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z" fill="#FBBC05"></path>
                                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z" fill="#EA4335"></path>
                            </svg>
                            <span>Tài khoản Google Workspace Giáo dục (@educenter.vn)</span>
                        </a>
                    </div>

                    <!-- Footer Notice within Card -->
                    <div class="auth-footer-note">
                        <span>
                            Chưa có tài khoản tuyển sinh? 
                            <a href="${pageContext.request.contextPath}/register">Đăng ký xét tuyển &amp; Học viên mới</a>
                        </span>
                        <span style="font-size: var(--font-size-xs); font-family: monospace;">v2.4.19-STABLE</span>
                    </div>
                </div>

                <!-- Right Column: Enterprise Brand & Academic Security Panel -->
                <div class="auth-split-showcase">
                    <!-- Top Institutional Badges -->
                    <div class="showcase-top">
                        <div class="showcase-brand-badge">
                            <div class="showcase-brand-letter">M</div>
                            <span>M02 - Tuyển Sinh &amp; Đào Tạo</span>
                        </div>
                        <span class="showcase-category-tag">THPT Quốc Gia</span>
                    </div>

                    <!-- Center Academic Metrics & Infographic Card -->
                    <div>
                        <div class="academic-metrics-card">
                            <div class="metrics-header-row">
                                <span class="metrics-title">Hiệu quả luyện thi THPT 2025</span>
                                <span class="metrics-highlight">98.4% Đỗ NV1</span>
                            </div>
                            <!-- Multi-segment progress bar -->
                            <div class="multi-progress-bar">
                                <div class="progress-segment-1" title="Khối A00/A01 (65%)"></div>
                                <div class="progress-segment-2" title="Khối B00/D01 (25%)"></div>
                                <div class="progress-segment-3" title="Khối Khác (10%)"></div>
                            </div>
                            <div class="metrics-scores-row">
                                <span>Điểm TB Toán: 8.72</span>
                                <span>Lý: 8.45</span>
                                <span>Hóa: 8.60</span>
                            </div>
                        </div>

                        <!-- Academic Architecture Keypoints -->
                        <div class="academic-keypoints-card">
                            <div class="keypoint-item">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                <div>
                                    <h4 class="keypoint-title">Quyền hạn tác nghiệp nghiêm ngặt (RBAC)</h4>
                                    <p class="keypoint-desc">
                                        Phân tách độc lập sổ điểm kiểm tra định kỳ giữa Giảng viên chuyên môn, Trợ giảng, Học viên và Phụ huynh theo thời gian thực.
                                    </p>
                                </div>
                            </div>
                            <div class="keypoint-item">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    <polyline points="9 12 11 14 15 10"></polyline>
                                </svg>
                                <div>
                                    <h4 class="keypoint-title">Mã hóa Dữ liệu Học tập Chuẩn AES-256</h4>
                                    <p class="keypoint-desc">
                                        Bảo vệ kết quả thi thử mô phỏng, lịch sử nộp bài và dữ liệu liên lạc gia đình theo quy chế an toàn dữ liệu Bộ GD&amp;ĐT.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- Quote Box -->
                        <div class="academic-quote-box">
                            <p class="academic-quote-text">
                                “Hệ thống tự động đồng bộ kết quả chuyên cần vân tay, cảnh báo học lực suy giảm và gửi SMS định kỳ cho phụ huynh sau mỗi ca luyện đề.”
                            </p>
                            <div class="academic-quote-author">
                                <span class="pulse-dot"></span>
                                <span>Hội đồng Chuyên môn Toán - Lý - Hóa EduCenter</span>
                            </div>
                        </div>
                    </div>

                    <!-- Bottom Status Footer -->
                    <div class="showcase-bottom-status">
                        <div style="display: flex; align-items: center; gap: 6px;">
                            <span class="pulse-dot"></span>
                            <span>Cụm máy chủ Hà Nội (HN-01)</span>
                        </div>
                        <span style="font-family: monospace;">Độ trễ: 14ms · TLS 1.3</span>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</body>
</html>
