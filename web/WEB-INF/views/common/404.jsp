<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="404 - Không Tìm Thấy Trang | EduCenter" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="error-shell">
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <main class="error-main">
        <div class="error-container">
            <div class="error-card">
                <!-- Subtle Ambient Backdrop Accent -->
                <div class="error-ambient-accent" aria-hidden="true"></div>

                <!-- Top System Indicator Badge -->
                <div class="error-status-badge">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted);">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <span>Mã lỗi HTTP 404 • Trang không tồn tại</span>
                </div>

                <!-- Massive Error Digits Display with Code Overlay -->
                <div class="error-massive-num-wrap">
                    <span class="error-massive-num">404</span>
                    <div class="error-icon-overlay">
                        <span class="error-code-badge">ERR_RESOURCE_NOT_FOUND</span>
                    </div>
                </div>

                <!-- Core Messaging -->
                <h1 class="error-heading">Không tìm thấy trang bạn đang tìm kiếm</h1>
                <p class="error-desc">
                    Trang này có thể đã được di chuyển, đổi đường dẫn hoặc tạm thời không khả dụng. Vui lòng kiểm tra lại địa chỉ hoặc điều hướng tới các chương trình gia sư THPT đang hoạt động.
                </p>

                <!-- Quick Navigation Directory Card -->
                <div class="error-dir-card">
                    <div class="error-dir-header">
                        <div class="error-dir-title">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                <polygon points="3 11 22 2 13 21 11 13 3 11"></polygon>
                            </svg>
                            <span>Các liên kết hữu ích cho học sinh & phụ huynh THPT:</span>
                        </div>
                        <span class="badge" style="font-size: 10px; text-transform: uppercase; letter-spacing: 0.05em;">Hệ thống</span>
                    </div>

                    <div class="error-dir-list">
                        <a href="${pageContext.request.contextPath}/#chuong-trinh" class="error-dir-item">
                            <div class="error-dir-item-left">
                                <span class="error-dir-dot" style="background-color: var(--primary);"></span>
                                <span style="font-weight: 550;">Chương trình gia sư Lớp 10, 11, 12 (Toán, Văn, Anh, Lý, Hóa, Sinh)</span>
                            </div>
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted);">
                                <polyline points="9 18 15 12 9 6"></polyline>
                            </svg>
                        </a>

                        <a href="${pageContext.request.contextPath}/#dang-ky-tu-van" class="error-dir-item">
                            <div class="error-dir-item-left">
                                <span class="error-dir-dot" style="background-color: #0d9488;"></span>
                                <span style="font-weight: 550;">Cổng thông tin tuyển sinh & Đăng ký đánh giá năng lực</span>
                            </div>
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted);">
                                <polyline points="9 18 15 12 9 6"></polyline>
                            </svg>
                        </a>

                        <a href="${pageContext.request.contextPath}/#cong-phu-huynh" class="error-dir-item">
                            <div class="error-dir-item-left">
                                <span class="error-dir-dot" style="background-color: #d97706;"></span>
                                <span style="font-weight: 550;">Cổng phụ huynh & học sinh (Tra cứu lịch học & điểm thi)</span>
                            </div>
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted);">
                                <polyline points="9 18 15 12 9 6"></polyline>
                            </svg>
                        </a>
                    </div>
                </div>

                <!-- Quick Search Assist Bar -->
                <form action="${pageContext.request.contextPath}/" method="get" class="error-search-bar" onsubmit="window.location.href='${pageContext.request.contextPath}/#chuong-trinh'; return false;">
                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--text-muted); margin-left: 4px;">
                        <circle cx="11" cy="11" r="8"></circle>
                        <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                    </svg>
                    <input type="text" class="error-search-input" placeholder="Tìm khóa học, phòng luyện thi hoặc mã lớp..." id="error-search-input">
                    <button type="submit" class="btn btn-secondary btn-sm" style="white-space: nowrap;">Tìm kiếm</button>
                </form>

                <!-- Primary & Secondary Interactive Action CTAs -->
                <div class="error-actions">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                        </svg>
                        <span>Về trang chủ</span>
                    </a>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/#chuong-trinh">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                            <path d="M6 6h10"></path>
                            <path d="M6 10h10"></path>
                        </svg>
                        <span>Khám phá chương trình gia sư</span>
                    </a>
                </div>

                <!-- Minimal Subtle History Return Trigger -->
                <div style="margin-top: 20px;">
                    <button class="btn btn-ghost btn-sm" onclick="window.history.length > 1 ? window.history.back() : window.location.href='${pageContext.request.contextPath}/';" type="button">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Quay lại trang trước</span>
                    </button>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>
</body>
</html>
