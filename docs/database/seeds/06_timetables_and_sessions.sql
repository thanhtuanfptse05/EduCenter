-- ============================================================================
-- EDUCENTER ERP - BƯỚC 06: KHỞI TẠO THỜI KHÓA BIỂU & CÁC CA HỌC CHI TIẾT
-- ============================================================================

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

-- Khởi tạo danh sách các lớp học
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

-- Khởi tạo giáo viên
DECLARE @TeacherHung BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hung@educenter.vn');
DECLARE @TeacherMai BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.mai@educenter.vn');
DECLARE @TeacherTuan BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.tuan@educenter.vn');
DECLARE @TeacherLan BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.lan@educenter.vn');
DECLARE @TeacherPhuong BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.phuong@educenter.vn');
DECLARE @TeacherHoang BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.hoang@educenter.vn');
DECLARE @TeacherMaiAnh BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.maianh@educenter.vn');
DECLARE @TeacherNam BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.nam@educenter.vn');
DECLARE @TeacherNgoc BIGINT = (SELECT id FROM dbo.Teachers WHERE email = 'teacher.ngoc@educenter.vn');

-- Khởi tạo phòng học
DECLARE @RoomP101 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P101');
DECLARE @RoomP102 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P102');
DECLARE @RoomP201 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P201');
DECLARE @RoomP202 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P202');
DECLARE @RoomP301 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P301');
DECLARE @RoomP302 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'P302');
DECLARE @RoomLAB01 BIGINT = (SELECT id FROM dbo.Rooms WHERE code = 'LAB01');

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

-- 1. L12-TOAN-01 (Thứ 2 & 5)
INSERT INTO #TmpSessions VALUES
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-05', '17:30:00', '19:30:00', N'Buổi 01: Khảo sát sự biến thiên và vẽ đồ thị hàm số chứa dấu GTTĐ', 'COMPLETED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-08', '17:30:00', '19:30:00', N'Buổi 02: Cực trị của hàm số bậc ba và hàm phân thức hữu tỉ nâng cao', 'COMPLETED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-12', '17:30:00', '19:30:00', N'Buổi 03: Giá trị lớn nhất - nhỏ nhất của hàm số trên đoạn và bài toán thực tế', 'COMPLETED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-15', '17:30:00', '19:30:00', N'Buổi 04: Tiệm cận đứng, tiệm cận ngang và bài toán tương giao đồ thị', 'COMPLETED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-19', '17:30:00', '19:30:00', N'Buổi 05: Khối đa diện và thể tích khối chóp, khối lăng trụ cơ bản', 'COMPLETED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-22', '17:30:00', '19:30:00', N'Buổi 06: Kiểm tra định kỳ Chuyên đề 1 & Kỹ thuật Casio nâng cao', 'COMPLETED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-26', '17:30:00', '19:30:00', N'Buổi 07: Hàm số lũy thừa, hàm số mũ và lôgarit chuyên sâu', 'SCHEDULED'),
(@L12_TOAN_01, @TeacherHung, @RoomP101, '2026-10-29', '17:30:00', '19:30:00', N'Buổi 08: Phương trình và bất phương trình mũ chứa tham số m', 'SCHEDULED');

-- 2. L12-TOAN-02 (Thứ 3 & 6)
INSERT INTO #TmpSessions VALUES
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-06', '17:30:00', '19:30:00', N'Buổi 01: Hàm số hợp và tính đơn điệu của hàm số f(u)', 'COMPLETED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-09', '17:30:00', '19:30:00', N'Buổi 02: Cực trị hàm số chứa tham số và kỹ thuật đạo hàm cấp hai', 'COMPLETED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-13', '17:30:00', '19:30:00', N'Buổi 03: Min - Max hàm liên kết và phương pháp cô lập tham số m', 'COMPLETED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-16', '17:30:00', '19:30:00', N'Buổi 04: Tương giao đồ thị và bài toán biện luận số nghiệm', 'COMPLETED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-20', '17:30:00', '19:30:00', N'Buổi 05: Thể tích khối đa diện phân hóa và tỷ số thể tích Simson', 'COMPLETED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-23', '17:30:00', '19:30:00', N'Buổi 06: Bất đẳng thức mũ và lôgarit vận dụng cao', 'COMPLETED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-27', '17:30:00', '19:30:00', N'Buổi 07: Phương trình mũ và lôgarit chứa tham số nâng cao', 'SCHEDULED'),
(@L12_TOAN_02, @TeacherHung, @RoomP202, '2026-10-30', '17:30:00', '19:30:00', N'Buổi 08: Mặt nón, mặt trụ và góc nhìn thực tiễn', 'SCHEDULED');

