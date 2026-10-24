-- ============================================================================
-- EDUCENTER ERP - BƯỚC 07: KHỞI TẠO GHI DANH (ENROLLMENTS), HÓA ĐƠN & PHIẾU THU
-- ============================================================================

USE EduCenterDB;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

-- 1. Ghi danh học viên vào các lớp (Enrollments)
DECLARE @L12_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-01');
DECLARE @L12_TOAN_02 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-TOAN-02');
DECLARE @L12_DGNL_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-DGNL-01');
DECLARE @L11_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-TOAN-01');
DECLARE @L10_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-TOAN-01');
DECLARE @L09_TOAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L09-TOAN-01');

DECLARE @L12_ENG_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-ENG-01');
DECLARE @L09_ENG_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L09-ENG-01');
DECLARE @L10_ENG_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-ENG-01');
DECLARE @L11_IELTS_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-IELTS-01');
DECLARE @L12_IELTS_02 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-IELTS-02');

DECLARE @L12_LY_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-LY-01');
DECLARE @L11_LY_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-LY-01');
DECLARE @L10_LY_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-LY-01');

DECLARE @L12_HOA_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-HOA-01');
DECLARE @L11_HOA_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-HOA-01');
DECLARE @L10_HOA_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-HOA-01');

DECLARE @L12_SINH_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-SINH-01');
DECLARE @L11_SINH_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L11-SINH-01');

DECLARE @L12_VAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L12-VAN-01');
DECLARE @L10_VAN_01 BIGINT = (SELECT id FROM dbo.Classes WHERE code = 'L10-VAN-01');

-- Học viên
DECLARE @sNam BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.nam@educenter.vn');
DECLARE @sMai BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.mai@educenter.vn');
DECLARE @sPhong BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.phong@educenter.vn');
DECLARE @sAnh BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.anh@educenter.vn');
DECLARE @sHuy BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.huy@educenter.vn');
DECLARE @sTrang BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.trang@educenter.vn');
DECLARE @sKhoi BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.khoi@educenter.vn');
DECLARE @sVy BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.vy@educenter.vn');
DECLARE @sBach BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.bach@educenter.vn');
DECLARE @sNgan BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.ngan@educenter.vn');
DECLARE @sMinh BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.minh@educenter.vn');
DECLARE @sChau BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.chau@educenter.vn');
DECLARE @sKien BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.kien@educenter.vn');
DECLARE @sHa BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.ha@educenter.vn');
DECLARE @sLong BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.long@educenter.vn');
DECLARE @sDuong BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.duong@educenter.vn');
DECLARE @sQuang BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.quang@educenter.vn');
DECLARE @sThao BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.thao@educenter.vn');
DECLARE @sTri BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.tri@educenter.vn');
DECLARE @sChi BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.chi@educenter.vn');
DECLARE @sHung BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.hung@educenter.vn');
DECLARE @sLinh BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.linh@educenter.vn');
DECLARE @sDuc BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.duc@educenter.vn');
DECLARE @sHoa BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.hoa@educenter.vn');
DECLARE @sQuan BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.quan@educenter.vn');
DECLARE @sGiang BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.giang@educenter.vn');
DECLARE @sTung BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.tung@educenter.vn');
DECLARE @sLan BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.lan@educenter.vn');
DECLARE @sPhuoc BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.phuoc@educenter.vn');
DECLARE @sMy BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.my@educenter.vn');

CREATE TABLE #TmpEnroll (
    student_id BIGINT,
    class_id BIGINT,
    start_date DATE,
    status VARCHAR(20),
    notes NVARCHAR(500)
);

INSERT INTO #TmpEnroll VALUES
-- 1. Học sinh lớp 12
-- Nam (Khối A01 & DGNL)
(@sNam, @L12_TOAN_01, '2026-09-01', 'ACTIVE', N'Ghi danh khóa Toán 12 trọng điểm Thầy Hùng'),
(@sNam, @L12_ENG_01, '2026-09-01', 'ACTIVE', N'Ghi danh khóa Tiếng Anh 12 Cô Mai'),
(@sNam, @L12_LY_01, '2026-09-01', 'ACTIVE', N'Ghi danh khóa Vật lý 12 Thầy Tuấn'),
(@sNam, @L12_DGNL_01, '2026-10-01', 'ACTIVE', N'Khóa ĐGNL ĐHQG cuối tuần'),

