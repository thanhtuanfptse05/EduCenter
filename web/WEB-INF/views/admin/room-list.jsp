<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
    <style>
        .kpi-row-3 {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        @media (max-width: 768px) {
            .kpi-row-3 { grid-template-columns: 1fr; }
        }
        .kpi-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 18px;
            box-shadow: var(--shadow-sm);
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .kpi-icon-wrap {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--primary-subtle);
            color: var(--primary);
            flex-shrink: 0;
        }
        .kpi-icon-wrap.success { background: var(--success-subtle); color: var(--success); }
        .kpi-icon-wrap.warning { background: var(--warning-subtle); color: var(--warning); }
        .kpi-val { font-size: 24px; font-weight: 700; color: var(--text); line-height: 1.2; }
        .kpi-lbl { font-size: 11px; color: var(--text-muted); font-weight: 500; text-transform: uppercase; margin-top: 2px; }
        
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 20px;
        }
        .modal-overlay.active { display: flex; }
        .modal-card {
            background: var(--surface);
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            width: 100%;
            max-width: 480px;
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            animation: modalFadeIn 0.2s ease-out;
        }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: scale(0.96); }
            to { opacity: 1; transform: scale(1); }
        }
        .modal-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .modal-body { padding: 20px; }
        .modal-footer {
            padding: 14px 20px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            background: var(--bg);
        }
        .room-code-badge {
            font-family: monospace;
            font-weight: 600;
            color: var(--primary);
            background: var(--primary-subtle);
            padding: 2px 8px;
            border-radius: var(--radius-sm);
            font-size: 13px;
        }
        .badge-available { background: var(--success-subtle); color: var(--success); }
        .badge-maintenance { background: var(--warning-subtle); color: var(--warning); }
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
                        <h1 class="page-title">Quản lý Phòng học</h1>
                        <p class="page-subtitle">Danh mục phòng học, sức chứa và kiểm soát bảo trì (UC34)</p>
                    </div>
                    <div style="display: flex; gap: 10px;">
                        <a href="${pageContext.request.contextPath}/admin/classes" class="btn btn-secondary">
                            &larr; Quản lý Lớp học
                        </a>
                        <button type="button" class="btn btn-primary" onclick="openCreateModal()">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                            Thêm phòng học mới
                        </button>
                    </div>
                </div>

                <!-- Flash Messages -->
                <c:if test="${not empty flashSuccess}">
                    <div class="alert alert-success" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                        <span>${flashSuccess}</span>
                    </div>
                </c:if>
                <c:if test="${not empty flashError}">
                    <div class="alert alert-danger" style="margin-bottom: 20px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span>${flashError}</span>
                    </div>
                </c:if>

                <!-- KPI Thống kê -->
                <div class="kpi-row-3">
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${totalRooms}</div>
                            <div class="kpi-lbl">Tổng số phòng học</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap success">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${availableCount}</div>
                            <div class="kpi-lbl">Phòng sẵn sàng (AVAILABLE)</div>
                        </div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon-wrap warning">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        </div>
                        <div>
                            <div class="kpi-val">${maintenanceCount}</div>
                            <div class="kpi-lbl">Đang bảo trì (MAINTENANCE)</div>
                        </div>
                    </div>
                </div>

                <!-- Bảng danh sách phòng học -->
                <div class="content-card">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th style="width: 130px;">Mã phòng</th>
                                    <th>Tên phòng học</th>
                                    <th style="width: 140px;">Sức chứa</th>
                                    <th style="width: 160px;">Lớp đang sử dụng</th>
                                    <th style="width: 160px;">Trạng thái</th>
                                    <th style="width: 120px; text-align: right;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty rooms}">
                                        <c:forEach var="rm" items="${rooms}">
                                            <tr>
                                                <td>
                                                    <span class="room-code-badge">${rm.code}</span>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text);">${rm.name}</div>
                                                </td>
                                                <td>
                                                    <div style="font-weight: 600; color: var(--text); font-size: 14px;">
                                                        ${rm.capacity} chỗ ngồi
                                                    </div>
                                                </td>
                                                <td>
                                                    <div style="font-size: 13px; color: var(--text);">
                                                        ${rm.activeClassesCount} lớp học
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${rm.status == 'AVAILABLE'}">
                                                            <span class="badge badge-available">Khả dụng</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-maintenance">Bảo trì</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: right;">
                                                    <button type="button" class="btn btn-sm btn-secondary" 
                                                            onclick="openEditModal(${rm.id}, '${rm.code}', '${rm.name}', ${rm.capacity}, '${rm.status}')">
                                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                        Sửa
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6">
                                                <div style="padding: 40px; text-align: center;">
                                                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="color: var(--text-muted); opacity: 0.5; margin-bottom: 12px;"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                                    <h4 style="font-size: 15px; font-weight: 600; color: var(--text); margin-bottom: 4px;">Chưa có phòng học nào</h4>
                                                    <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 16px;">Vui lòng thêm các phòng học để phục vụ việc xếp lớp và thời khóa biểu.</p>
                                                    <button type="button" class="btn btn-primary btn-sm" onclick="openCreateModal()">
                                                        Thêm phòng học ngay
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Modal Thêm/Sửa Phòng học -->
                <div id="roomModal" class="modal-overlay">
                    <div class="modal-card">
                        <div class="modal-header">
                            <h3 id="modalTitle" style="font-size: 16px; font-weight: 700; color: var(--text); margin: 0;">Thêm phòng học mới</h3>
                            <button type="button" class="btn-close" onclick="closeRoomModal()" style="background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-muted);">&times;</button>
                        </div>
                        <form id="roomForm" method="post" action="${pageContext.request.contextPath}/admin/rooms/create">
                            <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">
                            <input type="hidden" id="roomId" name="id" value="">

                            <div class="modal-body">
                                <div class="form-group">
                                    <label class="form-label required">Mã phòng học</label>
                                    <input type="text" id="roomCode" name="code" class="form-control" placeholder="VD: P101, LAB02" required style="text-transform: uppercase;">
                                </div>
                                <div class="form-group">
                                    <label class="form-label required">Tên phòng học</label>
                                    <input type="text" id="roomName" name="name" class="form-control" placeholder="VD: Phòng Lý thuyết 101" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label required">Sức chứa (chỗ ngồi)</label>
                                    <input type="number" id="roomCapacity" name="capacity" class="form-control" min="1" max="500" value="20" required>
                                </div>
                                <div class="form-group" style="margin-bottom: 0;">
                                    <label class="form-label required">Trạng thái phòng</label>
                                    <select id="roomStatus" name="status" class="form-control" required>
                                        <option value="AVAILABLE">Khả dụng (AVAILABLE)</option>
                                        <option value="MAINTENANCE">Bảo trì (MAINTENANCE)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeRoomModal()">Hủy</button>
                                <button type="submit" class="btn btn-primary">Lưu phòng học</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function openCreateModal() {
                        document.getElementById('modalTitle').innerText = 'Thêm phòng học mới';
                        document.getElementById('roomForm').action = '${pageContext.request.contextPath}/admin/rooms/create';
                        document.getElementById('roomId').value = '';
                        document.getElementById('roomCode').value = '';
                        document.getElementById('roomName').value = '';
                        document.getElementById('roomCapacity').value = '20';
                        document.getElementById('roomStatus').value = 'AVAILABLE';
                        document.getElementById('roomModal').classList.add('active');
                    }
                    function openEditModal(id, code, name, capacity, status) {
                        document.getElementById('modalTitle').innerText = 'Chỉnh sửa phòng học: ' + code;
                        document.getElementById('roomForm').action = '${pageContext.request.contextPath}/admin/rooms/edit';
                        document.getElementById('roomId').value = id;
                        document.getElementById('roomCode').value = code;
                        document.getElementById('roomName').value = name;
                        document.getElementById('roomCapacity').value = capacity;
                        document.getElementById('roomStatus').value = status;
                        document.getElementById('roomModal').classList.add('active');
                    }
                    function closeRoomModal() {
                        document.getElementById('roomModal').classList.remove('active');
                    }
                </script>
            </main>
        </div>
    </div>
</body>
</html>
