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
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.5); z-index: 1000; align-items: center; justify-content: center; backdrop-filter: blur(2px); }
        .modal.active { display: flex; }
        .modal-content { background: var(--surface); border-radius: var(--radius-lg); width: 100%; max-width: 540px; padding: 24px; box-shadow: var(--shadow-lg); border: 1px solid var(--border); }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="assessments" scope="request" />
    <c:set var="breadcrumb" value="Giáo viên / Bài kiểm tra & Bảng điểm" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 20px;">
                <div>
                    <h1 class="page-title">Quản lý Bài kiểm tra & Điểm số</h1>
                    <p class="page-subtitle">Tạo đề kiểm tra, chấm điểm và công bố kết quả học tập cho học sinh & phụ huynh (TCH-05, TCH-06)</p>
                </div>
                <div>
                    <button type="button" class="btn btn-primary" onclick="openCreateModal();" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        <span>Tạo bài kiểm tra mới</span>
                    </button>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- Filter Toolbar -->
            <div class="filter-toolbar" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 16px; margin-bottom: 20px;">
                <form action="${pageContext.request.contextPath}/teacher/assessments" method="get" class="filter-form" style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                    <div style="min-width: 200px;">
                        <select name="classId" class="form-control">
                            <option value="">-- Tất cả lớp giảng dạy --</option>
                            <c:forEach var="c" items="${classes}">
                                <option value="${c.id}" ${selectedClassId == c.id ? 'selected' : ''}>
                                    <c:out value="${c.code}" /> - <c:out value="${c.name}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div style="min-width: 160px;">
                        <select name="status" class="form-control">
                            <option value="">-- Tất cả trạng thái --</option>
                            <option value="DRAFT" ${selectedStatus == 'DRAFT' ? 'selected' : ''}>Bản nháp (DRAFT)</option>
                            <option value="PUBLISHED" ${selectedStatus == 'PUBLISHED' ? 'selected' : ''}>Đã công bố (PUBLISHED)</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <span>Lọc bài</span>
                    </button>
                    <c:if test="${not empty selectedClassId or not empty selectedStatus}">
                        <a href="${pageContext.request.contextPath}/teacher/assessments" class="btn btn-ghost btn-sm">Xóa bộ lọc</a>
                    </c:if>
                </form>
            </div>

            <!-- Assessments Table -->
            <div class="admin-card">
                <c:choose>
                    <c:when test="${not empty assessments}">
                        <div class="table-responsive">
                            <table class="table" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                <tr>
                                    <th style="width: 48px; text-align: center;">#</th>
                                    <th>Tên bài kiểm tra</th>
                                    <th>Lớp học</th>
                                    <th>Phân loại</th>
                                    <th>Ngày làm bài</th>
                                    <th style="text-align: center;">Thang / Trọng số</th>
                                    <th style="text-align: center;">Tiến độ chấm</th>
                                    <th style="text-align: right;">Điểm TB lớp</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align: right; width: 150px;">Hành động</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="a" items="${assessments}" varStatus="loop">
                                    <tr>
                                        <td style="text-align: center; color: var(--text-muted);">${loop.count}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" style="font-weight: 600; color: var(--primary); text-decoration: none;">
                                                <c:out value="${a.title}" />
                                            </a>
                                        </td>
                                        <td>
                                            <div style="font-weight: 500;"><c:out value="${a.className}" /></div>
                                            <div style="font-size: 0.8rem; color: var(--text-muted);">
                                                <code><c:out value="${a.classCode}" /></code>
                                            </div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.assessmentType == '15_MIN'}">Kiểm tra 15p</c:when>
                                                <c:when test="${a.assessmentType == '1_PERIOD'}">Kiểm tra 1 tiết</c:when>
                                                <c:when test="${a.assessmentType == 'MID_TERM'}">Giữa kỳ</c:when>
                                                <c:when test="${a.assessmentType == 'FINAL'}">Cuối kỳ</c:when>
                                                <c:when test="${a.assessmentType == 'ENTRANCE'}">Khảo sát đầu vào</c:when>
                                                <c:when test="${a.assessmentType == 'TRIAL'}">Thi thử</c:when>
                                                <c:otherwise><c:out value="${a.assessmentType}" /></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:out value="${a.testDate}" /></td>
                                        <td style="text-align: center;">
                                            Thang <c:out value="${a.maxScore}" /> (HS: <c:out value="${a.weight}" />)
                                        </td>
                                        <td style="text-align: center;">
                                            <span style="font-weight: 600; color: ${a.gradedCount >= a.totalStudents and a.totalStudents > 0 ? '#16a34a' : 'var(--text)'};">
                                                ${a.gradedCount} / ${a.totalStudents}
                                            </span>
                                        </td>
                                        <td style="text-align: right; font-weight: 700; color: var(--primary);">
                                            <c:choose>
                                                <c:when test="${not empty a.averageScore}">
                                                    <fmt:formatNumber value="${a.averageScore}" minFractionDigits="1" maxFractionDigits="2"/>
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${a.status == 'PUBLISHED'}">
                                                    <span class="badge badge-published">Đã công bố</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-draft">Bản nháp</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: right; white-space: nowrap;">
                                            <a href="${pageContext.request.contextPath}/teacher/scores?id=${a.id}" class="btn btn-secondary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                    <path d="M12 20h9"></path>
                                                    <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z"></path>
                                                </svg>
                                                <span>${a.status == 'PUBLISHED' ? 'Chỉnh sửa điểm' : 'Nhập & Sửa điểm'}</span>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="empty-state" style="text-align: center; padding: 48px 24px;">
                            <div style="display: inline-flex; align-items: center; justify-content: center; width: 64px; height: 64px; border-radius: 50%; background: var(--bg); margin-bottom: 16px; color: var(--text-muted);">
                                <svg class="icon icon-lg" viewBox="0 0 24 24" aria-hidden="true" style="width: 32px; height: 32px;">
                                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                    <polyline points="14 2 14 8 20 8"></polyline>
                                    <line x1="16" y1="13" x2="8" y2="13"></line>
                                    <line x1="16" y1="17" x2="8" y2="17"></line>
                                </svg>
                            </div>
                            <h3 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 8px;">Chưa có bài kiểm tra nào</h3>
                            <p style="color: var(--text-muted); max-width: 440px; margin: 0 auto 20px;">
                                Giáo viên có thể tạo các bài kiểm tra 15 phút, 1 tiết, giữa kỳ hoặc thi thử để đánh giá năng lực học sinh.
                            </p>
                            <button type="button" class="btn btn-primary btn-sm" onclick="openCreateModal();">
                                Tạo bài kiểm tra đầu tiên
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<!-- Modal Tạo bài kiểm tra mới -->
<div class="modal" id="createModal">
    <div class="modal-content">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid var(--border); padding-bottom: 12px;">
            <h3 style="font-size: 1.125rem; font-weight: 700; margin: 0; color: var(--text);">Tạo bài kiểm tra mới (TCH-05)</h3>
            <button type="button" onclick="closeCreateModal();" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--text-muted);">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/teacher/assessments/create" method="post">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight: 600;">Lớp học giảng dạy <span style="color: #dc2626;">*</span></label>
                <select name="classId" class="form-control" required>
                    <option value="">-- Chọn lớp học --</option>
                    <c:forEach var="c" items="${classes}">
                        <option value="${c.id}" ${selectedClassId == c.id ? 'selected' : ''}>
                            <c:out value="${c.code}" /> - <c:out value="${c.name}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin-bottom: 14px;">
                <label class="form-label" style="font-weight: 600;">Tên bài kiểm tra <span style="color: #dc2626;">*</span></label>
                <input type="text" name="title" class="form-control" placeholder="VD: Kiểm tra 15 phút - Chương 1 Hàm số" required>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 14px;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 600;">Phân loại bài</label>
                    <select name="assessmentType" class="form-control">
                        <option value="15_MIN">Kiểm tra 15 phút</option>
                        <option value="1_PERIOD">Kiểm tra 1 tiết</option>
                        <option value="MID_TERM">Kiểm tra Giữa kỳ</option>
                        <option value="FINAL">Kiểm tra Cuối kỳ</option>
                        <option value="ENTRANCE">Khảo sát đầu vào</option>
                        <option value="TRIAL">Thi thử định kỳ</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 600;">Ngày làm bài <span style="color: #dc2626;">*</span></label>
                    <input type="date" name="testDate" class="form-control" value="<%= java.time.LocalDate.now() %>" required>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px;">
                <div class="form-group">
                    <label class="form-label" style="font-weight: 600;">Thang điểm tối đa</label>
                    <input type="number" name="maxScore" class="form-control" value="10.00" min="1" max="100" step="0.25" required>
                    <small style="color: var(--text-muted); font-size: 0.75rem;">Mặc định thang 10.00</small>
                </div>
                <div class="form-group">
                    <label class="form-label" style="font-weight: 600;">Trọng số / Hệ số</label>
                    <input type="number" name="weight" class="form-control" value="1.00" min="0.1" max="10" step="0.1" required>
                    <small style="color: var(--text-muted); font-size: 0.75rem;">VD: Hệ số 1 hoặc 2</small>
                </div>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 10px; border-top: 1px solid var(--border); padding-top: 16px;">
                <button type="button" class="btn btn-secondary" onclick="closeCreateModal();">Hủy bỏ</button>
                <button type="submit" class="btn btn-primary">Khởi tạo bài & Chấm điểm</button>
            </div>
        </form>
    </div>
</div>

<script>
function openCreateModal() {
    document.getElementById('createModal').classList.add('active');
}
function closeCreateModal() {
    document.getElementById('createModal').classList.remove('active');
}
</script>
</body>
</html>