-- Phong (Khối A00 & DGNL)
(@sPhong, @L12_TOAN_01, '2026-09-01', 'ACTIVE', N'Luyện thi khối A00 điểm cao'),
(@sPhong, @L12_LY_01, '2026-09-01', 'ACTIVE', N'Luyện thi khối A00 Thầy Tuấn'),
(@sPhong, @L12_HOA_01, '2026-09-01', 'ACTIVE', N'Luyện thi khối A00 Cô Lan'),
(@sPhong, @L12_DGNL_01, '2026-10-01', 'ACTIVE', N'Luyện thi ĐGNL ĐHQG'),

-- Kiên (Khối A01)
(@sKien, @L12_TOAN_01, '2026-09-01', 'ACTIVE', N'Học sinh khối A01'),
(@sKien, @L12_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 12 nâng cao'),
(@sKien, @L12_DGNL_01, '2026-10-01', 'ACTIVE', N'Đăng ký thêm lớp ĐGNL cuối tuần'),

-- Ngân (Khối D01)
(@sNgan, @L12_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 12 chuẩn bị kỳ thi tốt nghiệp'),
(@sNgan, @L12_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 12 bứt phá điểm 9'),
(@sNgan, @L12_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ Văn 12 chuyên đề tác phẩm'),

-- Đức (Chuyên Tin Amsterdam - Khối A00 & IELTS)
(@sDuc, @L12_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 12 mục tiêu Bách Khoa IT'),
(@sDuc, @L12_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 12 luyện đề thực chiến'),
(@sDuc, @L12_IELTS_02, '2026-10-01', 'ACTIVE', N'IELTS 7.5+ Intensive'),
(@sDuc, @L12_DGNL_01, '2026-10-01', 'ACTIVE', N'ĐGNL ĐHQG Hà Nội'),

-- Tùng (Việt Đức - Khối A00)
(@sTung, @L12_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 12 mục tiêu 8.5+'),
(@sTung, @L12_LY_01, '2026-09-01', 'ACTIVE', N'Vật Lý 12 Thầy Tuấn'),
(@sTung, @L12_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 12 Cô Mai'),

-- Long (Nguyễn Siêu - Khối A01 & IELTS)
(@sLong, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 bứt phá điểm 9'),
(@sLong, @L12_IELTS_02, '2026-10-01', 'ACTIVE', N'IELTS 7.5+ Target du học Úc'),
(@sLong, @L12_DGNL_01, '2026-10-01', 'ACTIVE', N'ĐGNL ĐHQG cuối tuần'),

-- Trí (Chuyên Ngoại Ngữ - Khối D & IELTS)
(@sTri, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 bứt phá điểm 9'),
(@sTri, @L12_IELTS_02, '2026-10-01', 'ACTIVE', N'IELTS 7.5+ chuyên sâu Writing'),
(@sTri, @L12_DGNL_01, '2026-10-01', 'ACTIVE', N'Toán tư duy định lượng'),

-- Linh (Chuyên KHTN - Khối B00 Y Dược)
(@sLinh, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 chuyên sâu điểm 9+'),
(@sLinh, @L12_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 12 Cô Lan mục tiêu 9.5'),
(@sLinh, @L12_SINH_01, '2026-10-01', 'ACTIVE', N'Sinh học 12 Thầy Hoàng bồi dưỡng Y Dược'),

-- Vy (Cầu Giấy - Khối B00 Y Dược)
(@sVy, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 Thầy Hùng'),
(@sVy, @L12_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 12 Cô Lan'),
(@sVy, @L12_SINH_01, '2026-10-01', 'ACTIVE', N'Sinh học 12 chuyên đề di truyền'),
(@sVy, @L12_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ Văn 12 tốt nghiệp'),

-- Mỹ (Phan Đình Phùng - Khối D07)
(@sMy, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 nhóm bứt phá'),
(@sMy, @L12_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 12 Cô Lan'),
(@sMy, @L12_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 12 Cô Mai'),

-- Huy (Thăng Long - Khối D01)
(@sHuy, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 bứt phá'),
(@sHuy, @L12_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 12'),
(@sHuy, @L12_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ văn 12 điểm 8.5+'),

-- Khôi (Chu Văn An - Khối A01)
(@sKhoi, @L12_TOAN_02, '2026-09-15', 'ACTIVE', N'Toán 12 Thầy Hùng'),
(@sKhoi, @L12_LY_01, '2026-09-01', 'ACTIVE', N'Vật Lý 12 Thầy Tuấn'),
(@sKhoi, @L12_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 12 Cô Mai'),

-- 2. Học sinh lớp 11
-- Mai (Yên Hòa - Khối D & IELTS)
(@sMai, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Ghi danh lớp Toán 11 Nâng cao'),
(@sMai, @L11_IELTS_01, '2026-10-01', 'ACTIVE', N'Lớp IELTS Foundation 6.5+'),
(@sMai, @L11_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 11 Cô Lan'),

-- Trang (Việt Đức - Khối D & IELTS)
(@sTrang, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Học bạ Toán 11 điểm 9+'),
(@sTrang, @L11_IELTS_01, '2026-10-01', 'ACTIVE', N'IELTS Academic 6.5+'),

-- Châu (Chuyên Sư Phạm - Khối D & IELTS)
(@sChau, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 11 hình không gian chuyên sâu'),
(@sChau, @L11_IELTS_01, '2026-10-01', 'ACTIVE', N'IELTS Academic Foundation'),
(@sChau, @L11_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 11 nâng cao'),

-- Minh (Marie Curie - Khối A)
(@sMinh, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 11 Thầy Hùng'),
(@sMinh, @L11_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 11 Thầy Tuấn'),

-- Dương (Lê Quý Đôn - Khối A & B)
(@sDuong, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 11 lượng giác'),
(@sDuong, @L11_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 11 hữu cơ'),
(@sDuong, @L11_SINH_01, '2026-10-01', 'ACTIVE', N'Sinh học 11 nâng cao'),

-- Chi (Kim Liên - Khối D & IELTS)
(@sChi, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 11 học kỳ I'),
(@sChi, @L11_IELTS_01, '2026-10-01', 'ACTIVE', N'IELTS Foundation 6.5+'),

-- Quân (Thăng Long - Khối A)
(@sQuan, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 11 nâng cao'),
(@sQuan, @L11_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 11 sóng cơ'),

-- Lan (Lương Thế Vinh - Khối B)
(@sLan, @L11_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 11 Thầy Hùng'),
(@sLan, @L11_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa 11 Cô Lan'),
(@sLan, @L11_SINH_01, '2026-10-01', 'ACTIVE', N'Sinh học 11 Thầy Hoàng'),

-- 3. Học sinh lớp 10
-- Anh (Kim Liên)
(@sAnh, @L10_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 10 Thầy Nam'),
(@sAnh, @L10_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 10 Cô Mai'),
(@sAnh, @L10_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa học 10 Cô Lan'),
(@sAnh, @L10_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ văn 10 Cô Ngọc'),

-- Bách (Lương Thế Vinh)
(@sBach, @L10_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 10 Thầy Nam'),
(@sBach, @L10_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 10 Thầy Tuấn'),
(@sBach, @L10_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 10'),

-- Hà (Yên Hòa)
(@sHa, @L10_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 10 GDPT 2018'),
(@sHa, @L10_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 10'),
(@sHa, @L10_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa 10'),
(@sHa, @L10_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ Văn 10 Cô Ngọc'),

-- Quang (Đống Đa)
(@sQuang, @L10_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 10 cơ bản và nâng cao'),
(@sQuang, @L10_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 10'),
(@sQuang, @L10_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ Văn 10'),

-- Hùng (Chu Văn An)
(@sHung, @L10_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 10 Thầy Nam'),
(@sHung, @L10_LY_01, '2026-09-01', 'ACTIVE', N'Vật lý 10 Thầy Tuấn'),
(@sHung, @L10_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa 10 Cô Lan'),

-- Giang (Yên Hòa)
(@sGiang, @L10_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 10 Thầy Nam'),
(@sGiang, @L10_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 10 Cô Mai'),
(@sGiang, @L10_HOA_01, '2026-09-01', 'ACTIVE', N'Hóa 10 Cô Lan'),
(@sGiang, @L10_VAN_01, '2026-09-01', 'ACTIVE', N'Ngữ văn 10 Cô Ngọc'),

-- 4. Học sinh lớp 9
-- Thảo (Archimedes)
(@sThao, @L09_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 9 ôn thi vào 10 chuyên'),
(@sThao, @L09_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 9 vào 10 chuyên'),

-- Hoa (Thực Nghiệm)
(@sHoa, @L09_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 9 vào 10 công lập'),
(@sHoa, @L09_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 9 Cô Mai'),

-- Phước (Marie Curie)
(@sPhuoc, @L09_TOAN_01, '2026-09-01', 'ACTIVE', N'Toán 9 Thầy Nam'),
(@sPhuoc, @L09_ENG_01, '2026-09-01', 'ACTIVE', N'Tiếng Anh 9 Cô Mai');

INSERT INTO dbo.Enrollments (student_id, class_id, enrolled_at, start_date, status, notes, created_at, updated_at)
SELECT t.student_id, t.class_id, DATEADD(day, -5, t.start_date), t.start_date, t.status, t.notes, GETDATE(), GETDATE()
FROM #TmpEnroll t
WHERE t.student_id IS NOT NULL AND t.class_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM dbo.Enrollments e WHERE e.student_id = t.student_id AND e.class_id = t.class_id
);

DROP TABLE #TmpEnroll;
GO

-- 2. Khởi tạo Hóa đơn (Invoices) và Chi tiết hóa đơn (InvoiceItems) cho mọi lượt Enrollment
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');

DECLARE @EnrId BIGINT, @StuId BIGINT, @CourseFee DECIMAL(18,2), @CourseName NVARCHAR(200), @InvCode VARCHAR(50), @InvId BIGINT;

DECLARE curEnroll CURSOR LOCAL FOR
SELECT e.id, e.student_id, c.fee, c.name, 'INV-2026-' + RIGHT('00000' + CAST(e.id AS VARCHAR(10)), 5)
FROM dbo.Enrollments e
JOIN dbo.Classes cl ON cl.id = e.class_id
JOIN dbo.Courses c ON c.id = cl.course_id
WHERE NOT EXISTS (SELECT 1 FROM dbo.Invoices inv WHERE inv.enrollment_id = e.id);

OPEN curEnroll;
FETCH NEXT FROM curEnroll INTO @EnrId, @StuId, @CourseFee, @CourseName, @InvCode;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO dbo.Invoices (invoice_code, enrollment_id, student_id, total_amount, discount_amount, final_amount, status, due_date, notes, version, created_at, updated_at)
    VALUES (@InvCode, @EnrId, @StuId, @CourseFee, 0.00, @CourseFee, 'UNPAID', DATEADD(day, 10, GETDATE()), N'Hóa đơn học phí khóa ' + @CourseName, 0, GETDATE(), GETDATE());

    SET @InvId = SCOPE_IDENTITY();

    INSERT INTO dbo.InvoiceItems (invoice_id, description, unit_price, quantity, amount, created_at)
    VALUES (@InvId, N'Học phí niêm yết trọn khóa - ' + @CourseName, @CourseFee, 1, @CourseFee, GETDATE());

    FETCH NEXT FROM curEnroll INTO @EnrId, @StuId, @CourseFee, @CourseName, @InvCode;
END;

CLOSE curEnroll;
DEALLOCATE curEnroll;
GO

-- 3. Tạo các phiếu thu thanh toán mẫu phân bổ đều theo 6 tháng (T5 đến T10/2026)
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');

-- Bảng tạm phân bổ thanh toán
CREATE TABLE #TmpPay (
    student_email VARCHAR(100),
    class_code VARCHAR(50),
    amount DECIMAL(18,2),
    method VARCHAR(20),
    pay_date DATETIME2,
    receipt VARCHAR(50),
    note NVARCHAR(255)
);

INSERT INTO #TmpPay VALUES
-- THÁNG 5/2026: ~45.0Tr
('student.anh@educenter.vn', 'L10-TOAN-01', 3600000.00, 'BANK_TRANSFER', '2026-05-10 09:15:00', 'PT-2026-0501', N'Phụ huynh chuyển khoản ngân hàng Vietcombank'),
('student.anh@educenter.vn', 'L10-ENG-01', 3600000.00, 'BANK_TRANSFER', '2026-05-10 09:20:00', 'PT-2026-0502', N'Đóng học phí Tiếng Anh 10'),
('student.bach@educenter.vn', 'L10-TOAN-01', 3600000.00, 'CASH', '2026-05-15 14:30:00', 'PT-2026-0503', N'Đóng trực tiếp tại quầy tuyển sinh'),
('student.bach@educenter.vn', 'L10-LY-01', 3400000.00, 'BANK_TRANSFER', '2026-05-18 10:00:00', 'PT-2026-0504', N'Thanh toán học phí Vật lý 10'),
('student.thao@educenter.vn', 'L09-TOAN-01', 3600000.00, 'VNPAY', '2026-05-22 16:45:00', 'PT-2026-0505', N'Thanh toán qua cổng VNPAY'),
('student.thao@educenter.vn', 'L09-ENG-01', 3600000.00, 'BANK_TRANSFER', '2026-05-25 11:30:00', 'PT-2026-0506', N'Chuyển khoản lớp Anh 9 chuyên'),
('student.hoa@educenter.vn', 'L09-TOAN-01', 3600000.00, 'MOMO', '2026-05-28 18:20:00', 'PT-2026-0507', N'Ví MoMo phụ huynh'),
('student.phuoc@educenter.vn', 'L09-TOAN-01', 3600000.00, 'CASH', '2026-05-29 15:00:00', 'PT-2026-0508', N'Nộp tiền mặt tại phòng học vụ'),

-- THÁNG 6/2026: ~68.0Tr
('student.quang@educenter.vn', 'L10-TOAN-01', 3600000.00, 'BANK_TRANSFER', '2026-06-05 08:30:00', 'PT-2026-0601', N'Phụ huynh Thành chuyển khoản Techcombank'),
('student.quang@educenter.vn', 'L10-LY-01', 3400000.00, 'BANK_TRANSFER', '2026-06-05 08:35:00', 'PT-2026-0602', N'Đóng combo Toán - Lý 10'),
('student.hung@educenter.vn', 'L10-TOAN-01', 3600000.00, 'VNPAY', '2026-06-12 14:15:00', 'PT-2026-0603', N'Cổng VNPAY QR'),
('student.hung@educenter.vn', 'L10-LY-01', 3400000.00, 'BANK_TRANSFER', '2026-06-15 10:20:00', 'PT-2026-0604', N'Chuyển khoản qua BIDV'),
('student.giang@educenter.vn', 'L10-TOAN-01', 3600000.00, 'BANK_TRANSFER', '2026-06-18 16:30:00', 'PT-2026-0605', N'Chuyển khoản phụ huynh Lan'),
('student.giang@educenter.vn', 'L10-ENG-01', 3600000.00, 'BANK_TRANSFER', '2026-06-20 09:45:00', 'PT-2026-0606', N'Học phí Tiếng Anh 10'),
('student.ha@educenter.vn', 'L10-TOAN-01', 3600000.00, 'CASH', '2026-06-22 17:15:00', 'PT-2026-0607', N'Tiền mặt phòng tuyển sinh'),
('student.hoa@educenter.vn', 'L09-ENG-01', 3600000.00, 'MOMO', '2026-06-25 11:20:00', 'PT-2026-0608', N'Thanh toán qua ví MoMo'),
('student.phuoc@educenter.vn', 'L09-ENG-01', 3600000.00, 'BANK_TRANSFER', '2026-06-28 14:00:00', 'PT-2026-0609', N'Học phí Anh 9 vào 10'),

-- THÁNG 7/2026: ~95.0Tr
('student.mai@educenter.vn', 'L11-TOAN-01', 4200000.00, 'BANK_TRANSFER', '2026-07-02 09:30:00', 'PT-2026-0701', N'Phụ huynh Lan đóng học phí Toán 11'),
('student.trang@educenter.vn', 'L11-TOAN-01', 4200000.00, 'VNPAY', '2026-07-08 15:40:00', 'PT-2026-0702', N'Thanh toán VNPAY QR'),
('student.chau@educenter.vn', 'L11-TOAN-01', 4200000.00, 'BANK_TRANSFER', '2026-07-12 11:00:00', 'PT-2026-0703', N'Học phí Toán 11 Nâng cao'),
('student.minh@educenter.vn', 'L11-TOAN-01', 4200000.00, 'CASH', '2026-07-15 16:30:00', 'PT-2026-0704', N'Tiền mặt tại trung tâm'),
('student.duong@educenter.vn', 'L11-TOAN-01', 4200000.00, 'BANK_TRANSFER', '2026-07-18 10:15:00', 'PT-2026-0705', N'Chuyển khoản Vietcombank'),
('student.chi@educenter.vn', 'L11-TOAN-01', 4200000.00, 'MOMO', '2026-07-22 19:00:00', 'PT-2026-0706', N'Ví MoMo phụ huynh'),
('student.quan@educenter.vn', 'L11-TOAN-01', 4200000.00, 'BANK_TRANSFER', '2026-07-25 14:20:00', 'PT-2026-0707', N'Chuyển khoản Agribank'),
('student.lan@educenter.vn', 'L11-TOAN-01', 4200000.00, 'BANK_TRANSFER', '2026-07-28 09:50:00', 'PT-2026-0708', N'Học phí Toán 11 Thầy Hùng'),
('student.minh@educenter.vn', 'L11-LY-01', 3800000.00, 'CASH', '2026-07-29 17:00:00', 'PT-2026-0709', N'Đóng học phí Lý 11'),

-- THÁNG 8/2026: ~135.0Tr
('student.nam@educenter.vn', 'L12-TOAN-01', 4800000.00, 'BANK_TRANSFER', '2026-08-03 08:45:00', 'PT-2026-0801', N'Phụ huynh Tuấn chuyển khoản khóa Toán 12'),
('student.phong@educenter.vn', 'L12-TOAN-01', 4800000.00, 'BANK_TRANSFER', '2026-08-05 10:15:00', 'PT-2026-0802', N'Đóng học phí Toán 12 Thầy Hùng'),
('student.kien@educenter.vn', 'L12-TOAN-01', 4800000.00, 'VNPAY', '2026-08-08 14:30:00', 'PT-2026-0803', N'Cổng thanh toán trực tuyến VNPAY'),
('student.ngan@educenter.vn', 'L12-TOAN-01', 4800000.00, 'BANK_TRANSFER', '2026-08-12 11:20:00', 'PT-2026-0804', N'Chuyển khoản Vietinbank'),
('student.duc@educenter.vn', 'L12-TOAN-01', 4800000.00, 'BANK_TRANSFER', '2026-08-15 09:00:00', 'PT-2026-0805', N'Toán 12 nhóm điểm 9+'),
('student.tung@educenter.vn', 'L12-TOAN-01', 4800000.00, 'CASH', '2026-08-18 16:00:00', 'PT-2026-0806', N'Nộp tiền mặt tại quầy'),
('student.long@educenter.vn', 'L12-TOAN-02', 4800000.00, 'BANK_TRANSFER', '2026-08-20 15:10:00', 'PT-2026-0807', N'Học phí Toán 12 bứt phá'),
('student.tri@educenter.vn', 'L12-TOAN-02', 4800000.00, 'MOMO', '2026-08-22 18:30:00', 'PT-2026-0808', N'Ví điện tử MoMo'),
('student.linh@educenter.vn', 'L12-TOAN-02', 4800000.00, 'BANK_TRANSFER', '2026-08-25 10:40:00', 'PT-2026-0809', N'Chuyển khoản ngân hàng VPBank'),
('student.vy@educenter.vn', 'L12-TOAN-02', 4800000.00, 'BANK_TRANSFER', '2026-08-28 14:00:00', 'PT-2026-0810', N'Chuyển khoản MB Bank'),

-- THÁNG 9/2026: ~190.0Tr
('student.nam@educenter.vn', 'L12-ENG-01', 4200000.00, 'BANK_TRANSFER', '2026-09-02 09:15:00', 'PT-2026-0901', N'Học phí Tiếng Anh 12'),
('student.nam@educenter.vn', 'L12-LY-01', 4500000.00, 'BANK_TRANSFER', '2026-09-02 09:20:00', 'PT-2026-0902', N'Học phí Vật lý 12'),
('student.phong@educenter.vn', 'L12-LY-01', 4500000.00, 'BANK_TRANSFER', '2026-09-05 10:30:00', 'PT-2026-0903', N'Vật lý 12 Thầy Tuấn'),
('student.phong@educenter.vn', 'L12-HOA-01', 4500000.00, 'BANK_TRANSFER', '2026-09-05 10:35:00', 'PT-2026-0904', N'Hóa học 12 Cô Lan'),
('student.duc@educenter.vn', 'L12-LY-01', 4500000.00, 'VNPAY', '2026-09-08 14:00:00', 'PT-2026-0905', N'Thanh toán trực tuyến VNPAY'),
('student.duc@educenter.vn', 'L12-IELTS-02', 7500000.00, 'BANK_TRANSFER', '2026-09-10 11:00:00', 'PT-2026-0906', N'Học phí IELTS Intensive 7.5+'),
('student.long@educenter.vn', 'L12-IELTS-02', 7500000.00, 'BANK_TRANSFER', '2026-09-12 16:20:00', 'PT-2026-0907', N'Khóa IELTS 7.5+ Target du học'),
('student.tri@educenter.vn', 'L12-IELTS-02', 7500000.00, 'MOMO', '2026-09-15 19:30:00', 'PT-2026-0908', N'Thanh toán MoMo'),
('student.mai@educenter.vn', 'L11-IELTS-01', 6500000.00, 'BANK_TRANSFER', '2026-09-18 10:00:00', 'PT-2026-0909', N'Khóa IELTS Foundation Cô Mai Anh'),
('student.trang@educenter.vn', 'L11-IELTS-01', 6500000.00, 'BANK_TRANSFER', '2026-09-20 14:15:00', 'PT-2026-0910', N'IELTS 6.5+ Cô Mai Anh'),
('student.chau@educenter.vn', 'L11-IELTS-01', 6500000.00, 'CASH', '2026-09-22 17:00:00', 'PT-2026-0911', N'Nộp tiền mặt tại trung tâm'),
('student.linh@educenter.vn', 'L12-HOA-01', 4500000.00, 'BANK_TRANSFER', '2026-09-25 11:30:00', 'PT-2026-0912', N'Hóa học 12 chuyên sâu'),
('student.vy@educenter.vn', 'L12-HOA-01', 4500000.00, 'BANK_TRANSFER', '2026-09-28 15:45:00', 'PT-2026-0913', N'Hóa học 12 Cô Lan'),

-- THÁNG 10/2026: ~235.0Tr
('student.nam@educenter.vn', 'L12-DGNL-01', 3800000.00, 'BANK_TRANSFER', '2026-10-02 08:30:00', 'PT-2026-1001', N'Đóng khóa ĐGNL ĐHQG Thầy Hùng'),
('student.phong@educenter.vn', 'L12-DGNL-01', 3800000.00, 'BANK_TRANSFER', '2026-10-02 08:35:00', 'PT-2026-1002', N'Khóa ĐGNL ĐHQG'),
('student.kien@educenter.vn', 'L12-DGNL-01', 3800000.00, 'VNPAY', '2026-10-05 14:10:00', 'PT-2026-1003', N'VNPAY cổng thanh toán'),
('student.duc@educenter.vn', 'L12-DGNL-01', 3800000.00, 'BANK_TRANSFER', '2026-10-06 10:20:00', 'PT-2026-1004', N'ĐGNL cuối tuần'),
('student.long@educenter.vn', 'L12-DGNL-01', 3800000.00, 'MOMO', '2026-10-08 17:00:00', 'PT-2026-1005', N'Ví điện tử MoMo'),
('student.tri@educenter.vn', 'L12-DGNL-01', 3800000.00, 'BANK_TRANSFER', '2026-10-10 11:45:00', 'PT-2026-1006', N'Toán tư duy định lượng'),
('student.linh@educenter.vn', 'L12-SINH-01', 3800000.00, 'BANK_TRANSFER', '2026-10-12 15:30:00', 'PT-2026-1007', N'Khóa Sinh 12 Thầy Hoàng bồi dưỡng Y Dược'),
('student.vy@educenter.vn', 'L12-SINH-01', 3800000.00, 'BANK_TRANSFER', '2026-10-14 09:20:00', 'PT-2026-1008', N'Sinh học 12 Thầy Hoàng'),
('student.my@educenter.vn', 'L12-SINH-01', 3800000.00, 'CASH', '2026-10-15 16:40:00', 'PT-2026-1009', N'Tiền mặt phòng kế toán'),
('student.huy@educenter.vn', 'L12-VAN-01', 4000000.00, 'BANK_TRANSFER', '2026-10-16 11:00:00', 'PT-2026-1010', N'Ngữ văn 12 Cô Phương'),
('student.ngan@educenter.vn', 'L12-VAN-01', 4000000.00, 'MOMO', '2026-10-18 19:15:00', 'PT-2026-1011', N'MoMo đóng học phí Văn'),
('student.tung@educenter.vn', 'L12-VAN-01', 4000000.00, 'BANK_TRANSFER', '2026-10-20 14:00:00', 'PT-2026-1012', N'Chuyển khoản lớp Văn 12'),
('student.chi@educenter.vn', 'L11-IELTS-01', 6500000.00, 'BANK_TRANSFER', '2026-10-21 10:30:00', 'PT-2026-1013', N'IELTS Foundation 6.5+'),
('student.duong@educenter.vn', 'L11-IELTS-01', 6500000.00, 'VNPAY', '2026-10-22 15:00:00', 'PT-2026-1014', N'VNPAY đóng học phí IELTS');

-- Thực hiện nạp Payments và cập nhật trạng thái Invoices
DECLARE @pEmail VARCHAR(100), @pClass VARCHAR(50), @pAmount DECIMAL(18,2), @pMethod VARCHAR(20), @pDate DATETIME2, @pReceipt VARCHAR(50), @pNote NVARCHAR(255);
DECLARE @pInvId BIGINT;

DECLARE curPay CURSOR LOCAL FOR
SELECT student_email, class_code, amount, method, pay_date, receipt, note FROM #TmpPay;

OPEN curPay;
FETCH NEXT FROM curPay INTO @pEmail, @pClass, @pAmount, @pMethod, @pDate, @pReceipt, @pNote;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @pInvId = (
        SELECT TOP 1 i.id 
        FROM dbo.Invoices i
        JOIN dbo.Students s ON s.id = i.student_id
        JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
        WHERE s.email = @pEmail AND cl.code = @pClass
    );

    IF @pInvId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE invoice_id = @pInvId AND payment_code = @pReceipt)
    BEGIN
        INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
        VALUES (@pReceipt, @pInvId, @pAmount, @pMethod, 'TXN-' + @pReceipt, @pDate, @StaffLinh, @pNote, 'CONFIRMED', @pDate);

        UPDATE dbo.Invoices
        SET status = 'PAID', updated_at = @pDate
        WHERE id = @pInvId;
    END;

    FETCH NEXT FROM curPay INTO @pEmail, @pClass, @pAmount, @pMethod, @pDate, @pReceipt, @pNote;
END;

CLOSE curPay;
DEALLOCATE curPay;
DROP TABLE #TmpPay;
GO

PRINT N'Hoàn thành Bước 07: Khởi tạo 80+ ghi danh, hóa đơn đồng bộ và phân bổ phiếu thu liên tục 6 tháng T5 đến T10/2026!';
GO
