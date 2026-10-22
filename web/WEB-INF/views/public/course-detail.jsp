<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <c:set var="pageTitle" value="${detail.course.name} — EduCenter" />
    <%@ include file="/WEB-INF/views/common/head.jspf" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/course.css">
</head>
<body>
    <c:set var="activeNav" value="courses" scope="request" />
    <%@ include file="/WEB-INF/views/common/public-header.jspf" %>

    <main style="padding-top: 64px; min-height: calc(100vh - 200px);">
        <!-- Flash Alert Messages -->
        <div style="max-width: 1200px; margin: 16px auto 0; padding: 0 20px;">
            <%@ include file="/WEB-INF/views/common/alert.jsp" %>
        </div>

        <!-- Top Announcement Banner -->
        <div style="background: var(--surface-muted); border-bottom: 1px solid var(--border); padding: 8px 20px;">
            <div style="max-width: 1200px; margin: 0 auto; display: flex; align-items: center; justify-content: space-between; font-size: 13px; color: var(--text-muted);">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--warning);"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                    <span>Hạn chót ưu đãi giảm 10% học phí sớm cho đợt tuyển sinh mới. Đăng ký ngay để giữ chỗ!</span>
                </div>
                <div style="display: none; align-items: center; gap: 12px; font-weight: 600; font-size: 11px; letter-spacing: 0.05em;" class="md-show">
                    <span>MÃ KHÓA: <c:out value="${detail.course.code}" /></span>
                    <span>•</span>
                    <span>BẢN QUYỀN EDUCENTER ACADEMIC</span>
                </div>
            </div>
        </div>

        <div class="detail-container">
            <!-- Breadcrumbs -->
            <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                <a href="${pageContext.request.contextPath}/">
                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>
                    <span>Trang chủ</span>
                </a>
                <span style="color: var(--border);">/</span>
                <a href="${pageContext.request.contextPath}/courses">Danh mục khóa học</a>
                <span style="color: var(--border);">/</span>
                <span class="chip-btn" style="padding: 1px 8px; font-size: 11px;">Khối <c:out value="${detail.course.gradeLevel}" /></span>
                <span style="color: var(--border);">/</span>
                <span style="color: var(--text); font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 320px;">
                    <c:out value="${detail.course.name}" />
                </span>
            </nav>

            <!-- Hero Section Grid -->
            <div class="detail-hero-grid">
                <!-- Left Column (7 cols): Academic Information & Teacher -->
                <div class="detail-left">
                    <!-- Status Badges Strip -->
                    <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 8px;">
                        <span class="badge" style="background: var(--primary-subtle); color: var(--primary); font-weight: 600;">
                            <c:out value="${detail.course.subjectName}" />
                        </span>
                        <span class="badge" style="background: var(--surface-muted); color: var(--text-muted); font-weight: 600;">
                            Khối <c:out value="${detail.course.gradeLevel}" /> THPT
                        </span>
                        <span class="badge" style="background: var(--success-subtle); color: var(--success); font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
                            <span style="width: 6px; height: 6px; border-radius: 50%; background: var(--success); display: inline-block;"></span>
                            Đang mở tuyển sinh
                        </span>
                    </div>

                    <!-- Course Title & Description -->
                    <h1 class="detail-title"><c:out value="${detail.course.name}" /></h1>
                    <p class="detail-lead">
                        <c:out value="${detail.course.description != null ? detail.course.description : 'Chương trình ôn luyện chuyên sâu bám sát ma trận đề thi Bộ GD&ĐT 2026 và cấu trúc đề ĐGNL ĐHQG. Rèn luyện phương pháp giải nhanh trắc nghiệm và tư duy bài toán phân loại cao.'}" />
                    </p>

                    <!-- Bento Metadata Grid -->
                    <div class="bento-grid">
                        <div class="bento-item">
                            <div class="bento-icon">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </div>
                            <div>
                                <div class="bento-meta-title">Quy mô</div>
                                <div class="bento-meta-value"><c:out value="${detail.course.totalSessions}" /> buổi học</div>
                            </div>
                        </div>

                        <div class="bento-item">
                            <div class="bento-icon">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </div>
                            <div>
                                <div class="bento-meta-title">Thời lượng</div>
                                <div class="bento-meta-value">90 phút / buổi</div>
                            </div>
                        </div>

                        <div class="bento-item">
                            <div class="bento-icon">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                            </div>
                            <div>
                                <div class="bento-meta-title">Sĩ số giới hạn</div>
                                <div class="bento-meta-value">Tối đa <c:out value="${detail.course.maxCapacity}" /> HV/lớp</div>
                            </div>
                        </div>

                        <div class="bento-item">
                            <div class="bento-icon" style="color: var(--success);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                            </div>
                            <div>
                                <div class="bento-meta-title">Hình thức</div>
                                <div class="bento-meta-value">Trực tiếp tại cơ sở</div>
                            </div>
                        </div>

                        <div class="bento-item">
                            <div class="bento-icon">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M8 2v4"></path><path d="M16 2v4"></path><rect width="18" height="18" x="3" y="4" rx="2"></rect><path d="M3 10h18"></path></svg>
                            </div>
                            <div>
                                <div class="bento-meta-title">Khai giảng dự kiến</div>
                                <div class="bento-meta-value">Tháng 11/2026</div>
                            </div>
                        </div>

                        <div class="bento-item">
                            <div class="bento-icon" style="color: var(--warning);">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                            </div>
                            <div>
                                <div class="bento-meta-title">Chứng nhận</div>
                                <div class="bento-meta-value">Kiểm định chuẩn BGD</div>
                            </div>
                        </div>
                    </div>

                    <!-- Teacher Spotlight Card -->
                    <div class="teacher-spotlight-card">
                        <c:choose>
                            <c:when test="${not empty detail.primaryTeacher && not empty detail.primaryTeacher.photoUrl}">
                                <div class="teacher-avatar-circle" style="overflow: hidden; padding: 0;">
                                    <img src="<c:url value='${detail.primaryTeacher.photoUrl}' />" alt="<c:out value='${detail.primaryTeacher.fullName}' />" style="width: 100%; height: 100%; object-fit: cover;" />
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="teacher-avatar-circle">
                                    <c:out value="${detail.primaryTeacher != null && detail.primaryTeacher.fullName != null ? detail.primaryTeacher.fullName.substring(0, 1).toUpperCase() : 'G'}" />
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="teacher-meta-details">
                            <div class="teacher-name-row">
                                <h3 class="teacher-name-title">
                                    <c:out value="${detail.primaryTeacher != null ? detail.primaryTeacher.fullName : 'ThS. Trần Hoàng Nam'}" />
                                </h3>
                                <span class="teacher-role-tag">
                                    <c:out value="${detail.primaryTeacher != null && detail.primaryTeacher.degree != null ? detail.primaryTeacher.degree : 'Chủ nhiệm bộ môn'}" />
                                </span>
                            </div>
                            <p class="teacher-bio-text">
                                <c:out value="${detail.primaryTeacher != null && detail.primaryTeacher.bio != null ? detail.primaryTeacher.bio : 'Giảng viên giàu kinh nghiệm luyện thi điểm 9+, trực tiếp đào tạo hàng trăm học viên đỗ nguyện vọng 1 các trường Đại học Top đầu.'}" />
                            </p>
                            <div style="display: flex; align-items: center; gap: 16px; margin-top: 4px; font-size: 13px; color: var(--text-muted);">
                                <span style="display: inline-flex; align-items: center; gap: 4px; color: var(--warning); font-weight: 600;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    4.95/5.0 (Đánh giá học viên)
                                </span>
                                <span style="display: inline-flex; align-items: center; gap: 4px; color: var(--success); font-weight: 600;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                    1.200+ học sinh đỗ NV1
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (5 cols): Sticky Action Registration Card -->
                <div class="sticky-action-card">
                    <div class="action-card-header">
                        <c:choose>
                            <c:when test="${not empty detail.course.imageUrl}">
                                <img src="<c:url value='${detail.course.imageUrl}' />" alt="<c:out value='${detail.course.name}' />" />
                            </c:when>
                            <c:otherwise>
                                <div style="width: 100%; height: 100%; background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);"></div>
                            </c:otherwise>
                        </c:choose>
                        <div class="action-card-overlay">
                            <div style="display: flex; align-items: center; justify-content: space-between; width: 100%; color: #ffffff;">
                                <span style="font-size: 12px; font-weight: 700; background: rgba(0,0,0,0.5); padding: 3px 8px; border-radius: 4px;">
                                    Mã: <c:out value="${detail.course.code}" />
                                </span>
                                <span style="font-size: 12px; font-weight: 600; background: var(--success); padding: 3px 8px; border-radius: 4px; display: inline-flex; align-items: center; gap: 4px;">
                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                                    Tuyển sinh đợt mới
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="action-card-body">
                        <!-- Pricing Block -->
                        <div class="price-block">
                            <span style="font-size: 13px; color: var(--text-muted);">Học phí niêm yết trọn khóa (<c:out value="${detail.course.totalSessions}" /> buổi):</span>
                            <div style="display: flex; align-items: baseline; gap: 4px; margin-top: 2px;">
                                <span class="price-main-num">
                                    <fmt:formatNumber value="${detail.course.fee}" pattern="#,##0" />
                                    <span style="font-size: 16px; font-weight: 600;">VNĐ</span>
                                </span>
                                <c:if test="${detail.originalFee != null}">
                                    <span class="price-strikethrough">
                                        <fmt:formatNumber value="${detail.originalFee}" pattern="#,##0" /> VNĐ
                                    </span>
                                </c:if>
                            </div>
                            <span style="font-size: 12px; font-weight: 600; color: var(--warning);">
                                Tiết kiệm 10% khi kết hợp đăng ký combo từ 2 môn trở lên
                            </span>
                        </div>

                        <!-- Incentive Box -->
                        <div class="incentive-box">
                            <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true" style="color: var(--primary);"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                            <div>
                                <strong style="color: var(--primary); display: block; margin-bottom: 2px;">Ưu đãi học liệu độc quyền:</strong>
                                Tặng kèm ngân hàng 10.000 câu hỏi luyện thi có lời giải video chi tiết và bộ 15 đề thi thử dự đoán 2026.
                            </div>
                        </div>

                        <!-- Actions -->
                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <form action="${pageContext.request.contextPath}/registration-cart/add" method="POST" style="margin: 0;">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                <input type="hidden" name="courseId" value="${detail.course.id}" />
                                <button type="submit" class="btn btn-primary" style="width: 100%; height: 44px; font-size: 14px; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 8px;">
                                    <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
                                    <span>Thêm vào danh sách đăng ký</span>
                                </button>
                            </form>

                            <a href="${pageContext.request.contextPath}/courses" class="btn btn-secondary" style="width: 100%; height: 40px; display: flex; align-items: center; justify-content: center; gap: 6px; text-decoration: none;">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                                <span>Quay lại danh mục khóa học</span>
                            </a>
                        </div>

                        <!-- Guarantees -->
                        <div class="guarantee-list">
                            <span style="font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text);">
                                Cam kết chất lượng chuẩn EduCenter
                            </span>
                            <div class="guarantee-item">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <span>Sĩ số tối đa 15 bạn, kèm cặp sát sao từng học viên.</span>
                            </div>
                            <div class="guarantee-item">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <span>Báo cáo điểm danh và nhật ký bài tập gửi phụ huynh định kỳ.</span>
                            </div>
                            <div class="guarantee-item">
                                <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                                <span>Hỗ trợ học bù miễn phí bằng video bài giảng chất lượng cao.</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabs Section -->
            <div style="display: flex; flex-direction: column; gap: 24px; margin-top: 16px;">
                <div class="detail-tabs-bar">
                    <button type="button" class="tab-trigger-btn active" onclick="switchDetailTab('tab-objectives', this)">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"></path><line x1="4" y1="22" x2="4" y2="15"></line></svg>
                        <span>1. Mục tiêu &amp; Chuẩn đầu ra</span>
                    </button>
                    <button type="button" class="tab-trigger-btn" onclick="switchDetailTab('tab-curriculum', this)">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1-2.5-2.5Z"></path><path d="M6 6h10"></path><path d="M6 10h10"></path></svg>
                        <span>2. Lộ trình phân kỳ đào tạo</span>
                    </button>
                    <button type="button" class="tab-trigger-btn" onclick="switchDetailTab('tab-classes', this)">
                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                        <span>3. Danh sách lớp mở tuyển sinh (<c:out value="${detail.openClasses.size()}" />)</span>
                    </button>
                </div>

                <!-- Tab 1: Objectives -->
                <section id="tab-objectives" class="content-section-box">
                    <div>
                        <h2 class="section-head-title">Mục Tiêu Đào Tạo &amp; Chuẩn Đầu Ra Học Thuật</h2>
                        <p class="section-head-subtitle">Lộ trình được thiết kế chuẩn mực nhằm tối ưu hóa điểm số và nâng cao năng lực tư duy.</p>
                    </div>

                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px;">
                        <div class="summary-card" style="box-shadow: none;">
                            <div style="width: 36px; height: 36px; border-radius: 8px; background: var(--primary-subtle); color: var(--primary); display: flex; align-items: center; justify-content: center;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"></polyline><polyline points="17 6 23 6 23 12"></polyline></svg>
                            </div>
                            <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Mục tiêu Điểm số 8.5+ THPTQG</h3>
                            <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                                Đảm bảo học viên nắm vững toàn bộ kiến thức cốt lõi, sẵn sàng chinh phục các trường Đại học Top 1 (Bách Khoa, Kinh Tế Quốc Dân, Ngoại Thương, Y Dược).
                            </p>
                        </div>

                        <div class="summary-card" style="box-shadow: none;">
                            <div style="width: 36px; height: 36px; border-radius: 8px; background: var(--success-subtle); color: var(--success); display: flex; align-items: center; justify-content: center;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 14 10"></polyline></svg>
                            </div>
                            <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Tốc Độ &amp; Phản Xạ Trắc Nghiệm</h3>
                            <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                                Kỹ thuật phân tích đề thi kết hợp máy tính Casio giúp giải quyết nhanh các câu nhận biết, thông hiểu, dành trọn thời gian cho các câu vận dụng cao.
                            </p>
                        </div>

                        <div class="summary-card" style="box-shadow: none;">
                            <div style="width: 36px; height: 36px; border-radius: 8px; background: var(--warning-subtle); color: var(--warning); display: flex; align-items: center; justify-content: center;">
                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm1 14.5h-2v-2h2zm0-4.5h-2V7h2z"></path></svg>
                            </div>
                            <h3 style="font-size: 15px; font-weight: 700; color: var(--text); margin: 0;">Bứt Phá Vận Dụng Cao (VDC)</h3>
                            <p style="font-size: 13px; color: var(--text-muted); line-height: 1.5; margin: 0;">
                                Phương pháp tư duy bản chất giải quyết triệt để các bài toán phân loại từ 9.0 đến 10.0 điểm và đề tư duy định lượng ĐGNL ĐHQG.
                            </p>
                        </div>
                    </div>
                </section>

                <!-- Tab 2: Curriculum -->
                <section id="tab-curriculum" class="content-section-box" style="display: none;">
                    <div>
                        <h2 class="section-head-title">Lộ Trình Đào Tạo Phân Kỳ (<c:out value="${detail.course.totalSessions}" /> Buổi Học)</h2>
                        <p class="section-head-subtitle">Chương trình tinh gọn chia thành 3 giai đoạn mang tính chiến lược, kiểm tra định kỳ 4 tuần/lần.</p>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <div class="summary-card" style="box-shadow: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); padding-bottom: 10px;">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span class="badge" style="background: var(--primary); color: #fff;">G1</span>
                                    <strong style="color: var(--text); font-size: 15px;">Giai đoạn 1: Nền tảng chuyên đề cốt lõi &amp; Nhận diện bẫy đề</strong>
                                </div>
                                <span class="badge" style="background: var(--surface-muted); color: var(--text-muted);">8 Buổi Cơ bản &amp; Nâng cao</span>
                            </div>
                            <p style="font-size: 13px; color: var(--text-muted); line-height: 1.6; margin: 8px 0 0;">
                                Quét toàn bộ kiến thức trọng tâm theo cấu trúc ma trận của Bộ GD&amp;ĐT, rèn kỹ năng xử lý bài toán trong 45 giây đầu tiên.
                            </p>
                        </div>

                        <div class="summary-card" style="box-shadow: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); padding-bottom: 10px;">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span class="badge" style="background: var(--success); color: #fff;">G2</span>
                                    <strong style="color: var(--text); font-size: 15px;">Giai đoạn 2: Khắc phục điểm yếu &amp; Luyện kỹ thuật VDC</strong>
                                </div>
                                <span class="badge" style="background: var(--surface-muted); color: var(--text-muted);">8 Buổi Chuyên sâu</span>
                            </div>
                            <p style="font-size: 13px; color: var(--text-muted); line-height: 1.6; margin: 8px 0 0;">
                                Rèn luyện phương pháp dồn biến, đồ thị hàm hợp và hình học giải tích đa chiều để công phá các câu hỏi khó nhất trong đề thi.
                            </p>
                        </div>

                        <div class="summary-card" style="box-shadow: none;">
                            <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid var(--border); padding-bottom: 10px;">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span class="badge" style="background: var(--warning); color: #fff;">G3</span>
                                    <strong style="color: var(--text); font-size: 15px;">Giai đoạn 3: Thực chiến 15 đề chuẩn phòng thi &amp; Tổng duyệt</strong>
                                </div>
                                <span class="badge" style="background: var(--surface-muted); color: var(--text-muted);">8 Buổi Tổng lực</span>
                            </div>
                            <p style="font-size: 13px; color: var(--text-muted); line-height: 1.6; margin: 8px 0 0;">
                                Thi thử áp lực thời gian ma trận 2026, chấm chữa chi tiết từng lỗi sai và hướng dẫn chiến thuật phân bổ thời gian phòng thi.
                            </p>
                        </div>
                    </div>
                </section>

                <!-- Tab 3: Open Classes -->
                <section id="tab-classes" class="content-section-box" style="display: none;">
                    <div style="display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <h2 class="section-head-title">Danh Sách Lớp Học Đang Mở Tuyển Sinh</h2>
                            <p class="section-head-subtitle">Học viên chủ động chọn ca học phù hợp với lịch học chính khóa tại trường THPT.</p>
                        </div>
                        <span style="font-size: 13px; font-weight: 600; color: var(--success); display: inline-flex; align-items: center; gap: 4px;">
                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                            Cơ sở Ba Đình &amp; Cầu Giấy (Hà Nội)
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${not empty detail.openClasses}">
                            <div style="display: flex; flex-direction: column; gap: 12px;">
                                <c:forEach var="cl" items="${detail.openClasses}">
                                    <div class="open-class-card">
                                        <div class="class-card-left">
                                            <div class="class-icon-box">
                                                <svg class="icon icon-md" viewBox="0 0 24 24" aria-hidden="true"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
                                            </div>
                                            <div class="class-details">
                                                <div class="class-code-title">
                                                    <span>Lớp: <c:out value="${cl.code}" /></span>
                                                    <span class="badge" style="background: var(--primary-subtle); color: var(--primary); font-size: 11px;">
                                                        <c:out value="${cl.shiftName}" />
                                                    </span>
                                                </div>
                                                <div class="class-schedule-line">
                                                    <span>
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                                        <c:out value="${cl.scheduleText}" />
                                                    </span>
                                                    <span>•</span>
                                                    <span>
                                                        <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path></svg>
                                                        <c:out value="${cl.roomName}" />
                                                    </span>
                                                    <c:if test="${not empty cl.teacherName}">
                                                        <span>•</span>
                                                        <span>GV: <c:out value="${cl.teacherName}" /></span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="class-card-right">
                                            <div class="capacity-progress-box">
                                                <div class="capacity-num-text">
                                                    <c:out value="${cl.enrolledCount}" /> / <c:out value="${cl.capacity}" /> Học viên
                                                </div>
                                                <div class="capacity-bar-track">
                                                    <div class="capacity-bar-fill" style="width: ${cl.percentFilled}%;"></div>
                                                </div>
                                                <span style="font-size: 11px; font-weight: 600; color: var(--warning);">
                                                    Còn <c:out value="${cl.remainingSlots}" /> chỗ trống
                                                </span>
                                            </div>

                                            <form action="${pageContext.request.contextPath}/registration-cart/add" method="POST" style="margin: 0;">
                                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                                                <input type="hidden" name="courseId" value="${detail.course.id}" />
                                                <input type="hidden" name="notes" value="Đăng ký ưu tiên lớp ${cl.code} (${cl.scheduleText})" />
                                                <button type="submit" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 4px;">
                                                    <span>Chọn lớp này</span>
                                                    <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><polyline points="9 18 15 12 9 6"></polyline></svg>
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state-card" style="padding: 32px 16px;">
                                <p class="empty-state-desc">Hiện tại các lớp học đang trong quá trình sắp xếp lịch khai giảng mới. Bạn có thể thêm khóa học vào giỏ để nhận tư vấn lịch học phù hợp nhất.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>
            </div>

            <!-- Related Courses Suggestions -->
            <c:if test="${not empty detail.relatedCourses}">
                <div style="display: flex; flex-direction: column; gap: 16px; margin-top: 16px;">
                    <div style="display: flex; align-items: center; justify-content: space-between;">
                        <div>
                            <h2 class="section-head-title">Khóa Học Khối <c:out value="${detail.course.gradeLevel}" /> Được Đăng Ký Cùng Nhiều Nhất</h2>
                            <p class="section-head-subtitle">Xây dựng trọn bộ tổ hợp xét tuyển Đại học với chi phí tối ưu.</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/courses?gradeLevel=${detail.course.gradeLevel}" style="font-size: 13px; font-weight: 600; color: var(--primary);">
                            Xem thêm các khóa khác &rarr;
                        </a>
                    </div>

                    <div class="course-grid">
                        <c:forEach var="rc" items="${detail.relatedCourses}">
                            <article class="course-card">
                                <div class="course-card-body">
                                    <div class="course-card-topbar">
                                        <span class="course-code-tag"><c:out value="${rc.code}" /></span>
                                        <span class="badge-open">Đang mở</span>
                                    </div>

                                    <c:if test="${not empty rc.imageUrl}">
                                        <div class="course-card-thumb" style="height: 120px;">
                                            <img src="<c:url value='${rc.imageUrl}' />" alt="<c:out value='${rc.name}' />" class="course-card-img" />
                                            <span class="course-card-thumb-tag">
                                                <c:out value="${rc.subjectName}" /> • Khối <c:out value="${rc.gradeLevel}" />
                                            </span>
                                        </div>
                                    </c:if>

                                    <h4 class="course-card-title">
                                        <a href="${pageContext.request.contextPath}/courses/detail?id=${rc.id}" style="color: inherit; text-decoration: none;">
                                            <c:out value="${rc.name}" />
                                        </a>
                                    </h4>

                                    <p class="course-card-desc">
                                        <c:out value="${rc.description != null ? rc.description : 'Khóa học chất lượng cao, bám sát ma trận đề thi chuẩn.'}" />
                                    </p>

                                    <div class="course-card-specs">
                                        <div class="course-spec-item">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                            <span><c:out value="${rc.totalSessions}" /> buổi</span>
                                        </div>
                                        <div class="course-spec-item">
                                            <svg class="icon icon-sm" viewBox="0 0 24 24" aria-hidden="true"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                                            <span>Tối đa <c:out value="${rc.maxCapacity}" /> HV</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="course-card-footer">
                                    <div>
                                        <div class="course-card-fee-label">Học phí</div>
                                        <div class="course-card-fee-num">
                                            <fmt:formatNumber value="${rc.fee}" pattern="#,##0" /> VNĐ
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/courses/detail?id=${rc.id}" class="btn btn-primary btn-sm">
                                        <span>Chi tiết</span>
                                    </a>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/common/public-footer.jspf" %>

    <script>
    function switchDetailTab(tabId, btn) {
        document.querySelectorAll('.content-section-box').forEach(function(sec) {
            sec.style.display = 'none';
        });
        document.querySelectorAll('.tab-trigger-btn').forEach(function(b) {
            b.classList.remove('active');
        });
        var activeSec = document.getElementById(tabId);
        if (activeSec) {
            activeSec.style.display = 'flex';
        }
        if (btn) {
            btn.classList.add('active');
        }
    }
    </script>
</body>
</html>
