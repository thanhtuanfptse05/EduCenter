-- ============================================================================
-- EDUCENTER ERP - BƯỚC 04: KHỞI TẠO TÀI KHOẢN, GIÁO VIÊN, NHÂN VIÊN, HỌC VIÊN & PHỤ HUYNH
-- Mật khẩu mặc định cho toàn bộ tài khoản thử nghiệm: 123456
-- Chuỗi mã băm BCrypt: $2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

DECLARE @PassHash VARCHAR(255) = '$2a$10$xk08hfrg1KAofW7P60rvSe6NAuaWWU0yuwRDsoLMyZGjqyIZVk9Qe';

-- 1. Thêm danh sách Users hệ thống
MERGE dbo.Users AS target
USING (VALUES
    -- Quản trị viên
    ('admin@educenter.vn', @PassHash, N'Nguyễn Quản Trị', '0901234567', NULL, 'ACTIVE'),

    -- Nhân viên tư vấn & Học vụ
    ('staff@educenter.vn', @PassHash, N'Trần Thu Hà', '0912345678', NULL, 'ACTIVE'),
    ('staff.linh@educenter.vn', @PassHash, N'Phạm Mỹ Linh', '0918889999', NULL, 'ACTIVE'),
    ('staff.dung@educenter.vn', @PassHash, N'Vũ Tiến Dũng', '0917778888', NULL, 'ACTIVE'),

    -- Giáo viên & Gia sư
    ('teacher.hung@educenter.vn', @PassHash, N'ThS. Lê Mạnh Hùng', '0987654321', '/assets/images/teachers/teacher-hung.jpg', 'ACTIVE'),
    ('teacher.mai@educenter.vn', @PassHash, N'Cô Trần Phương Mai', '0981112233', '/assets/images/teachers/teacher-mai.jpg', 'ACTIVE'),
    ('teacher.tuan@educenter.vn', @PassHash, N'Thầy Lê Anh Tuấn', '0982223344', '/assets/images/teachers/teacher-tuan.jpg', 'ACTIVE'),
    ('teacher.lan@educenter.vn', @PassHash, N'TS. Hoàng Thị Lan', '0983334455', '/assets/images/teachers/teacher-lan.jpg', 'ACTIVE'),
    ('teacher.phuong@educenter.vn', @PassHash, N'ThS. Nguyễn Bích Phương', '0984445566', '/assets/images/teachers/teacher-phuong.jpg', 'ACTIVE'),

    -- Học viên
    ('student.nam@educenter.vn', @PassHash, N'Trần Hoàng Nam', '0933112233', NULL, 'ACTIVE'),
    ('student.mai@educenter.vn', @PassHash, N'Lê Thị Hoàng Mai', '0933223344', NULL, 'ACTIVE'),
    ('student.phong@educenter.vn', @PassHash, N'Nguyễn Hải Phong', '0933334455', NULL, 'ACTIVE'),
    ('student.anh@educenter.vn', @PassHash, N'Đỗ Quỳnh Anh', '0933445566', NULL, 'ACTIVE'),
    ('student.huy@educenter.vn', @PassHash, N'Vũ Đức Huy', '0933556677', NULL, 'ACTIVE'),
    ('student.trang@educenter.vn', @PassHash, N'Bùi Thu Trang', '0933667788', NULL, 'ACTIVE'),
    ('student.khoi@educenter.vn', @PassHash, N'Phan Minh Khôi', '0933778899', NULL, 'ACTIVE'),
    ('student.vy@educenter.vn', @PassHash, N'Hoàng Thảo Vy', '0933889900', NULL, 'ACTIVE'),
    ('student.bach@educenter.vn', @PassHash, N'Ngô Xuân Bách', '0934112233', NULL, 'ACTIVE'),
    ('student.ngan@educenter.vn', @PassHash, N'Trịnh Kim Ngân', '0934223344', NULL, 'ACTIVE'),
    ('student.minh@educenter.vn', @PassHash, N'Đặng Tuấn Minh', '0934334455', NULL, 'ACTIVE'),
    ('student.chau@educenter.vn', @PassHash, N'Lý Bảo Châu', '0934445566', NULL, 'ACTIVE'),
    ('student.kien@educenter.vn', @PassHash, N'Phạm Trung Kiên', '0934556677', NULL, 'ACTIVE'),
    ('student.ha@educenter.vn', @PassHash, N'Vũ Thanh Hà', '0934667788', NULL, 'ACTIVE'),
    ('student.long@educenter.vn', @PassHash, N'Nguyễn Hoàng Long', '0934778899', NULL, 'ACTIVE'),

    -- Phụ huynh
    ('parent.tuan@educenter.vn', @PassHash, N'Trần Quốc Tuấn', '0944556677', NULL, 'ACTIVE'),
    ('parent.lan@educenter.vn', @PassHash, N'Nguyễn Thị Mai Lan', '0944667788', NULL, 'ACTIVE'),
    ('parent.thanh@educenter.vn', @PassHash, N'Đỗ Đình Thành', '0944778899', NULL, 'ACTIVE'),
    ('parent.hoa@educenter.vn', @PassHash, N'Phạm Thanh Hoa', '0944889900', NULL, 'ACTIVE'),
    ('parent.dung@educenter.vn', @PassHash, N'Vũ Mạnh Dũng', '0945112233', NULL, 'ACTIVE'),
    ('parent.huong@educenter.vn', @PassHash, N'Bùi Thu Hương', '0945223344', NULL, 'ACTIVE'),
    ('parent.quang@educenter.vn', @PassHash, N'Phan Minh Quang', '0945334455', NULL, 'ACTIVE'),
    ('parent.phuong@educenter.vn', @PassHash, N'Hoàng Minh Phương', '0945445566', NULL, 'ACTIVE'),
    ('parent.ngoc@educenter.vn', @PassHash, N'Trịnh Bích Ngọc', '0945556677', NULL, 'ACTIVE'),
    ('parent.binh@educenter.vn', @PassHash, N'Đặng Văn Bình', '0945667788', NULL, 'ACTIVE')
) AS source (email, password_hash, full_name, phone, avatar_url, status)
ON target.email = source.email
WHEN MATCHED THEN
    UPDATE SET full_name = source.full_name, phone = source.phone, avatar_url = source.avatar_url, status = source.status, updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (email, password_hash, full_name, phone, avatar_url, status, created_at, updated_at)
    VALUES (source.email, source.password_hash, source.full_name, source.phone, source.avatar_url, source.status, GETDATE(), GETDATE());
