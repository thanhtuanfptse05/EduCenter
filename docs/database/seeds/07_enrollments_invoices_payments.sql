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
DECLARE @sKien BIGINT = (SELECT id FROM dbo.Students WHERE email = 'student.kien@educenter.vn');

CREATE TABLE #TmpEnroll (
    student_id BIGINT,
    class_id BIGINT,
    start_date DATE,
    status VARCHAR(20),
    notes NVARCHAR(500)
);

INSERT INTO #TmpEnroll VALUES
(@sNam, @ClassToan12_01, '2026-09-01', 'ACTIVE', N'Ghi danh khóa Toán 12 trọng điểm'),
(@sNam, @ClassEng12_01, '2026-09-01', 'ACTIVE', N'Ghi danh khóa Tiếng Anh 12'),
(@sNam, @ClassLy12_01, '2026-09-01', 'ACTIVE', N'Ghi danh khóa Vật lý 12'),

(@sPhong, @ClassToan12_01, '2026-09-01', 'ACTIVE', N'Luyện thi khối A00 điểm cao'),
(@sPhong, @ClassLy12_01, '2026-09-01', 'ACTIVE', N'Luyện thi khối A00'),
(@sPhong, @ClassHoa12_01, '2026-09-01', 'ACTIVE', N'Luyện thi khối A00'),

(@sKien, @ClassToan12_01, '2026-09-01', 'ACTIVE', N'Học sinh khối A01'),
(@sKien, @ClassToanDGNL, '2026-10-01', 'ACTIVE', N'Đăng ký thêm lớp ĐGNL cuối tuần'),

(@sHuy, @ClassToan12_02, '2026-09-15', 'ACTIVE', N'Ghi danh lớp Toán 12 bứt phá điểm 9'),
(@sHuy, @ClassVan12_01, '2026-09-01', 'ACTIVE', N'Ghi danh lớp Ngữ văn 12'),

(@sMai, @ClassToan11_01, '2026-09-01', 'ACTIVE', N'Học sinh lớp 11 Toán nâng cao'),
(@sMai, @ClassEngIelts, '2026-10-01', 'ACTIVE', N'Học sinh lớp IELTS 6.5+'),

(@sTrang, @ClassToan11_01, '2026-09-01', 'RESERVED', N'Bảo lưu 3 tháng do ôn thi đội tuyển HSG ở trường THPT'),
(@sTrang, @ClassEngIelts, '2026-10-01', 'ACTIVE', N'Vẫn tiếp tục theo học lớp IELTS cuối tuần'),

(@sAnh, @ClassToan10_01, '2026-09-01', 'ACTIVE', N'Học sinh lớp 10 củng cố đại số'),
(@sBach, @ClassToan10_01, '2026-09-01', 'ACTIVE', N'Học sinh lớp 10 hình học'),

(@sKhoi, @ClassEng09_01, '2026-09-01', 'ACTIVE', N'Học sinh lớp 9 ôn thi vào 10 chuyên'),
(@sVy, @ClassHoa12_01, '2026-09-01', 'ACTIVE', N'Học sinh khối B00'),

(@sMinh, @ClassLy11_01, '2026-09-01', 'ACTIVE', N'Học sinh lớp 11 Vật lý'),
(@sMinh, @ClassHoa11_01, '2026-09-01', 'ACTIVE', N'Học sinh lớp 11 Hóa học'),

(@sNgan, @ClassToan12_01, '2026-09-01', 'TRANSFERRED', N'Đã chuyển sang lớp L12-TOAN-02 từ giữa tháng 9'),
(@sNgan, @ClassToan12_02, '2026-09-15', 'ACTIVE', N'Lớp đích tiếp nhận sau khi chuyển lớp');

INSERT INTO dbo.Enrollments (student_id, class_id, enrolled_at, start_date, status, notes, created_at, updated_at)
SELECT t.student_id, t.class_id, DATEADD(day, -5, t.start_date), t.start_date, t.status, t.notes, GETDATE(), GETDATE()
FROM #TmpEnroll t
WHERE t.student_id IS NOT NULL AND t.class_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM dbo.Enrollments e WHERE e.student_id = t.student_id AND e.class_id = t.class_id
);

DROP TABLE #TmpEnroll;
GO

-- 2. Khởi tạo Hóa đơn (Invoices) và Chi tiết hóa đơn (InvoiceItems)
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');

