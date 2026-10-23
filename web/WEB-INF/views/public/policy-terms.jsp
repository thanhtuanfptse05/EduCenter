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
      <span style="color: var(--text-muted);">Quy chế đào tạo &amp; Điều khoản dịch vụ</span>
    </nav>

    <div class="screen-heading" style="margin-bottom: 32px;">
      <span class="screen-eyebrow" style="color: var(--primary); font-weight: 600; text-transform: uppercase; font-size: 13px; letter-spacing: 0.5px;">Pháp lý &amp; Quy định</span>
      <h1 style="font-size: 28px; font-weight: 700; color: var(--text); margin-top: 8px;">Quy Chế Đào Tạo &amp; Điều Khoản Dịch Vụ EduCenter</h1>
      <p style="color: var(--text-muted); font-size: 14px; margin-top: 6px;">Cập nhật lần cuối: Tháng 10/2026 · Áp dụng cho toàn bộ học viên, phụ huynh và đối tác</p>
    </div>

    <div style="display: flex; flex-direction: column; gap: 24px;">
      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
          1. Nguyên tắc chung &amp; Mục đích đào tạo
        </h2>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text); margin-bottom: 12px;">
          EduCenter là đơn vị chuyên sâu về gia sư bồi dưỡng kiến thức, bổ trợ học lực và luyện thi chuyển cấp, THPT Quốc Gia và Đánh Giá Năng Lực (ĐHQG/ĐHBK) từ Lớp 6 đến Lớp 12. Mọi quy trình tác nghiệp học vụ, điểm số và điểm danh đều được số hóa và quản trị minh bạch theo mô hình RBAC chuẩn hóa.
        </p>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text);">
          Khi đăng ký tham gia học tập hoặc sử dụng Cổng Phụ huynh / Học sinh tại EduCenter, người dùng xác nhận đã đọc, hiểu và đồng ý tuân thủ toàn bộ các điều khoản trong văn bản này.
        </p>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          2. Quy định về Xếp lớp &amp; Sĩ số tối đa (BR01, BR02, BR19)
        </h2>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li>Mỗi lớp học duy trì sĩ số nhóm nhỏ (tối đa theo quy định từng khóa, không vượt quá sức chứa phòng học).</li>
          <li>Việc ghi danh chính thức chỉ hoàn tất khi học viên hoàn thành thủ tục học phí theo kỳ hạn hóa đơn quy định.</li>
          <li>Học sinh cần làm bài kiểm tra đánh giá năng lực đầu vào để đảm bảo được phân bổ vào lớp có trình độ và tốc độ tiếp thu tương thích nhất.</li>
          <li>Học viên không được tự ý chuyển lớp hoặc đổi ca học khi chưa có xác nhận điều phối từ Bộ phận Giáo vụ.</li>
        </ul>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
          3. Quy định Chuyên cần &amp; Kỷ luật phòng học (BR11, BR12)
        </h2>
        <ul style="font-size: 14px; line-height: 1.7; color: var(--text); padding-left: 20px;">
          <li>Học viên có mặt đúng giờ trước khi buổi học bắt đầu ít nhất 5 phút. Trường hợp đến muộn sau 15 phút sẽ được tính là Đến muộn (LATE).</li>
          <li>Nghỉ học có phép (ABSENT_EXCUSED): Phụ huynh phải gửi thông báo xin phép qua Cổng Phụ huynh hoặc đường dây nóng trước giờ vào học ít nhất 2 giờ.</li>
          <li>Nghỉ học không phép (ABSENT_UNEXCUSED): Hệ thống sẽ ghi nhận và gửi thông báo khẩn cấp tới phụ huynh trong ngày.</li>
          <li>Nghiêm cấm mọi hành vi gây rối trật tự lớp học, xúc phạm giáo viên/bạn học hoặc gian lận trong kiểm tra định kỳ.</li>
        </ul>
      </section>

      <section class="screen-card" style="padding: 24px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border);">
        <h2 style="font-size: 18px; font-weight: 600; color: var(--text); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
          <svg class="icon icon-sm text-primary" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>
          4. Nghĩa vụ Học phí &amp; Thanh toán (BR06, BR07)
        </h2>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text); margin-bottom: 12px;">
          Học phí được phát hành dưới dạng Hóa đơn điện tử với mã tra cứu duy nhất. Hạn nộp học phí mặc định là 10 ngày kể từ ngày xuất hóa đơn (hoặc theo cấu hình hệ thống).
        </p>
        <p style="font-size: 14px; line-height: 1.6; color: var(--text);">
          Thanh toán được thực hiện trực tiếp tại quầy thu ngân (Tiền mặt) hoặc qua chuyển khoản ngân hàng có mã định danh giao dịch. Phiếu thu điện tử có giá trị pháp lý lưu trữ trên Cổng Phụ huynh.
        </p>
      </section>
    </div>

    <div style="margin-top: 32px; text-align: center;">
      <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary" style="padding: 10px 24px; display: inline-flex; align-items: center; gap: 8px;">
        <span>Khám phá các khóa học</span>
        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
      </a>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
