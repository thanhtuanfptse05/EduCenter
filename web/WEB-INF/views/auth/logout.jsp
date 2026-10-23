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
      <div class="auth-centered-box" style="max-width: 480px;">
        <div class="auth-single-card" style="text-align: center;">
          <div class="top-accent-bar"></div>

          <div class="security-emblem-wrapper">
            <div class="security-emblem-circle">
              <div class="security-emblem-inner" style="background: rgba(239, 68, 68, 0.1); color: var(--danger);">
                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
              </div>
            </div>
          </div>

          <div class="auth-pill-badge" style="display: inline-flex; margin-bottom: 8px;">Phiên làm việc</div>
          <h1 class="auth-main-heading" style="font-size: 20px; margin-bottom: 8px;">Xác nhận đăng xuất</h1>
          <p class="auth-sub-desc" style="font-size: 13px; line-height: 1.5; margin-bottom: 24px;">
            Bạn có chắc chắn muốn kết thúc phiên làm việc của <strong style="color: var(--text);"><c:out value="${sessionScope.currentUser.fullName}"/></strong>? Mọi dữ liệu đã lưu sẽ được bảo toàn an toàn.
          </p>

          <form action="${pageContext.request.contextPath}/logout" method="post" style="display: flex; gap: 12px; justify-content: center;">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
            <a href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}" class="btn btn-secondary" style="height: 42px; padding: 0 24px; text-decoration: none; display: inline-flex; align-items: center; justify-content: center;">
              Hủy bỏ
            </a>
            <button type="submit" class="btn btn-danger" style="height: 42px; padding: 0 24px; display: inline-flex; align-items: center; justify-content: center; gap: 6px; font-weight: 600;">
              <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
              <span>Đăng xuất</span>
            </button>
          </form>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
