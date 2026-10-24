<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <%@ include file="/WEB-INF/views/common/head.jspf" %>
  <style>
    /* Robust self-contained styles for Logout Gateway to eliminate cache dependencies */
    .logout-wrapper {
      min-height: calc(100vh - 120px);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 40px 16px;
      background-color: var(--bg, #F8FAFC);
    }
    .logout-card-container {
      max-width: 500px;
      width: 100%;
      margin: 0 auto;
    }
    .logout-single-card {
      background-color: var(--surface, #FFFFFF);
      border: 1px solid var(--border, #E2E8F0);
      border-radius: 16px;
      box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.08), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
      overflow: hidden;
      position: relative;
      padding: 36px 32px 28px;
      text-align: center;
    }
    .logout-top-accent {
      height: 4px;
      width: 100%;
      background: linear-gradient(90deg, #f59e0b 0%, #ef4444 50%, var(--primary, #2563EB) 100%);
      position: absolute;
      top: 0;
      left: 0;
    }
    .logout-mascot-emblem {
      position: relative;
      width: 80px;
      height: 80px;
      margin: 0 auto 16px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .logout-mascot-circle {
      width: 76px;
      height: 76px;
      border-radius: 50%;
      background: var(--surface, #FFFFFF);
      border: 2px solid var(--border, #E2E8F0);
      box-shadow: var(--shadow-sm, 0 1px 2px rgba(0,0,0,0.05));
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      padding: 6px;
    }
    .logout-mascot-circle img {
      width: 100% !important;
      height: 100% !important;
      max-width: 64px !important;
      max-height: 64px !important;
      object-fit: contain !important;
      display: block;
    }
    .logout-badge-alert {
      position: absolute;
      bottom: -2px;
      right: -2px;
      width: 26px;
      height: 26px;
      border-radius: 50%;
      background: var(--danger, #EF4444);
      color: #FFFFFF;
      border: 2px solid var(--surface, #FFFFFF);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: var(--shadow-xs, 0 1px 2px rgba(0,0,0,0.05));
    }
    .logout-user-box {
      background-color: var(--surface-muted, #F1F5F9);
      border: 1px solid var(--border, #E2E8F0);
      border-radius: 12px;
      padding: 14px 16px;
      margin: 20px 0;
      display: flex;
      align-items: center;
      gap: 14px;
      text-align: left;
    }
    .logout-user-avatar {
      position: relative;
      width: 48px;
      height: 48px;
      min-width: 48px;
      max-width: 48px;
      min-height: 48px;
      max-height: 48px;
      border-radius: 50%;
      background: var(--primary-subtle, #EFF6FF);
      border: 2px solid var(--border, #E2E8F0);
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      overflow: hidden;
    }
    .logout-user-avatar img {
      width: 48px !important;
      height: 48px !important;
      min-width: 48px !important;
      max-width: 48px !important;
      min-height: 48px !important;
      max-height: 48px !important;
      border-radius: 50% !important;
      object-fit: cover !important;
      display: block;
    }
    .logout-user-avatar .avatar-initial {
      font-size: 18px;
      font-weight: 700;
      color: var(--primary, #2563EB);
    }
    .logout-user-avatar .online-dot {
      position: absolute;
      bottom: 0;
      right: 0;
      width: 12px;
      height: 12px;
      border-radius: 50%;
      background: var(--success, #15803D);
      border: 2px solid var(--surface, #FFFFFF);
    }
    .logout-user-info {
      flex: 1;
      min-width: 0;
    }
    .logout-user-name {
      font-size: 15px;
      font-weight: 700;
      color: var(--text, #0F172A);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    .logout-user-email {
      font-size: 12px;
      color: var(--text-muted, #64748B);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      margin-top: 1px;
    }
    .logout-user-meta {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-top: 5px;
    }
    .logout-points-list {
      background-color: rgba(13, 148, 136, 0.05);
      border: 1px solid rgba(13, 148, 136, 0.18);
      border-radius: 10px;
      padding: 12px 14px;
      margin-bottom: 22px;
      text-align: left;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }
    .logout-point-item {
      display: flex;
      align-items: flex-start;
      gap: 10px;
      font-size: 12px;
      color: var(--text-muted, #64748B);
      line-height: 1.45;
    }
    .logout-point-item svg {
      flex-shrink: 0;
      margin-top: 2px;
      color: var(--success, #15803D);
    }
    .logout-actions-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
    }
    @media (max-width: 480px) {
      .logout-actions-grid {
        grid-template-columns: 1fr;
      }
    }
    .logout-btn-cancel {
      height: 44px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-weight: 600;
      font-size: 14px;
      text-decoration: none;
      border-radius: 8px;
      border: 1px solid var(--border, #E2E8F0);
      background: var(--surface, #FFFFFF);
      color: var(--text, #0F172A);
      transition: all 0.15s ease;
      cursor: pointer;
    }
    .logout-btn-cancel:hover {
      background: var(--surface-hover, #EAF0F8);
      border-color: var(--border-focus, #2563EB);
      color: var(--text, #0F172A);
    }
    .logout-btn-confirm {
      height: 44px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      font-weight: 600;
      font-size: 14px;
      border-radius: 8px;
      background: #EF4444;
      color: #FFFFFF;
      border: 1px solid #DC2626;
      cursor: pointer;
      transition: all 0.15s ease;
      box-shadow: 0 1px 2px rgba(239, 68, 68, 0.2);
    }
    .logout-btn-confirm:hover {
      background: #DC2626;
      border-color: #B91C1C;
      box-shadow: 0 4px 12px rgba(239, 68, 68, 0.25);
      transform: translateY(-1px);
    }
    .logout-card-footer {
      margin-top: 20px;
      padding-top: 14px;
      border-top: 1px solid var(--border, #E2E8F0);
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 12px;
      color: var(--text-muted, #64748B);
    }
  </style>
</head>
<body class="public-site">
  <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

  <main id="main-content" class="logout-wrapper">
    <div class="logout-card-container" style="max-width: 500px; width: 100%; margin: 0 auto;">
      <div class="logout-single-card" style="background-color: var(--surface, #FFFFFF); border: 1px solid var(--border, #E2E8F0); border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.08), 0 8px 10px -6px rgba(0, 0, 0, 0.04); overflow: hidden; position: relative; padding: 36px 32px 28px; text-align: center;">
        <!-- Top Accent Line -->
        <div class="logout-top-accent" style="height: 4px; width: 100%; background: linear-gradient(90deg, #f59e0b 0%, #ef4444 50%, var(--primary, #2563EB) 100%); position: absolute; top: 0; left: 0;"></div>

        <!-- Brand Mascot Emblem with Security Alert Badge -->
        <div class="logout-mascot-emblem" style="position: relative; width: 80px; height: 80px; margin: 0 auto 16px; display: flex; align-items: center; justify-content: center;">
          <div class="logout-mascot-circle" style="width: 76px; height: 76px; border-radius: 50%; background: var(--surface, #FFFFFF); border: 2px solid var(--border, #E2E8F0); box-shadow: 0 1px 2px rgba(0,0,0,0.05); display: flex; align-items: center; justify-content: center; overflow: hidden; padding: 6px;">
            <img src="${pageContext.request.contextPath}/assets/images/logo/mascot_owl_icon.png" alt="EduCenter Security Dr. Owl" style="width: 100%; height: 100%; max-width: 64px; max-height: 64px; object-fit: contain; display: block;">
          </div>
          <div class="logout-badge-alert" title="Yêu cầu kết thúc phiên" style="position: absolute; bottom: -2px; right: -2px; width: 26px; height: 26px; border-radius: 50%; background: #EF4444; color: #FFFFFF; border: 2px solid var(--surface, #FFFFFF); display: flex; align-items: center; justify-content: center;">
            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px; stroke-width: 2.5;"><path d="M18.36 6.64a9 9 0 1 1-12.73 0"/><line x1="12" y1="2" x2="12" y2="12"/></svg>
          </div>
        </div>

        <!-- Header Titles & Badges -->
        <div style="margin-bottom: 8px;">
          <span style="display: inline-flex; align-items: center; gap: 6px; padding: 3px 10px; border-radius: 9999px; font-size: 11px; font-weight: 600; background: rgba(239, 68, 68, 0.08); color: #DC2626; border: 1px solid rgba(239, 68, 68, 0.2);">
            <span style="width: 6px; height: 6px; border-radius: 50%; background-color: #EF4444;"></span>
            Cổng bảo mật tác nghiệp · TLS 1.3
          </span>
        </div>
        <h1 style="font-size: 21px; font-weight: 700; color: var(--text, #0F172A); margin: 0 0 8px; letter-spacing: -0.02em;">Xác nhận kết thúc phiên làm việc</h1>
        <p style="font-size: 13px; color: var(--text-muted, #64748B); line-height: 1.5; margin: 0 auto 20px; max-width: 420px;">
          Bạn đang yêu cầu đăng xuất khỏi tài khoản trên hệ thống EduCenter. Vui lòng kiểm tra lại thông tin phiên trước khi xác nhận.
        </p>

        <!-- User Session Identity Box -->
        <div class="logout-user-box" style="background-color: var(--surface-muted, #F1F5F9); border: 1px solid var(--border, #E2E8F0); border-radius: 12px; padding: 14px 16px; margin: 20px 0; display: flex; align-items: center; gap: 14px; text-align: left;">
          <div class="logout-user-avatar" style="position: relative; width: 48px; height: 48px; min-width: 48px; max-width: 48px; min-height: 48px; max-height: 48px; border-radius: 50%; background: var(--primary-subtle, #EFF6FF); border: 2px solid var(--border, #E2E8F0); display: flex; align-items: center; justify-content: center; flex-shrink: 0; overflow: hidden;">
            <c:choose>
              <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
                <img src="<c:url value='${sessionScope.currentUser.avatarUrl}'/>" alt="" style="width: 48px; height: 48px; min-width: 48px; max-width: 48px; min-height: 48px; max-height: 48px; border-radius: 50%; object-fit: cover; display: block;" onerror="this.style.display='none'; this.nextElementSibling.style.display='inline';">
                <span class="avatar-initial" style="display: none; font-size: 18px; font-weight: 700; color: var(--primary, #2563EB);"><c:out value="${sessionScope.currentUser.fullName.substring(0,1).toUpperCase()}"/></span>
              </c:when>
              <c:otherwise>
                <span class="avatar-initial" style="font-size: 18px; font-weight: 700; color: var(--primary, #2563EB);"><c:out value="${sessionScope.currentUser.fullName != null && !sessionScope.currentUser.fullName.isEmpty() ? sessionScope.currentUser.fullName.substring(0,1).toUpperCase() : 'U'}"/></span>
              </c:otherwise>
            </c:choose>
            <span class="online-dot" title="Tài khoản đang hoạt động" style="position: absolute; bottom: 0; right: 0; width: 12px; height: 12px; border-radius: 50%; background: #15803D; border: 2px solid var(--surface, #FFFFFF);"></span>
          </div>

          <div class="logout-user-info" style="flex: 1; min-width: 0;">
            <div class="logout-user-name" style="font-size: 15px; font-weight: 700; color: var(--text, #0F172A); white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><c:out value="${sessionScope.currentUser.fullName}"/></div>
            <div class="logout-user-email" style="font-size: 12px; color: var(--text-muted, #64748B); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 1px;"><c:out value="${sessionScope.currentUser.email}"/></div>
            <div class="logout-user-meta" style="display: flex; align-items: center; gap: 8px; margin-top: 5px;">
              <span class="badge badge-admin" style="font-size: 10px; padding: 2px 7px; border-radius: 4px; font-weight: 600;">
                <c:out value="${sessionScope.currentUser.primaryRole}"/>
              </span>
              <span class="font-code-num text-muted" style="font-size: 11px;">#UID-<c:out value="${sessionScope.currentUser.userId != null ? sessionScope.currentUser.userId : sessionScope.currentUser.id}"/></span>
            </div>
          </div>
        </div>

        <!-- Reassurance Checklist (Security & State) -->
        <div class="logout-points-list" style="background-color: rgba(13, 148, 136, 0.05); border: 1px solid rgba(13, 148, 136, 0.18); border-radius: 10px; padding: 12px 14px; margin-bottom: 22px; text-align: left; display: flex; flex-direction: column; gap: 8px;">
          <div class="logout-point-item" style="display: flex; align-items: flex-start; gap: 10px; font-size: 12px; color: var(--text-muted, #64748B); line-height: 1.45;">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px; color: #15803D; flex-shrink: 0; margin-top: 1px;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
            <span><strong style="color: var(--text, #0F172A);">Dữ liệu an toàn:</strong> Mọi thao tác, điểm số và dữ liệu đã lưu trữ thành công trên CSDL trung tâm.</span>
          </div>
          <div class="logout-point-item" style="display: flex; align-items: flex-start; gap: 10px; font-size: 12px; color: var(--text-muted, #64748B); line-height: 1.45;">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px; color: var(--primary, #2563EB); flex-shrink: 0; margin-top: 1px;"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            <span><strong style="color: var(--text, #0F172A);">Bảo mật phiên:</strong> Khóa cookie xác thực và giải phóng phiên làm việc khỏi trình duyệt này.</span>
          </div>
        </div>

        <!-- Dual Action CTA Buttons -->
        <form action="${pageContext.request.contextPath}/logout" method="post" style="margin: 0;">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
          <div class="logout-actions-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
            <a href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}" class="btn btn-secondary logout-btn-cancel" style="height: 44px; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600; font-size: 14px; text-decoration: none; border-radius: 8px; border: 1px solid var(--border, #E2E8F0); background: var(--surface, #FFFFFF); color: var(--text, #0F172A);">
              <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px;"><path d="m15 18-6-6 6-6"/></svg>
              <span>Ở lại phiên làm việc</span>
            </a>
            <button type="submit" class="logout-btn-confirm" style="height: 44px; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600; font-size: 14px; border-radius: 8px; background: #EF4444; color: #FFFFFF; border: 1px solid #DC2626; cursor: pointer;">
              <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px;"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
              <span>Xác nhận đăng xuất</span>
            </button>
          </div>
        </form>

        <!-- Card Bottom Reassurance -->
        <div class="logout-card-footer" style="margin-top: 20px; padding-top: 14px; border-top: 1px solid var(--border, #E2E8F0); display: flex; align-items: center; justify-content: space-between; font-size: 12px; color: var(--text-muted, #64748B);">
          <div style="display: flex; align-items: center; gap: 6px;">
            <span style="width: 7px; height: 7px; border-radius: 50%; background: #15803D;"></span>
            <span>EduCenter Cloud (HN-01)</span>
          </div>
          <a href="${pageContext.request.contextPath}/login" style="color: var(--primary, #2563EB); text-decoration: none; font-weight: 500;">
            Đổi tài khoản khác &rarr;
          </a>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
