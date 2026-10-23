-- ============================================================================
-- EDUCENTER ERP - BƯỚC 03: KHỞI TẠO MÔN HỌC & DANH MỤC KHÓA HỌC CHUẨN
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

-- 1. Khởi tạo 6 môn học cốt lõi
MERGE dbo.Subjects AS target
USING (VALUES
    ('MATH', N'Toán học', N'Bổ trợ kiến thức, rèn luyện tư duy logic và luyện thi Toán từ lớp 6 đến lớp 12', 'ACTIVE'),
    ('LIT', N'Ngữ văn', N'Kỹ năng đọc hiểu văn bản, nghị luận xã hội và nghị luận văn học theo chuẩn GDPT 2018', 'ACTIVE'),
    ('ENG', N'Tiếng Anh', N'Ngữ pháp chuyên sâu, từ vựng học thuật, luyện thi vào 10, tốt nghiệp và chứng chỉ quốc tế', 'ACTIVE'),
    ('PHYS', N'Vật lý', N'Hệ thống hóa hiện tượng vật lý, công thức trọng tâm và kỹ thuật giải nhanh bài tập trắc nghiệm', 'ACTIVE'),
    ('CHEM', N'Hóa học', N'Hóa học đại cương, hóa vô cơ - hữu cơ và các phương pháp giải toán hóa hiện đại', 'ACTIVE'),
    ('BIO', N'Sinh học', N'Chuyên đề Di truyền học, Tiến hóa và Sinh thái học phục vụ xét tuyển đại học khối B', 'ACTIVE')
) AS source (code, name, description, status)
ON target.code = source.code
WHEN MATCHED THEN
    UPDATE SET name = source.name, description = source.description, status = source.status
WHEN NOT MATCHED THEN
    INSERT (code, name, description, status, created_at)
    VALUES (source.code, source.name, source.description, source.status, GETDATE());
GO

-- 2. Khởi tạo danh mục khóa học chuẩn từ lớp 9 đến lớp 12 & Luyện thi ĐGNL
DECLARE @MathId BIGINT = (SELECT id FROM dbo.Subjects WHERE code = 'MATH');
DECLARE @LitId BIGINT = (SELECT id FROM dbo.Subjects WHERE code = 'LIT');
DECLARE @EngId BIGINT = (SELECT id FROM dbo.Subjects WHERE code = 'ENG');
DECLARE @PhysId BIGINT = (SELECT id FROM dbo.Subjects WHERE code = 'PHYS');
DECLARE @ChemId BIGINT = (SELECT id FROM dbo.Subjects WHERE code = 'CHEM');
DECLARE @BioId BIGINT = (SELECT id FROM dbo.Subjects WHERE code = 'BIO');

