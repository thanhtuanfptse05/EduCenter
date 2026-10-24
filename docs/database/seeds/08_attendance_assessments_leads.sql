-- ============================================================================
-- EDUCENTER ERP - BƯỚC 08: KHỞI TẠO ĐIỂM DANH, SỔ ĐẦU BÀI, BÀI KIỂM TRA, CRM LEADS & AUDIT LOG
-- ============================================================================

USE EduCenterDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

-- 1. Tự động sinh Điểm danh (Attendances) cho mọi ca học COMPLETED và học viên ghi danh
PRINT N'Đang đồng bộ hóa dữ liệu Điểm danh (Attendances)...';

INSERT INTO dbo.Attendances (session_id, student_id, status, remarks, notes, recorded_at, recorded_by)
SELECT 
    cs.id,
    e.student_id,
    CASE 
        WHEN (cs.id * 3 + e.student_id * 7) % 31 = 0 THEN 'ABSENT_UNEXCUSED'
        WHEN (cs.id * 5 + e.student_id * 11) % 23 = 0 THEN 'ABSENT_EXCUSED'
        WHEN (cs.id + e.student_id * 2) % 11 = 0 THEN 'LATE'
        ELSE 'PRESENT'
    END AS status,
    CASE 
        WHEN (cs.id * 3 + e.student_id * 7) % 31 = 0 THEN N'Nghỉ học không phép, bộ phận học vụ đã gọi điện thông báo phụ huynh'
        WHEN (cs.id * 5 + e.student_id * 11) % 23 = 0 THEN N'Phụ huynh có gửi đơn xin phép nghỉ do ốm/lịch thi đột xuất ở trường'
        WHEN (cs.id + e.student_id * 2) % 11 = 0 THEN N'Đến muộn 10-15 phút do thời tiết mưa/tắc đường, vào lớp trật tự'
        ELSE N'Đi học đúng giờ, chuẩn bị bài đầy đủ, tiếp thu nhanh và hăng hái phát biểu'
    END AS remarks,
    CASE 
        WHEN (cs.id * 3 + e.student_id * 7) % 31 = 0 THEN N'Cần xem lại video bài giảng và bù bài tập tờ chuyên đề'
        WHEN (cs.id * 5 + e.student_id * 11) % 23 = 0 THEN N'Giáo viên đã gửi file tài liệu tóm tắt qua Zalo học tập'
        WHEN (cs.id + e.student_id * 2) % 11 = 0 THEN N'Nhắc nhở chú ý sắp xếp thời gian đi sớm hơn'
        ELSE N'Nắm vững kiến thức trọng tâm bài học'
    END AS notes,
    DATEADD(minute, 30, CAST(CONCAT(cs.session_date, ' ', cs.start_at) AS DATETIME2)),
    u.id
FROM dbo.ClassSessions cs
JOIN dbo.Classes cl ON cl.id = cs.class_id
JOIN dbo.Enrollments e ON e.class_id = cl.id AND e.status = 'ACTIVE'
JOIN dbo.Teachers t ON t.id = cs.teacher_id
JOIN dbo.Users u ON u.id = t.user_id
WHERE cs.status = 'COMPLETED'
  AND NOT EXISTS (
      SELECT 1 FROM dbo.Attendances a WHERE a.session_id = cs.id AND a.student_id = e.student_id
  );
GO

-- 2. Tự động sinh Sổ đầu bài (TeachingJournals) cho mọi ca học COMPLETED
PRINT N'Đang đồng bộ hóa dữ liệu Sổ đầu bài (TeachingJournals)...';

INSERT INTO dbo.TeachingJournals (session_id, content, homework, teacher_remarks, created_at, updated_at)
SELECT 
    cs.id,
    cs.title,
    N'Hoàn thành bài tập tự luyện trong tài liệu phát tay (Câu 1 đến Câu 25) và chuẩn bị bài mới',
    N'Lớp học duy trì nề nếp kỷ luật tốt, tương tác sôi nổi. Đa số các em nắm vững phương pháp và giải nhanh đúng tiến độ.',
    cs.session_date,
    cs.session_date
FROM dbo.ClassSessions cs
WHERE cs.status = 'COMPLETED'
  AND NOT EXISTS (SELECT 1 FROM dbo.TeachingJournals tj WHERE tj.session_id = cs.id);
GO

