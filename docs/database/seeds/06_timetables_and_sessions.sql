-- ============================================================================
-- EDUCENTER ERP - BƯỚC 06: KHỞI TẠO THỜI KHÓA BIỂU & CÁC CA HỌC CHI TIẾT
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

DECLARE @ClassToan12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-01');
DECLARE @ClassToan12_02 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-02');
DECLARE @ClassToanDGNL BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-DGNL-01');
DECLARE @ClassToan11_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-TOAN-01');
DECLARE @ClassToan10_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-TOAN-01');

DECLARE @ClassEng12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-ENG-01');
DECLARE @ClassEng09_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L09-ENG-01');
DECLARE @ClassEngIelts BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-IELTS-01');

DECLARE @ClassLy12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-LY-01');
DECLARE @ClassLy11_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-LY-01');

DECLARE @ClassHoa12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-HOA-01');
DECLARE @ClassHoa11_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-HOA-01');

DECLARE @ClassVan12_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-VAN-01');

DECLARE @TeacherHung BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherMai BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.mai@educenter.vn');
DECLARE @TeacherTuan BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.tuan@educenter.vn');
DECLARE @TeacherLan BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.lan@educenter.vn');
DECLARE @TeacherPhuong BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.phuong@educenter.vn');

DECLARE @RoomP101 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P101');
DECLARE @RoomP102 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P102');
DECLARE @RoomP201 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P201');
DECLARE @RoomP202 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P202');
DECLARE @RoomP301 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P301');
DECLARE @RoomP302 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P302');
DECLARE @RoomLAB01 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'LAB01');

-- Tạo bảng tạm chứa các buổi học
CREATE TABLE #TmpSessions (
    class_id BIGINT,
    teacher_id BIGINT,
    room_id BIGINT,
    session_date DATE,
    start_at TIME(0),
    end_at TIME(0),
    title NVARCHAR(255),
    status VARCHAR(20)
);

-- 1. Lớp L12-TOAN-01 (Thứ 2 & Thứ 5: 17:30 - 19:30)
INSERT INTO #TmpSessions VALUES
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-05', '17:30:00', '19:30:00', N'Buổi 01: Khảo sát sự biến thiên và vẽ đồ thị hàm số chứa dấu giá trị tuyệt đối', 'COMPLETED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-08', '17:30:00', '19:30:00', N'Buổi 02: Cực trị của hàm số bậc ba và hàm phân thức hữu tỉ nâng cao', 'COMPLETED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-12', '17:30:00', '19:30:00', N'Buổi 03: Giá trị lớn nhất - nhỏ nhất của hàm số trên đoạn và bài toán thực tế', 'COMPLETED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-15', '17:30:00', '19:30:00', N'Buổi 04: Tiệm cận đứng, tiệm cận ngang và bài toán tương giao đồ thị', 'COMPLETED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-19', '17:30:00', '19:30:00', N'Buổi 05: Khối đa diện và thể tích khối chóp, khối lăng trụ cơ bản', 'COMPLETED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-22', '17:30:00', '19:30:00', N'Buổi 06: Kiểm tra định kỳ Chuyên đề 1 & Kỹ thuật Casio nâng cao', 'COMPLETED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-26', '17:30:00', '19:30:00', N'Buổi 07: Hàm số lũy thừa, hàm số mũ và lôgarit chuyên sâu', 'SCHEDULED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-10-29', '17:30:00', '19:30:00', N'Buổi 08: Phương trình và bất phương trình mũ chứa tham số m', 'SCHEDULED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-11-02', '17:30:00', '19:30:00', N'Buổi 09: Hình nón, hình trụ, mặt cầu ngoại tiếp khối đa diện', 'SCHEDULED'),
(@ClassToan12_01, @TeacherHung, @RoomP101, '2026-11-05', '17:30:00', '19:30:00', N'Buổi 10: Nguyên hàm, tích phân và các phương pháp đổi biến số', 'SCHEDULED');

