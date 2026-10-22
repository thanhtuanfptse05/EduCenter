<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
    <style>
        .hero-banner {
            padding: 64px 24px 48px;
            text-align: center;
            background: linear-gradient(180deg, var(--surface) 0%, var(--bg) 100%);
            border-bottom: 1px solid var(--border);
            margin-bottom: 40px;
        }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            background-color: var(--primary-subtle);
            color: var(--primary);
            border: 1px solid var(--primary-border);
            border-radius: var(--radius-full);
            font-size: var(--font-size-xs);
            font-weight: 600;
            margin-bottom: 20px;
            letter-spacing: 0.02em;
        }
        .hero-title {
            font-size: 36px;
            font-weight: 800;
            letter-spacing: -0.03em;
            line-height: 1.25;
            margin-bottom: 16px;
            max-width: 820px;
            margin-left: auto;
            margin-right: auto;
            color: var(--text);
        }
        .hero-desc {
            font-size: var(--font-size-md);
            color: var(--text-muted);
            max-width: 680px;
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 32px;
            line-height: 1.6;
        }
        .stats-strip {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            max-width: 1100px;
            margin: -20px auto 48px;
            padding: 0 20px;
        }
        .stat-card {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: var(--primary);
            letter-spacing: -0.02em;
            line-height: 1;
            margin-bottom: 6px;
        }
        .stat-label {
            font-size: var(--font-size-sm);
            color: var(--text-muted);
            font-weight: 500;
        }
        .section-header {
            text-align: center;
            margin-bottom: 36px;
        }
        .section-tag {
            font-size: var(--font-size-xs);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--primary);
            margin-bottom: 8px;
            display: inline-block;
        }
        .section-title {
            font-size: var(--font-size-2xl);
            font-weight: 750;
            color: var(--text);
            letter-spacing: -0.02em;
        }
        .program-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 24px;
            margin-bottom: 60px;
        }
        .program-card {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 28px;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            transition: all var(--transition-fast);
        }
        .program-card:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow-md);
            transform: translateY(-2px);
        }
        .program-badge {
            align-self: flex-start;
            padding: 3px 10px;
            border-radius: var(--radius-full);
            font-size: var(--font-size-xs);
            font-weight: 600;
            margin-bottom: 16px;
            background: var(--surface-muted);
            color: var(--text-muted);
        }
        .program-title {
            font-size: var(--font-size-lg);
            font-weight: 700;
            color: var(--text);
            margin-bottom: 8px;
        }
        .program-desc {
            font-size: var(--font-size-sm);
            color: var(--text-muted);
            line-height: 1.5;
            margin-bottom: 20px;
            flex: 1;
        }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }
        .feature-card {
            background-color: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            transition: transform var(--transition-fast), border-color var(--transition-fast);
        }
        .feature-card:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
        }
        .feature-icon-wrapper {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-md);
            background-color: var(--primary-subtle);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
        }
        .cta-banner {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-hover) 100%);
            color: #ffffff;
            border-radius: var(--radius-lg);
            padding: 48px 32px;
            text-align: center;
            margin-bottom: 60px;
            box-shadow: 0 10px 25px -5px rgba(37, 99, 235, 0.3);
        }
        .cta-title {
            font-size: var(--font-size-2xl);
            font-weight: 750;
            color: #ffffff;
            margin-bottom: 12px;
        }
        .cta-desc {
            font-size: var(--font-size-md);
            color: rgba(255, 255, 255, 0.9);
            max-width: 600px;
            margin: 0 auto 28px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
    <c:choose>
        <%-- Logged-In User Dashboard Landing (FR-008) --%>
        <c:when test="${not empty sessionScope.currentUser}">
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
                                    Phiên làm việc được bảo vệ bằng cơ chế xác thực kép và tự động gia hạn bảo mật.
                                </p>
                                <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                    <span class="status-pill status-active">Hệ thống CSDL: Trực tuyến</span>
                                    <span class="status-pill status-active">Mã hóa mật khẩu: BCrypt (SEC-01)</span>
                                    <span class="status-pill status-active">Kiểm soát truy cập: Phân quyền RBAC</span>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Action Navigation -->
                        <div class="feature-grid">
                            <div class="feature-card">
                                <div class="feature-icon-wrapper">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <polyline points="16 11 18 13 22 9"></polyline>
                                    </svg>
                                </div>
                                <h3 style="font-size: var(--font-size-md); margin-bottom: 6px;">Quản lý tài khoản & Phân quyền</h3>
                                <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 14px;">
                                    Quản trị viên có toàn quyền kiểm soát vai trò người dùng (ADMIN, STAFF, TEACHER, STUDENT, PARENT), kiểm soát trạng thái ACTIVE/LOCKED và truy vết Audit Logs.
                                </p>
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.admin}">
                                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">Mở danh sách người dùng &rarr;</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted" style="font-size: var(--font-size-xs);">Dành riêng cho Quản trị viên (ADMIN)</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="feature-card">
                                <div class="feature-icon-wrapper">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <circle cx="12" cy="12" r="3"></circle>
                                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
                                    </svg>
                                </div>
                                <h3 style="font-size: var(--font-size-md); margin-bottom: 6px;">Hồ sơ cá nhân & Bảo mật</h3>
                                <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 14px;">
                                    Cập nhật họ tên, số điện thoại, ảnh đại diện và thực hiện đổi mật khẩu tài khoản với kiểm tra bảo mật nghiêm ngặt.
                                </p>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary btn-sm">Xem hồ sơ &rarr;</a>
                            </div>

                            <div class="feature-card">
                                <div class="feature-icon-wrapper">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                </div>
                                <h3 style="font-size: var(--font-size-md); margin-bottom: 6px;">Đăng xuất & Bảo mật phiên</h3>
                                <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 14px;">
                                    Kết thúc phiên làm việc hiện tại, thu hồi token CSRF và đăng xuất an toàn khỏi thiết bị truy cập.
                                </p>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Đăng xuất tài khoản &rarr;</a>
                            </div>
                        </div>
                    </main>
                </div>
            </div>
        </c:when>

        <%-- Public Landing Page (Unauthenticated Guests) --%>
        <c:otherwise>
            <div style="min-height: 100vh; display: flex; flex-direction: column;">
                <%@ include file="/WEB-INF/views/common/header.jspf" %>

                <!-- Hero Section -->
                <section class="hero-banner">
                    <div style="max-width: 960px; margin: 0 auto; padding: 0 16px;">
                        <span class="hero-badge">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                <circle cx="12" cy="12" r="10"></circle>
                                <polyline points="12 6 12 12 16 14"></polyline>
                            </svg>
                            Tuyển sinh năm học mới • Bồi dưỡng văn hóa & Luyện thi chất lượng cao
                        </span>
                        <h1 class="hero-title">Nền Tảng Bồi Dưỡng Kiến Thức & Luyện Thi Hàng Đầu</h1>
                        <p class="hero-desc">
                            Hệ sinh thái giáo dục chuẩn mực: Lộ trình cá nhân hóa từ lớp 6 đến lớp 12, đội ngũ giáo viên trường chuyên và hệ thống quản trị chuyên cần, điểm số minh bạch theo thời gian thực.
                        </p>
                        <div style="display: flex; justify-content: center; gap: 12px; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg" style="padding: 12px 28px; font-size: var(--font-size-md);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <line x1="19" y1="8" x2="19" y2="14"></line>
                                    <line x1="22" y1="11" x2="16" y2="11"></line>
                                </svg>
                                <span>Đăng ký học viên mới</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-lg" style="padding: 12px 28px; font-size: var(--font-size-md);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                                    <polyline points="10 17 15 12 10 7"></polyline>
                                    <line x1="15" y1="12" x2="3" y2="12"></line>
                                </svg>
                                <span>Đăng nhập cổng học tập</span>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Statistics Strip -->
                <div class="stats-strip">
                    <div class="stat-card">
                        <div class="stat-number">98.6%</div>
                        <div class="stat-label">Học viên đỗ NV1 Trường chuyên & Đại học Top đầu</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">10,000+</div>
                        <div class="stat-label">Học viên tin tưởng theo học từ lớp 6 đến 12</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">150+</div>
                        <div class="stat-label">Thầy cô chuyên môn cao, thạc sĩ & thủ khoa</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">12+</div>
                        <div class="stat-label">Năm khẳng định uy tín & chất lượng đào tạo</div>
                    </div>
                </div>

                <!-- Main Content Area -->
                <main style="max-width: 1100px; margin: 0 auto; padding: 0 24px 60px 24px; width: 100%;">
                    <!-- Programs Section -->
                    <div class="section-header">
                        <span class="section-tag">Lộ trình học tập</span>
                        <h2 class="section-title">Chương Trình Đào Tạo Trọng Điểm</h2>
                    </div>

                    <div class="program-grid">
                        <div class="program-card">
                            <span class="program-badge">Lớp 9 &rarr; 10</span>
                            <h3 class="program-title">Luyện Thi Vào Lớp 10 Chuyên</h3>
                            <p class="program-desc">
                                Bồi dưỡng toàn diện Toán, Văn, Tiếng Anh và Khoa học tự nhiên bám sát cấu trúc tuyển sinh THPT Chuyên & Công lập trọng điểm.
                            </p>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-sm" style="margin-top: auto;">Đăng ký tư vấn &rarr;</a>
                        </div>

                        <div class="program-card">
                            <span class="program-badge">Lớp 12 & Ôn thi ĐH</span>
                            <h3 class="program-title">Luyện Thi Tốt Nghiệp THPT & ĐGNL</h3>
                            <p class="program-desc">
                                Chiến thuật giải đề thần tốc, nắm vững bản chất kiến thức, rèn luyện áp lực phòng thi cho kỳ thi Tốt nghiệp THPT và ĐGNL ĐHQG.
                            </p>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-sm" style="margin-top: auto;">Đăng ký tư vấn &rarr;</a>
                        </div>

                        <div class="program-card">
                            <span class="program-badge">Lớp 6 đến Lớp 12</span>
                            <h3 class="program-title">Bổ Trợ & Nâng Cao Văn Hóa</h3>
                            <p class="program-desc">
                                Bổ sung lỗ hổng kiến thức, bồi dưỡng học sinh giỏi các môn Toán, Lý, Hóa, Sinh, Ngữ Văn theo chương trình giáo dục mới.
                            </p>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-sm" style="margin-top: auto;">Đăng ký tư vấn &rarr;</a>
                        </div>

                        <div class="program-card">
                            <span class="program-badge">Chứng chỉ quốc tế</span>
                            <h3 class="program-title">Luyện Thi IELTS & SAT Digital</h3>
                            <p class="program-desc">
                                Lộ trình từ mất gốc đến Target 7.0+ IELTS và 1450+ SAT Digital cùng phương pháp tương tác học thuật chuyên sâu.
                            </p>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-sm" style="margin-top: auto;">Đăng ký tư vấn &rarr;</a>
                        </div>
                    </div>

                    <!-- Core Strengths Section -->
                    <div class="section-header">
                        <span class="section-tag">Cam kết chất lượng</span>
                        <h2 class="section-title">Tại Sao Phụ Huynh & Học Sinh Chọn EduCenter?</h2>
                    </div>

                    <div class="feature-grid">
                        <div class="feature-card">
                            <div class="feature-icon-wrapper">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"></path>
                                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"></path>
                                </svg>
                            </div>
                            <h3 style="font-size: var(--font-size-md); margin-bottom: 8px;">Giáo Trình Biên Soạn Độc Quyền</h3>
                            <p class="text-muted" style="font-size: var(--font-size-sm); line-height: 1.5;">
                                Hệ thống bài giảng và ngân hàng đề thi được cập nhật thường xuyên theo sát ma trận đề thi chuẩn của Bộ Giáo dục & Đào tạo.
                            </p>
                        </div>

                        <div class="feature-card">
                            <div class="feature-icon-wrapper">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <polyline points="12 6 12 12 14 14"></polyline>
                                </svg>
                            </div>
                            <h3 style="font-size: var(--font-size-md); margin-bottom: 8px;">Báo Cáo Tiến Độ Thời Gian Thực</h3>
                            <p class="text-muted" style="font-size: var(--font-size-sm); line-height: 1.5;">
                                Kết quả kiểm tra định kỳ, điểm danh chuyên cần và nhận xét của giáo viên được cập nhật trực tuyến tức thì đến phụ huynh.
                            </p>
                        </div>

                        <div class="feature-card">
                            <div class="feature-icon-wrapper">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                </svg>
                            </div>
                            <h3 style="font-size: var(--font-size-md); margin-bottom: 8px;">Lớp Học Quy Mô Chuẩn (15-20 HS)</h3>
                            <p class="text-muted" style="font-size: var(--font-size-sm); line-height: 1.5;">
                                Giữ sĩ số vàng giúp giáo viên theo sát từng học viên, phát hiện kịp thời lỗ hổng kiến thức và hỗ trợ gia sư kèm 1-1.
                            </p>
                        </div>

                        <div class="feature-card">
                            <div class="feature-icon-wrapper">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <h3 style="font-size: var(--font-size-md); margin-bottom: 8px;">Lịch Học Linh Hoạt & Đa Dạng</h3>
                            <p class="text-muted" style="font-size: var(--font-size-sm); line-height: 1.5;">
                                Hỗ trợ sắp xếp ca học thuận tiện cho học sinh chính khóa, có lớp học bù và hệ thống tài liệu ôn tập trực tuyến 24/7.
                            </p>
                        </div>
                    </div>

                    <!-- Call To Action -->
                    <div class="cta-banner">
                        <h2 class="cta-title">Sẵn Sàng Bứt Phá Điểm Số Trong Năm Học Mới?</h2>
                        <p class="cta-desc">
                            Đăng ký tham gia bài kiểm tra đánh giá năng lực đầu vào hoàn toàn miễn phí để được tư vấn lộ trình học tập tối ưu nhất!
                        </p>
                        <div style="display: flex; justify-content: center; gap: 12px; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-lg" style="background-color: #ffffff; color: var(--primary); font-weight: 700;">
                                <span>Đăng ký nhận tư vấn miễn phí</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-lg" style="color: #ffffff; border-color: rgba(255,255,255,0.6);">
                                <span>Đăng nhập hệ thống</span>
                            </a>
                        </div>
                    </div>
                </main>

                <!-- Professional Footer -->
                <footer style="margin-top: auto; padding: 48px 24px 32px; border-top: 1px solid var(--border); color: var(--text-muted); font-size: var(--font-size-sm); background-color: var(--surface);">
                    <div style="max-width: 1100px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 32px; margin-bottom: 32px; text-align: left;">
                        <div>
                            <div style="display: flex; align-items: center; gap: 8px; font-weight: 700; font-size: var(--font-size-md); color: var(--text); margin-bottom: 12px;">
                                <div style="width: 28px; height: 28px; background: var(--primary); border-radius: var(--radius-sm); display: flex; align-items: center; justify-content: center; color: #fff;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: #fff;">
                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                    </svg>
                                </div>
                                <span>EduCenter</span>
                            </div>
                            <p style="line-height: 1.6; font-size: var(--font-size-xs);">
                                Trung tâm bồi dưỡng văn hóa, luyện thi tuyển sinh lớp 10 và luyện thi Tốt nghiệp THPT chất lượng hàng đầu.
                            </p>
                        </div>
                        <div>
                            <div style="font-weight: 650; color: var(--text); margin-bottom: 12px;">Liên kết nhanh</div>
                            <div style="display: flex; flex-direction: column; gap: 8px; font-size: var(--font-size-xs);">
                                <a href="${pageContext.request.contextPath}/register">Đăng ký học viên</a>
                                <a href="${pageContext.request.contextPath}/login">Đăng nhập tài khoản</a>
                                <a href="${pageContext.request.contextPath}/forgot-password">Khôi phục mật khẩu</a>
                            </div>
                        </div>
                        <div>
                            <div style="font-weight: 650; color: var(--text); margin-bottom: 12px;">Cơ sở đào tạo</div>
                            <p style="line-height: 1.6; font-size: var(--font-size-xs); margin-bottom: 6px;">
                                <strong>Cơ sở 1:</strong> Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội.
                            </p>
                            <p style="line-height: 1.6; font-size: var(--font-size-xs);">
                                <strong>Cơ sở 2:</strong> Quận Cầu Giấy, TP. Hà Nội.
                            </p>
                        </div>
                        <div>
                            <div style="font-weight: 650; color: var(--text); margin-bottom: 12px;">Tổng đài hỗ trợ</div>
                            <p style="font-size: var(--font-size-md); font-weight: 750; color: var(--primary); margin-bottom: 6px;">
                                1900 6868 (8:00 - 21:00)
                            </p>
                            <p style="font-size: var(--font-size-xs);">
                                Email tiếp nhận: <strong>tuyensinh@educenter.vn</strong>
                            </p>
                        </div>
                    </div>
                    <div style="max-width: 1100px; margin: 0 auto; padding-top: 24px; border-top: 1px solid var(--border); text-align: center; font-size: var(--font-size-xs);">
                        &copy; 2026 EduCenter — Hệ Thống Quản Trị & Bồi Dưỡng Kiến Thức Trực Tuyến. Bản quyền thuộc về EduCenter.
                    </div>
                </footer>
            </div>
        </c:otherwise>
    </c:choose>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
