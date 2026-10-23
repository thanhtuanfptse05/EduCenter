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

    <!-- Header Section -->
    <div class="screen-heading">
      <span class="screen-eyebrow">Quy trình tuyển sinh & Ghi danh</span>
      <h1>Danh sách đăng ký khóa học</h1>
      <p>Kiểm tra các chương trình đào tạo đã chọn, bổ sung nguyện vọng xếp ca và gửi yêu cầu tư vấn xếp lớp tới phòng đào tạo EduCenter.</p>
    </div>

    <!-- Stepper Progress Bar (3-Step Flow) -->
    <div class="screen-stepper-wrap" aria-label="Tiến trình đăng ký">
      <div class="stepper-step active">
        <span class="stepper-num">
          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"/><path d="M3 6h18"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub">Bước 1</span>
          <span class="stepper-title">Khóa học & Nguyện vọng</span>
        </div>
      </div>
      <div class="stepper-divider"></div>
      <div class="stepper-step">
        <span class="stepper-num">
          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
        </span>
        <div class="stepper-meta">
          <span class="stepper-sub">Bước 2</span>
          <span class="stepper-title">Xác nhận thông tin học viên</span>
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

    <c:choose>
      <c:when test="${empty cart.items}">
        <div class="screen-card screen-empty">
          <div class="empty-icon-wrap">
            <svg class="icon-lg" viewBox="0 0 24 24"><circle cx="8" cy="21" r="1"/><circle cx="19" cy="21" r="1"/><path d="M2.05 2.05h2l2.66 12.42a2 2 0 0 0 2 1.58h9.78a2 2 0 0 0 1.95-1.57l1.65-7.43H5.12"/></svg>
          </div>
          <h2>Bạn chưa chọn khóa học nào</h2>
          <p>Danh sách của bạn đang trống. Khám phá các khóa học bổ trợ kiến thức và luyện thi chất lượng cao tại EduCenter để tìm chương trình phù hợp nhất.</p>
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/courses">
            <svg class="icon-sm" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>
            Khám phá khóa học ngay
          </a>
        </div>
      </c:when>

      <c:otherwise>
        <div class="screen-columns">
          <!-- Main Content: Course Item List -->
          <div class="screen-stack">
            <div class="cart-list-header">
              <span class="cart-list-title">
                <svg class="icon-md" viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10"/><path d="M6 10h10"/></svg>
                Khóa học đã chọn (<c:out value="${cart.totalCourses}"/>)
              </span>
              <span class="cart-list-hint">Ghi chú ca học mong muốn để được xếp lớp tối ưu</span>
            </div>

            <c:forEach var="item" items="${cart.items}">
              <article class="cart-item-card">
                <!-- Thumbnail Box -->
                <div class="cart-item-thumb-box">
                  <c:choose>
                    <c:when test="${not empty item.imageUrl}">
                      <img class="cart-item-img" src="<c:url value='${item.imageUrl}'/>" alt="<c:out value='${item.courseName}'/>" loading="lazy" />
                    </c:when>
                    <c:otherwise>
                      <div class="cart-item-placeholder">
                        <svg class="icon-lg" viewBox="0 0 24 24"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/><path d="M6 6h10"/><path d="M6 10h10"/></svg>
                      </div>
                    </c:otherwise>
                  </c:choose>
                  <c:if test="${not empty item.gradeLevel}">
                    <span class="cart-thumb-badge">Lớp <c:out value="${item.gradeLevel}"/></span>
                  </c:if>
                </div>

                <!-- Main Details -->
                <div class="cart-item-content">
                  <div class="cart-item-top">
                    <div class="cart-item-heading">
                      <div class="cart-item-tags">
                        <span class="tag-code"><c:out value="${item.courseCode}"/></span>
                        <c:if test="${not empty item.subjectName}">
                          <span class="tag-subject"><c:out value="${item.subjectName}"/></span>
                        </c:if>
                        <c:choose>
                          <c:when test="${item.available}">
                            <span class="tag-status status-open">Đang mở tuyển sinh</span>
                          </c:when>
                          <c:otherwise>
                            <span class="tag-status status-closed">Tạm đóng</span>
                          </c:otherwise>
                        </c:choose>
                      </div>

                      <h2 class="cart-item-title">
                        <a href="${pageContext.request.contextPath}/courses/detail?id=${item.courseId}">
                          <c:out value="${item.courseName}"/>
                        </a>
                      </h2>
                    </div>

                    <!-- Pricing & Remove Button -->
                    <div class="cart-item-pricing">
                      <c:choose>
                        <c:when test="${item.available}">
                          <span class="price-label">Học phí niêm yết</span>
                          <span class="price-val"><c:out value="${item.formattedFee}"/></span>
                        </c:when>
                        <c:otherwise>
                          <span class="price-label">Trạng thái</span>
                          <span class="price-closed">Chưa công bố</span>
                        </c:otherwise>
                      </c:choose>

                      <form action="${pageContext.request.contextPath}/registration-cart/remove" method="post" class="cart-remove-form">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                        <input type="hidden" name="courseId" value="${item.courseId}"/>
                        <button class="btn-remove-item" type="submit" title="Xóa khỏi danh sách">
                          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
                          <span>Xóa</span>
                        </button>
                      </form>
                    </div>
                  </div>

                  <!-- Course Meta Chips -->
                  <div class="cart-item-chips">
                    <span class="meta-chip">
                      <svg class="icon-sm" viewBox="0 0 24 24"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                      <c:out value="${item.totalSessions != null ? item.totalSessions : 24}"/> buổi học
                    </span>
                    <c:if test="${not empty item.teacherName}">
                      <span class="meta-chip">
                        <svg class="icon-sm" viewBox="0 0 24 24"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                        GV: <c:out value="${item.teacherName}"/>
                      </span>
                    </c:if>
                    <c:if test="${not empty item.maxCapacity && item.maxCapacity > 0}">
                      <span class="meta-chip">
                        <svg class="icon-sm" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                        Tối đa <c:out value="${item.maxCapacity}"/> hv/lớp
                      </span>
                    </c:if>
                  </div>

                  <c:if test="${not item.available}">
                    <p class="screen-warning">Khóa học này không còn mở đăng ký hoặc chưa công bố học phí. Vui lòng xóa khỏi danh sách trước khi xác nhận.</p>
                  </c:if>

                  <!-- Schedule Notes Form -->
                  <div class="cart-item-notes-box">
                    <form action="${pageContext.request.contextPath}/registration-cart/update" method="post" class="cart-notes-form">
                      <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                      <input type="hidden" name="courseId" value="${item.courseId}"/>
                      <div class="notes-header">
                        <label for="notes-${item.courseId}" class="notes-label">
                          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
                          Ghi chú / Lịch học mong muốn:
                        </label>
                        <button class="btn btn-secondary btn-save-notes" type="submit">
                          <svg class="icon-sm" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                          Lưu ghi chú
                        </button>
                      </div>
                      <textarea id="notes-${item.courseId}" name="notes" maxlength="500" rows="2" class="notes-textarea" placeholder="VD: Muốn học ca tối thứ 3 - 5 hoặc sáng Chủ nhật, học sinh cần hỗ trợ kiến thức chuyển cấp..."><c:out value="${item.notes}"/></textarea>
                    </form>
                  </div>
                </div>
              </article>
            </c:forEach>

            <!-- Bottom Navigation Actions -->
            <div class="cart-bottom-actions">
              <a class="btn btn-secondary" href="${pageContext.request.contextPath}/courses">
                <svg class="icon-sm" viewBox="0 0 24 24"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                Chọn thêm khóa học
              </a>
              <form action="${pageContext.request.contextPath}/registration-cart/clear" method="post" class="cart-clear-form">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
                <button class="btn btn-ghost" type="submit" onclick="return confirm('Bạn có chắc chắn muốn làm trống danh sách đăng ký?');">
                  <svg class="icon-sm" viewBox="0 0 24 24"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>
                  Làm trống danh sách
                </button>
              </form>
            </div>
          </div>

          <!-- Aside: Executive Registration Summary -->
          <aside class="cart-summary-card">
            <div class="summary-header">
              <svg class="icon-md" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
              <h2>Tóm tắt đăng ký</h2>
            </div>

            <div class="summary-breakdown">
              <div class="summary-row">
                <span>Số khóa đã chọn</span>
                <strong><c:out value="${cart.totalCourses}"/> khóa</strong>
              </div>
              <div class="summary-row">
                <span>Kiểm tra năng lực đầu vào</span>
                <span class="chip-free">Miễn phí 100%</span>
              </div>
              <div class="summary-row">
                <span>Giáo trình & Đề thi bổ trợ</span>
                <span class="chip-included">Đã bao gồm</span>
              </div>
            </div>

            <div class="summary-total-box">
              <span class="total-label">Tổng học phí các khóa đang mở</span>
              <div class="summary-total-val"><c:out value="${cart.formattedTotalFee}"/></div>
              <p class="total-note">* Học phí niêm yết theo thông tin đào tạo hiện tại. Chưa áp dụng các chính sách học bổng hoặc ưu đãi đăng ký sớm.</p>
            </div>

            <div class="summary-trust-badges">
              <div class="trust-item">
                <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                <span><strong>Chưa phát sinh thanh toán:</strong> Yêu cầu được gửi đến phòng đào tạo để xếp lịch học thử và sắp xếp lớp học.</span>
              </div>
              <div class="trust-item">
                <svg class="icon-sm" viewBox="0 0 24 24"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                <span><strong>Hỗ trợ nhanh trong 24h:</strong> Thầy cô ban chuyên môn sẽ liên hệ tư vấn lộ trình và ca học tối ưu.</span>
              </div>
              <div class="trust-item">
                <svg class="icon-sm" viewBox="0 0 24 24"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <span><strong>Bảo mật thông tin:</strong> Dữ liệu học sinh và phụ huynh được mã hóa và bảo mật nghiêm ngặt.</span>
              </div>
            </div>

            <c:choose>
              <c:when test="${cart.checkoutReady}">
                <a class="btn btn-primary btn-checkout" href="${pageContext.request.contextPath}/registration/confirm">
                  <span>Tiếp tục đăng ký</span>
                  <svg class="icon-sm" viewBox="0 0 24 24"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                </a>
              </c:when>
              <c:otherwise>
                <p class="screen-warning">Cần cập nhật hoặc xóa khóa học không còn nhận đăng ký trước khi tiếp tục.</p>
              </c:otherwise>
            </c:choose>
          </aside>
        </div>
      </c:otherwise>
    </c:choose>
  </main>

  <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