-- 3. Khởi tạo danh mục Bài kiểm tra (Assessments) và Điểm số chi tiết (AssessmentScores)
PRINT N'Đang tạo Bài kiểm tra (Assessments) và Bảng điểm (AssessmentScores)...';

DECLARE @TeacherHungUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherMaiUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.mai@educenter.vn');
DECLARE @TeacherTuanUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.tuan@educenter.vn');
DECLARE @TeacherLanUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.lan@educenter.vn');
DECLARE @TeacherPhuongUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.phuong@educenter.vn');
DECLARE @TeacherHoangUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.hoang@educenter.vn');
DECLARE @TeacherMaiAnhUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.maianh@educenter.vn');
DECLARE @TeacherNamUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.nam@educenter.vn');
DECLARE @TeacherNgocUser BIGINT = (SELECT id FROM dbo.Users WHERE email = 'teacher.ngoc@educenter.vn');

DECLARE @L12_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-01');
DECLARE @L12_TOAN_02 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-02');
DECLARE @L12_DGNL_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-DGNL-01');
DECLARE @L11_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-TOAN-01');
DECLARE @L10_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-TOAN-01');
DECLARE @L09_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L09-TOAN-01');

DECLARE @L12_ENG_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-ENG-01');
DECLARE @L11_IELTS_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-IELTS-01');
DECLARE @L12_IELTS_02 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-IELTS-02');
DECLARE @L10_ENG_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-ENG-01');
DECLARE @L09_ENG_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L09-ENG-01');

DECLARE @L12_LY_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-LY-01');
DECLARE @L11_LY_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-LY-01');
DECLARE @L12_HOA_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-HOA-01');
DECLARE @L11_HOA_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-HOA-01');
DECLARE @L12_SINH_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-SINH-01');
DECLARE @L12_VAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-VAN-01');
DECLARE @L10_VAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-VAN-01');

-- Helper bảng tạm chứa các bài kiểm tra
CREATE TABLE #TmpAsm (
    class_id BIGINT,
    title NVARCHAR(255),
    asm_type VARCHAR(20),
    weight DECIMAL(4,2),
    max_score DECIMAL(5,2),
    test_date DATE,
    descr NVARCHAR(500),
    status VARCHAR(20),
    teacher_user_id BIGINT
);

INSERT INTO #TmpAsm VALUES
-- 1. L12-TOAN-01
(@L12_TOAN_01, N'Kiểm tra Khảo sát Hàm số & Ứng dụng Đạo hàm (Chương 1)', '1_PERIOD', 1.00, 10.00, '2026-10-15', N'Kiểm tra định kỳ 45 phút rèn luyện kỹ năng nhận diện đồ thị và cực trị hàm hợp.', 'PUBLISHED', @TeacherHungUser),
(@L12_TOAN_01, N'Khảo sát Chất lượng Đầu vào & Thi thử Tốt nghiệp THPT Đợt 1', 'TRIAL', 2.00, 100.00, '2026-10-22', N'Đề thi chuẩn cấu trúc 50 câu trắc nghiệm THPT Quốc Gia phân hóa 4 cấp độ.', 'PUBLISHED', @TeacherHungUser),
(@L12_TOAN_01, N'Kiểm tra 15 Phút Khởi Động: Hàm số Mũ & Lôgarit', '15_MIN', 1.00, 10.00, '2026-10-26', N'Kiểm tra nhanh công thức lũy thừa và biến đổi biểu thức lôgarit.', 'DRAFT', @TeacherHungUser),

-- 2. L12-TOAN-02
(@L12_TOAN_02, N'Kiểm tra Chuyên đề Hàm số Phân hóa & Vận dụng Cao 9+', '1_PERIOD', 1.00, 10.00, '2026-10-16', N'Đề bài 25 câu trắc nghiệm phân hóa điểm 8.5 đến 10 câu hỏi tham số m.', 'PUBLISHED', @TeacherHungUser),

-- 3. L12-DGNL-01
(@L12_DGNL_01, N'Khảo sát ĐGNL ĐHQG Phần Tư duy Định lượng Đợt 1', 'TRIAL', 2.00, 100.00, '2026-10-17', N'Bài thi 50 câu hỏi tư duy logic, phân tích biểu đồ và suy luận số liệu trên máy.', 'PUBLISHED', @TeacherHungUser),