-- 3. L12-DGNL-01 (Thứ 7: 08:30 - 11:30)
INSERT INTO #TmpSessions VALUES
(@L12_DGNL_01, @TeacherHung, @RoomLAB01, '2026-10-03', '08:30:00', '11:30:00', N'Buổi 01: Cấu trúc đề thi ĐGNL ĐHQG & Tư duy định lượng căn bản', 'COMPLETED'),
(@L12_DGNL_01, @TeacherHung, @RoomLAB01, '2026-10-10', '08:30:00', '11:30:00', N'Buổi 02: Kỹ năng đọc biểu đồ, bảng số liệu thống kê và phân tích suy luận', 'COMPLETED'),
(@L12_DGNL_01, @TeacherHung, @RoomLAB01, '2026-10-17', '08:30:00', '11:30:00', N'Buổi 03: Bài toán tổ hợp, xác suất và quy tắc đếm thực tế', 'COMPLETED'),
(@L12_DGNL_01, @TeacherHung, @RoomLAB01, '2026-10-24', '08:30:00', '11:30:00', N'Buổi 04: Thi thử trực tuyến trên hệ thống EduCenter Lab Đợt 1', 'SCHEDULED'),
(@L12_DGNL_01, @TeacherHung, @RoomLAB01, '2026-10-31', '08:30:00', '11:30:00', N'Buổi 05: Chữa đề thi thử và phân tích chiến thuật phân bổ thời gian', 'SCHEDULED'),
(@L12_DGNL_01, @TeacherHung, @RoomLAB01, '2026-11-07', '08:30:00', '11:30:00', N'Buổi 06: Xử lý dạng toán logic suy luận mệnh đề và suy diễn', 'SCHEDULED');

-- 4. L11-TOAN-01 (Thứ 4 & Chủ Nhật)
INSERT INTO #TmpSessions VALUES
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-04', '18:00:00', '20:00:00', N'Buổi 01: Phương trình lượng giác cơ bản và công thức biến đổi', 'COMPLETED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-07', '18:00:00', '20:00:00', N'Buổi 02: Phương trình bậc nhất và bậc hai đối với một hàm số lượng giác', 'COMPLETED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-11', '18:00:00', '20:00:00', N'Buổi 03: Quan hệ song song trong không gian và giao tuyến mặt phẳng', 'COMPLETED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-14', '18:00:00', '20:00:00', N'Buổi 04: Đường thẳng song song với mặt phẳng và thiết diện', 'COMPLETED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-18', '18:00:00', '20:00:00', N'Buổi 05: Dãy số, cấp số cộng và cấp số nhân ứng dụng', 'COMPLETED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-21', '18:00:00', '20:00:00', N'Buổi 06: Giới hạn của dãy số và giới hạn hàm số', 'COMPLETED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-25', '18:00:00', '20:00:00', N'Buổi 07: Hàm số liên tục và định lý giá trị trung gian', 'SCHEDULED'),
(@L11_TOAN_01, @TeacherHung, @RoomP102, '2026-10-28', '18:00:00', '20:00:00', N'Buổi 08: Hai mặt phẳng song song và định lý Thales trong không gian', 'SCHEDULED');

-- 5. L10-TOAN-01 (Thứ 2 & 6: 19:30 - 21:30 - Thầy Nam)
INSERT INTO #TmpSessions VALUES
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-05', '19:30:00', '21:30:00', N'Buổi 01: Mệnh đề toán học và các phép toán trên tập hợp', 'COMPLETED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-09', '19:30:00', '21:30:00', N'Buổi 02: Bất phương trình bậc nhất hai ẩn và bài toán quy hoạch tuyến tính', 'COMPLETED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-12', '19:30:00', '21:30:00', N'Buổi 03: Hệ bất phương trình bậc nhất hai ẩn và ứng dụng thực tế', 'COMPLETED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-16', '19:30:00', '21:30:00', N'Buổi 04: Hàm số và đồ thị, hàm số bậc hai y = ax^2 + bx + c', 'COMPLETED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-19', '19:30:00', '21:30:00', N'Buổi 05: Dấu của tam thức bậc hai và bất phương trình bậc hai một ẩn', 'COMPLETED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-23', '19:30:00', '21:30:00', N'Buổi 06: Khái niệm véctơ và các phép toán cộng, trừ véctơ', 'COMPLETED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-26', '19:30:00', '21:30:00', N'Buổi 07: Tích của một số với véctơ và trục tọa độ Oxy', 'SCHEDULED'),
(@L10_TOAN_01, @TeacherNam, @RoomP102, '2026-10-30', '19:30:00', '21:30:00', N'Buổi 08: Tích vô hướng của hai véctơ và ứng dụng tính góc, khoảng cách', 'SCHEDULED');

