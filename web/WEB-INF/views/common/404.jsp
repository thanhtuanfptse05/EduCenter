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
        <div class="auth-card" style="text-align: center; max-width: 480px;">
            <div style="display: inline-flex; align-items: center; justify-content: center; width: 64px; height: 64px; border-radius: 50%; background-color: var(--warning-subtle); color: var(--warning); margin-bottom: 20px;">
                <svg class="icon icon-lg" style="width: 32px; height: 32px;" viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
            </div>

            <h1 style="font-size: var(--font-size-2xl); font-weight: 700; margin-bottom: 8px;">404 — Không tìm thấy trang</h1>
            <p class="text-muted" style="margin-bottom: 24px;">
                Trang hoặc tài nguyên bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển sang địa chỉ mới.
            </p>

            <div style="display: flex; justify-content: center; gap: 12px;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Về trang chủ EduCenter</span>
                </a>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
