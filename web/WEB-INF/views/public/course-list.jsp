<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Danh Mục Khóa Học &amp; Luyện Thi THPT — EduCenter" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course.css">
</head>
<body>
    <c:set var="activeNav" value="courses" scope="request" />
    <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

    <main style="padding-top: 64px; min-height: calc(100vh - 200px);">
        <!-- Flash Alert Messages -->
        <div style="max-width: 1200px; margin: 16px auto 0; padding: 0 20px;">
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>
        </div>

        <!-- Section 1: Hero Banner & Search Console -->
        <section class="catalog-hero">
            <div class="catalog-hero-container">
                <div class="catalog-hero-header">
                    <div>
                        <div class="badge badge-admin" style="font-size: 11px; padding: 3px 8px; margin-bottom: 6px; display: inline-flex; align-items: center; gap: 4px;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                            HỆ THỐNG ĐÀO TẠO 2026
                        </div>
                        <h1 class="catalog-hero-title">Danh Mục Khóa Học &amp; Luyện Thi Chất Lượng Cao</h1>
                        <p class="catalog-hero-subtitle">
                            Các khóa học ôn luyện THPT Quốc Gia, Đánh giá năng lực và bồi dưỡng chuyên sâu theo chương trình GDPT mới, bám sát cấu trúc tuyển sinh Đại học.
                        </p>
                    </div>

                    <!-- Trust Metrics Spark -->
                    <div class="catalog-trust-badge">
                        <div class="catalog-trust-item">
                            <div class="catalog-trust-icon">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                            <div>
                                <div class="catalog-trust-num">3.850+</div>
                                <div class="catalog-trust-label">Học viên theo học</div>
                            </div>
                        </div>
                        <div style="width: 1px; height: 32px; background: var(--border);"></div>
                        <div class="catalog-trust-item">
                            <div class="catalog-trust-icon" style="color: var(--success);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                            </div>
                            <div>
                                <div class="catalog-trust-num">98.2%</div>
                                <div class="catalog-trust-label">Đạt mục tiêu điểm</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search Console -->
                <div class="search-console-card">
                    <form action="${pageContext.request.contextPath}/courses" method="GET" class="search-console-form">
                        <c:if test="${not empty filter.subjectId}">
                            <input type="hidden" name="subjectId" value="${filter.subjectId}" />
                        </c:if>
                        <c:if test="${not empty filter.gradeLevel}">
                            <input type="hidden" name="gradeLevel" value="${filter.gradeLevel}" />
                        </c:if>
                        <c:if test="${not empty filter.feeRange}">
                            <input type="hidden" name="fee_range" value="${filter.feeRange}" />
                        </c:if>
                        <c:if test="${not empty filter.sort}">
                            <input type="hidden" name="sort" value="${filter.sort}" />
                        </c:if>

                        <div class="search-input-wrapper">
                            <svg class="icon icon-md search-input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <input type="text" name="keyword" value="<c:out value='${filter.keyword}' />"
                                   placeholder="Nhập tên khóa học, mã môn hoặc kỳ thi (ví dụ: Toán 12, ĐGNL, Lý 11)..."
                                   class="search-console-input" />
                        </div>
                        <button type="submit" class="btn btn-primary" style="height: 42px; padding: 0 24px; display: inline-flex; align-items: center; gap: 8px;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <span>Tìm kiếm</span>
                        </button>
                    </form>
                </div>

                <!-- Trending Keyword Shortcuts -->
                <div class="trending-keywords">
                    <span style="font-weight: 600; color: var(--warning); display: inline-flex; align-items: center; gap: 4px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"></path></svg>
                        Xu hướng:
                    </span>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=12&keyword=To%C3%A1n" class="trending-chip">Toán 12 ĐGNL</a>
                    <a href="${pageContext.request.contextPath}/courses?keyword=IELTS" class="trending-chip">IELTS 6.5+</a>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=11&keyword=V%E1%BA%ADt+L%C3%BD" class="trending-chip">Lý 11 Nâng cao</a>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=10&keyword=H%C3%B3a" class="trending-chip">Hóa 10 Chuyên</a>
                </div>
            </div>
        </section>

        <!-- Section 2: Quick Grade Level & Subject Selectors -->
        <section class="quick-chips-strip">
            <div class="quick-chips-container">
                <!-- Grade Selectors -->
                <div class="chips-row">
                    <span class="chips-row-label">Khối lớp:</span>
                    <a href="${pageContext.request.contextPath}/courses?subjectId=${filter.subjectId != null ? filter.subjectId : ''}&sort=${filter.sort}"
                       class="chip-btn ${empty filter.gradeLevel ? 'active' : ''}">
                        Tất cả khối
                    </a>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=12&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&sort=${filter.sort}"
                       class="chip-btn ${filter.gradeLevel == 12 ? 'active' : ''}">
                        Khối 12 (Luyện thi THPT)
                    </a>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=11&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&sort=${filter.sort}"
                       class="chip-btn ${filter.gradeLevel == 11 ? 'active' : ''}">
                        Khối 11 (Nền tảng)
                    </a>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=10&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&sort=${filter.sort}"
                       class="chip-btn ${filter.gradeLevel == 10 ? 'active' : ''}">
                        Khối 10 (GDPT mới)
                    </a>
                </div>

                <!-- Subject Selectors -->
                <div class="chips-row">
                    <span class="chips-row-label">Môn học:</span>
                    <a href="${pageContext.request.contextPath}/courses?gradeLevel=${filter.gradeLevel != null ? filter.gradeLevel : ''}&sort=${filter.sort}"
                       class="chip-btn ${empty filter.subjectId ? 'active' : ''}">
                        Tất cả môn
                    </a>
                    <c:forEach var="sub" items="${subjects}">
                        <a href="${pageContext.request.contextPath}/courses?subjectId=${sub.id}&gradeLevel=${filter.gradeLevel != null ? filter.gradeLevel : ''}&sort=${filter.sort}"
                           class="chip-btn ${filter.subjectId == sub.id ? 'active' : ''}">
                            <c:out value="${sub.name}" />
                            <c:if test="${sub.courseCount > 0}">
                                <span style="font-size: 11px; opacity: 0.8;">(<c:out value="${sub.courseCount}" />)</span>
                            </c:if>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </section>

        <!-- Section 3: Main Workspace (Sidebar Filter + Results Grid) -->
        <section class="catalog-main-section">
            <div class="catalog-layout">
                <!-- Left Filter Panel -->
                <aside class="filter-aside">
                    <div class="filter-aside-header">
                        <h3 class="filter-title">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><line x1="4" y1="21" x2="4" y2="14"></line><line x1="4" y1="10" x2="4" y2="3"></line><line x1="12" y1="21" x2="12" y2="12"></line><line x1="12" y1="8" x2="12" y2="3"></line><line x1="20" y1="21" x2="20" y2="16"></line><line x1="20" y1="12" x2="20" y2="3"></line><line x1="1" y1="14" x2="7" y2="14"></line><line x1="9" y1="8" x2="15" y2="8"></line><line x1="17" y1="16" x2="23" y2="16"></line></svg>
                            Bộ Lọc Chi Tiết
                        </h3>
                        <a href="${pageContext.request.contextPath}/courses" class="filter-reset-link">Xóa tất cả</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/courses" method="GET" id="catalogFilterForm" style="display: flex; flex-direction: column; gap: 20px;">
                        <input type="hidden" name="keyword" value="<c:out value='${filter.keyword}' />" />

                        <!-- Group: Môn học -->
                        <div class="filter-group">
                            <h4 class="filter-group-title">Môn học</h4>
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <c:forEach var="sub" items="${subjects}">
                                    <label class="filter-item-label">
                                        <div class="filter-item-left">
                                            <input type="radio" name="subjectId" value="${sub.id}"
                                                   ${filter.subjectId == sub.id ? 'checked' : ''}
                                                   onchange="document.getElementById('catalogFilterForm').submit()" />
                                            <span><c:out value="${sub.name}" /></span>
                                        </div>
                                        <span class="filter-count-badge"><c:out value="${sub.courseCount}" /></span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Divider -->
                        <div style="height: 1px; background: var(--border);"></div>

                        <!-- Group: Khối lớp -->
                        <div class="filter-group">
                            <h4 class="filter-group-title">Khối lớp</h4>
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="gradeLevel" value=""
                                               ${empty filter.gradeLevel ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Tất cả các khối</span>
                                    </div>
                                </label>
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="gradeLevel" value="12"
                                               ${filter.gradeLevel == 12 ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Khối 12 (Luyện thi Đại học)</span>
                                    </div>
                                </label>
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="gradeLevel" value="11"
                                               ${filter.gradeLevel == 11 ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Khối 11 (Tạo nền tảng)</span>
                                    </div>
                                </label>
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="gradeLevel" value="10"
                                               ${filter.gradeLevel == 10 ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Khối 10 (GDPT mới)</span>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Divider -->
                        <div style="height: 1px; background: var(--border);"></div>

                        <!-- Group: Mức học phí -->
                        <div class="filter-group">
                            <h4 class="filter-group-title">Khoảng học phí / khóa</h4>
                            <div style="display: flex; flex-direction: column; gap: 6px;">
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="fee_range" value="all"
                                               ${empty filter.feeRange || filter.feeRange == 'all' ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Tất cả mức phí</span>
                                    </div>
                                </label>
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="fee_range" value="under_2m"
                                               ${filter.feeRange == 'under_2m' ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Dưới 2.000.000 đ</span>
                                    </div>
                                </label>
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="fee_range" value="2m_3m5"
                                               ${filter.feeRange == '2m_3m5' ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>2.000.000 đ - 3.500.000 đ</span>
                                    </div>
                                </label>
                                <label class="filter-item-label">
                                    <div class="filter-item-left">
                                        <input type="radio" name="fee_range" value="over_3m5"
                                               ${filter.feeRange == 'over_3m5' ? 'checked' : ''}
                                               onchange="document.getElementById('catalogFilterForm').submit()" />
                                        <span>Trên 3.500.000 đ</span>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 4px;">
                            <button type="submit" class="btn btn-primary btn-sm">Áp dụng bộ lọc</button>
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-secondary btn-sm" style="text-align: center;">Đặt lại mặc định</a>
                        </div>
                    </form>
                </aside>

                <!-- Right Results Grid -->
                <div class="catalog-results">
                    <!-- Results Toolbar -->
                    <div class="results-toolbar">
                        <div class="results-count-text">
                            Tìm thấy <span class="results-count-highlight"><c:out value="${coursePage.totalRecords}" /></span> khóa học phù hợp:
                            <c:if test="${not empty filter.keyword}">
                                <span style="font-weight: 600; color: var(--text);">cho từ khóa "<c:out value="${filter.keyword}" />"</span>
                            </c:if>
                        </div>

                        <!-- Sort By Dropdown -->
                        <div class="results-sort-box">
                            <label for="catalogSortSelect" style="font-size: 13px; color: var(--text-muted); font-weight: 500;">Sắp xếp:</label>
                            <select id="catalogSortSelect" class="sort-select"
                                    onchange="location.href='${pageContext.request.contextPath}/courses?keyword=${filter.keyword != null ? filter.keyword : ''}&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&gradeLevel=${filter.gradeLevel != null ? filter.gradeLevel : ''}&fee_range=${filter.feeRange != null ? filter.feeRange : ''}&sort=' + this.value">
                                <option value="newest" ${filter.sort == 'newest' ? 'selected' : ''}>Mới nhất &amp; Nổi bật</option>
                                <option value="fee_asc" ${filter.sort == 'fee_asc' ? 'selected' : ''}>Học phí: Thấp đến cao</option>
                                <option value="fee_desc" ${filter.sort == 'fee_desc' ? 'selected' : ''}>Học phí: Cao đến thấp</option>
                                <option value="name_asc" ${filter.sort == 'name_asc' ? 'selected' : ''}>Tên khóa học (A-Z)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Courses Cards Grid or Empty State -->
                    <c:choose>
                        <c:when test="${not empty coursePage.items}">
                            <div class="course-grid">
                                <c:forEach var="c" items="${coursePage.items}">
                                    <article class="course-card">
                                        <div class="course-card-body">
                                            <div class="course-card-topbar">
                                                <span class="course-code-tag"><c:out value="${c.code}" /></span>
                                                <div class="course-badge-strip">
                                                    <c:if test="${c.isFeatured}">
                                                        <span class="badge-featured">
                                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                                            Nổi bật
                                                        </span>
                                                    </c:if>
                                                    <span class="badge-open">Đang mở</span>
                                                </div>
                                            </div>

                                            <div class="course-card-thumb">
                                                <c:choose>
                                                    <c:when test="${not empty c.imageUrl}">
                                                        <img src="<c:url value='${c.imageUrl}' />" alt="<c:out value='${c.name}' />" class="course-card-img" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: var(--surface-muted); color: var(--primary);">
                                                            <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="course-card-thumb-tag">
                                                    <c:out value="${c.subjectName}" /> • Khối <c:out value="${c.gradeLevel}" />
                                                </span>
                                            </div>

                                            <h3 class="course-card-title">
                                                <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" style="color: inherit; text-decoration: none;">
                                                    <c:out value="${c.name}" />
                                                </a>
                                            </h3>

                                            <p class="course-card-desc">
                                                <c:out value="${c.description != null ? c.description : 'Chương trình giảng dạy chuẩn hóa, rèn luyện tư duy tự luận và kỹ năng giải nhanh trắc nghiệm.'}" />
                                            </p>

                                            <div class="course-card-specs">
                                                <div class="course-spec-item">
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                                    <span><c:out value="${c.totalSessions}" /> buổi học</span>
                                                </div>
                                                <div class="course-spec-item">
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                                    <span>Tối đa <c:out value="${c.maxCapacity}" /> HV</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="course-card-footer">
                                            <div>
                                                <div class="course-card-fee-label">Học phí trọn khóa</div>
                                                <div class="course-card-fee-num">
                                                    <fmt:formatNumber value="${c.fee}" pattern="#,##0" /> VNĐ
                                                </div>
                                            </div>

                                            <div class="course-card-actions">
                                                <!-- Add to cart form via PRG -->
                                                <form action="${pageContext.request.contextPath}/registration-cart/add" method="POST" style="margin: 0;">
                                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                    <input type="hidden" name="courseId" value="${c.id}" />
                                                    <button type="submit" class="btn btn-secondary btn-sm" title="Thêm vào danh sách đăng ký">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                                                    </button>
                                                </form>

                                                <a href="${pageContext.request.contextPath}/courses/detail?id=${c.id}" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                                                    <span>Chi tiết</span>
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                                </a>
                                            </div>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>

                            <!-- Pagination Controls -->
                            <c:if test="${coursePage.totalPages > 1}">
                                <nav class="pagination-nav" aria-label="Phân trang danh mục">
                                    <!-- Previous -->
                                    <c:choose>
                                        <c:when test="${coursePage.hasPrevious}">
                                            <a href="${pageContext.request.contextPath}/courses?page=${coursePage.currentPage - 1}&keyword=${filter.keyword != null ? filter.keyword : ''}&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&gradeLevel=${filter.gradeLevel != null ? filter.gradeLevel : ''}&fee_range=${filter.feeRange != null ? filter.feeRange : ''}&sort=${filter.sort}"
                                               class="page-link-btn" title="Trang trước">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-link-btn disabled">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Page Number Chips -->
                                    <c:forEach var="p" begin="1" end="${coursePage.totalPages}">
                                        <a href="${pageContext.request.contextPath}/courses?page=${p}&keyword=${filter.keyword != null ? filter.keyword : ''}&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&gradeLevel=${filter.gradeLevel != null ? filter.gradeLevel : ''}&fee_range=${filter.feeRange != null ? filter.feeRange : ''}&sort=${filter.sort}"
                                           class="page-link-btn ${p == coursePage.currentPage ? 'active' : ''}">
                                            <c:out value="${p}" />
                                        </a>
                                    </c:forEach>

                                    <!-- Next -->
                                    <c:choose>
                                        <c:when test="${coursePage.hasNext}">
                                            <a href="${pageContext.request.contextPath}/courses?page=${coursePage.currentPage + 1}&keyword=${filter.keyword != null ? filter.keyword : ''}&subjectId=${filter.subjectId != null ? filter.subjectId : ''}&gradeLevel=${filter.gradeLevel != null ? filter.gradeLevel : ''}&fee_range=${filter.feeRange != null ? filter.feeRange : ''}&sort=${filter.sort}"
                                               class="page-link-btn" title="Trang kế tiếp">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-link-btn disabled">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </nav>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <!-- Empty State View when no courses found -->
                            <div class="empty-state-card">
                                <div class="empty-state-icon">
                                    <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line><line x1="8" y1="11" x2="14" y2="11"></line></svg>
                                </div>
                                <h3 class="empty-state-title">Không tìm thấy khóa học nào phù hợp</h3>
                                <p class="empty-state-desc">
                                    Rất tiếc, hiện tại không có khóa học nào khớp với các bộ lọc bạn đã chọn. Vui lòng thử thay đổi từ khóa tìm kiếm hoặc đặt lại tiêu chí lọc.
                                </p>
                                <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary btn-sm" style="margin-top: 8px;">
                                    Xem tất cả khóa học
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </main>

    <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
