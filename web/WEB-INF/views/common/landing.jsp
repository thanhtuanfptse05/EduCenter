<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/portal.css">
</head>
<body class="${not empty dashboardPath ? 'internal-site' : 'public-site'}">
    <c:choose>
        <%-- Logged-In User Dashboard Landing (FR-008) --%>
        <c:when test="${not empty dashboardPath}">
            <c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
                <c:set var="activeNav" value="dashboard" scope="request" />
                <c:set var="breadcrumb" value="${dashboardRoleName != null ? dashboardRoleName : 'Bảng điều khiển'}" scope="request" />
                <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

                <div class="admin-main">
                    <%@ include file="/WEB-INF/views/common/header.jspf" %>

                    <main class="admin-content">
                        <!-- Flash Alerts -->
                        <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                        <div class="page-header">
                            <div>
                                <h1 class="page-title">Chào mừng trở lại, <c:out value="${sessionScope.currentUser.fullName}" />!</h1>
                                <p class="page-subtitle">Không gian làm việc: <strong><c:out value="${dashboardRoleName != null ? dashboardRoleName : sessionScope.currentUser.primaryRole}" /></strong></p>
                            </div>
                            <div style="display: flex; gap: 8px;">
                                <c:if test="${sessionScope.currentUser.admin}">
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <line x1="19" y1="8" x2="19" y2="14"></line>
                                            <line x1="22" y1="11" x2="16" y2="11"></line>
                                        </svg>
                                        <span>Quản lý người dùng</span>
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="12" cy="12" r="3"></circle>
                                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                    </svg>
                                    <span>Hồ sơ cá nhân</span>
                                </a>
                            </div>
                        </div>

                        <!-- System Status Banner -->
                        <div class="card" style="margin-bottom: 24px;">
                            <div class="card-body">
                                <h2 style="font-size: var(--font-size-md); font-weight: 650; margin-bottom: 8px;">Trạng thái tài khoản & Phiên làm việc</h2>
                                <p class="text-muted" style="margin-bottom: 16px;">
                                    Đang đăng nhập với email: <strong><c:out value="${sessionScope.currentUser.email}" /></strong>.
                                    Quản lý thông tin tài khoản và các quyền được cấp cho bạn.
                                </p>
                                <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary btn-sm">Quản lý tài khoản</a>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Action Navigation -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px;">
                            <div class="card">
                                <div class="card-body">
                                    <h3 style="font-size: var(--font-size-md); font-weight: 700; margin-bottom: 8px;">Quản trị người dùng & Phân quyền</h3>
                                    <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 16px;">
                                        Xem danh sách 5 vai trò, khóa/mở khóa tài khoản và phân quyền quản trị theo đúng Business Rules.
                                    </p>
                                    <c:choose>
                                        <c:when test="${sessionScope.currentUser.admin}">
                                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary btn-sm">Mở danh sách người dùng &rarr;</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted" style="font-size: var(--font-size-xs);">Chỉ dành cho Quản trị viên (ADMIN)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-body">
                                    <h3 style="font-size: var(--font-size-md); font-weight: 700; margin-bottom: 8px;">Hồ sơ cá nhân & Đổi mật khẩu</h3>
                                    <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 16px;">
                                        Cập nhật số điện thoại, thông tin định danh và đổi mật khẩu tài khoản.
                                    </p>
                                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary btn-sm">Xem hồ sơ &rarr;</a>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-body">
                                    <h3 style="font-size: var(--font-size-md); font-weight: 700; margin-bottom: 8px;">Cổng thông tin gia sư THPT</h3>
                                    <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 16px;">
                                        Xem giao diện trang chủ công khai dành cho phụ huynh và học sinh tìm kiếm chương trình học.
                                    </p>
                                    <a href="${pageContext.request.contextPath}/#chuong-trinh" class="btn btn-secondary btn-sm">Xem cổng thông tin &rarr;</a>
                                </div>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </c:when>

        <%-- Public Landing Page (Unauthenticated Guests & High School Tutoring Portal) --%>
        <c:otherwise>
            <c:set var="activeNav" value="home" scope="request"/>
            <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

            <main id="main-content" class="public-home">
                <!-- SECTION 02: HERO SECTION -->
                <section class="portal-hero">
                    <div class="portal-hero-container">
                        <!-- Left Column: Copy & Quick Filter -->
                        <div>
                            <div class="hero-pill-badge">
                                <span class="hero-pulse-dot"></span>
                                <span>Chuyên biệt Gia sư & Bổ trợ Kiến thức THPT</span>
                            </div>

                            <h1 class="hero-title">
                                Vững kiến thức.<br><span class="hero-highlight">Tự tin chinh phục kỳ thi.</span>
                            </h1>

                            <p class="hero-desc">
                                Đồng hành cùng học sinh THPT trên hành trình củng cố kiến thức, nâng cao điểm số và tự tin chinh phục kỳ thi tốt nghiệp THPT với phương pháp học tập khoa học và đội ngũ sư phạm chuẩn mực.
                            </p>

                            <div class="hero-btn-group">
                                <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary" style="padding: 12px 24px; font-weight: 600;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="11" cy="11" r="8"></circle>
                                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                    </svg>
                                    <span>Khám phá khóa học</span>
                                </a>
                                <a href="#dang-ky-tu-van" class="btn btn-secondary" style="padding: 12px 24px; font-weight: 600;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                    </svg>
                                    <span>Đăng ký tư vấn miễn phí</span>
                                </a>
                            </div>

                            <!-- Quick Filter Bar (Data driven from DB) -->
                            <div class="hero-filter-box">
                                <div class="hero-filter-top">
                                    <span>Lọc nhanh theo khối lớp:</span>
                                    <span class="hero-class-count">
                                        <c:out value="${portalData.openClassesCount}" /> lớp học đang mở
                                    </span>
                                </div>
                                <div class="hero-chip-row">
                                    <a class="hero-filter-chip" href="${pageContext.request.contextPath}/courses">Tất cả khóa học</a>
                                    <c:forEach var="grade" items="${availableGrades}">
                                        <a class="hero-filter-chip" href="${pageContext.request.contextPath}/courses?gradeLevel=${grade}">Lớp <c:out value="${grade}"/></a>
                                    </c:forEach>
                                </div>
                                <div class="hero-chip-row">
                                    <c:forEach var="subject" items="${portalSubjects}">
                                        <a class="grade-tag" href="${pageContext.request.contextPath}/courses?subjectId=${subject.id}"><c:out value="${subject.name}"/></a>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Right Column: Personal Progress Showcase Card -->
                        <div>
                            <div class="progress-card">
                                <!-- Campus Hero Showcase Banner -->
                                <div class="hero-campus-banner">
                                    <img src="<c:url value='/assets/images/courses/classroom-hero.jpg' />" alt="Không gian giảng đường & phòng học chuyên đề EduCenter" class="hero-campus-img" />
                                    <div class="hero-campus-tag">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                        <span>EduCenter Campus • Cơ sở học thuật chuẩn quốc gia</span>
                                    </div>
                                </div>

                                <div class="progress-header">
                                    <div class="progress-student-meta">
                                        <h3>Hồ sơ Tiến độ Cá nhân</h3>
                                        <p>Mã HV: #THPT-2026-9812 • Lớp 12A1</p>
                                    </div>
                                    <span class="grade-badge">Đang học kỳ II</span>
                                </div>

                                <div class="progress-trajectory">
                                    <div>
                                        <span style="font-size: 11px; color: var(--text-muted); display: block;">Mục tiêu môn Toán 12</span>
                                        <span class="progress-trajectory-val">6.5 &rarr; 8.5+</span>
                                    </div>
                                    <div style="text-align: right;">
                                        <span class="progress-badge-score">+2.0 Điểm đạt</span>
                                        <span style="font-size: 11px; color: var(--text-muted); display: block; margin-top: 4px;">Đánh giá sau 14 buổi</span>
                                    </div>
                                </div>

                                <!-- Sparkline Visualization -->
                                <div class="sparkline-wrapper">
                                    <div class="sparkline-header">
                                        <span>Lịch sử bài kiểm tra 45 phút</span>
                                        <span style="color: var(--primary); font-weight: 700;">Gần nhất: 8.6 đ</span>
                                    </div>
                                    <div class="sparkline-container">
                                        <div class="sparkline-bar" style="height: 55%;"><span>5.8</span></div>
                                        <div class="sparkline-bar" style="height: 64%;"><span>6.5</span></div>
                                        <div class="sparkline-bar" style="height: 72%;"><span>7.2</span></div>
                                        <div class="sparkline-bar" style="height: 80%;"><span>7.8</span></div>
                                        <div class="sparkline-bar" style="height: 85%;"><span>8.2</span></div>
                                        <div class="sparkline-bar active" style="height: 92%;"><span>8.6</span></div>
                                    </div>
                                </div>

                                <!-- Operational Metrics -->
                                <div class="progress-metrics-grid">
                                    <div class="metric-cell">
                                        <span class="metric-cell-label">Chuyên cần</span>
                                        <span class="metric-cell-val">96.4%</span>
                                    </div>
                                    <div class="metric-cell">
                                        <span class="metric-cell-label">Đã hoàn thành</span>
                                        <span class="metric-cell-val" style="color: var(--primary);">16/24 buổi</span>
                                    </div>
                                    <div class="metric-cell">
                                        <span class="metric-cell-label">Bài tập về nhà</span>
                                        <span class="metric-cell-val" style="color: var(--success);">100%</span>
                                    </div>
                                </div>

                                <div style="display: flex; justify-content: space-between; align-items: center; font-size: 11px; color: var(--text-muted); border-top: 1px solid var(--border); padding-top: 10px;">
                                    <span style="display: flex; align-items: center; gap: 4px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" style="color: var(--primary);" aria-hidden="true">
                                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                            <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                        </svg>
                                        GV phụ trách: ThS. Đặng Vũ Nam
                                    </span>
                                    <span style="font-weight: 600; color: var(--text);">Cập nhật: Hôm nay</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 02B: THÀNH TỰU & GIẢI THƯỞNG DANH GIÁ (AWARDS CAROUSEL WITH DRAG/SWIPE) -->
                <section class="portal-section" id="thanh-tuu" style="padding-top: 48px; padding-bottom: 40px;">
                    <div class="portal-container">
                        <div class="portal-carousel" id="awards-carousel">
                            <div class="carousel-head">
                                <div>
                                    <div class="hero-pill-badge" style="margin-bottom: 10px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><circle cx="12" cy="8" r="7"></circle><polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline></svg>
                                        <span>Khẳng Định Uy Tín Giáo Dục</span>
                                    </div>
                                    <h2 class="section-heading" style="margin-bottom: 8px;">Thành tựu & Giải thưởng Danh giá</h2>
                                    <p class="section-desc" style="margin-bottom: 0;">Sự ghi nhận từ các tổ chức giáo dục, hiệp hội học thuật và cộng đồng khảo thí uy tín trong nước và quốc tế.</p>
                                </div>
                                <div class="carousel-nav-controls">
                                    <button type="button" class="carousel-nav-btn carousel-btn-prev" aria-label="Xem giải thưởng trước">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="15 18 9 12 15 6"></polyline></svg>
                                    </button>
                                    <button type="button" class="carousel-nav-btn carousel-btn-next" aria-label="Xem giải thưởng tiếp theo">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                    </button>
                                </div>
                            </div>

                            <div class="carousel-viewport">
                                <div class="carousel-track">
                                    <c:forEach var="award" items="${portalData.achievementAwards}">
                                        <article class="award-card carousel-card">
                                            <div>
                                                <div class="award-card-header">
                                                    <div class="award-icon-box">
                                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                                            <c:choose>
                                                                <c:when test="${award.iconType == 'trophy'}">
                                                                    <path d="M6 9H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h2"></path>
                                                                    <path d="M18 9h2a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2h-2"></path>
                                                                    <path d="M4 3h16v6a8 8 0 0 1-16 0V3z"></path>
                                                                    <path d="M12 17v4"></path>
                                                                    <path d="M8 21h8"></path>
                                                                </c:when>
                                                                <c:when test="${award.iconType == 'award'}">
                                                                    <circle cx="12" cy="8" r="7"></circle>
                                                                    <polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
                                                                </c:when>
                                                                <c:when test="${award.iconType == 'shield-check'}">
                                                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                                                    <polyline points="9 12 11 14 15 10"></polyline>
                                                                </c:when>
                                                                <c:when test="${award.iconType == 'star'}">
                                                                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <circle cx="12" cy="8" r="6"></circle>
                                                                    <path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"></path>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </svg>
                                                    </div>
                                                    <span class="award-year-tag"><c:out value="${award.year}" /></span>
                                                </div>

                                                <h3 class="award-card-title"><c:out value="${award.title}" /></h3>
                                                <span class="award-card-org"><c:out value="${award.organization}" /></span>
                                                <p class="award-card-desc"><c:out value="${award.description}" /></p>
                                            </div>

                                            <div class="award-card-footer">
                                                <span class="award-pill"><c:out value="${award.badgeType}" /></span>
                                                <span style="font-size: 11px; color: var(--text-muted); font-weight: 600;">EduCenter Honor</span>
                                            </div>
                                        </article>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="carousel-dots" aria-hidden="true"></div>
                        </div>

                        <!-- SECTION 02C: CON SỐ ẤN TƯỢNG (HIGH-CONTRAST ACADEMIC METRICS BANNER) -->
                        <div class="milestones-wrapper">
                            <div class="milestones-grid">
                                <!-- Card 1 -->
                                <div class="milestone-dark-card">
                                    <div class="milestone-icon-top">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                    </div>
                                    <div>
                                        <div class="milestone-num-val">10+</div>
                                        <p class="milestone-label-main">Năm kinh nghiệm bồi dưỡng học thuật & luyện thi chuyên sâu.</p>
                                    </div>
                                </div>

                                <!-- Card 2 -->
                                <div class="milestone-dark-card">
                                    <div class="milestone-icon-top">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                    </div>
                                    <div>
                                        <div class="milestone-num-val">
                                            <c:out value="${portalData.openClassesCount > 0 ? portalData.openClassesCount : 32}" />+
                                        </div>
                                        <p class="milestone-label-main">Giảng đường & phòng học đạt chuẩn học thuật chất lượng cao.</p>
                                    </div>
                                </div>

                                <!-- Card 3 -->
                                <div class="milestone-dark-card">
                                    <div class="milestone-icon-top">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                    </div>
                                    <div>
                                        <div class="milestone-num-val">
                                            <c:choose>
                                                <c:when test="${portalData.totalStudents > 0}">
                                                    <fmt:formatNumber value="${portalData.totalStudents}" pattern="#,##0" />+
                                                </c:when>
                                                <c:otherwise>50.000+</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <p class="milestone-label-main">Học sinh học tập, cải thiện điểm số và bứt phá năng lực.</p>
                                    </div>
                                </div>

                                <!-- Card 4 -->
                                <div class="milestone-dark-card">
                                    <div class="milestone-icon-top">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"></path></svg>
                                    </div>
                                    <div>
                                        <div class="milestone-num-val">
                                            <c:out value="${portalData.universityPassingRate != null ? portalData.universityPassingRate : '98.6%'}" />
                                        </div>
                                        <p class="milestone-label-main">Học viên trúng tuyển Nguyện vọng 1 các trường Đại học Tốp đầu.</p>
                                    </div>
                                </div>

                                <!-- Card 5 -->
                                <div class="milestone-dark-card">
                                    <div class="milestone-icon-top">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.8                <!-- SECTION 03A: HÀNH TRÌNH BỨT PHÁ NĂNG LỰC & CHINH PHỤC ĐẠI HỌC (ASCENDING ROADMAP PATHWAY) -->
                <section class="roadmap-section" id="lo-trinh-hoc-tap">
                    <div class="portal-container">
                        <div class="section-head text-center">
                            <div class="hero-pill-badge" style="margin-bottom: 12px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                                </svg>
                                <span>Lộ Trình Đào Tạo Dài Hạn</span>
                            </div>
                            <h2 class="section-heading">Hành trình Bứt phá Năng lực của con bạn</h2>
                            <p class="section-desc">Thành công tương lai với nền tảng học thuật vững vàng, học bạ điểm cao, lộ trình bồi dưỡng chuyên sâu và cơ hội bước vào cánh cổng đại học mơ ước.</p>
                        </div>

                        <div class="roadmap-showcase-container">
                            <!-- Top Header: Runner figure on left, Flag + Summit badge on right -->
                            <div class="roadmap-apex-header">
                                <div class="roadmap-runner-lead">
                                    <span class="roadmap-runner-avatar">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                            <circle cx="12" cy="5" r="3"></circle>
                                            <path d="m9 20 3-6 3 6"></path>
                                            <path d="m6 8 6 2 6-2"></path>
                                            <path d="M12 10v4"></path>
                                        </svg>
                                    </span>
                                    <div class="roadmap-runner-text">
                                        <strong>Xuất phát điểm học sinh</strong>
                                        <span>Khởi đầu lộ trình bài bản</span>
                                    </div>
                                </div>

                                <div class="roadmap-summit-target">
                                    <div class="roadmap-flag-unit" aria-hidden="true">
                                        <svg class="roadmap-flag-icon" viewBox="0 0 24 24">
                                            <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" fill="#f59e0b" stroke="#d97706" stroke-width="1.5"></path>
                                            <line x1="4" y1="22" x2="4" y2="15" stroke="#78716c" stroke-width="2.5" stroke-linecap="round"></line>
                                        </svg>
                                    </div>
                                    <div class="roadmap-summit-badge">
                                        <span class="summit-star-pulse">★</span>
                                        <span>CƠ HỘI ĐẠI HỌC • 100+ TRƯỜNG ĐẠI HỌC TỐP ĐẦU</span>
                                    </div>
                                </div>
                            </div>

                            <!-- The 3D Ascending Ramp SVG Graphic traversing beneath milestone cards -->
                            <div class="roadmap-ramp-backdrop" aria-hidden="true">
                                <svg class="roadmap-ramp-svg" viewBox="0 0 1200 160" preserveAspectRatio="none">
                                    <defs>
                                        <linearGradient id="rampSlopeGrad" x1="0%" y1="100%" x2="100%" y2="0%">
                                            <stop offset="0%" stop-color="#3b82f6" stop-opacity="0.25"/>
                                            <stop offset="35%" stop-color="#6366f1" stop-opacity="0.35"/>
                                            <stop offset="70%" stop-color="#8b5cf6" stop-opacity="0.45"/>
                                            <stop offset="100%" stop-color="#10b981" stop-opacity="0.6"/>
                                        </linearGradient>
                                        <linearGradient id="rampCoreGrad" x1="0%" y1="0%" x2="100%" y2="0%">
                                            <stop offset="0%" stop-color="#2563eb"/>
                                            <stop offset="100%" stop-color="#059669"/>
                                        </linearGradient>
                                    </defs>
                                    <polygon points="0,150 1020,40 1020,10 1180,45 1020,80 1020,60 0,160" fill="url(#rampSlopeGrad)"/>
                                    <line x1="10" y1="152" x2="1010" y2="42" stroke="url(#rampCoreGrad)" stroke-width="4" stroke-dasharray="10 8" opacity="0.85"/>
                                    <polygon points="1020,15 1170,45 1020,75 1040,45" fill="url(#rampCoreGrad)"/>
                                </svg>
                            </div>

                            <!-- 4 Milestone Stage Columns -->
                            <div class="roadmap-stages-grid">
                                <c:forEach var="stage" items="${portalData.learningStages}">
                                    <div class="roadmap-stage-column stage-${stage.stageNumber} ${stage.apexGoal ? 'is-summit' : ''}">
                                        <div class="stage-marker-wrap">
                                            <span class="stage-milestone-circle">0<c:out value="${stage.stageNumber}" /></span>
                                            <span class="stage-milestone-pill"><c:out value="${stage.badgeText}" /></span>
                                        </div>

                                        <div class="stage-card-body">
                                            <div class="stage-grade-label"><c:out value="${stage.gradeRange}" /></div>
                                            <h3 class="stage-title"><c:out value="${stage.title}" /></h3>
                                            <p class="stage-desc"><c:out value="${stage.description}" /></p>

                                            <div class="stage-footer-tags">
                                                <span class="stage-tag-caption">Trọng tâm:</span>
                                                <span class="stage-focus-tag"><c:out value="${stage.focusSubjects}" /></span>
                                            </div>
                                        </div>

                                        <div class="stage-elevation-badge">
                                            <c:choose>
                                                <c:when test="${stage.stageNumber == 1}"><span>Chặng 1 • Nền tảng</span></c:when>
                                                <c:when test="${stage.stageNumber == 2}"><span>Chặng 2 • Thích nghi</span></c:when>
                                                <c:when test="${stage.stageNumber == 3}"><span>Chặng 3 • Tăng tốc</span></c:when>
                                                <c:otherwise><span class="summit-label">Chặng 4 • Về đích ★</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 03: CHƯƠNG TRÌNH THEO KHỐI LỚP (3 Focused Cards) -->
                <section class="portal-section bg-alt" id="chuong-trinh">
                    <div class="portal-container">
                        <div class="section-head text-center">
                            <span class="section-tagline">Định Hướng Đào Tạo Chuyên Biệt</span>
                            <h2 class="section-heading">Chương trình gia sư thiết kế riêng cho từng khối lớp</h2>
                            <p class="section-desc">Không dàn trải. Mỗi năm học THPT đều có mục tiêu sống còn riêng để bứt phá học bạ và xét tuyển đại học.</p>
                        </div>

                        <div class="grade-grid">
                            <!-- Lớp 10 (Cyan / Teal Accent) -->
                            <div class="grade-card grade-card--10" data-grade="10">
                                <div class="grade-card-header">
                                    <div class="grade-num-box">
                                        <span class="grade-num">10</span>
                                        <span class="grade-level-text">Lớp 10 THPT</span>
                                    </div>
                                    <span class="grade-badge-custom badge-teal">Thích nghi & Nền tảng</span>
                                </div>

                                <div class="grade-target-banner banner-teal">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <span>Mục tiêu: Đạt học sinh Giỏi & Vững GDPT mới</span>
                                </div>

                                <h3 class="grade-card-title">Xây dựng nền tảng vững chắc</h3>
                                <p class="grade-card-desc">Củng cố kiến thức chuyển cấp THCS lên THPT, làm quen phương pháp học chương trình GDPT mới, hỗ trợ giải bài tập và cải thiện điểm số bài kiểm tra học kỳ.</p>

                                <div class="grade-checklist">
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-teal" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Hệ thống hóa toàn bộ kiến thức chuyển cấp then chốt</span>
                                    </div>
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-teal" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Làm quen cấu trúc đề tự luận & trắc nghiệm GDPT mới</span>
                                    </div>
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-teal" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Đánh giá định kỳ 2 tuần/lần & phản hồi tiến độ phụ huynh</span>
                                    </div>
                                </div>

                                <div class="grade-subject-block">
                                    <span class="grade-subject-title">Môn bồi dưỡng trọng điểm:</span>
                                    <div class="grade-subject-tags">
                                        <span class="grade-tag">Toán 10</span>
                                        <span class="grade-tag">Ngữ văn 10</span>
                                        <span class="grade-tag">Tiếng Anh 10</span>
                                        <span class="grade-tag">Vật lý 10</span>
                                        <span class="grade-tag">Hóa học 10</span>
                                    </div>
                                </div>

                                <div class="grade-card-cta">
                                    <a href="#dang-ky-tu-van" class="btn btn-secondary w-full">
                                        <span>Xem chương trình Lớp 10</span>
                                        <svg class="icon icon-sm" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                    </a>
                                </div>
                            </div>

                            <!-- Lớp 11 (Indigo / Blue Accent) -->
                            <div class="grade-card grade-card--11" data-grade="11">
                                <div class="grade-card-header">
                                    <div class="grade-num-box">
                                        <span class="grade-num">11</span>
                                        <span class="grade-level-text">Lớp 11 THPT</span>
                                    </div>
                                    <span class="grade-badge-custom badge-indigo">Tăng tốc điểm số</span>
                                </div>

                                <div class="grade-target-banner banner-indigo">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <span>Mục tiêu: Điểm kiểm tra 8.0+ & Chuẩn bị ĐGNL</span>
                                </div>

                                <h3 class="grade-card-title">Bứt phá năng lực & Nâng cao</h3>
                                <p class="grade-card-desc">Nâng cao kiến thức và kỹ năng giải bài tập chuyên sâu, lấp đầy mọi lỗ hổng kiến thức phân hóa, tạo tiền đề vững vàng để bước vào năm cuối cấp.</p>

                                <div class="grade-checklist">
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-indigo" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Làm chủ các chuyên đề phân hóa cao (Lượng giác, Đạo hàm, Hữu cơ)</span>
                                    </div>
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-indigo" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Tối ưu hóa điểm số học bạ làm hồ sơ xét tuyển sớm</span>
                                    </div>
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-indigo" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Tiếp cận sớm ngân hàng câu hỏi Đánh giá Năng lực ĐHQG</span>
                                    </div>
                                </div>

                                <div class="grade-subject-block">
                                    <span class="grade-subject-title">Môn bồi dưỡng trọng điểm:</span>
                                    <div class="grade-subject-tags">
                                        <span class="grade-tag">Toán 11 Chuyên đề</span>
                                        <span class="grade-tag">Văn 11</span>
                                        <span class="grade-tag">Anh 11</span>
                                        <span class="grade-tag">Lý 11</span>
                                        <span class="grade-tag">Hóa 11</span>
                                        <span class="grade-tag">Sinh 11</span>
                                    </div>
                                </div>

                                <div class="grade-card-cta">
                                    <a href="#dang-ky-tu-van" class="btn btn-secondary w-full">
                                        <span>Xem chương trình Lớp 11</span>
                                        <svg class="icon icon-sm" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                    </a>
                                </div>
                            </div>

                            <!-- Lớp 12 (Featured Golden Crown & Primary Accent) -->
                            <div class="grade-card grade-card--12 featured" data-grade="12">
                                <div class="grade-card-crown">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <span>CHƯƠNG TRÌNH TRỌNG ĐIỂM QUỐC GIA</span>
                                </div>

                                <div class="grade-card-header">
                                    <div class="grade-num-box">
                                        <span class="grade-num">12</span>
                                        <span class="grade-level-text">Lớp 12 & Luyện thi</span>
                                    </div>
                                    <span class="grade-badge-custom badge-amber">Luyện đề & Về đích</span>
                                </div>

                                <div class="grade-target-banner banner-amber">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    <span>Mục tiêu: Đạt 8.5 - 9.5+ & Trúng tuyển Nguyện vọng 1</span>
                                </div>

                                <h3 class="grade-card-title">Chinh phục Tốt nghiệp & ĐGNL</h3>
                                <p class="grade-card-desc">Tổng ôn toàn diện kiến thức trọng tâm 3 năm THPT, rèn luyện kỹ năng phân bổ thời gian thực chiến phòng thi và tối ưu hóa tổ hợp xét tuyển đại học tốp đầu.</p>

                                <div class="grade-checklist">
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-amber" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>50+ bộ đề thi thử độc quyền chuẩn ma trận Bộ GD&ĐT</span>
                                    </div>
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-amber" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Phân tích lỗi sai và luyện mẹo xử lý câu vận dụng cao</span>
                                    </div>
                                    <div class="grade-check-item">
                                        <svg class="icon icon-xs text-amber" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        <span>Chiến lược chọn nguyện vọng thông minh theo phổ điểm thi</span>
                                    </div>
                                </div>

                                <div class="grade-subject-block">
                                    <span class="grade-subject-title">Tổ hợp môn xét tuyển:</span>
                                    <div class="grade-subject-tags">
                                        <span class="grade-tag tag-primary">Toán 12 Chuyên sâu</span>
                                        <span class="grade-tag tag-primary">Vật Lý 12</span>
                                        <span class="grade-tag tag-primary">Hóa Học 12</span>
                                        <span class="grade-tag tag-primary">Tiếng Anh THPTQG</span>
                                        <span class="grade-tag tag-primary">Ngữ Văn 12</span>
                                    </div>
                                </div>

                                <div class="grade-card-cta">
                                    <a href="#dang-ky-tu-van" class="btn btn-primary w-full">
                                        <span>Đăng ký xếp lớp Lớp 12</span>
                                        <svg class="icon icon-sm" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 04: GIA SƯ THEO MÔN HỌC (Interactive Subject Grid - DYNAMIC DATA FROM DB) -->
                <section class="portal-section" id="mon-hoc">
                    <div class="portal-container">
                        <div style="display: flex; flex-direction: column; md:flex-row; justify-content: space-between; align-items: flex-start; margin-bottom: 36px; gap: 16px;">
                            <div>
                                <div class="hero-pill-badge" style="margin-bottom: 10px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                        <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                    </svg>
                                    <span>Môn Học Trọng Điểm</span>
                                </div>
                                <h2 class="section-heading">Gia sư theo bộ môn chuyên ngành</h2>
                                <p class="section-desc">Tuyển chọn giáo viên tốt nghiệp đúng chuyên ngành sư phạm hoặc cử nhân xuất sắc với tối thiểu 5 năm giảng dạy cấp THPT.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-secondary btn-sm" style="align-self: flex-start;">
                                <span>Xem tất cả khóa học</span>
                                <svg class="icon icon-sm" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${empty portalData.subjects}">
                                <div class="card" style="text-align: center; padding: 48px;">
                                    <p class="text-muted">Đang cập nhật danh mục môn học từ cơ sở dữ liệu...</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="subject-grid">
                                    <c:forEach var="sub" items="${portalData.subjects}">
                                        <div class="subject-card subject-theme-${sub.code != null ? sub.code.toLowerCase() : 'gen'}">
                                            <div>
                                                <c:if test="${not empty sub.imageUrl}">
                                                    <div class="subject-card-thumb">
                                                        <img src="<c:url value='${sub.imageUrl}' />" alt="<c:out value='${sub.name}' />" class="subject-card-img" />
                                                        <span class="subject-card-tag"><c:out value="${sub.name}" /></span>
                                                    </div>
                                                </c:if>

                                                <div class="subject-header-row">
                                                    <div class="subject-icon-box">
                                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                                            <c:choose>
                                                                <c:when test="${sub.code == 'MATH' || sub.code == 'MAT'}">
                                                                    <rect x="4" y="2" width="16" height="20" rx="2"></rect>
                                                                    <line x1="8" y1="6" x2="16" y2="6"></line>
                                                                    <line x1="16" y1="14" x2="16" y2="18"></line>
                                                                    <path d="M16 10h.01M12 10h.01M8 10h.01M12 14h.01M8 14h.01M12 18h.01M8 18h.01"></path>
                                                                </c:when>
                                                                <c:when test="${sub.code == 'PHYS' || sub.code == 'PHY'}">
                                                                    <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon>
                                                                </c:when>
                                                                <c:when test="${sub.code == 'CHEM' || sub.code == 'CHE'}">
                                                                    <path d="M10 2v7.527a2 2 0 0 1-.211.896L4.72 20.55a1 1 0 0 0 .9 1.45h12.76a1 1 0 0 0 .9-1.45l-5.069-10.127A2 2 0 0 1 14 9.527V2"></path>
                                                                    <line x1="8.5" y1="2" x2="15.5" y2="2"></line>
                                                                </c:when>
                                                                <c:when test="${sub.code == 'ENG'}">
                                                                    <circle cx="12" cy="12" r="10"></circle>
                                                                    <line x1="2" y1="12" x2="22" y2="12"></line>
                                                                    <path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path>
                                                                </c:when>
                                                                <c:when test="${sub.code == 'LIT'}">
                                                                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                                                                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"></path>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </svg>
                                                    </div>
                                                    <div>
                                                        <h3 class="subject-card-title"><c:out value="${sub.name}" /></h3>
                                                        <span class="subject-prog-counter-badge"><c:out value="${sub.courseCount}" /> chương trình đào tạo</span>
                                                    </div>
                                                </div>

                                                <p class="subject-card-desc"><c:out value="${sub.description}" /></p>

                                                <div class="subject-grades-badge">
                                                    <span class="subject-grade-pill">Lớp 10</span>
                                                    <span class="subject-grade-pill">Lớp 11</span>
                                                    <span class="subject-grade-pill highlight">Lớp 12 Ôn thi</span>
                                                </div>
                                            </div>

                                            <div class="subject-card-foot">
                                                <span class="subject-curriculum-label">Giáo trình chuẩn Bộ GD&ĐT</span>
                                                <a href="${pageContext.request.contextPath}/courses?keyword=<c:out value='${sub.name}' />" class="subject-explore-link">
                                                    <span>Khám phá môn học</span>
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>


                <!-- SECTION 05: CHƯƠNG TRÌNH GIA SƯ NỔI BẬT (DYNAMIC DATA FROM DB) -->
                <section class="portal-section bg-alt" id="khoa-hoc-noi-bat">
                    <div class="portal-container">
                        <div style="display: flex; flex-direction: column; md:flex-row; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; gap: 16px;">
                            <div>
                                <span class="section-tagline">Lịch Tuyển Sinh Hiện Tại</span>
                                <h2 class="section-heading">Chương trình gia sư nổi bật</h2>
                            </div>
                            <div style="display: flex; align-items: center; gap: 8px; font-size: var(--font-size-sm); color: var(--text-muted);">
                                <span style="width: 10px; height: 10px; border-radius: 50%; background-color: var(--success); display: inline-block;"></span>
                                <span>Sĩ số giới hạn để đảm bảo chất lượng tương tác</span>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty portalData.featuredCourses}">
                                <div class="card" style="text-align: center; padding: 48px;">
                                    <p class="text-muted">Hiện tại đang hoàn thiện lịch tuyển sinh các khóa học tiếp theo.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="course-grid">
                                    <c:forEach var="course" items="${portalData.featuredCourses}">
                                        <div class="course-card" data-course-grade="${course.gradeLevel}">
                                            <div>
                                                <!-- Dynamic Course Thumbnail from Database -->
                                                <div class="course-card-thumb">
                                                    <c:choose>
                                                        <c:when test="${not empty course.imageUrl}">
                                                            <img src="<c:url value='${course.imageUrl}' />" alt="<c:out value='${course.name}' />" class="course-card-img" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: var(--surface-muted); color: var(--primary);">
                                                                <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span class="course-card-thumb-tag">
                                                        <c:out value="${course.subjectName}" /> • Khối <c:out value="${course.gradeLevel}" />
                                                    </span>
                                                </div>

                                                <div class="course-card-top-badges">
                                                    <span class="course-model-pill"><c:out value="${course.modelText}" /></span>
                                                    <div style="display: flex; gap: 6px;">
                                                        <span class="grade-badge">Khối <c:out value="${course.gradeLevel}" /></span>
                                                        <span class="status-pill status-active">Đang tuyển sinh</span>
                                                    </div>
                                                </div>

                                                <h3 class="course-card-title">
                                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" style="color: inherit; text-decoration: none;">
                                                        <c:out value="${course.name}" />
                                                    </a>
                                                </h3>

                                                <div class="course-meta-row">
                                                    <div class="course-meta-item">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" style="color: var(--primary);" aria-hidden="true">
                                                            <circle cx="12" cy="12" r="10"></circle>
                                                            <polyline points="12 6 12 12 16 14"></polyline>
                                                        </svg>
                                                        <span><c:out value="${course.totalSessions}" /> buổi (<c:out value="${course.durationWeeks}" /> tuần)</span>
                                                    </div>
                                                    <div class="course-meta-item">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" style="color: var(--primary);" aria-hidden="true">
                                                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                                            <line x1="16" y1="2" x2="16" y2="6"></line>
                                                            <line x1="8" y1="2" x2="8" y2="6"></line>
                                                            <line x1="3" y1="10" x2="21" y2="10"></line>
                                                        </svg>
                                                        <span><c:out value="${course.scheduleText}" /></span>
                                                    </div>
                                                </div>

                                                <div class="course-teacher-box">
                                                    <div>
                                                        <span class="course-teacher-desc">Giáo viên phụ trách</span>
                                                        <span class="course-teacher-name"><c:out value="${course.teacherName}" /></span>
                                                        <span class="course-teacher-desc"><c:out value="${course.teacherTitle}" /></span>
                                                    </div>
                                                    <div style="text-align: right;">
                                                        <span class="course-teacher-desc">Học phí niêm yết</span>
                                                        <span class="course-fee-val"><c:out value="${course.formattedFee}" /></span>
                                                        <span class="course-teacher-desc">/ khóa học</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="course-card-foot">
                                                <a href="${pageContext.request.contextPath}/courses/detail?id=${course.id}" class="btn btn-secondary btn-sm">Xem chi tiết</a>
                                                <a href="#dang-ky-tu-van" class="btn btn-primary btn-sm">Đăng ký giữ chỗ</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <!-- SECTION 06: VÌ SAO CHỌN EDUCENTER? (6 Service Value Pillars) -->
                <section class="portal-section">
                    <div class="portal-container">
                        <div class="section-head text-center">
                            <span class="section-tagline">Cam Kết Năng Lực Học Thuật</span>
                            <h2 class="section-heading">Vì sao phụ huynh và học sinh THPT tin tưởng EduCenter?</h2>
                            <p class="section-desc">Chúng tôi vận hành hệ thống gia sư với tiêu chuẩn quản trị học tập chuyên nghiệp, minh bạch từng buổi học và đo lường sự tiến bộ bằng dữ liệu.</p>
                        </div>

                        <div class="pillar-grid">
                            <!-- Pillar 1 -->
                            <div class="pillar-card">
                                <div class="pillar-icon-box">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="4" y1="21" x2="4" y2="14"></line>
                                        <line x1="4" y1="10" x2="4" y2="3"></line>
                                        <line x1="12" y1="21" x2="12" y2="12"></line>
                                        <line x1="12" y1="8" x2="12" y2="3"></line>
                                        <line x1="20" y1="21" x2="20" y2="16"></line>
                                        <line x1="20" y1="12" x2="20" y2="3"></line>
                                        <line x1="1" y1="14" x2="7" y2="14"></line>
                                        <line x1="9" y1="8" x2="15" y2="8"></line>
                                        <line x1="17" y1="16" x2="23" y2="16"></line>
                                    </svg>
                                </div>
                                <h3 class="pillar-title">Lộ trình cá nhân hóa</h3>
                                <p class="pillar-desc">Thiết kế giáo án riêng biệt dựa trên kết quả bài kiểm tra đầu vào và năng lực thực tế của từng học sinh, không áp dụng một công thức chung.</p>
                            </div>

                            <!-- Pillar 2 -->
                            <div class="pillar-card">
                                <div class="pillar-icon-box">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <h3 class="pillar-title">Đội ngũ sư phạm chuẩn hóa</h3>
                                <p class="pillar-desc">100% giáo viên có bằng cử nhân/thạc sĩ sư phạm hoặc chuyên khoa từ các trường ĐH trọng điểm, phân công đúng chuyên môn giảng dạy.</p>
                            </div>

                            <!-- Pillar 3 -->
                            <div class="pillar-card">
                                <div class="pillar-icon-box">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                </div>
                                <h3 class="pillar-title">Minh bạch nhật ký & chuyên cần</h3>
                                <p class="pillar-desc">Báo cáo chi tiết nội dung đã học, thái độ tương tác và kết quả bài tập về nhà được gửi ngay sau mỗi buổi học đến phụ huynh.</p>
                            </div>

                            <!-- Pillar 4 -->
                            <div class="pillar-card">
                                <div class="pillar-icon-box">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                                        <line x1="16" y1="2" x2="16" y2="6"></line>
                                        <line x1="8" y1="2" x2="8" y2="6"></line>
                                        <line x1="3" y1="10" x2="21" y2="10"></line>
                                    </svg>
                                </div>
                                <h3 class="pillar-title">Quản lý lịch học khoa học</h3>
                                <p class="pillar-desc">Hỗ trợ đổi ca linh hoạt và bảo lưu buổi học khi học sinh bận lịch thi tại trường. Quy trình xếp lịch bù nhanh chóng và tiện lợi.</p>
                            </div>

                            <!-- Pillar 5 -->
                            <div class="pillar-card">
                                <div class="pillar-icon-box">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                </div>
                                <h3 class="pillar-title">Cổng Phụ Huynh (Parent Portal)</h3>
                                <p class="pillar-desc">Tra cứu lịch thi, điểm số định kỳ, biểu đồ tiến độ học lực và theo dõi biên lai học phí rõ ràng mọi lúc mọi nơi trên điện thoại.</p>
                            </div>

                            <!-- Pillar 6 -->
                            <div class="pillar-card">
                                <div class="pillar-icon-box">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polygon points="12 6 12 12 14 14"></polygon>
                                    </svg>
                                </div>
                                <h3 class="pillar-title">Đánh giá năng lực bài bản</h3>
                                <p class="pillar-desc">Bài kiểm tra chuẩn hóa trước khi nhập học để xác định chính xác lỗ hổng kiến thức và thiết lập mục tiêu điểm số khả thi trong từng giai đoạn.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 07: ĐỘI NGŨ GIA SƯ & GIÁO VIÊN NÒNG CỐT (DYNAMIC DATA FROM DB) -->
                <section class="portal-section bg-alt" id="doi-ngu">
                    <div class="portal-container">
                        <div style="display: flex; flex-direction: column; md:flex-row; justify-content: space-between; align-items: flex-start; margin-bottom: 36px; gap: 16px;">
                            <div>
                                <div class="hero-pill-badge" style="margin-bottom: 10px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                    <span>Ban Cố Vấn Học Thuật</span>
                                </div>
                                <h2 class="section-heading">Đội ngũ giáo viên nòng cốt</h2>
                                <p class="section-desc">100% giáo viên tốt nghiệp cử nhân, thạc sĩ sư phạm các trường đại học trọng điểm, phân công đúng chuyên môn bồi dưỡng.</p>
                            </div>
                            <a href="#dang-ky-tu-van" class="btn btn-secondary btn-sm" style="align-self: flex-start;">
                                <span>Yêu cầu chọn giáo viên</span>
                                <svg class="icon icon-sm" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                            </a>
                        </div>

                        <c:choose>
                            <c:when test="${empty portalData.facultyTeachers}">
                                <div class="card" style="text-align: center; padding: 48px;">
                                    <p class="text-muted">Đang tải hồ sơ giảng viên từ hệ thống...</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="teacher-grid">
                                    <c:forEach var="t" items="${portalData.facultyTeachers}">
                                        <div class="teacher-card">
                                            <div>
                                                <div class="teacher-avatar-box">
                                                    <c:choose>
                                                        <c:when test="${not empty t.photoUrl}">
                                                            <img src="<c:url value='${t.photoUrl}' />" alt="<c:out value='${t.fullName}' />" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <svg class="icon icon-xl" viewBox="0 0 24 24" style="color: var(--primary);" aria-hidden="true">
                                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                                                <circle cx="12" cy="7" r="4"></circle>
                                                            </svg>
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <span class="teacher-verified-badge" title="Giảng viên đã qua xác thực sư phạm">
                                                        <svg class="icon icon-xs" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path><polyline points="9 12 11 14 15 10"></polyline></svg>
                                                        <span>Đã kiểm duyệt</span>
                                                    </span>

                                                    <c:if test="${not empty t.experienceBadge}">
                                                        <span class="teacher-exp-tag"><c:out value="${t.experienceBadge}" /></span>
                                                    </c:if>
                                                </div>

                                                <h3 class="teacher-name"><c:out value="${t.fullName}" /></h3>
                                                <div class="teacher-degree-row">
                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" style="color: var(--primary);"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                                    <span class="teacher-role-tag"><c:out value="${t.degree}" /></span>
                                                </div>
                                                <p class="teacher-bio"><c:out value="${t.bio}" /></p>
                                            </div>
                                            <div class="teacher-grades-footer">
                                                <span class="teacher-spec-label">Chuyên môn:</span>
                                                <span><c:out value="${t.specialization}" /></span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <!-- SECTION 08: QUY TRÌNH 4 BƯỚC BẮT ĐẦU HỌC (Timeline/Stepper) -->
                <section class="portal-section" id="quy-trinh">
                    <div class="portal-container">
                        <div class="section-head text-center">
                            <span class="section-tagline">Quy Trình Chuẩn Hóa</span>
                            <h2 class="section-heading">4 bước bắt đầu học cùng EduCenter</h2>
                            <p class="section-desc">Đơn giản, minh bạch và đảm bảo đúng năng lực học sinh trước khi chính thức xếp lịch học.</p>
                        </div>

                        <div class="stepper-grid">
                            <!-- Step 1 -->
                            <div class="step-card">
                                <div class="step-header">
                                    <span class="step-number">01</span>
                                    <span class="step-icon">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                    </span>
                                </div>
                                <h3 class="step-title">Chọn khối lớp & Môn học</h3>
                                <p class="step-desc">Xác định rõ khối lớp (10, 11 hoặc 12) cùng các môn học cần củng cố kiến thức hoặc bồi dưỡng nâng cao điểm số.</p>
                            </div>

                            <!-- Step 2 -->
                            <div class="step-card">
                                <div class="step-header">
                                    <span class="step-number">02</span>
                                    <span class="step-icon">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                    </span>
                                </div>
                                <h3 class="step-title">Gửi thông tin nhu cầu</h3>
                                <p class="step-desc">Điền biểu mẫu liên hệ với hình thức mong muốn (gia sư kèm 1:1 hoặc nhóm nhỏ) và mục tiêu điểm số kỳ vọng.</p>
                            </div>

                            <!-- Step 3 -->
                            <div class="step-card">
                                <div class="step-header">
                                    <span class="step-number">03</span>
                                    <span class="step-icon">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                    </span>
                                </div>
                                <h3 class="step-title">Kiểm tra đầu vào miễn phí</h3>
                                <p class="step-desc">Học sinh thực hiện bài test chuẩn hóa 45 phút để đánh giá đúng năng lực thực tế và nhận tư vấn giáo trình chi tiết.</p>
                            </div>

                            <!-- Step 4 -->
                            <div class="step-card">
                                <div class="step-header">
                                    <span class="step-number">04</span>
                                    <span class="step-icon">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    </span>
                                </div>
                                <h3 class="step-title">Xếp lịch & Khởi động</h3>
                                <p class="step-desc">Xác nhận thời khóa biểu, kích hoạt tài khoản Cổng Phụ Huynh và bắt đầu buổi học đầu tiên với giáo viên được chỉ định.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 09: CỔNG THEO DÕI TIẾN ĐỘ HỌC TẬP (Parent Portal Mockup Showcase) -->
                <section class="portal-section bg-alt" id="hoc-phi">
                    <div class="portal-container">
                        <div class="parent-portal-grid">
                            <!-- Left: Feature Copy -->
                            <div>
                                <span class="section-tagline">Hệ Thống Quản Trị Trực Tuyến</span>
                                <h2 class="section-heading">Cổng thông tin phụ huynh & học sinh minh bạch từng buổi</h2>
                                <p class="section-desc">Không còn nỗi lo con em học tập thiếu tập trung hay không nắm bắt được bài giảng. Mọi dữ liệu học tập đều được số hóa chuẩn xác theo thời gian thực.</p>

                                <div class="portal-feature-list">
                                    <div class="portal-feature-item">
                                        <span class="portal-check-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        </span>
                                        <div>
                                            <h4>Điểm danh & Báo cáo tức thì</h4>
                                            <p>Thông báo chuyên cần và nhật ký giảng dạy ngay sau khi kết thúc buổi học qua SMS/Email.</p>
                                        </div>
                                    </div>

                                    <div class="portal-feature-item">
                                        <span class="portal-check-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        </span>
                                        <div>
                                            <h4>Biểu đồ tiến độ điểm số</h4>
                                            <p>Trực quan hóa xu hướng kết quả qua từng bài kiểm tra 15 phút, 1 tiết và thi thử định kỳ.</p>
                                        </div>
                                    </div>

                                    <div class="portal-feature-item">
                                        <span class="portal-check-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                        </span>
                                        <div>
                                            <h4>Hóa đơn điện tử & Học phí rõ ràng</h4>
                                            <p>Tra cứu biên lai thu phí, số buổi còn lại và lịch bù chi tiết không mập mờ phát sinh.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right: Simulated Browser Window -->
                            <div>
                                <div class="browser-mockup">
                                    <div class="browser-bar">
                                        <div class="browser-dots">
                                            <span class="dot red"></span>
                                            <span class="dot yellow"></span>
                                            <span class="dot green"></span>
                                            <span class="browser-url">portal.educenter.vn/parent/student/12</span>
                                        </div>
                                        <span style="font-size: 11px; font-weight: 600; color: var(--text-muted);">Cổng Phụ Huynh Học Sinh</span>
                                    </div>

                                    <div class="browser-content">
                                        <div class="portal-mini-kpis">
                                            <div class="portal-kpi-box">
                                                <span>Điểm TB đợt 1</span>
                                                <strong class="primary">8.4 / 10</strong>
                                            </div>
                                            <div class="portal-kpi-box">
                                                <span>Số buổi tham gia</span>
                                                <strong>22/24 buổi</strong>
                                            </div>
                                            <div class="portal-kpi-box">
                                                <span>Trạng thái học phí</span>
                                                <strong class="success" style="font-size: 13px;">Đã thanh toán</strong>
                                            </div>
                                        </div>

                                        <!-- Lesson Logs Table Snippet -->
                                        <div style="background-color: var(--surface-muted); border-radius: var(--radius-md); overflow: hidden; border: 1px solid var(--border);">
                                            <div style="padding: 10px 14px; background-color: var(--surface-hover); display: flex; justify-content: space-between; font-size: 12px; font-weight: 700; color: var(--text);">
                                                <span>Nhật ký 3 buổi gần nhất</span>
                                                <span style="color: var(--primary);">Xem tất cả &rarr;</span>
                                            </div>
                                            <div style="font-size: 12px;">
                                                <div style="padding: 10px 14px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                                                    <div>
                                                        <strong style="display: block; color: var(--text);">Buổi 22: Tích phân & Ứng dụng tính diện tích</strong>
                                                        <span style="color: var(--text-muted); font-size: 11px;">18:00 - 19:30 • ThS. Đặng Vũ Nam</span>
                                                    </div>
                                                    <span class="status-pill status-active">Có mặt</span>
                                                </div>
                                                <div style="padding: 10px 14px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                                                    <div>
                                                        <strong style="display: block; color: var(--text);">Buổi 21: Kiểm tra định kỳ Chuyên đề Nguyên hàm</strong>
                                                        <span style="color: var(--text-muted); font-size: 11px;">18:00 - 19:30 • Điểm số: 8.8 / 10</span>
                                                    </div>
                                                    <span class="status-pill status-active">Đạt 8.8 đ</span>
                                                </div>
                                                <div style="padding: 10px 14px; display: flex; justify-content: space-between; align-items: center;">
                                                    <div>
                                                        <strong style="display: block; color: var(--text);">Buổi 20: Phương pháp đổi biến số & từng phần</strong>
                                                        <span style="color: var(--text-muted); font-size: 11px;">18:00 - 19:30 • Làm bài tập 100%</span>
                                                    </div>
                                                    <span class="status-pill status-active">Hoàn thành</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 10: CÂU HỎI THƯỜNG GẶP (Accordion FAQ) -->
                <section class="portal-section" id="faq">
                    <div class="portal-container">
                        <div class="section-head text-center">
                            <span class="section-tagline">Giải Đáp Thắc Mắc</span>
                            <h2 class="section-heading">Câu hỏi thường gặp</h2>
                            <p class="section-desc">Tổng hợp thông tin quan trọng dành cho phụ huynh và học sinh trước khi tham gia học.</p>
                        </div>

                        <div class="faq-list">
                            <!-- FAQ 1 -->
                            <div class="faq-item">
                                <button type="button" class="faq-question-btn" onclick="toggleFaq(this)">
                                    <span>EduCenter tập trung hỗ trợ những khối lớp nào?</span>
                                    <svg class="icon icon-sm faq-icon-arrow" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <div class="faq-answer">
                                    Các chương trình bồi dưỡng và luyện thi được phân theo môn học, khối lớp và mục tiêu. Xem các khối lớp đang mở trong danh mục khóa học để chọn chương trình phù hợp.
                                </div>
                            </div>

                            <!-- FAQ 2 -->
                            <div class="faq-item">
                                <button type="button" class="faq-question-btn" onclick="toggleFaq(this)">
                                    <span>Trung tâm có hình thức gia sư 1 kèm 1 không?</span>
                                    <svg class="icon icon-sm faq-icon-arrow" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <div class="faq-answer">
                                    Có. EduCenter tổ chức 2 mô hình linh hoạt: Gia sư kèm riêng 1 kèm 1 (thiết kế giáo án chuyên sâu theo đúng tốc độ học của học sinh) và Lớp gia sư nhóm nhỏ giới hạn 10-15 học viên để duy trì tính tương tác phản xạ và tiết kiệm chi phí.
                                </div>
                            </div>

                            <!-- FAQ 3 -->
                            <div class="faq-item">
                                <button type="button" class="faq-question-btn" onclick="toggleFaq(this)">
                                    <span>Phụ huynh làm thế nào để theo dõi việc học của con?</span>
                                    <svg class="icon icon-sm faq-icon-arrow" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <div class="faq-answer">
                                    Mỗi phụ huynh được cấp một tài khoản Cổng Phụ Huynh (Parent Portal) để theo dõi điểm danh từng buổi, đọc nhật ký đánh giá của giáo viên bộ môn, xem biểu đồ điểm kiểm tra định kỳ và hóa đơn học phí minh bạch trên điện thoại.
                                </div>
                            </div>

                            <!-- FAQ 4 -->
                            <div class="faq-item">
                                <button type="button" class="faq-question-btn" onclick="toggleFaq(this)">
                                    <span>Có được làm bài kiểm tra đánh giá năng lực đầu vào không?</span>
                                    <svg class="icon icon-sm faq-icon-arrow" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <div class="faq-answer">
                                    Hoàn toàn miễn phí. Tất cả học sinh đăng ký đều thực hiện bài đánh giá kiến thức 45 phút để chuyên viên học vụ và giáo viên xác định chính xác năng lực khởi điểm trước khi đề xuất lộ trình phù hợp nhất.
                                </div>
                            </div>

                            <!-- FAQ 5 -->
                            <div class="faq-item">
                                <button type="button" class="faq-question-btn" onclick="toggleFaq(this)">
                                    <span>Học phí được thanh toán theo hình thức nào?</span>
                                    <svg class="icon icon-sm faq-icon-arrow" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <div class="faq-answer">
                                    Học phí được thanh toán theo từng khóa học (thường là 20-24 buổi) hoặc phân kỳ linh hoạt theo tháng qua chuyển khoản ngân hàng, có xuất hóa đơn điện tử và biên lai nội bộ rõ ràng qua hệ thống portal.
                                </div>
                            </div>

                            <!-- FAQ 6 -->
                            <div class="faq-item">
                                <button type="button" class="faq-question-btn" onclick="toggleFaq(this)">
                                    <span>Học sinh có thể đổi lịch hoặc xin học bù khi bận việc đột xuất không?</span>
                                    <svg class="icon icon-sm faq-icon-arrow" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                </button>
                                <div class="faq-answer">
                                    Có. Học sinh hoặc phụ huynh chỉ cần thông báo trước tối thiểu 24 giờ qua bộ phận giáo vụ. Trung tâm sẽ hỗ trợ xếp buổi học bù cùng giáo viên hoặc ghép ca tương đương để đảm bảo không bị gián đoạn kiến thức.
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- SECTION 11: FINAL CTA & FORM TƯ VẤN (CRM Lead Generation - REAL SUBMIT) -->
                <section class="portal-section bg-alt" id="dang-ky-tu-van">
                    <div class="portal-container">
                        <div class="lead-split-wrapper">
                            <!-- Left Side: Trust Assurances & Value Proposition -->
                            <div class="lead-benefits-sidebar">
                                <div class="hero-pill-badge" style="margin-bottom: 14px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                    </svg>
                                    <span>Tư Vấn Học Vụ Chuyên Sâu</span>
                                </div>

                                <h2 class="lead-sidebar-heading">Xây dựng lộ trình học tập tối ưu ngay hôm nay</h2>
                                <p class="lead-sidebar-sub">Để lại thông tin để chuyên viên học vụ EduCenter liên hệ tư vấn giải pháp củng cố kiến thức và bứt phá điểm số cho học sinh.</p>

                                <div class="lead-guarantee-list">
                                    <div class="lead-guarantee-item">
                                        <div class="lead-guarantee-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path><polyline points="9 12 11 14 15 10"></polyline></svg>
                                        </div>
                                        <div>
                                            <strong>100% Miễn phí kiểm tra năng lực</strong>
                                            <p>Bài test 45 phút chuẩn hóa để xác định chính xác năng lực thực tế trước khi xếp lớp.</p>
                                        </div>
                                    </div>

                                    <div class="lead-guarantee-item">
                                        <div class="lead-guarantee-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
                                        </div>
                                        <div>
                                            <strong>Lộ trình cá nhân hóa theo năng lực</strong>
                                            <p>Giáo án thiết kế riêng dựa trên điểm xuất phát và mục tiêu điểm số kỳ thi của học sinh.</p>
                                        </div>
                                    </div>

                                    <div class="lead-guarantee-item">
                                        <div class="lead-guarantee-icon">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                                        </div>
                                        <div>
                                            <strong>Cam kết bứt phá điểm số sau 12 tuần</strong>
                                            <p>Cải thiện từ 1.5 - 2.5 điểm số bài kiểm tra học kỳ với phương pháp học tập khoa học.</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="lead-support-contact">
                                    <div class="support-avatar-group">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" style="color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        <span>Thời gian phản hồi: <strong>Trong vòng 15 phút</strong> (Giờ hành chính)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Side: The Form Card -->
                            <div class="lead-form-container">
                                <div class="lead-form-card">
                                    <!-- Flash Toast Alerts -->
                                    <c:if test="${not empty sessionScope.alertMessage}">
                                        <div class="alert alert-${sessionScope.alertType != null ? sessionScope.alertType : 'info'}" style="margin-bottom: 20px;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                <c:choose>
                                                    <c:when test="${sessionScope.alertType == 'success'}">
                                                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <circle cx="12" cy="12" r="10"></circle>
                                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                                    </c:otherwise>
                                                </c:choose>
                                            </svg>
                                            <span><c:out value="${sessionScope.alertMessage}" /></span>
                                        </div>
                                        <c:remove var="alertMessage" scope="session" />
                                        <c:remove var="alertType" scope="session" />
                                    </c:if>

                                    <form action="${pageContext.request.contextPath}/dang-ky-tu-van" method="POST" id="lead-consultation-form">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                                        <div class="form-row-2">
                                            <div class="portal-form-group">
                                                <label for="lead-fullname">Họ tên Phụ huynh / Học sinh <span class="required">*</span></label>
                                                <input type="text" id="lead-fullname" name="fullName" value="<c:out value='${leadDraft.fullName}'/>" maxlength="150" class="portal-input" placeholder="Ví dụ: Nguyễn Văn Hùng" required>
                                            </div>
                                            <div class="portal-form-group">
                                                <label for="lead-phone">Số điện thoại liên hệ <span class="required">*</span></label>
                                                <input type="tel" id="lead-phone" name="phone" value="<c:out value='${leadDraft.phone}'/>" class="portal-input" pattern="0[35789][0-9]{8}" placeholder="Ví dụ: 0988123456" required>
                                            </div>
                                        </div>

                                        <div class="form-row-3">
                                            <div class="portal-form-group">
                                                <label for="lead-grade">Khối lớp học <span class="required">*</span></label>
                                                <select id="lead-grade" name="gradeLevel" class="portal-select" required>
                                                    <option value="">Chọn khối lớp</option>
                                                    <c:forEach var="grade" items="${availableGrades}"><option value="${grade}" ${leadDraft.gradeLevel == grade ? 'selected' : ''}>Lớp <c:out value="${grade}"/></option></c:forEach>
                                                </select>
                                            </div>

                                            <div class="portal-form-group">
                                                <label for="lead-subject">Môn học trọng tâm <span class="required">*</span></label>
                                                <select id="lead-subject" name="subject" class="portal-select" required>
                                                    <option value="">Chọn môn học</option>
                                                    <c:forEach var="subject" items="${portalSubjects}"><option value="<c:out value='${subject.name}'/>" ${leadDraft.subject == subject.name ? 'selected' : ''}><c:out value="${subject.name}"/></option></c:forEach>
                                                </select>
                                            </div>

                                            <div class="portal-form-group">
                                                <label for="lead-model">Hình thức học <span class="required">*</span></label>
                                                <select id="lead-model" name="learningModel" class="portal-select" required>
                                                    <option value="Lớp nhóm">Lớp nhóm</option>
                                                    <option value="Gia sư 1 kèm 1 cá nhân hóa">Gia sư 1 kèm 1 cá nhân hóa</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="portal-form-group" style="margin-bottom: 20px;">
                                            <label for="lead-notes">Mục tiêu học tập hoặc tình trạng hiện tại</label>
                                            <textarea id="lead-notes" name="notes" class="portal-textarea" maxlength="3000" rows="2" placeholder="Ví dụ: Đang bị hổng kiến thức Hình không gian Lớp 11, cần mục tiêu 8.0 môn Toán thi THPT Quốc gia..."><c:out value="${leadDraft.notes}"/></textarea>
                                        </div>

                                        <button type="submit" class="portal-submit-btn" id="lead-submit-btn">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                <line x1="22" y1="2" x2="11" y2="13"></line>
                                                <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                                            </svg>
                                            <span>Gửi thông tin đăng ký tư vấn</span>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <!-- FOOTER -->
            <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>

            <script src="${pageContext.request.contextPath}/assets/js/portal-carousel.js"></script>
            <script>
                function toggleFaq(btn) {
                    const item = btn.closest('.faq-item');
                    const isOpen = item.classList.contains('open');

                    // Close all FAQs
                    document.querySelectorAll('.faq-item').forEach(el => el.classList.remove('open'));

                    // Toggle current
                    if (!isOpen) {
                        item.classList.add('open');
                    }
                }

            </script>
</c:otherwise>
    </c:choose>
</body>
</html>