-- 2. Lớp L12-TOAN-02 (Thứ 3 & Thứ 6: 17:30 - 19:30)
INSERT INTO #TmpSessions VALUES
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-06', '17:30:00', '19:30:00', N'Buổi 01: Hàm số hợp và tính đơn điệu của hàm số f(u)', 'COMPLETED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-09', '17:30:00', '19:30:00', N'Buổi 02: Cực trị hàm số chứa tham số và kỹ thuật đạo hàm cấp hai', 'COMPLETED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-13', '17:30:00', '19:30:00', N'Buổi 03: Min - Max hàm liên kết và phương pháp cô lập tham số m', 'COMPLETED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-16', '17:30:00', '19:30:00', N'Buổi 04: Tương giao đồ thị và bài toán biện luận số nghiệm nghiệm', 'COMPLETED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-20', '17:30:00', '19:30:00', N'Buổi 05: Thể tích khối đa diện phân hóa và tỷ số thể tích Simson', 'COMPLETED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-23', '17:30:00', '19:30:00', N'Buổi 06: Bất đẳng thức mũ và lôgarit vận dụng cao', 'COMPLETED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-27', '17:30:00', '19:30:00', N'Buổi 07: Phương trình mũ và lôgarit chứa tham số nâng cao', 'SCHEDULED'),
(@ClassToan12_02, @TeacherHung, @RoomP202, '2026-10-30', '17:30:00', '19:30:00', N'Buổi 08: Mặt nón, mặt trụ và góc nhìn thực tiễn', 'SCHEDULED');

-- 3. Lớp L12-DGNL-01 (Thứ 7: 08:30 - 11:30)
INSERT INTO #TmpSessions VALUES
(@ClassToanDGNL, @TeacherHung, @RoomLAB01, '2026-10-03', '08:30:00', '11:30:00', N'Chuyên đề 01: Phân tích số liệu biểu đồ cột, biểu đồ tròn và ma trận', 'COMPLETED'),
(@ClassToanDGNL, @TeacherHung, @RoomLAB01, '2026-10-10', '08:30:00', '11:30:00', N'Chuyên đề 02: Suy luận logic tổ hợp, hoán vị và xác suất thực nghiệm', 'COMPLETED'),
(@ClassToanDGNL, @TeacherHung, @RoomLAB01, '2026-10-17', '08:30:00', '11:30:00', N'Chuyên đề 03: Đọc hiểu dữ liệu thống kê bảng biểu và kiểm thử giải định', 'COMPLETED'),
(@ClassToanDGNL, @TeacherHung, @RoomLAB01, '2026-10-24', '08:30:00', '11:30:00', N'Chuyên đề 04: Toán tư duy mô hình hóa hình học và tối ưu chi phí', 'SCHEDULED'),
(@ClassToanDGNL, @TeacherHung, @RoomLAB01, '2026-10-31', '08:30:00', '11:30:00', N'Chuyên đề 05: Thi thử trực tuyến ĐGNL ĐHQG đợt 1 tại Phòng Lab', 'SCHEDULED');

-- 4. Lớp L12-ENG-01 (Thứ 2 & Thứ 5: 19:30 - 21:30)
INSERT INTO #TmpSessions VALUES
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-05', '19:30:00', '21:30:00', N'Lesson 01: Advanced Tenses & Passive Voice Transformations', 'COMPLETED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-08', '19:30:00', '21:30:00', N'Lesson 02: Relative Clauses & Reduced Clauses Masterclass', 'COMPLETED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-12', '19:30:00', '21:30:00', N'Lesson 03: Conditionals, Inversion & Mixed Conditionals', 'COMPLETED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-15', '19:30:00', '21:30:00', N'Lesson 04: Phrasal Verbs & Collocations in National Exam', 'COMPLETED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-19', '19:30:00', '21:30:00', N'Lesson 05: Academic Reading Comprehension Strategies', 'COMPLETED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-22', '19:30:00', '21:30:00', N'Lesson 06: Mid-Term Grammar & Vocabulary Assessment Test', 'COMPLETED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-26', '19:30:00', '21:30:00', N'Lesson 07: Error Identification & Sentence Combination', 'SCHEDULED'),
(@ClassEng12_01, @TeacherMai, @RoomP101, '2026-10-29', '19:30:00', '21:30:00', N'Lesson 08: Synonym & Antonym Question Traps and Tips', 'SCHEDULED');

-- 5. Lớp L12-LY-01 (Thứ 3 & Thứ 6: 17:30 - 19:30)
INSERT INTO #TmpSessions VALUES
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-06', '17:30:00', '19:30:00', N'Buổi 01: Dao động điều hòa cơ bản và phương trình vi phân', 'COMPLETED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-09', '17:30:00', '19:30:00', N'Buổi 02: Con lắc lò xo và bài toán cắt ghép lò xo nâng cao', 'COMPLETED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-13', '17:30:00', '19:30:00', N'Buổi 03: Con lắc đơn và các lực lạ (quán tính, điện trường)', 'COMPLETED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-16', '17:30:00', '19:30:00', N'Buổi 04: Dao động tắt dần, dao động duy trì và cộng hưởng cơ', 'COMPLETED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-20', '17:30:00', '19:30:00', N'Buổi 05: Sóng cơ học và phương trình truyền sóng', 'COMPLETED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-23', '17:30:00', '19:30:00', N'Buổi 06: Giao thoa sóng và bài toán đếm số điểm cực đại', 'COMPLETED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-27', '17:30:00', '19:30:00', N'Buổi 07: Sóng dừng trên dây và điều kiện tạo nút, bụng sóng', 'SCHEDULED'),
(@ClassLy12_01, @TeacherTuan, @RoomP301, '2026-10-30', '17:30:00', '19:30:00', N'Buổi 08: Sóng âm, mức cường độ âm và họa âm nhạc cụ', 'SCHEDULED');

