<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <title>Chi tiết Học viên: ${student.fullName} (${student.code}) | EduCenter</title>
    <style>
        .profile-grid {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 24px;
        }
        @media (max-width: 1024px) {
            .profile-grid { grid-template-columns: 1fr; }
        }
        .info-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin-bottom: 24px;
        }
        .info-card-header {
            padding: 16px 20px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .info-card-body { padding: 20px; }
        .avatar-circle-lg {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: var(--primary-subtle);
            color: var(--primary);
            font-size: 28px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px auto;
            border: 2px solid rgba(37, 99, 235, 0.2);
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px dashed var(--border);
            font-size: 13px;
        }
        .detail-row:last-child { border-bottom: none; }
        .detail-label { color: var(--text-muted); font-weight: 500; }
        .detail-value { color: var(--text); font-weight: 600; text-align: right; }

        .status-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 9999px;
            letter-spacing: 0.02em;
        }
        .status-pill.studying { background: var(--success-subtle); color: var(--success); }
        .status-pill.reserved { background: var(--warning-subtle); color: var(--warning); }
        .status-pill.dropped { background: rgba(220, 38, 38, 0.1); color: var(--danger); }
        .status-pill.graduated { background: var(--primary-subtle); color: var(--primary); }

        .guardian-card {
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 16px;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            transition: all var(--transition-fast);
        }
        .guardian-card:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow-sm);
        }
        .verify-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: var(--radius-xs);
            letter-spacing: 0.02em;
        }
        .verify-badge.verified {
            background: var(--success-subtle);
            color: var(--success);
            border: 1px solid rgba(22, 163, 74, 0.3);
        }
        .verify-badge.unverified {
            background: var(--warning-subtle);
            color: var(--warning);
            border: 1px solid rgba(217, 119, 6, 0.3);
        }

        .btn-icon {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-xs);
            border: 1px solid var(--border);
            background: var(--surface);
            color: var(--text);
            cursor: pointer;
            text-decoration: none;
            transition: all var(--transition-fast);
        }
        .btn-icon:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-subtle);
        }
        .btn-icon.danger:hover {
            border-color: var(--danger);
            color: var(--danger);
            background: rgba(220, 38, 38, 0.1);
        }

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 16px;
        }
        .modal-overlay.active { display: flex; }
        .modal-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 580px;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-body { padding: 24px; }
        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: var(--bg);
        }
        .form-row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        @media (max-width: 576px) {
            .form-row-2 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="students" scope="request" />
    <c:set var="breadcrumb" value="Chi tiết Học viên" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Header bar -->
            <div class="page-header" style="margin-bottom: 24px; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 16px;">
                <div>
                    <div style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 4px;">
                        <a href="${pageContext.request.contextPath}/staff/students" style="color: var(--text-muted); text-decoration: none;">Hồ sơ Học viên</a> / <span>${student.code}</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <h1 style="font-size: var(--font-size-2xl); font-weight: 800; color: var(--text); margin: 0;">
                            ${student.fullName}
                        </h1>
                        <span class="student-code" style="font-size: 16px;">(${student.code})</span>
                        <c:choose>
                            <c:when test="${student.status == 'STUDYING'}">
                                <span class="status-pill studying">Đang theo học</span>
                            </c:when>
                            <c:when test="${student.status == 'RESERVED'}">
                                <span class="status-pill reserved">Bảo lưu</span>
                            </c:when>
                            <c:when test="${student.status == 'GRADUATED'}">
                                <span class="status-pill graduated">Đã tốt nghiệp</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-pill dropped">Đã thôi học</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <a href="${pageContext.request.contextPath}/staff/students" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <line x1="19" y1="12" x2="5" y2="12"></line>
                            <polyline points="12 19 5 12 12 5"></polyline>
                        </svg>
                        Danh sách
                    </a>
                    <button type="button" class="btn btn-outline" onclick="openStatusModal()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"></path>
                        </svg>
                        Đổi trạng thái
                    </button>
                    <button type="button" class="btn btn-primary" onclick="openEditModal()" style="display: inline-flex; align-items: center; gap: 6px;">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M12 20h9"></path>
                            <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                        </svg>
                        Sửa hồ sơ
                    </button>
                </div>
            </div>

            <!-- Flash Alerts -->
            <c:if test="${not empty flash_success}">
                <div class="toast-alert toast-success" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: var(--success-subtle); color: var(--success); border: 1px solid rgba(22, 163, 74, 0.2);">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                    <span>${flash_success}</span>
                </div>
            </c:if>
            <c:if test="${not empty flash_error}">
                <div class="toast-alert toast-error" style="margin-bottom: 20px; padding: 14px 18px; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 12px; font-weight: 500; font-size: var(--font-size-sm); background: rgba(220, 38, 38, 0.1); color: var(--danger); border: 1px solid rgba(220, 38, 38, 0.2);">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
                    <span>${flash_error}</span>
                </div>
            </c:if>

            <div class="profile-grid">
                <!-- Left Column: Personal info & Account Link -->
                <div>
                    <!-- Personal info card -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Thông tin Cá nhân</h3>
                            <span class="grade-badge" style="background: var(--primary-subtle); color: var(--primary); font-weight: 700;">
                                Khối ${student.gradeLevel}
                            </span>
                        </div>
                        <div class="info-card-body">
                            <div class="avatar-circle-lg">
                                ${student.fullName.substring(0, 1).toUpperCase()}
                            </div>
                            <div style="text-align: center; margin-bottom: 18px;">
                                <div style="font-weight: 700; font-size: 16px; color: var(--text);">${student.fullName}</div>
                                <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                    Mã định danh: <strong>${student.code}</strong>
                                </div>
                            </div>

                            <div class="detail-row">
                                <span class="detail-label">Giới tính:</span>
                                <span class="detail-value">
                                    <c:choose>
                                        <c:when test="${student.gender == 'NAM'}">Nam</c:when>
                                        <c:when test="${student.gender == 'NU'}">Nữ</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Ngày sinh:</span>
                                <span class="detail-value"><c:out value="${student.formattedDob != null ? student.formattedDob : 'Chưa cập nhật'}" /></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Trường học:</span>
                                <span class="detail-value"><c:out value="${student.school != null ? student.school : 'Chưa cập nhật'}" /></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Số điện thoại:</span>
                                <span class="detail-value"><c:out value="${student.phone != null ? student.phone : 'Chưa cập nhật'}" /></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">Email:</span>
                                <span class="detail-value"><c:out value="${student.email != null ? student.email : 'Chưa cập nhật'}" /></span>
                            </div>
                            <div class="detail-row" style="flex-direction: column; gap: 4px;">
                                <span class="detail-label">Mục tiêu học tập & thi cử:</span>
                                <div style="font-size: 13px; color: var(--text); background: var(--bg); padding: 8px 12px; border-radius: var(--radius-xs); border: 1px solid var(--border); margin-top: 4px; line-height: 1.4;">
                                    <c:out value="${student.targetGoal != null && !student.targetGoal.isEmpty() ? student.targetGoal : 'Chưa thiết lập mục tiêu'}" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- User Account Link Card -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Tài khoản Student Portal</h3>
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                                <circle cx="12" cy="7" r="4"></circle>
                            </svg>
                        </div>
                        <div class="info-card-body">
                            <c:choose>
                                <c:when test="${not empty student.userId}">
                                    <div style="background: var(--primary-subtle); border: 1px solid rgba(37, 99, 235, 0.2); border-radius: var(--radius-sm); padding: 14px; margin-bottom: 14px;">
                                        <div style="font-size: 11px; text-transform: uppercase; color: var(--primary); font-weight: 700; letter-spacing: 0.04em;">
                                            Đã liên kết tài khoản
                                        </div>
                                        <div style="font-size: 14px; font-weight: 700; color: var(--text); margin-top: 4px;">
                                            ${student.userEmail}
                                        </div>
                                        <div style="font-size: 12px; color: var(--text-muted); margin-top: 2px;">
                                            User ID: #${student.userId} &bull; Trạng thái: <strong>${student.userStatus}</strong>
                                        </div>
                                    </div>
                                    <form method="POST" action="${pageContext.request.contextPath}/staff/students/user-link" onsubmit="return confirm('Bạn có chắc chắn muốn hủy liên kết tài khoản portal của học viên này?');">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="studentId" value="${student.id}">
                                        <input type="hidden" name="action" value="unlink">
                                        <button type="submit" class="btn btn-outline" style="width: 100%; color: var(--danger); border-color: rgba(220, 38, 38, 0.3);">
                                            Hủy liên kết tài khoản
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div style="background: var(--bg); border: 1px dashed var(--border); border-radius: var(--radius-sm); padding: 14px; margin-bottom: 14px; text-align: center;">
                                        <div style="font-size: 13px; color: var(--text-muted);">
                                            Học viên chưa được gắn tài khoản đăng nhập portal.
                                        </div>
                                    </div>
                                    <form method="POST" action="${pageContext.request.contextPath}/staff/students/user-link">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="studentId" value="${student.id}">
                                        <input type="hidden" name="action" value="link">
                                        <div class="form-group" style="margin-bottom: 10px;">
                                            <select name="userId" required class="form-select" style="font-size: 13px;">
                                                <option value="">-- Chọn tài khoản học sinh --</option>
                                                <c:forEach var="u" items="${availableUsers}">
                                                    <option value="${u.id}">${u.fullName} (${u.email})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary" style="width: 100%;">
                                            Liên kết tài khoản
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Guardians & Enrolled Classes -->
                <div>
                    <!-- Guardians Section -->
                    <div class="info-card" id="guardians">
                        <div class="info-card-header">
                            <div>
                                <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">
                                    Người giám hộ & Phụ huynh liên kết (${guardians.size()})
                                </h3>
                                <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">
                                    Quyền xem dữ liệu học tập tuân thủ Business Rule BR15 (Bắt buộc xác thực hợp lệ).
                                </p>
                            </div>
                            <button type="button" class="btn btn-primary" onclick="openAddGuardianModal()" style="font-size: 12px; padding: 6px 12px; display: inline-flex; align-items: center; gap: 6px;">
                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Gắn Phụ huynh
                            </button>
                        </div>
                        <div class="info-card-body">
                            <c:choose>
                                <c:when test="${not empty guardians}">
                                    <c:forEach var="g" items="${guardians}">
                                        <div class="guardian-card">
                                            <div style="display: flex; align-items: center; gap: 14px;">
                                                <div style="width: 42px; height: 42px; border-radius: 50%; background: var(--surface); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; font-weight: 700; color: var(--text); flex-shrink: 0;">
                                                    ${g.guardianName.substring(0, 1).toUpperCase()}
                                                </div>
                                                <div>
                                                    <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                                                        <span style="font-weight: 700; font-size: 14px; color: var(--text);">${g.guardianName}</span>
                                                        <span class="grade-badge" style="font-size: 11px;">${g.relationship}</span>
                                                        <c:if test="${g.isPrimary}">
                                                            <span style="font-size: 10px; font-weight: 700; background: var(--primary); color: #fff; padding: 1px 6px; border-radius: 9999px;">
                                                                Liên hệ chính
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <div style="font-size: 12px; color: var(--text-muted); margin-top: 3px;">
                                                        Mã: <strong>${g.guardianCode}</strong> &bull; SĐT: <strong>${g.guardianPhone}</strong>
                                                        <c:if test="${not empty g.guardianEmail}">
                                                            &bull; ${g.guardianEmail}
                                                        </c:if>
                                                    </div>
                                                    <div style="margin-top: 6px;">
                                                        <c:choose>
                                                            <c:when test="${g.verified}">
                                                                <span class="verify-badge verified">
                                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                        <polyline points="20 6 9 17 4 12"></polyline>
                                                                    </svg>
                                                                    ĐÃ XÁC THỰC
                                                                </span>
                                                                <span style="font-size: 11px; color: var(--text-muted); margin-left: 6px;">
                                                                    Duyệt: ${g.formattedVerifiedAt} <c:if test="${not empty g.verifierName}">bởi ${g.verifierName}</c:if>
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="verify-badge unverified">
                                                                    <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true">
                                                                        <circle cx="12" cy="12" r="10"></circle>
                                                                        <line x1="12" y1="8" x2="12" y2="12"></line>
                                                                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                                                    </svg>
                                                                    CHỜ XÁC THỰC (BR15)
                                                                </span>
                                                                <span style="font-size: 11px; color: var(--warning); margin-left: 6px;">
                                                                    (Chưa cấp quyền xem điểm/điểm danh)
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>

                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <c:choose>
                                                    <c:when test="${g.verified}">
                                                        <button type="button" class="btn btn-outline" style="font-size: 12px; padding: 4px 10px; color: var(--danger); border-color: rgba(220, 38, 38, 0.3);" onclick="openRevokeModal(${g.id}, '${g.guardianName}')">
                                                            Thu hồi xác thực
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/verify" style="margin: 0;">
                                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                            <input type="hidden" name="linkId" value="${g.id}">
                                                            <input type="hidden" name="notes" value="Duyệt hồ sơ hợp lệ tại bàn tư vấn">
                                                            <input type="hidden" name="redirect" value="/staff/students/detail?id=${student.id}">
                                                            <button type="submit" class="btn btn-primary" style="font-size: 12px; padding: 4px 10px; background: var(--success); border-color: var(--success);">
                                                                Duyệt xác thực
                                                            </button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>

                                                <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/unlink" onsubmit="return confirm('Bạn có chắc muốn xóa liên kết giữa học viên và phụ huynh này?');" style="margin: 0;">
                                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                    <input type="hidden" name="linkId" value="${g.id}">
                                                    <input type="hidden" name="redirect" value="/staff/students/detail?id=${student.id}">
                                                    <button type="submit" class="btn-icon danger" title="Hủy liên kết">
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                                                            <line x1="18" y1="6" x2="6" y2="18"></line>
                                                            <line x1="6" y1="6" x2="18" y2="18"></line>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="padding: 32px 16px; text-align: center; border: 1px dashed var(--border); border-radius: var(--radius-sm); background: var(--bg);">
                                        <div style="color: var(--text-muted); font-size: 13px; margin-bottom: 12px;">
                                            Chưa có hồ sơ người giám hộ hoặc phụ huynh nào được liên kết với học viên này.
                                        </div>
                                        <button type="button" class="btn btn-primary" onclick="openAddGuardianModal()" style="font-size: 12px;">
                                            + Thiết lập liên kết Giám hộ ngay
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Enrolled Classes Section -->
                    <div class="info-card">
                        <div class="info-card-header">
                            <div>
                                <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">
                                    Lớp học & Lịch sử Ghi danh (${enrolledClasses.size()})
                                </h3>
                                <p style="font-size: 12px; color: var(--text-muted); margin: 2px 0 0 0;">
                                    Danh sách các lớp học viện đang tham gia hoặc đã hoàn thành.
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/staff/classes" class="btn btn-outline" style="font-size: 12px; padding: 6px 12px;">
                                Tra cứu Lớp học
                            </a>
                        </div>
                        <div class="info-card-body" style="padding: 0;">
                            <c:choose>
                                <c:when test="${not empty enrolledClasses}">
                                    <div class="table-responsive">
                                        <table class="data-table" style="width: 100%; border-collapse: collapse;">
                                            <thead>
                                                <tr>
                                                    <th>Mã lớp</th>
                                                    <th>Tên lớp học</th>
                                                    <th>Khóa học</th>
                                                    <th>Trạng thái ghi danh</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="ec" items="${enrolledClasses}">
                                                    <tr>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/staff/classes/detail?id=${ec.id}" style="font-weight: 700; color: var(--primary); text-decoration: none;">
                                                                ${ec.code}
                                                            </a>
                                                        </td>
                                                        <td style="font-weight: 600;">${ec.name}</td>
                                                        <td>${ec.courseName}</td>
                                                        <td>
                                                            <span class="status-pill studying">${ec.status}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div style="padding: 32px 16px; text-align: center; color: var(--text-muted); font-size: 13px;">
                                        Học viên chưa ghi danh vào lớp học nào trong hệ thống.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal: Sửa Hồ sơ Học viên -->
<div class="modal-overlay" id="editModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">
                Cập nhật Hồ sơ Học viên (${student.code})
            </h3>
            <button type="button" class="btn-icon" onclick="closeEditModal()">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/students/save">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="id" value="${student.id}">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Họ và tên học viên <span style="color: var(--danger);">*</span></label>
                    <input type="text" name="fullName" required maxlength="150" value="${student.fullName}" class="form-control">
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Khối lớp <span style="color: var(--danger);">*</span></label>
                        <select name="gradeLevel" required class="form-select">
                            <c:forEach var="g" begin="6" end="12">
                                <option value="${g}" ${g == student.gradeLevel ? 'selected' : ''}>Khối ${g}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Giới tính</label>
                        <select name="gender" class="form-select">
                            <option value="NAM" ${student.gender == 'NAM' ? 'selected' : ''}>Nam</option>
                            <option value="NU" ${student.gender == 'NU' ? 'selected' : ''}>Nữ</option>
                            <option value="KHAC" ${student.gender == 'KHAC' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Ngày sinh</label>
                        <input type="date" name="dob" value="${student.dob}" class="form-control">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Trường học đang theo học</label>
                        <input type="text" name="school" maxlength="255" value="${student.school}" class="form-control">
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Số điện thoại</label>
                        <input type="tel" name="phone" maxlength="20" value="${student.phone}" class="form-control">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Email học viên</label>
                        <input type="email" name="email" maxlength="255" value="${student.email}" class="form-control">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Mục tiêu học tập & thi cử</label>
                    <textarea name="targetGoal" rows="2" maxlength="500" class="form-control">${student.targetGoal}</textarea>
                </div>

                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Trạng thái học tập</label>
                    <select name="status" class="form-select">
                        <option value="STUDYING" ${student.status == 'STUDYING' ? 'selected' : ''}>Đang theo học (STUDYING)</option>
                        <option value="RESERVED" ${student.status == 'RESERVED' ? 'selected' : ''}>Đang bảo lưu (RESERVED)</option>
                        <option value="GRADUATED" ${student.status == 'GRADUATED' ? 'selected' : ''}>Đã tốt nghiệp (GRADUATED)</option>
                        <option value="DROPPED" ${student.status == 'DROPPED' ? 'selected' : ''}>Đã thôi học (DROPPED)</option>
                    </select>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeEditModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Đổi Trạng thái Học viên -->
<div class="modal-overlay" id="statusModal">
    <div class="modal-card" style="max-width: 440px;">
        <div class="modal-header">
            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">
                Thay đổi Trạng thái Học viên
            </h3>
            <button type="button" class="btn-icon" onclick="closeStatusModal()">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/students/status">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="id" value="${student.id}">
            <input type="hidden" name="redirect" value="detail">

            <div class="modal-body">
                <p style="font-size: 13px; color: var(--text-muted); margin: 0 0 16px 0;">
                    Chọn trạng thái mới cho học viên <strong>${student.fullName}</strong> (${student.code}):
                </p>
                <div class="form-group">
                    <select name="status" class="form-select" style="font-size: 14px; font-weight: 600;">
                        <option value="STUDYING" ${student.status == 'STUDYING' ? 'selected' : ''}>Đang theo học (STUDYING)</option>
                        <option value="RESERVED" ${student.status == 'RESERVED' ? 'selected' : ''}>Bảo lưu học tập (RESERVED)</option>
                        <option value="GRADUATED" ${student.status == 'GRADUATED' ? 'selected' : ''}>Đã tốt nghiệp (GRADUATED)</option>
                        <option value="DROPPED" ${student.status == 'DROPPED' ? 'selected' : ''}>Đã thôi học (DROPPED)</option>
                    </select>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeStatusModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Cập nhật trạng thái</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Gắn Người giám hộ -->
<div class="modal-overlay" id="addGuardianModal">
    <div class="modal-card">
        <div class="modal-header">
            <h3 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">
                Gắn Hồ sơ Người giám hộ / Phụ huynh
            </h3>
            <button type="button" class="btn-icon" onclick="closeAddGuardianModal()">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/link">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="studentId" value="${student.id}">
            <input type="hidden" name="redirect" value="/staff/students/detail?id=${student.id}">

            <div class="modal-body">
                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">ID Hồ sơ Phụ huynh <span style="color: var(--danger);">*</span></label>
                    <input type="number" name="guardianId" required min="1" class="form-control" placeholder="Nhập ID số của phụ huynh (Ví dụ: 1 cho PH0001)">
                    <div style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">
                        Tra cứu mã ID phụ huynh tại danh sách <a href="${pageContext.request.contextPath}/staff/guardians" target="_blank" style="color: var(--primary);">Phụ huynh & Giám hộ</a>.
                    </div>
                </div>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" style="font-size: 13px; font-weight: 600;">Mối quan hệ <span style="color: var(--danger);">*</span></label>
                        <select name="relationship" required class="form-select">
                            <option value="Bố">Bố</option>
                            <option value="Mẹ">Mẹ</option>
                            <option value="Ông">Ông</option>
                            <option value="Bà">Bà</option>
                            <option value="Anh/Chị">Anh/Chị</option>
                            <option value="Người giám hộ">Người giám hộ hợp pháp</option>
                        </select>
                    </div>

                    <div class="form-group" style="display: flex; flex-direction: column; justify-content: flex-end;">
                        <label style="display: flex; align-items: center; gap: 8px; font-size: 13px; cursor: pointer; margin-bottom: 8px;">
                            <input type="checkbox" name="isPrimary" value="true">
                            <span>Người nhận thông báo chính</span>
                        </label>
                    </div>
                </div>

                <div style="background: var(--bg); border: 1px solid var(--border); border-radius: var(--radius-xs); padding: 12px; font-size: 12px; color: var(--text-muted);">
                    <strong>Lưu ý BR15:</strong> Sau khi thiết lập liên kết, nhân viên cần kiểm tra giấy tờ xác thực quan hệ và nhấn nút <strong>"Duyệt xác thực"</strong> để cấp quyền truy cập Parent Portal cho phụ huynh.
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeAddGuardianModal()">Hủy</button>
                <button type="submit" class="btn btn-primary">Thiết lập liên kết</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal: Thu hồi xác thực (BR15) -->
<div class="modal-overlay" id="revokeModal">
    <div class="modal-card" style="max-width: 480px;">
        <div class="modal-header">
            <h3 style="font-size: 16px; font-weight: 700; color: var(--danger); margin: 0;">
                Thu hồi Quyền giám hộ (BR15)
            </h3>
            <button type="button" class="btn-icon" onclick="closeRevokeModal()">
                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/staff/guardians/revoke">
            <input type="hidden" name="csrfToken" value="${csrfToken}">
            <input type="hidden" name="linkId" id="revokeLinkId" value="">
            <input type="hidden" name="redirect" value="/staff/students/detail?id=${student.id}">

            <div class="modal-body">
                <p style="font-size: 13px; color: var(--text); margin: 0 0 12px 0;">
                    Bạn đang thực hiện thu hồi xác thực của phụ huynh <strong id="revokeGuardianName"></strong> đối với học viên <strong>${student.fullName}</strong>.
                </p>
                <div class="form-group">
                    <label class="form-label" style="font-size: 13px; font-weight: 600;">Lý do thu hồi xác thực <span style="color: var(--danger);">*</span></label>
                    <textarea name="reason" required rows="3" class="form-control" placeholder="Ví dụ: Giấy tờ giám hộ hết hiệu lực, thay đổi quyền nuôi dưỡng theo yêu cầu gia đình..."></textarea>
                </div>
                <div style="font-size: 11px; color: var(--text-muted);">
                    Hành động này sẽ được ghi vào nhật ký kiểm toán hệ thống (Audit Log) và lập tức ngắt quyền tra cứu của phụ huynh trên Parent Portal.
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeRevokeModal()">Hủy</button>
                <button type="submit" class="btn btn-primary" style="background: var(--danger); border-color: var(--danger);">
                    Xác nhận thu hồi
                </button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditModal() {
    document.getElementById('editModal').classList.add('active');
}
function closeEditModal() {
    document.getElementById('editModal').classList.remove('active');
}

function openStatusModal() {
    document.getElementById('statusModal').classList.add('active');
}
function closeStatusModal() {
    document.getElementById('statusModal').classList.remove('active');
}

function openAddGuardianModal() {
    document.getElementById('addGuardianModal').classList.add('active');
}
function closeAddGuardianModal() {
    document.getElementById('addGuardianModal').classList.remove('active');
}

function openRevokeModal(linkId, guardianName) {
    document.getElementById('revokeLinkId').value = linkId;
    document.getElementById('revokeGuardianName').innerText = guardianName;
    document.getElementById('revokeModal').classList.add('active');
}
function closeRevokeModal() {
    document.getElementById('revokeModal').classList.remove('active');
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeEditModal();
        closeStatusModal();
        closeAddGuardianModal();
        closeRevokeModal();
    }
});
</script>
</body>
</html>
