<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher-ops.css?v=20261024_01">
    <style>
        @media print {
            .admin-sidebar, .admin-header, .ops-top-bar, .ops-sticky-bar, .no-print {
                display: none !important;
            }
            .admin-main { margin: 0 !important; padding: 0 !important; }
            .admin-content { padding: 0 !important; }
            .ops-hero-card, .ops-journal-section { box-shadow: none !important; border: 1px solid #000 !important; }
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="attendance" scope="request" />
    <c:set var="breadcrumb" value="Giảng dạy / Sổ đầu bài & Nhật ký" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="ops-wrap">
                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- 1. Top Navigation & Quick Switcher -->
                <div class="ops-top-bar no-print">
                    <div class="ops-top-left">
                        <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${sessionData.sessionId}" class="ops-back-btn">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                            <span>Quay lại sổ điểm danh ca học</span>
                        </a>
                        <span class="ops-code-pill">CA-${sessionData.sessionId}</span>
                    </div>

                    <div class="ops-tabs">
                        <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${sessionData.sessionId}" class="ops-tab-item">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 11l3 3L22 4"></path><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                            <span>Điểm danh học sinh</span>
                        </a>
                        <span class="ops-tab-item active">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                            <span>Sổ đầu bài &amp; Nhật ký</span>
                        </span>
                    </div>
                </div>

                <!-- 2. Session Overview Summary Banner -->
                <div class="ops-hero-card">
                    <div class="ops-hero-main">
                        <div class="ops-hero-title-row">
                            <h1 class="ops-hero-title">Sổ Đầu Bài &amp; Nhật Ký Giảng Dạy Buổi Học</h1>
                            <span class="badge" style="background: var(--surface-muted); color: var(--primary); font-weight: 700;">
                                <c:out value="${sessionData.classCode}" />
                            </span>
                            <c:choose>
                                <c:when test="${sessionData.sessionStatus == 'COMPLETED'}">
                                    <span class="badge" style="background: #DCFCE7; color: #15803D; font-weight: 700;">ĐÃ HOÀN TẤT</span>
                                </c:when>
                                <c:when test="${sessionData.sessionStatus == 'IN_PROGRESS'}">
                                    <span class="badge" style="background: #FEF9C3; color: #854D0E; font-weight: 700;">ĐANG DIỄN RA</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge" style="background: #EFF6FF; color: #1D4ED8; font-weight: 700;">SẮP DIỄN RA</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <p style="margin: 0; font-size: 13.5px; color: var(--text-muted);">
                            Lớp học: <strong><c:out value="${sessionData.className}" /></strong> • Môn: <strong><c:out value="${sessionData.subjectName}" /></strong>
                        </p>

                        <div class="ops-meta-chips" style="margin-top: 4px;">
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                <span>Ngày dạy: <strong><c:out value="${sessionData.sessionDate}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                <span>Khung ca: <strong><c:out value="${sessionData.startTime}" /> - <c:out value="${sessionData.endTime}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                <span>Phòng: <strong><c:out value="${sessionData.roomName}" /></strong></span>
                            </span>
                            <span style="color: var(--border);">•</span>
                            <span class="ops-meta-chip">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--success);"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                <span>Sĩ số có mặt: <strong><c:out value="${sessionData.presentCount}" />/<c:out value="${sessionData.totalStudents}" /></strong></span>
                            </span>
                        </div>
                    </div>

                    <div class="ops-hero-actions no-print">
                        <button type="button" class="btn btn-secondary btn-sm" onclick="window.print()" title="In sổ đầu bài" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect width="12" height="8" x="6" y="14"></rect></svg>
                            <span>In sổ đầu bài</span>
                        </button>
                    </div>
                </div>

                <!-- 3. Main Form: 2-Column Grid (Left: 8 cols / Right: 4 cols) -->
                <form action="${pageContext.request.contextPath}/teacher/journal/save" method="post" id="journalForm">
                    <input type="hidden" name="sessionId" value="${sessionData.sessionId}">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

                    <div class="ops-journal-layout">
                        <!-- LEFT COLUMN: Main Log Form -->
                        <div style="display: flex; flex-direction: column; gap: 20px;">
                            <!-- Form Section 1: Lesson Contents -->
                            <section class="ops-journal-section">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; flex-wrap: wrap;">
                                    <div class="ops-journal-sec-header">
                                        <div class="ops-step-badge">01</div>
                                        <div>
                                            <h3 class="ops-journal-sec-title">
                                                Nội Dung Bài Học &amp; Kiến Thức Đã Truyền Đạt <span style="color: var(--danger);">*</span>
                                            </h3>
                                            <p class="ops-journal-sec-desc">
                                                Ghi rõ các chuyên đề, dạng bài tập đã ôn luyện, lý thuyết trọng tâm trong buổi học hôm nay.
                                            </p>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-ghost btn-sm" onclick="insertSampleLessonPlan()" style="font-size: 12px; color: var(--primary);">
                                        + Chèn mẫu giáo án
                                    </button>
                                </div>

                                <!-- Rich Mini Toolbar & Textarea -->
                                <div>
                                    <div class="ops-mini-toolbar">
                                        <div class="ops-mini-tools">
                                            <button type="button" class="ops-tool-btn" onclick="formatText('contentInput', '**', '**')" title="In đậm">B</button>
                                            <button type="button" class="ops-tool-btn" onclick="formatText('contentInput', '*', '*')" title="In nghiêng" style="font-style: italic;">I</button>
                                            <button type="button" class="ops-tool-btn" onclick="formatText('contentInput', '<u>', '</u>')" title="Gạch chân" style="text-decoration: underline;">U</button>
                                            <div class="ops-tool-sep"></div>
                                            <button type="button" class="ops-tool-btn" onclick="insertPrefix('contentInput', '• ')" title="Danh sách gạch đầu dòng">•</button>
                                            <button type="button" class="ops-tool-btn" onclick="insertPrefix('contentInput', '1. ')" title="Danh sách đánh số">1.</button>
                                        </div>
                                        <div style="font-size: 11.5px; color: var(--text-muted);">
                                            <c:if test="${not empty journal.updatedAt}">
                                                Cập nhật: <c:out value="${journal.updatedAt}" />
                                            </c:if>
                                        </div>
                                    </div>
                                    <textarea id="contentInput" name="content" class="form-control" rows="5" required
                                              style="border-top-left-radius: 0; border-top-right-radius: 0; resize: vertical;"
                                              placeholder="Nhập chi tiết nội dung đã giảng dạy trong ca học..."><c:out value="${journal.content}" /></textarea>
                                </div>
                            </section>

                            <!-- Form Section 2: Homework & Self-study Tasks -->
                            <section class="ops-journal-section">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 12px; flex-wrap: wrap;">
                                    <div class="ops-journal-sec-header">
                                        <div class="ops-step-badge">02</div>
                                        <div>
                                            <h3 class="ops-journal-sec-title">
                                                Bài Tập Về Nhà &amp; Nhiệm Vụ Tự Học
                                            </h3>
                                            <p class="ops-journal-sec-desc">
                                                Thông tin bài tập sẽ hiển thị trực tiếp trên Cổng học sinh và thông báo phụ huynh để theo dõi tiến độ.
                                            </p>
                                        </div>
                                    </div>
                                    <span class="badge" style="background: var(--surface-muted); color: var(--info); font-size: 11.5px;">
                                        Đồng bộ Cổng Học sinh &amp; Phụ huynh
                                    </span>
                                </div>

                                <textarea id="homeworkInput" name="homework" class="form-control" rows="3"
                                          style="resize: vertical;"
                                          placeholder="Nhập bài tập, thời hạn nộp bài và chỉ dẫn thực hành tự học..."><c:out value="${journal.homework}" /></textarea>
                            </section>

                            <!-- Form Section 3: General Remarks on Learning Atmosphere -->
                            <section class="ops-journal-section">
                                <div class="ops-journal-sec-header">
                                    <div class="ops-step-badge">03</div>
                                    <div>
                                        <h3 class="ops-journal-sec-title">
                                            Nhận Xét Chung Về Buổi Học &amp; Tinh Thần Lớp
                                        </h3>
                                        <p class="ops-journal-sec-desc">
                                            Đánh giá mức độ tiếp thu, thái độ tham gia phát biểu hoặc lưu ý cần khắc phục cho ca học sau.
                                        </p>
                                    </div>
                                </div>

                                <div>
                                    <textarea id="remarksInput" name="teacherRemarks" class="form-control" rows="3"
                                              style="resize: vertical;"
                                              placeholder="Nhận xét tinh thần tập thể, khen thưởng cá nhân hoặc nhắc nhở học viên..."><c:out value="${journal.teacherRemarks}" /></textarea>

                                    <!-- Quick Tags Suggestions -->
                                    <div class="ops-quick-tags">
                                        <span style="font-size: 12px; color: var(--text-muted); font-weight: 600; margin-right: 4px;">Gợi ý nhanh:</span>
                                        <button type="button" class="ops-quick-tag" onclick="appendTag('Tập trung cao độ')">+ Tập trung cao độ</button>
                                        <button type="button" class="ops-quick-tag" onclick="appendTag('Hăng hái xây dựng bài')">+ Hăng hái xây dựng bài</button>
                                        <button type="button" class="ops-quick-tag" onclick="appendTag('Cần luyện thêm tốc độ giải đề')">+ Cần luyện thêm tốc độ giải đề</button>
                                        <button type="button" class="ops-quick-tag" onclick="appendTag('Tiếp thu bài rất tốt')">+ Tiếp thu bài rất tốt</button>
                                        <button type="button" class="ops-quick-tag" onclick="appendTag('Chú ý trình bày cẩn thận')">+ Chú ý trình bày cẩn thận</button>
                                    </div>
                                </div>
                            </section>
                        </div>

                        <!-- RIGHT COLUMN: Roster Preview & Compliance Card -->
                        <div style="display: flex; flex-direction: column; gap: 20px;">
                            <!-- Attendance Roster Snapshot Card -->
                            <div class="ops-journal-section">
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <h3 class="ops-journal-sec-title" style="display: inline-flex; align-items: center; gap: 6px;">
                                        <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                        <span>Điểm danh buổi học</span>
                                    </h3>
                                    <span class="badge" style="background: #DCFCE7; color: #15803D; font-weight: 700;">
                                        Có mặt <c:out value="${sessionData.presentCount}" />/<c:out value="${sessionData.totalStudents}" />
                                    </span>
                                </div>

                                <div style="display: flex; flex-direction: column; gap: 8px; max-height: 280px; overflow-y: auto; padding-right: 4px;">
                                    <c:choose>
                                        <c:when test="${not empty sessionData.roster}">
                                            <c:forEach var="st" items="${sessionData.roster}">
                                                <div style="display: flex; align-items: center; justify-content: space-between; padding: 6px 8px; border-radius: var(--radius-sm); background: var(--surface-muted);">
                                                    <div style="display: flex; align-items: center; gap: 8px;">
                                                        <div class="ops-avatar-initials" style="width: 26px; height: 26px; font-size: 11px;">
                                                            ${st.studentName.substring(0, 1)}
                                                        </div>
                                                        <div style="display: flex; flex-direction: column;">
                                                            <span style="font-size: 12.5px; font-weight: 600; color: var(--text);"><c:out value="${st.studentName}" /></span>
                                                            <span style="font-size: 11px; color: var(--text-muted);"><c:out value="${st.studentCode}" /></span>
                                                        </div>
                                                    </div>
                                                    <div>
                                                        <c:choose>
                                                            <c:when test="${st.attendanceStatus == 'PRESENT'}">
                                                                <span style="color: var(--success); font-size: 11px; font-weight: 600;">Có mặt</span>
                                                            </c:when>
                                                            <c:when test="${st.attendanceStatus == 'LATE'}">
                                                                <span style="color: var(--warning); font-size: 11px; font-weight: 600;">Đi muộn</span>
                                                            </c:when>
                                                            <c:when test="${st.attendanceStatus == 'ABSENT_EXCUSED'}">
                                                                <span style="color: var(--primary); font-size: 11px; font-weight: 600;">Có phép</span>
                                                            </c:when>
                                                            <c:when test="${st.attendanceStatus == 'ABSENT_UNEXCUSED'}">
                                                                <span style="color: var(--danger); font-size: 11px; font-weight: 600;">Không phép</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: var(--text-muted); font-size: 11px;">Chưa chọn</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p style="margin: 0; font-size: 12.5px; color: var(--text-muted); text-align: center; padding: 20px 0;">Chưa có dữ liệu học sinh</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${sessionData.sessionId}" style="font-size: 12.5px; color: var(--primary); text-decoration: none; font-weight: 600; text-align: center; margin-top: 4px;">
                                    Xem bảng điểm danh chi tiết từng học viên &rarr;
                                </a>
                            </div>

                            <!-- Compliance & Auto-lock Warning Notice -->
                            <div class="ops-callout">
                                <svg class="icon icon-sm ops-callout-icon" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning);"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                                <div>
                                    <div class="ops-callout-title">Quy chuẩn đào tạo TCH-04:</div>
                                    Hệ thống tự động đồng bộ lên Cổng phụ huynh và khóa sổ đầu bài sau <strong>24 giờ</strong> kể từ khi ca học kết thúc. Giáo viên cần hoàn tất cập nhật bài tập và nhận xét đúng hạn để đảm bảo chỉ số đánh giá nghiệp vụ.
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 4. Bottom Sticky Action Deck -->
                    <div class="ops-sticky-bar no-print">
                        <div class="ops-sticky-left">
                            <span class="legend-dot" style="background: var(--success);"></span>
                            <span>Giảng viên phụ trách: <strong><c:out value="${sessionData.teacherName}" /></strong></span>
                        </div>

                        <div class="ops-sticky-right">
                            <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${sessionData.sessionId}" class="btn btn-secondary btn-sm">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px; font-weight: 600;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                <span>Lưu &amp; Xác nhận hoàn tất sổ đầu bài</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script>
    function appendTag(tagText) {
        const textarea = document.getElementById('remarksInput');
        if (!textarea) return;
        const current = textarea.value.trim();
        if (!current) {
            textarea.value = tagText;
        } else {
            textarea.value = current + '. ' + tagText;
        }
        textarea.focus();
    }

    function formatText(textareaId, prefix, suffix) {
        const textarea = document.getElementById(textareaId);
        if (!textarea) return;
        const start = textarea.selectionStart;
        const end = textarea.selectionEnd;
        const text = textarea.value;
        const selected = text.substring(start, end);

        if (selected) {
            textarea.value = text.substring(0, start) + prefix + selected + suffix + text.substring(end);
            textarea.selectionStart = start + prefix.length;
            textarea.selectionEnd = end + prefix.length;
        } else {
            textarea.value = text.substring(0, start) + prefix + 'nội dung' + suffix + text.substring(end);
        }
        textarea.focus();
    }

    function insertPrefix(textareaId, linePrefix) {
        const textarea = document.getElementById(textareaId);
        if (!textarea) return;
        const start = textarea.selectionStart;
        const text = textarea.value;
        textarea.value = text.substring(0, start) + '\n' + linePrefix + text.substring(start);
        textarea.focus();
    }

    function insertSampleLessonPlan() {
        const textarea = document.getElementById('contentInput');
        if (!textarea) return;
        const sample = `Chuyên đề: Ôn tập & Luyện giải dạng toán trọng tâm kỳ học.\n1. Hệ thống hóa lý thuyết và công thức cốt lõi.\n2. Hướng dẫn các phương pháp giải nhanh và kỹ thuật phân tích dạng bài.\n3. Cho học sinh thực hành bộ câu hỏi rèn luyện tại lớp, sửa lỗi sai phổ biến.`;
        if (!textarea.value.trim() || confirm('Chèn mẫu giáo án vào khung nội dung? (Dữ liệu đang nhập sẽ được thay thế)')) {
            textarea.value = sample;
            textarea.focus();
        }
    }
</script>
</body>
</html>
