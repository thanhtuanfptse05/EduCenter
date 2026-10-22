<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Thiết lập mật khẩu mới — EduCenter Cổng Bảo Mật" scope="request" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="auth-page-wrapper">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="auth-main-content">
            <div class="auth-centered-box" style="max-width: 500px;">
                <!-- Token Security Badge Indicator -->
                <div class="auth-token-badge-bar" id="token-valid-badge">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <span class="pulse-dot"></span>
                        <span style="font-weight: 700; color: var(--text); letter-spacing: 0.05em; font-family: monospace;">TOKEN VALID</span>
                        <span>•</span>
                        <span>Mã xác thực an toàn</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 6px; font-family: monospace; font-weight: 700; color: var(--text);">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);">
                            <circle cx="12" cy="12" r="10"></circle>
                            <polyline points="12 6 12 12 16 14"></polyline>
                        </svg>
                        <span id="countdown-timer">14:59</span>
                    </div>
                </div>

                <!-- Main Card Container -->
                <div class="auth-single-card">
                    <!-- Top Color Bar Indicator -->
                    <div class="top-accent-bar"></div>

                    <!-- Header -->
                    <div style="margin-bottom: 24px;">
                        <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px;">
                            <div style="width: 40px; height: 40px; border-radius: var(--radius-md); background: var(--surface-muted); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                    <path d="M12 14v4"></path>
                                </svg>
                            </div>
                            <span class="auth-pill-badge" style="font-family: monospace;">AUTH-04</span>
                        </div>
                        <h1 class="auth-main-heading" style="font-size: var(--font-size-xl);">Thiết lập mật khẩu mới</h1>
                        <p class="auth-sub-desc" style="font-size: var(--font-size-sm);">
                            Mật khẩu mới của bạn phải khác mật khẩu đã sử dụng gần đây và đáp ứng tiêu chuẩn an toàn dữ liệu ISO/IEC 27001.
                        </p>
                    </div>

                    <!-- Alerts (Success / Error / Info) -->
                    <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                    <!-- Form -->
                    <form action="${pageContext.request.contextPath}/reset-password" method="post" novalidate id="reset-password-form">
                        <!-- CSRF Token -->
                        <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                        <input type="hidden" name="token" value="<c:out value='${token}' />">

                        <!-- Field 1: New Password -->
                        <div class="form-group" style="margin-bottom: 16px;">
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
                                       placeholder="••••••••••••" required autocomplete="new-password" autofocus>
                                <button type="button" class="auth-password-toggle" data-password-toggle="newPassword"
                                        aria-label="Ẩn/hiện mật khẩu" title="Ẩn/Hiện mật khẩu">
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
                            <div class="pwd-strength-bars-grid">
                                <div class="pwd-bar-segment" id="bar-1"></div>
                                <div class="pwd-bar-segment" id="bar-2"></div>
                                <div class="pwd-bar-segment" id="bar-3"></div>
                                <div class="pwd-bar-segment" id="bar-4"></div>
                            </div>

                            <!-- Password Dynamic Checklist -->
                            <div style="background-color: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 12px; margin-top: 8px;">
                                <ul class="pwd-rules-checklist" style="margin: 0; gap: 8px 16px;">
                                    <li class="pwd-rule-item" id="rule-len">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                        <span>Ít nhất 8 ký tự</span>
                                    </li>
                                    <li class="pwd-rule-item" id="rule-num">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                        <span>Có ít nhất 1 chữ số</span>
                                    </li>
                                    <li class="pwd-rule-item" id="rule-special">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                        <span>Có chữ hoa &amp; ký tự đặc biệt</span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Field 2: Confirm Password -->
                        <div class="form-group" style="margin-bottom: 16px;">
                            <div class="pwd-strength-header">
                                <label for="confirmNewPassword" class="form-label" style="margin-bottom: 0;">
                                    Xác nhận mật khẩu <span class="required" style="color: var(--danger);">*</span>
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
                                <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-control"
                                       placeholder="••••••••••••" required autocomplete="new-password">
                                <button type="button" class="auth-password-toggle" data-password-toggle="confirmNewPassword"
                                        aria-label="Ẩn/hiện mật khẩu xác nhận" title="Ẩn/Hiện mật khẩu">
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

                        <!-- Session Revocation Checkbox -->
                        <div style="background-color: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 12px 14px; margin-bottom: 20px;">
                            <label class="auth-checkbox-label" style="align-items: flex-start; cursor: pointer;" for="revoke-sessions">
                                <input type="checkbox" id="revoke-sessions" name="revokeOtherSessions" value="true" checked style="margin-top: 3px;">
                                <span style="display: flex; flex-direction: column;">
                                    <span style="font-weight: 600; font-size: var(--font-size-sm); color: var(--text);">Đăng xuất khỏi tất cả các thiết bị khác</span>
                                    <span style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.4; margin-top: 2px;">
                                        Khuyến nghị cho trường hợp nghi ngờ lộ thông tin hoặc truy cập từ máy công cộng.
                                    </span>
                                </span>
                            </label>
                        </div>

                        <!-- Submit Button CTA -->
                        <button type="submit" class="btn btn-primary btn-block" style="height: 42px; font-size: var(--font-size-md);" id="btn-submit">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                            <span>Cập nhật mật khẩu &amp; Đăng nhập</span>
                        </button>
                    </form>

                    <!-- Auxiliary Action Links -->
                    <div style="margin-top: 24px; padding-top: 18px; border-top: 1px solid var(--border); display: flex; flex-direction: column; align-items: center; gap: 8px; text-align: center;">
                        <div style="font-size: var(--font-size-sm); color: var(--text-muted);">
                            Đã nhớ mật khẩu hiện tại? 
                            <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">
                                Quay lại Đăng nhập &rarr;
                            </a>
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
                    <span>Phiên giao dịch an toàn</span>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</body>
</html>
