-- ============================================================================
-- EDUCENTER ERP - BƯỚC 08: KHỞI TẠO ĐIỂM DANH, SỔ ĐẦU BÀI, BÀI KIỂM TRA, CRM LEADS & AUDIT LOG
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

DECLARE @TeacherHungUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherHung BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherMaiUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.mai@educenter.vn');
DECLARE @TeacherMai BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.mai@educenter.vn');

DECLARE @ClassToan12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-01');
DECLARE @ClassEng12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-ENG-01');

DECLARE @sNam BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.nam@educenter.vn');
DECLARE @sPhong BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.phong@educenter.vn');
DECLARE @sKien BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.kien@educenter.vn');
DECLARE @sNgan BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.ngan@educenter.vn');

-- 1. Khởi tạo Điểm danh (Attendances) và Sổ đầu bài (TeachingJournals) cho các buổi đã học của lớp L12-TOAN-01
DECLARE @Sess1 BIGINT = (SELECT id FROM dbo.ClassSessions WHERE class_id = @ClassToan12_01 AND session_date = '2026-10-05');
DECLARE @Sess2 BIGINT = (SELECT id FROM dbo.ClassSessions WHERE class_id = @ClassToan12_01 AND session_date = '2026-10-08');
DECLARE @Sess3 BIGINT = (SELECT id FROM dbo.ClassSessions WHERE class_id = @ClassToan12_01 AND session_date = '2026-10-12');
DECLARE @Sess4 BIGINT = (SELECT id FROM dbo.ClassSessions WHERE class_id = @ClassToan12_01 AND session_date = '2026-10-15');
DECLARE @Sess5 BIGINT = (SELECT id FROM dbo.ClassSessions WHERE class_id = @ClassToan12_01 AND session_date = '2026-10-19');
DECLARE @Sess6 BIGINT = (SELECT id FROM dbo.ClassSessions WHERE class_id = @ClassToan12_01 AND session_date = '2026-10-22');

CREATE TABLE #TmpAtt (
    session_id BIGINT,
    student_id BIGINT,
    status VARCHAR(20),
    notes NVARCHAR(255)
);

-- Buổi 1
INSERT INTO #TmpAtt VALUES
(@Sess1, @sNam, 'PRESENT', N'Đi học đúng giờ, hăng hái phát biểu'),
(@Sess1, @sPhong, 'PRESENT', N'Nắm bài nhanh, làm trọn vẹn bài tập'),
(@Sess1, @sKien, 'PRESENT', N'Tập trung nghe giảng'),
(@Sess1, @sNgan, 'PRESENT', N'Học tập nghiêm túc');

-- Buổi 2
INSERT INTO #TmpAtt VALUES
(@Sess2, @sNam, 'PRESENT', N'Làm bài tập về nhà đầy đủ'),
(@Sess2, @sPhong, 'PRESENT', N'Có phương pháp giải sáng tạo'),
(@Sess2, @sKien, 'PRESENT', N'Tiếp thu tốt'),
(@Sess2, @sNgan, 'PRESENT', N'Đúng giờ');

-- Buổi 3
INSERT INTO #TmpAtt VALUES
(@Sess3, @sNam, 'PRESENT', N'Hoàn thành bài trên lớp'),
(@Sess3, @sPhong, 'PRESENT', N'Hoàn thành xuất sắc'),
(@Sess3, @sKien, 'PRESENT', N'Đúng giờ'),
(@Sess3, @sNgan, 'PRESENT', N'Buổi cuối trước khi chuyển lớp');

-- Buổi 4
INSERT INTO #TmpAtt VALUES
(@Sess4, @sNam, 'LATE', N'Đến muộn 15 phút do tắc đường trên đường Cầu Giấy'),
(@Sess4, @sPhong, 'PRESENT', N'Đúng giờ'),
(@Sess4, @sKien, 'PRESENT', N'Đúng giờ');

-- Buổi 5
INSERT INTO #TmpAtt VALUES
(@Sess5, @sNam, 'PRESENT', N'Hiểu bài hình không gian'),
(@Sess5, @sPhong, 'PRESENT', N'Đúng giờ'),
(@Sess5, @sKien, 'PRESENT', N'Đúng giờ');

