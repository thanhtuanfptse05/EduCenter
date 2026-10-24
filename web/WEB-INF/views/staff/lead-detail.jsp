<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261024_05">
    <title>${pageTitle}</title>
    <style>
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        @media (max-width: 992px) {
            .detail-grid { grid-template-columns: 1fr; }
        }
        .timeline-item {
            position: relative;
            padding-left: 28px;
            padding-bottom: 20px;
            border-left: 2px solid var(--border);
        }
        .timeline-item:last-child {
            border-left: 2px solid transparent;
            padding-bottom: 0;
        }
        .timeline-dot {
            position: absolute;
            left: -7px;
            top: 2px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--primary);
            border: 2px solid var(--surface);
        }
    </style>
</head>
<body>
<c:set var="internalShell" value="true" scope="request"/>
<div class="admin-layout">
    <c:set var="activeNav" value="leads" scope="request" />
    <c:set var="breadcrumb" value="Chi tiết Khách hàng" scope="request" />
    <%@ include file="/WEB-INF/views/common/sidebar.jspf" %>

    <div class="admin-main">
        <%@ include file="/WEB-INF/views/common/header.jspf" %>

        <main class="admin-content">
            <!-- Flash Message -->
            <c:if test="${not empty flashSuccess}">
                <div class="alert alert-success" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <span>${flashSuccess}</span>
                </div>
            </c:if>
            <c:if test="${not empty flashError}">
                <div class="alert alert-danger" style="display: flex; align-items: center; gap: 10px; margin-bottom: 20px;">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    <span>${flashError}</span>
                </div>
            </c:if>

            <!-- Breadcrumb -->
            <div style="font-size: 0.875rem; color: var(--text-muted); margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                <a href="${pageContext.request.contextPath}/staff/leads" style="color: var(--primary); text-decoration: none;">Danh sách Khách hàng</a>
                <span>/</span>
                <span>Chi tiết tư vấn #LEAD-${lead.id}</span>
            </div>

            <!-- Page Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 24px;">
                <div>
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <h1 style="font-size: 1.5rem; font-weight: 700; color: var(--text); margin: 0;">${lead.name}</h1>
                        <span class="badge ${lead.statusBadgeClass}">${lead.statusDisplayName}</span>
                    </div>
                    <div style="font-size: 0.875rem; color: var(--text-muted); margin-top: 4px;">
                        Mã khách hàng: #LEAD-${lead.id} • Tiếp nhận từ nguồn: <strong>${lead.source}</strong> • Ngày tạo: ${lead.createdAt.toLocalDate()}
                    </div>
                </div>

                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/staff/enrollments/create?leadId=${lead.id}" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
                        <span>Chuyển sang Ghi danh học viên</span>
                    </a>
                </div>
            </div>

            <!-- Main Detail Grid -->
            <div class="detail-grid">
                <!-- Left Column: Customer Info & Status Update -->
                <div>
                    <!-- Customer Information Card -->
                    <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 20px 24px; margin-bottom: 24px; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 16px 0; border-bottom: 1px solid var(--border); padding-bottom: 12px;">
                            Thông tin liên hệ
                        </h3>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                            <div>
                                <div style="font-size: 0.8125rem; color: var(--text-muted); margin-bottom: 4px;">Số điện thoại</div>
                                <div style="font-weight: 600; font-size: 1rem;">
                                    <a href="tel:${lead.phone}" style="color: var(--primary); text-decoration: none;">${lead.phone}</a>
                                </div>
                            </div>
                            <div>
                                <div style="font-size: 0.8125rem; color: var(--text-muted); margin-bottom: 4px;">Email</div>
                                <div style="font-weight: 500;">
                                    <c:choose>
                                        <c:when test="${not empty lead.email}">${lead.email}</c:when>
                                        <c:otherwise><span style="color: var(--text-muted);">Chưa cập nhật</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div>
                                <div style="font-size: 0.8125rem; color: var(--text-muted); margin-bottom: 4px;">Khối lớp quan tâm</div>
                                <div style="font-weight: 600;">
                                    <c:choose>
                                        <c:when test="${not empty lead.gradeLevel}">Lớp ${lead.gradeLevel}</c:when>
                                        <c:otherwise><span style="color: var(--text-muted);">Chưa xác định</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div>
                                <div style="font-size: 0.8125rem; color: var(--text-muted); margin-bottom: 4px;">Người phụ trách hiện tại</div>
                                <div style="font-weight: 600; color: var(--text);">
                                    <c:choose>
                                        <c:when test="${not empty lead.assignedToName}">${lead.assignedToName}</c:when>
                                        <c:otherwise><span style="color: var(--warning);">Chưa phân công</span></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty lead.notes}">
                            <div style="margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border);">
                                <div style="font-size: 0.8125rem; color: var(--text-muted); margin-bottom: 6px;">Nội dung ban đầu / Nhu cầu:</div>
                                <div style="background: var(--bg-alt); padding: 12px 14px; border-radius: var(--radius-md); font-size: 0.875rem; white-space: pre-line; color: var(--text);">
                                    ${lead.notes}
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Update Status & Assignment Card -->
                    <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 20px 24px; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 16px 0; border-bottom: 1px solid var(--border); padding-bottom: 12px;">
                            Cập nhật Tiến trình & Phân công
                        </h3>

                        <form action="${pageContext.request.contextPath}/staff/leads/status" method="POST">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="leadId" value="${lead.id}">

                            <div style="margin-bottom: 14px;">
                                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Trạng thái tư vấn</label>
                                <select name="status" class="form-control" required>
                                    <option value="NEW" ${lead.status == 'NEW' ? 'selected' : ''}>Mới tiếp nhận (NEW)</option>
                                    <option value="CONTACTED" ${lead.status == 'CONTACTED' ? 'selected' : ''}>Đã liên hệ cuộc gọi đầu (CONTACTED)</option>
                                    <option value="CONSULTING" ${lead.status == 'CONSULTING' ? 'selected' : ''}>Đang tư vấn / Chờ lịch hẹn (CONSULTING)</option>
                                    <option value="ASSESSED" ${lead.status == 'ASSESSED' ? 'selected' : ''}>Đã làm bài kiểm tra đầu vào (ASSESSED)</option>
                                    <option value="ENROLLED" ${lead.status == 'ENROLLED' ? 'selected' : ''}>Đã hoàn thành ghi danh (ENROLLED)</option>
                                    <option value="LOST" ${lead.status == 'LOST' ? 'selected' : ''}>Hủy / Khách hàng từ chối (LOST)</option>
                                </select>
                            </div>

                            <div style="margin-bottom: 14px;">
                                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Phân công nhân viên phụ trách</label>
                                <select name="assignedToId" class="form-control">
                                    <option value="-1">-- Không phân công (Bỏ trống) --</option>
                                    <c:forEach var="staff" items="${lead.staffList}">
                                        <option value="${staff.userId}" ${lead.assignedToId == staff.userId ? 'selected' : ''}>
                                            ${staff.fullName} (${staff.email})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div style="margin-bottom: 16px;">
                                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Ghi chú cập nhật tiến trình</label>
                                <input type="text" name="notes" class="form-control" placeholder="Ví dụ: Đã tư vấn học phí, phụ huynh hẹn thứ 7 đưa con đến...">
                            </div>

                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                Cập nhật trạng thái
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Right Column: Consultation Timeline & Add Note -->
                <div>
                    <!-- Add Consultation Note Form Card -->
                    <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 20px 24px; margin-bottom: 24px; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 16px 0; border-bottom: 1px solid var(--border); padding-bottom: 12px; display: flex; align-items: center; gap: 8px;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                            <span>Ghi nhận Nhật ký Cuộc gọi / Tư vấn</span>
                        </h3>

                        <form action="${pageContext.request.contextPath}/staff/leads/consultation" method="POST">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <input type="hidden" name="leadId" value="${lead.id}">

                            <div style="margin-bottom: 14px;">
                                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Nội dung trao đổi <span style="color: var(--danger);">*</span></label>
                                <textarea name="notes" class="form-control" rows="3" required placeholder="Ghi nhận phản hồi của phụ huynh/học sinh, câu hỏi thắc mắc, nguyện vọng..."></textarea>
                            </div>

                            <div style="margin-bottom: 16px;">
                                <label class="form-label" style="font-size: 0.875rem; font-weight: 600; display: block; margin-bottom: 6px;">Lịch hẹn gọi lại / Test tiếp theo (nếu có)</label>
                                <input type="datetime-local" name="nextAppointment" class="form-control">
                            </div>

                            <button type="submit" class="btn btn-primary" style="display: flex; align-items: center; justify-content: center; gap: 8px; width: 100%;">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                                <span>Lưu nhật ký tư vấn</span>
                            </button>
                        </form>
                    </div>

                    <!-- Consultation Timeline Card -->
                    <div class="card" style="background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 20px 24px; box-shadow: var(--shadow-sm);">
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin: 0 0 16px 0; border-bottom: 1px solid var(--border); padding-bottom: 12px;">
                            Lịch sử Tư vấn & Tương tác (${lead.consultations.size()} lượt)
                        </h3>

                        <c:choose>
                            <c:when test="${empty lead.consultations}">
                                <div style="text-align: center; padding: 32px 16px; color: var(--text-muted);">
                                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="margin-bottom: 10px; opacity: 0.6;"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                                    <div style="font-weight: 600; color: var(--text);">Chưa có nhật ký tư vấn</div>
                                    <div style="font-size: 0.8125rem; margin-top: 4px;">Hãy thêm ghi nhận cuộc gọi ở biểu mẫu phía trên.</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="margin-top: 8px;">
                                    <c:forEach var="c" items="${lead.consultations}">
                                        <div class="timeline-item">
                                            <div class="timeline-dot"></div>
                                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 4px;">
                                                <div style="font-weight: 600; font-size: 0.875rem; color: var(--text);">${c.staffName != null ? c.staffName : 'Nhân viên tuyển sinh'}</div>
                                                <div style="font-size: 0.75rem; color: var(--text-muted);">
                                                    ${c.contactedAt.toLocalDate()} ${c.contactedAt.toLocalTime().toString().substring(0, 5)}
                                                </div>
                                            </div>
                                            <div style="font-size: 0.875rem; color: var(--text); background: var(--bg-alt); padding: 10px 12px; border-radius: var(--radius-md); margin-top: 6px; white-space: pre-line;">
                                                ${c.notes}
                                            </div>
                                            <c:if test="${not empty c.nextAppointment}">
                                                <div style="font-size: 0.8125rem; color: var(--primary); margin-top: 6px; display: flex; align-items: center; gap: 4px;">
                                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 14 14"/></svg>
                                                    <span>Lịch hẹn tiếp theo: ${c.nextAppointment.toLocalDate()} ${c.nextAppointment.toLocalTime().toString().substring(0, 5)}</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/WEB-INF/views/common/footer.jspf" %>
    </div>
</div>
</body>
</html>