-- 4. L11-TOAN-01
(@L11_TOAN_01, N'Kiểm tra Định kỳ 1 Tiết: Phương trình Lượng giác & Hình Không gian', '1_PERIOD', 1.00, 10.00, '2026-10-18', N'Đánh giá kỹ năng biến đổi công thức lượng giác và xác định giao tuyến mặt phẳng.', 'PUBLISHED', @TeacherHungUser),

-- 5. L10-TOAN-01
(@L10_TOAN_01, N'Kiểm tra Giữa kỳ I: Tập hợp, Mệnh đề & Bất phương trình', 'MID_TERM', 1.50, 10.00, '2026-10-19', N'Đánh giá năng lực tư duy toán học đầu cấp THPT theo chương trình GDPT mới.', 'PUBLISHED', @TeacherNamUser),

-- 6. L09-TOAN-01
(@L09_TOAN_01, N'Khảo sát Năng lực Đầu vào Môn Toán & Rút gọn Biểu thức Chứa căn', '1_PERIOD', 1.00, 10.00, '2026-10-17', N'Kiểm tra trọng tâm các dạng toán điều kiện xác định, rút gọn và bài toán phụ.', 'PUBLISHED', @TeacherNamUser),

-- 7. L12-ENG-01
(@L12_ENG_01, N'Mid-Term Academic Vocabulary & Grammar Check', 'MID_TERM', 1.50, 10.00, '2026-10-20', N'Kiểm tra giữa kỳ kiến thức thì, mệnh đề quan hệ và ngữ động từ trọng điểm.', 'PUBLISHED', @TeacherMaiUser),

-- 8. L11-IELTS-01
(@L11_IELTS_01, N'IELTS Progress Check 1: Reading True/False & Writing Task 1', 'MID_TERM', 1.50, 10.00, '2026-10-22', N'Đánh giá kỹ năng viết miêu tả biểu đồ đường và đọc hiểu học thuật Cambridge.', 'PUBLISHED', @TeacherMaiAnhUser),

-- 9. L12-IELTS-02
(@L12_IELTS_02, N'IELTS Intensive Mock 1: Writing Task 2 & Reading Passage 3 Band 7.5+', 'TRIAL', 2.00, 10.00, '2026-10-21', N'Bài thi kiểm tra áp lực phòng thi đạt chuẩn tiêu chí chấm của Hội đồng Anh / IDP.', 'PUBLISHED', @TeacherMaiAnhUser),

-- 10. L12-LY-01
(@L12_LY_01, N'Kiểm tra Định kỳ 45 Phút: Dao động Cơ & Sóng Cơ Học Điểm 9+', '1_PERIOD', 1.00, 10.00, '2026-10-19', N'Rèn luyện kỹ năng sử dụng vòng tròn lượng giác và đọc đồ thị sóng cơ học.', 'PUBLISHED', @TeacherTuanUser),

-- 11. L12-HOA-01
(@L12_HOA_01, N'Kiểm tra 1 Tiết: Este - Lipit & Cacbohiđrat Chuyên sâu', '1_PERIOD', 1.00, 10.00, '2026-10-20', N'Đề trắc nghiệm 30 câu bao gồm các bài toán thủy phân hỗn hợp este phân hóa.', 'PUBLISHED', @TeacherLanUser),

-- 12. L12-SINH-01
(@L12_SINH_01, N'Khảo sát Di truyền Học Phân tử & Bài toán Phả hệ Y Dược', '1_PERIOD', 1.00, 10.00, '2026-10-21', N'Đánh giá kỹ năng tính xác suất phả hệ và quy luật di truyền phân ly độc lập.', 'PUBLISHED', @TeacherHoangUser),

-- 13. L12-VAN-01
(@L12_VAN_01, N'Kiểm tra Viết 90 Phút: Nghị luận Xã hội & Đoạn trích Sông Đà', 'MID_TERM', 1.50, 10.00, '2026-10-20', N'Rèn luyện tư duy lập luận sắc sảo, dẫn chứng thực tế và chất văn giàu cảm xúc.', 'PUBLISHED', @TeacherPhuongUser),

-- 14. L10-VAN-01
(@L10_VAN_01, N'Kiểm tra Đọc hiểu Văn học Dân gian & Đoạn văn Nghị luận 200 chữ', '1_PERIOD', 1.00, 10.00, '2026-10-21', N'Đọc hiểu sử thi anh hùng và kỹ năng phân tích hình tượng nhân vật.', 'PUBLISHED', @TeacherNgocUser);