-- 6. L09-TOAN-01 (Thứ 3 & 7: 18:00 - 20:00 - Thầy Nam)
INSERT INTO #TmpSessions VALUES
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-06', '18:00:00', '20:00:00', N'Buổi 01: Căn bậc hai, căn bậc ba và rút gọn biểu thức chứa căn', 'COMPLETED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-10', '18:00:00', '20:00:00', N'Buổi 02: Các bài toán phụ rút gọn: tìm x nguyên để P nguyên', 'COMPLETED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-13', '18:00:00', '20:00:00', N'Buổi 03: Hệ phương trình bậc nhất hai ẩn và phương pháp đặt ẩn phụ', 'COMPLETED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-17', '18:00:00', '20:00:00', N'Buổi 04: Giải bài toán bằng cách lập phương trình và hệ phương trình', 'COMPLETED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-20', '18:00:00', '20:00:00', N'Buổi 05: Hệ thức lượng trong tam giác vuông và tỉ số lượng giác góc nhọn', 'COMPLETED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-24', '18:00:00', '20:00:00', N'Buổi 06: Đường tròn, tiếp tuyến và tính chất hai tiếp tuyến cắt nhau', 'SCHEDULED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-27', '18:00:00', '20:00:00', N'Buổi 07: Vị trí tương đối của hai đường tròn', 'SCHEDULED'),
(@L09_TOAN_01, @TeacherNam, @RoomP202, '2026-10-31', '18:00:00', '20:00:00', N'Buổi 08: Tứ giác nội tiếp và chứng minh điểm thuộc đường tròn', 'SCHEDULED');

-- 7. L12-ENG-01 (Thứ 3 & 6: 19:30 - 21:30 - Cô Mai)
INSERT INTO #TmpSessions VALUES
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-06', '19:30:00', '21:30:00', N'Buổi 01: Hệ thống 12 thì cơ bản & Sự hòa hợp chủ vị nâng cao', 'COMPLETED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-09', '19:30:00', '21:30:00', N'Buổi 02: Câu bị động đặc biệt và thể sai khiến', 'COMPLETED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-13', '19:30:00', '21:30:00', N'Buổi 03: Câu điều kiện loại 1, 2, 3 và đảo ngữ câu điều kiện', 'COMPLETED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-16', '19:30:00', '21:30:00', N'Buổi 04: Mệnh đề quan hệ và rút gọn mệnh đề quan hệ', 'COMPLETED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-20', '19:30:00', '21:30:00', N'Buổi 05: Cụm động từ (Phrasal Verbs) và Collocations chủ điểm Giáo dục', 'COMPLETED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-23', '19:30:00', '21:30:00', N'Buổi 06: Kỹ thuật Skimming & Scanning bài đọc hiểu dài 500 từ', 'COMPLETED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-27', '19:30:00', '21:30:00', N'Buổi 07: Kỹ năng xử lý bài đục lỗ (Cloze text) và chọn từ loại chính xác', 'SCHEDULED'),
(@L12_ENG_01, @TeacherMai, @RoomP101, '2026-10-30', '19:30:00', '21:30:00', N'Buổi 08: Tìm lỗi sai trong câu phức và câu ghép', 'SCHEDULED');