-- Buổi 6
INSERT INTO #TmpAtt VALUES
(@Sess6, @sNam, 'ABSENT_EXCUSED', N'Phụ huynh có gửi đơn xin phép nghỉ do bị sốt nhẹ'),
(@Sess6, @sPhong, 'PRESENT', N'Tham gia làm bài kiểm tra định kỳ nghiêm túc'),
(@Sess6, @sKien, 'LATE', N'Đến muộn 10 phút, làm bài tích cực');

INSERT INTO dbo.Attendances (session_id, student_id, status, notes, recorded_at, recorded_by)
SELECT t.session_id, t.student_id, t.status, t.notes, GETDATE(), @TeacherHungUser
FROM #TmpAtt t
WHERE t.session_id IS NOT NULL AND t.student_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM dbo.Attendances a WHERE a.session_id = t.session_id AND a.student_id = t.student_id
);

DROP TABLE #TmpAtt;

-- Sổ đầu bài cho các buổi đã học
IF @Sess1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.TeachingJournals WHERE session_id = @Sess1)
    INSERT INTO dbo.TeachingJournals (session_id, teacher_id, lesson_topic, homework_assigned, student_evaluations, teacher_feedback, created_at, updated_at)
    VALUES (@Sess1, @TeacherHung, N'Khảo sát sự biến thiên và vẽ đồ thị hàm số chứa dấu giá trị tuyệt đối', N'Bài tập tờ chuyên đề 1 (Câu 1 đến 25)', N'Cả lớp trật tự, tương tác tốt với bảng điện tử', N'Cần chú ý kỹ thuật vẽ đồ thị đối xứng qua trục hoành', GETDATE(), GETDATE());

IF @Sess2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.TeachingJournals WHERE session_id = @Sess2)
    INSERT INTO dbo.TeachingJournals (session_id, teacher_id, lesson_topic, homework_assigned, student_evaluations, teacher_feedback, created_at, updated_at)
    VALUES (@Sess2, @TeacherHung, N'Cực trị của hàm số bậc ba và hàm phân thức hữu tỉ nâng cao', N'Bài tập chuyên đề cực trị hàm hợp f(u)', N'Nam và Phong làm bài rất tốt trên bảng', N'Lớp nắm vững điều kiện cực trị qua dấu đạo hàm bậc nhất', GETDATE(), GETDATE());
GO

-- 2. Khởi tạo Bài kiểm tra (Assessments) và Điểm số (AssessmentScores)
DECLARE @TeacherHungUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherMaiUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.mai@educenter.vn');

DECLARE @ClassToan12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-01');
DECLARE @ClassEng12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-ENG-01');

DECLARE @sNam BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.nam@educenter.vn');
DECLARE @sPhong BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.phong@educenter.vn');
DECLARE @sKien BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.kien@educenter.vn');

-- Bài kiểm tra 1 (Thang 10, Trọng số 1.0, Đã công bố)
DECLARE @Asm1Id BIGINT;
IF NOT EXISTS (SELECT 1 FROM dbo.Assessments WHERE class_id = @ClassToan12_01 AND name = N'Kiểm tra Khảo sát Hàm số & Ứng dụng Đạo hàm (Chương 1)')
BEGIN
    INSERT INTO dbo.Assessments (class_id, name, weight, max_score, test_date, description, status, created_at, updated_at)
    VALUES (@ClassToan12_01, N'Kiểm tra Khảo sát Hàm số & Ứng dụng Đạo hàm (Chương 1)', 1.00, 10.00, '2026-10-15', N'Kiểm tra định kỳ 45 phút rèn luyện kỹ năng nhận diện đồ thị và cực trị hàm hợp.', 'PUBLISHED', GETDATE(), GETDATE());
    SET @Asm1Id = SCOPE_IDENTITY();

    INSERT INTO dbo.AssessmentScores (assessment_id, student_id, score, feedback, graded_at, graded_by) VALUES
    (@Asm1Id, @sPhong, 9.50, N'Làm bài xuất sắc, trình bày bài bản và cẩn thận.', GETDATE(), @TeacherHungUser),
    (@Asm1Id, @sNam, 8.00, N'Tư duy tốt, cần cẩn thận hơn ở câu hỏi cực trị chứa tham số.', GETDATE(), @TeacherHungUser),
    (@Asm1Id, @sKien, 7.50, N'Nắm vững kiến thức cơ bản, cần tăng tốc độ làm bài.', GETDATE(), @TeacherHungUser);
