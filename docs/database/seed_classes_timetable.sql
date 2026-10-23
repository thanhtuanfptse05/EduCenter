-- ============================================================================
-- EduCenter - Script Nạp Dữ Liệu Mẫu Lớp Học & Thời Khóa Biểu (feat-class-timetable)
-- Mô tả: Thêm giáo viên, môn học, lớp học và các buổi học chi tiết
-- Tuần trọng tâm: Tháng 10 - Tháng 11 năm 2026 (Hiển thị đầy đủ trên Thời khóa biểu tuần)
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
PRINT N'--> Bắt đầu nạp dữ liệu mẫu Lớp học & Thời khóa biểu...';

-- ----------------------------------------------------------------------------
-- 1. Bổ sung Giáo viên mẫu (Cô Mai - Tiếng Anh, Thầy Tuấn - Vật Lý, Cô Lan - Ngữ Văn)
-- ----------------------------------------------------------------------------
-- Mật khẩu mặc định: 123456 ($2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe)
IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.mai@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, status, created_at, updated_at)
    VALUES ('teacher.mai@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'Cô Trần Phương Mai', '0912345678', 'ACTIVE', GETDATE(), GETDATE());
    
    INSERT INTO dbo.UserRoles (user_id, role_id)
    SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r WHERE u.email = 'teacher.mai@educenter.vn' AND r.code = 'TEACHER';

    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate)
    SELECT id, full_name, phone, email, N'Tiếng Anh THCS & Luyện thi Chuyên / Vào 10', N'Thạc sĩ Ngôn ngữ Anh - ĐH Quốc Gia Hà Nội', N'10 năm kinh nghiệm bồi dưỡng học sinh giỏi', 320000.00
    FROM dbo.Users WHERE email = 'teacher.mai@educenter.vn';
END

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.tuan@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, status, created_at, updated_at)
    VALUES ('teacher.tuan@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'Thầy Lê Anh Tuấn', '0987654321', 'ACTIVE', GETDATE(), GETDATE());
    
    INSERT INTO dbo.UserRoles (user_id, role_id)
    SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r WHERE u.email = 'teacher.tuan@educenter.vn' AND r.code = 'TEACHER';

    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate)
    SELECT id, full_name, phone, email, N'Vật Lý 10-12, Luyện đề thi Tốt nghiệp THPT', N'Cử nhân Sư phạm Vật lý - ĐH Sư Phạm Hà Nội', N'Chuyên gia phương pháp giải nhanh trắc nghiệm', 300000.00
    FROM dbo.Users WHERE email = 'teacher.tuan@educenter.vn';
END

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.lan@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, status, created_at, updated_at)
    VALUES ('teacher.lan@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'Cô Hoàng Bích Lan', '0934567890', 'ACTIVE', GETDATE(), GETDATE());
    
    INSERT INTO dbo.UserRoles (user_id, role_id)
    SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r WHERE u.email = 'teacher.lan@educenter.vn' AND r.code = 'TEACHER';

    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate)
    SELECT id, full_name, phone, email, N'Ngữ Văn THPT, Luyện kỹ năng viết Nghị luận', N'Thạc sĩ Văn học Việt Nam - ĐH Sư Phạm', N'Nhiều năm chấm thi tốt nghiệp THPT Quốc gia', 300000.00
    FROM dbo.Users WHERE email = 'teacher.lan@educenter.vn';
END
GO

-- ----------------------------------------------------------------------------
-- 2. Đảm bảo các Phòng học sẵn sàng
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE code = 'P101')
    INSERT INTO dbo.Rooms (code, name, capacity, status) VALUES ('P101', N'Phòng 101 (Tầng 1 - Máy chiếu, Điều hòa)', 20, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE code = 'P102')
    INSERT INTO dbo.Rooms (code, name, capacity, status) VALUES ('P102', N'Phòng 102 (Tầng 1 - Bảng từ, Điều hòa)', 15, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE code = 'P201')
    INSERT INTO dbo.Rooms (code, name, capacity, status) VALUES ('P201', N'Phòng 201 (Tầng 2 - Lớp VIP 1-1)', 6, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE code = 'P202')
    INSERT INTO dbo.Rooms (code, name, capacity, status) VALUES ('P202', N'Phòng 202 (Tầng 2 - Tiêu chuẩn 15 chỗ)', 15, 'AVAILABLE');