-- Duyệt chèn Assessments
DECLARE @aClassId BIGINT, @aTitle NVARCHAR(255), @aType VARCHAR(20), @aWeight DECIMAL(4,2), @aMax DECIMAL(5,2), @aDate DATE, @aDescr NVARCHAR(500), @aStatus VARCHAR(20), @aTeacherUser BIGINT;
DECLARE @AsmId BIGINT;

DECLARE curAsm CURSOR LOCAL FOR
SELECT class_id, title, asm_type, weight, max_score, test_date, descr, status, teacher_user_id FROM #TmpAsm;

OPEN curAsm;
FETCH NEXT FROM curAsm INTO @aClassId, @aTitle, @aType, @aWeight, @aMax, @aDate, @aDescr, @aStatus, @aTeacherUser;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.Assessments WHERE class_id = @aClassId AND (title = @aTitle OR name = @aTitle))
    BEGIN
        INSERT INTO dbo.Assessments (class_id, title, name, assessment_type, weight, max_score, test_date, description, status, created_at, updated_at)
        VALUES (@aClassId, @aTitle, @aTitle, @aType, @aWeight, @aMax, @aDate, @aDescr, @aStatus, GETDATE(), GETDATE());

        SET @AsmId = SCOPE_IDENTITY();

        -- Tự động sinh điểm cho học viên của lớp nếu bài kiểm tra là PUBLISHED
        IF @aStatus = 'PUBLISHED'
        BEGIN
            INSERT INTO dbo.AssessmentScores (assessment_id, student_id, score, remarks, feedback, graded_at, graded_by)
            SELECT 
                @AsmId,
                e.student_id,
                CASE 
                    WHEN @aMax = 100.00 THEN 
                        CASE (e.student_id * 7 + @AsmId * 13) % 5
                            WHEN 0 THEN 94.00
                            WHEN 1 THEN 88.00
                            WHEN 2 THEN 82.00
                            WHEN 3 THEN 76.00
                            ELSE 90.00
                        END
                    ELSE
                        CASE (e.student_id * 7 + @AsmId * 13) % 5
                            WHEN 0 THEN 9.50
                            WHEN 1 THEN 8.80
                            WHEN 2 THEN 8.00
                            WHEN 3 THEN 7.50
                            ELSE 9.00
                        END
                END AS score,
                CASE (e.student_id * 7 + @AsmId * 13) % 5
                    WHEN 0 THEN N'Làm bài xuất sắc, trình bày bài bản, nắm rất chắc phương pháp giải.'
                    WHEN 1 THEN N'Tư duy tốt, lập luận rõ ràng, cần cẩn thận hơn ở các câu hỏi bẫy.'
                    WHEN 2 THEN N'Nắm vững kiến thức trọng tâm, tốc độ làm bài ổn định.'
                    WHEN 3 THEN N'Có tiến bộ, cần rèn thêm kỹ năng tính toán và quản lý thời gian.'
                    ELSE N'Kết quả tốt, phát huy tốt phong độ học tập hiện tại.'
                END AS remarks,
                CASE (e.student_id * 7 + @AsmId * 13) % 5
                    WHEN 0 THEN N'Làm bài xuất sắc, trình bày bài bản, nắm rất chắc phương pháp giải.'
                    WHEN 1 THEN N'Tư duy tốt, lập luận rõ ràng, cần cẩn thận hơn ở các câu hỏi bẫy.'
                    WHEN 2 THEN N'Nắm vững kiến thức trọng tâm, tốc độ làm bài ổn định.'
                    WHEN 3 THEN N'Có tiến bộ, cần rèn thêm kỹ năng tính toán và quản lý thời gian.'
                    ELSE N'Kết quả tốt, phát huy tốt phong độ học tập hiện tại.'
                END AS feedback,
                GETDATE(),
                @aTeacherUser
            FROM dbo.Enrollments e
            WHERE e.class_id = @aClassId AND e.status = 'ACTIVE';
        END;
    END;

    FETCH NEXT FROM curAsm INTO @aClassId, @aTitle, @aType, @aWeight, @aMax, @aDate, @aDescr, @aStatus, @aTeacherUser;
END;

CLOSE curAsm;
DEALLOCATE curAsm;
DROP TABLE #TmpAsm;
GO

