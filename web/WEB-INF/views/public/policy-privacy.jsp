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
      <span style="color: var(--text-muted);">Chính sách bảo mật thông tin</span>
    </nav>

    <div class="screen-heading" style="margin-bottom: 32px;">
      <span class="screen-eyebrow" style="color: var(--primary); font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px;">Bảo mật &amp; Quyền riêng tư</span>
      <h1 style="font-size: 28px; font-weight: 700; color: var(--text); margin-top: 8px;">Chính Sách Bảo Mật Dữ Liệu Học Tập EduCenter</h1>
      <p style="color: var(--text-muted); font-size: 14px; margin-top: 6px;">Tuân thủ Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá nhân &amp; Tiêu chuẩn ISO/IEC 27001</p>
    </div>

    <div style="display: flex; flex-direction: column; gap: 24px;">
      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          1. Cam kết bảo mật dữ liệu học viên &amp; phụ huynh
        </h2>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text); margin-bottom: 12px;">
          EduCenter cam kết bảo vệ tuyệt đối thông tin định danh cá nhân (PII), kết quả học tập, học bạ và lịch sử tài chính của học viên và phụ huynh. Mọi dữ liệu chỉ được sử dụng cho mục đích tổ chức đào tạo, báo cáo kết quả và kết nối gia đình - nhà trường.
        </p>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text);">
          Chúng tôi tuyệt đối không mua bán, trao đổi hoặc cung cấp dữ liệu học viên cho bất kỳ bên thứ ba nào vì mục đích thương mại ngoài phạm vi dịch vụ.
        </p>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          2. Tiêu chuẩn mã hóa &amp; Phân quyền RBAC
        </h2>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li><strong>Mật khẩu người dùng:</strong> Toàn bộ mật khẩu được băm một chiều an toàn bằng thuật toán BCrypt với hệ số Salt (Cost Factor >= 10). Không một nhân viên hay quản trị viên nào có thể xem mật khẩu gốc.</li>
          <li><strong>Đường truyền dữ liệu:</strong> Sử dụng giao thức HTTPS với chứng chỉ SSL/TLS 1.3 mã hóa 256-bit trên toàn bộ các kênh truyền thông giữa trình duyệt và máy chủ.</li>
          <li><strong>Phân quyền nghiêm ngặt (RBAC):</strong> Giáo viên chỉ được xem điểm danh và điểm số của lớp mình phụ trách. Phụ huynh chỉ được xem thông tin của con em sau khi đã được xác thực quan hệ giám hộ (StudentGuardian.isVerified = true).</li>
          <li><strong>Audit Trail:</strong> Mọi thao tác quản trị tài chính, công bố điểm và mở lại điểm đều được ghi vết tự động vào hệ thống Audit Log phục vụ giám sát nội bộ (BR18).</li>
        </ul>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
          3. Quyền của Chủ thể dữ liệu
        </h2>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text); margin-bottom: 12px;">
          Theo quy định pháp luật, phụ huynh và học sinh có các quyền:
        </p>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li>Quyền được biết thông tin dữ liệu thu thập và tiến trình xử lý học tập.</li>
          <li>Quyền yêu cầu chỉnh sửa, cập nhật thông tin liên hệ khi có sai sót hoặc thay đổi.</li>
          <li>Quyền yêu cầu trích xuất bảng điểm và lịch sử học vụ trong suốt thời gian theo học.</li>
          <li>Quyền khiếu nại hoặc báo cáo vi phạm an toàn thông tin qua kênh hỗ trợ chính thức.</li>
        </ul>
      </section>
    </div>

    <div style="margin-top: 32px; text-align: center;">
      <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary" style="padding: 10px 24px; display: inline-flex; align-items: center; gap: 8px;">
        <span>Vào cổng đăng nhập</span>
        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"/></svg>
      </a>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
