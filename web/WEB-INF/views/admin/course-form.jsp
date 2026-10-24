<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261025_02">
    <style>
        .form-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 992px) {
            .form-layout {
                grid-template-columns: 1fr;
            }
        }
        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }
        .form-card-title {
            font-size: var(--font-size-md);
            font-weight: 700;
            color: var(--text);
            margin: 0 0 16px 0;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        .form-grid-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        @media (max-width: 640px) {
            .form-grid-2, .form-grid-3 {
                grid-template-columns: 1fr;
            }
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-label {
            display: block;
            font-size: var(--font-size-sm);
            font-weight: 600;
            color: var(--text);
            margin-bottom: 6px;
        }
        .form-helper {
            font-size: var(--font-size-xs);
            color: var(--text-muted);
            margin-top: 4px;
        }
        .switch-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="courses" scope="request" />
        <c:set var="breadcrumb" value="${isEdit ? 'Chỉnh sửa khóa học' : 'Tạo khóa học mới'}" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Page Header -->
                <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                    <div>
                        <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                            <a href="${pageContext.request.contextPath}/admin/courses" style="color: var(--text-muted); text-decoration: none;">Khóa học</a> / <span>${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}</span>
                        </div>
                        <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                            ${isEdit ? 'Chỉnh sửa Khóa học' : 'Tạo Khóa học mới'}
                        </h1>
                        <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                            ${isEdit ? courseForm.name : 'Thiết lập thông tin học vụ, khối lớp, lộ trình học và biểu phí đào tạo.'}
                        </p>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px;">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                            Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Toast Alert -->
                <c:if test="${not empty toastMessage}">
                    <div class="toast-alert ${toastType == 'success' ? 'toast-success' : 'toast-error'}" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: ${toastType == 'success' ? 'var(--success-subtle)' : 'var(--danger-subtle)'}; color: ${toastType == 'success' ? 'var(--success)' : 'var(--danger)'}; border: 1px solid ${toastType == 'success' ? 'rgba(22, 163, 74, 0.2)' : 'rgba(220, 38, 38, 0.2)'};">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        <span>${toastMessage}</span>
                    </div>
                </c:if>

                <form method="POST" action="${pageContext.request.contextPath}/admin/courses/save">
                    <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="id" value="${courseForm.id}">
                    </c:if>

                    <div class="form-layout">
                        <!-- Main Left Column -->
                        <div>
                            <!-- Card 1: Thông tin cơ bản -->
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"/>
                                        <path d="M6 6h10"/>
                                        <path d="M6 10h10"/>
                                    </svg>
                                    1. Thông tin học thuật & Định danh
                                </h3>

                                <div class="form-grid-2">
                                    <div class="form-group" style="margin: 0;">
                                        <label for="courseCode" class="form-label">
                                            Mã khóa học <span style="color: var(--danger);">*</span>
                                        </label>
                                        <input type="text" id="courseCode" name="code" value="<c:out value='${courseForm.code}' />"
                                               class="form-control" required placeholder="Ví dụ: MATH-10-PREP"
                                               maxlength="50" style="text-transform: uppercase; font-family: monospace;">
                                        <div class="form-helper">Mã duy nhất, viết hoa, không dấu cách. Dùng quản lý liên môn.</div>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label for="subjectId" class="form-label">
                                            Bộ môn trực thuộc <span style="color: var(--danger);">*</span>
                                        </label>
                                        <select id="subjectId" name="subjectId" class="form-control" required>
                                            <option value="">-- Chọn bộ môn --</option>
                                            <c:forEach var="s" items="${subjects}">
                                                <option value="${s.id}" ${courseForm.subjectId == s.id ? 'selected' : ''}>
                                                    ${s.name} (${s.code})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="courseName" class="form-label">
                                        Tên khóa học đầy đủ <span style="color: var(--danger);">*</span>
                                    </label>
                                    <input type="text" id="courseName" name="name" value="<c:out value='${courseForm.name}' />"
                                           class="form-control" required placeholder="Ví dụ: Luyện thi Toán chuyên sâu vào lớp 10"
                                           maxlength="200">
                                </div>

                                <div class="form-grid-2">
                                    <div class="form-group" style="margin: 0;">
                                        <label for="gradeLevel" class="form-label">
                                            Khối lớp giảng dạy <span style="color: var(--danger);">*</span>
                                        </label>
                                        <select id="gradeLevel" name="gradeLevel" class="form-control" required>
                                            <option value="">-- Chọn khối --</option>
                                            <c:forEach var="g" begin="6" end="12">
                                                <option value="${g}" ${courseForm.gradeLevel == g ? 'selected' : ''}>Khối lớp ${g}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label for="targetExam" class="form-label">
                                            Mục tiêu đào tạo / Kỳ thi
                                        </label>
                                        <input type="text" id="targetExam" name="targetExam" value="<c:out value='${courseForm.targetExam}' />"
                                               class="form-control" placeholder="Ví dụ: Thi vào 10, THPT QG, ĐGNL ĐHQG..."
                                               maxlength="100">
                                    </div>
                                </div>
                            </div>

                            <!-- Card 2: Lộ trình & Học phí -->
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <path d="M12 6v6l4 2"></path>
                                    </svg>
                                    2. Thời lượng & Biểu phí niêm yết
                                </h3>

                                <div class="form-group">
                                    <label for="courseFee" class="form-label">
                                        Học phí niêm yết (VNĐ) <span style="color: var(--danger);">*</span>
                                    </label>
                                    <input type="number" id="courseFee" name="fee" value="${courseForm.fee}"
                                           class="form-control" required min="0" step="50000"
                                           placeholder="Ví dụ: 3500000" style="font-weight: 700; color: var(--primary);">
                                    <div class="form-helper">
                                        Quy tắc bảo toàn BR18: Đổi học phí sẽ tự động lưu vết kiểm toán (AuditLog) và không ảnh hưởng đến các hóa đơn/phiếu thu đã phát hành.
                                    </div>
                                </div>

                                <div class="form-grid-3">
                                    <div class="form-group" style="margin: 0;">
                                        <label for="durationWeeks" class="form-label">
                                            Số tuần học <span style="color: var(--danger);">*</span>
                                        </label>
                                        <input type="number" id="durationWeeks" name="durationWeeks" value="${courseForm.durationWeeks}"
                                               class="form-control" required min="1" max="52">
                                        <div class="form-helper">Mặc định 12 tuần</div>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label for="totalSessions" class="form-label">
                                            Tổng số buổi <span style="color: var(--danger);">*</span>
                                        </label>
                                        <input type="number" id="totalSessions" name="totalSessions" value="${courseForm.totalSessions}"
                                               class="form-control" required min="1" max="150">
                                        <div class="form-helper">Mặc định 24 buổi</div>
                                    </div>

                                    <div class="form-group" style="margin: 0;">
                                        <label for="maxCapacity" class="form-label">
                                            Sĩ số tối đa/lớp <span style="color: var(--danger);">*</span>
                                        </label>
                                        <input type="number" id="maxCapacity" name="maxCapacity" value="${courseForm.maxCapacity}"
                                               class="form-control" required min="5" max="50">
                                        <div class="form-helper">Mặc định 15 học viên</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Card 3: Đề cương chi tiết -->
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <line x1="8" y1="6" x2="21" y2="6"></line>
                                        <line x1="8" y1="12" x2="21" y2="12"></line>
                                        <line x1="8" y1="18" x2="21" y2="18"></line>
                                    </svg>
                                    3. Đề cương & Nội dung chương trình
                                </h3>

                                <div class="form-group" style="margin: 0;">
                                    <label for="description" class="form-label">Mô tả chi tiết khóa học</label>
                                    <textarea id="description" name="description" class="form-control" rows="6"
                                              placeholder="Mục tiêu đầu ra, lộ trình từng giai đoạn, yêu cầu đầu vào..."><c:out value="${courseForm.description}" /></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Right Sidebar Column -->
                        <div>
                            <!-- Card 4: Trạng thái tuyển sinh -->
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <circle cx="12" cy="12" r="10"></circle>
                                        <polyline points="12 6 12 12 16 14"></polyline>
                                    </svg>
                                    Trạng thái tuyển sinh
                                </h3>

                                <div class="form-group">
                                    <label for="courseStatus" class="form-label">Trạng thái khóa học</label>
                                    <select id="courseStatus" name="status" class="form-control" style="width: 100%;">
                                        <option value="OPEN" ${courseForm.status == 'OPEN' ? 'selected' : ''}>Mở tuyển sinh (OPEN)</option>
                                        <option value="CLOSED" ${courseForm.status == 'CLOSED' ? 'selected' : ''}>Tạm đóng (CLOSED)</option>
                                        <option value="ARCHIVED" ${courseForm.status == 'ARCHIVED' ? 'selected' : ''}>Lưu trữ (ARCHIVED)</option>
                                    </select>
                                    <div class="form-helper">
                                        Khóa học tạm đóng hoặc lưu trữ sẽ không nhận thêm đơn đăng ký mới.
                                    </div>
                                </div>

                                <div class="form-group" style="margin-bottom: 0;">
                                    <div class="switch-wrap">
                                        <input type="checkbox" id="isFeatured" name="isFeatured" value="true"
                                               ${courseForm.isFeatured ? 'checked' : ''} style="width: 18px; height: 18px; cursor: pointer;">
                                        <label for="isFeatured" style="font-size: var(--font-size-sm); font-weight: 600; color: var(--text); cursor: pointer; margin: 0;">
                                            Khóa học nổi bật (Featured)
                                        </label>
                                    </div>
                                    <div class="form-helper">Ưu tiên hiển thị trên trang chủ và đầu danh mục catalog.</div>
                                </div>
                            </div>

                            <!-- Card 5: Hình ảnh đại diện -->
                            <div class="form-card">
                                <h3 class="form-card-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <rect width="18" height="18" x="3" y="3" rx="2" ry="2"></rect>
                                        <circle cx="9" cy="9" r="2"></circle>
                                        <path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"></path>
                                    </svg>
                                    Hình ảnh đại diện
                                </h3>

                                <div class="form-group" style="margin-bottom: 0;">
                                    <label for="imageUrl" class="form-label">Đường dẫn ảnh bìa (URL)</label>
                                    <input type="text" id="imageUrl" name="imageUrl" value="<c:out value='${courseForm.imageUrl}' />"
                                           class="form-control" placeholder="https://example.com/images/course.jpg"
                                           maxlength="500">
                                    <div class="form-helper">Hỗ trợ ảnh webp, png, jpg tỷ lệ 16:9.</div>
                                </div>
                            </div>

                            <!-- Form Action Buttons -->
                            <div class="form-card" style="padding: 18px; background: var(--bg);">
                                <button type="submit" class="btn btn-primary" style="width: 100%; margin-bottom: 10px; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                        <polyline points="7 3 7 8 15 8"></polyline>
                                    </svg>
                                    ${isEdit ? 'Lưu cập nhật khóa học' : 'Tạo khóa học'}
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-secondary" style="width: 100%; display: flex; align-items: center; justify-content: center;">
                                    Hủy bỏ
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </main>

            <%@ include file="/WEB-INF/views/common/footer.jspf" %>
        </div>
    </div>
</body>
</html>
