<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Đăng ký tài khoản — EduCenter Nền Tảng Đào Tạo & Tuyển Sinh" scope="request" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">
</head>
<body>
    <div class="auth-page-wrapper">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="auth-main-content">
            <div class="auth-register-grid">
                <!-- Main Registration Column (8 cols) -->
                <div class="register-main-col">
                    <!-- Stepper / Status Top bar -->
                    <div class="register-stepper-bar">
                        <div class="stepper-left">
                            <div class="stepper-num-badge">01</div>
                            <div>
                                <span class="stepper-sub">SRS AUTH-02 · Xác thực tài khoản</span>
                                <h1 class="stepper-title">Đăng ký thành viên hệ thống EduCenter</h1>
                            </div>
                        </div>
                        <div class="auth-pill-badge" style="color: var(--text-muted);">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                            <span>Bảo mật 256-bit SSL &amp; BR01 Validated</span>
                        </div>
                    </div>

                    <!-- Registration Form Card -->
                    <div class="register-form-card">
                        <!-- Role Selector (STUDENT or PARENT only per FR-001) -->
                        <div class="role-segmented-container">
                            <div class="role-segmented-header">
                                <span style="font-weight: 600; color: var(--text);">Vai trò đăng ký sử dụng <span class="required" style="color: var(--danger);">*</span></span>
                                <span style="color: var(--text-muted); font-size: var(--font-size-xs);">Chọn đối tượng tài khoản (Học sinh hoặc Phụ huynh)</span>
                            </div>
                            <div class="role-segmented-grid">
                                <!-- Role 1: Học sinh -->
                                <button type="button" class="role-segmented-btn active" data-role="STUDENT">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M22 10v6M2 10l10-5 10 5-10 5z"></path>
                                        <path d="M6 12v5c3 3 9 3 12 0v-5"></path>
                                    </svg>
                                    <div>
                                        <span class="role-btn-title">Học sinh THPT</span>
                                        <span class="role-btn-desc">Luyện thi, xem thời khóa biểu &amp; tra cứu điểm</span>
                                    </div>
                                </button>
                                <!-- Role 2: Phụ huynh -->
                                <button type="button" class="role-segmented-btn" data-role="PARENT">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="9" cy="7" r="4"></circle>
                                        <path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
                                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                    </svg>
                                    <div>
                                        <span class="role-btn-title">Phụ huynh</span>
                                        <span class="role-btn-desc">Giám sát chuyên cần, học bạ &amp; đối soát học phí</span>
                                    </div>
                                </button>
                            </div>
                        </div>

                        <!-- Alerts -->
                        <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                        <!-- Form Element -->
                        <form action="${pageContext.request.contextPath}/register" method="post" novalidate id="register-form">
                            <!-- CSRF Token -->
                            <input type="hidden" name="csrfToken" value="<c:out value='${csrfToken}' />">
                            <!-- Hidden Role Code (Updated by role-segmented-btn) -->
                            <input type="hidden" name="roleCode" id="roleCodeInput" value="STUDENT">

                            <!-- Row 1: Full Name & Phone Number -->
                            <div class="form-grid-2col">
                                <!-- Full Name -->
                                <div class="form-group">
                                    <label for="fullname" class="form-label">
                                        Họ và tên <span class="required" style="color: var(--danger);">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
                                            <circle cx="12" cy="7" r="4"></circle>
                                        </svg>
                                        <input type="text" id="fullname" name="fullName" class="form-control"
                                               placeholder="Nguyễn Văn An" required
                                               value="<c:out value='${not empty sessionScope.preserved_fullName ? sessionScope.preserved_fullName : ""}' />">
                                    </div>
                                    <c:remove var="preserved_fullName" scope="session" />
                                </div>

                                <!-- Phone Number -->
                                <div class="form-group">
                                    <label for="phone" class="form-label">
                                        Số điện thoại liên hệ <span class="required" style="color: var(--danger);">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
                                        </svg>
                                        <input type="tel" id="phone" name="phone" class="form-control"
                                               pattern="[0-9]{10}" placeholder="0912 345 678" required
                                               value="<c:out value='${not empty sessionScope.preserved_phone ? sessionScope.preserved_phone : ""}' />">
                                    </div>
                                    <c:remove var="preserved_phone" scope="session" />
                                </div>
                            </div>

                            <!-- Row 2: Email -->
                            <div class="form-group">
                                <label for="email" class="form-label">
                                    Email cá nhân <span class="required" style="color: var(--danger);">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                        <rect width="20" height="16" x="2" y="4" rx="2"></rect>
                                        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path>
                                    </svg>
                                    <input type="email" id="email" name="email" class="form-control"
                                           placeholder="hocsinh@thpt.edu.vn" required
                                           value="<c:out value='${not empty sessionScope.preserved_email ? sessionScope.preserved_email : ""}' />">
                                </div>
                                <c:remove var="preserved_email" scope="session" />
                            </div>

                            <!-- Row 3: Password & Confirm Password Grid -->
                            <div class="form-grid-2col">
                                <!-- Password -->
                                <div class="form-group">
                                    <div class="pwd-strength-header">
                                        <label for="password" class="form-label" style="margin-bottom: 0;">
                                            Mật khẩu <span class="required" style="color: var(--danger);">*</span>
                                        </label>
                                        <span id="strength-label" style="font-size: var(--font-size-xs); font-family: monospace; color: var(--text-muted);">Chưa nhập</span>
                                    </div>
                                    <div class="auth-password-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password" id="password" name="password" class="form-control"
                                               placeholder="Tối thiểu 6 ký tự" required autocomplete="new-password">
                                        <button type="button" class="auth-password-toggle" data-password-toggle="password"
                                                aria-label="Hiện/Ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
                                            <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display: none;">
                                                <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"></path>
                                                <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"></path>
                                                <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"></path>
                                                <line x1="2" y1="2" x2="22" y2="22"></line>
                                            </svg>
                                        </button>
                                    </div>

                                    <!-- 4-Segment Password Strength Meter -->
                                    <div class="pwd-strength-bars-grid">
                                        <div class="pwd-bar-segment" id="bar-1"></div>
                                        <div class="pwd-bar-segment" id="bar-2"></div>
                                        <div class="pwd-bar-segment" id="bar-3"></div>
                                        <div class="pwd-bar-segment" id="bar-4"></div>
                                    </div>

                                    <ul class="pwd-rules-checklist">
                                        <li class="pwd-rule-item" id="rule-len">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                            <span>≥ 6 ký tự</span>
                                        </li>
                                        <li class="pwd-rule-item" id="rule-upper">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                            <span>Chữ hoa</span>
                                        </li>
                                        <li class="pwd-rule-item" id="rule-num">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                            <span>Số</span>
                                        </li>
                                        <li class="pwd-rule-item" id="rule-special">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle></svg>
                                            <span>Ký tự đặc biệt</span>
                                        </li>
                                    </ul>
                                </div>

                                <!-- Confirm Password -->
                                <div class="form-group">
                                    <div class="pwd-strength-header">
                                        <label for="confirm-password" class="form-label" style="margin-bottom: 0;">
                                            Xác nhận mật khẩu <span class="required" style="color: var(--danger);">*</span>
                                        </label>
                                        <span id="match-indicator" class="match-status-text matched" style="opacity: 0;">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                            Mật khẩu khớp
                                        </span>
                                    </div>
                                    <div class="auth-password-wrapper">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
                                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                        </svg>
                                        <input type="password" id="confirm-password" name="confirmPassword" class="form-control"
                                               placeholder="Nhập lại mật khẩu" required autocomplete="new-password">
                                        <button type="button" class="auth-password-toggle" data-password-toggle="confirm-password"
                                                aria-label="Hiện/Ẩn mật khẩu" title="Hiện/Ẩn mật khẩu">
                                            <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true">
                                                <path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                            <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display: none;">
                                                <path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"></path>
                                                <path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"></path>
                                                <path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"></path>
                                                <line x1="2" y1="2" x2="22" y2="22"></line>
                                            </svg>
                                        </button>
                                    </div>
                                    <div id="match-error" class="match-status-text mismatch" style="display: none;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                        Mật khẩu xác nhận không khớp
                                    </div>
                                </div>
                            </div>

                            <!-- Terms Checkboxes -->
                            <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 8px;">
                                <label class="auth-checkbox-label" style="align-items: flex-start;">
                                    <input type="checkbox" id="terms-agree" required style="margin-top: 3px;">
                                    <span>
                                        Tôi đồng ý với <a href="#" style="color: var(--primary); font-weight: 500;">Điều khoản dịch vụ trung tâm</a> và <a href="#" style="color: var(--primary); font-weight: 500;">Quy chế kiểm tra &amp; đánh giá</a> của hệ thống đào tạo EduCenter.
                                    </span>
                                </label>
                                <label class="auth-checkbox-label" style="align-items: flex-start;">
                                    <input type="checkbox" id="privacy-agree" required style="margin-top: 3px;">
                                    <span>
                                        Tôi cho phép lưu trữ và bảo mật dữ liệu học tập/học bạ theo chuẩn bảo mật ISO/IEC 27001 &amp; Nghị định 13/2023/NĐ-CP.
                                    </span>
                                </label>
                            </div>

                            <!-- Action Buttons -->
                            <div style="display: flex; align-items: center; justify-content: space-between; gap: 16px; margin-top: 24px; flex-wrap: wrap;">
                                <button type="submit" class="btn btn-primary" style="height: 44px; padding: 0 28px; font-size: var(--font-size-md);">
                                    <span>Tạo tài khoản &amp; Bắt đầu</span>
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </button>
                                <div style="font-size: var(--font-size-sm); color: var(--text-muted);">
                                    Đã có tài khoản? 
                                    <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">
                                        Đăng nhập ngay &rarr;
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Compliance Metadata -->
                    <div style="display: flex; align-items: center; justify-content: space-between; font-size: var(--font-size-xs); color: var(--text-muted); font-family: monospace;">
                        <span>ERP ID: AUTH-FORM-2026-V2</span>
                        <span>Máy chủ: edu-cluster-hcm01 · Độ trễ: 14ms</span>
                    </div>
                </div>

                <!-- Right Column: Institutional Trust & Benefit Showcase (4 cols) -->
                <div class="register-trust-col">
                    <!-- Visual Card: Campus Life / Academics -->
                    <div class="campus-card">
                        <div class="campus-banner-image">
                            <span class="campus-banner-tag">Niên khóa 2025 - 2026</span>
                        </div>
                        <div class="campus-card-body">
                            <div style="display: flex; align-items: center; justify-content: space-between; font-size: var(--font-size-xs);">
                                <span style="font-weight: 600; color: var(--success); text-transform: uppercase;">Chỉ số tuyển sinh</span>
                                <span style="color: var(--text-muted);">Top 5% toàn quốc</span>
                            </div>
                            <h2 style="font-size: var(--font-size-md); font-weight: 650; color: var(--text); margin: 0;">Chuẩn bị toàn diện kỳ thi Tốt nghiệp &amp; ĐGNL</h2>
                            <p style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.5; margin: 0;">
                                Học sinh đăng ký sớm được kích hoạt ngân hàng 10.000+ câu hỏi phân hóa từ tổ bộ môn chuyên THPT Quốc Gia.
                            </p>
                        </div>
                    </div>

                    <!-- Bento Box: Account Benefits -->
                    <div class="bento-box-card">
                        <div style="display: flex; align-items: center; justify-content: space-between;">
                            <h3 style="font-size: var(--font-size-sm); font-weight: 650; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text); margin: 0;">Quyền lợi tài khoản</h3>
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                                <polyline points="9 12 11 14 15 10"></polyline>
                            </svg>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <!-- Item 1 -->
                            <div class="bento-benefit-item">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                    <polyline points="10 9 9 9 8 9"></polyline>
                                </svg>
                                <div>
                                    <div style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text);">Làm bài test đầu vào miễn phí</div>
                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.4;">Định vị năng lực chuẩn xác theo ma trận đề Bộ GD&amp;ĐT.</div>
                                </div>
                            </div>
                            <!-- Item 2 -->
                            <div class="bento-benefit-item">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <rect width="18" height="18" x="3" y="4" rx="2"></rect>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                                <div>
                                    <div style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text);">Lịch học &amp; Điểm danh thông minh</div>
                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.4;">Đồng bộ lịch học, nhận thông báo dời ca qua SMS và Zalo.</div>
                                </div>
                            </div>
                            <!-- Item 3 -->
                            <div class="bento-benefit-item">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                    <line x1="18" y1="20" x2="18" y2="10"></line>
                                    <line x1="12" y1="20" x2="12" y2="4"></line>
                                    <line x1="6" y1="20" x2="6" y2="14"></line>
                                </svg>
                                <div>
                                    <div style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text);">Biểu đồ tiến độ học tập</div>
                                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); line-height: 1.4;">Phân tích chi tiết từng kỹ năng yếu theo chuyên đề.</div>
                                </div>
                            </div>
                        </div>

                        <!-- Metric mini-bar -->
                        <div style="margin-top: 6px;">
                            <div style="display: flex; justify-content: space-between; font-size: var(--font-size-xs); margin-bottom: 4px;">
                                <span style="color: var(--text-muted);">Chỉ tiêu lớp chuyên tháng 4</span>
                                <span style="font-weight: 600; color: var(--text);">82% Đã đăng ký</span>
                            </div>
                            <div style="width: 100%; height: 6px; background-color: var(--surface-muted); border-radius: var(--radius-full); overflow: hidden;">
                                <div style="height: 100%; width: 82%; background-color: var(--success); border-radius: var(--radius-full);"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Support Box -->
                    <div class="support-action-box">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <div style="width: 36px; height: 36px; border-radius: var(--radius-md); background-color: var(--surface); display: flex; align-items: center; justify-content: center; box-shadow: var(--shadow-sm); color: var(--primary);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M3 18v-6a9 9 0 0 1 18 0v6"></path>
                                    <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"></path>
                                </svg>
                            </div>
                            <div>
                                <div style="font-size: var(--font-size-xs); color: var(--text-muted);">Cần trợ giúp đăng ký?</div>
                                <div style="font-size: var(--font-size-sm); font-weight: 700; color: var(--text); font-family: monospace;">1900 6886 (8h - 21h)</div>
                            </div>
                        </div>
                        <a href="tel:19006886" class="btn btn-secondary btn-sm" style="font-weight: 600; text-decoration: none;">
                            Gọi tư vấn
                        </a>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</body>
</html>
