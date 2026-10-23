<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="403 - Không Có Quyền Truy Cập | EduCenter" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="public-site error-shell">
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <main id="main-content" class="error-main">
        <div class="error-container">
            <div class="error-card">
                <!-- Subtle Ambient Backdrop Accent -->
                <div class="error-ambient-accent" aria-hidden="true"></div>

                <!-- Error Status Badge -->
                <div class="error-status-badge">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--danger);">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span>Mã lỗi HTTP 403 • Truy cập bị từ chối</span>
                </div>

                <!-- Massive Crisp Numeric Display with Lock Badge -->
                <div class="error-massive-num-wrap">
                    <span class="error-massive-num">403</span>
                    <div class="error-icon-overlay">
                        <div class="error-lock-badge">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Authoritative Heading -->
                <h1 class="error-heading">Bạn không có quyền truy cập trang này</h1>

                <!-- Contextual Description -->
                <p class="error-desc">
                    Tài khoản của bạn hiện không được cấp quyền xem nội dung này. Vui lòng quay lại khu vực làm việc phù hợp với vai trò của bạn hoặc liên hệ quản trị viên nếu bạn cho rằng đây là sự nhầm lẫn về phân quyền.
                </p>

                <!-- Role-Based Context Hint Card -->
                <div class="error-hint-card">
                    <div class="error-hint-row">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary); margin-top: 2px;">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            <polyline points="9 12 11 14 15 10"></polyline>
                        </svg>
                        <div>
                            <span class="error-hint-title">Trạng thái tài khoản</span>
                            <c:choose>
                                <c:when test="${not empty sessionScope.currentUser}">
                                    <span class="error-hint-sub">
                                        Đang đăng nhập: <strong><c:out value="${sessionScope.currentUser.fullName}" /></strong> 
                                        (Vai trò: <strong><c:out value="${sessionScope.currentUser.primaryRole}" /></strong>) • Quyền hạn hiện tại được kiểm soát bởi cơ chế phân quyền vai trò (RBAC).
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="error-hint-sub">
                                        Chưa đăng nhập • Quyền hạn hiện tại bị giới hạn cho khách vãng lai. Vui lòng đăng nhập với tài khoản có thẩm quyền.
                                    </span>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty forbiddenPath}">
                                <div style="font-family: monospace; font-size: 11px; color: var(--danger); margin-top: 4px; word-break: break-all;">
                                    Đường dẫn bị hạn chế: <code><c:out value="${forbiddenPath}" /></code>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <div class="error-hint-divider"></div>

                    <div class="error-hint-row">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted); margin-top: 2px;">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="16" x2="12" y2="12"></line>
                            <line x1="12" y1="8" x2="12.01" y2="8"></line>
                        </svg>
                        <div>
                            <span class="error-hint-title">Gợi ý điều hướng</span>
                            <span class="error-hint-sub">
                                Trở về trang tài khoản để sử dụng các chức năng thuộc quyền được cấp.
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="error-actions">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                </svg>
                                <span>Về trang của tôi</span>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/login">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                                    <polyline points="10 17 15 12 10 7"></polyline>
                                    <line x1="15" y1="12" x2="3" y2="12"></line>
                                </svg>
                                <span>Đăng nhập ngay</span>
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <button class="btn btn-secondary" onclick="window.history.length > 1 ? window.history.back() : window.location.href='${pageContext.request.contextPath}/';" type="button">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Quay lại</span>
                    </button>
                </div>

                <!-- Technical Support Direct Link -->
                <div class="error-support-footer">
                    <span>Bạn cần nâng cấp quyền hạn? Liên hệ quản trị viên:</span>
                    <c:if test="${not empty contactEmail}"><span><c:out value="${contactEmail}"/></span></c:if>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
