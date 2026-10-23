<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="attendance" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Sổ đầu bài & Nhật ký buổi học" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Navigation Back -->
            <div style="margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center;">
                <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${sessionData.sessionId}" class="btn btn-ghost btn-sm" style="display: inline-flex; align-items: center; gap: 6px; padding-left: 0;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    <span>Quay lại sổ điểm danh ca học</span>
                </a>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Session Banner Info -->
            <div class="admin-card" style="padding: 20px; margin-bottom: 24px;">
                <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text); margin-bottom: 8px;">
                    Sổ đầu bài & Nhật ký giảng dạy — <c:out value="${sessionData.className}" /> (<c:out value="${sessionData.classCode}" />)
                </h2>
                <div style="font-size: 0.875rem; color: var(--text-muted); display: flex; flex-wrap: wrap; gap: 16px;">
                    <span>Môn: <strong><c:out value="${sessionData.subjectName}" /></strong></span>
                    <span>Ngày dạy: <strong><c:out value="${sessionData.sessionDate}" /></strong></span>
                    <span>Ca học: <strong><c:out value="${sessionData.startTime}" /> - <c:out value="${sessionData.endTime}" /></strong></span>
                    <span>Phòng: <strong><c:out value="${sessionData.roomName}" /></strong></span>
                    <span>Giáo viên: <strong><c:out value="${sessionData.teacherName}" /></strong></span>
                </div>
            </div>

            <!-- Journal Form -->
            <div class="admin-card">
                <form action="${pageContext.request.contextPath}/teacher/journal/save" method="post">
                    <input type="hidden" name="sessionId" value="${sessionData.sessionId}">

                    <div style="padding: 24px;">
                        <!-- Nội dung bài học -->
                        <div class="form-group" style="margin-bottom: 20px;">
                            <label class="form-label" style="font-weight: 600; font-size: 0.95rem;">
                                Nội dung bài học / Kiến thức đã truyền đạt <span style="color: var(--danger);">*</span>
                            </label>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 8px;">
                                Ghi rõ các chuyên đề, dạng bài tập đã ôn luyện, lý thuyết trọng tâm trong buổi học hôm nay.
                            </p>
                            <textarea name="content" class="form-control" rows="5" required
                                      placeholder="Ví dụ: Chuyên đề 3: Phương trình bậc hai chứa tham số m. Luyện tập giải các dạng bài tìm m để phương trình có 2 nghiệm phân biệt..."><c:out value="${journal.content}" /></textarea>
                        </div>

                        <!-- Bài tập về nhà -->
                        <div class="form-group" style="margin-bottom: 20px;">
                            <label class="form-label" style="font-weight: 600; font-size: 0.95rem;">
                                Bài tập về nhà & Nhiệm vụ tự học
                            </label>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 8px;">
                                Thông tin bài tập sẽ hiển thị trên Cổng học sinh và phụ huynh để theo dõi tiến độ.
                            </p>
                            <textarea name="homework" class="form-control" rows="3"
                                      placeholder="Ví dụ: Làm bài 1, 2, 4 trang 56 SBT. Đọc trước bài Hàm số bậc nhất..."><c:out value="${journal.homework}" /></textarea>
                        </div>

                        <!-- Nhận xét chung -->
                        <div class="form-group" style="margin-bottom: 0;">
                            <label class="form-label" style="font-weight: 600; font-size: 0.95rem;">
                                Nhận xét chung về buổi học & Tinh thần học tập của lớp
                            </label>
                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 8px;">
                                Đánh giá mức độ tiếp thu, thái độ tham gia phát biểu hoặc lưu ý cần khắc phục.
                            </p>
                            <textarea name="teacherRemarks" class="form-control" rows="3"
                                      placeholder="Ví dụ: Lớp học sôi nổi, các bạn tiếp thu tốt dạng bài cơ bản. Một số bạn cần chú ý tính toán dấu cẩn thận..."><c:out value="${journal.teacherRemarks}" /></textarea>
                        </div>
                    </div>

                    <div style="padding: 16px 24px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; background: var(--bg-subtle);">
                        <div>
                            <c:if test="${not empty journal.updatedAt}">
                                <span style="font-size: 0.8rem; color: var(--text-muted);">
                                    Cập nhật lần cuối: <c:out value="${journal.updatedAt}" />
                                </span>
                            </c:if>
                        </div>
                        <div style="display: flex; gap: 10px;">
                            <a href="${pageContext.request.contextPath}/teacher/attendance?sessionId=${sessionData.sessionId}" class="btn btn-ghost">Hủy</a>
                            <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                    <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                    <polyline points="7 3 7 8 15 8"></polyline>
                                </svg>
                                <span>Lưu sổ đầu bài & Nhật ký</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>
