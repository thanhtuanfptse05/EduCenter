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
      <div class="logout-card-container">
        <div class="logout-single-card">
          <!-- Top Accent Line -->
          <div class="logout-top-accent"></div>

          <!-- Brand Mascot Emblem with Security Alert Badge -->
          <div class="logout-mascot-emblem">
            <div class="logout-mascot-circle">
              <img src="${pageContext.request.contextPath}/assets/images/logo/mascot_owl_icon.png" alt="EduCenter Security Dr. Owl">
            </div>
            <div class="logout-badge-alert" title="Yêu cầu kết thúc phiên">
              <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="stroke-width: 2.5;"><path d="M18.36 6.64a9 9 0 1 1-12.73 0"/><line x1="12" y1="2" x2="12" y2="12"/></svg>
            </div>
          </div>

          <!-- Header Titles & Badges -->
          <div style="margin-bottom: 6px;">
            <span class="auth-pill-badge" style="background: rgba(239, 68, 68, 0.08); color: var(--danger); border: 1px solid rgba(239, 68, 68, 0.2);">
              <span class="pulse-dot" style="background-color: var(--danger);"></span>
              Cổng bảo mật tác nghiệp · TLS 1.3
            </span>
          </div>
          <h1 class="auth-main-heading" style="font-size: 22px; margin-bottom: 8px;">Xác nhận kết thúc phiên làm việc</h1>
          <p class="auth-sub-desc" style="font-size: 13px; line-height: 1.5; margin: 0 auto; max-width: 420px;">
            Bạn đang yêu cầu đăng xuất khỏi tài khoản trên hệ thống quản trị EduCenter. Vui lòng kiểm tra lại thông tin phiên trước khi xác nhận.
          </p>

          <!-- User Session Identity Box -->
          <div class="logout-user-box">
            <div class="logout-user-avatar">
              <c:choose>
                <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                  <img src="<c:url value='${sessionScope.currentUser.avatarUrl}'/>" alt="" onerror="this.style.display='none'; this.nextElementSibling.style.display='inline';">
                  <span class="avatar-initial" style="display: none;"><c:out value="${sessionScope.currentUser.fullName.substring(0,1).toUpperCase()}"/></span>
                </c:when>
                <c:otherwise>
                  <span class="avatar-initial"><c:out value="${sessionScope.currentUser.fullName != null && !sessionScope.currentUser.fullName.isEmpty() ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'U'}"/></span>
                </c:otherwise>
              </c:choose>
              <span class="online-dot" title="Tài khoản đang hoạt động"></span>
            </div>

            <div class="logout-user-info">
              <div class="logout-user-name"><c:out value="${sessionScope.currentUser.fullName}"/></div>
              <div class="logout-user-email"><c:out value="${sessionScope.currentUser.email}"/></div>
              <div class="logout-user-meta">
                <span class="badge badge-admin" style="font-size: 10px; padding: 2px 7px;">
                  <c:out value="${sessionScope.currentUser.primaryRole}"/>
                </span>
                <span class="font-code-num text-muted" style="font-size: 11px;">#UID-<c:out value="${sessionScope.currentUser.userId != null ? sessionScope.currentUser.userId : sessionScope.currentUser.id}"/></span>
              </div>
            </div>
          </div>

          <!-- Reassurance Checklist (Security & State) -->
          <div class="logout-points-list">
            <div class="logout-point-item">
              <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
              <span><strong>Dữ liệu an toàn:</strong> Mọi thao tác, điểm danh và dữ liệu đã lưu trữ thành công trên CSDL trung tâm.</span>
            </div>
            <div class="logout-point-item">
              <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
              <span><strong>Bảo mật phiên:</strong> Khóa cookie xác thực và giải phóng phiên làm việc khỏi trình duyệt này.</span>
            </div>
          </div>

          <!-- Dual Action CTA Buttons -->
          <form action="${pageContext.request.contextPath}/logout" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
            <div class="logout-actions-grid">
              <a href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}" class="btn btn-secondary logout-btn-cancel">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="m15 18-6-6 6-6"/></svg>
                <span>Ở lại phiên làm việc</span>
              </a>
              <button type="submit" class="logout-btn-confirm">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                <span>Xác nhận đăng xuất</span>
              </button>
            </div>
          </form>

          <!-- Card Bottom Reassurance -->
          <div class="logout-card-footer">
            <div style="display: flex; align-items: center; gap: 6px;">
              <span class="site-footer-uptime-dot" style="background: var(--success);"></span>
              <span>EduCenter Cloud (HN-01)</span>
            </div>
            <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); text-decoration: none; font-weight: 500;">
              Đổi tài khoản khác &rarr;
            </a>
          </div>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
