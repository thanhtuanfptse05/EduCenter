<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .badge-draft { background: #fef3c7; color: #b45309; border: 1px solid #fde68a; }
        .badge-published { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .score-input { font-size: 1.0625rem; font-weight: 700; color: var(--primary); width: 110px; text-align: center; }
        .score-input:focus { border-color: var(--primary); box-shadow: 0 0 0 2px rgba(2, 132, 199, 0.2); }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(2px); }
        .modal.active { display: flex; }
        .modal-content { background: var(--surface); border-radius: var(--radius-lg); width: 100%; max-width: 480px; padding: 24px; box-shadow: var(--shadow-lg); border: 1px solid var(--border); }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="assessments" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Nhập điểm bài kiểm tra" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        <span>Quay lại danh sách</span>
                    </a>
                    <div>
                        <h1 class="page-title" style="margin: 0; font-size: 1.5rem;">
                            Bảng điểm: <c:out value="${gradeView.title}" />
                        </h1>
                        <span style="font-size: 0.85rem; color: var(--text-muted);">
                            Lớp: <strong><c:out value="${gradeView.className}" /></strong> (<code><c:out value="${gradeView.classCode}" /></code>)
                            • Môn: <c:out value="${gradeView.subjectName}" />
                            • Ngày kiểm tra: <c:out value="${gradeView.testDate}" />
                        </span>
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <c:choose>
                        <c:when test="${gradeView.status == 'PUBLISHED'}">
                            <span class="badge badge-published" style="font-size: 0.875rem; padding: 6px 14px;">Đã công bố (PUBLISHED)</span>
                            <button type="button" class="btn btn-secondary btn-sm" onclick="openReopenModal();" style="display: inline-flex; align-items: center; gap: 4px; color: #b45309;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 20h9"></path><path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path></svg>
                                <span>Chuyển về Bản nháp (DRAFT)</span>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-draft" style="font-size: 0.875rem; padding: 6px 14px;">Bản nháp (DRAFT)</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Assessment Meta Cards -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 20px;">
                <div class="admin-card" style="padding: 16px;">
                    <div style="font-size: 0.8125rem; color: var(--text-muted); font-weight: 500;">THANG ĐIỂM & TRỌNG SỐ</div>
                    <div style="font-size: 1.25rem; font-weight: 700; color: var(--primary); margin-top: 4px;">
                        Tối đa <c:out value="${gradeView.maxScore}" /> <span style="font-size: 0.875rem; font-weight: 500; color: var(--text-muted);">(Hệ số ${gradeView.weight})</span>
                    </div>
                </div>
                <div class="admin-card" style="padding: 16px;">
                    <div style="font-size: 0.8125rem; color: var(--text-muted); font-weight: 500;">TIẾN ĐỘ CHẤM ĐIỂM</div>
                    <div style="font-size: 1.25rem; font-weight: 700; color: ${gradeView.gradedCount >= gradeView.totalStudents and gradeView.totalStudents > 0 ? '#16a34a' : 'var(--text)'}; margin-top: 4px;">
                        ${gradeView.gradedCount} / ${gradeView.totalStudents} học sinh
                    </div>
                </div>
                <div class="admin-card" style="padding: 16px;">
                    <div style="font-size: 0.8125rem; color: var(--text-muted); font-weight: 500;">ĐIỂM TRUNG BÌNH CẢ LỚP</div>
                    <div style="font-size: 1.25rem; font-weight: 700; color: #ea580c; margin-top: 4px;">
                        <c:choose>
                            <c:when test="${not empty gradeView.averageScore}">
                                <fmt:formatNumber value="${gradeView.averageScore}" minFractionDigits="1" maxFractionDigits="2"/>
                            </c:when>
                            <c:otherwise>Chưa có điểm</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <c:if test="${gradeView.status == 'PUBLISHED'}">
                <div style="padding: 12px 16px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: var(--radius-md); margin-bottom: 20px; font-size: 0.875rem; color: #1e40af; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px;">
                    <div style="display: flex; align-items: center; gap: 8px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                        </svg>
                        <span>Bài kiểm tra đã công bố. Thầy/Cô có thể trực tiếp chỉnh sửa điểm số hoặc nhận xét tại bảng bên dưới, sau đó bấm <strong>Cập nhật điểm</strong>.</span>
                    </div>
                </div>
            </c:if>

            <!-- Grading Table Form -->
            <form action="${pageContext.request.contextPath}/teacher/scores/save" method="post" id="gradingForm">
                <input type="hidden" name="assessmentId" value="${gradeView.assessmentId}">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <input type="hidden" name="action" id="formActionInput" value="DRAFT">

                <div class="admin-card">
                    <c:choose>
                        <c:when test="${not empty gradeView.students}">
                            <div class="table-responsive">
                                <table class="table" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                    <tr>
                                        <th style="width: 48px; text-align: center;">#</th>
                                        <th>Mã HV</th>
                                        <th>Họ và tên học sinh</th>
                                        <th>Số điện thoại</th>
                                        <th style="width: 140px; text-align: center;">Điểm số (0 - ${gradeView.maxScore})</th>
                                        <th>Lời phê & Nhận xét của giáo viên</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="st" items="${gradeView.students}" varStatus="loop">
                                        <tr>
                                            <td style="text-align: center; color: var(--text-muted);">${loop.count}</td>
                                            <td><code><c:out value="${st.studentCode}" /></code></td>
                                            <td style="font-weight: 600; color: var(--text);"><c:out value="${st.studentName}" /></td>
                                            <td style="color: var(--text-muted);"><c:out value="${st.studentPhone}" /></td>
                                            <td style="text-align: center;">
                                                <input type="number" name="score_${st.studentId}" class="form-control score-input"
                                                       min="0" max="${gradeView.maxScore}" step="0.25"
                                                       placeholder="-"
                                                       value="${st.score}">
                                            </td>
                                            <td>
                                                <input type="text" name="remarks_${st.studentId}" class="form-control"
                                                       placeholder="Nhận xét cụ thể (nếu có)..."
                                                       value="<c:out value='${st.remarks}' />">
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div style="display: flex; justify-content: flex-end; align-items: center; gap: 12px; margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--border);">
                                <button type="button" class="btn btn-secondary" onclick="submitScores('DRAFT');" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                        <polyline points="7 3 7 8 15 8"></polyline>
                                    </svg>
                                    <span>Lưu nháp điểm (DRAFT)</span>
                                </button>
                                <button type="button" class="btn btn-primary" onclick="submitScores('PUBLISH');" style="display: inline-flex; align-items: center; gap: 6px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                        <polyline points="20 6 9 17 4 12"></polyline>
                                    </svg>
                                    <span>${gradeView.status == 'PUBLISHED' ? 'Cập nhật & Công bố điểm' : 'Công bố điểm cho Học viên (PUBLISH)'}</span>
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state" style="text-align: center; padding: 40px 24px;">
                                <p style="color: var(--text-muted);">Lớp học này hiện tại chưa có học viên chính thức nào để nhập điểm.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </main>
    </div>
</div>

<!-- Modal Reopen bài kiểm tra (Admin) -->
<div class="modal" id="reopenModal">
    <div class="modal-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; border-bottom: 1px solid var(--border); padding-bottom: 10px;">
            <h3 style="font-size: 1.125rem; font-weight: 700; margin: 0; color: #b45309;">Mở lại bài kiểm tra (Admin Correction - BR18)</h3>
            <button type="button" onclick="closeReopenModal();" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--text-muted);">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/teacher/scores/reopen" method="post">
            <input type="hidden" name="assessmentId" value="${gradeView.assessmentId}">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label" style="font-weight: 600;">Lý do mở lại bài kiểm tra <span style="color: #dc2626;">*</span></label>
                <textarea name="reason" class="form-control" rows="3" placeholder="Nhập lý do đính chính / phúc khảo điểm số..." required></textarea>
                <small style="color: var(--text-muted); font-size: 0.75rem;">Hành động này sẽ tạm thời ẩn điểm số trên Portal cho đến khi được giáo viên công bố lại.</small>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" class="btn btn-secondary" onclick="closeReopenModal();">Hủy</button>
                <button type="submit" class="btn btn-primary" style="background: #b45309; border-color: #b45309;">Xác nhận mở lại</button>
            </div>
        </form>
    </div>
