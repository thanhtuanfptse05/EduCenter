<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Giỏ Đăng Ký Khóa Học — EduCenter" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
</head>
<body>
    <c:set var="activeNav" value="courses" scope="request" />
    <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

    <main style="padding-top: 64px; min-height: calc(100vh - 200px);">
        <!-- Flash Alert Messages -->
        <div style="max-width: 1200px; margin: 16px auto 0; padding: 0 20px;">
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>
        </div>

        <div style="max-width: 1200px; margin: 0 auto; padding: 24px 20px 48px; display: flex; flex-direction: column; gap: 24px;">
            <!-- Breadcrumbs & Heading -->
            <div style="display: flex; flex-direction: column; gap: 8px;">
                <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                    <a href="${pageContext.request.contextPath}/">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                        <span>Trang chủ</span>
                    </a>
                    <span style="color: var(--border);">/</span>
                    <a href="${pageContext.request.contextPath}/courses">Danh mục khóa học</a>
                    <span style="color: var(--border);">/</span>
                    <span style="color: var(--text); font-weight: 600;">Danh sách đăng ký</span>
                </nav>

                <div style="display: flex; flex-direction: column; gap: 4px; margin-top: 4px;">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <h1 style="font-size: 26px; font-weight: 700; color: var(--text); margin: 0; letter-spacing: -0.02em;">
                            Danh Sách Khóa Học Dự Định Đăng Ký
                        </h1>
                        <span class="badge" style="background: var(--primary-subtle); color: var(--primary); font-weight: 600;">
                            <c:out value="${cart.totalCourses}" /> khóa học đã chọn
                        </span>
                    </div>
                    <p style="font-size: 14px; color: var(--text-muted); margin: 0;">
                        Xem lại các chương trình học bạn đã chọn, ghi chú nhu cầu cá nhân trước khi hoàn tất gửi hồ sơ tư vấn tuyển sinh.
                    </p>
                </div>
            </div>

            <!-- Content Area or Empty State -->
            <c:choose>
                <c:when test="${not cart.isEmpty()}">
                    <div class="cart-layout">
                        <!-- Left Column (8 cols): Items list -->
                        <div style="display: flex; flex-direction: column; gap: 20px;">
                            <div style="display: flex; flex-direction: column; gap: 16px;">
                                <c:forEach var="item" items="${cart.items}">
                                    <article class="cart-item-card">
                                        <div class="cart-item-main">
                                            <!-- Thumbnail -->
                                            <div class="cart-item-thumb">
                                                <c:choose>
                                                    <c:when test="${not empty item.imageUrl}">
                                                        <img src="<c:url value='${item.imageUrl}' />" alt="<c:out value='${item.courseName}' />" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: var(--surface-muted); color: var(--primary);">
                                                            <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path></svg>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <span class="cart-item-badge">Khối <c:out value="${item.gradeLevel}" /></span>
                                            </div>

                                            <!-- Main Details -->
                                            <div class="cart-item-details">
                                                <div class="cart-item-topline">
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <span class="cart-subject-chip"><c:out value="${item.subjectName}" /></span>
                                                        <span style="font-size: 12px; font-weight: 600; color: var(--text-muted);">Mã: <c:out value="${item.courseCode}" /></span>
                                                    </div>

                                                    <!-- Remove Form -->
                                                    <form action="${pageContext.request.contextPath}/registration-cart/remove" method="POST" style="margin: 0;">
                                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                        <input type="hidden" name="courseId" value="${item.courseId}" />
                                                        <button type="submit" class="btn btn-ghost btn-sm" style="color: var(--danger); padding: 4px;" title="Xóa khỏi danh sách">
                                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                        </button>
                                                    </form>
                                                </div>

                                                <h3 class="cart-item-title">
                                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${item.courseId}" style="color: inherit; text-decoration: none;">
                                                        <c:out value="${item.courseName}" />
                                                    </a>
                                                </h3>

                                                <div class="cart-item-meta-strip">
                                                    <span style="display: inline-flex; align-items: center; gap: 4px;">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                                        <c:out value="${item.totalSessions}" /> buổi học
                                                    </span>
                                                    <span>•</span>
                                                    <span style="display: inline-flex; align-items: center; gap: 4px;">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                                        Nhóm tối đa <c:out value="${item.maxCapacity}" /> HV
                                                    </span>
                                                </div>

                                                <div class="cart-item-price-line">
                                                    <span style="font-size: 13px; color: var(--text-muted);">Học phí niêm yết:</span>
                                                    <span class="cart-item-price-num"><c:out value="${item.formattedFee}" /></span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Notes box -->
                                        <div class="cart-note-box">
                                            <label class="cart-note-label">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                Ghi chú nguyện vọng / Lịch học ưu tiên:
                                            </label>
                                            <input type="text" readonly value="<c:out value='${item.notes != null ? item.notes : "Học sinh muốn kiểm tra đầu vào và tư vấn ca học phù hợp."}' />" class="cart-note-textarea" />
                                        </div>

                                        <div style="display: flex; align-items: center; justify-content: space-between; font-size: 13px; padding-top: 4px;">
                                            <a href="${pageContext.request.contextPath}/courses/detail?id=${item.courseId}" style="color: var(--primary); font-weight: 500; display: inline-flex; align-items: center; gap: 4px;">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 16 16 12 12 8"></polyline><line x1="8" y1="12" x2="16" y2="12"></line></svg>
                                                Xem lại chi tiết đề cương
                                            </a>
                                            <span style="color: var(--text-muted); font-size: 12px;">Trạng thái: Sẵn sàng xếp lớp</span>
                                        </div>
                                    </article>
                                </c:forEach>
                            </div>

                            <!-- Cart Actions Row -->
                            <div style="display: flex; flex-direction: column; gap: 12px; align-items: center; justify-content: space-between;" class="sm-row">
                                <a href="${pageContext.request.contextPath}/courses" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                                    <span>Tiếp tục chọn thêm khóa học khác</span>
                                </a>

                                <form action="${pageContext.request.contextPath}/registration-cart/clear" method="POST" style="margin: 0;" onsubmit="return confirm('Bạn có chắc chắn muốn làm trống danh sách đăng ký?');">
                                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                    <button type="submit" class="btn btn-ghost" style="color: var(--danger); font-size: 13px; display: inline-flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                        <span>Làm trống danh sách đăng ký</span>
                                    </button>
                                </form>
                            </div>

                            <!-- Assessment Info Banner -->
                            <div class="incentive-box" style="padding: 16px;">
                                <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                <div>
                                    <strong style="color: var(--text); font-size: 14px; display: block; margin-bottom: 2px;">Kiểm tra đầu vào chuẩn hóa (Miễn phí 100%)</strong>
                                    Mỗi học viên sẽ thực hiện một bài test năng lực 45 phút trước khi xếp tổ bộ môn. Giáo viên chủ nhiệm sẽ dựa vào phổ điểm chi tiết để xếp vào lớp nâng cao hoặc lớp tiêu chuẩn phù hợp nhất.
                                </div>
                            </div>
                        </div>

                        <!-- Right Column (4 cols): Sticky Summary Sidebar -->
                        <div style="display: flex; flex-direction: column; gap: 20px; position: sticky; top: 80px;">
                            <div class="summary-card">
                                <div class="summary-card-header">
                                    <h2 class="summary-title">
                                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>
                                        Tổng Kết Hồ Sơ Đăng Ký
                                    </h2>
                                    <span class="badge" style="background: var(--surface-muted); color: var(--text-muted); font-size: 11px;">TẠM TÍNH</span>
                                </div>

                                <div class="summary-fee-list">
                                    <div class="summary-fee-row">
                                        <span>Số lượng khóa học:</span>
                                        <strong style="color: var(--text);"><c:out value="${cart.totalCourses}" /> khóa</strong>
                                    </div>
                                    <div class="summary-fee-row">
                                        <span>Tạm tính học phí niêm yết:</span>
                                        <strong style="color: var(--text);"><c:out value="${cart.formattedTotalFee}" /></strong>
                                    </div>
                                    <c:if test="${cart.discount.compareTo(java.math.BigDecimal.ZERO) > 0}">
                                        <div class="summary-fee-row highlight">
                                            <span>Ưu đãi học combo (từ 2 môn):</span>
                                            <span><c:out value="${cart.formattedDiscount}" /></span>
                                        </div>
                                    </c:if>

                                    <div class="summary-total-row">
                                        <div>
                                            <strong style="font-size: 15px; color: var(--text); display: block;">Tổng học phí dự kiến:</strong>
                                            <span style="font-size: 11px; color: var(--text-muted);">(Đã tính chiết khấu combo)</span>
                                        </div>
                                        <span class="summary-total-num"><c:out value="${cart.formattedFinalFee}" /></span>
                                    </div>
                                </div>

                                <div style="background: var(--surface-muted); border-radius: 6px; padding: 10px; font-size: 12px; color: var(--text-muted); line-height: 1.5;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning); vertical-align: text-bottom; margin-right: 4px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                    Học phí chính thức, chính sách miễn giảm bổ sung và lịch học cụ thể sẽ được ban tuyển sinh xác nhận trong buổi tư vấn trực tiếp xếp lớp.
                                </div>

                                <!-- CTA Proceed to Confirmation -->
                                <a href="${pageContext.request.contextPath}/registration/confirm" class="btn btn-primary" style="height: 44px; font-size: 14px; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none;">
                                    <span>Tiến hành gửi thông tin đăng ký</span>
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                                </a>

                                <!-- Trust commitments -->
                                <div class="guarantee-list">
                                    <div class="guarantee-item">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                        <span>Cam kết xếp lớp đúng trình độ qua test 0đ</span>
                                    </div>
                                    <div class="guarantee-item">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                        <span>Không phát sinh chi phí giáo trình tài liệu</span>
                                    </div>
                                    <div class="guarantee-item">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                        <span>Trợ giảng 1:1 kèm bài tập hàng tuần</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Hotline Quick Connect -->
                            <div class="hotline-card">
                                <div>
                                    <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--text-muted); letter-spacing: 0.05em; display: block;">Hỗ trợ tuyển sinh 24/7</span>
                                    <span class="hotline-num">1900 8866 (Nhánh 1)</span>
                                </div>
                                <span class="badge" style="background: var(--success-subtle); color: var(--success); font-weight: 600;">Miễn cước</span>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Empty Cart State -->
                    <div class="empty-state-card" style="margin-top: 16px;">
                        <div class="empty-state-icon">
                            <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                        </div>
                        <h3 class="empty-state-title">Danh sách đăng ký đang trống</h3>
                        <p class="empty-state-desc">
                            Bạn chưa chọn khóa học nào. Hãy khám phá ngay các chương trình ôn luyện THPT Quốc Gia, ĐGNL và bồi dưỡng kiến thức chuyên sâu tại EduCenter.
                        </p>
                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary" style="margin-top: 8px; display: inline-flex; align-items: center; gap: 8px;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            <span>Khám phá khóa học ngay</span>
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
