-- ============================================================================
-- EDUCENTER MIGRATION 003: CẬP NHẬT ĐƯỜNG DẪN ẢNH CỤC BỘ CHO KHÓA HỌC & GIẢNG VIÊN
-- Lưu trữ nội bộ trong web/assets/images/
-- ============================================================================

USE EduCenterDB;
GO

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1. Cập nhật ảnh đại diện giảng viên trong bảng Users
UPDATE dbo.Users
SET avatar_url = '/assets/images/teachers/teacher-nam.jpg'
WHERE email = 'teacher.nam@educenter.vn';

UPDATE dbo.Users
SET avatar_url = '/assets/images/teachers/teacher-hung.jpg'
WHERE email = 'teacher.hung@educenter.vn';

UPDATE dbo.Users
SET avatar_url = '/assets/images/teachers/teacher-maianh.jpg'
WHERE email = 'teacher.maianh@educenter.vn';

UPDATE dbo.Users
SET avatar_url = '/assets/images/teachers/teacher-ngoc.jpg'
WHERE email = 'teacher.ngoc@educenter.vn';

UPDATE dbo.Users
SET avatar_url = '/assets/images/teachers/teacher-hoang.jpg'
WHERE email = 'teacher.hoang@educenter.vn';
GO

-- 2. Cập nhật ảnh thumbnail khóa học trong bảng Courses
-- Toán
UPDATE dbo.Courses
SET image_url = '/assets/images/courses/math.jpg'
WHERE code IN ('TOAN10-CB', 'TOAN11-CB', 'TOAN12-TN');

-- Vật lý
UPDATE dbo.Courses
SET image_url = '/assets/images/courses/physics.jpg'
WHERE code IN ('LY11-CB', 'LY12-TN');

-- Hóa học
UPDATE dbo.Courses
SET image_url = '/assets/images/courses/chemistry.jpg'
WHERE code = 'HOA12-TN';

-- Ngữ văn
UPDATE dbo.Courses
SET image_url = '/assets/images/courses/literature.jpg'
WHERE code = 'VAN12-TN';

-- Tiếng Anh
UPDATE dbo.Courses
SET image_url = '/assets/images/courses/english.jpg'
WHERE code IN ('ENG9-VAO10', 'ANH11-CB');

-- Sinh học
UPDATE dbo.Courses
SET image_url = '/assets/images/courses/biology.jpg'
WHERE code = 'SINH12-TN';
GO

PRINT N'Cập nhật thành công toàn bộ đường dẫn ảnh cục bộ cho Khóa học và Giảng viên trong EduCenterDB!';
GO
