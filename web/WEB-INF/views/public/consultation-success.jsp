<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="Đăng Ký Tư Vấn Thành Công — EduCenter" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
    <style>
        @media print {
            .public-nav-header, .public-page-footer, .stepper-card, .btn, .no-print {
                display: none !important;
            }
            main { padding-top: 0 !important; }
            #printReceiptArea {
                border: 1px solid #000 !important;
                box-shadow: none !important;
            }
        }
    </style>
</head>
<body>
    <c:set var="activeNav" value="courses" scope="request" />
    <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

    <main style="padding-top: 64px; min-height: calc(100vh - 200px);">
        <!-- Flash Alert Messages -->
        <div style="max-width: 1040px; margin: 16px auto 0; padding: 0 20px;">
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>
        </div>

        <div style="max-width: 1040px; margin: 0 auto; padding: 24px 20px 48px; display: flex; flex-direction: column; gap: 24px;">
            <!-- Stepper Component: 3 Completed Steps -->
            <div class="stepper-card">
                <div class="stepper-container">
                    <!-- Step 1 -->
                    <div class="step-node completed">
                        <div class="step-circle">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                        <div class="step-label-group">
                            <span class="step-phase-tag">Bước 01</span>
                            <span class="step-main-title">Chọn khóa học</span>
                            <span class="step-sub-desc" style="color: var(--success); font-weight: 500;">Hoàn thành</span>
                        </div>
                    </div>

                    <div class="stepper-divider completed"></div>

                    <!-- Step 2 -->
                    <div class="step-node completed">
                        <div class="step-circle">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                        <div class="step-label-group">
                            <span class="step-phase-tag">Bước 02</span>
                            <span class="step-main-title">Xác nhận thông tin</span>
                            <span class="step-sub-desc" style="color: var(--success); font-weight: 500;">Hoàn thành</span>
                        </div>
                    </div>

                    <div class="stepper-divider completed"></div>

                    <!-- Step 3 (Active Success) -->
                    <div class="step-node completed">
                        <div class="step-circle" style="background: var(--success); border-color: var(--success); box-shadow: 0 0 0 4px var(--success-subtle);">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        </div>
                        <div class="step-label-group">
                            <span class="step-phase-tag" style="color: var(--success);">Bước 03 • Hoàn tất</span>
                            <span class="step-main-title" style="color: var(--success);">Gửi hồ sơ thành công</span>
                            <span class="step-sub-desc">Hồ sơ đã tiếp nhận</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Layout (2 Columns) -->
            <div style="display: grid; grid-template-columns: 1fr; gap: 24px; align-items: start;" class="lg-grid-2col">
                <!-- Left Column (7 cols): Success Notification & Next Steps -->
                <div style="display: flex; flex-direction: column; gap: 24px;">
                    <!-- Main Centered Success Banner Card -->
                    <div class="success-hero-card">
                        <div class="success-icon-badge">
                            <svg class="icon icon-xl" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                        </div>

                        <div>
                            <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--success); letter-spacing: 0.05em; display: inline-flex; align-items: center; gap: 6px;">
                                <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--success); display: inline-block;"></span>
                                Tuyển sinh 2026 • Ghi danh trực tuyến
                            </span>
                            <h1 style="font-size: 24px; font-weight: 800; color: var(--text); margin: 6px 0 8px; letter-spacing: -0.02em;">
                                Gửi Yêu Cầu Đăng Ký Khóa Học Thành Công!
                            </h1>
                            <p style="font-size: 14px; color: var(--text-muted); line-height: 1.6; margin: 0;">
                                Hệ thống EduCenter đã tiếp nhận hồ sơ đăng ký của bạn. Chuyên viên tư vấn học vụ sẽ liên hệ qua số điện thoại đăng ký trong vòng <strong style="color: var(--text); text-decoration: underline; text-decoration-color: var(--success);">30 phút</strong> để xác nhận thông tin và xếp lịch kiểm tra năng lực đầu vào miễn phí.
                            </p>
                        </div>

                        <div style="background: var(--surface-muted); border-radius: var(--radius-md); padding: 12px 16px; display: flex; align-items: center; gap: 12px;">
                            <div style="width: 36px; height: 36px; border-radius: 8px; background: var(--surface); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 10"></polyline></svg>
                            </div>
                            <div>
                                <strong style="font-size: 13px; color: var(--text); display: block;">Thời gian hỗ trợ tư vấn học vụ</strong>
                                <span style="font-size: 12px; color: var(--text-muted);">Thứ 2 – Chủ Nhật: 08:00 – 21:30 (Không nghỉ lễ)</span>
                            </div>
                        </div>
                    </div>

                    <!-- Next Steps Process Guide -->
                    <div class="summary-card">
                        <div class="summary-card-header">
                            <h2 class="summary-title">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                Quy Trình Hoàn Tất Nhập Học
                            </h2>
                            <span class="badge" style="background: var(--surface-muted); color: var(--text-muted); font-size: 11px;">3 BƯỚC CHUẨN HÓA</span>
                        </div>

                        <div style="display: flex; flex-direction: column; gap: 18px;">
                            <!-- Step 1 -->
                            <div style="display: flex; align-items: flex-start; gap: 14px;">
                                <div class="timeline-num" style="background: var(--surface-muted); color: var(--text);">01</div>
                                <div style="display: flex; flex-direction: column; gap: 2px;">
                                    <div style="display: flex; align-items: center; justify-content: space-between;">
                                        <strong style="font-size: 13px; color: var(--text);">Nhận cuộc gọi xác nhận từ chuyên viên tư vấn</strong>
                                        <span style="font-size: 11px; color: var(--success); font-weight: 600;">Hotline 1900 8866</span>
                                    </div>
                                    <p style="font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                                        Chuyên viên sẽ rà soát thông tin học sinh, giải đáp thắc mắc về khung chương trình và thống nhất hình thức thi thử năng lực (online hoặc trực tiếp).
                                    </p>
                                </div>
                            </div>

                            <!-- Step 2 -->
                            <div style="display: flex; align-items: flex-start; gap: 14px;">
                                <div class="timeline-num" style="background: var(--surface-muted); color: var(--text);">02</div>
                                <div style="display: flex; flex-direction: column; gap: 2px;">
                                    <div style="display: flex; align-items: center; justify-content: space-between;">
                                        <strong style="font-size: 13px; color: var(--text);">Tham gia bài test đánh giá năng lực 45 phút</strong>
                                        <span style="font-size: 11px; color: var(--primary); font-weight: 600;">Miễn phí 100%</span>
                                    </div>
                                    <p style="font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                                        Bài kiểm tra trắc nghiệm kết hợp tự luận ngắn giúp định vị lỗ hổng kiến thức hiện tại, chuẩn bị dữ liệu cho việc xếp lớp đúng trình độ.
                                    </p>
                                </div>
                            </div>

                            <!-- Step 3 -->
                            <div style="display: flex; align-items: flex-start; gap: 14px;">
                                <div class="timeline-num" style="background: var(--surface-muted); color: var(--text);">03</div>
                                <div style="display: flex; flex-direction: column; gap: 2px;">
                                    <div style="display: flex; align-items: center; justify-content: space-between;">
                                        <strong style="font-size: 13px; color: var(--text);">Nhận báo cáo phổ điểm &amp; Học thử buổi đầu</strong>
                                        <span style="font-size: 11px; color: var(--warning); font-weight: 600;">Cá nhân hóa</span>
                                    </div>
                                    <p style="font-size: 12px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                                        Nhận sơ đồ tư duy phân tích điểm mạnh - điểm yếu và tham gia 01 buổi học thử cùng giáo viên chủ nhiệm bộ môn.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (5 cols): Receipt Card & Action Buttons -->
                <div style="display: flex; flex-direction: column; gap: 20px;">
                    <!-- Printable Receipt Area -->
                    <div class="summary-card" id="printReceiptArea">
                        <div class="summary-card-header">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                                <span style="font-size: 15px; font-weight: 700; color: var(--text);">Phiếu Tiếp Nhận Hồ Sơ</span>
                            </div>
                            <span class="badge" style="background: var(--success); color: #ffffff; font-weight: 600; font-size: 11px;">Chờ Xác Nhận</span>
                        </div>

                        <!-- Lead Code Box with Copy Button -->
                        <div class="success-lead-code-box">
                            <div>
                                <span style="font-size: 11px; color: var(--text-muted); display: block;">Mã hồ sơ tuyển sinh</span>
                                <span class="lead-code-text" id="leadCodeValue"><c:out value="${leadCode}" /></span>
                            </div>
                            <button type="button" class="btn btn-secondary btn-sm" id="btnCopyLeadCode" onclick="copyLeadCode()" style="font-size: 12px; display: inline-flex; align-items: center; gap: 4px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"></rect><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path></svg>
                                <span id="copyBtnText">Sao chép</span>
                            </button>
                        </div>

                        <!-- Lead Meta Details -->
                        <div style="display: flex; flex-direction: column; gap: 10px; font-size: 13px;">
                            <div style="display: flex; align-items: center; justify-content: space-between; padding-bottom: 8px; border-bottom: 1px solid var(--border);">
                                <span style="color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 10"></polyline></svg>
                                    Thời gian nộp
                                </span>
                                <span style="font-weight: 600; color: var(--text);">Vừa xong</span>
                            </div>

                            <c:if test="${not empty sessionScope.LAST_LEAD_NAME}">
                                <div style="display: flex; align-items: center; justify-content: space-between; padding-bottom: 8px; border-bottom: 1px solid var(--border);">
                                    <span style="color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                        Họ tên thí sinh
                                    </span>
                                    <span style="font-weight: 700; color: var(--text);"><c:out value="${sessionScope.LAST_LEAD_NAME}" /></span>
                                </div>
                            </c:if>

                            <c:if test="${not empty sessionScope.LAST_LEAD_PHONE}">
                                <div style="display: flex; align-items: center; justify-content: space-between; padding-bottom: 8px; border-bottom: 1px solid var(--border);">
                                    <span style="color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                                        Điện thoại
                                    </span>
                                    <span style="font-weight: 600; color: var(--text);"><c:out value="${sessionScope.LAST_LEAD_PHONE}" /></span>
                                </div>
                            </c:if>

                            <c:if test="${not empty sessionScope.LAST_LEAD_GRADE}">
                                <div style="display: flex; align-items: center; justify-content: space-between; padding-bottom: 8px; border-bottom: 1px solid var(--border);">
                                    <span style="color: var(--text-muted); display: flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                        Khối lớp đăng ký
                                    </span>
                                    <span class="badge" style="background: var(--primary-subtle); color: var(--primary); font-weight: 600;">
                                        Khối <c:out value="${sessionScope.LAST_LEAD_GRADE}" />
                                    </span>
                                </div>
                            </c:if>
                        </div>

                        <div style="background: var(--surface-muted); border-radius: 6px; padding: 10px; font-size: 12px; color: var(--text-muted); line-height: 1.5; font-style: italic;">
                            Học phí chính thức và lịch học sẽ được kích hoạt sau khi học sinh xác nhận thời khóa biểu và tham gia kiểm tra năng lực đầu vào.
                        </div>
                    </div>

                    <!-- Action Navigation Group -->
                    <div style="display: flex; flex-direction: column; gap: 10px;" class="no-print">
                        <a href="${pageContext.request.contextPath}/courses" class="btn btn-primary" style="height: 44px; font-size: 14px; font-weight: 700; display: flex; align-items: center; justify-content: center; gap: 8px; text-decoration: none;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                            <span>Khám phá thêm các khóa học khác</span>
                        </a>

                        <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px;">
                            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary" style="height: 40px; display: flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                                <span>Về trang chủ</span>
                            </a>

                            <button type="button" class="btn btn-secondary" onclick="window.print()" style="height: 40px; display: flex; align-items: center; justify-content: center; gap: 6px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect width="12" height="8" x="6" y="14"></rect></svg>
                                <span>In phiếu tiếp nhận</span>
                            </button>
                        </div>

                        <!-- Hotline Support Box -->
                        <div class="hotline-card" style="margin-top: 4px;">
                            <div>
                                <span style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: var(--text-muted); letter-spacing: 0.05em; display: block;">Hỗ trợ tuyển sinh khẩn cấp</span>
                                <span class="hotline-num">1900 8866 (Trực ban 24/7)</span>
                            </div>
                            <a href="mailto:tuyensinh@educenter.edu.vn" style="font-size: 12px; color: var(--primary); font-weight: 600; text-decoration: underline;">
                                Email liên hệ
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>

    <script>
    function copyLeadCode() {
        var codeEl = document.getElementById('leadCodeValue');
        if (!codeEl) return;
        var text = codeEl.innerText.trim();
        navigator.clipboard.writeText(text).then(function() {
            var label = document.getElementById('copyBtnText');
            if (label) {
                var prev = label.innerText;
                label.innerText = 'Đã chép!';
                label.style.color = 'var(--success)';
                setTimeout(function() {
                    label.innerText = prev;
                    label.style.color = '';
                }, 2000);
            }
        }).catch(function(err) {
            console.error('Không thể sao chép: ', err);
        });
    }
    </script>
</body>
</html>
