<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="auth-container" style="min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 24px; background: linear-gradient(135deg, #f8fafc 0%, #edf2f7 100%);">
        <div class="auth-card" style="text-align: center; max-width: 520px; width: 100%; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px; padding: 48px 36px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.03);">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 72px; height: 72px; border-radius: 50%; background-color: #fee2e2; color: #dc2626; margin-bottom: 24px;">
                <svg class="icon icon-lg" style="width: 36px; height: 36px;" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
            </div>

            <h1 style="font-size: 26px; font-weight: 700; color: #0f172a; margin: 0 0 10px 0; letter-spacing: -0.02em;">403 — Từ chối truy cập</h1>
            <p style="font-size: 15px; color: #64748b; line-height: 1.6; margin: 0 0 24px 0;">
                Bạn không có quyền truy cập vào chức năng hoặc đường dẫn này. Vui lòng kiểm tra lại vai trò tài khoản hoặc liên hệ Quản trị viên trung tâm.
            </p>

            <c:if test="${not empty forbiddenPath}">
                <div style="padding: 10px 14px; background: var(--surface-muted); border: 1px solid var(--border); border-radius: var(--radius-md); font-family: monospace; font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 24px;">
                    Đường dẫn yêu cầu: <code><c:out value="${forbiddenPath}" /></code>
                </div>
            </c:if>

            <div style="display: flex; justify-content: center; gap: 12px;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                    <svg class="icon icon-sm" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Về trang chủ</span>
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <a href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}" class="btn btn-primary">
                            <span>Về Bảng điều khiển</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                            <span>Đăng nhập lại</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