IF NOT EXISTS (SELECT 1 FROM dbo.Rooms WHERE code = 'LAB01')
    INSERT INTO dbo.Rooms (code, name, capacity, status) VALUES ('LAB01', N'Phòng Lab Máy Tính (Tầng 3)', 25, 'AVAILABLE');
GO

-- ----------------------------------------------------------------------------
-- 3. Bổ sung các Khóa học OPEN nếu chưa có
-- ----------------------------------------------------------------------------
-- Khóa Vật Lý 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'PHYS12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, status, description, is_featured)
    SELECT id, 'PHYS12-TN', N'Vật Lý 12 – Luyện Thi Tốt Nghiệp THPT Điểm 8+', 12, N'Tốt nghiệp THPT', 3800000.00, 10, 20, 15, 'OPEN', N'Tổng ôn toàn bộ kiến thức Vật lý 12 và phương pháp giải nhanh trắc nghiệm đồ thị.', 1
    FROM dbo.Subjects WHERE code = 'PHYS';
END

-- Khóa Ngữ Văn 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'LIT12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, status, description, is_featured)
    SELECT id, 'LIT12-TN', N'Ngữ Văn 12 – Chinh Phục Điểm 8+ Nghị Luận Văn Học', 12, N'Tốt nghiệp THPT', 3600000.00, 10, 20, 15, 'OPEN', N'Hệ thống dàn ý chi tiết các tác phẩm trọng tâm và rèn kỹ năng viết mở bài, kết bài sáng tạo.', 1
    FROM dbo.Subjects WHERE code = 'LIT';
END

-- Cập nhật tất cả khóa học mẫu sang trạng thái OPEN để sẵn sàng tạo lớp
UPDATE dbo.Courses SET status = 'OPEN' WHERE status != 'OPEN';
GO

-- ----------------------------------------------------------------------------
-- 4. Danh sách Lớp học chuẩn (dbo.Classes)
-- ----------------------------------------------------------------------------
-- Lớp 1: Toán 12 - Luyện thi T2-T4-T6 (Thầy Hùng - Phòng P101)
IF NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'MAT12-2026-01')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status, created_at, updated_at)
    SELECT c.id, t.id, r.id, 'MAT12-2026-01', N'Toán 12 – Luyện Đề Tốt Nghiệp (T2-T4-T6)', 15, '2026-10-19', '2026-12-31', 'ONGOING', GETDATE(), GETDATE()
    FROM dbo.Courses c, dbo.Teachers t, dbo.Rooms r
    WHERE c.code = 'TOAN12-TN' 
      AND t.email = 'teacher.hung@educenter.vn' 
      AND r.code = 'P101';
END

-- Lớp 2: Tiếng Anh 9 - Vào 10 (Cô Mai - Phòng P102)
IF NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'ENG9-2026-01')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status, created_at, updated_at)
    SELECT c.id, t.id, r.id, 'ENG9-2026-01', N'Tiếng Anh 9 – Chinh Phục Vào 10 (T3-T5-T7)', 12, '2026-10-20', '2026-12-30', 'ONGOING', GETDATE(), GETDATE()
    FROM dbo.Courses c, dbo.Teachers t, dbo.Rooms r
    WHERE c.code = 'ENG9-VAO10' 
      AND t.email = 'teacher.mai@educenter.vn' 
      AND r.code = 'P102';
END

-- Lớp 3: Vật Lý 12 - Chuyên đề (Thầy Tuấn - Phòng LAB01)
IF NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'PHYS12-2026-01')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status, created_at, updated_at)
    SELECT c.id, t.id, r.id, 'PHYS12-2026-01', N'Vật Lý 12 – Chuyên Đề Sóng & Điện Xoay Chiều (T7-CN)', 15, '2026-10-24', '2026-12-27', 'OPEN', GETDATE(), GETDATE()
    FROM dbo.Courses c, dbo.Teachers t, dbo.Rooms r
    WHERE c.code = 'PHYS12-TN' 
      AND t.email = 'teacher.tuan@educenter.vn' 
      AND r.code = 'LAB01';
END

-- Lớp 4: Ngữ Văn 12 - Nghị luận (Cô Lan - Phòng P202)
IF NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'LIT12-2026-01')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status, created_at, updated_at)
    SELECT c.id, t.id, r.id, 'LIT12-2026-01', N'Ngữ Văn 12 – Kỹ Năng Viết Nghị Luận Xã Hội (T3-T5)', 15, '2026-10-20', '2026-12-24', 'OPEN', GETDATE(), GETDATE()
    FROM dbo.Courses c, dbo.Teachers t, dbo.Rooms r
    WHERE c.code = 'LIT12-TN' 
      AND t.email = 'teacher.lan@educenter.vn' 
      AND r.code = 'P202';
