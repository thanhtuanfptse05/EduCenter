<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261025_02">
    <style>
        .form-container {
            max-width: 1040px;
            margin: 0 auto;
        }
        .form-grid-2col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        @media (max-width: 860px) {
            .form-grid-2col {
                grid-template-columns: 1fr;
            }
        }
        .section-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--text);
            margin: 0 0 16px 0;
            display: flex;
            align-items: center;
            gap: 8px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }
        .required-star {
            color: var(--danger);
            margin-left: 2px;
        }
        .input-hint {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 4px;
            display: block;
        }
        .btn-group-footer {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 12px;
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="teachers" scope="request" />
        <c:set var="breadcrumb" value="${isEdit ? 'Chỉnh sửa hồ sơ giáo viên' : 'Thêm mới Giáo viên'}" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <div class="form-container">
                    <!-- Page Header -->
                    <div style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                        <div>
                            <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                                <a href="${pageContext.request.contextPath}/admin/teachers" style="color: var(--text-muted); text-decoration: none;">Đội ngũ Giáo viên</a> / 
                                <span>${isEdit ? 'Chỉnh sửa hồ sơ' : 'Thêm mới Giáo viên'}</span>
                            </div>
                            <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                                ${isEdit ? 'Chỉnh sửa hồ sơ: ' : 'Thêm mới Giáo viên'}
                                <c:if test="${isEdit}"><span style="color: var(--primary);">${teacherForm.fullName}</span></c:if>
                            </h1>
                            <p style="font-size: var(--font-size-sm); color: var(--text-muted); margin: 4px 0 0 0;">
                                ${isEdit ? 'Cập nhật phân công chuyên môn, học vị và thù lao giảng dạy.' : 'Liên kết tài khoản người dùng TEACHER và thiết lập hồ sơ chuyên môn giảng dạy.'}
                            </p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 6px; text-decoration: none;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="19" y1="12" x2="5" y2="12"></line>
                                    <polyline points="12 19 5 12 12 5"></polyline>
                                </svg>
                                Danh sách giáo viên
                            </a>
                        </div>
                    </div>

                    <!-- Toast Error/Success -->
                    <c:if test="${not empty toastMessage}">
                        <div class="toast-alert ${toastType == 'success' ? 'toast-success' : 'toast-error'}" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: ${toastType == 'success' ? 'var(--success-subtle)' : 'var(--danger-subtle)'}; color: ${toastType == 'success' ? 'var(--success)' : 'var(--danger)'}; border: 1px solid ${toastType == 'success' ? 'rgba(22, 163, 74, 0.2)' : 'rgba(220, 38, 38, 0.2)'};">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="15" y1="9" x2="9" y2="15"></line>
                                <line x1="9" y1="9" x2="15" y2="15"></line>
                            </svg>
                            <span>${toastMessage}</span>
                        </div>
                    </c:if>

                    <!-- Form -->
                    <form method="post" action="${pageContext.request.contextPath}/admin/teachers/save">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                        <input type="hidden" name="id" value="${teacherForm.id}">

                        <div class="form-grid-2col">
                            <!-- Cột 1: Thông tin cá nhân & Tài khoản -->
                            <div class="section-card">
                                <div class="section-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--primary);">
                                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                        <circle cx="12" cy="7" r="4"></circle>
                                    </svg>
                                    Tài khoản & Thông tin cá nhân
                                </div>

                                <!-- Tài khoản User liên kết -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Tài khoản User liên kết <span class="required-star">*</span>
                                    </label>
                                    <c:choose>
                                        <c:when test="${isEdit}">
                                            <input type="hidden" name="userId" value="${teacherForm.userId}">
                                            <input type="text" class="form-control" value="Tài khoản ID #${teacherForm.userId}" disabled style="background: var(--bg); cursor: not-allowed;">
                                            <span class="input-hint">Không thể đổi tài khoản User sau khi hồ sơ đã được thiết lập (BR02 quan hệ 1-1).</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${not empty availableUsers}">
                                                    <select name="userId" class="form-control" required style="width: 100%;">
                                                        <option value="">-- Chọn tài khoản người dùng có vai trò TEACHER --</option>
                                                        <c:forEach var="u" items="${availableUsers}">
                                                            <option value="${u.userId}" ${teacherForm.userId == u.userId ? 'selected' : ''}>
                                                                ${u.fullName} (${u.email}${not empty u.phone ? ' - ' : ''}${u.phone})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <span class="input-hint">Chỉ hiển thị các tài khoản đã kích hoạt (ACTIVE), có vai trò TEACHER và chưa liên kết hồ sơ giáo viên nào.</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <div style="background: var(--warning-subtle); border: 1px solid rgba(245, 158, 11, 0.3); border-radius: var(--radius-xs); padding: 12px; font-size: 13px; color: var(--text);">
                                                        <strong>Chưa có tài khoản khả dụng:</strong> Hiện không có tài khoản người dùng nào mang vai trò <code>TEACHER</code> chưa được liên kết. Vui lòng tạo tài khoản mới trong <a href="${pageContext.request.contextPath}/admin/users" style="color: var(--primary); font-weight: 600;">Quản lý người dùng</a> trước.
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Họ và tên -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Họ và tên hiển thị <span class="required-star">*</span>
                                    </label>
                                    <input type="text" name="fullName" class="form-control" value="${teacherForm.fullName}" required minlength="2" maxlength="150" placeholder="Ví dụ: Thầy Trần Quang Tuấn">
                                    <span class="input-hint">Tên giáo viên được dùng trong bảng phân công lớp học và lịch biểu.</span>
                                </div>

                                <!-- Số điện thoại -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Số điện thoại liên hệ
                                    </label>
                                    <input type="text" name="phone" class="form-control" value="${teacherForm.phone}" placeholder="Ví dụ: 0912345678">
                                </div>

                                <!-- Email -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Email liên hệ công tác
                                    </label>
                                    <input type="email" name="email" class="form-control" value="${teacherForm.email}" placeholder="Ví dụ: tuan.tq@educenter.vn">
                                </div>

                                <!-- Bằng cấp / Học vị -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Học vị / Trình độ chuyên môn
                                    </label>
                                    <input type="text" name="degree" class="form-control" value="${teacherForm.degree}" placeholder="Ví dụ: Thạc sĩ Toán Giải tích, Cử nhân Sư phạm Toán">
                                </div>
                            </div>

                            <!-- Cột 2: Chuyên môn, Thù lao & Trạng thái -->
                            <div class="section-card">
                                <div class="section-title">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--primary);">
                                        <path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path>
                                        <path d="M6 6h10"></path>
                                        <path d="M6 10h10"></path>
                                    </svg>
                                    Chuyên môn, Thù lao & Công tác
                                </div>

                                <!-- Chuyên môn giảng dạy -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Chuyên môn giảng dạy / Môn phụ trách
                                    </label>
                                    <input type="text" name="specialization" class="form-control" value="${teacherForm.specialization}" placeholder="Ví dụ: Toán THPT, Luyện thi ĐH, Bồi dưỡng HSG Toán 12">
                                    <span class="input-hint">Mô tả định hướng môn học và cấp lớp giáo viên phụ trách chuyên môn.</span>
                                </div>

                                <!-- Đơn giá thù lao tham khảo -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Đơn giá thù lao tham khảo (VNĐ/giờ)
                                    </label>
                                    <input type="number" name="hourlyRate" class="form-control" min="0" step="10000" value="${teacherForm.hourlyRate}" placeholder="Ví dụ: 350000">
                                    <span class="input-hint">Định mức nội bộ phục vụ tính công giảng dạy. <strong>Tuyệt đối không hiển thị ra công khai học viên (FR-006).</strong></span>
                                </div>

                                <!-- Trạng thái công tác -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Trạng thái công tác <span class="required-star">*</span>
                                    </label>
                                    <select name="status" class="form-control" style="width: 100%;">
                                        <option value="ACTIVE" ${teacherForm.status == 'ACTIVE' or empty teacherForm.status ? 'selected' : ''}>Đang giảng dạy (ACTIVE)</option>
                                        <option value="ON_LEAVE" ${teacherForm.status == 'ON_LEAVE' ? 'selected' : ''}>Tạm nghỉ / Nghỉ phép (ON_LEAVE)</option>
                                        <option value="INACTIVE" ${teacherForm.status == 'INACTIVE' ? 'selected' : ''}>Ngừng công tác (INACTIVE)</option>
                                    </select>
                                    <span class="input-hint">Hệ thống sẽ chặn chuyển sang <em>Nghỉ phép</em> hoặc <em>Ngừng dạy</em> nếu còn lịch dạy tương lai chưa hoàn tất (BR05).</span>
                                </div>

                                <!-- Tiểu sử / Giới thiệu -->
                                <div class="form-group" style="margin-bottom: 18px;">
                                    <label class="form-label" style="font-weight: 600; display: block; margin-bottom: 6px;">
                                        Tiểu sử & Thành tích giảng dạy
                                    </label>
                                    <textarea name="bio" class="form-control" rows="4" placeholder="Kinh nghiệm giảng dạy, thành tích bồi dưỡng học sinh giỏi, phương pháp sư phạm...">${teacherForm.bio}</textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Button Footer -->
                        <div class="btn-group-footer">
                            <a href="${pageContext.request.contextPath}/admin/teachers" class="btn btn-secondary" style="text-decoration: none;">
                                Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                                    <polyline points="17 21 17 13 7 13 7 21"></polyline>
                                    <polyline points="7 3 7 8 15 8"></polyline>
                                </svg>
                                ${isEdit ? 'Lưu thay đổi hồ sơ' : 'Lưu hồ sơ Giáo viên'}
                            </button>
                        </div>
                    </form>
                </div>
            </main>

            <%@ include file="/WEB-INF/views/common/footer.jspf" %>
        </div>
    </div>
</body>
</html>
