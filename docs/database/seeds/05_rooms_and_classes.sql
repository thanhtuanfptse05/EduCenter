-- ============================================================================
-- EDUCENTER ERP - BƯỚC 05: KHỞI TẠO DANH SÁCH PHÒNG HỌC & LỚP HỌC ĐANG MỞ
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

-- 1. Khởi tạo 7 phòng học tiêu chuẩn
MERGE dbo.Rooms AS target
USING (VALUES
    ('P101', N'Phòng 101 (Tầng 1 - Máy chiếu, Điều hòa hai chiều)', 20, 'AVAILABLE'),
    ('P102', N'Phòng 102 (Tầng 1 - Bảng từ chống lóa, Điều hòa)', 15, 'AVAILABLE'),
    ('P201', N'Phòng 201 (Tầng 2 - Lớp VIP nhóm nhỏ & Gia sư 1-1)', 10, 'AVAILABLE'),
    ('P202', N'Phòng 202 (Tầng 2 - Tiêu chuẩn 15 chỗ học tập tương tác)', 15, 'AVAILABLE'),
    ('P301', N'Phòng 301 (Tầng 3 - Phòng học chuyên đề Khoa học Tự nhiên)', 18, 'AVAILABLE'),
    ('P302', N'Phòng 302 (Tầng 3 - Phòng học chuyên sâu Hóa - Sinh)', 18, 'AVAILABLE'),
    ('LAB01', N'Phòng Lab Máy Tính (Tầng 3 - Thi thử ĐGNL trực tuyến)', 25, 'AVAILABLE')
) AS source (code, name, capacity, status)
ON target.code = source.code
WHEN MATCHED THEN
    UPDATE SET name = source.name, capacity = source.capacity, status = source.status
WHEN NOT MATCHED THEN
    INSERT (code, name, capacity, status, created_at)
    VALUES (source.code, source.name, source.capacity, source.status, GETDATE());
GO

-- 2. Khởi tạo 20 lớp học đang diễn ra (ONGOING) và đang mở tiếp nhận (OPEN)
DECLARE @TeacherHung BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherMai BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.mai@educenter.vn');
DECLARE @TeacherTuan BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.tuan@educenter.vn');
DECLARE @TeacherLan BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.lan@educenter.vn');
DECLARE @TeacherPhuong BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.phuong@educenter.vn');
DECLARE @TeacherHoang BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hoang@educenter.vn');
DECLARE @TeacherMaiAnh BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.maianh@educenter.vn');
DECLARE @TeacherNam BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.nam@educenter.vn');
DECLARE @TeacherNgoc BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.ngoc@educenter.vn');

DECLARE @CourseToan12TN BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'TOAN12-TN');
DECLARE @CourseToan11NC BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'TOAN11-NC');
DECLARE @CourseToan10CB BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'TOAN10-CB');
DECLARE @CourseToan9Vao10 BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'TOAN9-VAO10');
DECLARE @CourseToanDGNL BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'TOAN-DGNL');

DECLARE @CourseEng12TN BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'ENG12-TN');
DECLARE @CourseEng10CB BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'ENG10-CB');
DECLARE @CourseEng9Vao10 BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'ENG9-VAO10');
DECLARE @CourseEngIelts BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'ENG-IELTS');
DECLARE @CourseEngIelts7 BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'ENG-IELTS7');

DECLARE @CourseLy12TN BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'LY12-TN');
DECLARE @CourseLy11NC BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'LY11-NC');
DECLARE @CourseLy10CB BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'LY10-CB');

DECLARE @CourseHoa12TN BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'HOA12-TN');
DECLARE @CourseHoa11NC BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'HOA11-NC');
DECLARE @CourseHoa10CB BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'HOA10-CB');

DECLARE @CourseVan12TN BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'VAN12-TN');
DECLARE @CourseVan10CB BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'VAN10-CB');

DECLARE @CourseSinh12TN BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'SINH12-TN');
DECLARE @CourseSinh11NC BIGINT = (SELECT id FROM dbo.Courses WHERE code = 'SINH11-NC');

DECLARE @RoomP101 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P101');
DECLARE @RoomP102 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P102');
DECLARE @RoomP201 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P201');
DECLARE @RoomP202 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P202');
DECLARE @RoomP301 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P301');
DECLARE @RoomP302 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P302');
DECLARE @RoomLAB01 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'LAB01');