MERGE dbo.Courses AS target
USING (VALUES
    -- TOÁN HỌC
    (@MathId, 'TOAN10-CB', N'Toán 10 – Đại số & Hình học Cơ bản GDPT 2018', 10, N'Học kỳ & Bổ trợ', 3600000.00, 12, 24, 15, N'Khóa học củng cố nền tảng đại số tập hợp, hàm số bậc hai và véc-tơ chuyển cấp cho học sinh vào 10.', '/assets/images/courses/math.jpg', 1, 'OPEN'),
    (@MathId, 'TOAN11-NC', N'Toán 11 – Lượng giác & Hình học Không gian Chuyên sâu', 11, N'Nâng cao & Học bạ', 4200000.00, 14, 28, 15, N'Chuyên sâu các dạng toán góc, khoảng cách không gian cổ điển và đạo hàm phục vụ bứt phá điểm số.', '/assets/images/courses/math.jpg', 1, 'OPEN'),
    (@MathId, 'TOAN12-TN', N'Toán 12 – Luyện Thi Tốt Nghiệp THPT Điểm 8+', 12, N'Tốt nghiệp THPT', 4800000.00, 16, 32, 15, N'Khóa học mũi nhọn tổng ôn toàn diện kiến thức 3 năm THPT, rèn phản xạ chống sai ngớ ngẩn và bẫy đề thi.', '/assets/images/courses/math.jpg', 1, 'OPEN'),
    (@MathId, 'TOAN-DGNL', N'Toán Tư Duy & Định Lượng Đánh Giá Năng Lực ĐHQG', 12, N'ĐGNL ĐHQG / ĐGTD Bách Khoa', 3800000.00, 10, 20, 15, N'Tập trung xử lý các câu hỏi tư duy logic, phân tích số liệu bảng biểu và suy luận toán học thực tế.', '/assets/images/courses/math.jpg', 1, 'OPEN'),

    -- TIẾNG ANH
    (@EngId, 'ENG9-VAO10', N'Tiếng Anh 9 – Chinh Phục Kỳ Thi Vào Lớp 10', 9, N'Vào 10 Chuyên & Công lập', 3600000.00, 12, 24, 12, N'Tổng ôn ngữ pháp trọng tâm, từ vựng theo chủ điểm và kỹ năng làm bài thi trắc nghiệm điểm 9+.', '/assets/images/courses/english.jpg', 1, 'OPEN'),
    (@EngId, 'ENG10-CB', N'Tiếng Anh 10 – Ngữ Pháp & Kỹ Năng Đọc Hiểu Học Thuật', 10, N'Bổ trợ & Nền tảng', 3600000.00, 12, 24, 15, N'Rèn luyện ngữ âm, trọng âm, cụm động từ và các dạng bài điền từ, đọc hiểu theo chương trình GDPT mới.', '/assets/images/courses/english.jpg', 0, 'OPEN'),
    (@EngId, 'ENG12-TN', N'Tiếng Anh 12 – Bứt Phá Điểm Số Thi Tốt Nghiệp THPT', 12, N'Tốt nghiệp THPT', 4200000.00, 14, 28, 15, N'Chiến thuật giải quyết bài đọc hiểu dài, phân tích câu đồng nghĩa, tìm lỗi sai và mở rộng vốn từ vựng.', '/assets/images/courses/english.jpg', 1, 'OPEN'),
    (@EngId, 'ENG-IELTS', N'IELTS Chuyên Sâu 6.5+ & Academic Reading / Writing', 11, N'Chứng chỉ Quốc tế / Tuyển thẳng ĐH', 6500000.00, 16, 32, 10, N'Lộ trình cá nhân hóa hướng tới chứng chỉ IELTS 6.5 - 7.5 phục vụ quy đổi điểm xét tuyển đại học sớm.', '/assets/images/courses/english.jpg', 1, 'OPEN'),

    -- NGỮ VĂN
    (@LitId, 'VAN10-CB', N'Ngữ Văn 10 – Đọc Hiểu & Kỹ Năng Viết Đoạn Văn Nghị Luận', 10, N'Học kỳ & Nền tảng', 3200000.00, 12, 24, 15, N'Phương pháp tiếp cận các thể loại thần thoại, sử thi và kỹ năng viết bài văn nghị luận xã hội giàu sức thuyết phục.', '/assets/images/courses/literature.jpg', 0, 'OPEN'),
    (@LitId, 'VAN12-TN', N'Ngữ Văn 12 – Chuyên Đề Tác Phẩm & Nghị Luận Văn Học Điểm 8.5+', 12, N'Tốt nghiệp THPT', 4000000.00, 14, 28, 15, N'Phân tích sâu sắc hệ thống tác phẩm trọng tâm, cấu trúc mở bài - kết bài sáng tạo và lập luận sắc bén.', '/assets/images/courses/literature.jpg', 1, 'OPEN'),

    -- VẬT LÝ
    (@PhysId, 'LY11-NC', N'Vật Lý 11 – Dao Động Cơ, Sóng & Điện Trường Chuyên Sâu', 11, N'Nâng cao & Học bạ', 3800000.00, 12, 24, 15, N'Làm chủ bản chất vật lý của dao động điều hòa, sóng dừng, giao thoa sóng và phương pháp giải đồ thị.', '/assets/images/courses/physics.jpg', 0, 'OPEN'),
    (@PhysId, 'LY12-TN', N'Vật Lý 12 – Tổng Ôn Trọng Tâm & Kỹ Thuật Bấm Máy Tính Giải Nhanh', 12, N'Tốt nghiệp THPT', 4500000.00, 14, 28, 15, N'Hệ thống hóa toàn bộ mạch kiến thức Vật lý 12, rèn luyện tốc độ làm 30 câu đầu trong 15 phút.', '/assets/images/courses/physics.jpg', 1, 'OPEN'),

    -- HÓA HỌC
    (@ChemId, 'HOA11-NC', N'Hóa Học 11 – Hóa Hữu Cơ & Các Dạng Toán Phân Hóa Cao', 11, N'Nâng cao & Học sinh giỏi', 3800000.00, 12, 24, 15, N'Nắm vững bản chất liên kết hữu cơ, đồng phân, danh pháp và kỹ thuật quy đổi hỗn hợp chất.', '/assets/images/courses/chemistry.jpg', 0, 'OPEN'),
    (@ChemId, 'HOA12-TN', N'Hóa Học 12 – Luyện Đề Thực Chiến & Chống Sai Lý Thuyết Điểm 9+', 12, N'Tốt nghiệp THPT', 4500000.00, 14, 28, 15, N'Quét sạch mọi câu hỏi bẫy đếm chất, bài tập kim loại tác dụng với axit và este nâng cao.', '/assets/images/courses/chemistry.jpg', 1, 'OPEN'),

    -- SINH HỌC
    (@BioId, 'SINH12-TN', N'Sinh Học 12 – Chuyên Đề Di Truyền Học & Quần Thể Khối B', 12, N'Tốt nghiệp & Tuyển sinh Y Dược', 3800000.00, 12, 24, 15, N'Bổ trợ toàn diện các dạng toán phả hệ, quy luật di truyền Menđen và công nghệ tế bào cho khối B.', '/assets/images/courses/biology.jpg', 0, 'OPEN')
) AS source (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, image_url, is_featured, status)
ON target.code = source.code
WHEN MATCHED THEN
    UPDATE SET 
        subject_id = source.subject_id,
        name = source.name,
        grade_level = source.grade_level,
        target_exam = source.target_exam,
        fee = source.fee,
        duration_weeks = source.duration_weeks,
        total_sessions = source.total_sessions,
        max_capacity = source.max_capacity,
        description = source.description,
        image_url = source.image_url,
        is_featured = source.is_featured,
        status = source.status,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, image_url, is_featured, status, created_at, updated_at)
    VALUES (source.subject_id, source.code, source.name, source.grade_level, source.target_exam, source.fee, source.duration_weeks, source.total_sessions, source.max_capacity, source.description, source.image_url, source.is_featured, source.status, GETDATE(), GETDATE());
GO

PRINT N'Hoàn thành Bước 03: Khởi tạo 6 môn học và 15 khóa học chuẩn cho các khối 9-12!';
GO
