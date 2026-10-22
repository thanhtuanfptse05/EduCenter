<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty flash_success or not empty requestScope.successMessage}">
    <div class="alert alert-success" role="alert">
        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
            <polyline points="22 4 12 14.01 9 11.01"></polyline>
        </svg>
        <div><c:out value="${not empty flash_success ? flash_success : requestScope.successMessage}" /></div>
    </div>
</c:if>

<c:if test="${not empty flash_error or not empty requestScope.errorMessage}">
    <div class="alert alert-danger" role="alert">
        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <div><c:out value="${not empty flash_error ? flash_error : requestScope.errorMessage}" /></div>
    </div>
</c:if>

<c:if test="${not empty flash_warning}">
    <div class="alert alert-warning" role="alert">
        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
            <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path>
            <line x1="12" y1="9" x2="12" y2="13"></line>
            <line x1="12" y1="17" x2="12.01" y2="17"></line>
        </svg>
        <div><c:out value="${flash_warning}" /></div>
    </div>
</c:if>

<c:if test="${not empty flash_info or not empty sessionScope.reset_link or not empty sessionScope.demo_reset_link}">
    <div class="alert alert-info" role="alert">
        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="16" x2="12" y2="12"></line>
            <line x1="12" y1="8" x2="12.01" y2="8"></line>
        </svg>
        <div>
            <c:if test="${not empty flash_info}"><p><c:out value="${flash_info}" /></p></c:if>
            <c:set var="activeResetLink" value="${not empty sessionScope.reset_link ? sessionScope.reset_link : sessionScope.demo_reset_link}" />
            <c:if test="${not empty activeResetLink}">
                <p style="margin-top: 6px;">
                    <a href="${activeResetLink}" style="font-weight: 600; text-decoration: underline;">
                        Bấm vào đây để mở liên kết đặt lại mật khẩu của bạn &rarr;
                    </a>
                </p>
                <c:remove var="reset_link" scope="session" />
                <c:remove var="demo_reset_link" scope="session" />
            </c:if>
        </div>
    </div>
</c:if>
