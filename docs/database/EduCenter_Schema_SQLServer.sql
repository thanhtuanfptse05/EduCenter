-- ============================================================================
-- EDUCENTER - TUTORING & EXAM PREPARATION MANAGEMENT SYSTEM
-- SCRIPT TẠO CƠ SỞ DỮ LIỆU MICROSOFT SQL SERVER (30 BẢNG CHUẨN SRS v1.1)
-- Hệ QT CSDL: Microsoft SQL Server 2019 / 2022
-- Tương thích: Jakarta Persistence (JPA 3.1) / Hibernate 6 / Tomcat 10.1 / Java 17
-- Ngày tạo: 2026-10-22
-- ============================================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'EduCenterDB')
BEGIN
    CREATE DATABASE EduCenterDB
    COLLATE Vietnamese_CI_AS;
END
GO

USE EduCenterDB;
GO

-- ============================================================================
-- PHẦN 1: XÓA CÁC BẢNG NẾU ĐÃ TỒN TẠI (THEO THỨ TỰ PHỤ THUỘC NGƯỢC)
-- ============================================================================
IF OBJECT_ID(N'dbo.AuditLogs', N'U') IS NOT NULL DROP TABLE dbo.AuditLogs;
IF OBJECT_ID(N'dbo.SystemSettings', N'U') IS NOT NULL DROP TABLE dbo.SystemSettings;
IF OBJECT_ID(N'dbo.Notifications', N'U') IS NOT NULL DROP TABLE dbo.Notifications;
IF OBJECT_ID(N'dbo.Answers', N'U') IS NOT NULL DROP TABLE dbo.Answers;
IF OBJECT_ID(N'dbo.Questions', N'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID(N'dbo.Payments', N'U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID(N'dbo.InvoiceItems', N'U') IS NOT NULL DROP TABLE dbo.InvoiceItems;
IF OBJECT_ID(N'dbo.Invoices', N'U') IS NOT NULL DROP TABLE dbo.Invoices;
IF OBJECT_ID(N'dbo.Discounts', N'U') IS NOT NULL DROP TABLE dbo.Discounts;
IF OBJECT_ID(N'dbo.TrialAssessments', N'U') IS NOT NULL DROP TABLE dbo.TrialAssessments;
IF OBJECT_ID(N'dbo.AssessmentScores', N'U') IS NOT NULL DROP TABLE dbo.AssessmentScores;
IF OBJECT_ID(N'dbo.Assessments', N'U') IS NOT NULL DROP TABLE dbo.Assessments;
IF OBJECT_ID(N'dbo.TeachingJournals', N'U') IS NOT NULL DROP TABLE dbo.TeachingJournals;
IF OBJECT_ID(N'dbo.Attendances', N'U') IS NOT NULL DROP TABLE dbo.Attendances;
IF OBJECT_ID(N'dbo.Enrollments', N'U') IS NOT NULL DROP TABLE dbo.Enrollments;
IF OBJECT_ID(N'dbo.RegistrationCartItems', N'U') IS NOT NULL DROP TABLE dbo.RegistrationCartItems;
IF OBJECT_ID(N'dbo.ClassSessions', N'U') IS NOT NULL DROP TABLE dbo.ClassSessions;
IF OBJECT_ID(N'dbo.Classes', N'U') IS NOT NULL DROP TABLE dbo.Classes;
IF OBJECT_ID(N'dbo.Rooms', N'U') IS NOT NULL DROP TABLE dbo.Rooms;
IF OBJECT_ID(N'dbo.Courses', N'U') IS NOT NULL DROP TABLE dbo.Courses;
IF OBJECT_ID(N'dbo.Subjects', N'U') IS NOT NULL DROP TABLE dbo.Subjects;
IF OBJECT_ID(N'dbo.Consultations', N'U') IS NOT NULL DROP TABLE dbo.Consultations;
IF OBJECT_ID(N'dbo.Leads', N'U') IS NOT NULL DROP TABLE dbo.Leads;
IF OBJECT_ID(N'dbo.StudentGuardians', N'U') IS NOT NULL DROP TABLE dbo.StudentGuardians;
IF OBJECT_ID(N'dbo.Guardians', N'U') IS NOT NULL DROP TABLE dbo.Guardians;
IF OBJECT_ID(N'dbo.Students', N'U') IS NOT NULL DROP TABLE dbo.Students;
IF OBJECT_ID(N'dbo.Teachers', N'U') IS NOT NULL DROP TABLE dbo.Teachers;
IF OBJECT_ID(N'dbo.UserRoles', N'U') IS NOT NULL DROP TABLE dbo.UserRoles;
IF OBJECT_ID(N'dbo.PasswordResetTokens', N'U') IS NOT NULL DROP TABLE dbo.PasswordResetTokens;
IF OBJECT_ID(N'dbo.Users', N'U') IS NOT NULL DROP TABLE dbo.Users;
IF OBJECT_ID(N'dbo.Roles', N'U') IS NOT NULL DROP TABLE dbo.Roles;
GO

-- ============================================================================
-- PHẦN 2: TẠO 30 BẢNG DỮ LIỆU
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Roles (Vai trò người dùng)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Roles (
    id INT IDENTITY(1,1) CONSTRAINT PK_Roles PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Roles_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Roles_CreatedAt DEFAULT GETDATE()
);
GO

-- ----------------------------------------------------------------------------
-- 2. Users (Tài khoản người dùng - BR01, SEC-01)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Users (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    email VARCHAR(255) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(150) NOT NULL,
    phone VARCHAR(20) NULL,
    avatar_url NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Users_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Users_Status CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Users_UpdatedAt DEFAULT GETDATE()
);
GO

-- ----------------------------------------------------------------------------
-- 2b. PasswordResetTokens (FR-004 Quên & đặt lại mật khẩu)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.PasswordResetTokens (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_PasswordResetTokens PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_hash VARCHAR(64) NOT NULL CONSTRAINT UQ_PasswordResetTokens_Hash UNIQUE,
    expires_at DATETIME2(0) NOT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_PasswordResetTokens_CreatedAt DEFAULT GETDATE(),
    consumed_at DATETIME2(0) NULL,
    CONSTRAINT FK_PasswordResetTokens_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO


-- ----------------------------------------------------------------------------
-- 3. UserRoles (Bảng nối Người dùng - Vai trò)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.UserRoles (
    user_id BIGINT NOT NULL,
    role_id INT NOT NULL,
    assigned_at DATETIME2(0) NOT NULL CONSTRAINT DF_UserRoles_AssignedAt DEFAULT GETDATE(),
    CONSTRAINT PK_UserRoles PRIMARY KEY (user_id, role_id),
    CONSTRAINT FK_UserRoles_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION,
    CONSTRAINT FK_UserRoles_Role FOREIGN KEY (role_id) REFERENCES dbo.Roles(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 4. Teachers (Hồ sơ Giáo viên / Gia sư)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Teachers (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Teachers PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT UQ_Teachers_UserId UNIQUE,
    full_name NVARCHAR(150) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    specialization NVARCHAR(255) NULL,
    degree NVARCHAR(100) NULL,
    bio NVARCHAR(MAX) NULL,
    hourly_rate DECIMAL(18,2) NOT NULL CONSTRAINT DF_Teachers_HourlyRate DEFAULT 0.00
        CONSTRAINT CK_Teachers_HourlyRate CHECK (hourly_rate >= 0),
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Teachers_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Teachers_Status CHECK (status IN ('ACTIVE', 'INACTIVE', 'ON_LEAVE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Teachers_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Teachers_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Teachers_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 5. Students (Hồ sơ Học viên)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Students (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Students PRIMARY KEY,
    user_id BIGINT NULL CONSTRAINT UQ_Students_UserId UNIQUE,
    full_name NVARCHAR(150) NOT NULL,
    dob DATE NULL,
    gender VARCHAR(10) NULL CONSTRAINT CK_Students_Gender CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    phone VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    school NVARCHAR(255) NULL,
    grade_level INT NOT NULL CONSTRAINT CK_Students_GradeLevel CHECK (grade_level BETWEEN 6 AND 12),
    target_goal NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Students_Status DEFAULT 'STUDYING'
        CONSTRAINT CK_Students_Status CHECK (status IN ('STUDYING', 'RESERVED', 'DROPPED', 'GRADUATED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Students_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Students_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Students_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 6. Guardians (Hồ sơ Phụ huynh / Người giám hộ)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Guardians (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Guardians PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT UQ_Guardians_UserId UNIQUE,
    full_name NVARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NULL,
    occupation NVARCHAR(150) NULL,
    address NVARCHAR(255) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Guardians_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Guardians_Status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Guardians_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Guardians_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Guardians_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 7. StudentGuardians (Liên kết Học viên - Phụ huynh, BR15)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.StudentGuardians (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_StudentGuardians PRIMARY KEY,
    student_id BIGINT NOT NULL,
    guardian_id BIGINT NOT NULL,
    relationship NVARCHAR(50) NOT NULL,
    is_primary BIT NOT NULL CONSTRAINT DF_StudentGuardians_IsPrimary DEFAULT 1,
    verified_at DATETIME2(0) NULL,
    verified_by BIGINT NULL,
    CONSTRAINT UQ_StudentGuardians_Pair UNIQUE (student_id, guardian_id),
    CONSTRAINT FK_StudentGuardians_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_StudentGuardians_Guardian FOREIGN KEY (guardian_id) REFERENCES dbo.Guardians(id) ON DELETE NO ACTION,
    CONSTRAINT FK_StudentGuardians_Verifier FOREIGN KEY (verified_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 8. Leads (Khách hàng tiềm năng CRM)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Leads (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Leads PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NULL,
    grade_level INT NULL CONSTRAINT CK_Leads_GradeLevel CHECK (grade_level BETWEEN 6 AND 12),
    source VARCHAR(50) NOT NULL CONSTRAINT DF_Leads_Source DEFAULT 'WEBSITE'
        CONSTRAINT CK_Leads_Source CHECK (source IN ('WEBSITE', 'FACEBOOK', 'HOTLINE', 'REFERRAL', 'DIRECT')),
    status VARCHAR(30) NOT NULL CONSTRAINT DF_Leads_Status DEFAULT 'NEW'
        CONSTRAINT CK_Leads_Status CHECK (status IN ('NEW', 'CONTACTED', 'ASSESSED', 'CONSULTING', 'ENROLLED', 'LOST')),
    notes NVARCHAR(MAX) NULL,
    assigned_to BIGINT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Leads_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Leads_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Leads_AssignedTo FOREIGN KEY (assigned_to) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 9. Consultations (Lịch sử tư vấn Lead)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Consultations (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Consultations PRIMARY KEY,
    lead_id BIGINT NOT NULL,
    staff_id BIGINT NOT NULL,
    notes NVARCHAR(MAX) NOT NULL,
    contacted_at DATETIME2(0) NOT NULL CONSTRAINT DF_Consultations_ContactedAt DEFAULT GETDATE(),
    next_appointment DATETIME2(0) NULL,
    CONSTRAINT FK_Consultations_Lead FOREIGN KEY (lead_id) REFERENCES dbo.Leads(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Consultations_Staff FOREIGN KEY (staff_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 10. Subjects (Môn học)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Subjects (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Subjects PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Subjects_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Subjects_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Subjects_Status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Subjects_CreatedAt DEFAULT GETDATE()
);
GO

-- ----------------------------------------------------------------------------
-- 11. Courses (Khóa học niêm yết)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Courses (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Courses PRIMARY KEY,
    subject_id BIGINT NOT NULL,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Courses_Code UNIQUE,
    name NVARCHAR(200) NOT NULL,
    grade_level INT NOT NULL CONSTRAINT CK_Courses_GradeLevel CHECK (grade_level BETWEEN 6 AND 12),
    target_exam NVARCHAR(100) NULL,
    fee DECIMAL(18,2) NOT NULL CONSTRAINT DF_Courses_Fee DEFAULT 0.00
        CONSTRAINT CK_Courses_Fee CHECK (fee >= 0),
    duration_weeks INT NOT NULL CONSTRAINT DF_Courses_DurationWeeks DEFAULT 12
        CONSTRAINT CK_Courses_DurationWeeks CHECK (duration_weeks > 0),
    total_sessions INT NOT NULL CONSTRAINT DF_Courses_TotalSessions DEFAULT 24
        CONSTRAINT CK_Courses_TotalSessions CHECK (total_sessions > 0),
    max_capacity INT NOT NULL CONSTRAINT DF_Courses_MaxCapacity DEFAULT 15
        CONSTRAINT CK_Courses_MaxCapacity CHECK (max_capacity > 0),
    description NVARCHAR(MAX) NULL,
    image_url NVARCHAR(500) NULL,
    is_featured BIT NOT NULL CONSTRAINT DF_Courses_IsFeatured DEFAULT 0,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Courses_Status DEFAULT 'OPEN'
        CONSTRAINT CK_Courses_Status CHECK (status IN ('OPEN', 'CLOSED', 'ARCHIVED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Courses_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Courses_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Courses_Subject FOREIGN KEY (subject_id) REFERENCES dbo.Subjects(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 12. Rooms (Phòng học)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Rooms (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Rooms PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Rooms_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    capacity INT NOT NULL CONSTRAINT CK_Rooms_Capacity CHECK (capacity > 0),
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Rooms_Status DEFAULT 'AVAILABLE'
        CONSTRAINT CK_Rooms_Status CHECK (status IN ('AVAILABLE', 'MAINTENANCE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Rooms_CreatedAt DEFAULT GETDATE()
);
GO

-- ----------------------------------------------------------------------------
-- 13. Classes (Lớp học cụ thể - BR04, BR19, SEC-04)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Classes (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Classes PRIMARY KEY,
    course_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    room_id BIGINT NULL,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Classes_Code UNIQUE,
    name NVARCHAR(200) NOT NULL,
    capacity INT NOT NULL CONSTRAINT CK_Classes_Capacity CHECK (capacity > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Classes_Status DEFAULT 'PLANNING'
        CONSTRAINT CK_Classes_Status CHECK (status IN ('PLANNING', 'OPEN', 'ONGOING', 'CLOSED', 'CANCELLED')),
    version BIGINT NOT NULL CONSTRAINT DF_Classes_Version DEFAULT 0, -- Optimistic Locking
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Classes_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Classes_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT CK_Classes_Dates CHECK (end_date >= start_date),
    CONSTRAINT FK_Classes_Course FOREIGN KEY (course_id) REFERENCES dbo.Courses(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Classes_Teacher FOREIGN KEY (teacher_id) REFERENCES dbo.Teachers(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Classes_Room FOREIGN KEY (room_id) REFERENCES dbo.Rooms(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 14. ClassSessions (Buổi học chi tiết - BR05, BR06)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.ClassSessions (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_ClassSessions PRIMARY KEY,
    class_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL, -- Giáo viên thực dạy (cho phép dạy thay)
    session_date DATE NOT NULL,
    start_at TIME(0) NOT NULL,
    end_at TIME(0) NOT NULL,
    title NVARCHAR(255) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_ClassSessions_Status DEFAULT 'SCHEDULED'
        CONSTRAINT CK_ClassSessions_Status CHECK (status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'RESCHEDULED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_ClassSessions_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_ClassSessions_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT CK_ClassSessions_Time CHECK (end_at > start_at),
    CONSTRAINT FK_ClassSessions_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE NO ACTION,
    CONSTRAINT FK_ClassSessions_Room FOREIGN KEY (room_id) REFERENCES dbo.Rooms(id) ON DELETE NO ACTION,
    CONSTRAINT FK_ClassSessions_Teacher FOREIGN KEY (teacher_id) REFERENCES dbo.Teachers(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 15. RegistrationCartItems (Giỏ hàng đăng ký khóa học - ASM 3.6)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.RegistrationCartItems (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_RegistrationCartItems PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    quantity INT NOT NULL CONSTRAINT DF_Cart_Quantity DEFAULT 1 CONSTRAINT CK_Cart_Quantity CHECK (quantity > 0),
    notes NVARCHAR(500) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Cart_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT UQ_RegistrationCartItems_User_Course UNIQUE (user_id, course_id),
    CONSTRAINT FK_RegistrationCartItems_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION,
    CONSTRAINT FK_RegistrationCartItems_Course FOREIGN KEY (course_id) REFERENCES dbo.Courses(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 16. Enrollments (Ghi danh học viên - BR03, BR04, BR16)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Enrollments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Enrollments PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    status VARCHAR(30) NOT NULL CONSTRAINT DF_Enrollments_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Enrollments_Status CHECK (status IN ('ACTIVE', 'RESERVED', 'TRANSFERRED', 'DROPPED', 'COMPLETED')),
    enrolled_at DATETIME2(0) NOT NULL CONSTRAINT DF_Enrollments_EnrolledAt DEFAULT GETDATE(),
    start_date DATE NOT NULL,
    end_date DATE NULL,
    notes NVARCHAR(500) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Enrollments_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Enrollments_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Enrollments_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Enrollments_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE NO ACTION
);
GO

-- Chỉ mục lọc ngăn chặn ghi danh trùng đang ACTIVE (BR03)
CREATE UNIQUE NONCLUSTERED INDEX UQ_Enrollment_Active 
ON dbo.Enrollments(student_id, class_id) 
WHERE status = 'ACTIVE';
GO

-- ----------------------------------------------------------------------------
-- 17. Attendances (Điểm danh học viên - BR08)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Attendances (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Attendances PRIMARY KEY,
    session_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    status VARCHAR(30) NOT NULL
        CONSTRAINT CK_Attendances_Status CHECK (status IN ('PRESENT', 'ABSENT_EXCUSED', 'ABSENT_UNEXCUSED', 'LATE')),
    remarks NVARCHAR(255) NULL,
    recorded_by BIGINT NULL,
    recorded_at DATETIME2(0) NOT NULL CONSTRAINT DF_Attendances_RecordedAt DEFAULT GETDATE(),
    CONSTRAINT UQ_Attendances_Session_Student UNIQUE (session_id, student_id),
    CONSTRAINT FK_Attendances_Session FOREIGN KEY (session_id) REFERENCES dbo.ClassSessions(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Attendances_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Attendances_Recorder FOREIGN KEY (recorded_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 18. TeachingJournals (Nhật ký giảng dạy buổi học)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.TeachingJournals (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_TeachingJournals PRIMARY KEY,
    session_id BIGINT NOT NULL CONSTRAINT UQ_TeachingJournals_SessionId UNIQUE,
    content NVARCHAR(MAX) NOT NULL,
    homework NVARCHAR(MAX) NULL,
    teacher_remarks NVARCHAR(MAX) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_TeachingJournals_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_TeachingJournals_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_TeachingJournals_Session FOREIGN KEY (session_id) REFERENCES dbo.ClassSessions(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 19. Assessments (Bài kiểm tra / Đánh giá - BR10, BR11)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Assessments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Assessments PRIMARY KEY,
    class_id BIGINT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    assessment_type VARCHAR(30) NOT NULL
        CONSTRAINT CK_Assessments_Type CHECK (assessment_type IN ('ENTRANCE', 'MID_TERM', 'FINAL', 'PERIODIC')),
    max_score DECIMAL(5,2) NOT NULL CONSTRAINT DF_Assessments_MaxScore DEFAULT 10.00
        CONSTRAINT CK_Assessments_MaxScore CHECK (max_score > 0),
    weight DECIMAL(4,2) NOT NULL CONSTRAINT DF_Assessments_Weight DEFAULT 1.00
        CONSTRAINT CK_Assessments_Weight CHECK (weight > 0),
    test_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Assessments_Status DEFAULT 'DRAFT'
        CONSTRAINT CK_Assessments_Status CHECK (status IN ('DRAFT', 'PUBLISHED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Assessments_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Assessments_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Assessments_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 20. AssessmentScores (Điểm kiểm tra của học sinh - BR09, BR10)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.AssessmentScores (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_AssessmentScores PRIMARY KEY,
    assessment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    score DECIMAL(5,2) NOT NULL CONSTRAINT CK_Scores_NonNegative CHECK (score >= 0),
    remarks NVARCHAR(500) NULL,
    graded_by BIGINT NULL,
    graded_at DATETIME2(0) NOT NULL CONSTRAINT DF_Scores_GradedAt DEFAULT GETDATE(),
    CONSTRAINT UQ_AssessmentScores_Pair UNIQUE (assessment_id, student_id),
    CONSTRAINT FK_AssessmentScores_Assessment FOREIGN KEY (assessment_id) REFERENCES dbo.Assessments(id) ON DELETE NO ACTION,
    CONSTRAINT FK_AssessmentScores_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_AssessmentScores_Grader FOREIGN KEY (graded_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 21. TrialAssessments (Kiểm tra năng lực đầu vào học sinh mới)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.TrialAssessments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_TrialAssessments PRIMARY KEY,
    lead_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    test_date DATE NOT NULL,
    score DECIMAL(4,2) NULL CONSTRAINT CK_TrialAssessments_Score CHECK (score BETWEEN 0 AND 10),
    notes NVARCHAR(MAX) NULL,
    evaluated_by BIGINT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_TrialAssessments_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_TrialAssessments_Lead FOREIGN KEY (lead_id) REFERENCES dbo.Leads(id) ON DELETE NO ACTION,
    CONSTRAINT FK_TrialAssessments_Subject FOREIGN KEY (subject_id) REFERENCES dbo.Subjects(id) ON DELETE NO ACTION,
    CONSTRAINT FK_TrialAssessments_Evaluator FOREIGN KEY (evaluated_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 22. Discounts (Mã giảm giá / Ưu đãi học phí)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Discounts (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Discounts PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Discounts_Code UNIQUE,
    name NVARCHAR(150) NOT NULL,
    discount_type VARCHAR(20) NOT NULL
        CONSTRAINT CK_Discounts_Type CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    discount_value DECIMAL(18,2) NOT NULL CONSTRAINT CK_Discounts_Value CHECK (discount_value > 0),
    max_discount_amount DECIMAL(18,2) NULL,
    min_invoice_amount DECIMAL(18,2) NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Discounts_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Discounts_Status CHECK (status IN ('ACTIVE', 'EXPIRED', 'DISABLED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Discounts_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT CK_Discounts_Dates CHECK (end_date >= start_date)
);
GO

-- ----------------------------------------------------------------------------
-- 23. Invoices (Hóa đơn học phí - BR12, BR16, SEC-03, SEC-04)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Invoices (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Invoices PRIMARY KEY,
    invoice_code VARCHAR(50) NOT NULL CONSTRAINT UQ_Invoices_Code UNIQUE,
    enrollment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    total_amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Invoices_TotalAmount DEFAULT 0.00
        CONSTRAINT CK_Invoices_TotalAmount CHECK (total_amount >= 0),
    discount_amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Invoices_DiscountAmount DEFAULT 0.00
        CONSTRAINT CK_Invoices_DiscountAmount CHECK (discount_amount >= 0),
    final_amount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Invoices_FinalAmount DEFAULT 0.00
        CONSTRAINT CK_Invoices_FinalAmount CHECK (final_amount >= 0),
    status VARCHAR(30) NOT NULL CONSTRAINT DF_Invoices_Status DEFAULT 'UNPAID'
        CONSTRAINT CK_Invoices_Status CHECK (status IN ('UNPAID', 'PARTIALLY_PAID', 'PAID', 'CANCELLED')),
    due_date DATE NOT NULL,
    notes NVARCHAR(500) NULL,
    version BIGINT NOT NULL CONSTRAINT DF_Invoices_Version DEFAULT 0, -- Optimistic Locking
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Invoices_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Invoices_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Invoices_Enrollment FOREIGN KEY (enrollment_id) REFERENCES dbo.Enrollments(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Invoices_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 24. InvoiceItems (Chi tiết mục thu trong hóa đơn)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.InvoiceItems (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_InvoiceItems PRIMARY KEY,
    invoice_id BIGINT NOT NULL,
    description NVARCHAR(255) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL CONSTRAINT CK_InvoiceItems_UnitPrice CHECK (unit_price >= 0),
    quantity INT NOT NULL CONSTRAINT DF_InvoiceItems_Qty DEFAULT 1 CONSTRAINT CK_InvoiceItems_Qty CHECK (quantity > 0),
    amount DECIMAL(18,2) NOT NULL CONSTRAINT CK_InvoiceItems_Amount CHECK (amount >= 0),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_InvoiceItems_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_InvoiceItems_Invoice FOREIGN KEY (invoice_id) REFERENCES dbo.Invoices(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 25. Payments (Phiếu thu / Giao dịch thanh toán - BR13, BR14, BR16)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Payments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Payments PRIMARY KEY,
    payment_code VARCHAR(50) NOT NULL CONSTRAINT UQ_Payments_Code UNIQUE,
    invoice_id BIGINT NOT NULL,
    amount DECIMAL(18,2) NOT NULL CONSTRAINT CK_Payments_Amount CHECK (amount > 0),
    payment_method VARCHAR(30) NOT NULL
        CONSTRAINT CK_Payments_Method CHECK (payment_method IN ('CASH', 'BANK_TRANSFER', 'VNPAY', 'MOMO')),
    transaction_ref VARCHAR(100) NULL,
    paid_at DATETIME2(0) NOT NULL CONSTRAINT DF_Payments_PaidAt DEFAULT GETDATE(),
    confirmed_by BIGINT NOT NULL,
    notes NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Payments_Status DEFAULT 'CONFIRMED'
        CONSTRAINT CK_Payments_Status CHECK (status IN ('CONFIRMED', 'CANCELLED', 'REFUNDED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Payments_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Payments_Invoice FOREIGN KEY (invoice_id) REFERENCES dbo.Invoices(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Payments_Confirmer FOREIGN KEY (confirmed_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 26. Questions (Câu hỏi Q&A diễn đàn - BR17, ASM 3.8)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Questions (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Questions PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NULL,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Questions_Status DEFAULT 'PENDING'
        CONSTRAINT CK_Questions_Status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'HIDDEN')),
    moderated_by BIGINT NULL,
    moderated_at DATETIME2(0) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Questions_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Questions_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Questions_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Questions_Course FOREIGN KEY (course_id) REFERENCES dbo.Courses(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Questions_Moderator FOREIGN KEY (moderated_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 27. Answers (Câu trả lời Q&A - BR17)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Answers (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Answers PRIMARY KEY,
    question_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    is_accepted BIT NOT NULL CONSTRAINT DF_Answers_IsAccepted DEFAULT 0,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Answers_Status DEFAULT 'PENDING'
        CONSTRAINT CK_Answers_Status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'HIDDEN')),
    moderated_by BIGINT NULL,
    moderated_at DATETIME2(0) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Answers_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Answers_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Answers_Question FOREIGN KEY (question_id) REFERENCES dbo.Questions(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Answers_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Answers_Moderator FOREIGN KEY (moderated_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 28. Notifications (Thông báo người dùng)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.Notifications (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Notifications PRIMARY KEY,
    recipient_id BIGINT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    type VARCHAR(50) NOT NULL CONSTRAINT DF_Notifications_Type DEFAULT 'GENERAL'
        CONSTRAINT CK_Notifications_Type CHECK (type IN ('TIMETABLE', 'ATTENDANCE', 'GRADE', 'TUITION', 'GENERAL')),
    related_entity_type VARCHAR(50) NULL,
    related_entity_id BIGINT NULL,
    is_read BIT NOT NULL CONSTRAINT DF_Notifications_IsRead DEFAULT 0,
    read_at DATETIME2(0) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Notifications_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_Recipient FOREIGN KEY (recipient_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 29. AuditLogs (Nhật ký hệ thống - BR18)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.AuditLogs (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_AuditLogs PRIMARY KEY,
    actor_id BIGINT NULL,
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id BIGINT NOT NULL,
    old_values NVARCHAR(MAX) NULL,
    new_values NVARCHAR(MAX) NULL,
    ip_address VARCHAR(45) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_AuditLogs_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_AuditLogs_Actor FOREIGN KEY (actor_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ----------------------------------------------------------------------------
-- 30. SystemSettings (Tham số cấu hình hệ thống)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.SystemSettings (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_SystemSettings PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL CONSTRAINT UQ_SystemSettings_Key UNIQUE,
    setting_value NVARCHAR(MAX) NOT NULL,
    description NVARCHAR(255) NULL,
    updated_by BIGINT NULL,
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_SystemSettings_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_SystemSettings_Updater FOREIGN KEY (updated_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- ============================================================================
-- PHẦN 3: TẠO CHỈ MỤC NON-CLUSTERED INDEX (TỐI ƯU HIỆU NĂNG QUERY)
-- ============================================================================
CREATE NONCLUSTERED INDEX IX_Users_Status ON dbo.Users(status);
CREATE NONCLUSTERED INDEX IX_Courses_Subject ON dbo.Courses(subject_id, grade_level, status);
CREATE NONCLUSTERED INDEX IX_Classes_Course ON dbo.Classes(course_id, status);
CREATE NONCLUSTERED INDEX IX_Classes_Teacher ON dbo.Classes(teacher_id, status);
CREATE NONCLUSTERED INDEX IX_ClassSessions_Teacher_Time ON dbo.ClassSessions(teacher_id, session_date, start_at, end_at);
CREATE NONCLUSTERED INDEX IX_ClassSessions_Room_Time ON dbo.ClassSessions(room_id, session_date, start_at, end_at);
CREATE NONCLUSTERED INDEX IX_ClassSessions_Class_Date ON dbo.ClassSessions(class_id, session_date);
CREATE NONCLUSTERED INDEX IX_Enrollments_Student ON dbo.Enrollments(student_id, status);
CREATE NONCLUSTERED INDEX IX_Enrollments_Class ON dbo.Enrollments(class_id, status);
CREATE NONCLUSTERED INDEX IX_Attendances_Session ON dbo.Attendances(session_id);
CREATE NONCLUSTERED INDEX IX_Attendances_Student ON dbo.Attendances(student_id);
CREATE NONCLUSTERED INDEX IX_AssessmentScores_Student ON dbo.AssessmentScores(student_id);
CREATE NONCLUSTERED INDEX IX_Invoices_Student ON dbo.Invoices(student_id, status);
CREATE NONCLUSTERED INDEX IX_Invoices_Enrollment ON dbo.Invoices(enrollment_id);
CREATE NONCLUSTERED INDEX IX_Payments_Invoice ON dbo.Payments(invoice_id, status);
CREATE NONCLUSTERED INDEX IX_Leads_AssignedTo ON dbo.Leads(assigned_to, status);
CREATE NONCLUSTERED INDEX IX_Consultations_Lead ON dbo.Consultations(lead_id);
CREATE NONCLUSTERED INDEX IX_Questions_Status ON dbo.Questions(status, created_at DESC);
CREATE NONCLUSTERED INDEX IX_Notifications_Recipient ON dbo.Notifications(recipient_id, is_read, created_at DESC);
CREATE NONCLUSTERED INDEX IX_AuditLogs_Entity ON dbo.AuditLogs(entity_type, entity_id, created_at DESC);
GO

-- ============================================================================
-- PHẦN 4: DỮ LIỆU KHỞI TẠO (SEED DATA)
-- ============================================================================

-- 1. 5 Vai trò hệ thống chuẩn (Admin kiêm Quản lý trung tâm)
INSERT INTO dbo.Roles (code, name, description) VALUES
('ADMIN', N'Quản trị viên & Quản lý trung tâm', N'Toàn quyền quản trị hệ thống, tài khoản, cấu hình, phê duyệt và xem báo cáo tài chính'),
('STAFF', N'Nhân viên tuyển sinh & Học vụ', N'Tư vấn CRM, ghi danh học viên, xếp lịch và thu học phí'),
('TEACHER', N'Giáo viên / Gia sư', N'Giảng dạy, điểm danh, ra bài kiểm tra và chấm điểm'),
('STUDENT', N'Học viên', N'Xem lịch học, tiến độ, điểm số, học phí và hỏi đáp'),
('PARENT', N'Phụ huynh học sinh', N'Theo dõi chuyên cần, kết quả học tập và công nợ của con');
GO

-- 2. Tài khoản Demo cho 5 vai trò hệ thống (Mật khẩu chung cho tất cả: 123456)
-- Hash BCrypt cho '123456': $2a$10$qR6QdEaFmZtC3UvBnX9TLeh7I.3.i9nKbPwqh4oF2wZtVvS4rN9rO
INSERT INTO dbo.Users (email, password_hash, full_name, phone, avatar_url, status) VALUES
('admin@educenter.vn', '$2a$10$qR6QdEaFmZtC3UvBnX9TLeh7I.3.i9nKbPwqh4oF2wZtVvS4rN9rO', N'Nguyễn Quản Trị (Admin & Manager)', '0901234567', NULL, 'ACTIVE'),
('staff@educenter.vn', '$2a$10$qR6QdEaFmZtC3UvBnX9TLeh7I.3.i9nKbPwqh4oF2wZtVvS4rN9rO', N'Trần Thu Hà (Tư Vấn & Tuyển Sinh)', '0912345678', NULL, 'ACTIVE'),
('teacher.hung@educenter.vn', '$2a$10$qR6QdEaFmZtC3UvBnX9TLeh7I.3.i9nKbPwqh4oF2wZtVvS4rN9rO', N'ThS. Lê Mạnh Hùng (Giáo Viên Toán)', '0987654321', '/assets/images/teachers/teacher-hung.jpg', 'ACTIVE'),
('student.nam@educenter.vn', '$2a$10$qR6QdEaFmZtC3UvBnX9TLeh7I.3.i9nKbPwqh4oF2wZtVvS4rN9rO', N'Trần Hoàng Nam (Học Viên Lớp 12)', '0933112233', NULL, 'ACTIVE'),
('parent.tuan@educenter.vn', '$2a$10$qR6QdEaFmZtC3UvBnX9TLeh7I.3.i9nKbPwqh4oF2wZtVvS4rN9rO', N'Trần Quốc Tuấn (Phụ Huynh)', '0944556677', NULL, 'ACTIVE');
GO

-- Gán vai trò tương ứng cho từng tài khoản demo
INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r 
WHERE u.email = 'admin@educenter.vn' AND r.code = 'ADMIN';

INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r 
WHERE u.email = 'staff@educenter.vn' AND r.code = 'STAFF';

INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r 
WHERE u.email = 'teacher.hung@educenter.vn' AND r.code = 'TEACHER';

INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r 
WHERE u.email = 'student.nam@educenter.vn' AND r.code = 'STUDENT';

INSERT INTO dbo.UserRoles (user_id, role_id)
SELECT u.id, r.id FROM dbo.Users u, dbo.Roles r 
WHERE u.email = 'parent.tuan@educenter.vn' AND r.code = 'PARENT';
GO

-- Hồ sơ giáo viên mẫu (liên kết 1:1 với teacher.hung)
INSERT INTO dbo.Teachers (user_id, full_name, phone, email, specialization, degree, bio, hourly_rate)
SELECT id, full_name, phone, email, N'Toán THPT, Ôn thi tốt nghiệp & Đánh giá năng lực', N'Thạc sĩ Toán học - ĐH Sư Phạm Hà Nội', N'12 năm kinh nghiệm luyện thi THPT Quốc gia', 350000.00
FROM dbo.Users WHERE email = 'teacher.hung@educenter.vn';

-- Hồ sơ học viên mẫu (liên kết với student.nam)
INSERT INTO dbo.Students (user_id, full_name, dob, gender, phone, email, school, grade_level, target_goal)
SELECT id, full_name, '2008-05-15', 'MALE', phone, email, N'THPT Chu Văn An', 12, N'Đạt 8.5+ môn Toán thi Tốt nghiệp THPT'
FROM dbo.Users WHERE email = 'student.nam@educenter.vn';

-- Hồ sơ phụ huynh mẫu (liên kết với parent.tuan)
INSERT INTO dbo.Guardians (user_id, full_name, phone, email, occupation, address)
SELECT id, full_name, phone, email, N'Kỹ sư CNTT', N'Số 45 Hoàng Quốc Việt, Cầu Giấy, Hà Nội'
FROM dbo.Users WHERE email = 'parent.tuan@educenter.vn';

-- Liên kết xác thực phụ huynh - học viên (BR15)
INSERT INTO dbo.StudentGuardians (student_id, guardian_id, relationship, is_primary, verified_at, verified_by)
SELECT s.id, g.id, N'Bố', 1, GETDATE(), u.id
FROM dbo.Students s, dbo.Guardians g, dbo.Users u
WHERE s.email = 'student.nam@educenter.vn' 
  AND g.email = 'parent.tuan@educenter.vn' 
  AND u.email = 'admin@educenter.vn';
GO

-- 3. Môn học chuẩn
INSERT INTO dbo.Subjects (code, name, description) VALUES
('MATH', N'Toán học', N'Bổ trợ kiến thức và luyện thi Toán từ lớp 6 đến lớp 12'),
('LIT', N'Ngữ văn', N'Luyện kỹ năng nghị luận văn học và nghị luận xã hội'),
('ENG', N'Tiếng Anh', N'Ngữ pháp THCS, THPT và luyện thi chứng chỉ / tốt nghiệp'),
('PHYS', N'Vật lý', N'Bổ trợ kiến thức và phương pháp giải nhanh trắc nghiệm'),
('CHEM', N'Hóa học', N'Hóa học đại cương và chuyên đề luyện thi'),
('BIO', N'Sinh học', N'Chuyên đề Sinh học luyện thi khối B');
GO

-- 4. Phòng học chuẩn
INSERT INTO dbo.Rooms (code, name, capacity, status) VALUES
('P101', N'Phòng 101 (Tầng 1 - Máy chiếu, Điều hòa)', 20, 'AVAILABLE'),
('P102', N'Phòng 102 (Tầng 1 - Bảng từ, Điều hòa)', 15, 'AVAILABLE'),
('P201', N'Phòng 201 (Tầng 2 - Lớp VIP 1-1)', 6, 'AVAILABLE'),
('P202', N'Phòng 202 (Tầng 2 - Tiêu chuẩn 15 chỗ)', 15, 'AVAILABLE'),
('LAB01', N'Phòng Lab Máy Tính (Tầng 3)', 25, 'AVAILABLE');
GO

-- 5. Khóa học mẫu
INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, image_url, is_featured)
SELECT id, 'TOAN12-TN', N'Toán 12 – Luyện Thi Tốt Nghiệp THPT Điểm 8+', 12, N'Tốt nghiệp THPT', 4200000.00, 12, 24, 15, N'Khóa học trọng điểm tổng ôn toàn bộ kiến thức Toán 12 và phương pháp giải đề nhanh.', '/assets/images/courses/math.jpg', 1
FROM dbo.Subjects WHERE code = 'MATH';

INSERT INTO dbo.Courses (subject_id, code, name, grade_level, target_exam, fee, duration_weeks, total_sessions, max_capacity, description, image_url, is_featured)
SELECT id, 'ENG9-VAO10', N'Tiếng Anh 9 – Chinh Phục Kỳ Thi Vào Lớp 10', 9, N'Vào 10 Chuyên & Không Chuyên', 3600000.00, 10, 20, 12, N'Hệ thống hóa ngữ pháp trọng tâm, từ vựng theo chủ đề và rèn kỹ năng làm bài thi trắc nghiệm.', '/assets/images/courses/english.jpg', 1
FROM dbo.Subjects WHERE code = 'ENG';
GO

-- 6. Tham số hệ thống cấu hình
INSERT INTO dbo.SystemSettings (setting_key, setting_value, description) VALUES
('CENTER_NAME', N'EduCenter - Trung Tâm Bồi Dưỡng Văn Hóa & Luyện Thi', N'Tên chính thức hiển thị trên website và hóa đơn'),
('CENTER_HOTLINE', '0988.123.456', N'Hotline tư vấn và tiếp nhận phụ huynh'),
('CENTER_ADDRESS', N'Số 123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội', N'Địa chỉ cơ sở chính'),
('MAX_CLASS_CAPACITY_DEFAULT', '15', N'Sĩ số tối đa mặc định cho các lớp học nhóm'),
('TUITION_DUE_DAYS', '7', N'Số ngày cho phép hoàn thành học phí sau khi tạo hóa đơn');
GO

PRINT N'Khởi tạo Cơ sở dữ liệu EduCenterDB (SQL Server) thành công với đầy đủ 30 bảng và dữ liệu mẫu!';
GO