-- 8. L09-ENG-01 (Thứ 4 & 7: 17:30 - 19:30 - Cô Mai)
INSERT INTO #TmpSessions VALUES
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-07', '17:30:00', '19:30:00', N'Buổi 01: Ngữ âm: Quy tắc phát âm -s/-es và -ed chuẩn quốc tế', 'COMPLETED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-10', '17:30:00', '19:30:00', N'Buổi 02: Trọng âm từ 2 và 3 âm tiết hay xuất hiện trong đề thi vào 10', 'COMPLETED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-14', '17:30:00', '19:30:00', N'Buổi 03: Câu gián tiếp và câu tường thuật đặc biệt', 'COMPLETED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-17', '17:30:00', '19:30:00', N'Buổi 04: So sánh hơn, so sánh nhất và so sánh kép (The more... the more...)', 'COMPLETED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-21', '17:30:00', '19:30:00', N'Buổi 05: Viết lại câu không đổi nghĩa chuyên đề vào 10', 'COMPLETED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-24', '17:30:00', '19:30:00', N'Buổi 06: Bài tập tình huống giao tiếp và chức năng ngôn ngữ', 'SCHEDULED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-28', '17:30:00', '19:30:00', N'Buổi 07: Kỹ năng đọc hiểu chủ điểm Môi trường và Đô thị hóa', 'SCHEDULED'),
(@L09_ENG_01, @TeacherMai, @RoomP202, '2026-10-31', '17:30:00', '19:30:00', N'Buổi 08: Thi thử chuẩn form tuyển sinh vào lớp 10 Hà Nội', 'SCHEDULED');

-- 9. L10-ENG-01 (Thứ 2 & 5: 18:00 - 20:00 - Cô Mai)
INSERT INTO #TmpSessions VALUES
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-05', '18:00:00', '20:00:00', N'Buổi 01: Unit 1: Family Life - Thì hiện tại đơn & hiện tại tiếp diễn', 'COMPLETED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-08', '18:00:00', '20:00:00', N'Buổi 02: Unit 2: Humans and the Environment - Câu bị động thì tương lai', 'COMPLETED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-12', '18:00:00', '20:00:00', N'Buổi 03: Unit 3: Music - Động từ nguyên mẫu có to và không to', 'COMPLETED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-15', '18:00:00', '20:00:00', N'Buổi 04: Kỹ năng đọc hiểu bài đọc văn hóa nghệ thuật hiện đại', 'COMPLETED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-19', '18:00:00', '20:00:00', N'Buổi 05: Unit 4: For a Better Community - Quá khứ đơn & Quá khứ tiếp diễn', 'COMPLETED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-22', '18:00:00', '20:00:00', N'Buổi 06: Kỹ năng viết đoạn văn miêu tả hoạt động tình nguyện', 'COMPLETED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-26', '18:00:00', '20:00:00', N'Buổi 07: Ôn tập giữa học kỳ I chương trình GDPT mới', 'SCHEDULED'),
(@L10_ENG_01, @TeacherMai, @RoomP102, '2026-10-29', '18:00:00', '20:00:00', N'Buổi 08: Kiểm tra giữa kỳ và chữa chi tiết', 'SCHEDULED');

-- 10. L11-IELTS-01 (Thứ 3 & 5: 19:30 - 21:30 - Cô Mai Anh)
INSERT INTO #TmpSessions VALUES
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-06', '19:30:00', '21:30:00', N'Buổi 01: Overview IELTS Format & Writing Task 1 Line Graph Strategy', 'COMPLETED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-08', '19:30:00', '21:30:00', N'Buổi 02: Writing Task 1 Bar Chart & Comparative Structures', 'COMPLETED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-13', '19:30:00', '21:30:00', N'Buổi 03: Reading: True/False/Not Given & Yes/No/Not Given Mastery', 'COMPLETED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-15', '19:30:00', '21:30:00', N'Buổi 04: Speaking Part 1: Fluency, Coherence & Natural Fillers', 'COMPLETED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-20', '19:30:00', '21:30:00', N'Buổi 05: Writing Task 2: Opinion Essay (Agree/Disagree) Structure', 'COMPLETED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-22', '19:30:00', '21:30:00', N'Buổi 06: Listening Section 1 & Section 2 Note-taking Techniques', 'COMPLETED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-27', '19:30:00', '21:30:00', N'Buổi 07: Speaking Part 2: Long Turn & Storytelling Mind-map', 'SCHEDULED'),
(@L11_IELTS_01, @TeacherMaiAnh, @RoomP201, '2026-10-29', '19:30:00', '21:30:00', N'Buổi 08: Full IELTS Mini-mock Test (Reading & Listening)', 'SCHEDULED');

