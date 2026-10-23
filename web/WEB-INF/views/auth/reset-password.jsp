<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="public-site">
  <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

  <main id="main-content" class="auth-page-wrapper">
    <div class="auth-main-content">
      <div class="auth-centered-box" style="max-width: 520px;">
        <c:choose>
          <c:when test="${resetState != null and resetState.valid}">
            <!-- Token Security Badge Indicator -->
            <div class="auth-token-badge-bar" data-reset-seconds="${resetState.remainingSeconds}">
              <div style="display: flex; align-items: center; gap: 8px;">
                <span class="site-footer-uptime-dot" style="animation: pulse 2s infinite;"></span>
                <span id="token-valid-badge" class="font-code-num" style="font-weight: 700; color: var(--text);">TOKEN VALID</span>
                <span style="opacity: 0.4;">•</span>
                <span>Mã xác thực an toàn</span>
              </div>
              <div style="display: flex; align-items: center; gap: 6px; font-weight: 600; color: var(--text);">
                <svg class="icon icon-sm" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                <span class="font-code-num" id="countdown-timer">
                  <strong id="reset-time-left">
                  <c:choose>
                    <c:when test="${resetState.remainingSeconds > 0}">
                      ${resetState.remainingSeconds / 60}:${(resetState.remainingSeconds % 60 < 10 ? '0' : '')}${resetState.remainingSeconds % 60}
                    </c:when>
                    <c:otherwise>14:59</c:otherwise>
                  </c:choose>
                  </strong>
                </span>
              </div>
            </div>

            <!-- Main Card Container -->
            <div class="auth-single-card">
              <!-- Top Accent Bar -->
              <div class="top-accent-bar"></div>

              <!-- Header Group -->
              <div style="display: flex; flex-direction: column; gap: 6px; margin-bottom: 24px;">
                <div style="display: flex; align-items: center; justify-content: space-between;">
                  <div style="width: 40px; height: 40px; border-radius: var(--radius-md); background: var(--surface-muted); display: flex; align-items: center; justify-content: center; color: var(--primary);">
                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 2l-2 2m-2-2l2 2"/><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                  </div>
                  <span class="auth-pill-badge">AUTH-04</span>
                </div>
                <h1 class="auth-main-heading" style="font-size: 20px; margin-top: 8px; margin-bottom: 4px;">
                  Thiết lập mật khẩu mới
                </h1>
                <p class="auth-sub-desc" style="font-size: 13px; line-height: 1.5; margin: 0;">
                  Mật khẩu mới của bạn phải khác mật khẩu đã sử dụng gần đây và đáp ứng tiêu chuẩn an toàn dữ liệu ISO/IEC 27001.
                </p>
              </div>

              <!-- Flash Alert -->
              <%@ include file="/WEB-INF/views/common/alert.jsp" %>

              <!-- Reset Form -->
              <form action="${pageContext.request.contextPath}/reset-password" method="post" id="reset-password-form" data-reset-form style="display: flex; flex-direction: column; gap: 18px;">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <input type="hidden" name="token" value="<c:out value='${token}'/>"/>

                <!-- Field 1: New Password -->
                <div class="form-group">
                  <div class="pwd-strength-header">
                    <label class="form-label" for="newPassword" style="margin: 0;">Mật khẩu mới</label>
                    <span class="font-code-num text-muted" id="pwd-strength-label" style="font-size: 11px;"
                          data-empty="Chưa đánh giá"
                          data-weak="Yếu"
                          data-medium="Trung bình"
                          data-good="Khá"
                          data-strong="Rất mạnh">Chưa đánh giá</span>
                  </div>
                  <div class="auth-password-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </span>
                    <input class="form-control" id="newPassword" name="newPassword" type="password"
                           placeholder="••••••••••••" required minlength="6" autocomplete="new-password"/>
                    <button type="button" class="auth-password-toggle" data-password-toggle="newPassword" aria-label="Hiện/ẩn mật khẩu">
                      <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                      <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display:none;"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" x2="22" y1="2" y2="22"/></svg>
                    </button>
                  </div>
                  <!-- Dynamic Strength 4-Bar Meter -->
                  <div class="pwd-strength-bars-grid">
                    <div class="pwd-bar-segment" id="bar-1"></div>
                    <div class="pwd-bar-segment" id="bar-2"></div>
                    <div class="pwd-bar-segment" id="bar-3"></div>
                    <div class="pwd-bar-segment" id="bar-4"></div>
                  </div>
                  <!-- Dynamic Rules Checklist -->
                  <ul class="pwd-rules-checklist">
                    <li class="pwd-rule-item" id="rule-len">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>≥ 6 ký tự</span>
                    </li>
                    <li class="pwd-rule-item" id="rule-upper">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>Chữ hoa</span>
                    </li>
                    <li class="pwd-rule-item" id="rule-num">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>Chữ số</span>
                    </li>
                    <li class="pwd-rule-item" id="rule-special">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>Ký tự đặc biệt</span>
                    </li>
                  </ul>
                </div>

                <!-- Field 2: Confirm Password -->
                <div class="form-group">
                  <div class="pwd-strength-header">
                    <label class="form-label" for="confirmNewPassword" style="margin: 0;">Xác nhận mật khẩu</label>
                  </div>
                  <div class="auth-password-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 2l-2 2m-2-2l2 2"/><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </span>
                    <input class="form-control" id="confirmNewPassword" name="confirmNewPassword" type="password"
                           placeholder="••••••••••••" required minlength="6" autocomplete="new-password"/>
                    <button type="button" class="auth-password-toggle" data-password-toggle="confirmNewPassword" aria-label="Hiện/ẩn mật khẩu">
                      <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                      <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display:none;"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" x2="22" y1="2" y2="22"/></svg>
                    </button>
                  </div>
                  <span id="match-indicator" class="match-status-text matched" style="opacity: 0; transition: opacity 0.2s;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                    Mật khẩu trùng khớp
                  </span>
                  <span id="match-error" class="match-status-text mismatch" style="display: none;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    Mật khẩu xác nhận không khớp
                  </span>
                </div>

                <!-- Session Revocation Checkbox -->
                <div class="turnstile-box" style="margin-bottom: 4px;">
                  <label class="auth-checkbox-label" style="align-items: flex-start;">
                    <input type="checkbox" name="revokeSessions" checked style="margin-top: 3px;"/>
                    <div>
                      <div style="font-size: 13px; font-weight: 600; color: var(--text);">Đăng xuất khỏi tất cả các thiết bị khác</div>
                      <div style="font-size: 11px; color: var(--text-muted); line-height: 1.4;">Khuyến nghị cho trường hợp nghi ngờ lộ thông tin hoặc truy cập từ máy công cộng.</div>
                    </div>
                  </label>
                </div>

                <!-- Submit CTA -->
                <button type="submit" class="btn btn-primary" style="height: 44px; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600;">
                  <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
                  <span>Cập nhật mật khẩu &amp; Đăng nhập</span>
                </button>
              </form>

              <!-- Token Expired Notification Banner Preview -->
              <div id="token-expired-card" class="alert alert-danger" style="display: none; border-radius: var(--radius-md); margin-top: 16px; flex-direction: column; gap: 8px;">
                <div style="font-weight: 600; font-size: 14px;">Phiên xác thực đã hết hạn</div>
                <p style="margin: 0; font-size: 13px; color: var(--text-muted);">
                  Liên kết đặt lại mật khẩu của bạn đã quá thời gian 15 phút bảo mật. Vui lòng tạo yêu cầu cấp token mới.
                </p>
                <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn-secondary btn-sm" style="text-decoration: none; align-self: flex-start; margin-top: 4px;">
                  Yêu cầu gửi lại liên kết mới
                </a>
              </div>
            </div>
          </c:when>

          <c:otherwise>
            <!-- Token Expired or Invalid State -->
            <div class="auth-single-card" style="text-align: center;">
              <div class="top-accent-bar" style="background: var(--danger);"></div>
              <div class="security-emblem-wrapper">
                <div class="security-emblem-circle">
                  <div class="security-emblem-inner" style="background: rgba(239, 68, 68, 0.1); color: var(--danger);">
                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                  </div>
                </div>
              </div>
              <h1 class="auth-main-heading" style="font-size: 20px; margin-bottom: 8px;">Liên kết không hợp lệ hoặc đã hết hạn</h1>
              <p class="auth-sub-desc" style="font-size: 13px; line-height: 1.5; margin-bottom: 20px;">
                Liên kết đặt lại mật khẩu này không tồn tại, đã được sử dụng trước đó hoặc đã quá thời hạn 15 phút bảo mật tiêu chuẩn.
              </p>
              <a href="${pageContext.request.contextPath}/forgot-password" class="btn btn-primary" style="text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600;">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"/></svg>
                <span>Yêu cầu liên kết mới</span>
              </a>
            </div>
          </c:otherwise>
        </c:choose>

        <!-- Return to Login Footer Navigation -->
        <div style="display: flex; align-items: center; justify-content: center; gap: 6px; font-size: 14px; color: var(--text-muted); margin-top: 16px;">
          <span>Đã nhớ mật khẩu hiện tại?</span>
          <a href="${pageContext.request.contextPath}/login" class="auth-forgot-link" style="display: inline-flex; align-items: center; gap: 2px;">
            Quay lại Đăng nhập
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"/></svg>
          </a>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>