GO

-- 2. Gán quyền RBAC (UserRoles)
DECLARE @AdminRole BIGINT = (SELECT id FROM dbo.Roles WHERE code = 'ADMIN');
DECLARE @StaffRole BIGINT = (SELECT id FROM dbo.Roles WHERE code = 'STAFF');
DECLARE @TeacherRole BIGINT = (SELECT id FROM dbo.Roles WHERE code = 'TEACHER');
DECLARE @StudentRole BIGINT = (SELECT id FROM dbo.Roles WHERE code = 'STUDENT');
DECLARE @ParentRole BIGINT = (SELECT id FROM dbo.Roles WHERE code = 'PARENT');

-- Gán Admin
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT id, @AdminRole FROM dbo.Users WHERE email = 'admin@educenter.vn'
AND NOT EXISTS (SELECT 1 FROM dbo.UserRoles WHERE user_id = dbo.Users.id AND role_id = @AdminRole);

-- Gán Staff
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT id, @StaffRole FROM dbo.Users WHERE email IN ('staff@educenter.vn', 'staff.linh@educenter.vn', 'staff.dung@educenter.vn')
AND NOT EXISTS (SELECT 1 FROM dbo.UserRoles WHERE user_id = dbo.Users.id AND role_id = @StaffRole);

-- Gán Teacher
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT id, @TeacherRole FROM dbo.Users WHERE email LIKE 'teacher.%'
AND NOT EXISTS (SELECT 1 FROM dbo.UserRoles WHERE user_id = dbo.Users.id AND role_id = @TeacherRole);

-- Gán Student
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT id, @StudentRole FROM dbo.Users WHERE email LIKE 'student.%'
AND NOT EXISTS (SELECT 1 FROM dbo.UserRoles WHERE user_id = dbo.Users.id AND role_id = @StudentRole);

-- Gán Parent
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT id, @ParentRole FROM dbo.Users WHERE email LIKE 'parent.%'
AND NOT EXISTS (SELECT 1 FROM dbo.UserRoles WHERE user_id = dbo.Users.id AND role_id = @ParentRole);
GO

