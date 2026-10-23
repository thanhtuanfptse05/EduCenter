-- ============================================================================
-- EDUCENTER MIGRATION 002: SEED DATA CHO CỔNG THÔNG TIN GIA SƯ THPT (LANDING PORTAL)
-- Cung cấp dữ liệu thực tế cho Giảng viên, Môn học, Khóa học và Lớp học mở
-- ============================================================================

USE EduCenterDB;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1. Thêm tài khoản Giảng viên nòng cốt THPT (Mật khẩu mặc định: 123456)
-- Hash BCrypt: $2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe
IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.nam@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, avatar_url, status)
    VALUES ('teacher.nam@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'ThS. Đặng Vũ Nam', '0912888999', '/assets/images/teachers/teacher-nam.jpg', 'ACTIVE');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.maianh@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, avatar_url, status)
    VALUES ('teacher.maianh@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'Cô Lê Mai Anh', '0934777888', '/assets/images/teachers/teacher-maianh.jpg', 'ACTIVE');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.ngoc@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, avatar_url, status)
    VALUES ('teacher.ngoc@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'TS. Hoàng Như Ngọc', '0988666555', '/assets/images/teachers/teacher-ngoc.jpg', 'ACTIVE');
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE email = 'teacher.hoang@educenter.vn')
BEGIN
    INSERT INTO dbo.Users (email, password_hash, full_name, phone, avatar_url, status)
    VALUES ('teacher.hoang@educenter.vn', '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe', N'ThS. Trần Huy Hoàng', '0977333222', '/assets/images/teachers/teacher-hoang.jpg', 'ACTIVE');
END;
GO

-- Gán vai trò TEACHER cho các giảng viên mới
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r
WHERE u.email IN ('teacher.nam@educenter.vn', 'teacher.maianh@educenter.vn', 'teacher.ngoc@educenter.vn', 'teacher.hoang@educenter.vn')
  AND r.code = 'TEACHER'
  AND NOT EXISTS (SELECT 1 FROM dbo.UserRoles ur WHERE ur.user_id = u.id AND ur.role_id = r.id);
GO

-- 2. Thêm hoặc cập nhật chi tiết Hồ sơ Giảng viên (`Teachers`)
IF NOT EXISTS (SELECT 1 FROM dbo.Teachers WHERE email = 'teacher.nam@educenter.vn')
BEGIN
    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate, status)
    SELECT id, full_name, phone, email,
           N'Tổ trưởng Chuyên môn Toán THPT • Lớp 10, 11, 12',
           N'Thạc sĩ ĐH Sư Phạm Hà Nội',
           N'10 năm kinh nghiệm. Chuyên gia luyện đề bứt phá điểm 8.0 - 9.5 Toán thi THPTQG và ĐGNL.',
           400000.00, 'ACTIVE'
    FROM dbo.Users WHERE email = 'teacher.nam@educenter.vn';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Teachers WHERE email = 'teacher.maianh@educenter.vn')
BEGIN
    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate, status)
    SELECT id, full_name, phone, email,
           N'Giảng viên Tiếng Anh THPT • Lớp 11, 12 & IELTS',
           N'Thạc sĩ TESOL • IELTS 8.5',
           N'8 năm kinh nghiệm giảng dạy tiếng Anh học thuật, chuyên bồi dưỡng học sinh thi Đại học khối D & A1.',
           380000.00, 'ACTIVE'
    FROM dbo.Users WHERE email = 'teacher.maianh@educenter.vn';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Teachers WHERE email = 'teacher.ngoc@educenter.vn')
BEGIN
    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate, status)
    SELECT id, full_name, phone, email,
           N'Giảng viên Ngữ Văn THPT • Lớp 10, 11, 12',
           N'Tiến sĩ Văn học',
           N'12 năm kinh nghiệm. Tác giả nhiều tài liệu chuyên đề nghị luận văn học và tư duy hành văn mạch lạc 8.5+.',
           420000.00, 'ACTIVE'
    FROM dbo.Users WHERE email = 'teacher.ngoc@educenter.vn';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Teachers WHERE email = 'teacher.hoang@educenter.vn')
BEGIN
    INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate, status)
    SELECT id, full_name, phone, email,
           N'Giáo viên Vật lý THPT • Lớp 10, 11, 12',
           N'Thạc sĩ Vật lý • Cựu GV THPT Chuyên HN-Amsterdam',
           N'9 năm kinh nghiệm. Chuyên bồi dưỡng học sinh thi ĐGNL ĐHQG và ĐH Bách Khoa.',
           390000.00, 'ACTIVE'
    FROM dbo.Users WHERE email = 'teacher.hoang@educenter.vn';
END;
GO

-- 3. Đảm bảo 6 Môn học chuẩn hoạt động
UPDATE dbo.Subjects SET status = 'ACTIVE' WHERE code IN ('MATH', 'PHYS', 'CHEM', 'ENG', 'LIT', 'BIO');
GO