</div>

<script>
function submitScores(action) {
    document.getElementById('formActionInput').value = action;
    var maxScore = ${gradeView.maxScore != null ? gradeView.maxScore : 10};

    // Kiểm tra điểm trên giao diện
    var inputs = document.querySelectorAll('.score-input');
    var hasScore = false;
    for (var i = 0; i < inputs.length; i++) {
        var val = inputs[i].value;
        if (val !== '') {
            var num = parseFloat(val);
            if (num < 0 || num > maxScore) {
                alert('Điểm số không hợp lệ: ' + val + '. Điểm phải từ 0 đến ' + maxScore + '!');
                inputs[i].focus();
                return false;
            }
            hasScore = true;
        }
    }

    if (action === 'PUBLISH') {
        if (!hasScore) {
            alert('Không thể công bố bài kiểm tra khi chưa nhập điểm cho bất kỳ học sinh nào (BR11)!');
            return false;
        }
        if (!confirm('XÁC NHẬN CÔNG BỐ ĐIỂM:\n\nSau khi công bố (PUBLISHED), toàn bộ học sinh và phụ huynh sẽ xem được kết quả kiểm tra trên Portal.\n\nBạn có chắc chắn muốn công bố bảng điểm này?')) {
            return false;
        }
    }

    document.getElementById('gradingForm').submit();
}

function openReopenModal() {
    document.getElementById('reopenModal').classList.add('active');
}
function closeReopenModal() {
    document.getElementById('reopenModal').classList.remove('active');
}
</script>
</body>
</html>
