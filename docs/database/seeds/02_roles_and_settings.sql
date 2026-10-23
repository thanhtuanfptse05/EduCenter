-- ============================================================================
-- EDUCENTER ERP - BƯỚC 02: KHỞI TẠO VAI TRÒ HỆ THỐNG & CẤU HÌNH TRUNG TÂM
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

-- 1. Khởi tạo 5 vai trò hệ thống chuẩn (RBAC)
IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE code = 'ADMIN')
    INSERT INTO dbo.Roles (code, name, description) VALUES
    ('ADMIN', N'Quản trị viên & Giám đốc trung tâm', N'Toàn quyền quản trị hệ thống, tài khoản, cấu hình tham số, duyệt mở lại điểm và xem báo cáo tài chính');

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE code = 'STAFF')
    INSERT INTO dbo.Roles (code, name, description) VALUES
    ('STAFF', N'Nhân viên tư vấn tuyển sinh & Học vụ', N'Quản lý phễu CRM Leads, tiếp nhận tư vấn, xếp lớp, ghi danh và lập phiếu thu học phí');

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE code = 'TEACHER')
    INSERT INTO dbo.Roles (code, name, description) VALUES
    ('TEACHER', N'Giáo viên / Gia sư giảng dạy', N'Giảng dạy các lớp được phân công, điểm danh buổi học, ghi sổ đầu bài, tạo bài kiểm tra và chấm điểm');

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE code = 'STUDENT')
    INSERT INTO dbo.Roles (code, name, description) VALUES
    ('STUDENT', N'Học viên theo học', N'Truy cập cổng cá nhân tra cứu thời khóa biểu, lịch học, kết quả học tập và nhật ký buổi học');

IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE code = 'PARENT')
    INSERT INTO dbo.Roles (code, name, description) VALUES
    ('PARENT', N'Phụ huynh học sinh', N'Truy cập cổng giám sát theo dõi chuyên cần, bảng điểm định kỳ và hóa đơn học phí của con');
GO

-- 2. Cấu hình tham số hệ thống toàn diện (SystemSettings)
MERGE dbo.SystemSettings AS target
USING (VALUES
    ('CENTER_NAME', N'EduCenter - Trung Tâm Bồi Dưỡng Văn Hóa & Luyện Thi THPT', N'Tên thương hiệu chính thức hiển thị trên giao diện và hóa đơn'),
    ('CENTER_HOTLINE', '1900 6886', N'Đường dây nóng tuyển sinh và hỗ trợ kỹ thuật'),
    ('CENTER_EMAIL', 'hotro@educenter.vn', N'Thư điện tử hỗ trợ học vụ và tiếp nhận phản hồi'),
    ('CENTER_ADDRESS', N'Khu Công nghệ cao Hòa Lạc / Cầu Giấy, Hà Nội & Thủ Đức, TP.HCM', N'Địa chỉ các cơ sở đào tạo chính thức'),
    ('SYSTEM_ADMISSIONS_OPEN', 'true', N'Cờ bật/tắt tiếp nhận tuyển sinh và đăng ký tư vấn mới (true/false)'),
    ('TUITION_DUE_DAYS', '10', N'Số ngày đến hạn thanh toán học phí kể từ khi xuất hóa đơn'),
    ('MAX_CLASS_CAPACITY_DEFAULT', '15', N'Sĩ số tối đa mặc định cho các lớp học theo nhóm'),
    ('ATTENDANCE_LATE_THRESHOLD_MINUTES', '15', N'Số phút muộn tối đa trước khi ghi nhận trạng thái LATE'),
    ('REFUND_GRACE_PERIOD_DAYS', '14', N'Thời hạn cho phép hoàn phí sau khai giảng')
) AS source (setting_key, setting_value, description)
ON target.setting_key = source.setting_key
WHEN MATCHED THEN
    UPDATE SET setting_value = source.setting_value, description = source.description, updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (setting_key, setting_value, description, updated_at)
    VALUES (source.setting_key, source.setting_value, source.description, GETDATE());
GO

PRINT N'Hoàn thành Bước 02: Khởi tạo 5 vai trò và các tham số cấu hình hệ thống!';
GO