END

-- Bài kiểm tra 2 (Thang 100, Trọng số 2.0, Đã công bố - Dùng để kiểm thử chuẩn hóa GPA B02: 8/10 và 80/100 -> 8.00/10)
DECLARE @Asm2Id BIGINT;
IF NOT EXISTS (SELECT 1 FROM dbo.Assessments WHERE class_id = @ClassToan12_01 AND name = N'Khảo sát Chất lượng Đầu vào & Thi thử Tốt nghiệp THPT Đợt 1')
BEGIN
    INSERT INTO dbo.Assessments (class_id, name, weight, 2.00, test_date, description, status, created_at, updated_at)
    VALUES (@ClassToan12_01, N'Khảo sát Chất lượng Đầu vào & Thi thử Tốt nghiệp THPT Đợt 1', 2.00, 100.00, '2026-10-22', N'Đề thi chuẩn cấu trúc 50 câu trắc nghiệm THPT Quốc Gia phân hóa 4 cấp độ.', 'PUBLISHED', GETDATE(), GETDATE());
    SET @Asm2Id = SCOPE_IDENTITY();

    INSERT INTO dbo.AssessmentScores (assessment_id, student_id, score, feedback, graded_at, graded_by) VALUES
    (@Asm2Id, @sPhong, 92.00, N'Đạt 46/50 câu. Kỹ năng tư duy giải nhanh rất tốt.', GETDATE(), @TeacherHungUser),
    (@Asm2Id, @sNam, 80.00, N'Đạt 40/50 câu (Tương đương 8.0 điểm). Tiến bộ rõ rệt phần hình học không gian.', GETDATE(), @TeacherHungUser),
    (@Asm2Id, @sKien, 74.00, N'Đạt 37/50 câu. Chú ý chống bẫy phần tiệm cận đứng.', GETDATE(), @TeacherHungUser);
END

-- Bài kiểm tra 3 (Bản nháp DRAFT để giáo viên kiểm thử giao diện chấm điểm)
IF NOT EXISTS (SELECT 1 FROM dbo.Assessments WHERE class_id = @ClassToan12_01 AND name = N'Kiểm tra 15 Phút Khởi Động: Hàm số Mũ & Lôgarit')
BEGIN
    INSERT INTO dbo.Assessments (class_id, name, weight, max_score, test_date, description, status, created_at, updated_at)
    VALUES (@ClassToan12_01, N'Kiểm tra 15 Phút Khởi Động: Hàm số Mũ & Lôgarit', 1.00, 10.00, '2026-10-26', N'Kiểm tra nhanh công thức lũy thừa và biến đổi biểu thức lôgarit.', 'DRAFT', GETDATE(), GETDATE());
END

-- Bài kiểm tra Tiếng Anh (L12-ENG-01)
DECLARE @AsmEngId BIGINT;
IF NOT EXISTS (SELECT 1 FROM dbo.Assessments WHERE class_id = @ClassEng12_01 AND name = N'Mid-Term Academic Vocabulary & Grammar Check')
BEGIN
    INSERT INTO dbo.Assessments (class_id, name, weight, max_score, test_date, description, status, created_at, updated_at)
    VALUES (@ClassEng12_01, N'Mid-Term Academic Vocabulary & Grammar Check', 1.50, 10.00, '2026-10-22', N'Kiểm tra giữa kỳ kiến thức thì, mệnh đề quan hệ và ngữ động từ.', 'PUBLISHED', GETDATE(), GETDATE());
    SET @AsmEngId = SCOPE_IDENTITY();

    INSERT INTO dbo.AssessmentScores (assessment_id, student_id, score, feedback, graded_at, graded_by) VALUES
    (@AsmEngId, @sNam, 8.50, N'Rất tốt phần ngữ pháp và câu đồng nghĩa. Cố gắng phát huy!', GETDATE(), @TeacherMaiUser);
