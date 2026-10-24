<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="internalShell" value="true" scope="request"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .form-layout-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .form-layout-grid { grid-template-columns: 1fr; }
        }
        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 24px;
        }
        .card-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .rule-item {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 10px;
            line-height: 1.4;
        }
        .rule-icon {
            color: var(--primary);
            flex-shrink: 0;
            margin-top: 2px;
        }
    </style>
</head>
<body class="admin-body">
    <div class="admin-layout">
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div class="content-header">
                    <div>
                        <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
                            <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-sm btn-secondary">
                                &larr; Quay lại danh sách
                            </a>
                        </div>
                        <h1 class="page-title">${isEdit ? 'Chỉnh sửa Lớp học' : 'Tạo mới Lớp học'}</h1>
                        <p class="page-subtitle">${isEdit ? 'Cập nhật thông tin giảng dạy và sĩ số lớp' : 'Khởi tạo lớp học mới từ khóa học đang mở tuyển sinh'}</p>
                    </div>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty flashError}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span>${flashError}</span>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/admin/classes/${isEdit ? 'edit' : 'create'}">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${classForm.id}">
                    </c:if>

                    <div class="form-layout-grid">
                        <!-- Cột thông tin chính -->
                        <div>
                            <div class="form-card">
                                <h3 class="card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                                    Thông tin cơ bản của lớp
                                </h3>

                                <div class="form-group">
                                    <label class="form-label required">Khóa học liên kết (Course)</label>
                                    <select name="courseId" class="form-control" required ${isEdit ? 'disabled' : ''}>
                                        <option value="">-- Chọn khóa học đang mở (OPEN) --</option>
                                        <c:forEach var="cItem" items="${courses}">
                                            <option value="${cItem.id}" ${classForm.courseId == cItem.id ? 'selected' : ''}>
                                                ${cItem.code} — ${cItem.name} (${cItem.totalSessions} buổi)
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <c:if test="${isEdit}">
                                        <input type="hidden" name="courseId" value="${classForm.courseId}">
                                    </c:if>
                                    <span class="form-text">Lưu ý: Chỉ các khóa học ở trạng thái OPEN mới có thể mở lớp (BR04).</span>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 2fr; gap: 16px;">
                                    <div class="form-group">
                                        <label class="form-label required">Mã lớp học</label>
                                        <input type="text" name="code" class="form-control" placeholder="VD: MAT12-01" 
                                               value="${classForm.code}" required style="text-transform: uppercase;">
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label required">Tên lớp học</label>
                                        <input type="text" name="name" class="form-control" placeholder="VD: Toán 12 - Luyện đề T2-T4-T6" 
                                               value="${classForm.name}" required>
                                    </div>
                                </div>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                    <div class="form-group">
                                        <label class="form-label required">Sĩ số tối đa</label>
                                        <input type="number" name="capacity" class="form-control" min="1" max="100" 
                                               value="${classForm.capacity}" required>
                                        <span class="form-text">Sĩ số không được vượt quá sức chứa của phòng học.</span>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label">Phòng học mặc định</label>
                                        <select name="roomId" class="form-control">
                                            <option value="">-- Chưa gán phòng học --</option>
                                            <c:forEach var="rItem" items="${rooms}">
                                                <option value="${rItem.id}" ${classForm.roomId == rItem.id ? 'selected' : ''}>
                                                    ${rItem.code} - ${rItem.name} (${rItem.capacity} chỗ)
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-card">
                                <h3 class="card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                                    Kế hoạch thời gian học
                                </h3>

                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                    <div class="form-group">
                                        <label class="form-label required">Ngày bắt đầu (Khai giảng)</label>
                                        <input type="date" name="startDate" class="form-control" value="${classForm.startDate}" required>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label required">Ngày kết thúc dự kiến</label>
                                        <input type="date" name="endDate" class="form-control" value="${classForm.endDate}" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Cột phân công & Trạng thái -->
                        <div>
                            <div class="form-card">
                                <h3 class="card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                    Phân công giáo viên
                                </h3>

                                <div class="form-group">
                                    <label class="form-label required">Giáo viên phụ trách chính</label>
                                    <select name="teacherId" class="form-control" required>
                                        <option value="">-- Chọn giáo viên --</option>
                                        <c:forEach var="tItem" items="${teachers}">
                                            <option value="${tItem.id}" ${classForm.teacherId == tItem.id ? 'selected' : ''}>
                                                ${tItem.fullName} (${tItem.code})
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <span class="form-text">Giáo viên sẽ nhận thông báo và theo dõi lớp này.</span>
                                </div>

                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label required">Trạng thái lớp</label>
                                    <select name="status" class="form-control" required>
                                        <option value="PLANNING" ${classForm.status == 'PLANNING' ? 'selected' : ''}>Kế hoạch (PLANNING)</option>
                                        <option value="OPEN" ${classForm.status == 'OPEN' ? 'selected' : ''}>Mở tuyển sinh (OPEN)</option>
                                        <option value="ONGOING" ${classForm.status == 'ONGOING' ? 'selected' : ''}>Đang diễn ra (ONGOING)</option>
                                        <option value="CLOSED" ${classForm.status == 'CLOSED' ? 'selected' : ''}>Đã đóng (CLOSED)</option>
                                        <option value="CANCELLED" ${classForm.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy (CANCELLED)</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Thẻ tóm tắt nghiệp vụ -->
                            <div class="form-card" style="background: var(--bg); border: 1px dashed var(--border);">
                                <h3 class="card-title" style="font-size: 14px;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="color: var(--primary);"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                                    Quy tắc học thuật (BR)
                                </h3>
                                <div class="rule-item">
                                    <span class="rule-icon">&#10003;</span>
                                    <span><strong>BR04:</strong> Khóa học phải ở trạng thái OPEN, sĩ số &gt; 0 và ngày kết thúc &ge; ngày bắt đầu.</span>
                                </div>
                                <div class="rule-item">
                                    <span class="rule-icon">&#10003;</span>
                                    <span><strong>BR05/BR06:</strong> Sau khi tạo lớp, bạn có thể sinh lịch học chi tiết với cơ chế tự động chặn trùng lịch giáo viên và phòng học.</span>
                                </div>
                                <div class="rule-item">
                                    <span class="rule-icon">&#10003;</span>
                                    <span><strong>BR19:</strong> Lớp đã đóng (CLOSED) sẽ không thể ghi danh hoặc sinh thêm buổi học mới.</span>
                                </div>
                            </div>

                            <div style="display: flex; gap: 12px; margin-top: 16px;">
                                <button type="submit" class="btn btn-primary" style="flex: 1;">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                    ${isEdit ? 'Lưu thay đổi' : 'Tạo lớp học'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-secondary">Hủy</a>
                            </div>
                        </div>
                    </div>
                </form>
            </main>
        </div>
    </div>
</body>
</html>