END

-- Lớp 5: Toán 12 - Lớp VIP 1-1 (Thầy Hùng - Phòng P201)
IF NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'MAT12-VIP-01')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status, created_at, updated_at)
    SELECT c.id, t.id, r.id, 'MAT12-VIP-01', N'Toán 12 – Gia Sư Bổ Trợ VIP 1-1 (T7-CN)', 1, '2026-10-24', '2026-12-27', 'OPEN', GETDATE(), GETDATE()
    FROM dbo.Courses c, dbo.Teachers t, dbo.Rooms r
    WHERE c.code = 'TOAN12-TN' 
      AND t.email = 'teacher.hung@educenter.vn' 
      AND r.code = 'P201';
END
GO

-- ----------------------------------------------------------------------------
-- 5. Sinh các Buổi học chi tiết (dbo.ClassSessions)
-- Phủ tuần 19/10 - 25/10/2026 và 26/10 - 01/11/2026 và các tuần tháng 11
-- Đảm bảo không trùng phòng và không trùng giáo viên (BR05, BR06)
-- ----------------------------------------------------------------------------
DECLARE @clsMatId BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'MAT12-2026-01');
DECLARE @clsEngId BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'ENG9-2026-01');
DECLARE @clsPhysId BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'PHYS12-2026-01');
DECLARE @clsLitId BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'LIT12-2026-01');
DECLARE @clsVipId BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'MAT12-VIP-01');

DECLARE @tcHungId BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hung@educenter.vn');
DECLARE @tcMaiId BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.mai@educenter.vn');
DECLARE @tcTuanId BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.tuan@educenter.vn');
DECLARE @tcLanId BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.lan@educenter.vn');

DECLARE @rmP101Id BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P101');
DECLARE @rmP102Id BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P102');
DECLARE @rmP201Id BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P201');
DECLARE @rmP202Id BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P202');
DECLARE @rmLab01Id BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'LAB01');

-- Xóa dữ liệu sessions cũ nếu muốn nạp lại sạch sẽ
DELETE FROM dbo.ClassSessions WHERE class_id IN (@clsMatId, @clsEngId, @clsPhysId, @clsLitId, @clsVipId);

-- ============================================================================
-- TUẦN 1: Từ Thứ 2 (19/10/2026) đến Chủ Nhật (25/10/2026)
-- ============================================================================
-- Thứ 2 (19/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsMatId, @rmP101Id, @tcHungId, '2026-10-19', '18:00', '20:00', N'Buổi 1: Tổng ôn Hàm số và Khảo sát đồ thị', 'COMPLETED');

-- Thứ 3 (20/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsLitId, @rmP202Id, @tcLanId, '2026-10-20', '14:00', '16:00', N'Buổi 1: Kỹ năng mở bài và kết bài Nghị luận xã hội', 'COMPLETED'),
(@clsEngId, @rmP102Id, @tcMaiId, '2026-10-20', '18:00', '20:00', N'Buổi 1: Chuyên đề Các thì trong Tiếng Anh và Dấu hiệu nhận biết', 'COMPLETED');

-- Thứ 4 (21/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsMatId, @rmP101Id, @tcHungId, '2026-10-21', '18:00', '20:00', N'Buổi 2: Cực trị của hàm số và bài toán chứa tham số m', 'COMPLETED');

-- Thứ 5 (22/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsLitId, @rmP202Id, @tcLanId, '2026-10-22', '14:00', '16:00', N'Buổi 2: Phân tích các dẫn chứng tiêu biểu trong đề thi', 'COMPLETED'),
(@clsEngId, @rmP102Id, @tcMaiId, '2026-10-22', '18:00', '20:00', N'Buổi 2: Câu bị động và các dạng đặc biệt vào lớp 10', 'COMPLETED');

-- Thứ 6 (23/10/2026 - Hôm nay)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsMatId, @rmP101Id, @tcHungId, '2026-10-23', '18:00', '20:00', N'Buổi 3: Giá trị lớn nhất, giá trị nhỏ nhất của hàm số', 'SCHEDULED');