MERGE dbo.Classes AS target
USING (VALUES
    -- TOÁN (Thầy Hùng & Thầy Nam)
    (@CourseToan12TN, @TeacherHung, @RoomP101, 'L12-TOAN-01', N'Toán 12 – Ôn Thi Tốt Nghiệp Nhóm A00 (Thầy Hùng)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseToan12TN, @TeacherHung, @RoomP202, 'L12-TOAN-02', N'Toán 12 – Bứt Phá Điểm 9 Chuyên Sâu (Thầy Hùng)', 15, '2026-09-15', '2026-12-31', 'ONGOING'),
    (@CourseToanDGNL, @TeacherHung, @RoomLAB01, 'L12-DGNL-01', N'Toán Tư Duy & Định Lượng ĐGNL ĐHQG (Thầy Hùng)', 20, '2026-10-01', '2026-12-15', 'ONGOING'),
    (@CourseToan11NC, @TeacherHung, @RoomP102, 'L11-TOAN-01', N'Toán 11 – Lượng Giác & Hình Không Gian (Thầy Hùng)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseToan10CB, @TeacherNam, @RoomP102, 'L10-TOAN-01', N'Toán 10 – Đại Số & Hình Học GDPT 2018 (Thầy Nam)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseToan9Vao10, @TeacherNam, @RoomP202, 'L09-TOAN-01', N'Toán 9 – Chinh Phục Điểm 9+ Thi Vào Lớp 10 (Thầy Nam)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),

    -- TIẾNG ANH & IELTS (Cô Mai & Cô Mai Anh)
    (@CourseEng12TN, @TeacherMai, @RoomP101, 'L12-ENG-01', N'Tiếng Anh 12 – Luyện Thi Tốt Nghiệp THPT Điểm 9 (Cô Mai)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseEng9Vao10, @TeacherMai, @RoomP202, 'L09-ENG-01', N'Tiếng Anh 9 – Luyện Thi Vào Lớp 10 Chuyên (Cô Mai)', 12, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseEng10CB, @TeacherMai, @RoomP102, 'L10-ENG-01', N'Tiếng Anh 10 – Ngữ Pháp & Đọc Hiểu Học Thuật (Cô Mai)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseEngIelts, @TeacherMaiAnh, @RoomP201, 'L11-IELTS-01', N'IELTS Foundation & Academic Writing 6.5+ (Cô Mai Anh)', 10, '2026-10-01', '2026-12-31', 'ONGOING'),
    (@CourseEngIelts7, @TeacherMaiAnh, @RoomP201, 'L12-IELTS-02', N'IELTS Intensive 7.5+ Target Tuyển Thẳng (Cô Mai Anh)', 8, '2026-10-01', '2026-12-31', 'ONGOING'),

    -- VẬT LÝ (Thầy Tuấn)
    (@CourseLy12TN, @TeacherTuan, @RoomP301, 'L12-LY-01', N'Vật Lý 12 – Luyện Đề Thực Chiến & Kỹ Thuật Casio (Thầy Tuấn)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseLy11NC, @TeacherTuan, @RoomP301, 'L11-LY-01', N'Vật Lý 11 – Sóng Cơ & Dao Động Nâng Cao (Thầy Tuấn)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseLy10CB, @TeacherTuan, @RoomP301, 'L10-LY-01', N'Vật Lý 10 – Động Học & Năng Lượng GDPT 2018 (Thầy Tuấn)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),

    -- HÓA HỌC (Cô Lan)
    (@CourseHoa12TN, @TeacherLan, @RoomP302, 'L12-HOA-01', N'Hóa Học 12 – Luyện Đề Thi Tốt Nghiệp Điểm 9+ (Cô Lan)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseHoa11NC, @TeacherLan, @RoomP302, 'L11-HOA-01', N'Hóa Học 11 – Hóa Hữu Cơ & Bài Toán Phân Hóa (Cô Lan)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseHoa10CB, @TeacherLan, @RoomP302, 'L10-HOA-01', N'Hóa Học 10 – Cấu Tạo Nguyên Tử & Bảng Tuần Hoàn (Cô Lan)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),

    -- SINH HỌC (Thầy Hoàng)
    (@CourseSinh12TN, @TeacherHoang, @RoomP302, 'L12-SINH-01', N'Sinh Học 12 – Chuyên Đề Di Truyền & Sinh Thái Khối B (Thầy Hoàng)', 15, '2026-10-01', '2026-12-31', 'ONGOING'),
    (@CourseSinh11NC, @TeacherHoang, @RoomP302, 'L11-SINH-01', N'Sinh Học 11 – Trao Đổi Chất & Bồi Dưỡng Y Dược (Thầy Hoàng)', 15, '2026-10-01', '2026-12-31', 'OPEN'),

    -- NGỮ VĂN (Cô Phương & Cô Ngọc)
    (@CourseVan12TN, @TeacherPhuong, @RoomP101, 'L12-VAN-01', N'Ngữ Văn 12 – Chuyên Đề Tác Phẩm & Nghị Luận Điểm 8.5+ (Cô Phương)', 15, '2026-09-01', '2026-12-31', 'ONGOING'),
    (@CourseVan10CB, @TeacherNgoc, @RoomP102, 'L10-VAN-01', N'Ngữ Văn 10 – Kỹ Năng Đọc Hiểu & Nghị Luận Văn Học (Cô Ngọc)', 15, '2026-09-01', '2026-12-31', 'ONGOING')
) AS source (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status)
ON target.code = source.code
WHEN MATCHED THEN
    UPDATE SET 
        course_id = source.course_id,
        teacher_id = source.teacher_id,
        room_id = source.room_id,
        name = source.name,
        capacity = source.capacity,
        start_date = source.start_date,
        end_date = source.end_date,
        status = source.status,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (course_id, teacher_id, room_id, code, name, capacity, start_date, end_date, status, created_at, updated_at)
    VALUES (source.course_id, source.teacher_id, source.room_id, source.code, source.name, source.capacity, source.start_date, source.end_date, source.status, GETDATE(), GETDATE());
GO

PRINT N'Hoàn thành Bước 05: Khởi tạo 7 phòng học và 21 lớp học tiêu chuẩn đang vận hành!';
GO
