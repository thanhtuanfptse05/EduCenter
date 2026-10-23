<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head><%@ include file="/WEB-INF/views/common/head.jspf" %></head>
<body class="public-site">
<%@ include file="/WEB-INF/views/common/public-header.jspf" %>
<main id="main-content" class="screen-wrap auth-screen">
    <section class="screen-card screen-stack">
        <div class="screen-heading"><span class="screen-eyebrow">Phiên làm việc</span><h1>Xác nhận đăng xuất</h1></div>
        <p>Bạn muốn kết thúc phiên làm việc của <strong><c:out value="${sessionScope.currentUser.fullName}"/></strong>?</p>
        <form action="${pageContext.request.contextPath}/logout" method="post" class="screen-actions">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
            <a href="${pageContext.request.contextPath}${sessionScope.currentUser.defaultDashboardUrl}" class="btn btn-secondary">Hủy bỏ</a>
            <button type="submit" class="btn btn-danger">Đăng xuất</button>
        </form>
    </section>
</main>
<%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