-- 4. Bổ sung danh sách Khóa học chuẩn Lớp 10, 11, 12
-- Toán 10
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'TOAN10-CB')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'TOAN10-CB', N'Toán 10 – Củng cố & Nâng cao Nền tảng Đại số - Hình học', 10, N'Học kỳ & Đánh giá năng lực', 3200000.00, 12, 24, 12,
           N'Xây dựng nền tảng vững chắc chương trình GDPT mới, củng cố Đại số và Hình học không gian.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'MATH';
END;

-- Tiếng Anh 11
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'ANH11-CB')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'ANH11-CB', N'Tiếng Anh 11 – Bứt phá Ngữ pháp Chuyên sâu & Kỹ năng Đọc hiểu', 11, N'Học kỳ & IELTS 6.5+', 3500000.00, 10, 20, 10,
           N'Gia sư 1 kèm 1 và nhóm nhỏ bứt phá ngữ pháp chuyên sâu, giải bẫy đề thi và kỹ năng bài luận.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'ENG';
END;

-- Toán 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'TOAN12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'TOAN12-TN', N'Toán 12 – Ôn Thi Tốt Nghiệp THPT & Đánh Giá Năng Lực Khối A-B', 12, N'Tốt nghiệp THPT & ĐGNL', 3600000.00, 12, 24, 15,
           N'Tổng ôn toàn bộ kiến thức trọng tâm, rèn luyện kỹ năng phân bổ thời gian thực chiến phòng thi và tối ưu hóa tổ hợp xét tuyển đại học tốp đầu.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'MATH';
END
ELSE
BEGIN
    UPDATE dbo.Courses
    SET name = N'Toán 12 – Ôn Thi Tốt Nghiệp THPT & Đánh Giá Năng Lực Khối A-B',
        fee = 3600000.00,
        is_featured = 1,
        status = 'OPEN'
    WHERE code = 'TOAN12-TN';
END;

-- Vật Lý 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'LY12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'LY12-TN', N'Vật Lý 12 – Tổng Ôn Chuyên Đề & Luyện Bộ Đề Chuẩn Cấu Trúc', 12, N'Tốt nghiệp THPT Khối A', 3200000.00, 12, 24, 15,
           N'Tổng ôn chuyên đề Dao động, Sóng, Điện xoay chiều, Hạt nhân và bộ 30 đề thi thử chuẩn cấu trúc đề Bộ GD&ĐT.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'PHYS';
END;

-- Hóa Học 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'HOA12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'HOA12-TN', N'Hóa Học 12 – Luyện Thi Tốt Nghiệp & Bứt Phá Điểm 8+ Khối A-B', 12, N'Tốt nghiệp THPT Khối B & A', 3200000.00, 12, 24, 15,
           N'Cấu tạo chất, Nhiệt hóa học, Hóa vô cơ & Hữu cơ chuyên sâu chuẩn đề thi TN THPT.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'CHEM';
END;

-- Ngữ Văn 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'VAN12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'VAN12-TN', N'Ngữ Văn 12 – Chinh Phục Điểm 8.5+ Nghị Luận Văn Học & Xã Hội', 12, N'Tốt nghiệp THPT Khối D & C', 3000000.00, 10, 20, 15,
           N'Kỹ năng đọc hiểu văn bản hiện đại, lập dàn ý Nghị luận xã hội & Nghị luận văn học đạt chuẩn thang điểm 8.0+.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'LIT';
END;

-- Sinh Học 12
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'SINH12-TN')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'SINH12-TN', N'Sinh Học 12 – Luyện Đề Tốt Nghiệp Khối B Y Dược', 12, N'Tốt nghiệp THPT Khối B', 3200000.00, 12, 24, 15,
           N'Di truyền học phân tử, Quần thể & Sinh thái học phục vụ tổ hợp xét tuyển Y Dược Khối B.', 1, 'OPEN'
    FROM dbo.Subjects WHERE code = 'BIO';
END;

-- Các khóa bồi dưỡng Lớp 10 & 11 bổ sung
IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'TOAN11-CB')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'TOAN11-CB', N'Toán 11 – Bứt Phá Năng Lực Lượng Giác & Hình Học Không Gian', 11, N'Học kỳ & Nền tảng 12', 3200000.00, 12, 24, 15,
           N'Nâng cao kiến thức và kỹ năng giải bài tập chuyên sâu, lấp đầy mọi lỗ hổng kiến thức phân hóa.', 0, 'OPEN'
    FROM dbo.Subjects WHERE code = 'MATH';
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Courses WHERE code = 'LY11-CB')
BEGIN
    INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, is_featured, status)
    SELECT id, 'LY11-CB', N'Vật Lý 11 – Điện Tích, Điện Trường & Quang Hình Học', 11, N'Học kỳ', 3000000.00, 12, 24, 15,
           N'Cơ học nâng cao và điện từ học lớp 11 bám sát chương trình GDPT mới.', 0, 'OPEN'
    FROM dbo.Subjects WHERE code = 'PHYS';