-- 4. Khởi tạo Phễu Tuyển sinh CRM (Leads & Consultations quy mô lớn)
PRINT N'Đang cập nhật danh sách Leads CRM và Lịch sử tư vấn...';

DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffDung BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.dung@educenter.vn');
DECLARE @StaffMai BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.mai@educenter.vn');

MERGE dbo.Leads AS target
USING (VALUES
    (N'Vũ Hoàng My', '0912111222', 'hoangmy.parent@gmail.com', 12, 'WEBSITE', 'ENROLLED', @StaffHa, N'Đã tư vấn lớp Toán 12 Thầy Hùng và hoàn tất thủ tục nhập học'),
    (N'Phạm Anh Tuấn', '0912333444', 'anhtuan.p@gmail.com', 11, 'FACEBOOK', 'CONSULTING', @StaffHa, N'Quan tâm khóa học Toán 11 và IELTS. Đã gửi lộ trình và học phí qua Zalo'),
    (N'Nguyễn Thị Thu Hương', '0912555666', 'thuhuong.m@gmail.com', 10, 'HOTLINE', 'NEW', NULL, N'Đăng ký tư vấn trực tiếp qua hotline. Cần xếp lịch kiểm tra đầu vào lớp 10'),
    (N'Đỗ Minh Trí', '0912777888', 'minhtri.d@gmail.com', 12, 'REFERRAL', 'CONTACTED', @StaffDung, N'Học sinh THPT Chu Văn An được bạn giới thiệu. Quan tâm ôn thi ĐGNL ĐHQG'),
    (N'Bùi Thanh Thảo', '0912999000', 'thanhthao.b@gmail.com', 9, 'WEBSITE', 'CONSULTING', @StaffHa, N'Phụ huynh tìm lớp Tiếng Anh ôn thi vào lớp 10 chuyên Sư Phạm'),
    (N'Hoàng Gia Huy', '0913111333', 'giahuy.h@gmail.com', 12, 'HOTLINE', 'NEW', NULL, N'Học sinh muốn học thử lớp Vật lý 12 Thầy Tuấn vào tuần tới'),
    (N'Lê Thùy Dương', '0913222444', 'thuyduong.le@gmail.com', 11, 'FACEBOOK', 'CONSULTING', @StaffLinh, N'Cần gia sư bồi dưỡng Hóa học lớp 11 mục tiêu khối B00'),
    (N'Trần Minh Đức', '0913555777', 'minhduc.tran@gmail.com', 8, 'WEBSITE', 'CONTACTED', @StaffHa, N'Phụ huynh hẹn cuối tuần đưa con qua trung tâm test đầu vào'),
    (N'Nguyễn Văn An', '0913666888', 'vanan.nguyen@gmail.com', 12, 'FACEBOOK', 'ENROLLED', @StaffDung, N'Đã đăng ký combo Toán - Lý - Hóa 12'),
    (N'Trịnh Bích Hạnh', '0913777999', 'bichhanh.t@gmail.com', 11, 'REFERRAL', 'CONSULTING', @StaffLinh, N'Tìm lớp IELTS target 7.0 du học Canada'),
    (N'Đoàn Quốc Bảo', '0913888000', 'quocbao.doan@gmail.com', 10, 'HOTLINE', 'CONTACTED', @StaffMai, N'Phụ huynh muốn bổ trợ môn Toán và Ngữ Văn lớp 10'),
    (N'Lâm Phương Nhi', '0914111222', 'phuongnhi.lam@gmail.com', 9, 'WALK_IN', 'ENROLLED', @StaffHa, N'Đến trực tiếp văn phòng đăng ký khóa Toán 9 vào 10'),
    (N'Võ Thành Đạt', '0914222333', 'thanhdat.vo@gmail.com', 12, 'WEBSITE', 'NEW', NULL, N'Điền form đăng ký tư vấn thi thử ĐGNL ĐHQG'),
    (N'Dương Hải Yến', '0914333444', 'haiyen.duong@gmail.com', 11, 'FACEBOOK', 'ASSESSED', @StaffDung, N'Đã làm bài test đầu vào đạt 8.2 điểm môn Tiếng Anh'),
    (N'Phan Thanh Bình', '0914444555', 'thanhbinh.p@gmail.com', 10, 'HOTLINE', 'LOST', @StaffMai, N'Phụ huynh chuyển công tác vào Đà Nẵng nên tạm hoãn học'),
    (N'Hồ Ngọc Mai', '0914555666', 'ngocmai.ho@gmail.com', 12, 'REFERRAL', 'ENROLLED', @StaffHa, N'Học sinh Amsterdam đăng ký lớp IELTS 7.5+ Cô Mai Anh'),
    (N'Tạ Quang Minh', '0914666777', 'quangminh.ta@gmail.com', 11, 'WEBSITE', 'CONSULTING', @StaffLinh, N'Cần cải thiện môn Vật Lý 11 phần dao động điều hòa'),
    (N'Lương Thảo Nguyên', '0914777888', 'thaonguyen.l@gmail.com', 9, 'FACEBOOK', 'CONTACTED', @StaffDung, N'Phụ huynh hỏi về học phí và lịch học lớp Tiếng Anh vào 10'),
    (N'Trương Gia Khiêm', '0914888999', 'giakhiem.t@gmail.com', 10, 'WALK_IN', 'ENROLLED', @StaffHa, N'Học sinh Kim Liên đăng ký lớp Toán 10 Thầy Nam'),
    (N'Đinh Tuyết Mai', '0915111222', 'tuyetmai.d@gmail.com', 12, 'HOTLINE', 'NEW', NULL, N'Hỏi thông tin khóa Luyện đề Tốt nghiệp THPT môn Sinh học'),
    (N'Bùi Thế Hùng', '0915222333', 'thehung.b@gmail.com', 11, 'REFERRAL', 'CONSULTING', @StaffLinh, N'Học sinh Yên Hòa quan tâm lớp Toán 11 Nâng cao'),
    (N'Mai Kim Chi', '0915333444', 'kimchi.m@gmail.com', 12, 'WEBSITE', 'ASSESSED', @StaffDung, N'Đã tham gia thi thử ĐGNL đạt 88/100 điểm'),
    (N'Trần Quốc Bảo', '0915444555', 'quocbao.tran@gmail.com', 9, 'FACEBOOK', 'ENROLLED', @StaffHa, N'Đã hoàn tất đăng ký khóa Toán 9 Chuyên Sư Phạm'),
    (N'Nguyễn Khánh Linh', '0915555666', 'khanhlinh.nguyen@gmail.com', 10, 'HOTLINE', 'CONTACTED', @StaffMai, N'Phụ huynh gọi điện tham khảo lịch học cuối tuần'),
    (N'Vũ Trọng Phụng', '0915666777', 'trongphung.vu@gmail.com', 12, 'WALK_IN', 'ENROLLED', @StaffHa, N'Học sinh đăng ký trực tiếp tại cơ sở khóa Ngữ Văn 12')
) AS source (name, phone, email, grade_level, source, status, assigned_to, notes)
ON target.phone = source.phone
WHEN MATCHED THEN
    UPDATE SET 
        name = source.name,
        email = source.email,
        grade_level = source.grade_level,
        source = source.source,
        status = source.status,
        assigned_to = source.assigned_to,
        notes = source.notes,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (name, phone, email, grade_level, source, status, assigned_to, notes, created_at, updated_at)
    VALUES (source.name, source.phone, source.email, source.grade_level, source.source, source.status, source.assigned_to, source.notes, GETDATE(), GETDATE());
