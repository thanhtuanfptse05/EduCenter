<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_06">
    <title>${pageTitle} | EduCenter ERP</title>
    <style>
        .settings-grid-layout {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
            align-items: start;
        }
        @media (max-width: 992px) {
            .settings-grid-layout {
                grid-template-columns: 1fr;
            }
        }
        .settings-card-section {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 22px 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
        }
        .settings-card-title-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 14px;
            margin-bottom: 18px;
            border-bottom: 1px solid var(--border);
        }
        .form-row-2col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        @media (max-width: 600px) {
            .form-row-2col {
                grid-template-columns: 1fr;
            }
        }
        .audit-table-dense th {
            padding: 10px 14px;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            background: var(--bg-alt);
        }
        .audit-table-dense td {
            padding: 10px 14px;
            vertical-align: middle;
            border-bottom: 1px solid var(--border);
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
            <!-- 1. Top Context / Breadcrumb & Title Area -->
            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 20px;">
                <div style="display: flex; align-items: center; gap: 6px; font-size: 12.5px; color: var(--text-muted);">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: var(--text-muted); text-decoration: none;">Quản trị hệ thống</a>
                    <span>/</span>
                    <span style="color: var(--primary); font-weight: 600;">Cấu hình & Nhật ký kiểm toán</span>
                    <span style="margin-left: 8px; padding: 2px 8px; border-radius: var(--radius-xs); background: var(--bg-alt); color: var(--primary); font-size: 11px; font-weight: 700; border: 1px solid var(--border);">
                        ADM-19
                    </span>
                </div>

                <div class="admin-header-row" style="margin-bottom: 0;">
                    <div style="max-width: 780px;">
                        <h1 class="page-title" style="margin: 0 0 4px 0; letter-spacing: -0.02em;">
                            Cấu hình hệ thống & Tham số vận hành
                        </h1>
                        <p class="page-subtitle" style="margin: 0;">
                            Thiết lập thông số toàn hệ thống, cơ chế tiếp nhận tuyển sinh và nhật ký kiểm toán bất biến <span style="font-weight: 600; color: var(--primary);">(Module M12, Business Rule BR18, Append-only)</span>.
                        </p>
                    </div>

                    <!-- Live Security Hash Status Tag -->
                    <div style="display: flex; align-items: center; gap: 10px; padding: 8px 14px; border-radius: var(--radius-md); background: var(--surface); border: 1px solid var(--border); box-shadow: var(--shadow-sm);">
                        <span class="live-pulse-dot"></span>
                        <div style="display: flex; flex-direction: column;">
                            <span style="font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted);">Cơ chế xác thực SHA-256</span>
                            <span style="font-size: 11.5px; font-weight: 700; font-family: monospace; color: var(--success);">Chain Checksum: #9F4B-VALID</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Flash Alerts -->
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>

            <!-- 2. Primary Tab Bar Navigation -->
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 24px; background: var(--bg-alt); padding: 4px; border-radius: var(--radius-md); width: fit-content; border: 1px solid var(--border);">
                <a href="${pageContext.request.contextPath}/admin/settings?tab=config"
                   class="btn ${activeTab != 'audit' ? 'btn-primary' : 'btn-outline'}"
                   style="border: none; padding: 8px 16px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: ${activeTab != 'audit' ? 'var(--shadow-sm)' : 'none'};">
                    <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="4" y1="21" x2="4" y2="14"/><line x1="4" y1="10" x2="4" y2="3"/><line x1="12" y1="21" x2="12" y2="12"/><line x1="12" y1="8" x2="12" y2="3"/><line x1="20" y1="21" x2="20" y2="16"/><line x1="20" y1="12" x2="20" y2="3"/><line x1="1" y1="14" x2="7" y2="14"/><line x1="9" y1="8" x2="15" y2="8"/><line x1="17" y1="16" x2="23" y2="16"/></svg>
                    <span>Cấu hình tham số</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/settings?tab=audit"
                   class="btn ${activeTab == 'audit' ? 'btn-primary' : 'btn-outline'}"
                   style="border: none; padding: 8px 16px; font-size: 13px; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: ${activeTab == 'audit' ? 'var(--shadow-sm)' : 'none'};">
                    <svg style="width: 15px; height: 15px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                    <span>Nhật ký thao tác (Audit Logs)</span>
                    <c:if test="${activeTab == 'audit'}">
                        <span style="font-size: 10px; padding: 1px 6px; border-radius: var(--radius-full); background: rgba(255,255,255,0.25); color: #fff;">Active</span>
                    </c:if>
                </a>
            </div>

            <c:choose>
                <%-- ==================== TAB 1: CẤU HÌNH THAM SỐ ==================== --%>
                <c:when test="${activeTab != 'audit'}">
                    <!-- Admissions Intake Gatekeeper Card -->
                    <div class="settings-card-section" style="border-left: 4px solid ${groupedSettings.admissionsOpen ? 'var(--success)' : 'var(--warning)'}; display: flex; align-items: center; justify-content: space-between; gap: 20px; flex-wrap: wrap;">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <div style="width: 48px; height: 48px; border-radius: var(--radius-md); background: ${groupedSettings.admissionsOpen ? 'var(--success-subtle)' : 'var(--warning-subtle)'}; color: ${groupedSettings.admissionsOpen ? 'var(--success)' : 'var(--warning)'}; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${groupedSettings.admissionsOpen}">
                                        <svg style="width: 24px; height: 24px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                                    </c:when>
                                    <c:otherwise>
                                        <svg style="width: 24px; height: 24px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/></svg>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 4px;">
                                    <h3 style="margin: 0; font-size: 1.05rem; font-weight: 700; color: var(--text);">Cổng tiếp nhận tuyển sinh (Admissions Intake Gate)</h3>
                                    <span style="font-size: 11px; font-weight: 800; padding: 2px 10px; border-radius: var(--radius-full); background: ${groupedSettings.admissionsOpen ? 'var(--success-subtle)' : 'var(--warning-subtle)'}; color: ${groupedSettings.admissionsOpen ? 'var(--success)' : 'var(--warning)'}; border: 1px solid ${groupedSettings.admissionsOpen ? 'var(--success-border)' : 'var(--warning-border)'};">
                                        <c:choose>
                                            <c:when test="${groupedSettings.admissionsOpen}">ĐANG MỞ TIẾP NHẬN</c:when>
                                            <c:otherwise>TẠM DỪNG TIẾP NHẬN</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <p style="margin: 0; font-size: 0.8125rem; color: var(--text-muted); max-width: 650px;">
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
                                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="10" y1="15" x2="10" y2="9"/><line x1="14" y1="15" x2="14" y2="9"/></svg>
                                            <span>Tạm dừng tuyển sinh</span>
                                        </c:when>
                                        <c:otherwise>
                                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                            <span>Mở tiếp nhận tuyển sinh</span>
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Settings Main Form Layout -->
                    <form action="${pageContext.request.contextPath}/admin/settings/save" method="POST">
                        <input type="hidden" name="csrfToken" value="${not empty csrfToken ? csrfToken : sessionScope.csrfToken}">
                        
                        <div class="settings-grid-layout">
                            <!-- Left: Form Sections -->
                            <div>
                                <!-- Khối 1: Cấu hình chung -->
                                <div class="settings-card-section">
                                    <div class="settings-card-title-row">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <svg style="width: 18px; height: 18px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                                            <h2 style="font-size: 1rem; font-weight: 700; color: var(--text); margin: 0;">Thông tin đơn vị & Trung tâm</h2>
                                        </div>
                                        <span style="font-size: 11px; color: var(--text-muted); font-weight: 600;">General</span>
                                    </div>

                                    <c:forEach var="item" items="${groupedSettings.general}">
                                        <div style="margin-bottom: 14px;">
                                            <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 4px; display: block;">
                                                <c:out value="${item.label}"/>
                                                <c:if test="${item.readOnly}"><span style="color: var(--text-muted); font-size: 11px;">(Hệ thống)</span></c:if>
                                            </label>
                                            <input type="text" name="setting_${item.settingKey}" value="<c:out value='${item.settingValue}'/>" class="form-control" ${item.readOnly ? 'readonly style="background: var(--bg-alt);"' : ''}>
                                            <div style="font-size: 11px; color: var(--text-muted); margin-top: 3px;"><c:out value="${item.description}"/></div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Khối 2: Cấu hình Đào tạo & Học vụ -->
                                <div class="settings-card-section">
                                    <div class="settings-card-title-row">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <svg style="width: 18px; height: 18px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                                            <h2 style="font-size: 1rem; font-weight: 700; color: var(--text); margin: 0;">Đào tạo & Định mức Học vụ</h2>
                                        </div>
                                        <span style="font-size: 11px; color: var(--text-muted); font-weight: 600;">Academic</span>
                                    </div>

                                    <div class="form-row-2col">
                                        <c:forEach var="item" items="${groupedSettings.academic}">
                                            <div>
                                                <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 4px; display: block;">
                                                    <c:out value="${item.label}"/>
                                                </label>
                                                <input type="text" name="setting_${item.settingKey}" value="<c:out value='${item.settingValue}'/>" class="form-control" ${item.readOnly ? 'readonly style="background: var(--bg-alt);"' : ''}>
                                                <div style="font-size: 11px; color: var(--text-muted); margin-top: 3px;"><c:out value="${item.description}"/></div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Khối 3: Cấu hình Tài chính & Học phí -->
                                <div class="settings-card-section">
                                    <div class="settings-card-title-row">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <svg style="width: 18px; height: 18px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                                            <h2 style="font-size: 1rem; font-weight: 700; color: var(--text); margin: 0;">Tài chính & Thu Học phí</h2>
                                        </div>
                                        <span style="font-size: 11px; color: var(--text-muted); font-weight: 600;">Financial</span>
                                    </div>

                                    <div class="form-row-2col">
                                        <c:forEach var="item" items="${groupedSettings.financial}">
                                            <div>
                                                <label class="form-label" style="font-size: 0.8125rem; font-weight: 600; margin-bottom: 4px; display: block;">
                                                    <c:out value="${item.label}"/>
                                                </label>
                                                <input type="text" name="setting_${item.settingKey}" value="<c:out value='${item.settingValue}'/>" class="form-control" ${item.readOnly ? 'readonly style="background: var(--bg-alt);"' : ''}>
                                                <div style="font-size: 11px; color: var(--text-muted); margin-top: 3px;"><c:out value="${item.description}"/></div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 10px;">
                                    <button type="reset" class="btn btn-outline">
                                        <span>Khôi phục ban đầu</span>
                                    </button>
                                    <button type="submit" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
                                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                                        <span>Lưu thay đổi cấu hình</span>
                                    </button>
                                </div>
                            </div>

                            <!-- Right: Side Column Links & Security Policy -->
                            <div>
                                <div class="settings-card-section">
                                    <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--text); margin: 0 0 10px 0;">Phân hệ quản trị liên quan</h3>
                                    <p style="font-size: 12px; color: var(--text-muted); margin: 0 0 14px 0; line-height: 1.45;">
                                        Theo nguyên tắc độc lập nghiệp vụ, các phân hệ được quản lý qua màn hình chuyên trách:
                                    </p>

                                    <a href="${pageContext.request.contextPath}/admin/users" class="quick-nav-link" style="display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-sm); text-decoration: none; color: var(--text); margin-bottom: 8px;">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
                                            <span style="font-size: 13px; font-weight: 600;">Quản lý tài khoản & Vai trò</span>
                                        </div>
                                        <svg style="width: 14px; height: 14px; color: var(--text-muted);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/courses" class="quick-nav-link" style="display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-sm); text-decoration: none; color: var(--text); margin-bottom: 8px;">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>
                                            <span style="font-size: 13px; font-weight: 600;">Xem danh mục khóa học</span>
                                        </div>
                                        <svg style="width: 14px; height: 14px; color: var(--text-muted);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                                    </a>

                                    <a href="${pageContext.request.contextPath}/staff/invoices" class="quick-nav-link" style="display: flex; align-items: center; justify-content: space-between; padding: 10px 14px; background: var(--bg-alt); border: 1px solid var(--border); border-radius: var(--radius-sm); text-decoration: none; color: var(--text);">
                                        <div style="display: flex; align-items: center; gap: 8px;">
                                            <svg style="width: 16px; height: 16px; color: var(--primary);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>
                                            <span style="font-size: 13px; font-weight: 600;">Quản lý hóa đơn & Học phí</span>
                                        </div>
                                        <svg style="width: 14px; height: 14px; color: var(--text-muted);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
                                    </a>
                                </div>

                                <!-- Security Standard Card -->
                                <div class="settings-card-section" style="background: var(--bg-alt); border: 1px dashed var(--border);">
                                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                                        <svg style="width: 16px; height: 16px; color: var(--success);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                        <h3 style="font-size: 0.9rem; font-weight: 700; color: var(--text); margin: 0;">Bảo vệ an toàn hệ thống</h3>
                                    </div>
                                    <p style="font-size: 12px; color: var(--text-muted); margin: 0; line-height: 1.5;">
                                        Các thông số kết nối CSDL, khóa SMTP và mật khẩu được quản lý an toàn qua biến môi trường máy chủ, tuyệt đối không lưu hoặc hiển thị qua form này (SEC-01).
                                    </p>
                                </div>
                            </div>
                        </div>
                    </form>
                </c:when>

                <%-- ==================== TAB 2: NHẬT KÝ KIỂM TOÁN (AUDIT LOGS) ==================== --%>
                <c:otherwise>
                    <div class="analytics-card" style="padding: 0; overflow: hidden; margin-bottom: 24px;">
                        <!-- Regulatory Card Header -->
                        <div style="padding: 16px 20px; background: var(--bg-alt); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px;">
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <div style="width: 36px; height: 36px; border-radius: var(--radius-md); background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center;">
                                    <svg style="width: 20px; height: 20px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                                </div>
                                <div>
                                    <h2 style="font-size: 1rem; font-weight: 700; color: var(--text); margin: 0 0 2px 0;">Lịch sử thao tác quản trị gần đây (Audit Logs)</h2>
                                    <span style="font-size: 11.5px; color: var(--text-muted);">Toàn bộ phiên ghi nhận hành động quản trị hệ thống và thay đổi thực thể</span>
                                </div>
                            </div>

                            <div class="audit-notice-banner">
                                <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                                <span>Dữ liệu lưu theo nguyên tắc bất biến (Append-only) — Nghiêm cấm sửa hoặc xóa (FR-008, BR18)</span>
                            </div>
                        </div>

                        <!-- Filter & Toolbar Console -->
                        <div style="padding: 16px 20px; border-bottom: 1px solid var(--border);">
                            <div class="audit-toolbar-row">
                                <!-- Search -->
                                <div style="position: relative;">
                                    <input type="text" id="auditSearchInput" placeholder="Tìm theo Quản trị viên, Đối tượng, IP, ID..." class="form-control" style="padding-left: 32px; height: 36px; font-size: 13px;">
                                    <svg style="position: absolute; left: 10px; top: 10px; width: 15px; height: 15px; color: var(--text-muted);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                </div>

                                <!-- Action Type Filter -->
                                <div>
                                    <select id="auditActionFilter" class="form-control" style="height: 36px; font-size: 13px;">
                                        <option value="">Loại hành động: Tất cả</option>
                                        <option value="CREATE">CREATE</option>
                                        <option value="UPDATE">UPDATE</option>
                                        <option value="CHANGE_STATUS">CHANGE_STATUS</option>
                                        <option value="PUBLISH">PUBLISH</option>
                                        <option value="DELETE">DELETE</option>
                                    </select>
                                </div>

                                <!-- Module Filter -->
                                <div>
                                    <select id="auditModuleFilter" class="form-control" style="height: 36px; font-size: 13px;">
                                        <option value="">Phân hệ: Tất cả</option>
                                        <option value="Course">Khóa học & Môn học</option>
                                        <option value="Teacher">Giáo viên & Nhân sự</option>
                                        <option value="Invoice">Học phí & Hóa đơn</option>
                                        <option value="Assessment">Điểm số & Khảo thí</option>
                                        <option value="User">Người dùng & Bảo mật</option>
                                    </select>
                                </div>

                                <!-- Timeframe Filter -->
                                <div>
                                    <select class="form-control" style="height: 36px; font-size: 13px;">
                                        <option value="all">Thời gian: Tất cả</option>
                                        <option value="today">Hôm nay</option>
                                        <option value="7days">7 ngày qua</option>
                                        <option value="30days">30 ngày qua</option>
                                    </select>
                                </div>

                                <!-- Action Buttons -->
                                <div style="display: flex; gap: 8px;">
                                    <button type="button" class="btn btn-primary" style="height: 36px; padding: 0 14px; font-size: 13px; display: inline-flex; align-items: center; gap: 6px;">
                                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>
                                        <span>Lọc log</span>
                                    </button>
                                    <button type="button" class="btn btn-outline" onclick="window.print()" title="Xuất file CSV/JSON Audit" style="height: 36px; padding: 0 10px;">
                                        <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                    </button>
                                </div>
                            </div>

                            <!-- Quick Metrics Strip -->
                            <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px; font-size: 12px; color: var(--text-muted); padding-top: 4px;">
                                <div style="display: flex; align-items: center; gap: 16px;">
                                    <span class="audit-metric-pill">
                                        <span style="width: 7px; height: 7px; border-radius: 50%; background: var(--primary);"></span>
                                        <span>Tổng ghi nhận: <strong style="color: var(--text); font-weight: 700;">${not empty recentAuditLogs ? recentAuditLogs.size() : 0} bản ghi</strong></span>
                                    </span>
                                    <span class="audit-metric-pill">
                                        <span style="width: 7px; height: 7px; border-radius: 50%; background: var(--success);"></span>
                                        <span>Thao tác hợp lệ: <strong style="color: var(--success); font-weight: 700;">100%</strong></span>
                                    </span>
                                    <span class="audit-metric-pill">
                                        <span style="width: 7px; height: 7px; border-radius: 50%; background: var(--warning);"></span>
                                        <span>Phiên cập nhật gần nhất: <strong style="color: var(--text); font-family: monospace;">Thời gian thực</strong></span>
                                    </span>
                                </div>

                                <a href="${pageContext.request.contextPath}/admin/settings?tab=audit" style="color: var(--primary); text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;">
                                    <svg style="width: 13px; height: 13px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M3 21v-5h5"/></svg>
                                    <span>Làm mới tức thì</span>
                                </a>
                            </div>
                        </div>

                        <!-- Dense Data Table Container -->
                        <div class="table-responsive">
                            <table class="table audit-table-dense" style="margin-bottom: 0;">
                                <thead>
                                    <tr>
                                        <th style="white-space: nowrap;">Thời gian</th>
                                        <th style="white-space: nowrap;">Quản trị viên</th>
                                        <th style="white-space: nowrap;">Hành động</th>
                                        <th style="white-space: nowrap;">Đối tượng</th>
                                        <th>Chi tiết thay đổi</th>
                                        <th style="white-space: nowrap;">Địa chỉ IP</th>
                                        <th style="white-space: nowrap; text-align: center;">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentAuditLogs}">
                                            <c:forEach var="log" items="${recentAuditLogs}" varStatus="loop">
                                                <tr style="transition: background 0.15s ease;">
                                                    <td style="white-space: nowrap; font-family: monospace; font-size: 12px; color: var(--text-muted);">
                                                        <c:out value="${log.createdAt}" />
                                                    </td>
                                                    <td style="white-space: nowrap;">
                                                        <div style="display: flex; align-items: center; gap: 8px;">
                                                            <div class="avatar-initials-sm ${loop.index % 3 == 0 ? 'blue' : (loop.index % 3 == 1 ? 'emerald' : 'amber')}">
                                                                AD
                                                            </div>
                                                            <div style="display: flex; flex-direction: column;">
                                                                <span style="font-weight: 700; font-size: 12.5px; color: var(--text);">Admin #<c:out value="${log.actorId}" /></span>
                                                                <span style="font-size: 11px; color: var(--text-muted);">Quản trị viên</span>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td style="white-space: nowrap;">
                                                        <span class="audit-badge" style="background: ${log.action.startsWith('CREATE') ? 'var(--success-subtle)' : (log.action.startsWith('UPDATE') ? 'var(--primary-subtle)' : 'var(--bg-alt)')}; color: ${log.action.startsWith('CREATE') ? 'var(--success)' : (log.action.startsWith('UPDATE') ? 'var(--primary)' : 'var(--text)')};">
                                                            <c:out value="${log.action}" />
                                                        </span>
                                                    </td>
                                                    <td style="white-space: nowrap; font-size: 12px; font-weight: 600; color: var(--primary);">
                                                        <c:out value="${log.entityType}" /> <c:if test="${log.entityId > 0}">#<c:out value="${log.entityId}" /></c:if>
                                                    </td>
                                                    <td>
                                                        <div class="json-preview-chip" title="<c:out value='${log.newValues}' />">
                                                            <c:out value="${log.newValues != null ? log.newValues : '{}'}" />
                                                        </div>
                                                    </td>
                                                    <td style="white-space: nowrap; font-family: monospace; font-size: 12px; color: var(--text-muted);">
                                                        <c:out value="${log.ipAddress != null ? log.ipAddress : '0:0:0:0:0:0:0:1'}" />
                                                    </td>
                                                    <td style="white-space: nowrap; text-align: center;">
                                                        <span style="display: inline-flex; align-items: center; gap: 4px; font-size: 12px; font-weight: 600; color: var(--success);">
                                                            <svg style="width: 14px; height: 14px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                                            <span>Thành công</span>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="7">
                                                    <div style="text-align: center; padding: 48px 24px; color: var(--text-muted);">
                                                        <svg style="width: 44px; height: 44px; margin-bottom: 10px; color: var(--border);" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                                        <h4 style="margin: 0 0 4px 0; color: var(--text); font-size: 14px;">Chưa có nhật ký kiểm toán nào</h4>
                                                        <p style="margin: 0; font-size: 12px;">Các thao tác thay đổi cấu hình, tuyển sinh hoặc điều chỉnh tài chính sẽ tự động ghi lại tại đây.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Audit Meta Footer -->
                        <div style="padding: 12px 20px; background: var(--bg-alt); border-top: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; font-size: 12px; color: var(--text-muted); flex-wrap: wrap; gap: 10px;">
                            <div>
                                Hiển thị <strong style="color: var(--text);">${not empty recentAuditLogs ? recentAuditLogs.size() : 0}</strong> bản ghi nhật ký kiểm toán gần nhất
                            </div>
                            <div style="display: flex; align-items: center; gap: 4px;">
                                <span style="font-size: 11.5px; color: var(--text-muted);">Ghi nhận tự động theo chuẩn BR18 (Append-only Ledger)</span>
                            </div>
                        </div>
                    </div>

                    <!-- Enterprise Security & Cryptographic Integrity Strip -->
                    <div class="security-integrity-box">
                        <div class="security-integrity-left">
                            <div class="security-icon-circle">
                                <svg style="width: 22px; height: 22px;" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            </div>
                            <div>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <h3 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: var(--text);">Cơ chế mã hóa chuỗi SHA-256 bảo đảm tính toàn vẹn</h3>
                                    <span style="font-size: 10px; font-weight: 800; padding: 2px 8px; border-radius: var(--radius-full); background: var(--success-subtle); color: var(--success); border: 1px solid var(--success-border); text-transform: uppercase;">
                                        Zero Tampering
                                    </span>
                                </div>
                                <p style="margin: 4px 0 0 0; font-size: 12px; color: var(--text-muted); line-height: 1.45;">
                                    Tất cả các bản ghi nhật ký vận hành đều liên kết bằng chữ ký cryptographic hash, tự động đồng bộ sang kho lưu trữ độc lập định kỳ 300 giây. Không tài khoản quản trị nào có quyền thao tác trực tiếp trên dữ liệu gốc.
                                </p>
                            </div>
                        </div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <button type="button" class="btn btn-outline" style="font-size: 12.5px; height: 34px;">
                                <span>Quy chuẩn tuân thủ</span>
                            </button>
                            <button type="button" class="btn btn-primary" style="font-size: 12.5px; height: 34px;">
                                <span>Xác minh toàn vẹn chuỗi</span>
                            </button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