-- 11. L12-IELTS-02 (Thứ 4 & 7: 19:30 - 21:30 - Cô Mai Anh)
INSERT INTO #TmpSessions VALUES
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-07', '19:30:00', '21:30:00', N'Buổi 01: Writing Task 2 Advanced Discussion Essays & Cohesive Devices', 'COMPLETED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-10', '19:30:00', '21:30:00', N'Buổi 02: Complex Sentence Structures & Lexical Resource for Band 7.5+', 'COMPLETED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-14', '19:30:00', '21:30:00', N'Buổi 03: Reading: Matching Headings & Information Location in Passage 3', 'COMPLETED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-17', '19:30:00', '21:30:00', N'Buổi 04: Speaking Part 3: Abstract Ideas & Academic Discussion', 'COMPLETED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-21', '19:30:00', '21:30:00', N'Buổi 05: Writing Task 1 Process & Map Description Masterclass', 'COMPLETED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-24', '19:30:00', '21:30:00', N'Buổi 06: Listening Section 3 & 4 Academic Lectures & Speed Drills', 'SCHEDULED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-28', '19:30:00', '21:30:00', N'Buổi 07: 1-on-1 Intensive Speaking Mock with Feedback', 'SCHEDULED'),
(@L12_IELTS_02, @TeacherMaiAnh, @RoomP201, '2026-10-31', '19:30:00', '21:30:00', N'Buổi 08: Writing Task 2 Peer Review and Band Descriptor Analysis', 'SCHEDULED');

-- 12. L12-LY-01 (Thứ 2 & 4: 17:30 - 19:30 - Thầy Tuấn)
INSERT INTO #TmpSessions VALUES
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-05', '17:30:00', '19:30:00', N'Buổi 01: Đại cương dao động điều hòa, vòng tròn lượng giác đa trục', 'COMPLETED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-07', '17:30:00', '19:30:00', N'Buổi 02: Con lắc lò xo, bài toán thời gian nén dãn và lực đàn hồi', 'COMPLETED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-12', '17:30:00', '19:30:00', N'Buổi 03: Con lắc đơn, dao động tắt dần và hiện tượng cộng hưởng cơ', 'COMPLETED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-14', '17:30:00', '19:30:00', N'Buổi 04: Sóng cơ và sự truyền sóng, phương trình sóng tại một điểm', 'COMPLETED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-19', '17:30:00', '19:30:00', N'Buổi 05: Giao thoa sóng cơ và bài toán đếm số điểm cực đại, cực tiểu', 'COMPLETED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-21', '17:30:00', '19:30:00', N'Buổi 06: Sóng dừng và bài toán đồ thị sóng dừng tại thời điểm t', 'COMPLETED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-26', '17:30:00', '19:30:00', N'Buổi 07: Đại cương dòng điện xoay chiều và các mạch điện RLC nối tiếp', 'SCHEDULED'),
(@L12_LY_01, @TeacherTuan, @RoomP301, '2026-10-28', '17:30:00', '19:30:00', N'Buổi 08: Phương pháp giản đồ véctơ buộc và véctơ trượt trong điện xoay chiều', 'SCHEDULED');

-- 13. L11-LY-01 (Thứ 3 & 6: 18:00 - 20:00 - Thầy Tuấn)
INSERT INTO #TmpSessions VALUES
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-06', '18:00:00', '20:00:00', N'Buổi 01: Dao động điều hòa và phương trình li độ, vận tốc, gia tốc', 'COMPLETED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-09', '18:00:00', '20:00:00', N'Buổi 02: Mô tả dao động điều hòa bằng đồ thị', 'COMPLETED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-13', '18:00:00', '20:00:00', N'Buổi 03: Vận tốc và gia tốc trong dao động điều hòa', 'COMPLETED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-16', '18:00:00', '20:00:00', N'Buổi 04: Năng lượng trong dao động điều hòa (Động năng và thế năng)', 'COMPLETED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-20', '18:00:00', '20:00:00', N'Buổi 05: Dao động tắt dần, dao động cưỡng bức và hiện tượng cộng hưởng', 'COMPLETED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-23', '18:00:00', '20:00:00', N'Buổi 06: Sóng ngang, sóng dọc và tốc độ truyền sóng', 'COMPLETED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-27', '18:00:00', '20:00:00', N'Buổi 07: Sóng điện từ và thang sóng điện từ', 'SCHEDULED'),
(@L11_LY_01, @TeacherTuan, @RoomP301, '2026-10-30', '18:00:00', '20:00:00', N'Buổi 08: Giao thoa sóng ánh sáng và thí nghiệm Young', 'SCHEDULED');

