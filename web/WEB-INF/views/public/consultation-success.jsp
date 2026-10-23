<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><%@ include file="/WEB-INF/views/common/head.jspf" %></head>
<body class="public-site"><c:set var="activeNav" value="courses" scope="request"/><%@ include file="/WEB-INF/views/common/public-header.jspf" %>
<main id="main-content" class="screen-wrap"><%@ include file="/WEB-INF/views/common/alert.jsp" %>
<div class="screen-heading"><span class="screen-eyebrow">Đã tiếp nhận yêu cầu</span><h1>Đăng ký tư vấn thành công</h1><p>Yêu cầu của bạn đã được lưu. Giữ mã hồ sơ dưới đây để thuận tiện khi liên hệ với trung tâm.</p></div>
<section class="screen-card screen-stack" id="printReceiptArea"><h2>Phiếu tiếp nhận đăng ký</h2><p class="screen-receipt-code"><c:out value="${receipt.code}"/></p>
<div class="screen-row"><span>Người đăng ký</span><strong><c:out value="${receipt.fullName}"/></strong></div><div class="screen-row"><span>Số điện thoại</span><c:out value="${receipt.phone}"/></div><div class="screen-row"><span>Khối lớp</span><span>Lớp <c:out value="${receipt.gradeLevel}"/></span></div><div class="screen-row"><span>Thời điểm tiếp nhận</span><c:out value="${receipt.formattedSubmittedAt}"/></div>
<p class="screen-muted">Đây là xác nhận tiếp nhận nhu cầu tư vấn, chưa phải xác nhận ghi danh hay thanh toán.</p><div class="screen-actions"><a class="btn btn-primary" href="${pageContext.request.contextPath}/courses">Khám phá khóa học</a><a class="btn btn-secondary" href="${pageContext.request.contextPath}/">Về trang chủ</a><button class="btn btn-secondary" type="button" onclick="window.print()">In phiếu tiếp nhận</button></div></section>
</main><%@ include file="/WEB-INF/views/common/public-footer.jspf" %></body></html>
