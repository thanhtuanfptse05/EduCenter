<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="public-site">
  <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

  <main id="main-content" class="screen-wrap" style="max-width: 960px; margin: 32px auto; padding: 0 16px;">
    <%@ include file="/WEB-INF/views/common/alert.jsp" %>

    <nav class="screen-steps" aria-label="Đường dẫn" style="margin-bottom: 20px;">
      <a href="${pageContext.request.contextPath}/">Trang chủ</a>
      <span>/</span>
      <span style="color: var(--text-muted);">Hỗ trợ kỹ thuật &amp; Liên hệ</span>
    </nav>

    <div class="screen-heading" style="margin-bottom: 32px;">
      <span class="screen-eyebrow" style="color: var(--primary); font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px;">Trung tâm trợ giúp 24/7</span>
      <h1 style="font-size: 28px; font-weight: 700; color: var(--text); margin-top: 8px;">Kênh Hỗ Trợ Kỹ Thuật &amp; Tiếp Nhận Ý Kiến Phụ Huynh</h1>
      <p style="color: var(--text-muted); font-size: 14px; margin-top: 6px;">Đội ngũ hỗ trợ EduCenter sẵn sàng giải đáp mọi thắc mắc học vụ, tài khoản và kỹ thuật</p>
    </div>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-bottom: 32px;">
      <div class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <div style="width: 44px; height: 44px; border-radius: 8px; background: var(--primary-subtle); display: flex; align-items: center; justify-content: center; margin-bottom: 16px;">
          <svg class="icon icon-md text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
        </div>
        <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 6px;">Tổng đài tuyển sinh &amp; CSKH</h3>
        <p style="font-size: 20px; font-weight: 700; color: var(--primary); margin-bottom: 8px;">1900 6886</p>
        <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5;">Hỗ trợ tư vấn khóa học, giải đáp lịch học và xác nhận ghi danh. Hoạt động 08:00 – 21:30 hàng ngày.</p>
      </div>

      <div class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <div style="width: 44px; height: 44px; border-radius: 8px; background: var(--primary-subtle); display: flex; align-items: center; justify-content: center; margin-bottom: 16px;">
          <svg class="icon icon-md text-primary" viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>
        </div>
        <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 6px;">Hòm thư kỹ thuật số</h3>
        <p style="font-size: 18px; font-weight: 700; color: var(--primary); margin-bottom: 8px;">hotro@educenter.vn</p>
        <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5;">Tiếp nhận yêu cầu liên kết tài khoản con, sự cố đăng nhập cổng và cấp lại biên lai điện tử trong 2h.</p>
      </div>

      <div class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <div style="width: 44px; height: 44px; border-radius: 8px; background: var(--primary-subtle); display: flex; align-items: center; justify-content: center; margin-bottom: 16px;">
          <svg class="icon icon-md text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>
        </div>
        <h3 style="font-size: 16px; font-weight: 600; margin-bottom: 6px;">Văn phòng đào tạo trực tiếp</h3>
        <p style="font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 8px;">Hà Nội &amp; TP. Hồ Chí Minh</p>
        <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5;">Cơ sở 1: Khu Công nghệ cao Hòa Lạc / Cầu Giấy.<br/>Cơ sở 2: Đường D1, Khu CNC, TP. Thủ Đức.</p>
      </div>
    </div>

    <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
      <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 16px;">Hướng dẫn nhanh các tình huống thường gặp</h2>
      <div style="display: flex; flex-direction: column; gap: 16px; font-size: 14px; line-height: 1.6;">
        <div>
          <strong style="color: var(--text);">1. Quên mật khẩu đăng nhập cổng học tập:</strong>
          <p style="color: var(--text-muted); margin-top: 4px;">Truy cập trang <a href="${pageContext.request.contextPath}/forgot-password" style="color: var(--primary); text-decoration: underline;">Khôi phục mật khẩu</a>, nhập email đăng ký để nhận mã OTP xác thực và đặt lại mật khẩu mới.</p>
        </div>
        <div>
          <strong style="color: var(--text);">2. Phụ huynh chưa xem được kết quả học tập của con:</strong>
          <p style="color: var(--text-muted); margin-top: 4px;">Vui lòng kiểm tra email con đã đăng ký. Khi tạo tài khoản phụ huynh, hệ thống yêu cầu email học sinh để khớp nối. Nếu thông tin chưa khớp, liên hệ văn phòng giáo vụ để xác minh quan hệ giám hộ.</p>
        </div>
        <div>
          <strong style="color: var(--text);">3. Muốn xin nghỉ học hoặc đổi lịch thi thử:</strong>
          <p style="color: var(--text-muted); margin-top: 4px;">Phụ huynh đăng nhập vào Cổng Phụ huynh, chọn con tương ứng và sử dụng tính năng thông báo nghỉ phép trước giờ vào học.</p>
        </div>
      </div>
    </section>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