-- 14. L10-LY-01 (Thứ 5 & Chủ Nhật - Thầy Tuấn)
INSERT INTO #TmpSessions VALUES
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-04', '17:30:00', '19:30:00', N'Buổi 01: Chuyển động thẳng đều và đồ thị độ dịch chuyển - thời gian', 'COMPLETED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-08', '17:30:00', '19:30:00', N'Buổi 02: Chuyển động thẳng biến đổi đều và các công thức liên hệ', 'COMPLETED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-11', '17:30:00', '19:30:00', N'Buổi 03: Rơi tự do và chuyển động ném ngang', 'COMPLETED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-15', '17:30:00', '19:30:00', N'Buổi 04: Ba định luật Newton và ứng dụng vào bài toán chuyển động', 'COMPLETED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-18', '17:30:00', '19:30:00', N'Buổi 05: Lực ma sát, lực cản và lực nâng của chất lưu', 'COMPLETED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-22', '17:30:00', '19:30:00', N'Buổi 06: Khái niệm moment lực và điều kiện cân bằng của vật rắn', 'COMPLETED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-25', '17:30:00', '19:30:00', N'Buổi 07: Năng lượng, công cơ học và công suất', 'SCHEDULED'),
(@L10_LY_01, @TeacherTuan, @RoomP301, '2026-10-29', '17:30:00', '19:30:00', N'Buổi 08: Động năng, thế năng và định luật bảo toàn cơ năng', 'SCHEDULED');

-- 15. L12-HOA-01 (Thứ 3 & 5: 17:30 - 19:30 - Cô Lan)
INSERT INTO #TmpSessions VALUES
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-06', '17:30:00', '19:30:00', N'Buổi 01: Este - Lipit: Đồng phân, danh pháp và phản ứng xà phòng hóa', 'COMPLETED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-08', '17:30:00', '19:30:00', N'Buổi 02: Bài toán thủy phân este đơn chức và đa chức nâng cao', 'COMPLETED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-13', '17:30:00', '19:30:00', N'Buổi 03: Cacbohiđrat: Glucozơ, Fructozơ, Saccarozơ và Tinh bột', 'COMPLETED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-15', '17:30:00', '19:30:00', N'Buổi 04: Amin, Amino Axit và Peptit: Cấu trúc và tính chất hóa học', 'COMPLETED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-20', '17:30:00', '19:30:00', N'Buổi 05: Phương pháp đồng đẳng hóa và quy đổi hỗn hợp Peptit', 'COMPLETED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-22', '17:30:00', '19:30:00', N'Buổi 06: Polime và vật liệu polime, bài toán hiệu suất phản ứng', 'COMPLETED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-27', '17:30:00', '19:30:00', N'Buổi 07: Đại cương về kim loại và dãy điện hóa kim loại', 'SCHEDULED'),
(@L12_HOA_01, @TeacherLan, @RoomP302, '2026-10-29', '17:30:00', '19:30:00', N'Buổi 08: Bài toán kim loại tác dụng với muối và phương pháp ion thu gọn', 'SCHEDULED');

-- 16. L11-HOA-01 (Thứ 2 & 6: 18:00 - 20:00 - Cô Lan)
INSERT INTO #TmpSessions VALUES
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-05', '18:00:00', '20:00:00', N'Buổi 01: Cân bằng hóa học và hằng số cân bằng Kc', 'COMPLETED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-09', '18:00:00', '20:00:00', N'Buổi 02: Sự điện li, thuyết Bronsted-Lowry về axit - bazơ và độ pH', 'COMPLETED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-12', '18:00:00', '20:00:00', N'Buổi 03: Đơn chất Nitrogen và các hợp chất của Nitrogen (NH3, HNO3)', 'COMPLETED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-16', '18:00:00', '20:00:00', N'Buổi 04: Sulfur và sulfur dioxide, tính oxi hóa - khử đặc trưng', 'COMPLETED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-19', '18:00:00', '20:00:00', N'Buổi 05: Sulfuric acid và muối sulfate, bài toán nhận biết định tính', 'COMPLETED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-23', '18:00:00', '20:00:00', N'Buổi 06: Mở đầu về hóa học hữu cơ và công thức phân tử', 'COMPLETED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-26', '18:00:00', '20:00:00', N'Buổi 07: Phương pháp phổ hồng ngoại (IR) và phổ khối lượng (MS)', 'SCHEDULED'),
(@L11_HOA_01, @TeacherLan, @RoomP302, '2026-10-30', '18:00:00', '20:00:00', N'Buổi 08: Alkane: Cấu trúc, danh pháp và phản ứng thế halogen', 'SCHEDULED');