GO

-- 5. Bổ sung Lịch sử tư vấn (Consultations) chi tiết cho các Leads
DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffDung BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.dung@educenter.vn');

DECLARE @lId BIGINT;

-- Lead: Phạm Anh Tuấn
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0912333444');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Cuộc gọi 1: Tư vấn lộ trình Toán 11 và kiểm tra trình độ IELTS. Phụ huynh rất hài lòng.', DATEADD(day, -4, GETDATE()), DATEADD(day, 2, GETDATE())),
    (@lId, @StaffHa, N'Cuộc gọi 2: Gửi bảng thời khóa biểu và chính sách ưu đãi combo qua Zalo.', DATEADD(day, -1, GETDATE()), DATEADD(day, 2, GETDATE()));
END;

-- Lead: Bùi Thanh Thảo
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0912999000');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Tư vấn trực tiếp tại văn phòng. Em Thảo có nền tảng ngữ pháp tốt, muốn tập trung kỹ năng viết luận.', DATEADD(day, -5, GETDATE()), DATEADD(day, 1, GETDATE()));
END;

-- Lead: Lê Thùy Dương
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0913222444');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffLinh, N'Nhắn tin Fanpage tư vấn khóa Hóa học 11 Cô Lan. Học sinh cần củng cố phần đồng đẳng hóa.', DATEADD(day, -3, GETDATE()), DATEADD(day, 3, GETDATE()));
END;