-- Duyệt qua từng Enrollment để tạo Hóa đơn tương ứng nếu chưa có
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

-- 3. Tạo các giao dịch thanh toán mẫu đa dạng qua 6 tháng (T5 đến T10/2026)
DECLARE @StaffLinh BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff.linh@educenter.vn');
DECLARE @StaffHa BIGINT = (SELECT id FROM dbo.Users WHERE email = 'staff@educenter.vn');

-- Helper procedure logic bằng script SQL tuần tự

-- ==================== THÁNG 5/2026 (T5/2026: ~12.0Tr) ====================
-- T5.1: Đỗ Quỳnh Anh (Toán 10) - 3.6Tr
DECLARE @InvAnhToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.anh@educenter.vn' AND cl.code = 'L10-TOAN-01'
);
IF @InvAnhToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202605-001')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202605-001', @InvAnhToan, 3600000.00, 'BANK_TRANSFER', 'TXN-VCB-20260512-001', '2026-05-12 10:15:00', @StaffLinh, N'Phụ huynh thanh toán học phí Toán 10 học kỳ hè', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvAnhToan;
END

-- T5.2: Trịnh Kim Ngân (Toán 12) - 4.8Tr
DECLARE @InvNganToan1 BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.ngan@educenter.vn' AND cl.code = 'L12-TOAN-01'
);
IF @InvNganToan1 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202605-002')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202605-002', @InvNganToan1, 4800000.00, 'BANK_TRANSFER', 'TXN-TCB-20260518-002', '2026-05-18 14:30:00', @StaffHa, N'Chuyển khoản học phí trọn gói Toán 12', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvNganToan1;
END

-- T5.3: Phan Minh Khôi (Tiếng Anh 9) - 3.6Tr
DECLARE @InvKhoiEng BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.khoi@educenter.vn' AND cl.code = 'L09-ENG-01'
);
IF @InvKhoiEng IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202605-003')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202605-003', @InvKhoiEng, 3600000.00, 'CASH', NULL, '2026-05-25 09:45:00', @StaffHa, N'Đóng học phí trực tiếp tại quầy tuyển sinh', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvKhoiEng;
END

-- ==================== THÁNG 6/2026 (T6/2026: ~15.4Tr) ====================
-- T6.1: Lê Thị Hoàng Mai (Toán 11) - 4.2Tr
DECLARE @InvMaiToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.mai@educenter.vn' AND cl.code = 'L11-TOAN-01'
);
IF @InvMaiToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202606-001')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202606-001', @InvMaiToan, 4200000.00, 'BANK_TRANSFER', 'TXN-MBB-20260608-001', '2026-06-08 11:20:00', @StaffLinh, N'Thanh toán học phí lớp Toán 11 nâng cao', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvMaiToan;
END

-- T6.2: Phạm Trung Kiên (Toán ĐGNL) - 3.8Tr
DECLARE @InvKienDGNL BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.kien@educenter.vn' AND cl.code = 'L12-DGNL-01'
);
IF @InvKienDGNL IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202606-002')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202606-002', @InvKienDGNL, 3800000.00, 'BANK_TRANSFER', 'TXN-BIDV-20260615-002', '2026-06-15 15:00:00', @StaffLinh, N'Học phí chuyên đề Toán Tư duy ĐGNL', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvKienDGNL;
END

-- T6.3: Đặng Tuấn Minh (Vật Lý 11) - 3.8Tr
DECLARE @InvMinhLy BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.minh@educenter.vn' AND cl.code = 'L11-LY-01'
);
IF @InvMinhLy IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202606-003')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202606-003', @InvMinhLy, 3800000.00, 'CASH', NULL, '2026-06-22 16:15:00', @StaffHa, N'Thu tiền mặt khóa Vật lý 11', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvMinhLy;
END

-- T6.4: Ngô Xuân Bách (Toán 10) - 3.6Tr
DECLARE @InvBachToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.bach@educenter.vn' AND cl.code = 'L10-TOAN-01'
);
IF @InvBachToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202606-004')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202606-004', @InvBachToan, 3600000.00, 'BANK_TRANSFER', 'TXN-VCB-20260628-003', '2026-06-28 10:30:00', @StaffLinh, N'Phụ huynh chuyển khoản học phí Toán 10', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvBachToan;
END

