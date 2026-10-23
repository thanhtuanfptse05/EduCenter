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
      <div class="auth-centered-box">
        <!-- Main Authentication Card -->
        <div class="auth-single-card">
          <!-- Top Color Bar Indicator -->
          <div class="top-accent-bar"></div>

          <!-- Security Emblem -->
          <div class="security-emblem-wrapper">
            <div class="security-emblem-circle">
              <div class="security-emblem-inner">
                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/><circle cx="12" cy="16" r="1"/></svg>
              </div>
              <div class="security-spark-badge">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
              </div>
            </div>
          </div>

          <!-- Heading Group -->
          <div style="text-align: center; margin-bottom: 24px;">
            <div class="auth-pill-badge" style="display: inline-flex; margin-bottom: 8px;">AUTH-03 · Khôi phục truy cập</div>
            <h1 class="auth-main-heading" style="font-size: 20px; margin-bottom: 6px;">
              Khôi phục mật khẩu tài khoản
            </h1>
            <p class="auth-sub-desc" style="font-size: 13px; line-height: 1.5; margin: 0;">
              Nhập địa chỉ email liên kết với hồ sơ cán bộ hoặc học viên EduCenter. Hệ thống sẽ phát hành liên kết mã hóa an toàn có hiệu lực trong 15 phút.
            </p>
          </div>

          <!-- Flash Alerts -->
          <%@ include file="/WEB-INF/views/common/alert.jsp" %>

          <!-- PRJ301 Evaluation Convenience Link (if generated) -->
          <c:if test="${not empty sessionScope.demo_reset_link}">
            <div class="alert alert-info mb-4" style="border-radius: var(--radius-md); font-size: 13px;">
              <div style="font-weight: 600; margin-bottom: 4px;">Liên kết đặt lại mật khẩu của bạn:</div>
              <p style="margin: 0 0 8px 0; color: var(--text-muted);">
                Do môi trường thực hành nội bộ không gửi email ra internet, bạn có thể nhấp vào nút dưới đây để tiếp tục quy trình:
              </p>
              <a href="${sessionScope.demo_reset_link}" class="btn btn-secondary btn-sm" style="text-decoration: none; display: inline-flex; align-items: center; gap: 6px;">
                <span>Mở phiên đặt lại mật khẩu</span>
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
              </a>
            </div>
            <c:remove var="demo_reset_link" scope="session"/>
          </c:if>

          <!-- Request Form -->
          <form action="${pageContext.request.contextPath}/forgot-password" method="post" style="display: flex; flex-direction: column; gap: 18px;">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>

            <!-- Input Field: Email -->
            <div class="form-group">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                <label class="form-label" for="recoveryEmail" style="margin: 0;">Email định danh cổng dịch vụ</label>
                <span class="font-code-num text-muted" style="font-size: 11px;">Bắt buộc</span>
              </div>
              <div class="input-wrapper">
                <span class="input-icon">
                  <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
                </span>
                <input class="form-control" id="recoveryEmail" name="email" type="email"
                       placeholder="ten.nguoidung@educenter.vn" required maxlength="255" autocomplete="email"/>
              </div>
              <div style="display: flex; align-items: center; gap: 6px; margin-top: 6px; font-size: 12px; color: var(--text-muted);">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                <span>Chấp nhận email tên miền trường (@educenter.vn) hoặc email cá nhân đã xác thực.</span>
              </div>
            </div>

            <!-- Bot Shield Guard -->
            <div class="turnstile-box">
              <div style="display: flex; align-items: center; gap: 10px;">
                <input type="checkbox" checked disabled class="accent-primary" style="width: 16px; height: 16px;"/>
                <div>
                  <div style="font-size: 13px; font-weight: 600; color: var(--text);">Xác thực con người bảo mật</div>
                  <div class="font-code-num text-muted" style="font-size: 11px;">EduCenter Sentinel Guard 3.0</div>
                </div>
              </div>
              <div style="display: flex; align-items: center; gap: 4px; color: var(--success); font-size: 11px; font-weight: 700; text-transform: uppercase;">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
                <span>Active</span>
              </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary" style="height: 44px; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600;">
              <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
              <span>Gửi liên kết khôi phục</span>
            </button>
          </form>

          <!-- Auxiliary Action Links -->
          <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--border); display: flex; flex-direction: column; align-items: center; gap: 12px; text-align: center;">
            <a href="${pageContext.request.contextPath}/login" class="auth-forgot-link" style="display: inline-flex; align-items: center; gap: 6px;">
              <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
              <span>Quay lại trang Đăng nhập</span>
            </a>
            <div style="font-size: 12px; color: var(--text-muted);">
              <span>Gặp sự cố truy cập? </span>
              <a href="mailto:hotro@educenter.vn" class="auth-forgot-link">hotro@educenter.vn</a>
            </div>
          </div>
        </div>

        <!-- Security & Compliance Micro Footer -->
        <div style="display: flex; align-items: center; justify-content: space-between; font-size: 11px; color: var(--text-muted); padding: 0 4px;">
          <div style="display: flex; align-items: center; gap: 4px;">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            <span>Mã hóa TLS 1.3 / AES-256</span>
          </div>
          <span>Phiên giao dịch: <strong class="font-code-num">SEC-9182</strong></span>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>