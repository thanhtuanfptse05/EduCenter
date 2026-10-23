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

    <!-- Stepper 3 Steps -->
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
      <div class="stepper-step active">
        <span class="stepper-num">
          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub">Bước 2</span>
          <span class="stepper-title">Thông tin học viên</span>
        </div>
      </div>
      <div class="stepper-divider"></div>
      <div class="stepper-step">
        <span class="stepper-num">
          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub">Bước 3</span>
          <span class="stepper-title">Tiếp nhận & Xếp lịch</span>
        </div>
      </div>
    </div>

    <!-- Header Section -->
    <div class="screen-heading">
      <span class="screen-eyebrow">Bước 2 / Xác nhận hồ sơ</span>
      <h1>Xác nhận nhu cầu đăng ký học</h1>
      <p>Vui lòng cung cấp thông tin liên hệ chính xác để bộ phận tuyển sinh & đào tạo EduCenter liên hệ xếp lịch khảo sát và tư vấn lộ trình học phù hợp nhất.</p>
    </div>

    <div class="screen-columns">
      <!-- Main Form Section -->
      <section class="screen-card">
        <div class="summary-header" style="margin-bottom: 20px; padding-bottom: 12px;">
          <svg class="icon-md" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          <h2 style="margin:0;">Thông tin liên hệ & Học viên</h2>
        </div>

        <form class="screen-fields" action="${pageContext.request.contextPath}/registration/confirm" method="post">
          <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
          <input type="hidden" name="submissionToken" value="<c:out value='${form.submissionToken}'/>"/>

          <label class="screen-field">
            Họ và tên học sinh / Phụ huynh *
            <input name="fullName" required minlength="2" maxlength="150" autocomplete="name" placeholder="Ví dụ: Nguyễn Văn A" value="<c:out value='${form.fullName}'/>"/>
          </label>

          <label class="screen-field">
            Số điện thoại nhận tư vấn *
            <input name="phoneNumber" type="tel" required maxlength="20" autocomplete="tel" placeholder="Ví dụ: 0912 345 678" value="<c:out value='${form.phoneNumber}'/>"/>
          </label>

          <label class="screen-field">
            Địa chỉ Email nhận thông tin
            <input name="email" type="email" maxlength="255" autocomplete="email" placeholder="Ví dụ: hocsinh@gmail.com" value="<c:out value='${form.email}'/>"/>
          </label>

          <label class="screen-field">
            Khối lớp học tập hiện tại *
            <select name="gradeLevel" required>
              <option value="">Chọn khối lớp</option>
              <c:forEach var="grade" items="${availableGrades}">
                <option value="${grade}" ${form.gradeLevel == grade ? 'selected' : ''}>
                  Lớp <c:out value="${grade}"/>
                </option>
              </c:forEach>
            </select>
          </label>

          <label class="screen-field screen-span">
            Trường THCS / THPT đang theo học
            <input name="schoolName" maxlength="200" placeholder="Ví dụ: THPT Chuyên Hà Nội - Amsterdam" value="<c:out value='${form.schoolName}'/>"/>
          </label>

          <label class="screen-field screen-span">
            Mục tiêu học tập / Kỳ thi quan tâm
            <input name="targetGoals" maxlength="150" placeholder="Ví dụ: Ôn thi tốt nghiệp THPT Khối A 26+, ĐGNL ĐHQG..." value="<c:out value='${empty form.targetGoals ? "" : form.targetGoals[0]}'/>"/>
          </label>

          <label class="screen-field screen-span">
            Nguyện vọng xếp ca / Khung giờ thuận tiện
            <textarea name="notes" maxlength="2000" rows="3" placeholder="Ghi chú thêm về lịch học rảnh trong tuần hoặc mong muốn giáo viên phụ trách..."><c:out value="${form.notes}"/></textarea>
          </label>

          <!-- Consent Checkbox -->
          <div class="screen-span" style="background:var(--surface-muted);border:1px solid var(--border);border-radius:var(--radius-md);padding:14px 16px;">
            <label class="screen-check" style="margin:0;">
              <input type="checkbox" name="consentCheck" value="true" required ${form.consentChecked ? 'checked' : ''}/>
              <span>Tôi đồng ý để EduCenter liên hệ tư vấn về yêu cầu đăng ký này. Cam kết thông tin được bảo mật theo chính sách quyền riêng tư.</span>
            </label>
          </div>

          <c:if test="${not cart.checkoutReady}">
            <p class="screen-warning screen-span">Có khóa học trong danh sách không còn nhận đăng ký. Vui lòng quay lại giỏ để kiểm tra.</p>
          </c:if>

          <div class="screen-actions screen-span" style="margin-top:8px; justify-content: space-between;">
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/registration-cart">
              <svg class="icon-sm" viewBox="0 0 24 24"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
              Quay lại danh sách
            </a>
            <button class="btn btn-primary" type="submit" ${cart.checkoutReady ? '' : 'disabled'} style="padding:10px 24px;font-size:15px;">
              <span>Gửi yêu cầu đăng ký</span>
              <svg class="icon-sm" viewBox="0 0 24 24"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg>
            </button>
          </div>
        </form>
      </section>

      <!-- Aside: Selected Courses Summary -->
      <aside class="cart-summary-card">
        <div class="summary-header">
          <svg class="icon-md" viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10"/><path d="M6 10h10"/></svg>
          <h2>Khóa học đã chọn</h2>
        </div>

        <div class="screen-stack" style="gap:14px;">
          <c:forEach var="item" items="${cart.items}">
            <div class="screen-row" style="padding:10px 0;">
              <div>
                <span class="tag-code"><c:out value="${item.courseCode}"/></span>
                <strong style="display:block;margin:4px 0 2px;"><c:out value="${item.courseName}"/></strong>
                <c:if test="${not empty item.notes}">
                  <p class="screen-muted" style="margin:2px 0 0;font-style:italic;"><c:out value="${item.notes}"/></p>
                </c:if>
              </div>
              <c:choose>
                <c:when test="${item.available}">
                  <span style="font-weight:700;color:var(--primary);white-space:nowrap;"><c:out value="${item.formattedFee}"/></span>
                </c:when>
                <c:otherwise>
                  <span class="screen-warning" style="font-size:12px;padding:2px 8px;">Không còn nhận đăng ký</span>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
        </div>

        <div class="summary-total-box">
          <span class="total-label">Tổng học phí các khóa đang mở</span>
          <div class="summary-total-val"><c:out value="${cart.formattedTotalFee}"/></div>
          <p class="total-note">* Chưa bao gồm ưu đãi combo. Trung tâm tiếp nhận nhu cầu trước khi xác nhận lịch học và xếp lớp.</p>
        </div>

        <div class="summary-trust-badges">
          <div class="trust-item">
            <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            <span><strong>Chưa phát sinh học phí:</strong> Bước này ghi nhận nguyện vọng xếp lịch khảo sát đầu vào.</span>
          </div>
          <div class="trust-item">
            <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
            <span><strong>Tư vấn 24h:</strong> Thầy cô phòng đào tạo sẽ liên hệ trao đổi chi tiết.</span>
          </div>
        </div>
      </aside>
    </div>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