-- ==================== THÁNG 7/2026 (T7/2026: ~17.0Tr) ====================
-- T7.1: Trần Hoàng Nam (Vật Lý 12) - 4.5Tr
DECLARE @InvNamLy BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.nam@educenter.vn' AND cl.code = 'L12-LY-01'
);
IF @InvNamLy IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202607-001')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202607-001', @InvNamLy, 4500000.00, 'BANK_TRANSFER', 'TXN-VCB-20260705-001', '2026-07-05 09:30:00', @StaffLinh, N'Chuyển khoản học phí khối A Vật lý 12', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvNamLy;
END

-- T7.2: Nguyễn Hải Phong (Vật Lý 12) - 4.5Tr
DECLARE @InvPhongLy BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.phong@educenter.vn' AND cl.code = 'L12-LY-01'
);
IF @InvPhongLy IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202607-002')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202607-002', @InvPhongLy, 4500000.00, 'BANK_TRANSFER', 'TXN-MBB-20260712-002', '2026-07-12 14:00:00', @StaffLinh, N'Thanh toán học phí ôn thi Vật lý 12', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvPhongLy;
END

-- T7.3: Bùi Thu Trang (Toán 11) - 4.2Tr
DECLARE @InvTrangToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.trang@educenter.vn' AND cl.code = 'L11-TOAN-01'
);
IF @InvTrangToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202607-003')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202607-003', @InvTrangToan, 4200000.00, 'CASH', NULL, '2026-07-20 16:45:00', @StaffHa, N'Đóng tiền mặt trước đợt bảo lưu', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvTrangToan;
END

-- T7.4: Đặng Tuấn Minh (Hóa Học 11) - 3.8Tr
DECLARE @InvMinhHoa BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.minh@educenter.vn' AND cl.code = 'L11-HOA-01'
);
IF @InvMinhHoa IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202607-004')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202607-004', @InvMinhHoa, 3800000.00, 'BANK_TRANSFER', 'TXN-TCB-20260728-003', '2026-07-28 11:15:00', @StaffLinh, N'Chuyển khoản học phí Hóa học 11', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvMinhHoa;
END

-- ==================== THÁNG 8/2026 (T8/2026: ~22.6Tr) ====================
-- T8.1: Phạm Trung Kiên (Toán 12) - 4.8Tr
DECLARE @InvKienToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.kien@educenter.vn' AND cl.code = 'L12-TOAN-01'
);
IF @InvKienToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202608-001')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202608-001', @InvKienToan, 4800000.00, 'BANK_TRANSFER', 'TXN-BIDV-20260804-001', '2026-08-04 10:00:00', @StaffLinh, N'Phụ huynh chuyển khoản học phí Toán 12 điểm 8+', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvKienToan;
END

-- T8.2: Nguyễn Hải Phong (Hóa Học 12) - 4.5Tr
DECLARE @InvPhongHoa BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.phong@educenter.vn' AND cl.code = 'L12-HOA-01'
);
IF @InvPhongHoa IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202608-002')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202608-002', @InvPhongHoa, 4500000.00, 'BANK_TRANSFER', 'TXN-MBB-20260811-002', '2026-08-11 15:30:00', @StaffLinh, N'Đóng trọn gói môn Hóa 12 khối A', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvPhongHoa;
END

-- T8.3: Vũ Đức Huy (Ngữ Văn 12) - 4.0Tr
DECLARE @InvHuyVan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.huy@educenter.vn' AND cl.code = 'L12-VAN-01'
);
IF @InvHuyVan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202608-003')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202608-003', @InvHuyVan, 4000000.00, 'BANK_TRANSFER', 'TXN-BIDV-20260818-003', '2026-08-18 09:15:00', @StaffLinh, N'Thanh toán học phí lớp Ngữ văn 12 điểm 8.5+', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvHuyVan;
END

-- T8.4: Hoàng Thảo Vy (Hóa Học 12) - 4.5Tr
DECLARE @InvVyHoa BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.vy@educenter.vn' AND cl.code = 'L12-HOA-01'
);
IF @InvVyHoa IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202608-004')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202608-004', @InvVyHoa, 4500000.00, 'BANK_TRANSFER', 'TXN-VCB-20260825-004', '2026-08-25 14:45:00', @StaffHa, N'Chuyển khoản học phí Hóa khối B00', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvVyHoa;
END

