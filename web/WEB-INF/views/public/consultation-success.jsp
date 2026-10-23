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

    <!-- Stepper 3 Steps: Completed Flow -->
    <div class="screen-stepper-wrap" aria-label="Tiến trình đăng ký">
      <div class="stepper-step completed">
        <span class="stepper-num">
          <svg class="icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub">Bước 1</span>
          <span class="stepper-title">Khóa học & Nguyện vọng</span>
        </div>
      </div>
      <div class="stepper-divider"></div>
      <div class="stepper-step completed">
        <span class="stepper-num">
          <svg class="icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub">Bước 2</span>
          <span class="stepper-title">Thông tin học viên</span>
        </div>
      </div>
      <div class="stepper-divider"></div>
      <div class="stepper-step active">
        <span class="stepper-num" style="background:var(--success);border-color:var(--success);box-shadow:0 0 0 4px var(--success-subtle);">
          <svg class="icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub" style="color:var(--success);">Bước 3</span>
          <span class="stepper-title" style="color:var(--text);font-weight:700;">Tiếp nhận & Xếp lịch</span>
        </div>
      </div>
    </div>

    <!-- Hero Success Banner -->
    <div class="receipt-hero-banner">
      <div class="receipt-success-icon">
        <svg class="icon-lg" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
      </div>
      <span class="screen-eyebrow" style="color:var(--success);">Đã tiếp nhận yêu cầu</span>
      <h1>Đăng ký tư vấn thành công</h1>
      <p>Yêu cầu của bạn đã được lưu vào hệ thống đào tạo EduCenter. Vui lòng lưu lại mã hồ sơ dưới đây để thuận tiện khi liên hệ và kiểm tra xếp lớp.</p>
    </div>

    <!-- Official Executive Receipt Voucher -->
    <section class="receipt-voucher-card" id="printReceiptArea">
      <!-- Voucher Header -->
      <div class="receipt-voucher-header">
        <div class="receipt-branding">
          <span class="receipt-brand-badge">EduCenter ERP · Ban Tuyển Sinh & Khảo Thí</span>
          <h2>Phiếu tiếp nhận đăng ký</h2>
          <span class="receipt-status-tag">
            <svg class="icon-sm" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
            Hồ sơ hợp lệ trên hệ thống
          </span>
        </div>

        <div class="receipt-code-panel">
          <div class="receipt-code-box">
            <span class="receipt-code-label">Mã phiếu tiếp nhận</span>
            <p class="screen-receipt-code"><c:out value="${receipt.code}"/></p>
          </div>
        </div>
      </div>

      <!-- Information Grid -->
      <div class="receipt-details-grid">
        <div class="receipt-detail-item">
          <span class="detail-item-label">
            <svg class="icon-sm" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            Người đăng ký
          </span>
          <span class="detail-item-val" style="color:var(--primary);text-transform:uppercase;"><c:out value="${receipt.fullName}"/></span>
        </div>

        <div class="receipt-detail-item">
          <span class="detail-item-label">
            <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
            Số điện thoại
          </span>
          <span class="detail-item-val"><c:out value="${receipt.phone}"/></span>
        </div>

        <div class="receipt-detail-item">
          <span class="detail-item-label">
            <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c3 3 9 3 12 0v-5"/></svg>
            Khối lớp
          </span>
          <span class="detail-item-val">Lớp <c:out value="${receipt.gradeLevel}"/></span>
        </div>

        <div class="receipt-detail-item">
          <span class="detail-item-label">
            <svg class="icon-sm" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            Thời điểm tiếp nhận
          </span>
          <span class="detail-item-val"><c:out value="${receipt.formattedSubmittedAt}"/></span>
        </div>
      </div>

      <!-- Next Steps Timeline -->
      <div class="receipt-next-steps-section">
        <h3>
          <svg class="icon-sm" viewBox="0 0 24 24"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>
          Quy trình 3 bước tiếp theo dành cho bạn:
        </h3>
        <div class="next-steps-timeline">
          <div class="timeline-step">
            <div class="timeline-step-badge">1</div>
            <span class="timeline-step-title">Tư vấn viên liên hệ</span>
            <p class="timeline-step-desc">Thầy cô chuyên môn sẽ gọi điện thoại trong vòng 24h để nắm bắt nguyện vọng và khung giờ phù hợp.</p>
          </div>
          <div class="timeline-step">
            <div class="timeline-step-badge">2</div>
            <span class="timeline-step-title">Khảo sát năng lực</span>
            <p class="timeline-step-desc">Học sinh được làm bài kiểm tra đánh giá năng lực miễn phí 45 phút để định vị chính xác lộ trình ôn luyện.</p>
          </div>
          <div class="timeline-step">
            <div class="timeline-step-badge">3</div>
            <span class="timeline-step-title">Học thử & Ghi danh</span>
            <p class="timeline-step-desc">Tham gia 01 buổi học thử trải nghiệm lớp học thực tế trước khi hoàn thiện thủ tục nhập học chính thức.</p>
          </div>
        </div>
      </div>

      <!-- Legal & Advisory Notice -->
      <div class="receipt-legal-note">
        <p style="margin:0;font-weight:500;">
          <strong>Lưu ý:</strong> Đây là xác nhận tiếp nhận nhu cầu tư vấn, chưa phải xác nhận ghi danh hay thanh toán. Quý phụ huynh và học sinh không phải đóng bất kỳ khoản phí nào ở bước này.
        </p>
      </div>

      <!-- Voucher Footer Stamp -->
      <div class="receipt-footer-stamp">
        <span>Hotline hỗ trợ phụ huynh: <strong>1900 6868</strong> (08:00 – 21:00)</span>
        <span>Hệ thống ERP Quản trị Trung tâm EduCenter</span>
      </div>
    </section>

    <!-- Bottom Actions Bar -->
    <div class="receipt-actions-bar">
      <button class="btn btn-secondary" type="button" onclick="window.print()">
        <svg class="icon-sm" viewBox="0 0 24 24"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect width="12" height="8" x="6" y="14"/></svg>
        In phiếu tiếp nhận
      </button>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/courses">
        <svg class="icon-sm" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
        Khám phá khóa học
      </a>
      <a class="btn btn-secondary" href="${pageContext.request.contextPath}/">
        <svg class="icon-sm" viewBox="0 0 24 24"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
        Về trang chủ
      </a>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