-- Lead: Trịnh Bích Hạnh
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0913777999');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffLinh, N'Trao đổi qua điện thoại về mục tiêu 7.0 IELTS du học. Hẹn lịch thi thử mini-mock test cuối tuần.', DATEADD(day, -2, GETDATE()), DATEADD(day, 2, GETDATE()));
END;

-- Lead: Dương Hải Yến
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0914333444');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffDung, N'Học sinh đã hoàn thành bài thi thử đánh giá đầu vào đạt 8.2 điểm. Xếp vào lớp L11-IELTS-01.', DATEADD(day, -1, GETDATE()), DATEADD(day, 4, GETDATE()));
END;

-- Lead: Tạ Quang Minh
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0914666777');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffLinh, N'Phụ huynh gọi điện xin tư vấn khóa Vật lý 11 Thầy Tuấn. Đã gửi đề cương chi tiết 8 buổi học.', DATEADD(day, -2, GETDATE()), DATEADD(day, 1, GETDATE()));
END;

-- Lead: Vũ Hoàng My
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0912111222');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Tư vấn trực tiếp tại văn phòng khóa Toán 12 Thầy Hùng và hoàn tất nhập học.', DATEADD(day, -6, GETDATE()), NULL);
END;

-- Lead: Nguyễn Văn An
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0913666888');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffDung, N'Tư vấn combo khối A00 (Toán, Lý, Hóa). Phụ huynh đồng ý ghi danh học kỳ I.', DATEADD(day, -5, GETDATE()), NULL);
END;

-- Lead: Lâm Phương Nhi
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0914111222');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Tiếp đón tại quầy tư vấn tuyển sinh. Đã làm bài test đầu vào môn Tiếng Anh và xếp lớp.', DATEADD(day, -4, GETDATE()), NULL);
END;

-- Lead: Hồ Ngọc Mai
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0914555666');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Trao đổi qua Zoom với học sinh và phụ huynh về target IELTS 7.5+. Đăng ký lớp IELTS 7.5+ Cô Mai Anh.', DATEADD(day, -3, GETDATE()), NULL);
END;

-- Lead: Trương Gia Khiêm
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0914888999');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Phụ huynh đưa con đến kiểm tra trình độ Toán 10. Điểm đạt 8.5/10, ghi danh lớp L10-TOAN-01.', DATEADD(day, -2, GETDATE()), NULL);
END;

-- Lead: Mai Kim Chi
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0915333444');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffDung, N'Thông báo kết quả thi thử ĐGNL đạt 88 điểm. Tư vấn lộ trình bổ trợ 3 tháng cuối.', DATEADD(day, -1, GETDATE()), DATEADD(day, 3, GETDATE()));
END;

-- Lead: Trần Quốc Bảo
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0915444555');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Phụ huynh hoàn tất hồ sơ đăng ký lớp Toán 9 Chuyên. Bàn giao tài liệu học tập đầu khóa.', DATEADD(day, -3, GETDATE()), NULL);
END;

-- Lead: Vũ Trọng Phụng
SET @lId = (SELECT id FROM dbo.Leads WHERE phone = '0915666777');
IF @lId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Consultations WHERE lead_id = @lId)
BEGIN
    INSERT INTO dbo.Consultations (lead_id, staff_id, notes, contacted_at, next_appointment) VALUES
    (@lId, @StaffHa, N'Tư vấn trực tiếp khóa Ngữ Văn 12 Cô Phương. Học sinh muốn củng cố phần đọc hiểu và NLXH.', DATEADD(day, -2, GETDATE()), NULL);
END;
GO

PRINT N'Hoàn thành Bước 08: Khởi tạo dữ liệu điểm danh, sổ đầu bài, bảng điểm công bố và CRM Leads quy mô lớn!';
PRINT N'=============================================================================';
PRINT N'HỆ THỐNG CƠ SỞ DỮ LIỆU ĐÃ ĐẦY ĐỦ VÀ HOÀN HẢO CHO MỌI VAI TRÒ VÀ BÁO CÁO!';
PRINT N'=============================================================================';
GO