-- Thứ 7 (24/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsPhysId, @rmLab01Id, @tcTuanId, '2026-10-24', '08:00', '10:00', N'Buổi 1: Dao động điều hòa và các đại lượng đặc trưng', 'SCHEDULED'),
(@clsVipId,  @rmP201Id,  @tcHungId, '2026-10-24', '14:00', '16:00', N'Buổi VIP 1: Rèn phản xạ trắc nghiệm Toán 12 điểm 8+', 'SCHEDULED'),
(@clsEngId,  @rmP102Id,  @tcMaiId,  '2026-10-24', '18:00', '20:00', N'Buổi 3: Câu điều kiện loại 1, 2, 3 và Đảo ngữ', 'SCHEDULED');

-- Chủ Nhật (25/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsPhysId, @rmLab01Id, @tcTuanId, '2026-10-25', '08:00', '10:00', N'Buổi 2: Con lắc lò xo và bài toán năng lượng cơ học', 'SCHEDULED'),
(@clsVipId,  @rmP201Id,  @tcHungId, '2026-10-25', '14:00', '16:00', N'Buổi VIP 2: Giải đề thi thử trường Chuyên Sư Phạm', 'SCHEDULED');

-- ============================================================================
-- TUẦN 2: Từ Thứ 2 (26/10/2026) đến Chủ Nhật (01/11/2026)
-- ============================================================================
-- Thứ 2 (26/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsMatId, @rmP101Id, @tcHungId, '2026-10-26', '18:00', '20:00', N'Buổi 4: Đường tiệm cận của đồ thị hàm số', 'SCHEDULED');

-- Thứ 3 (27/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsLitId, @rmP202Id, @tcLanId, '2026-10-27', '14:00', '16:00', N'Buổi 3: Tác phẩm Vợ Nhặt - Bối cảnh và nhân vật Tràng', 'SCHEDULED'),
(@clsEngId, @rmP102Id, @tcMaiId, '2026-10-27', '18:00', '20:00', N'Buổi 4: Mệnh đề quan hệ và cách rút gọn mệnh đề', 'SCHEDULED');

-- Thứ 4 (28/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsMatId, @rmP101Id, @tcHungId, '2026-10-28', '18:00', '20:00', N'Buổi 5: Đồ thị hàm phân thức bậc nhất trên bậc nhất', 'SCHEDULED');

-- Thứ 5 (29/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsLitId, @rmP202Id, @tcLanId, '2026-10-29', '14:00', '16:00', N'Buổi 4: Vợ Nhặt - Nhân vật người vợ nhặt và bà cụ Tứ', 'SCHEDULED'),
(@clsEngId, @rmP102Id, @tcMaiId, '2026-10-29', '18:00', '20:00', N'Buổi 5: Giới từ, Cụm động từ (Phrasal verbs) hay gặp', 'SCHEDULED');

-- Thứ 6 (30/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsMatId, @rmP101Id, @tcHungId, '2026-10-30', '18:00', '20:00', N'Buổi 6: Khối đa diện và thể tích khối chóp, lăng trụ', 'SCHEDULED');

-- Thứ 7 (31/10/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsPhysId, @rmLab01Id, @tcTuanId, '2026-10-31', '08:00', '10:00', N'Buổi 3: Con lắc đơn và bài toán thay đổi chu kỳ', 'SCHEDULED'),
(@clsVipId,  @rmP201Id,  @tcHungId, '2026-10-31', '14:00', '16:00', N'Buổi VIP 3: Chuyên đề Hình không gian Oxyz', 'SCHEDULED'),
(@clsEngId,  @rmP102Id,  @tcMaiId,  '2026-10-31', '18:00', '20:00', N'Buổi 6: Luyện kỹ năng đọc hiểu và tìm lỗi sai trong câu', 'SCHEDULED');

-- Chủ Nhật (01/11/2026)
INSERT INTO dbo.ClassSessions (class_id, room_id, teacher_id, session_date, start_at, end_at, title, status)
VALUES 
(@clsPhysId, @rmLab01Id, @tcTuanId, '2026-11-01', '08:00', '10:00', N'Buổi 4: Dao động tắt dần và hiện tượng cộng hưởng cơ', 'SCHEDULED'),
(@clsVipId,  @rmP201Id,  @tcHungId, '2026-11-01', '14:00', '16:00', N'Buổi VIP 4: Kỹ thuật Casio giải nhanh bài toán thực tế', 'SCHEDULED');

PRINT N'--> Nạp thành công dữ liệu mẫu cho Lớp học & Buổi học thời khóa biểu!';
GO
