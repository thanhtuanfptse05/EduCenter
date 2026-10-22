<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Flash & Request Success Alert --%>
<c:if test="${not empty flash_success or not empty requestScope.successMessage}">
    <div class="alert alert-toast alert-success" role="alert">
        <div class="alert-icon-wrapper">
            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                <circle cx="12" cy="12" r="10"></circle>
                <path d="m9 12 2 2 4-4"></path>
            </svg>
        </div>
        <div class="alert-content">
            <div class="alert-title">Thao tác thành công</div>
            <div class="alert-message"><c:out value="${not empty flash_success ? flash_success : requestScope.successMessage}" /></div>
        </div>
        <button type="button" class="alert-close-btn" aria-label="Đóng thông báo" title="Đóng">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>
    <c:remove var="flash_success" scope="session" />
</c:if>

<%-- Flash & Request Error Alert --%>
<c:if test="${not empty flash_error or not empty requestScope.errorMessage}">
    <div class="alert alert-toast alert-danger" role="alert">
        <div class="alert-icon-wrapper">
            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div class="alert-content">
            <div class="alert-title">Đã xảy ra lỗi</div>
            <div class="alert-message"><c:out value="${not empty flash_error ? flash_error : requestScope.errorMessage}" /></div>
        </div>
        <button type="button" class="alert-close-btn" aria-label="Đóng thông báo" title="Đóng">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>
    <c:remove var="flash_error" scope="session" />
</c:if>

<%-- Flash Warning Alert --%>
<c:if test="${not empty flash_warning}">
    <div class="alert alert-toast alert-warning" role="alert">
        <div class="alert-icon-wrapper">
            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path>
                <line x1="12" y1="9" x2="12" y2="13"></line>
                <line x1="12" y1="17" x2="12.01" y2="17"></line>
            </svg>
        </div>
        <div class="alert-content">
            <div class="alert-title">Lưu ý hệ thống</div>
            <div class="alert-message"><c:out value="${flash_warning}" /></div>
        </div>
        <button type="button" class="alert-close-btn" aria-label="Đóng thông báo" title="Đóng">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>
    <c:remove var="flash_warning" scope="session" />
</c:if>

<%-- Flash Info & Reset Link Alert --%>
<c:if test="${not empty flash_info or not empty sessionScope.reset_link or not empty sessionScope.demo_reset_link}">
    <div class="alert alert-toast alert-info" role="alert">
        <div class="alert-icon-wrapper">
            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="16" x2="12" y2="12"></line>
                <line x1="12" y1="8" x2="12.01" y2="8"></line>
            </svg>
        </div>
        <div class="alert-content">
            <div class="alert-title">Thông báo</div>
            <c:if test="${not empty flash_info}">
                <div class="alert-message"><c:out value="${flash_info}" /></div>
            </c:if>
            <c:set var="activeResetLink" value="${not empty sessionScope.reset_link ? sessionScope.reset_link : sessionScope.demo_reset_link}" />
            <c:if test="${not empty activeResetLink}">
                <div style="margin-top: 8px;">
                    <a href="${activeResetLink}" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px; text-decoration: none;">
                        <span>Mở liên kết đặt lại mật khẩu của bạn</span>
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                            <polyline points="12 5 19 12 12 19"></polyline>
                        </svg>
                    </a>
                </div>
                <c:remove var="reset_link" scope="session" />
                <c:remove var="demo_reset_link" scope="session" />
            </c:if>
        </div>
        <button type="button" class="alert-close-btn" aria-label="Đóng thông báo" title="Đóng">
            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        </button>
    </div>
    <c:remove var="flash_info" scope="session" />
</c:if>