-- T8.5: Trịnh Kim Ngân (Toán 12 chuyển lớp) - 4.8Tr
DECLARE @InvNganToan2 BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.ngan@educenter.vn' AND cl.code = 'L12-TOAN-02'
);
IF @InvNganToan2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202608-005')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202608-005', @InvNganToan2, 4800000.00, 'CASH', NULL, '2026-08-30 16:30:00', @StaffHa, N'Đóng trực tiếp tại văn phòng lớp Toán 12 bứt phá', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvNganToan2;
END

-- ==================== THÁNG 9/2026 (T9/2026: ~14.6Tr) ====================
-- T9.1: Bùi Thu Trang (IELTS 6.5+) - 6.5Tr
DECLARE @InvTrangIelts BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.trang@educenter.vn' AND cl.code = 'L11-IELTS-01'
);
IF @InvTrangIelts IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202609-001')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202609-001', @InvTrangIelts, 6500000.00, 'BANK_TRANSFER', 'TXN-TCB-20260905-001', '2026-09-05 11:00:00', @StaffLinh, N'Chuyển khoản trọn gói khóa IELTS 6.5+ Academic', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvTrangIelts;
END

-- T9.2: Trần Hoàng Nam (Tiếng Anh 12 đợt 2) - 2.2Tr (Hoàn tất 4.2Tr)
DECLARE @InvNamEng2 BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.nam@educenter.vn' AND cl.code = 'L12-ENG-01'
);
IF @InvNamEng2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202609-002')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202609-002', @InvNamEng2, 2200000.00, 'CASH', NULL, '2026-09-12 15:15:00', @StaffHa, N'Hoàn tất phần học phí còn lại (2.2 triệu)', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvNamEng2;
END

-- T9.3: Vũ Đức Huy (Toán 12 bứt phá đợt 2) - 2.3Tr (Hoàn tất 4.8Tr)
DECLARE @InvHuyToan2 BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Classes cl ON cl.id = (SELECT class_id FROM dbo.Enrollments WHERE id = i.enrollment_id)
    WHERE s.email = 'student.huy@educenter.vn' AND cl.code = 'L12-TOAN-02'
);
IF @InvHuyToan2 IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202609-003')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202609-003', @InvHuyToan2, 2300000.00, 'BANK_TRANSFER', 'TXN-BIDV-20260918-002', '2026-09-18 10:30:00', @StaffLinh, N'Hoàn tất đợt 2 học phí Toán bứt phá (2.3tr)', 'CONFIRMED', GETDATE());
    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvHuyToan2;
END

-- T9.4: Đỗ Quỳnh Anh (Bổ trợ Toán 10) - 3.6Tr
IF @InvAnhToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202609-004')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202609-004', @InvAnhToan, 3600000.00, 'BANK_TRANSFER', 'TXN-VCB-20260925-003', '2026-09-25 14:00:00', @StaffLinh, N'Gia hạn học phí bổ trợ kiến thức đại số', 'CONFIRMED', GETDATE());
END

-- ==================== THÁNG 10/2026 (T10/2026: 20.6Tr - ĐỢT GẦN NHẤT) ====================
-- Giao dịch 1: Học viên Trần Hoàng Nam (Toán 12) thanh toán ĐẦY ĐỦ qua Chuyển khoản (PAID)
DECLARE @InvNamToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Enrollments e ON e.id = i.enrollment_id
    JOIN dbo.Classes cl ON cl.id = e.class_id
    WHERE s.email = 'student.nam@educenter.vn' AND cl.code = 'L12-TOAN-01'
);
IF @InvNamToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202610-001')
BEGIN
    DECLARE @Amt1 DECIMAL(18,2) = (SELECT final_amount FROM dbo.Invoices WHERE id = @InvNamToan);
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202610-001', @InvNamToan, @Amt1, 'BANK_TRANSFER', 'TXN-VCB-20261005-001', '2026-10-05 14:30:00', @StaffLinh, N'Phụ huynh Trần Quốc Tuấn chuyển khoản học phí Toán 12', 'CONFIRMED', GETDATE());

    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvNamToan;
END