-- 3. Khởi tạo hồ sơ Giáo viên (Teachers)
MERGE dbo.Teachers AS target
USING (
    SELECT 
        u.id AS user_id,
        u.full_name,
        u.phone,
        u.email,
        v.specialization,
        v.degree,
        v.bio,
        v.hourly_rate
    FROM (VALUES
        ('teacher.hung@educenter.vn', N'Toán THPT, Ôn thi Tốt nghiệp 8+ & ĐGNL ĐHQG', N'Thạc sĩ Toán học - ĐH Sư Phạm Hà Nội', N'12 năm kinh nghiệm luyện thi, tác giả nhiều chuyên đề toán trắc nghiệm đạt điểm cao.', 350000.00),
        ('teacher.mai@educenter.vn', N'Tiếng Anh THCS, Luyện thi Chuyên & IELTS Foundation', N'Thạc sĩ Ngôn ngữ Anh - ĐH Ngoại Ngữ ĐHQGHN', N'10 năm kinh nghiệm bồi dưỡng học sinh giỏi và đào tạo chứng chỉ quốc tế.', 320000.00),
        ('teacher.tuan@educenter.vn', N'Vật Lý 10-12, Kỹ thuật Giải nhanh Máy tính Casio', N'Cử nhân Sư phạm Vật lý - ĐH Sư Phạm Hà Nội', N'Chuyên gia phương pháp sơ đồ tư duy và kỹ thuật bấm máy tính đạt điểm 9+.', 300000.00),
        ('teacher.lan@educenter.vn', N'Hóa Học THPT, Chuyên đề Phân hóa Khối A & B', N'Tiến sĩ Hóa học - ĐH Khoa học Tự nhiên ĐHQGHN', N'15 năm nghiên cứu và giảng dạy, cố vấn học thuật cho nhiều thế hệ thủ khoa.', 400000.00),
        ('teacher.phuong@educenter.vn', N'Ngữ Văn THPT, Kỹ năng Nghị luận Văn học & Xã hội', N'Thạc sĩ Lý luận Văn học - ĐH Sư Phạm Hà Nội', N'Phương pháp truyền cảm hứng văn chương hiện đại, giúp học sinh đạt điểm 8.5+.', 300000.00)
    ) AS v (email, specialization, degree, bio, hourly_rate)
    JOIN dbo.Users u ON u.email = v.email
) AS source
ON target.user_id = source.user_id
WHEN MATCHED THEN
    UPDATE SET 
        full_name = source.full_name,
        phone = source.phone,
        email = source.email,
        specialization = source.specialization,
        degree = source.degree,
        bio = source.bio,
        hourly_rate = source.hourly_rate,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate, status, created_at, updated_at)
    VALUES (source.user_id, source.full_name, source.phone, source.email, source.specialization, source.degree, source.bio, source.hourly_rate, 'ACTIVE', GETDATE(), GETDATE());
GO

