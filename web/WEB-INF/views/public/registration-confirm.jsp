<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><%@ include file="/WEB-INF/views/common/head.jspf" %></head>
<body class="public-site"><c:set var="activeNav" value="courses" scope="request"/><%@ include file="/WEB-INF/views/common/public-header.jspf" %>
<main id="main-content" class="screen-wrap"><%@ include file="/WEB-INF/views/common/alert.jsp" %>
<nav class="screen-steps" aria-label="Các bước đăng ký"><a href="${pageContext.request.contextPath}/registration-cart">1. Chọn khóa học</a><span>→</span><strong>2. Xác nhận thông tin</strong><span>→</span><span>3. Tiếp nhận yêu cầu</span></nav><div class="screen-heading"><h1>Xác nhận nhu cầu đăng ký</h1><p>Thông tin này giúp trung tâm liên hệ và tư vấn chương trình phù hợp cho bạn.</p></div>
<div class="screen-columns"><section class="screen-card"><h2>Thông tin liên hệ</h2>
<form class="screen-fields" action="${pageContext.request.contextPath}/registration/confirm" method="post">
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/><input type="hidden" name="submissionToken" value="<c:out value='${form.submissionToken}'/>"/>
<label class="screen-field">Họ và tên *<input name="fullName" required minlength="2" maxlength="150" autocomplete="name" value="<c:out value='${form.fullName}'/>"/></label>
<label class="screen-field">Số điện thoại *<input name="phoneNumber" type="tel" required maxlength="20" autocomplete="tel" value="<c:out value='${form.phoneNumber}'/>"/></label>
<label class="screen-field">Email<input name="email" type="email" maxlength="255" autocomplete="email" value="<c:out value='${form.email}'/>"/></label>
<label class="screen-field">Khối lớp hiện tại *<select name="gradeLevel" required><option value="">Chọn khối lớp</option><c:forEach var="grade" items="${availableGrades}"><option value="${grade}" ${form.gradeLevel == grade ? 'selected' : ''}>Lớp <c:out value="${grade}"/></option></c:forEach></select></label>
<label class="screen-field screen-span">Trường đang theo học<input name="schoolName" maxlength="200" value="<c:out value='${form.schoolName}'/>"/></label>
<label class="screen-field screen-span">Mục tiêu học tập / Kỳ thi quan tâm<input name="targetGoals" maxlength="150" value="<c:out value='${empty form.targetGoals ? "" : form.targetGoals[0]}'/>"/></label>
<label class="screen-field screen-span">Nguyện vọng / Khung giờ thuận tiện<textarea name="notes" maxlength="2000" rows="4"><c:out value="${form.notes}"/></textarea></label>
<label class="screen-check screen-span"><input type="checkbox" name="consentCheck" value="true" required ${form.consentChecked ? 'checked' : ''}/>Tôi đồng ý để EduCenter liên hệ tư vấn về yêu cầu đăng ký này.</label>
<div class="screen-actions screen-span"><a class="btn btn-secondary" href="${pageContext.request.contextPath}/registration-cart">Quay lại danh sách</a><button class="btn btn-primary" type="submit" ${cart.checkoutReady ? '' : 'disabled'}>Gửi yêu cầu đăng ký</button></div>
<c:if test="${not cart.checkoutReady}"><p class="screen-warning screen-span">Có khóa học không còn nhận đăng ký. Vui lòng kiểm tra lại danh sách.</p></c:if>
</form></section><aside class="screen-card screen-stack"><h2>Khóa học đã chọn</h2><c:forEach var="item" items="${cart.items}"><div class="screen-row"><div><strong><c:out value="${item.courseName}"/></strong><p class="screen-muted"><c:out value="${item.courseCode}"/></p><p class="screen-muted"><c:out value="${item.notes}"/></p></div><c:choose><c:when test="${item.available}"><span><c:out value="${item.formattedFee}"/></span></c:when><c:otherwise><span class="screen-warning">Không còn nhận đăng ký</span></c:otherwise></c:choose></div></c:forEach><div><span class="screen-muted">Tổng học phí các khóa đang mở</span><p class="screen-price"><c:out value="${cart.formattedTotalFee}"/></p></div><p class="screen-muted">Trung tâm tiếp nhận nhu cầu trước khi xác nhận lịch học và xếp lớp.</p></aside></div>
</main><%@ include file="/WEB-INF/views/common/public-footer.jspf" %></body></html>