-- 17. L10-HOA-01 (Thứ 4 & Chủ Nhật - Cô Lan)
INSERT INTO #TmpSessions VALUES
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-04', '19:30:00', '21:30:00', N'Buổi 01: Thành phần nguyên tử: proton, neutron, electron', 'COMPLETED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-07', '19:30:00', '21:30:00', N'Buổi 02: Hạt nhân nguyên tử, nguyên tố hóa học và đồng vị', 'COMPLETED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-11', '19:30:00', '21:30:00', N'Buổi 03: Mô hình nguyên tử Rutherford - Bohr và mô hình hiện đại', 'COMPLETED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-14', '19:30:00', '21:30:00', N'Buổi 04: Cấu hình electron nguyên tử và quy tắc Klechkowski', 'COMPLETED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-18', '19:30:00', '21:30:00', N'Buổi 05: Cấu tạo bảng tuần hoàn các nguyên tố hóa học', 'COMPLETED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-21', '19:30:00', '21:30:00', N'Buổi 06: Xu hướng biến đổi bán kính nguyên tử và độ âm điện', 'COMPLETED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-25', '19:30:00', '21:30:00', N'Buổi 07: Liên kết ion và bản chất hút tĩnh điện', 'SCHEDULED'),
(@L10_HOA_01, @TeacherLan, @RoomP302, '2026-10-28', '19:30:00', '21:30:00', N'Buổi 08: Liên kết cộng hóa trị và công thức Lewis', 'SCHEDULED');

-- 18. L12-SINH-01 (Thứ 4 & 7: 17:30 - 19:30 - Thầy Hoàng)
INSERT INTO #TmpSessions VALUES
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-07', '17:30:00', '19:30:00', N'Buổi 01: Gen, mã di truyền và quá trình nhân đôi ADN', 'COMPLETED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-10', '17:30:00', '19:30:00', N'Buổi 02: Phiên mã và dịch mã, cơ chế điều hòa hoạt động của gen (Operon Lac)', 'COMPLETED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-14', '17:30:00', '19:30:00', N'Buổi 03: Đột biến gen và các dạng bài tập tính số lượng nucleotit', 'COMPLETED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-17', '17:30:00', '19:30:00', N'Buổi 04: Nhiễm sắc thể và đột biến cấu trúc, số lượng nhiễm sắc thể', 'COMPLETED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-21', '17:30:00', '19:30:00', N'Buổi 05: Quy luật di truyền Menđen: Phân li và phân li độc lập', 'COMPLETED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-24', '17:30:00', '19:30:00', N'Buổi 06: Tương tác gen và tác động cộng gộp', 'SCHEDULED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-28', '17:30:00', '19:30:00', N'Buổi 07: Liên kết gen và hoán vị gen, bài toán tính tần số hoán vị', 'SCHEDULED'),
(@L12_SINH_01, @TeacherHoang, @RoomP302, '2026-10-31', '17:30:00', '19:30:00', N'Buổi 08: Di truyền liên kết với giới tính và di truyền ngoài nhân', 'SCHEDULED');

-- 19. L11-SINH-01 (Thứ 2 & 5: 19:30 - 21:30 - Thầy Hoàng)
INSERT INTO #TmpSessions VALUES
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-05', '19:30:00', '21:30:00', N'Buổi 01: Khái quát về trao đổi chất và chuyển hóa năng lượng ở sinh vật', 'COMPLETED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-08', '19:30:00', '21:30:00', N'Buổi 02: Trao đổi nước và khoáng ở thực vật, cơ chế thoát hơi nước', 'COMPLETED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-12', '19:30:00', '21:30:00', N'Buổi 03: Quang hợp ở thực vật: Pha sáng và pha tối (chu trình Calvin)', 'COMPLETED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-15', '19:30:00', '21:30:00', N'Buổi 04: Quang hợp ở thực vật C3, C4 và CAM', 'COMPLETED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-19', '19:30:00', '21:30:00', N'Buổi 05: Hô hấp ở thực vật và mối quan hệ với quang hợp', 'COMPLETED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-22', '19:30:00', '21:30:00', N'Buổi 06: Dinh dưỡng và tiêu hóa ở động vật', 'COMPLETED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-26', '19:30:00', '21:30:00', N'Buổi 07: Hô hấp và trao đổi khí ở động vật', 'SCHEDULED'),
(@L11_SINH_01, @TeacherHoang, @RoomP302, '2026-10-29', '19:30:00', '21:30:00', N'Buổi 08: Hệ tuần hoàn ở động vật và hoạt động của tim mạch', 'SCHEDULED');