-- 4. Khởi tạo hồ sơ Học viên (Students)
MERGE dbo.Students AS target
USING (
    SELECT 
        u.id AS user_id,
        u.full_name,
        v.dob,
        v.gender,
        u.phone,
        u.email,
        v.school,
        v.grade_level,
        v.target_goal,
        v.status
    FROM (VALUES
        ('student.nam@educenter.vn', '2008-05-15', 'MALE', N'THPT Chu Văn An', 12, N'Đạt 8.5+ môn Toán và Tiếng Anh kỳ thi Tốt nghiệp THPT', 'STUDYING'),
        ('student.mai@educenter.vn', '2009-10-20', 'FEMALE', N'THPT Yên Hòa', 11, N'Bứt phá học bạ 9.0 và ôn thi ĐGNL ĐHQG Hà Nội', 'STUDYING'),
        ('student.phong@educenter.vn', '2008-03-12', 'MALE', N'THPT Chuyên Hà Nội - Amsterdam', 12, N'Đỗ nguyện vọng 1 Đại học Bách Khoa Hà Nội (Khối A00)', 'STUDYING'),
        ('student.anh@educenter.vn', '2010-08-25', 'FEMALE', N'THPT Kim Liên', 10, N'Xây dựng nền tảng Toán và Tiếng Anh vững chắc lớp 10', 'STUDYING'),
        ('student.huy@educenter.vn', '2008-11-04', 'MALE', N'THPT Thăng Long', 12, N'Đạt 27+ điểm khối D01 (Toán, Văn, Anh)', 'STUDYING'),
        ('student.trang@educenter.vn', '2009-02-18', 'FEMALE', N'THPT Việt Đức', 11, N'Đạt chứng chỉ IELTS 6.5 và điểm trung bình môn Toán trên 8.5', 'STUDYING'),
        ('student.khoi@educenter.vn', '2011-09-30', 'MALE', N'THCS Giảng Võ', 9, N'Đỗ vào lớp 10 THPT Chu Văn An hoặc THPT Phan Đình Phùng', 'STUDYING'),
        ('student.vy@educenter.vn', '2008-07-14', 'FEMALE', N'THPT Cầu Giấy', 12, N'Đạt điểm 8+ môn Hóa và Sinh xét tuyển khối B00 Đại học Y Hà Nội', 'STUDYING'),
        ('student.bach@educenter.vn', '2010-12-05', 'MALE', N'THPT Lương Thế Vinh', 10, N'Củng cố phương pháp tự học và làm bài tập phân hóa', 'STUDYING'),
        ('student.ngan@educenter.vn', '2008-01-22', 'FEMALE', N'THPT Nhân Chính', 12, N'Xét tuyển sớm học bạ kết hợp chứng chỉ quốc tế', 'STUDYING'),
        ('student.minh@educenter.vn', '2009-06-19', 'MALE', N'THPT Marie Curie', 11, N'Bồi dưỡng học sinh giỏi môn Vật lý cấp trường', 'STUDYING'),
        ('student.chau@educenter.vn', '2012-04-10', 'FEMALE', N'THCS Cầu Giấy', 8, N'Xây dựng tư duy logic toán học từ THCS', 'STUDYING'),
        ('student.kien@educenter.vn', '2008-08-08', 'MALE', N'THPT Phan Đình Phùng', 12, N'Luyện đề tổng ôn THPT Quốc gia khối A01', 'STUDYING'),
        ('student.ha@educenter.vn', '2010-03-27', 'FEMALE', N'THPT Yên Hòa', 10, N'Nâng cao kỹ năng viết luận văn học và đọc hiểu Anh', 'STUDYING'),
        ('student.long@educenter.vn', '2013-11-15', 'MALE', N'THCS Nghĩa Tân', 7, N'Bổ trợ kiến thức môn Toán và Tiếng Anh cơ bản', 'STUDYING')
    ) AS v (email, dob, gender, school, grade_level, target_goal, status)
    JOIN dbo.Users u ON u.email = v.email
) AS source
ON target.user_id = source.user_id
WHEN MATCHED THEN
    UPDATE SET 
        full_name = source.full_name,
        dob = source.dob,
        gender = source.gender,
        phone = source.phone,
        email = source.email,
        school = source.school,
        grade_level = source.grade_level,
        target_goal = source.target_goal,
        status = source.status,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (user_id, full_name, dob, gender, phone, email, school, grade_level, target_goal, status, created_at, updated_at)
    VALUES (source.user_id, source.full_name, source.dob, source.gender, source.phone, source.email, source.school, source.grade_level, source.target_goal, source.status, GETDATE(), GETDATE());
GO

