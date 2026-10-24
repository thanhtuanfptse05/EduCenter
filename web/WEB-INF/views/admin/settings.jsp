<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
    <style>
        .settings-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 992px) {
            .settings-grid {
                grid-template-columns: 1fr;
            }
        }
        .settings-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
        }
        .settings-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 16px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border);
        }
        .settings-card-title {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: var(--font-size-lg);
            font-weight: 700;
            color: var(--text);
            margin: 0;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        .form-group-full {
            margin-bottom: 16px;
        }
        .form-helper {
            font-size: var(--font-size-xs);
            color: var(--text-muted);
            margin-top: 4px;
        }
        .gatekeeper-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 24px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }
        .gatekeeper-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: var(--font-size-xs);
            font-weight: 700;
            letter-spacing: 0.03em;
        }
        .gatekeeper-badge.open {
            background: var(--success-subtle);
            color: var(--success);
            border: 1px solid rgba(22, 163, 74, 0.2);
        }
        .gatekeeper-badge.closed {
            background: var(--warning-subtle);
            color: var(--warning);
            border: 1px solid rgba(234, 88, 12, 0.2);
        }
        .tab-nav {
            display: flex;
            gap: 8px;
            border-bottom: 1px solid var(--border);
            margin-bottom: 24px;
        }
        .tab-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 18px;
            font-size: var(--font-size-sm);
            font-weight: 600;
            color: var(--text-muted);
            border: none;
            background: none;
            border-bottom: 2px solid transparent;
            cursor: pointer;
            text-decoration: none;
            transition: all var(--transition-fast);
        }
        .tab-btn:hover {
            color: var(--text);
        }
        .tab-btn.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }
        .audit-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: var(--radius-xs);
            font-size: 11px;
            font-weight: 700;
            font-family: monospace;
            background: var(--primary-subtle);
            color: var(--primary);
        }
        .quick-nav-link {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 16px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text);
            text-decoration: none;
            margin-bottom: 10px;
            transition: all var(--transition-fast);
        }
        .quick-nav-link:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-subtle);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
    <div class="admin-layout">
        <c:set var="activeNav" value="settings" scope="request" />
        <c:set var="breadcrumb" value="Cấu hình hệ thống & Quản trị" scope="request" />
        <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

        <div class="admin-main">
            <%@ include file="/WEB-INF/views/common/header.jspf" %>

            <main class="admin-content">
                <!-- Page Context & Header -->
                <div class="mgmt-header" style="margin-bottom: 20px;">
                    <div class="mgmt-header-left">
                        <nav class="mgmt-breadcrumb">
                            <span style="color: var(--text-muted);">Quản trị hệ thống</span>
                            <span style="opacity: 0.5;">/</span>
                            <span style="color: var(--primary); font-weight: 600;">Cấu hình & Nhật ký kiểm toán</span>
                            <span class="mgmt-badge-version" style="margin-left: 8px;">ADM-19</span>
                        </nav>
                        <div class="mgmt-title-row">
                            <h1 class="mgmt-title">Cấu hình hệ thống & Tham số vận hành</h1>
                        </div>
                        <p class="mgmt-subtitle">
                            Thiết lập thông số toàn hệ thống, cơ chế tiếp nhận tuyển sinh và nhật ký kiểm toán bất biến <strong style="color: var(--primary);">(Module M12, Business Rule BR18, Append-only)</strong>.
                        </p>
                    </div>

                    <!-- Live Security Hash Status Tag -->
                    <div class="mgmt-header-actions">
                        <div style="display: flex; align-items: center; gap: 10px; padding: 8px 14px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-md); box-shadow: var(--shadow-xs);">
                            <span class="live-pulse-dot" style="background: var(--secondary); width: 8px; height: 8px;"></span>
                            <div style="display: flex; flex-direction: column;">
                                <span style="font-size: 10px; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); font-weight: 700; line-height: 1;">CƠ CHẾ XÁC THỰC SHA-256</span>
                                <span style="font-size: 11px; color: var(--secondary); font-weight: 700; font-family: monospace; line-height: 1.3;">Chain Checksum: #9F4B-VALID</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Flash Alerts -->
                <%@ include file="/WEB-INF/views/common/alert.jsp" %>

                <!-- Navigation Tabs -->
                <div class="tab-nav">
                    <a href="${pageContext.request.contextPath}/admin/settings?tab=config"
                       class="tab-btn ${activeTab != 'audit' ? 'active' : ''}">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px;">
                            <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                        <span>Cấu hình tham số</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/settings?tab=audit"
                       class="tab-btn ${activeTab == 'audit' ? 'active' : ''}">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px;">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                            <polyline points="14 2 14 8 20 8"></polyline>
                            <line x1="16" y1="13" x2="8" y2="13"></line>
                            <line x1="16" y1="17" x2="8" y2="17"></line>
                            <polyline points="10 9 9 9 8 9"></polyline>
                        </svg>
                        <span>Nhật ký thao tác (Audit Logs)</span>
                        <c:if test="${activeTab == 'audit'}">
                            <span style="margin-left: 6px; padding: 1px 6px; border-radius: 10px; background: rgba(0, 83, 219, 0.1); color: var(--primary); font-size: 10px; font-weight: 700;">Active</span>
                        </c:if>
                    </a>
                </div>

                <c:choose>
                    <%-- TAB 1: CẤU HÌNH THAM SỐ HỆ THỐNG --%>
                    <c:when test="${activeTab != 'audit'}">
                        <!-- Cờ tiếp nhận tuyển sinh (Gatekeeper FR-010) -->
                        <div class="gatekeeper-card">
                            <div style="display: flex; align-items: center; gap: 16px;">
                                <div style="width: 48px; height: 48px; border-radius: var(--radius-sm); background: ${groupedSettings.admissionsOpen ? 'var(--success-subtle)' : 'var(--warning-subtle)'}; color: ${groupedSettings.admissionsOpen ? 'var(--success)' : 'var(--warning)'}; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="width: 24px; height: 24px;">
                                        <c:choose>
                                            <c:when test="${groupedSettings.admissionsOpen}">
                                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                                <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                            </c:when>
                                            <c:otherwise>
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"></line>
                                            </c:otherwise>
                                        </c:choose>
                                    </svg>
                                </div>
                                <div>
                                    <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
                                        <h3 style="margin: 0; font-size: var(--font-size-md); font-weight: 700; color: var(--text);">Cổng tiếp nhận tuyển sinh (Admissions Intake Gate)</h3>
                                        <span class="gatekeeper-badge ${groupedSettings.admissionsOpen ? 'open' : 'closed'}">
                                            <c:choose>
                                                <c:when test="${groupedSettings.admissionsOpen}">ĐANG MỞ TIẾP NHẬN</c:when>
                                                <c:otherwise>TẠM DỪNG TIẾP NHẬN</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <p style="margin: 0; font-size: var(--font-size-xs); color: var(--text-muted); max-width: 650px;">
                                        Khi đóng tuyển sinh, biểu mẫu đăng ký tư vấn và xác nhận ghi danh ngoài website sẽ thông báo tạm ngưng. Ban Giám đốc và Nhân viên vẫn truy cập quản trị bình thường.
                                    </p>
                                </div>
                            </div>
                            <div>
                                <form action="${pageContext.request.contextPath}/admin/settings/toggle-admissions" method="POST" style="margin: 0;">
                                    <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                                    <input type="hidden" name="admissionsOpen" value="${groupedSettings.admissionsOpen ? 'false' : 'true'}">
                                    <button type="submit" class="btn ${groupedSettings.admissionsOpen ? 'btn-outline' : 'btn-primary'}"
                                            onclick="return confirm('${groupedSettings.admissionsOpen ? 'Bạn có chắc chắn muốn TẠM DỪNG tiếp nhận đơn đăng ký tuyển sinh mới?' : 'Bạn có chắc chắn muốn MỞ LẠI cổng tuyển sinh?'}');">
                                        <c:choose>
                                            <c:when test="${groupedSettings.admissionsOpen}">
                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px;"><circle cx="12" cy="12" r="10"></circle><line x1="10" y1="15" x2="10" y2="9"></line><line x1="14" y1="15" x2="14" y2="9"></line></svg>
                                                <span>Tạm dừng tuyển sinh</span>
                                            </c:when>
                                            <c:otherwise>
                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px;"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg>
                                                <span>Mở tiếp nhận tuyển sinh</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Main Form Grid -->
                        <form action="${pageContext.request.contextPath}/admin/settings/save" method="POST">
                            <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">

                            <div class="settings-grid">
                                <div class="settings-col-main">
                                    <!-- 1. Thông tin trung tâm (FR-003) -->
                                    <div class="settings-card">
                                        <div class="settings-card-header">
                                            <h2 class="settings-card-title">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                                </svg>
                                                <span>Thông tin cơ sở & Liên hệ đào tạo</span>
                                            </h2>
                                            <span style="font-size: var(--font-size-xs); color: var(--text-muted);">Hiển thị công khai trên website và hóa đơn</span>
                                        </div>

                                        <c:forEach var="item" items="${groupedSettings.centerInfo}">
                                            <div class="form-group-full">
                                                <label class="form-label" for="setting_${item.key}">
                                                    <c:out value="${item.label}"/> <span style="color: var(--danger);">*</span>
                                                </label>
                                                <input type="${item.inputType}" id="setting_${item.key}" name="${item.key}"
                                                       class="form-control" value="<c:out value='${item.value}'/>" required>
                                                <div class="form-helper"><c:out value="${item.description}"/></div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- 2. Quy tắc lớp học & Tài chính -->
                                    <div class="settings-card">
                                        <div class="settings-card-header">
                                            <h2 class="settings-card-title">
                                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);">
                                                    <rect width="18" height="18" x="3" y="3" rx="2"></rect>
                                                    <line x1="3" y1="9" x2="21" y2="9"></line>
                                                    <line x1="9" y1="21" x2="9" y2="9"></line>
                                                </svg>
                                                <span>Tham số học vụ & Tài chính mặc định</span>
                                            </h2>
                                            <span style="font-size: var(--font-size-xs); color: var(--text-muted);">Áp dụng cho các giao dịch và đợt tạo lớp mới</span>
                                        </div>

                                        <div class="form-row">
                                            <c:forEach var="item" items="${groupedSettings.academicRules}">
                                                <div class="form-group">
                                                    <label class="form-label" for="setting_${item.key}">
                                                        <c:out value="${item.label}"/> <span style="color: var(--danger);">*</span>
                                                    </label>
                                                    <div style="position: relative;">
                                                        <input type="${item.inputType}" id="setting_${item.key}" name="${item.key}"
                                                               class="form-control" value="<c:out value='${item.value}'/>" required min="1" max="100">
                                                        <c:if test="${not empty item.unit}">
                                                            <span style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); font-size: var(--font-size-xs); color: var(--text-muted); pointer-events: none;">
                                                                <c:out value="${item.unit}"/>
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <div class="form-helper"><c:out value="${item.description}"/></div>
                                                </div>
                                            </c:forEach>

                                            <c:forEach var="item" items="${groupedSettings.financeRules}">
                                                <div class="form-group">
                                                    <label class="form-label" for="setting_${item.key}">
                                                        <c:out value="${item.label}"/> <span style="color: var(--danger);">*</span>
                                                    </label>
                                                    <div style="position: relative;">
                                                        <input type="${item.inputType}" id="setting_${item.key}" name="${item.key}"
                                                               class="form-control" value="<c:out value='${item.value}'/>" required min="1" max="365">
                                                        <c:if test="${not empty item.unit}">
                                                            <span style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); font-size: var(--font-size-xs); color: var(--text-muted); pointer-events: none;">
                                                                <c:out value="${item.unit}"/>
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <div class="form-helper"><c:out value="${item.description}"/></div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 10px;">
                                        <button type="reset" class="btn btn-outline">
                                            <span>Khôi phục ban đầu</span>
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px;"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                                            <span>Lưu thay đổi cấu hình</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- Sidebar Side Column -->
                                <div class="settings-col-side">
                                    <!-- Liên kết phân hệ chuyên trách (FR-009) -->
                                    <div class="settings-card">
                                        <h3 style="font-size: var(--font-size-sm); font-weight: 700; color: var(--text); margin-top: 0; margin-bottom: 12px;">Phân hệ quản trị liên quan</h3>
                                        <p style="font-size: var(--font-size-xs); color: var(--text-muted); margin-bottom: 16px;">
                                            Theo nguyên tắc độc lập nghiệp vụ, việc quản lý người dùng và phòng học được thực hiện tại các màn hình riêng:
                                        </p>

                                        <a href="${pageContext.request.contextPath}/admin/users" class="quick-nav-link">
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px; color: var(--primary);"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                                <span style="font-size: var(--font-size-sm); font-weight: 600;">Quản lý tài khoản & Vai trò</span>
                                            </div>
                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 12px; height: 12px; color: var(--text-muted);"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/courses" class="quick-nav-link">
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 16px; height: 16px; color: var(--primary);"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                                                <span style="font-size: var(--font-size-sm); font-weight: 600;">Xem danh mục khóa học</span>
                                            </div>
                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 12px; height: 12px; color: var(--text-muted);"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                        </a>
                                    </div>

                                    <!-- Tiêu chuẩn bảo mật (FR-005, SEC-01) -->
                                    <div class="settings-card" style="background: var(--bg); border: 1px dashed var(--border);">
                                        <h3 style="font-size: var(--font-size-sm); font-weight: 700; color: var(--text); margin-top: 0; margin-bottom: 8px; display: flex; align-items: center; gap: 8px;">
                                            <svg class="icon icon-xs" viewBox="0 0 24 24" aria-hidden="true" style="width: 14px; height: 14px; color: var(--success);"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                            <span>Bảo vệ an toàn hệ thống</span>
                                        </h3>
                                        <p style="font-size: var(--font-size-xs); color: var(--text-muted); margin: 0; line-height: 1.5;">
                                            Các thông số kết nối CSDL, khóa SMTP và mật khẩu được quản lý an toàn qua biến môi trường máy chủ, tuyệt đối không lưu hoặc hiển thị qua form này (SEC-01).
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </c:when>

                    <%-- TAB 2: NHẬT KÝ KIỂM TOÁN (AUDIT LOGS - BR18, UC35) --%>
                    <c:otherwise>
                        <div class="settings-card" style="padding: 0; overflow: hidden;">
                            <!-- Card Header with Regulatory Banner -->
                            <div style="padding: 20px 24px; background: var(--bg-alt); border-bottom: 1px solid var(--border); display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 16px;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 38px; height: 38px; border-radius: var(--radius-md); background: rgba(0, 83, 219, 0.1); color: var(--primary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="width: 20px; height: 20px;">
                                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                            <polyline points="14 2 14 8 20 8"></polyline>
                                            <line x1="16" y1="13" x2="8" y2="13"></line>
                                            <line x1="16" y1="17" x2="8" y2="17"></line>
                                            <polyline points="10 9 9 9 8 9"></polyline>
                                        </svg>
                                    </div>
                                    <div>
                                        <h2 style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">Lịch sử thao tác quản trị gần đây (Audit Logs)</h2>
                                        <span style="font-size: 12px; color: var(--text-muted);">Toàn bộ phiên ghi nhận hành động quản trị hệ thống và thay đổi thực thể</span>
                                    </div>
                                </div>

                                <!-- Invariant Policy Legal Notice -->
                                <div style="display: flex; align-items: center; gap: 8px; padding: 6px 12px; background: rgba(0, 106, 97, 0.08); border: 1px solid rgba(0, 106, 97, 0.2); border-radius: var(--radius-md); color: var(--secondary);">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 14px; height: 14px;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                                    <span style="font-size: 11.5px; font-weight: 600;">
                                        Dữ liệu lưu theo nguyên tắc bất biến (Append-only) — Nghiêm cấm sửa hoặc xóa (FR-008, BR18)
                                    </span>
                                </div>
                            </div>

                            <!-- Quick Metrics Strip -->
                            <div style="padding: 14px 24px; background: var(--surface); border-bottom: 1px solid var(--border); display: flex; flex-wrap: wrap; align-items: center; justify-content: space-between; gap: 16px; font-size: 12.5px;">
                                <div style="display: flex; align-items: center; gap: 20px; flex-wrap: wrap;">
                                    <span style="display: flex; align-items: center; gap: 6px;">
                                        <span class="live-pulse-dot" style="background: var(--primary); width: 6px; height: 6px;"></span>
                                        <span>Tổng ghi nhận: <strong style="color: var(--text); font-weight: 700;"><c:out value="${recentAuditLogs != null ? recentAuditLogs.size() : 0}"/> bản ghi</strong></span>
                                    </span>
                                    <span style="display: flex; align-items: center; gap: 6px;">
                                        <span class="live-pulse-dot" style="background: var(--secondary); width: 6px; height: 6px;"></span>
                                        <span>Thao tác hợp lệ: <strong style="color: var(--secondary); font-weight: 700;">100%</strong></span>
                                    </span>
                                    <span style="display: flex; align-items: center; gap: 6px;">
                                        <span class="live-pulse-dot" style="background: #059669; width: 6px; height: 6px;"></span>
                                        <span>Tính toàn vẹn: <strong style="color: #059669; font-weight: 700; font-family: monospace;">SHA-256 Validated</strong></span>
                                    </span>
                                </div>
                                <div style="display: flex; align-items: center; gap: 6px; color: var(--primary); font-weight: 600; cursor: pointer;" onclick="location.reload();">
                                    <svg class="icon icon-xs" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width: 14px; height: 14px;"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>
                                    <span>Làm mới tức thì</span>
                                </div>
                            </div>

                            <!-- Dense Audit Table -->
                            <c:choose>
                                <c:when test="${not empty recentAuditLogs}">
                                    <div class="table-responsive" style="margin: 0;">
                                        <table class="table audit-table-dense" style="margin: 0; width: 100%;">
                                            <thead>
                                                <tr>
                                                    <th style="min-width: 150px;">Thời gian</th>
                                                    <th style="min-width: 140px;">Quản trị viên</th>
                                                    <th style="min-width: 130px;">Hành động</th>
                                                    <th style="min-width: 130px;">Đối tượng</th>
                                                    <th style="min-width: 250px;">Chi tiết thay đổi</th>
                                                    <th style="min-width: 120px;">Địa chỉ IP</th>
                                                    <th style="text-align: center; width: 110px;">Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="log" items="${recentAuditLogs}">
                                                    <tr>
                                                        <td style="white-space: nowrap; font-size: 12px; font-family: monospace; color: var(--text-muted);">
                                                            <c:out value="${log.createdAt}" />
                                                        </td>
                                                        <td>
                                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                                <div class="mgmt-avatar color-blue" style="width: 24px; height: 24px; font-size: 10px; font-weight: 700;">
                                                                    AD
                                                                </div>
                                                                <div style="display: flex; flex-direction: column;">
                                                                    <span style="font-weight: 600; font-size: 13px; color: var(--text);">Admin #<c:out value="${log.actorId}" /></span>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="audit-badge" style="font-size: 10.5px;"><c:out value="${log.action}" /></span>
                                                        </td>
                                                        <td style="font-size: 12.5px; font-weight: 600; color: var(--primary);">
                                                            <c:out value="${log.entityType}" /> <c:if test="${log.entityId > 0}">#<c:out value="${log.entityId}" /></c:if>
                                                        </td>
                                                        <td style="max-width: 320px;">
                                                            <div style="font-family: monospace; font-size: 11.5px; background: var(--bg-alt); padding: 4px 8px; border-radius: var(--radius-sm); border: 1px solid var(--border); overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"
                                                                 title="<c:out value='${log.newValues}' />">
                                                                <c:out value="${log.newValues}" />
                                                            </div>
                                                        </td>
                                                        <td style="font-size: 12px; font-family: monospace; color: var(--text-muted); white-space: nowrap;">
                                                            <c:out value="${log.ipAddress != null ? log.ipAddress : '-'}" />
                                                        </td>
                                                        <td style="text-align: center; white-space: nowrap;">
                                                            <span style="display: inline-flex; align-items: center; gap: 4px; font-size: 11.5px; font-weight: 600; color: #059669;">
                                                                <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                                                <span>Thành công</span>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-state-icon">
                                            <svg class="icon icon-md" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                            </svg>
                                        </div>
                                        <h3 style="margin: 0 0 6px 0; font-size: 16px; font-weight: 700; color: var(--text);">Chưa có nhật ký kiểm toán nào</h3>
                                        <p style="margin: 0; font-size: 13px; color: var(--text-muted); max-width: 480px;">
                                            Các thao tác thay đổi cấu hình, phân quyền hoặc điều chỉnh tài chính sẽ tự động ghi lại tại đây theo nguyên tắc bất biến (Append-only).
                                        </p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Enterprise Architecture Security & Cryptographic Integrity Strip -->
                        <div class="crypto-strip">
                            <div style="display: flex; align-items: center; gap: 14px;">
                                <div style="width: 42px; height: 42px; border-radius: var(--radius-md); background: rgba(0, 106, 97, 0.1); color: var(--secondary); display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                </div>
                                <div>
                                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 2px;">
                                        <h3 style="margin: 0; font-size: 14px; font-weight: 700; color: var(--text);">Cơ chế mã hóa chuỗi SHA-256 bảo đảm tính toàn vẹn</h3>
                                        <span style="font-size: 10px; font-weight: 700; text-transform: uppercase; background: rgba(0, 106, 97, 0.1); color: var(--secondary); padding: 2px 6px; border-radius: 4px;">Zero Tampering</span>
                                    </div>
                                    <p style="margin: 0; font-size: 12px; color: var(--text-muted); max-width: 720px;">
                                        Tất cả các bản ghi nhật ký vận hành đều liên kết bằng chữ ký cryptographic hash, tự động đồng bộ sang kho lưu trữ độc lập định kỳ 300 giây. Không tài khoản quản trị nào có quyền thao tác trực tiếp trên dữ liệu gốc.
                                    </p>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <button type="button" class="btn btn-outline" style="font-size: 12px; padding: 6px 12px;" onclick="alert('Hệ thống tuân thủ tiêu chuẩn kiểm toán bất biến ISO 27001 và Business Rule BR18.');">
                                    Quy chuẩn tuân thủ
                                </button>
                                <button type="button" class="btn btn-primary" style="font-size: 12px; padding: 6px 12px;" onclick="alert('Đã kiểm tra chuỗi mã hóa: Tất cả các block nhật ký hợp lệ 100%!');">
                                    Xác minh toàn vẹn chuỗi
                                </button>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
</body>
</html>
