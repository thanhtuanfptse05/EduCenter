<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html><html lang="vi"><head><%@ include file="/WEB-INF/views/common/head.jspf" %></head>
<body class="public-site"><c:set var="activeNav" value="courses" scope="request"/><%@ include file="/WEB-INF/views/common/public-header.jspf" %>
<main id="main-content" class="screen-wrap"><%@ include file="/WEB-INF/views/common/alert.jsp" %>
<div class="screen-heading"><span class="screen-eyebrow">Chương trình đang tuyển sinh</span><h1>Tìm khóa học phù hợp với bạn</h1><p>Chọn môn học, khối lớp và học phí để khám phá các chương trình hiện có tại EduCenter.</p></div>
<form class="screen-card screen-filters" action="${pageContext.request.contextPath}/courses" method="get">
 <label class="screen-field">Tìm kiếm<input name="keyword" type="search" maxlength="200" placeholder="Tên, mã khóa học hoặc mục tiêu kỳ thi" value="<c:out value='${filter.keyword}'/>"/></label>
 <label class="screen-field">Môn học<select name="subjectId"><option value="">Tất cả môn</option><c:forEach var="sub" items="${subjects}"><option value="${sub.id}" ${filter.subjectId == sub.id ? 'selected' : ''}><c:out value="${sub.name}"/></option></c:forEach></select></label>
 <label class="screen-field">Khối lớp<select name="gradeLevel"><option value="">Tất cả khối</option><c:forEach var="grade" items="${availableGrades}"><option value="${grade}" ${filter.gradeLevel == grade ? 'selected' : ''}>Lớp <c:out value="${grade}"/></option></c:forEach></select></label>
 <label class="screen-field">Học phí<select name="fee_range"><option value="all">Tất cả mức phí</option><option value="under_2m" ${filter.feeRange == 'under_2m' ? 'selected' : ''}>Đến 2.000.000 đ</option><option value="2m_3m5" ${filter.feeRange == '2m_3m5' ? 'selected' : ''}>2.000.000–3.500.000 đ</option><option value="over_3m5" ${filter.feeRange == 'over_3m5' ? 'selected' : ''}>Từ 3.500.000 đ</option></select></label>
 <label class="screen-field">Sắp xếp<select name="sort"><option value="newest" ${filter.sort == 'newest' ? 'selected' : ''}>Mới nhất</option><option value="fee_asc" ${filter.sort == 'fee_asc' ? 'selected' : ''}>Học phí tăng dần</option><option value="fee_desc" ${filter.sort == 'fee_desc' ? 'selected' : ''}>Học phí giảm dần</option><option value="name_asc" ${filter.sort == 'name_asc' ? 'selected' : ''}>Tên A–Z</option></select></label>
 <div class="screen-actions screen-span"><button class="btn btn-primary" type="submit">Tìm khóa học</button><a class="btn btn-secondary" href="${pageContext.request.contextPath}/courses">Đặt lại bộ lọc</a><span class="screen-muted"><c:out value="${coursePage.totalRecords}"/> khóa học phù hợp</span></div>
</form>
<c:choose><c:when test="${empty coursePage.items}"><div class="screen-card screen-empty"><h2>Chưa tìm thấy khóa học phù hợp</h2><p>Thử thay đổi môn học, khối lớp hoặc khoảng học phí. Danh mục sẽ cập nhật khi có chương trình tuyển sinh mới.</p><a class="btn btn-secondary" href="${pageContext.request.contextPath}/courses">Xem tất cả khóa học</a></div></c:when><c:otherwise>
<div class="screen-course-grid"><c:forEach var="course" items="${coursePage.items}"><article class="screen-card screen-course">
 <c:if test="${not empty course.imageUrl}"><img class="screen-course-image" loading="lazy" src="<c:url value='${course.imageUrl}'/>" alt="<c:out value='${course.name}'/>"/></c:if>
 <div class="screen-course-body"><span class="screen-muted"><c:out value="${course.subjectName}"/> · Lớp <c:out value="${course.gradeLevel}"/></span><h2><a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}"><c:out value="${course.name}"/></a></h2>
 <p class="screen-muted"><c:out value="${course.description}"/></p><span class="screen-muted"><c:out value="${course.totalSessions}"/> buổi · <c:out value="${course.durationWeeks}"/> tuần</span>
 <div class="screen-price"><c:out value="${course.formattedFee}"/></div>
 <div class="screen-actions"><a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/courses/detail?id=${course.id}">Chi tiết</a><c:if test="${course.openForRegistration}"><form action="${pageContext.request.contextPath}/registration-cart/add" method="post"><input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/><input type="hidden" name="courseId" value="${course.id}"/><button class="btn btn-primary btn-sm" type="submit">Thêm vào danh sách</button></form></c:if></div>
 </div></article></c:forEach></div>
<c:if test="${coursePage.totalPages > 1}"><nav class="screen-pagination" aria-label="Phân trang khóa học"><c:forEach var="p" begin="${coursePage.currentPage > 3 ? coursePage.currentPage - 3 : 1}" end="${coursePage.currentPage + 3 < coursePage.totalPages ? coursePage.currentPage + 3 : coursePage.totalPages}">
<c:url var="pageUrl" value="/courses"><c:param name="page" value="${p}"/><c:param name="keyword" value="${filter.keyword}"/><c:param name="subjectId" value="${filter.subjectId}"/><c:param name="gradeLevel" value="${filter.gradeLevel}"/><c:param name="fee_range" value="${filter.feeRange}"/><c:param name="sort" value="${filter.sort}"/></c:url>
<a href="<c:out value='${pageUrl}'/>" aria-current="${p == coursePage.currentPage ? 'page' : 'false'}"><c:out value="${p}"/></a></c:forEach></nav></c:if>
</c:otherwise></c:choose>
</main><%@ include file="/WEB-INF/views/common/public-footer.jspf" %></body></html>