END;
GO

-- 5. Tạo các Lớp học đang mở (`dbo.Classes`) liên kết Khóa học & Giáo viên
DECLARE @RoomId BIGINT = (SELECT TOP 1 id FROM dbo.Rooms WHERE status = 'AVAILABLE');
DECLARE @TeacherNam BIGINT = (SELECT TOP 1 id FROM dbo.Teachers WHERE email = 'teacher.nam@educenter.vn');
DECLARE @TeacherMaianh BIGINT = (SELECT TOP 1 id FROM dbo.Teachers WHERE email = 'teacher.maianh@educenter.vn');
DECLARE @TeacherHoang BIGINT = (SELECT TOP 1 id FROM dbo.Teachers WHERE email = 'teacher.hoang@educenter.vn');
DECLARE @TeacherNgoc BIGINT = (SELECT TOP 1 id FROM dbo.Teachers WHERE email = 'teacher.ngoc@educenter.vn');

-- Lớp Toán 10 (Thứ 3 & Thứ 6 18:00 - 19:30)
DECLARE @CourseToan10 BIGINT = (SELECT TOP 1 id FROM dbo.Courses WHERE code = 'TOAN10-CB');
IF @CourseToan10 IS NOT NULL AND @TeacherNam IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'CLS-TOAN10-A1')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, start_date, end_date, capacity, status)
    VALUES (@CourseToan10, @TeacherNam, @RoomId, 'CLS-TOAN10-A1', N'Lớp Toán 10 Nền Tảng K10A1 (Thứ 3 & 6)', '2026-11-01', '2027-01-30', 12, 'OPEN');
END;

-- Lớp Tiếng Anh 11 (Kèm 1-1 / Nhóm nhỏ)
DECLARE @CourseAnh11 BIGINT = (SELECT TOP 1 id FROM dbo.Courses WHERE code = 'ANH11-CB');
IF @CourseAnh11 IS NOT NULL AND @TeacherMaianh IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'CLS-ANH11-B1')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, start_date, end_date, capacity, status)
    VALUES (@CourseAnh11, @TeacherMaianh, @RoomId, 'CLS-ANH11-B1', N'Lớp Tiếng Anh 11 Chuyên Sâu K11B1', '2026-11-05', '2027-01-20', 10, 'OPEN');
END;

-- Lớp Toán 12 (Thứ 4 & CN 19:30 - 21:00)
DECLARE @CourseToan12 BIGINT = (SELECT TOP 1 id FROM dbo.Courses WHERE code = 'TOAN12-TN');
IF @CourseToan12 IS NOT NULL AND @TeacherNam IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'CLS-TOAN12-VIP')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, start_date, end_date, capacity, status)
    VALUES (@CourseToan12, @TeacherNam, @RoomId, 'CLS-TOAN12-VIP', N'Lớp Toán 12 Luyện Thi THPTQG Mục Tiêu 9+ (Thứ 4 & CN)', '2026-11-02', '2027-02-15', 15, 'OPEN');
END;

-- Lớp Vật Lý 12 (Thứ 2 & Thứ 5 18:00 - 19:30)
DECLARE @CourseLy12 BIGINT = (SELECT TOP 1 id FROM dbo.Courses WHERE code = 'LY12-TN');
IF @CourseLy12 IS NOT NULL AND @TeacherHoang IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'CLS-LY12-A1')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, start_date, end_date, capacity, status)
    VALUES (@CourseLy12, @TeacherHoang, @RoomId, 'CLS-LY12-A1', N'Lớp Vật Lý 12 Tổng Ôn & Giải Đề Thực Chiến (Thứ 2 & 5)', '2026-11-03', '2027-02-10', 15, 'OPEN');
END;

-- Lớp Ngữ Văn 12
DECLARE @CourseVan12 BIGINT = (SELECT TOP 1 id FROM dbo.Courses WHERE code = 'VAN12-TN');
IF @CourseVan12 IS NOT NULL AND @TeacherNgoc IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Classes WHERE code = 'CLS-VAN12-C1')
BEGIN
    INSERT INTO dbo.Classes (course_id, teacher_id, room_id, code, name, start_date, end_date, capacity, status)
    VALUES (@CourseVan12, @TeacherNgoc, @RoomId, 'CLS-VAN12-C1', N'Lớp Ngữ Văn 12 Chuyên Sâu Điểm 8.5+ K12C1', '2026-11-04', '2027-01-25', 15, 'OPEN');
END;
GO

PRINT N'Hoàn tất nạp dữ liệu Seed Cổng thông tin THPT EduCenter (Migration 002) thành công!';
GO
