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
      <div class="auth-split-card">
        <!-- Cột Trái: Auth Form Core -->
        <div class="auth-split-form">
          <div>
            <!-- Header Badges -->
            <div class="auth-split-header-badges">
              <div class="auth-badge-group">
                <span class="auth-pill-badge">
                  <span class="pulse-dot"></span>
                  AUTH-01
                </span>
                <span class="auth-pill-badge" style="background: var(--surface-muted); color: var(--text-muted);">
                  SSO &amp; RBAC Active
                </span>
              </div>
              <div class="auth-security-tag">
                <svg class="icon icon-sm" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
                <span>TLS 1.3 / AES-256</span>
              </div>
            </div>

            <!-- Page Heading & Brand Identity -->
            <div class="auth-title-block" style="margin-top: 16px; margin-bottom: 28px;">
              <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 10px;">
                <img src="${pageContext.request.contextPath}/assets/images/logo/mascot_owl_icon.png" alt="EduCenter Mascot" style="width: 46px; height: 46px; border-radius: 10px; object-fit: contain; box-shadow: var(--shadow-sm); background: #FFF; border: 1px solid var(--border); padding: 2px; flex-shrink: 0;">
                <div>
                  <h1 class="auth-main-heading" style="margin: 0; font-size: 22px; font-weight: 700; line-height: 1.25;">Đăng nhập vào EduCenter</h1>
                  <span style="font-size: 11px; font-weight: 600; color: var(--primary); text-transform: uppercase; letter-spacing: 0.04em;">Cổng xác thực tác nghiệp</span>
                </div>
              </div>
              <p class="auth-sub-desc" style="margin: 0; font-size: 13px; color: var(--text-muted); line-height: 1.5;">
                Nền tảng quản lý gia sư &amp; luyện thi THPT chuẩn hóa mô hình phân quyền tác nghiệp.
              </p>
            </div>

            <!-- Flash Alert Messages -->
            <div style="margin-bottom: 16px;">
              <%@ include file="/WEB-INF/views/common/alert.jsp" %>
            </div>

            <!-- Core Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form-body">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <input type="hidden" name="redirect_url" value="<c:out value='${param.redirect_url}'/>"/>

              <!-- Email Field -->
              <div class="form-group mb-3">
                <label class="form-label" for="auth-email">Tài khoản hoặc Email tổ chức</label>
                <div class="input-wrapper">
                  <span class="input-icon">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="4"/><path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8"/></svg>
                  </span>
                  <input class="form-control" id="auth-email" name="email" type="email"
                         placeholder="ten.nguoidung@educenter.vn" required autocomplete="username"
                         value="<c:out value='${sessionScope.preserved_email}'/>"/>
                </div>
              </div>
              <c:remove var="preserved_email" scope="session"/>

              <!-- Password Field -->
              <div class="form-group mb-3">
                <label class="form-label" for="auth-password">Mật khẩu hệ thống</label>
                <div class="auth-password-wrapper">
                  <span class="input-icon">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                  </span>
                  <input class="form-control" id="auth-password" name="password" type="password"
                         placeholder="••••••••••••" required autocomplete="current-password"/>
                  <button type="button" class="auth-password-toggle" data-password-toggle="auth-password" aria-label="Ẩn/hiện mật khẩu">
                    <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                    <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display:none;"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" x2="22" y1="2" y2="22"/></svg>
                  </button>
                </div>
              </div>

              <!-- Remember Me & Forgot Password Row -->
              <div class="auth-aux-row">
                <label class="auth-checkbox-label">
                  <input type="checkbox" name="remember" checked/>
                  <span>Duy trì phiên đăng nhập theo quy chế</span>
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password" class="auth-forgot-link">
                  Quên mật khẩu?
                </a>
              </div>

              <!-- Primary Submit CTA -->
              <button type="submit" class="btn btn-primary" style="width: 100%; height: 44px; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600;">
                <span>Đăng nhập vào hệ thống</span>
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
              </button>
            </form>
          </div>

          <!-- Footer within Card -->
          <div class="auth-footer-note">
            <p style="margin: 0;">
              Chưa có tài khoản tuyển sinh?
              <a href="${pageContext.request.contextPath}/register">
                Đăng ký xét tuyển &amp; Học viên mới
              </a>
            </p>
            <span class="font-code-num text-muted">v2.4.19-STABLE</span>
          </div>
        </div>

        <!-- Cột Phải: Enterprise Brand & Academic Security Panel -->
        <div class="auth-split-showcase">
          <!-- Top Badges -->
          <div class="showcase-top">
            <div class="showcase-brand-badge">
              <span class="showcase-brand-letter">M</span>
              <span>M02 - Tuyển Sinh &amp; Đào Tạo</span>
            </div>
            <span class="showcase-category-tag">THPT Quốc Gia</span>
          </div>

          <!-- Academic Metrics Card -->
          <div class="academic-metrics-card">
            <div class="metrics-header-row">
              <span class="metrics-title">Hiệu quả luyện thi THPT 2025</span>
              <span class="metrics-highlight">98.4% Đỗ NV1</span>
            </div>
            <!-- Progress Line Bar -->
            <div class="multi-progress-bar" title="Khối A00/A01 (65%), Khối B00/D01 (25%), Khối Khác (10%)">
              <div class="progress-segment-1"></div>
              <div class="progress-segment-2"></div>
              <div class="progress-segment-3"></div>
            </div>
            <div class="metrics-scores-row">
              <span>Điểm TB Toán: 8.72</span>
              <span>Lý: 8.45</span>
              <span>Hóa: 8.60</span>
            </div>
          </div>

          <!-- Architecture Keypoints -->
          <div class="academic-keypoints-card">
            <div class="keypoint-item">
              <svg class="icon icon-md" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
              <div>
                <div class="keypoint-title">Quyền hạn tác nghiệp nghiêm ngặt (RBAC)</div>
                <div class="keypoint-desc">
                  Phân tách độc lập sổ điểm kiểm tra định kỳ giữa Giảng viên chuyên môn, Trợ giảng, Học viên và Phụ huynh theo thời gian thực.
                </div>
              </div>
            </div>
            <div class="keypoint-item">
              <svg class="icon icon-md" style="color: var(--success);" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              <div>
                <div class="keypoint-title">Mã hóa Dữ liệu Học tập Chuẩn AES-256</div>
                <div class="keypoint-desc">
                  Bảo vệ kết quả thi thử mô phỏng, lịch sử nộp bài và dữ liệu liên lạc gia đình theo quy chế an toàn dữ liệu Bộ GD&amp;ĐT.
                </div>
              </div>
            </div>
          </div>

          <!-- Quote Box -->
          <div class="academic-quote-box">
            <div class="academic-quote-text">
              “Hệ thống tự động đồng bộ kết quả chuyên cần vân tay, cảnh báo học lực suy giảm và gửi SMS định kỳ cho phụ huynh sau mỗi ca luyện đề.”
            </div>
            <div class="academic-quote-author">
              <span class="showcase-brand-letter" style="width: 22px; height: 22px; font-size: 10px;">TS</span>
              <span>Hội đồng Chuyên môn Toán - Lý - Hóa EduCenter</span>
            </div>
          </div>

          <!-- Bottom Status Footer -->
          <div class="showcase-bottom-status">
            <div style="display: flex; align-items: center; gap: 6px;">
              <span class="site-footer-uptime-dot"></span>
              <span>Cụm máy chủ Hà Nội (HN-01)</span>
            </div>
            <span class="font-code-num">Latency: 14ms</span>
          </div>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>