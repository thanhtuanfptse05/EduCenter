<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="public-site">
  <c:set var="activeNav" value="courses" scope="request"/>
  <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

  <main id="main-content" class="screen-wrap">
    <%@ include file="/WEB-INF/views/common/alert.jsp" %>

    <div class="screen-heading">
      <span class="screen-eyebrow">Chương trình đào tạo & Bổ trợ</span>
      <h1>Khám phá các khóa học chất lượng cao</h1>
      <p>Tìm kiếm môn học, khối lớp và học phí để chọn chương trình ôn thi, bồi dưỡng kiến thức phù hợp nhất cùng đội ngũ giảng viên giàu kinh nghiệm tại EduCenter.</p>
    </div>

    <!-- Filter Bar -->
    <form class="screen-card screen-filters" action="${pageContext.request.contextPath}/courses" method="get">
      <label class="screen-field">
        Tìm kiếm
        <input name="keyword" type="search" maxlength="200" placeholder="Tên môn, mã khóa hoặc mục tiêu thi..." value="<c:out value='${filter.keyword}'/>"/>
      </label>

      <label class="screen-field">
        Môn học
        <select name="subjectId">
          <option value="">Tất cả môn học</option>
          <c:forEach var="sub" items="${subjects}">
            <option value="${sub.id}" ${filter.subjectId == sub.id ? 'selected' : ''}>
              <c:out value="${sub.name}"/>
            </option>
          </c:forEach>
        </select>
      </label>

      <label class="screen-field">
        Khối lớp
        <select name="gradeLevel">
          <option value="">Tất cả khối lớp</option>
          <c:forEach var="grade" items="${availableGrades}">
            <option value="${grade}" ${filter.gradeLevel == grade ? 'selected' : ''}>
              Lớp <c:out value="${grade}"/>
            </option>
          </c:forEach>
        </select>
      </label>

      <label class="screen-field">
        Học phí
        <select name="fee_range">
          <option value="all">Tất cả mức phí</option>
          <option value="under_2m" ${filter.feeRange == 'under_2m' ? 'selected' : ''}>Đến 2.000.000 đ</option>
          <option value="2m_3m5" ${filter.feeRange == '2m_3m5' ? 'selected' : ''}>2.000.000–3.500.000 đ</option>
          <option value="over_3m5" ${filter.feeRange == 'over_3m5' ? 'selected' : ''}>Từ 3.500.000 đ</option>
        </select>
      </label>

      <label class="screen-field">
        Sắp xếp
        <select name="sort">
          <option value="newest" ${filter.sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
          <option value="fee_asc" ${filter.sort == 'fee_asc' ? 'selected' : ''}>Học phí tăng dần</option>
          <option value="fee_desc" ${filter.sort == 'fee_desc' ? 'selected' : ''}>Học phí giảm dần</option>
          <option value="name_asc" ${filter.sort == 'name_asc' ? 'selected' : ''}>Tên A–Z</option>
        </select>
      </label>

      <div class="screen-actions screen-span">
        <button class="btn btn-primary" type="submit">
          <svg class="icon-sm" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
          Tìm khóa học
        </button>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/courses">Đặt lại bộ lọc</a>
        <span class="screen-muted"><c:out value="${coursePage.totalRecords}"/> chương trình đào tạo phù hợp</span>
      </div>
    </form>

    <!-- Course Grid -->
    <c:choose>
      <c:when test="${empty coursePage.items}">
        <div class="screen-card screen-empty">
          <div class="empty-icon-wrap">
            <svg class="icon-lg" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
          </div>
          <h2>Chưa tìm thấy khóa học phù hợp</h2>
          <p>Thử thay đổi từ khóa tìm kiếm, môn học, khối lớp hoặc khoảng học phí. Danh mục sẽ liên tục được cập nhật theo kế hoạch đào tạo mới nhất.</p>
          <a class="btn btn-secondary" href="${pageContext.request.contextPath}/courses">Xem tất cả khóa học</a>
        </div>
      </c:when>

      <c:otherwise>
        <div class="screen-course-grid">
          <c:forEach var="course" items="${coursePage.items}">
            <article class="screen-card screen-course">
              <!-- Thumbnail with Floating Badges -->
              <div class="course-thumb-wrap">
                <c:choose>
                  <c:when test="${not empty course.imageUrl}">
                    <img class="screen-course-image" loading="lazy" src="<c:url value='${course.imageUrl}'/>" alt="<c:out value='${course.name}'/>"/>
                  </c:when>
                  <c:otherwise>
                    <div class="course-placeholder-thumb">
                      <svg class="icon-lg" viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10"/><path d="M6 10h10"/></svg>
                    </div>
                  </c:otherwise>
                </c:choose>

                <!-- Floating Badges on Image -->
                <c:if test="${not empty course.subjectName}">
                  <span class="course-badge-subject"><c:out value="${course.subjectName}"/></span>
                </c:if>
                <c:if test="${not empty course.gradeLevel}">
                  <span class="course-badge-grade">Lớp <c:out value="${course.gradeLevel}"/></span>
                </c:if>
              </div>

              <!-- Course Body -->
              <div class="screen-course-body">
                <div class="course-code-row">
                  <span class="course-code-tag"><c:out value="${course.code}"/></span>
                  <c:choose>
                    <c:when test="${course.openForRegistration}">
                      <span class="course-status-pill">Đang tuyển sinh</span>
                    </c:when>
                    <c:otherwise>
                      <span class="course-status-pill" style="color:var(--text-muted);background:var(--surface-muted);border-color:var(--border);">Tạm dừng</span>
                    </c:otherwise>
                  </c:choose>
                </div>

                <h2>
                  <a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}">
                    <c:out value="${course.name}"/>
                  </a>
                </h2>

                <p class="course-desc">
                  <c:out value="${course.description}"/>
                </p>

                <!-- Course Specs (Icon Chips) -->
                <div class="course-meta-list">
                  <div class="course-meta-item">
                    <svg class="icon-sm" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    <span><c:out value="${course.totalSessions}"/> buổi · <c:out value="${course.durationWeeks}"/> tuần</span>
                  </div>
                  <div class="course-meta-item">
                    <svg class="icon-sm" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    <span><c:out value="${not empty course.teacherName ? course.teacherName : 'Giảng viên chuyên môn'}"/></span>
                  </div>
                </div>

                <!-- Footer: Price & Action Buttons -->
                <div class="course-footer">
                  <div class="course-price-wrap">
                    <span class="course-price-label">Học phí niêm yết</span>
                    <div class="screen-price"><c:out value="${course.formattedFee}"/></div>
                  </div>

                  <div class="course-card-actions">
                    <a class="btn btn-secondary btn-sm" href="${pageContext.request.contextPath}/courses/detail?id=${course.id}">
                      Chi tiết
                    </a>
                    <c:if test="${course.openForRegistration}">
                      <form action="${pageContext.request.contextPath}/registration-cart/add" method="post">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        <input type="hidden" name="courseId" value="${course.id}"/>
                        <button class="btn btn-primary btn-sm" type="submit">
                          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                          Thêm vào danh sách
                        </button>
                      </form>
                    </c:if>
                  </div>
                </div>
              </div>
            </article>
          </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${coursePage.totalPages > 1}">
          <nav class="screen-pagination" aria-label="Phân trang khóa học">
            <c:forEach var="p" begin="${coursePage.currentPage > 3 ? coursePage.currentPage - 3 : 1}" end="${coursePage.currentPage + 3 < coursePage.totalPages ? coursePage.currentPage + 3 : coursePage.totalPages}">
              <c:url var="pageUrl" value="/courses">
                <c:param name="page" value="${p}"/>
                <c:param name="keyword" value="${filter.keyword}"/>
                <c:param name="subjectId" value="${filter.subjectId}"/>
                <c:param name="gradeLevel" value="${filter.gradeLevel}"/>
                <c:param name="fee_range" value="${filter.feeRange}"/>
                <c:param name="sort" value="${filter.sort}"/>
              </c:url>
              <a href="<c:out value='${pageUrl}'/>" aria-current="${p == coursePage.currentPage ? 'page' : 'false'}">
                <c:out value="${p}"/>
              </a>
            </c:forEach>
          </nav>
        </c:if>
      </c:otherwise>
    </c:choose>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
