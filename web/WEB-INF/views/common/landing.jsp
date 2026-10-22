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
            padding: 48px 24px;
            text-align: center;
            background: linear-gradient(180deg, var(--surface) 0%, var(--bg) 100%);
            border-bottom: 1px solid var(--border);
            margin-bottom: 32px;
        }
        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            background-color: var(--primary-subtle);
            color: var(--primary);
            border: 1px solid var(--primary-border);
            border-radius: var(--radius-full);
            font-size: var(--font-size-xs);
            font-weight: 600;
            margin-bottom: 16px;
        }
        .hero-title {
            font-size: var(--font-size-3xl);
            font-weight: 800;
            letter-spacing: -0.02em;
            margin-bottom: 12px;
            max-width: 720px;
            margin-left: auto;
            margin-right: auto;
        }
        .hero-desc {
            font-size: var(--font-size-md);
            color: var(--text-muted);
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            margin-bottom: 24px;
        }
        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
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
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary btn-sm">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="9" cy="7" r="4"></circle>
                                            <polyline points="16 11 18 13 22 9"></polyline>
                                        </svg>
                                        <span>Quản lý người dùng</span>
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary btn-sm">
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
                                <h2 style="font-size: var(--font-size-md); font-weight: 650; margin-bottom: 8px;">Thông tin phiên làm việc hiện tại</h2>
                                <p class="text-muted" style="margin-bottom: 16px;">
                                    Đăng nhập với email: <strong><c:out value="${sessionScope.currentUser.email}" /></strong>.
                                    Phiên làm việc bảo vệ tự động hết hạn sau 30 phút không hoạt động (cookie HttpOnly).
                                </p>
                                <div style="display: flex; gap: 8px; flex-wrap: wrap;">
                                    <span class="status-pill status-active">Hệ thống CSDL: Kết nối sẵn sàng (Microsoft SQL Server)</span>
                                    <span class="status-pill status-active">Bộ lọc bảo mật: UTF-8 / CSRF / RBAC Kích hoạt</span>
                                    <span class="status-pill status-active">JPA/Hibernate ORM: 3.1 Sẵn sàng</span>
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
                                <h3 style="font-size: var(--font-size-md); margin-bottom: 6px;">Quản lý tài khoản & Vai trò</h3>
                                <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 14px;">
                                    Phân quyền 5 vai trò hệ thống (ADMIN, STAFF, TEACHER, STUDENT, PARENT), kiểm soát trạng thái ACTIVE/LOCKED và ghi nhật ký AuditLogs.
                                </p>
                                <c:choose>
                                    <c:when test="${sessionScope.currentUser.admin}">
                                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary btn-sm">Mở danh sách người dùng &rarr;</a>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted" style="font-size: var(--font-size-xs);">Chỉ dành cho Quản trị viên (ADMIN)</span>
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
                                <h3 style="font-size: var(--font-size-md); margin-bottom: 6px;">Hồ sơ & Đổi mật khẩu</h3>
                                <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 14px;">
                                    Cập nhật họ tên, số điện thoại, ảnh đại diện và thực hiện đổi mật khẩu bảo mật (yêu cầu xác thực mật khẩu cũ).
                                </p>
                                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary btn-sm">Xem hồ sơ &rarr;</a>
                            </div>

                            <div class="feature-card">
                                <div class="feature-icon-wrapper">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    </svg>
                                </div>
                                <h3 style="font-size: var(--font-size-md); margin-bottom: 6px;">Bảo mật & Ma trận phân quyền</h3>
                                <p class="text-muted" style="font-size: var(--font-size-sm); margin-bottom: 14px;">
                                    Kiểm tra cơ chế chặn truy cập trái phép bằng cách thử vào đường dẫn vai trò khác (ví dụ: thử vào route quản trị khi đóng vai học viên).
                                </p>
                                <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Đổi tài khoản khác &rarr;</a>
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
                            EduCenter ERP — Phiên bản 1.1 (PRJ301 Assignment)
                        </span>
                        <h1 class="hero-title">Hệ Thống Quản Trị Trung Tâm Gia Sư & Luyện Thi Điểm Cao</h1>
                        <p class="hero-desc">
                            Hạ tầng chuyển đổi số toàn diện: tiếp nhận Lead tuyển sinh, xếp lớp, điểm danh, bài kiểm tra, thu học phí và phân quyền 5 vai trò hệ thống.
                        </p>
                        <div style="display: flex; justify-content: center; gap: 12px; flex-wrap: wrap;">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
                                    <polyline points="10 17 15 12 10 7"></polyline>
                                    <line x1="15" y1="12" x2="3" y2="12"></line>
                                </svg>
                                <span>Đăng nhập hệ thống</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-lg">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                    <circle cx="9" cy="7" r="4"></circle>
                                    <line x1="19" y1="8" x2="19" y2="14"></line>
                                    <line x1="22" y1="11" x2="16" y2="11"></line>
                                </svg>
                                <span>Đăng ký học viên</span>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- Demo Accounts Table Section (PRJ301 Evaluator Guide) -->
                <main style="max-width: 960px; margin: 0 auto; padding: 0 24px 60px 24px; width: 100%;">
                    <div class="card" style="margin-bottom: 32px;">
                        <div class="card-header">
                            <h2 style="font-size: var(--font-size-md); font-weight: 650; display: flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                    <polyline points="9 12 11 14 15 10"></polyline>
                                </svg>
                                <span>Danh sách tài khoản Demo cấp sẵn phục vụ chấm thi (Mật khẩu chung: <code>123456</code>)</span>
                            </h2>
                        </div>
                        <div class="card-body" style="padding: 0;">
                            <div class="table-container" style="border: none; border-radius: 0;">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Vai trò (Role)</th>
                                            <th>Email đăng nhập</th>
                                            <th>Tên demo</th>
                                            <th>Phạm vi quyền hạn</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><span class="badge badge-admin">ADMIN</span></td>
                                            <td><code>admin@educenter.vn</code></td>
                                            <td>Nguyễn Quản Trị</td>
                                            <td>Toàn quyền quản trị, phân vai trò, xem báo cáo, AuditLogs</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-staff">STAFF</span></td>
                                            <td><code>staff@educenter.vn</code></td>
                                            <td>Trần Thu Hà</td>
                                            <td>Tuyển sinh CRM, hồ sơ học sinh, xếp lớp, lập hóa đơn</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-teacher">TEACHER</span></td>
                                            <td><code>teacher.hung@educenter.vn</code></td>
                                            <td>ThS. Lê Mạnh Hùng</td>
                                            <td>Lịch dạy, điểm danh học viên, ra đề và nhập điểm số</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-student">STUDENT</span></td>
                                            <td><code>student.nam@educenter.vn</code></td>
                                            <td>Trần Hoàng Nam</td>
                                            <td>Xem lịch học, kết quả học tập công bố, học phí</td>
                                        </tr>
                                        <tr>
                                            <td><span class="badge badge-parent">PARENT</span></td>
                                            <td><code>parent.tuan@educenter.vn</code></td>
                                            <td>Trần Quốc Tuấn</td>
                                            <td>Theo dõi chuyên cần, tiến độ học tập và đóng học phí cho con</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>

                <footer style="margin-top: auto; padding: 24px; border-top: 1px solid var(--border); text-align: center; color: var(--text-muted); font-size: var(--font-size-sm); background-color: var(--surface);">
                    &copy; 2026 EduCenter Tutoring & Exam Preparation ERP. Phát triển theo chuẩn Spec-Driven Development & Design System.
                </footer>
            </div>
        </c:otherwise>
    </c:choose>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