-- 6. Lớp L12-HOA-01 (Thứ 2 & Thứ 5: 17:30 - 19:30)
INSERT INTO #TmpSessions VALUES
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-05', '17:30:00', '19:30:00', N'Buổi 01: Este & Lipit - Đồng phân, danh pháp và tính chất thủy phân', 'COMPLETED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-08', '17:30:00', '19:30:00', N'Buổi 02: Phương pháp quy đổi este đa chức và biện luận cấu tạo', 'COMPLETED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-12', '17:30:00', '19:30:00', N'Buổi 03: Cacbohiđrat: Glucozơ, saccarozơ, tinh bột và xenlulozơ', 'COMPLETED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-15', '17:30:00', '19:30:00', N'Buổi 04: Amin, amino axit và peptit - Cơ chế phản ứng và nhận biết', 'COMPLETED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-19', '17:30:00', '19:30:00', N'Buổi 05: Thủy phân peptit và bài toán bảo toàn liên kết peptit', 'COMPLETED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-22', '17:30:00', '19:30:00', N'Buổi 06: Polime và vật liệu polime - Kỹ năng giải câu hỏi lý thuyết', 'COMPLETED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-26', '17:30:00', '19:30:00', N'Buổi 07: Đại cương kim loại: Cấu tạo, liên kết và ăn mòn điện hóa', 'SCHEDULED'),
(@ClassHoa12_01, @TeacherLan, @RoomP302, '2026-10-29', '17:30:00', '19:30:00', N'Buổi 08: Kim loại kiềm, kiềm thổ và nhôm - Chuyên đề nhiệt nhôm', 'SCHEDULED');

-- 7. Lớp L12-VAN-01 (Chủ Nhật: 08:30 - 11:30)
INSERT INTO #TmpSessions VALUES
(@ClassVan12_01, @TeacherPhuong, @RoomP101, '2026-10-04', '08:30:00', '11:30:00', N'Chuyên đề 01: Tuyên ngôn Độc lập - Phong cách văn chính luận Hồ Chí Minh', 'COMPLETED'),
(@ClassVan12_01, @TeacherPhuong, @RoomP101, '2026-10-11', '08:30:00', '11:30:00', N'Chuyên đề 02: Tây Tiến (Quang Dũng) - Bức tượng đài bi tráng về người lính', 'COMPLETED'),
(@ClassVan12_01, @TeacherPhuong, @RoomP101, '2026-10-18', '08:30:00', '11:30:00', N'Chuyên đề 03: Việt Bắc (Tố Hữu) - Khúc tráng ca và khúc tình ca cách mạng', 'COMPLETED'),
(@ClassVan12_01, @TeacherPhuong, @RoomP101, '2026-10-25', '08:30:00', '11:30:00', N'Chuyên đề 04: Sóng (Xuân Quỳnh) - Vẻ đẹp tâm hồn người phụ nữ trong tình yêu', 'SCHEDULED'),
(@ClassVan12_01, @TeacherPhuong, @RoomP101, '2026-11-01', '08:30:00', '11:30:00', N'Chuyên đề 05: Đất Nước (Nguyễn Khoa Điềm) - Cảm nhận mới mẻ về đất nước nhân dân', 'SCHEDULED');

-- Nạp vào dbo.ClassSessions (tránh trùng lặp)
INSERT INTO dbo.ClassSessions (class_id, teacher_id, room_id, session_date, start_at, end_at, title, status, created_at)
SELECT t.class_id, t.teacher_id, t.room_id, t.session_date, t.start_at, t.end_at, t.title, t.status, GETDATE()
FROM #TmpSessions t
WHERE t.class_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM dbo.ClassSessions cs 
    WHERE cs.class_id = t.class_id 
      AND cs.session_date = t.session_date 
      AND cs.start_at = t.start_at
);

DROP TABLE #TmpSessions;
GO

PRINT N'Hoàn thành Bước 06: Khởi tạo đầy đủ 50+ ca học thực tế trải dài các tuần từ Tháng 10 đến Tháng 11/2026!';
GO
