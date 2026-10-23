<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="public-site">
  <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

  <main id="main-content" class="auth-page-wrapper">
    <div class="auth-main-content">
      <div class="auth-register-grid">
        <!-- Main Registration Column -->
        <div class="register-main-col">
          <!-- Stepper / Status Top Bar -->
          <div class="register-stepper-bar">
            <div class="stepper-left">
              <div class="stepper-num-badge">01</div>
              <div>
                <div class="stepper-sub">SRS AUTH-02 · Xác thực tài khoản</div>
                <div class="stepper-title">Đăng ký thành viên hệ thống EduCenter</div>
              </div>
            </div>
            <div class="auth-pill-badge" style="background: var(--surface-muted); color: var(--text-muted);">
              <svg class="icon icon-sm" style="color: var(--primary);" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
              <span>Bảo mật 256-bit SSL &amp; BR01 Validated</span>
            </div>
          </div>

          <!-- Registration Form Container Card -->
          <div class="register-form-card">
            <!-- Flash Alert -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Segmented Role Selector (STUDENT or PARENT per FR-001) -->
            <div class="role-segmented-container">
              <div class="role-segmented-header">
                <span style="font-weight: 600; color: var(--text);">Vai trò đăng ký sử dụng</span>
                <span class="text-muted" style="font-size: 12px;">Chọn đúng quyền hạn để nhận lộ trình phù hợp</span>
              </div>
              <div class="role-segmented-grid">
                <!-- Role 1: Student -->
                <button type="button" class="role-segmented-btn ${sessionScope.preserved_roleCode != 'PARENT' ? 'active' : ''}" data-role="STUDENT">
                  <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                  <div>
                    <span class="role-btn-title">Học sinh THPT</span>
                    <span class="role-btn-desc">Lớp 10, 11, 12 &amp; Luyện thi ĐGNL</span>
                  </div>
                </button>
                <!-- Role 2: Parent -->
                <button type="button" class="role-segmented-btn ${sessionScope.preserved_roleCode == 'PARENT' ? 'active' : ''}" data-role="PARENT">
                  <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                  <div>
                    <span class="role-btn-title">Phụ huynh học sinh</span>
                    <span class="role-btn-desc">Giám sát điểm thi &amp; biểu phí</span>
                  </div>
                </button>
              </div>
            </div>

            <!-- Dynamic Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" id="register-form" style="display: flex; flex-direction: column; gap: 20px;">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <input type="hidden" id="roleCodeInput" name="roleCode" value="${sessionScope.preserved_roleCode != null ? sessionScope.preserved_roleCode : 'STUDENT'}"/>

              <!-- 2-Column Grid -->
              <div class="form-grid-2col">
                <!-- Full Name -->
                <div class="form-group">
                  <label class="form-label" for="fullname">
                    Họ và tên <span style="color: var(--danger);">*</span>
                  </label>
                  <div class="input-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </span>
                    <input class="form-control" id="fullname" name="fullName" type="text"
                           placeholder="Nguyễn Văn An" required minlength="2" maxlength="150" autocomplete="name"
                           value="<c:out value='${sessionScope.preserved_fullName}'/>"/>
                  </div>
                </div>

                <!-- Phone Number -->
                <div class="form-group">
                  <label class="form-label" for="phone">
                    Số điện thoại liên hệ <span style="color: var(--danger);">*</span>
                  </label>
                  <div class="input-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                    </span>
                    <input class="form-control" id="phone" name="phone" type="tel"
                           placeholder="0912 345 678" required pattern="[0-9]{10}" maxlength="20" autocomplete="tel"
                           value="<c:out value='${sessionScope.preserved_phone}'/>"/>
                  </div>
                </div>

                <!-- Email -->
                <div class="form-group">
                  <label class="form-label" for="email">
                    Email cá nhân <span style="color: var(--danger);">*</span>
                  </label>
                  <div class="input-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
                    </span>
                    <input class="form-control" id="email" name="email" type="email"
                           placeholder="phuhuynh@gmail.com" required maxlength="255" autocomplete="username"
                           value="<c:out value='${sessionScope.preserved_email}'/>"/>
                  </div>
                </div>

                <!-- Student Email for Parent (Auto-link Guardian FR-001 / D18) -->
                <div class="form-group" id="student-email-wrapper" style="${sessionScope.preserved_roleCode == 'PARENT' ? '' : 'display: none;'}">
                  <label class="form-label" for="studentEmail">
                    Email học sinh (con) <span style="color: var(--danger);">*</span>
                  </label>
                  <div class="input-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
                    </span>
                    <input class="form-control" id="studentEmail" name="studentEmail" type="email"
                           placeholder="con.hocsinh@thpt.edu.vn" maxlength="255"
                           ${sessionScope.preserved_roleCode == 'PARENT' ? 'required' : 'disabled'}
                           value="<c:out value='${sessionScope.preserved_studentEmail}'/>"/>
                  </div>
                  <span class="text-muted" style="font-size: 11px; margin-top: 4px; display: block; line-height: 1.4;">
                    Nhập đúng email con đã đăng ký tại EduCenter để tự động liên kết và xác minh quyền phụ huynh.
                  </span>
                </div>

                <!-- Grade / Role-Specific Field for Student -->
                <div class="form-group" id="grade-student-wrapper" style="${sessionScope.preserved_roleCode == 'PARENT' ? 'display: none;' : ''}">
                  <label class="form-label" for="grade-student">
                    Khối lớp quan tâm <span style="color: var(--danger);">*</span>
                  </label>
                  <div class="input-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>
                    </span>
                    <select class="form-control" id="grade-student" name="grade" ${sessionScope.preserved_roleCode == 'PARENT' ? 'disabled' : ''}>
                      <option value="" disabled selected>Chọn khối lớp đào tạo</option>
                      <option value="k10">Khối 10 (Chương trình GDPT 2018)</option>
                      <option value="k11">Khối 11 (Chuyên đề nâng cao &amp; ĐGNL sớm)</option>
                      <option value="k12">Khối 12 (Tổng ôn tốt nghiệp &amp; Tuyển sinh ĐH)</option>
                      <option value="dgnl">Luyện thi Đánh Giá Năng Lực (ĐHQG / ĐHBK)</option>
                    </select>
                  </div>
                </div>

                <!-- Grade / Role-Specific Field for Parent -->
                <div class="form-group" id="grade-parent-wrapper" style="${sessionScope.preserved_roleCode == 'PARENT' ? '' : 'display: none;'}">
                  <label class="form-label" for="grade-parent">
                    Khối lớp hiện tại của con <span style="color: var(--danger);">*</span>
                  </label>
                  <div class="input-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>
                    </span>
                    <select class="form-control" id="grade-parent" name="grade" ${sessionScope.preserved_roleCode == 'PARENT' ? '' : 'disabled'}>
                      <option value="" disabled selected>Chọn khối lớp của con</option>
                      <option value="k10">Con đang học Khối 10 THPT</option>
                      <option value="k11">Con đang học Khối 11 THPT</option>
                      <option value="k12">Con đang học Khối 12 THPT (Thi TN &amp; ĐH)</option>
                    </select>
                  </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                  <div class="pwd-strength-header">
                    <label class="form-label" for="password" style="margin: 0;">
                      Mật khẩu <span style="color: var(--danger);">*</span>
                    </label>
                    <span class="font-code-num text-muted" id="pwd-strength-label" style="font-size: 11px;"
                          data-empty="Chưa nhập"
                          data-weak="Yếu"
                          data-medium="Trung bình"
                          data-good="Khá"
                          data-strong="Rất mạnh">Chưa nhập</span>
                  </div>
                  <div class="auth-password-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </span>
                    <input class="form-control" id="password" name="password" type="password"
                           placeholder="Tối thiểu 6 ký tự" required minlength="6" autocomplete="new-password"/>
                    <button type="button" class="auth-password-toggle" data-password-toggle="password" aria-label="Hiện/ẩn mật khẩu">
                      <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                      <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display:none;"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" x2="22" y1="2" y2="22"/></svg>
                    </button>
                  </div>
                  <!-- Password 4-Bar Strength Meter -->
                  <div class="pwd-strength-bars-grid">
                    <div class="pwd-bar-segment" id="bar-1"></div>
                    <div class="pwd-bar-segment" id="bar-2"></div>
                    <div class="pwd-bar-segment" id="bar-3"></div>
                    <div class="pwd-bar-segment" id="bar-4"></div>
                  </div>
                  <!-- 4-Rule Checklist -->
                  <ul class="pwd-rules-checklist">
                    <li class="pwd-rule-item" id="rule-len">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>≥ 6 ký tự</span>
                    </li>
                    <li class="pwd-rule-item" id="rule-upper">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>Chữ hoa</span>
                    </li>
                    <li class="pwd-rule-item" id="rule-num">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>Chữ số</span>
                    </li>
                    <li class="pwd-rule-item" id="rule-special">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                      <span>Ký tự đặc biệt</span>
                    </li>
                  </ul>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                  <div class="pwd-strength-header">
                    <label class="form-label" for="confirmPassword" style="margin: 0;">
                      Xác nhận mật khẩu <span style="color: var(--danger);">*</span>
                    </label>
                  </div>
                  <div class="auth-password-wrapper">
                    <span class="input-icon">
                      <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 2l-2 2m-2-2l2 2"/><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </span>
                    <input class="form-control" id="confirmPassword" name="confirmPassword" type="password"
                           placeholder="Nhập lại mật khẩu" required minlength="6" autocomplete="new-password"/>
                    <button type="button" class="auth-password-toggle" data-password-toggle="confirmPassword" aria-label="Hiện/ẩn mật khẩu">
                      <svg class="icon icon-sm icon-eye" viewBox="0 0 24 24" aria-hidden="true"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                      <svg class="icon icon-sm icon-eye-off" viewBox="0 0 24 24" aria-hidden="true" style="display:none;"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" x2="22" y1="2" y2="22"/></svg>
                    </button>
                  </div>
                  <span id="match-indicator" class="match-status-text matched" style="opacity: 0; transition: opacity 0.2s;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                    Mật khẩu trùng khớp
                  </span>
                  <span id="match-error" class="match-status-text mismatch" style="display: none;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                    Mật khẩu xác nhận không khớp
                  </span>
                </div>
              </div>

              <!-- Terms Checkboxes -->
              <div style="display: flex; flex-direction: column; gap: 8px; margin-top: 4px;">
                <label class="auth-checkbox-label" style="align-items: flex-start;">
                  <input type="checkbox" id="terms-agree" required checked style="margin-top: 3px;"/>
                  <span style="font-size: 13px; line-height: 1.4;">
                    Tôi đồng ý với <a href="${pageContext.request.contextPath}/terms" target="_blank" class="auth-forgot-link">Điều khoản dịch vụ trung tâm</a> và <a href="${pageContext.request.contextPath}/terms" target="_blank" class="auth-forgot-link">Quy chế kiểm tra &amp; đánh giá</a> của hệ thống EduCenter.
                  </span>
                </label>
                <label class="auth-checkbox-label" style="align-items: flex-start;">
                  <input type="checkbox" id="privacy-agree" required checked style="margin-top: 3px;"/>
                  <span style="font-size: 13px; line-height: 1.4;">
                    Tôi cho phép lưu trữ và bảo mật dữ liệu học tập/học bạ theo <a href="${pageContext.request.contextPath}/privacy" target="_blank" class="auth-forgot-link">Chính sách bảo mật ISO/IEC 27001 &amp; Nghị định 13/2023/NĐ-CP</a>.
                  </span>
                </label>
              </div>

              <!-- Action Buttons -->
              <div style="display: flex; align-items: center; justify-content: space-between; gap: 16px; flex-wrap: wrap; margin-top: 8px;">
                <button type="submit" class="btn btn-primary" style="height: 44px; padding: 0 28px; display: inline-flex; align-items: center; gap: 8px; font-weight: 600;">
                  <span>Tạo tài khoản &amp; Bắt đầu</span>
                  <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                </button>
                <div style="font-size: 14px; color: var(--text-muted);">
                  Đã có tài khoản?
                  <a href="${pageContext.request.contextPath}/login" class="auth-forgot-link" style="margin-left: 4px; display: inline-flex; align-items: center; gap: 2px;">
                    Đăng nhập ngay
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"/></svg>
                  </a>
                </div>
              </div>
            </form>
          </div>

          <!-- Compliance Metadata -->
          <div style="display: flex; align-items: center; justify-content: space-between; font-size: 11px; color: var(--text-muted); padding: 0 4px;">
            <span class="font-code-num">ERP ID: AUTH-FORM-2026-V2</span>
            <div style="display: flex; align-items: center; gap: 16px;">
              <span>Máy chủ: edu-cluster-hcm01</span>
              <span>Độ trễ: 14ms</span>
            </div>
          </div>
        </div>

        <!-- Right Column: Institutional Trust & Benefit Showcase -->
        <div class="register-trust-col">
          <!-- Campus Life Card -->
          <div class="campus-card">
            <div class="campus-banner-image">
              <span class="campus-banner-tag">Niên khóa 2025 - 2026</span>
            </div>
            <div class="campus-card-body">
              <div style="display: flex; align-items: center; justify-content: space-between;">
                <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; color: var(--success); letter-spacing: 0.05em;">Chỉ số tuyển sinh</span>
                <span class="text-muted" style="font-size: 12px;">Top 5% toàn quốc</span>
              </div>
              <h2 style="font-size: 17px; font-weight: 700; color: var(--text); margin: 0; line-height: 1.3;">
                Chuẩn bị toàn diện kỳ thi Tốt nghiệp &amp; ĐGNL
              </h2>
              <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                Học sinh đăng ký sớm được kích hoạt ngân hàng 10.000+ câu hỏi phân hóa từ tổ bộ môn chuyên THPT Quốc Gia.
              </p>
            </div>
          </div>

          <!-- Bento Box Benefits -->
          <div class="bento-box-card">
            <div style="display: flex; align-items: center; justify-content: space-between;">
              <span style="font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text);">Quyền lợi tài khoản</span>
              <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/></svg>
            </div>

            <!-- Item 1 -->
            <div class="bento-benefit-item">
              <svg class="icon icon-md text-primary" style="margin-top: 2px;" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
              <div>
                <div style="font-size: 13px; font-weight: 600; color: var(--text);">Làm bài test đầu vào miễn phí</div>
                <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">Định vị năng lực chuẩn xác theo ma trận đề Bộ GD&amp;ĐT.</div>
              </div>
            </div>

            <!-- Item 2 -->
            <div class="bento-benefit-item">
              <svg class="icon icon-md text-primary" style="margin-top: 2px;" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>
              <div>
                <div style="font-size: 13px; font-weight: 600; color: var(--text);">Lịch học &amp; Điểm danh thông minh</div>
                <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">Đồng bộ lịch học, nhận thông báo dời ca qua SMS và Zalo.</div>
              </div>
            </div>

            <!-- Item 3 -->
            <div class="bento-benefit-item">
              <svg class="icon icon-md text-primary" style="margin-top: 2px;" viewBox="0 0 24 24" aria-hidden="true"><line x1="18" x2="18" y1="20" y2="10"/><line x1="12" x2="12" y1="20" y2="4"/><line x1="6" x2="6" y1="20" y2="14"/></svg>
              <div>
                <div style="font-size: 13px; font-weight: 600; color: var(--text);">Biểu đồ tiến độ học tập</div>
                <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">Phân tích chi tiết từng kỹ năng yếu theo chuyên đề.</div>
              </div>
            </div>

            <!-- Metric mini-bar -->
            <div style="padding-top: 4px;">
              <div style="display: flex; justify-content: space-between; font-size: 12px; margin-bottom: 6px;">
                <span class="text-muted">Chỉ tiêu lớp chuyên tháng 4</span>
                <span class="font-code-num" style="font-weight: 600; color: var(--text);">82% Đã đăng ký</span>
              </div>
              <div style="width: 100%; height: 6px; background: var(--surface-muted); border-radius: 9999px; overflow: hidden;">
                <div style="width: 82%; height: 100%; background: var(--success); border-radius: 9999px;"></div>
              </div>
            </div>
          </div>

          <!-- Support Hotline Box -->
          <div class="support-action-box">
            <div style="display: flex; align-items: center; gap: 12px;">
              <div style="width: 38px; height: 38px; border-radius: var(--radius-md); background: var(--surface); display: flex; align-items: center; justify-content: center; color: var(--primary); box-shadow: var(--shadow-sm);">
                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 18v-6a9 9 0 0 1 18 0v6"/><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/></svg>
              </div>
              <div>
                <div style="font-size: 11px; color: var(--text-muted);">Cần trợ giúp đăng ký?</div>
                <div class="font-code-num" style="font-size: 14px; font-weight: 700; color: var(--text);">1900 6886 (8h - 21h30)</div>
              </div>
            </div>
            <a href="tel:19006886" class="btn btn-secondary btn-sm" style="font-size: 12px; text-decoration: none;">
              Gọi tư vấn
            </a>
          </div>
        </div>
      </div>
    </div>
  </main>

  <c:remove var="preserved_fullName" scope="session"/>
  <c:remove var="preserved_phone" scope="session"/>
  <c:remove var="preserved_email" scope="session"/>
  <c:remove var="preserved_roleCode" scope="session"/>
  <c:remove var="preserved_studentEmail" scope="session"/>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>