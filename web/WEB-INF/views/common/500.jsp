<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="500 - Lỗi Hệ Thống Tạm Thời | EduCenter" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
</head>
<body class="error-shell">
    <%@ include file="/WEB-INF/views/common/header.jspf" %>

    <main class="error-main">
        <div class="error-container">
            <div class="error-card">
                <!-- Top ambient line indicating system status alert -->
                <div class="error-top-accent-line" aria-hidden="true"></div>

                <!-- Minimalist Status Badge -->
                <div class="error-status-badge">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning);">
                        <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"></path>
                        <line x1="12" y1="9" x2="12" y2="13"></line>
                        <line x1="12" y1="17" x2="12.01" y2="17"></line>
                    </svg>
                    <span>Mã lỗi HTTP 500 • Sự cố máy chủ nội bộ</span>
                </div>

                <!-- Monumental Error Code -->
                <div class="error-massive-num-wrap">
                    <span class="error-massive-num">500</span>
                </div>

                <!-- Reassuring Heading & Operational Context -->
                <h1 class="error-heading">Hệ thống đang gặp sự cố tạm thời</h1>
                <p class="error-desc">
                    EduCenter hiện chưa thể hoàn thành yêu cầu của bạn do gián đoạn kết nối máy chủ. Đội ngũ kỹ thuật đã được cảnh báo tự động để khắc phục. Chúng tôi rất tiếc vì sự bất tiện này.
                </p>

                <!-- System Incident Audit Box -->
                <div class="error-audit-box">
                    <div class="error-audit-header">
                        <div class="error-audit-title">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                <rect width="20" height="8" x="2" y="2" rx="2" ry="2"></rect>
                                <rect width="20" height="8" x="2" y="14" rx="2" ry="2"></rect>
                                <line x1="6" y1="6" x2="6.01" y2="6"></line>
                                <line x1="6" y1="18" x2="6.01" y2="18"></line>
                            </svg>
                            <span>Nhật ký sự cố hạ tầng</span>
                        </div>
                        <span class="badge badge-warning" style="font-size: 11px;">Cần kiểm tra</span>
                    </div>

                    <%-- Dynamic Incident Reference Code --%>
                    <%
                        long timeSeed = System.currentTimeMillis();
                        String hexRef = Long.toHexString(timeSeed).toUpperCase();
                        String refCode = "EC-202610-" + (hexRef.length() >= 5 ? hexRef.substring(hexRef.length() - 5) : hexRef);
                        String recordTime = new java.text.SimpleDateFormat("dd/MM/yyyy • HH:mm:ss 'GMT+7'").format(new java.util.Date());
                    %>

                    <div class="error-audit-row">
                        <span class="error-audit-label">Mã tham chiếu sự cố:</span>
                        <div class="error-audit-val">
                            <span id="ref-code"><%= refCode %></span>
                            <button type="button" class="error-copy-btn" title="Sao chép mã tham chiếu" onclick="copyIncidentRef();">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <rect width="14" height="14" x="8" y="8" rx="2" ry="2"></rect>
                                    <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <div class="error-audit-row">
                        <span class="error-audit-label">Thời điểm ghi nhận:</span>
                        <span style="font-family: monospace; font-size: 12px; color: var(--text);"><%= recordTime %></span>
                    </div>

                    <div id="copy-feedback" style="display: none; text-align: right; font-size: 11px; color: var(--success); font-weight: 600; margin-top: 4px;">
                        Đã sao chép mã tham chiếu vào bộ nhớ tạm
                    </div>

                    <c:if test="${not empty pageContext.exception}">
                        <div style="margin-top: 10px; padding: 8px 12px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); font-family: monospace; font-size: 11px; color: var(--danger); word-break: break-all; max-height: 80px; overflow-y: auto;">
                            <strong>Chi tiết kỹ thuật:</strong> <c:out value="${pageContext.exception.message}" />
                        </div>
                    </c:if>

                    <!-- Safe Transaction Notice -->
                    <div class="error-safe-notice">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning); flex-shrink: 0; margin-top: 2px;">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                            <polyline points="9 12 11 14 15 10"></polyline>
                        </svg>
                        <div>
                            <strong style="color: var(--text);">Lưu ý an toàn:</strong> Nếu bạn vừa thực hiện thanh toán học phí hoặc gửi hồ sơ xét tuyển, vui lòng không gửi lại liên tục để tránh phát sinh giao dịch trùng lặp.
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="error-actions">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                            <polyline points="9 22 9 12 15 12 15 22"></polyline>
                        </svg>
                        <span>Về trang chủ an toàn</span>
                    </a>
                    <button class="btn btn-secondary" onclick="window.location.reload();" type="button">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                            <path d="M3 3v5h5"></path>
                            <path d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16"></path>
                            <path d="M16 21h5v-5"></path>
                        </svg>
                        <span>Tải lại trang</span>
                    </button>
                </div>

                <!-- Auxiliary Support Direct Link -->
                <div class="error-support-footer">
                    <span>Hỗ trợ kỹ thuật khẩn cấp:</span>
                    <a href="mailto:hotro@educenter.vn">hotro@educenter.vn</a>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/footer.jspf" %>

    <script>
    function copyIncidentRef() {
        var code = document.getElementById('ref-code').innerText.trim();
        if (navigator.clipboard) {
            navigator.clipboard.writeText(code).then(showFeedback);
        } else {
            var input = document.createElement('textarea');
            input.value = code;
            document.body.appendChild(input);
            input.select();
            document.execCommand('copy');
            document.body.removeChild(input);
            showFeedback();
        }
    }

    function showFeedback() {
        var fb = document.getElementById('copy-feedback');
        if (fb) {
            fb.style.display = 'block';
            setTimeout(function () {
                fb.style.display = 'none';
            }, 2500);
        }
    }
    </script>
</body>
</html>