-- 5. Khởi tạo hồ sơ Phụ huynh (Guardians)
MERGE dbo.Guardians AS target
USING (
    SELECT 
        u.id AS user_id,
        u.full_name,
        u.phone,
        u.email,
        v.occupation,
        v.address
    FROM (VALUES
        ('parent.tuan@educenter.vn', N'Kỹ sư Phần mềm', N'Số 45 Hoàng Quốc Việt, Cầu Giấy, Hà Nội'),
        ('parent.lan@educenter.vn', N'Giảng viên Đại học', N'Số 12 Nguyễn Phong Sắc, Cầu Giấy, Hà Nội'),
        ('parent.thanh@educenter.vn', N'Bác sĩ chuyên khoa', N'Số 88 Trần Duy Hưng, Cầu Giấy, Hà Nội'),
        ('parent.hoa@educenter.vn', N'Kế toán trưởng', N'Số 102 Nguyễn Chí Thanh, Đống Đa, Hà Nội'),
        ('parent.dung@educenter.vn', N'Giám đốc doanh nghiệp', N'Số 15 Lê Văn Lương, Thanh Xuân, Hà Nội'),
        ('parent.huong@educenter.vn', N'Dược sĩ', N'Số 68 Kim Mã, Ba Đình, Hà Nội'),
        ('parent.quang@educenter.vn', N'Chuyên viên tài chính', N'Số 22 Liễu Giai, Ba Đình, Hà Nội'),
        ('parent.phuong@educenter.vn', N'Kiến trúc sư', N'Số 54 Xuân Thủy, Cầu Giấy, Hà Nội'),
        ('parent.ngoc@educenter.vn', N'Quản lý nhân sự', N'Số 77 Nguyễn Trãi, Thanh Xuân, Hà Nội'),
        ('parent.binh@educenter.vn', N'Luật sư', N'Số 39 Thái Hà, Đống Đa, Hà Nội')
    ) AS v (email, occupation, address)
    JOIN dbo.Users u ON u.email = v.email
) AS source
ON target.user_id = source.user_id
WHEN MATCHED THEN
    UPDATE SET 
        full_name = source.full_name,
        phone = source.phone,
        email = source.email,
        occupation = source.occupation,
        address = source.address,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (user_id, full_name, phone, email, occupation, address, status, created_at, updated_at)
    VALUES (source.user_id, source.full_name, source.phone, source.email, source.occupation, source.address, 'ACTIVE', GETDATE(), GETDATE());
GO

-- 6. Liên kết xác thực Giám hộ Phụ huynh - Học sinh (StudentGuardians)
DECLARE @AdminId BIGINT = (SELECT id FROM dbo.Users WHERE email = 'admin@educenter.vn');

MERGE dbo.StudentGuardians AS target
USING (
    SELECT 
        s.id AS student_id,
        g.id AS guardian_id,
        v.relationship,
        v.is_primary,
        GETDATE() AS verified_at,
        @AdminId AS verified_by,
        N'Đã xác minh qua sổ hộ khẩu và căn cước công dân' AS notes
    FROM (VALUES
        ('student.nam@educenter.vn', 'parent.tuan@educenter.vn', N'Bố', 1),
        ('student.mai@educenter.vn', 'parent.lan@educenter.vn', N'Mẹ', 1),
        ('student.phong@educenter.vn', 'parent.hoa@educenter.vn', N'Mẹ', 1),
        ('student.anh@educenter.vn', 'parent.thanh@educenter.vn', N'Bố', 1),
        ('student.huy@educenter.vn', 'parent.dung@educenter.vn', N'Bố', 1),
        ('student.trang@educenter.vn', 'parent.huong@educenter.vn', N'Mẹ', 1),
        ('student.khoi@educenter.vn', 'parent.quang@educenter.vn', N'Bố', 1),
        ('student.vy@educenter.vn', 'parent.phuong@educenter.vn', N'Bố', 1),
        ('student.ngan@educenter.vn', 'parent.ngoc@educenter.vn', N'Mẹ', 1),
        ('student.minh@educenter.vn', 'parent.binh@educenter.vn', N'Bố', 1)
    ) AS v (student_email, guardian_email, relationship, is_primary)
    JOIN dbo.Students s ON s.email = v.student_email
    JOIN dbo.Guardians g ON g.email = v.guardian_email
) AS source
ON target.student_id = source.student_id AND target.guardian_id = source.guardian_id
WHEN MATCHED THEN
    UPDATE SET relationship = source.relationship, is_primary = source.is_primary, verified_at = source.verified_at, verified_by = source.verified_by, notes = source.notes
WHEN NOT MATCHED THEN
    INSERT (student_id, guardian_id, relationship, is_primary, verified_at, verified_by, notes, created_at)
    VALUES (source.student_id, source.guardian_id, source.relationship, source.is_primary, source.verified_at, source.verified_by, source.notes, GETDATE());
GO

PRINT N'Hoàn thành Bước 04: Khởi tạo đầy đủ 30+ người dùng, 5 giáo viên, 3 nhân viên, 15 học viên và 10 phụ huynh xác thực!';
GO
