<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
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
                    <polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"></polygon>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
            </div>

            <h1 style="font-size: 26px; font-weight: 700; color: #0f172a; margin: 0 0 10px 0; letter-spacing: -0.02em;">500 — Lỗi hệ thống máy chủ</h1>
            <p style="font-size: 15px; color: #64748b; line-height: 1.6; margin: 0 0 28px 0;">
                Hệ thống đang gặp sự cố gián đoạn tạm thời. Đội ngũ kỹ thuật đã được thông báo để khắc phục sớm nhất.
            </p>

            <c:if test="${not empty pageContext.exception}">
                <div style="text-align: left; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 12px; margin-bottom: 24px; font-family: monospace; font-size: 12px; color: #dc2626; word-break: break-all; max-height: 120px; overflow-y: auto;">
                    <strong>Chi tiết lỗi:</strong> <c:out value="${pageContext.exception.message}" />
                </div>
            </c:if>

            <div style="display: flex; justify-content: center; gap: 12px;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px; background: #2563eb; color: #ffffff; text-decoration: none; font-weight: 600; font-size: 14px; padding: 10px 24px; border-radius: 8px; box-shadow: 0 1px 3px rgba(37,99,235,0.3);">
                    <svg class="icon icon-sm" style="width: 18px; height: 18px;" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                    </svg>
                    <span>Về trang chủ</span>
                </a>
            </div>
        </div>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