-- Giao dịch 2: Học viên Trần Hoàng Nam (Tiếng Anh 12) thanh toán MỘT PHẦN qua Tiền mặt
DECLARE @InvNamEng BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Enrollments e ON e.id = i.enrollment_id
    JOIN dbo.Classes cl ON cl.id = e.class_id
    WHERE s.email = 'student.nam@educenter.vn' AND cl.code = 'L12-ENG-01'
);
IF @InvNamEng IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202610-002')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202610-002', @InvNamEng, 2000000.00, 'CASH', NULL, '2026-10-06 09:15:00', @StaffHa, N'Thu đợt 1 tại bàn tuyển sinh (2 triệu / 4.2 triệu)', 'CONFIRMED', GETDATE());

    UPDATE dbo.Invoices SET status = 'PARTIALLY_PAID', updated_at = GETDATE() WHERE id = @InvNamEng;
END

-- Giao dịch 3: Học viên Nguyễn Hải Phong (Toán 12) thanh toán ĐẦY ĐỦ qua Chuyển khoản (PAID)
DECLARE @InvPhongToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Enrollments e ON e.id = i.enrollment_id
    JOIN dbo.Classes cl ON cl.id = e.class_id
    WHERE s.email = 'student.phong@educenter.vn' AND cl.code = 'L12-TOAN-01'
);
IF @InvPhongToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202610-003')
BEGIN
    DECLARE @Amt3 DECIMAL(18,2) = (SELECT final_amount FROM dbo.Invoices WHERE id = @InvPhongToan);
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202610-003', @InvPhongToan, @Amt3, 'BANK_TRANSFER', 'TXN-MBB-20261007-002', '2026-10-07 10:45:00', @StaffLinh, N'Phụ huynh Phạm Thanh Hoa chuyển khoản học phí Toán A00', 'CONFIRMED', GETDATE());

    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvPhongToan;
END

-- Giao dịch 4: Học viên Lê Thị Hoàng Mai (IELTS 6.5+) thanh toán ĐẦY ĐỦ qua Chuyển khoản (PAID)
DECLARE @InvMaiIelts BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Enrollments e ON e.id = i.enrollment_id
    JOIN dbo.Classes cl ON cl.id = e.class_id
    WHERE s.email = 'student.mai@educenter.vn' AND cl.code = 'L11-IELTS-01'
);
IF @InvMaiIelts IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202610-004')
BEGIN
    DECLARE @Amt4 DECIMAL(18,2) = (SELECT final_amount FROM dbo.Invoices WHERE id = @InvMaiIelts);
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202610-004', @InvMaiIelts, @Amt4, 'BANK_TRANSFER', 'TXN-TCB-20261008-003', '2026-10-08 16:20:00', @StaffLinh, N'Phụ huynh Nguyễn Thị Mai Lan đóng trọn khóa IELTS', 'CONFIRMED', GETDATE());

    UPDATE dbo.Invoices SET status = 'PAID', updated_at = GETDATE() WHERE id = @InvMaiIelts;
END

-- Giao dịch 5: Học viên Vũ Đức Huy (Toán 12 bứt phá) thanh toán MỘT PHẦN qua Chuyển khoản (PARTIALLY_PAID)
DECLARE @InvHuyToan BIGINT = (
    SELECT TOP 1 i.id FROM dbo.Invoices i 
    JOIN dbo.Students s ON s.id = i.student_id 
    JOIN dbo.Enrollments e ON e.id = i.enrollment_id
    JOIN dbo.Classes cl ON cl.id = e.class_id
    WHERE s.email = 'student.huy@educenter.vn' AND cl.code = 'L12-TOAN-02'
);
IF @InvHuyToan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM dbo.Payments WHERE payment_code = 'PAY-202610-005')
BEGIN
    INSERT INTO dbo.Payments (payment_code, invoice_id, amount, payment_method, transaction_ref, paid_at, confirmed_by, notes, status, created_at)
    VALUES ('PAY-202610-005', @InvHuyToan, 2500000.00, 'BANK_TRANSFER', 'TXN-BIDV-20261009-004', '2026-10-09 11:00:00', @StaffLinh, N'Phụ huynh Vũ Mạnh Dũng đóng đợt 1 lớp Toán bứt phá (2.5tr / 4.8tr)', 'CONFIRMED', GETDATE());

    UPDATE dbo.Invoices SET status = 'PARTIALLY_PAID', updated_at = GETDATE() WHERE id = @InvHuyToan;
END
GO

PRINT N'Hoàn thành Bước 07: Khởi tạo 22 ghi danh, toàn bộ hóa đơn điện tử và các giao dịch thu tiền qua 6 tháng T5-T10!';
GO