END
GO

-- 3. Khởi tạo Phễu Tuyển sinh CRM (Leads & Consultations)
DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffDung BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.dung@educenter.vn');

MERGE dbo.Leads AS target
USING (VALUES
    (N'Vũ Hoàng My', '0912111222', 'hoangmy.parent@gmail.com', 12, 'WEBSITE', 'ENROLLED', @StaffHa, N'Đã tư vấn lớp Toán 12 Thầy Hùng và hoàn tất thủ tục nhập học'),
    (N'Phạm Anh Tuấn', '0912333444', 'anhtuan.p@gmail.com', 11, 'FACEBOOK', 'CONSULTED', @StaffHa, N'Quan tâm khóa học Toán 11 và IELTS. Đã gửi lộ trình và học phí qua Zalo'),
    (N'Nguyễn Thị Thu Hương', '0912555666', 'thuhuong.m@gmail.com', 10, 'HOTLINE', 'NEW', @StaffLinh, N'Đăng ký tư vấn trực tiếp qua hotline. Cần xếp lịch kiểm tra đầu vào lớp 10'),
    (N'Đỗ Minh Trí', '0912777888', 'minhtri.d@gmail.com', 12, 'REFERRAL', 'CONTACTED', @StaffDung, N'Học sinh THPT Chu Văn An được bạn giới thiệu. Quan tâm ôn thi ĐGNL ĐHQG'),
    (N'Bùi Thanh Thảo', '0912999000', 'thanhthao.b@gmail.com', 9, 'WEBSITE', 'CONSULTED', @StaffHa, N'Phụ huynh tìm lớp Tiếng Anh ôn thi vào lớp 10 chuyên Sư Phạm'),
    (N'Hoàng Gia Huy', '0913111333', 'giahuy.h@gmail.com', 12, 'HOTLINE', 'NEW', @StaffLinh, N'Học sinh muốn học thử lớp Vật lý 12 Thầy Tuấn vào tuần tới')
) AS source (name, phone, email, grade_level, source, status, assigned_to, notes)
ON target.phone = source.phone
WHEN MATCHED THEN
    UPDATE SET status = source.status, assigned_to = source.assigned_to, notes = source.notes, updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (name, phone, email, grade_level, source, status, assigned_to, notes, created_at, updated_at)
    VALUES (source.name, source.phone, source.email, source.grade_level, source.source, source.status, source.assigned_to, source.notes, GETDATE(), GETDATE());
GO

-- 4. Khởi tạo Nhật ký Giám sát Hệ thống (AuditLogs)
DECLARE @AdminId BIGINT = (SELECT id FROM dbo.Users WHERE email = 'admin@educenter.vn');
DECLARE @TeacherHungUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.hung@educenter.vn');

IF NOT EXISTS (SELECT 1 FROM dbo.AuditLogs WHERE action = 'INITIALIZE_SYSTEM')
BEGIN
    INSERT INTO dbo.AuditLogs (actor_id, action, entity_type, entity_id, old_values, new_values, ip_address, created_at)
    VALUES
    (@AdminId, 'INITIALIZE_SYSTEM', 'SystemSetting', 1, NULL, N'Khởi tạo toàn bộ dữ liệu mẫu chuẩn hóa 30 bảng EduCenter ERP', '127.0.0.1', GETDATE()),
    (@TeacherHungUser, 'PUBLISH_ASSESSMENT', 'Assessment', 1, N'status=DRAFT', N'status=PUBLISHED, name=Kiểm tra Khảo sát Hàm số (Chương 1)', '127.0.0.1', GETDATE());
END
GO

PRINT N'Hoàn thành Bước 08: Khởi tạo đầy đủ nhật ký điểm danh, sổ đầu bài, bảng điểm công bố, CRM Leads và Audit Log!';
PRINT N'=============================================================================';
PRINT N'CHÚC MỪNG! HỆ THỐNG CƠ SỞ DỮ LIỆU EDUCENTER ĐÃ SẴN SÀNG 100% CHO CHẠY THỬ & DEMO!';
PRINT N'=============================================================================';
GO
