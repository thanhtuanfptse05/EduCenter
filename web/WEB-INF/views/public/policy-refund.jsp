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
      <span style="color: var(--text-muted);">Chính sách hoàn phí &amp; Bảo lưu</span>
    </nav>

    <div class="screen-heading" style="margin-bottom: 32px;">
      <span class="screen-eyebrow" style="color: var(--primary); font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px;">Tài chính &amp; Học vụ</span>
      <h1 style="font-size: 28px; font-weight: 700; color: var(--text); margin-top: 8px;">Quy Định Hoàn Phí, Bảo Lưu &amp; Chuyển Lớp EduCenter</h1>
      <p style="color: var(--text-muted); font-size: 14px; margin-top: 6px;">Căn cứ theo Business Rules BR04, BR05, BR08 và BR19 của trung tâm</p>
    </div>

    <div style="display: flex; flex-direction: column; gap: 24px;">
      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><path d="m4.93 4.93 4.24 4.24"/><path d="m14.83 9.17 4.24-4.24"/><path d="m14.83 14.83 4.24 4.24"/><path d="m9.17 14.83-4.24 4.24"/></svg>
          1. Chính sách Bảo lưu học tập (BR04, BR05)
        </h2>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li><strong>Điều kiện bảo lưu:</strong> Học viên đang có trạng thái ghi danh hợp lệ (ACTIVE) và hoàn thành đầy đủ nghĩa vụ học phí của giai đoạn đã học. Phụ huynh nộp đơn đề nghị bảo lưu nêu rõ lý do chính đáng (sức khỏe, thi cử, lý do gia đình).</li>
          <li><strong>Thời hạn bảo lưu:</strong> Tối đa 06 tháng kể từ ngày đơn bảo lưu được phê duyệt. Hết thời hạn nêu trên nếu không làm thủ tục khôi phục, kết quả bảo lưu sẽ tự động chuyển sang thôi học (DROPPED).</li>
          <li><strong>Khôi phục sau bảo lưu (BR05):</strong> Khi khôi phục, hệ thống sẽ kiểm tra lại sĩ số hiện tại của lớp và xung đột lịch học của học viên trước khi chấp thuận tái ghi danh.</li>
        </ul>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 3h5v5"/><path d="M4 20L21 3"/><path d="M21 16v5h-5"/><path d="M15 15l6 6"/><path d="M4 4l5 5"/></svg>
          2. Chính sách Chuyển lớp &amp; Đổi môn học (BR08)
        </h2>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li>Học viên được quyền yêu cầu chuyển lớp sang ca học khác hoặc giáo viên khác cùng khối kiến thức nếu lớp đích còn chỗ trống (remaining capacity > 0).</li>
          <li>Hệ thống tự động kiểm tra loại trừ lớp cũ sắp rời đi để tránh báo lỗi xung đột lịch giả định.</li>
          <li>Khoản học phí đã đóng cho các buổi chưa diễn ra ở lớp cũ sẽ được bảo toàn và khấu trừ sang lớp mới. Nếu có chênh lệch học phí giữa hai lớp, trung tâm sẽ phát hành hóa đơn điều chỉnh bổ sung hoặc hoàn trả số dư thừa.</li>
        </ul>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
          3. Quy định Hoàn phí &amp; Rút hồ sơ (BR19)
        </h2>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li><strong>Rút trước ngày khai giảng:</strong> Hoàn trả 100% học phí đã đóng (trừ phí hồ sơ hoặc học liệu ban đầu nếu đã nhận).</li>
          <li><strong>Rút trong 2 tuần đầu khai giảng:</strong> Hoàn trả tương ứng số buổi học còn lại chưa diễn ra, sau khi trừ phí quản trị 10% giá trị khóa học.</li>
          <li><strong>Rút sau quá 1/3 thời lượng khóa học:</strong> Không áp dụng hoàn phí bằng tiền mặt, chỉ hỗ trợ chuyển đổi sang suất học khác hoặc bảo lưu tín chỉ đào tạo.</li>
          <li><strong>Thời gian giải quyết:</strong> Tiền hoàn trả sẽ được chuyển vào tài khoản ngân hàng của phụ huynh đã đăng ký trong vòng 05 đến 07 ngày làm việc kể từ khi hoàn tất biên bản xác nhận.</li>
        </ul>
      </section>
    </div>

    <div style="margin-top: 32px; text-align: center;">
      <a href="${pageContext.request.contextPath}/support" class="btn btn-secondary" style="padding: 10px 24px; display: inline-flex; align-items: center; gap: 8px;">
        <span>Liên hệ bộ phận tư vấn &amp; hỗ trợ</span>
        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"/></svg>
      </a>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