-- 20. L12-VAN-01 (Thứ 3 & 6: 18:00 - 20:00 - Cô Phương)
INSERT INTO #TmpSessions VALUES
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-06', '18:00:00', '20:00:00', N'Buổi 01: Phương pháp làm bài đọc hiểu đạt tối đa 3.0 điểm', 'COMPLETED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-09', '18:00:00', '20:00:00', N'Buổi 02: Kỹ năng viết đoạn văn nghị luận xã hội 200 chữ sắc sảo', 'COMPLETED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-13', '18:00:00', '20:00:00', N'Buổi 03: Chuyên đề tác phẩm "Người lái đò Sông Đà" - Vẻ đẹp hùng vĩ và trữ tình', 'COMPLETED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-16', '18:00:00', '20:00:00', N'Buổi 04: Hình tượng người lái đò - Người nghệ sĩ trên sông nước', 'COMPLETED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-20', '18:00:00', '20:00:00', N'Buổi 05: Chuyên đề "Ai đã đặt tên cho dòng sông?" - Chất thơ và tình yêu Huế', 'COMPLETED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-23', '18:00:00', '20:00:00', N'Buổi 06: Đoạn trích "Đất Nước" (Nguyễn Khoa Điềm) - Cảm nhận về Đất Nước toàn vẹn', 'COMPLETED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-27', '18:00:00', '20:00:00', N'Buổi 07: Kỹ thuật mở bài gián tiếp và kết bài mở rộng đạt điểm 8.5+', 'SCHEDULED'),
(@L12_VAN_01, @TeacherPhuong, @RoomP101, '2026-10-30', '18:00:00', '20:00:00', N'Buổi 08: Bài thơ "Sóng" (Xuân Quỳnh) - Khát vọng tình yêu muôn thuở', 'SCHEDULED');

-- 21. L10-VAN-01 (Thứ 4 & 7: 18:00 - 20:00 - Cô Ngọc)
INSERT INTO #TmpSessions VALUES
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-07', '18:00:00', '20:00:00', N'Buổi 01: Khám phá thần thoại: Thần Trụ trời và Prô-mê-tê bị xiềng', 'COMPLETED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-10', '18:00:00', '20:00:00', N'Buổi 02: Sử thi anh hùng: Đoạn trích Đăm Săn chiến thắng Mtao Mxây', 'COMPLETED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-14', '18:00:00', '20:00:00', N'Buổi 03: Kỹ năng đọc hiểu văn bản tự sự và phân tích nhân vật', 'COMPLETED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-17', '18:00:00', '20:00:00', N'Buổi 04: Chèo cổ: Đoạn trích Xúy Vân giả dại và nghệ thuật biểu diễn dân gian', 'COMPLETED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-21', '18:00:00', '20:00:00', N'Buổi 05: Viết bài văn nghị luận thuyết phục người khác từ bỏ thói quen xấu', 'COMPLETED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-24', '18:00:00', '20:00:00', N'Buổi 06: Thơ ca dân gian và những câu hát than thân, yêu thương tình nghĩa', 'SCHEDULED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-28', '18:00:00', '20:00:00', N'Buổi 07: Kỹ năng liên hệ mở rộng và so sánh văn học lớp 10', 'SCHEDULED'),
(@L10_VAN_01, @TeacherNgoc, @RoomP102, '2026-10-31', '18:00:00', '20:00:00', N'Buổi 08: Tổng kết học phần văn học dân gian và làm bài kiểm tra định kỳ', 'SCHEDULED');

-- Nạp vào bảng ClassSessions
MERGE dbo.ClassSessions AS target
USING #TmpSessions AS source
ON target.class_id = source.class_id AND target.session_date = source.session_date AND target.start_at = source.start_at
WHEN MATCHED THEN
    UPDATE SET 
        teacher_id = source.teacher_id,
        room_id = source.room_id,
        end_at = source.end_at,
        title = source.title,
        status = source.status,
        updated_at = GETDATE()
WHEN NOT MATCHED THEN
    INSERT (class_id, teacher_id, room_id, session_date, start_at, end_at, title, status, created_at, updated_at)
    VALUES (source.class_id, source.teacher_id, source.room_id, source.session_date, source.start_at, source.end_at, source.title, source.status, GETDATE(), GETDATE());

DROP TABLE #TmpSessions;
GO

PRINT N'Hoàn thành Bước 06: Khởi tạo hơn 160 ca học chi tiết phủ kín 21 lớp học!';
GO
