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
        <div class="auth-card" style="text-align: center; max-width: 440px;">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 56px; height: 56px; border-radius: 50%; background-color: var(--primary-subtle); color: var(--primary); margin-bottom: 16px;">
                <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                    <polyline points="16 17 21 12 16 7"></polyline>
                    <line x1="21" y1="12" x2="9" y2="12"></line>
                </svg>
            </div>

            <h1 class="auth-card-title">Xác nhận đăng xuất</h1>
            <p class="auth-card-description" style="margin-top: 8px; margin-bottom: 24px;">
                Bạn có chắc chắn muốn kết thúc phiên làm việc của tài khoản <strong><c:out value="${sessionScope.currentUser.fullName}" /></strong> không?
            </p>

            <form action="${pageContext.request.contextPath}/logout" method="post">
                <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">

                <div style="display: flex; gap: 12px; justify-content: center;">
                    <a href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}" class="btn btn-secondary">
                        <span>Hủy bỏ</span>
                    </a>
                    <button type="submit" class="btn btn-danger">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                            <polyline points="16 17 21 12 16 7"></polyline>
                            <line x1="21" y1="12" x2="9" y2="12"></line>
                        </svg>
                        <span>Đăng xuất ngay</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
