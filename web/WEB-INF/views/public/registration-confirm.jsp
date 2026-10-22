<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Xác Nhận Nhu Cầu Đăng Ký Khóa Học — EduCenter" />
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
            <!-- Top Stepper Banner -->
            <div class="stepper-card">
                <div class="stepper-container">
                    <!-- Step 1: Completed -->
                    <div class="step-node completed">
                        <div class="step-circle">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                        <div class="step-label-group">
                            <span class="step-phase-tag">Bước 01</span>
                            <span class="step-main-title">Chọn khóa học</span>
                            <span class="step-sub-desc">Đã chọn <c:out value="${cart.totalCourses}" /> khóa học</span>
                        </div>
                    </div>

                    <div class="stepper-divider completed"></div>

                    <!-- Step 2: Active -->
                    <div class="step-node active">
                        <div class="step-circle">2</div>
                        <div class="step-label-group">
                            <span class="step-phase-tag">Bước 02 • Đang thực hiện</span>
                            <span class="step-main-title" style="color: var(--primary);">Xác nhận thông tin &amp; Hồ sơ</span>
                            <span class="step-sub-desc">Điền thông tin tiếp nhận</span>
                        </div>
                    </div>

                    <div class="stepper-divider"></div>

                    <!-- Step 3: Pending -->
                    <div class="step-node" style="opacity: 0.6;">
                        <div class="step-circle">3</div>
                        <div class="step-label-group">
                            <span class="step-phase-tag">Bước 03</span>
                            <span class="step-main-title">Gửi hồ sơ thành công</span>
                            <span class="step-sub-desc">Nhận mã hồ sơ &amp; Lịch thi</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Form & Summary Grid -->
            <div class="cart-layout">
                <!-- Left Column (8 cols): Admission Form -->
                <div style="display: flex; flex-direction: column; gap: 24px;">
                    <div class="form-card">
                        <!-- Form Header -->
                        <div style="border-bottom: 1px solid var(--border); padding-bottom: 16px;">
                            <div style="display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 8px; margin-bottom: 8px;">
                                <span class="form-header-badge">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
                                    Ghi danh học vụ niên khóa 2026
                                </span>
                                <span style="display: inline-flex; align-items: center; gap: 4px; font-size: 11px; font-weight: 600; color: var(--success); background: var(--success-subtle); padding: 3px 8px; border-radius: 4px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                    Mã hóa bảo mật ISO 27001
                                </span>
                            </div>

                            <h1 class="form-title">Thông Tin Tiếp Nhận Tư Vấn &amp; Ghi Danh</h1>
                            <p class="form-subtitle">
                                Vui lòng cung cấp thông tin liên hệ chính xác để thầy cô ban đào tạo liên hệ tư vấn lịch thi đầu vào và xếp lớp phù hợp.
                            </p>

                            <!-- Auto-fill Notification if Logged In -->
                            <c:if test="${not empty sessionScope.currentUser}">
                                <div class="form-autofill-banner" style="margin-top: 12px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                    <span>
                                        Đã tự động điền từ tài khoản đăng nhập (Họ tên: <strong><c:out value="${sessionScope.currentUser.fullName}" /></strong> • SĐT: <strong><c:out value="${sessionScope.currentUser.phone}" /></strong>)
                                    </span>
                                </div>
                            </c:if>
                        </div>

                        <!-- Submit Form -->
                        <form action="${pageContext.request.contextPath}/registration/confirm" method="POST" id="confirmRegistrationForm" style="display: flex; flex-direction: column; gap: 16px;">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                            <!-- Row 1: Full Name & Phone Number -->
                            <div class="form-row-2col">
                                <div class="form-group">
                                    <label for="fullName" class="form-label">
                                        <span>Họ và tên học sinh / Người đăng ký <span style="color: var(--danger);">*</span></span>
                                        <span style="font-size: 11px; color: var(--text-muted); font-weight: normal;">Họ tên khai sinh</span>
                                    </label>
                                    <div class="input-with-icon">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                        <input type="text" id="fullName" name="fullName" required
                                               value="<c:out value='${form.fullName}' />"
                                               class="form-control-input" placeholder="Ví dụ: Nguyễn Văn Tuấn" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="phoneNumber" class="form-label">
                                        <span>Số điện thoại liên hệ (SMS/Zalo) <span style="color: var(--danger);">*</span></span>
                                        <span style="font-size: 11px; color: var(--success); font-weight: 500;">Nhận SMS thông báo</span>
                                    </label>
                                    <div class="input-with-icon">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                                        <input type="tel" id="phoneNumber" name="phoneNumber" required
                                               value="<c:out value='${form.phoneNumber}' />"
                                               class="form-control-input" placeholder="Ví dụ: 0912345678" />
                                    </div>
                                </div>
                            </div>

                            <!-- Row 2: Email & Grade Level -->
                            <div class="form-row-2col">
                                <div class="form-group">
                                    <label for="email" class="form-label">
                                        <span>Email cá nhân nhận học liệu</span>
                                        <span style="font-size: 11px; color: var(--text-muted); font-weight: normal;">Không bắt buộc</span>
                                    </label>
                                    <div class="input-with-icon">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true"><rect width="20" height="16" x="2" y="4" rx="2"></rect><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"></path></svg>
                                        <input type="email" id="email" name="email"
                                               value="<c:out value='${form.email}' />"
                                               class="form-control-input" placeholder="tuan.nguyen@example.com" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="gradeLevel" class="form-label">
                                        <span>Khối lớp hiện tại của học sinh <span style="color: var(--danger);">*</span></span>
                                    </label>
                                    <div class="input-with-icon">
                                        <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                        <select id="gradeLevel" name="gradeLevel" required class="form-control-select">
                                            <option value="12" ${form.gradeLevel == 12 || empty form.gradeLevel ? 'selected' : ''}>Lớp 12 (Ôn thi THPT &amp; ĐGNL 2026)</option>
                                            <option value="11" ${form.gradeLevel == 11 ? 'selected' : ''}>Lớp 11 (Tạo nền tảng Chuyên sâu)</option>
                                            <option value="10" ${form.gradeLevel == 10 ? 'selected' : ''}>Lớp 10 (Chương trình GDPT mới)</option>
                                            <option value="9" ${form.gradeLevel == 9 ? 'selected' : ''}>Lớp 9 (Luyện thi vào 10 Chuyên)</option>
                                        </select>
                                        <svg class="icon icon-sm select-arrow-icon" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 12 15 18 9"></polyline></svg>
                                    </div>
                                </div>
                            </div>

                            <!-- Row 3: School Name -->
                            <div class="form-group">
                                <label for="schoolName" class="form-label">
                                    <span>Trường THPT đang theo học</span>
                                    <span style="font-size: 11px; color: var(--text-muted); font-weight: normal;">Không bắt buộc</span>
                                </label>
                                <div class="input-with-icon">
                                    <svg class="icon icon-sm input-icon" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                    <input type="text" id="schoolName" name="schoolName"
                                           value="<c:out value='${form.schoolName}' />"
                                           class="form-control-input" placeholder="Ví dụ: THPT Chuyên Hà Nội - Amsterdam" />
                                </div>
                            </div>

                            <!-- Row 4: Target Goals (Checkboxes) -->
                            <div class="form-group" style="padding-top: 4px;">
                                <label class="form-label">
                                    <span>Mục tiêu điểm số &amp; Kỳ thi học viên quan tâm</span>
                                    <span style="font-size: 11px; color: var(--text-muted); font-weight: normal;">Có thể chọn nhiều mục tiêu</span>
                                </label>
                                <div class="goals-grid">
                                    <label class="goal-card-label">
                                        <input type="checkbox" name="targetGoals" value="Thi tốt nghiệp THPT" checked />
                                        <div>
                                            <strong style="font-size: 13px; color: var(--text); display: block;">Thi tốt nghiệp THPT</strong>
                                            <span style="font-size: 11px; color: var(--text-muted);">Tập trung tổ hợp KHTN (Toán - Lý - Hóa)</span>
                                        </div>
                                    </label>

                                    <label class="goal-card-label">
                                        <input type="checkbox" name="targetGoals" value="Đánh giá năng lực ĐHQG" checked />
                                        <div>
                                            <strong style="font-size: 13px; color: var(--text); display: block;">Đánh giá năng lực ĐHQG</strong>
                                            <span style="font-size: 11px; color: var(--text-muted);">Luyện đề HSA &amp; VNU-HCM</span>
                                        </div>
                                    </label>

                                    <label class="goal-card-label">
                                        <input type="checkbox" name="targetGoals" value="Xét tuyển học bạ THPT" />
                                        <div>
                                            <strong style="font-size: 13px; color: var(--text); display: block;">Xét tuyển học bạ THPT</strong>
                                            <span style="font-size: 11px; color: var(--text-muted);">Tối ưu điểm tổng kết các kỳ học</span>
                                        </div>
                                    </label>

                                    <label class="goal-card-label">
                                        <input type="checkbox" name="targetGoals" value="Xét tuyển kết hợp chứng chỉ" />
                                        <div>
                                            <strong style="font-size: 13px; color: var(--text); display: block;">Xét tuyển kết hợp chứng chỉ</strong>
                                            <span style="font-size: 11px; color: var(--text-muted);">Kết hợp IELTS / SAT với môn tự nhiên</span>
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <!-- Row 5: Notes & Timeslots -->
                            <div class="form-group">
                                <label for="notes" class="form-label">
                                    <span>Ghi chú nguyện vọng / Khung giờ rảnh kiểm tra đầu vào</span>
                                    <span style="font-size: 11px; color: var(--text-muted); font-weight: normal;">Không bắt buộc</span>
                                </label>
                                <textarea id="notes" name="notes" rows="3" class="form-control-input" style="height: auto; padding: 10px 12px; resize: none;"><c:out value="${form.notes}" /></textarea>
                            </div>

                            <!-- Row 6: Consent Checkbox -->
                            <div style="background: var(--surface-muted); border-radius: var(--radius-md); padding: 12px 14px; display: flex; align-items: flex-start; gap: 10px;">
                                <input type="checkbox" id="consentCheck" name="consentCheck" required checked
                                       style="margin-top: 3px; cursor: pointer; accent-color: var(--primary);" />
                                <label for="consentCheck" style="font-size: 12px; color: var(--text-muted); line-height: 1.5; cursor: pointer; user-select: none;">
                                    Tôi đồng ý nhận thông báo lịch thi thử đầu vào, kết quả xếp lớp và tư vấn lộ trình học tập qua Số điện thoại / Zalo từ trung tâm EduCenter (Bảo mật theo quy chuẩn Quốc tế ISO 27001).
                                </label>
                            </div>

                            <!-- Action Buttons -->
                            <div style="display: flex; flex-direction: column; gap: 12px; align-items: center; justify-content: space-between; padding-top: 8px;" class="sm-row">
                                <a href="${pageContext.request.contextPath}/registration-cart" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                                    <span>Quay lại chỉnh sửa danh sách</span>
                                </a>

                                <button type="submit" class="btn btn-primary" style="height: 44px; padding: 0 32px; font-size: 14px; font-weight: 700; display: inline-flex; align-items: center; gap: 8px;">
                                    <span>Xác nhận gửi hồ sơ đăng ký tư vấn</span>
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Academic Guarantee 3 Cards -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px;">
                        <div class="summary-card" style="box-shadow: none; padding: 16px;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                            <h4 style="font-size: 14px; font-weight: 700; color: var(--text); margin: 6px 0 2px;">Đánh giá chuẩn hóa</h4>
                            <p style="font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0;">Bộ đề test chuẩn format đề Bộ GD&amp;ĐT và ĐHQG.</p>
                        </div>

                        <div class="summary-card" style="box-shadow: none; padding: 16px;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                            <h4 style="font-size: 14px; font-weight: 700; color: var(--text); margin: 6px 0 2px;">Minh bạch cam kết</h4>
                            <p style="font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0;">Ký hợp đồng đào tạo cam kết phổ điểm đầu ra.</p>
                        </div>

                        <div class="summary-card" style="box-shadow: none; padding: 16px;">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 10"></polyline></svg>
                            <h4 style="font-size: 14px; font-weight: 700; color: var(--text); margin: 6px 0 2px;">Đồng hành 1:1</h4>
                            <p style="font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0;">Cố vấn học vụ báo cáo kết quả định kỳ hàng tháng.</p>
                        </div>
                    </div>
                </div>

                <!-- Right Column (4 cols): Registration Summary Box -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <div class="summary-card">
                        <div class="summary-card-header">
                            <h2 class="summary-title">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                Danh mục đăng ký (<c:out value="${cart.totalCourses}" />)
                            </h2>
                            <span class="badge" style="background: var(--surface-muted); color: var(--text-muted); font-size: 11px;">2026</span>
                        </div>

                        <!-- Item list -->
                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <c:forEach var="item" items="${cart.items}">
                                <div style="background: var(--surface-muted); border-radius: var(--radius-md); padding: 12px; display: flex; flex-direction: column; gap: 6px;">
                                    <div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 8px;">
                                        <div>
                                            <strong style="font-size: 13px; color: var(--text); display: block;"><c:out value="${item.courseName}" /></strong>
                                            <span style="font-size: 11px; color: var(--text-muted);">Mã: <c:out value="${item.courseCode}" /> • <c:out value="${item.totalSessions}" /> Buổi</span>
                                        </div>
                                        <span style="font-size: 13px; font-weight: 700; color: var(--text); white-space: nowrap;"><c:out value="${item.formattedFee}" /></span>
                                    </div>
                                    <div style="font-size: 11px; color: var(--primary); font-weight: 500; display: inline-flex; align-items: center; gap: 4px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                        <span>Môn: <c:out value="${item.subjectName}" /></span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Price calculation area -->
                        <div class="summary-fee-list" style="padding-top: 10px; border-top: 1px solid var(--border);">
                            <div class="summary-fee-row">
                                <span>Học phí niêm yết (<c:out value="${cart.totalCourses}" /> môn):</span>
                                <strong style="color: var(--text);"><c:out value="${cart.formattedTotalFee}" /></strong>
                            </div>
                            <c:if test="${cart.discount.compareTo(java.math.BigDecimal.ZERO) > 0}">
                                <div class="summary-fee-row highlight">
                                    <span>Ưu đãi liên môn (Combo Tự Nhiên):</span>
                                    <span><c:out value="${cart.formattedDiscount}" /></span>
                                </div>
                            </c:if>
                            <div class="summary-total-row">
                                <div>
                                    <strong style="font-size: 15px; color: var(--text); display: block;">Tổng chi phí dự kiến:</strong>
                                    <span style="font-size: 11px; color: var(--text-muted);">Bao gồm giáo trình chuẩn hóa</span>
                                </div>
                                <span class="summary-total-num"><c:out value="${cart.formattedFinalFee}" /></span>
                            </div>
                        </div>

                        <!-- Next Steps Timeline -->
                        <div style="display: flex; flex-direction: column; gap: 12px; padding-top: 12px; border-top: 1px solid var(--border);">
                            <strong style="font-size: 13px; color: var(--text); display: flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                Quy trình tiếp nhận sau khi gửi hồ sơ
                            </strong>

                            <div class="timeline-list">
                                <div class="timeline-line"></div>

                                <div class="timeline-step">
                                    <div class="timeline-num">1</div>
                                    <div>
                                        <strong style="font-size: 13px; color: var(--text); display: block;">Xác nhận thông tin hồ sơ</strong>
                                        <p style="font-size: 11px; color: var(--text-muted); line-height: 1.4; margin: 2px 0 0;">
                                            Ban tuyển sinh liên hệ qua điện thoại trong vòng 30 phút để xác thực nhu cầu.
                                        </p>
                                    </div>
                                </div>

                                <div class="timeline-step">
                                    <div class="timeline-num">2</div>
                                    <div>
                                        <strong style="font-size: 13px; color: var(--text); display: block;">Đánh giá năng lực miễn phí</strong>
                                        <p style="font-size: 11px; color: var(--text-muted); line-height: 1.4; margin: 2px 0 0;">
                                            Học sinh làm bài test 45 phút trực tiếp tại cơ sở hoặc online.
                                        </p>
                                    </div>
                                </div>

                                <div class="timeline-step">
                                    <div class="timeline-num">3</div>
                                    <div>
                                        <strong style="font-size: 13px; color: var(--text); display: block;">Tư vấn phân lớp &amp; Hoàn tất</strong>
                                        <p style="font-size: 11px; color: var(--text-muted); line-height: 1.4; margin: 2px 0 0;">
                                            Nhận báo cáo phân tích năng lực chi tiết và xếp ca học chính thức.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Hotline Direct Help -->
                        <div class="hotline-card">
                            <div>
                                <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--text-muted); letter-spacing: 0.05em; display: block;">Hỗ trợ ghi danh 24/7</span>
                                <span class="hotline-num">1900 8866 (Nhánh 1)</span>
                            </div>
                            <span class="badge" style="background: var(--success-subtle); color: var(--success); font-weight: 600;">Miễn cước</span>
                        </div>
                    </div>

                    <!-- Security Note -->
                    <div style="background: var(--surface-muted); border-radius: var(--radius-md); padding: 14px; display: flex; align-items: flex-start; gap: 10px; font-size: 12px; color: var(--text-muted); line-height: 1.5;">
                        <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary); flex-shrink: 0;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        <span>Hồ sơ học thuật của học sinh được lưu trữ bảo mật trên máy chủ chuyên dụng EduCenter Security Cloud theo tiêu chuẩn an toàn dữ liệu giáo dục ISO 27001.</span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>
</body>
</html>
