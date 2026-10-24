-- ============================================================================
-- EDUCENTER ERP - BƯỚC 01: KHỞI TẠO CƠ SỞ DỮ LIỆU & 30 BẢNG CHUẨN
-- Hệ QT CSDL: Microsoft SQL Server 2019 / 2022
-- Chuẩn mã hóa: Unicode UTF-8 (Vietnamese_CI_AS)
-- ============================================================================

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'EduCenterDB')
BEGIN
    CREATE DATABASE EduCenterDB
    COLLATE Vietnamese_CI_AS;
    PRINT N'Đã tạo cơ sở dữ liệu EduCenterDB thành công.';
END
ELSE
BEGIN
    PRINT N'Cơ sở dữ liệu EduCenterDB đã tồn tại.';
END
GO

USE EduCenterDB;
GO

SET NOCOUNT ON;
GO

-- Xóa các bảng cũ theo thứ tự ràng buộc ngược nếu đã tồn tại
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

-- 1. Roles
CREATE TABLE dbo.Roles (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Roles PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Roles_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(255) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Roles_CreatedAt DEFAULT GETDATE()
);
GO

-- 2. Users
CREATE TABLE dbo.Users (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Users PRIMARY KEY,
    email VARCHAR(255) NOT NULL CONSTRAINT UQ_Users_Email UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    avatar_url VARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Users_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Users_Status CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Users_UpdatedAt DEFAULT GETDATE()
);
GO

-- 3. PasswordResetTokens (FR-004 Quên & đặt lại mật khẩu)
CREATE TABLE dbo.PasswordResetTokens (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_PasswordResetTokens PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_hash VARCHAR(64) NOT NULL CONSTRAINT UQ_PasswordResetTokens_Hash UNIQUE,
    expires_at DATETIME2(0) NOT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_PasswordResetTokens_CreatedAt DEFAULT GETDATE(),
    consumed_at DATETIME2(0) NULL,
    CONSTRAINT FK_PasswordResetTokens_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE CASCADE
);
GO

-- 4. UserRoles
CREATE TABLE dbo.UserRoles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at DATETIME2(0) NOT NULL CONSTRAINT DF_UserRoles_AssignedAt DEFAULT GETDATE(),
    CONSTRAINT PK_UserRoles PRIMARY KEY (user_id, role_id),
    CONSTRAINT FK_UserRoles_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE CASCADE,
    CONSTRAINT FK_UserRoles_Role FOREIGN KEY (role_id) REFERENCES dbo.Roles(id) ON DELETE CASCADE
);
GO

-- 5. Teachers
CREATE TABLE dbo.Teachers (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Teachers PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT UQ_Teachers_User UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    specialization NVARCHAR(255) NULL,
    degree NVARCHAR(100) NULL,
    bio NVARCHAR(MAX) NULL,
    hourly_rate DECIMAL(18,2) NULL CONSTRAINT CK_Teachers_HourlyRate CHECK (hourly_rate >= 0),
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Teachers_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Teachers_Status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Teachers_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Teachers_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Teachers_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE CASCADE
);
GO

-- 6. Students
CREATE TABLE dbo.Students (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Students PRIMARY KEY,
    user_id BIGINT NULL CONSTRAINT UQ_Students_User UNIQUE,
    code AS ('HV' + RIGHT('0000' + CAST(id AS VARCHAR(6)), 4)) PERSISTED,
    full_name NVARCHAR(100) NOT NULL,
    dob DATE NULL,
    gender VARCHAR(10) NULL CONSTRAINT CK_Students_Gender CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    phone VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
    school NVARCHAR(255) NULL,
    grade_level INT NULL CONSTRAINT CK_Students_Grade CHECK (grade_level BETWEEN 6 AND 12),
    target_goal NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Students_Status DEFAULT 'STUDYING'
        CONSTRAINT CK_Students_Status CHECK (status IN ('STUDYING', 'RESERVED', 'DROPPED', 'GRADUATED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Students_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Students_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Students_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE SET NULL
);
GO

-- 7. Guardians
CREATE TABLE dbo.Guardians (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Guardians PRIMARY KEY,
    user_id BIGINT NOT NULL CONSTRAINT UQ_Guardians_User UNIQUE,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NULL,
    occupation NVARCHAR(100) NULL,
    address NVARCHAR(255) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Guardians_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Guardians_Status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Guardians_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Guardians_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Guardians_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE CASCADE
);
GO

-- 8. StudentGuardians
CREATE TABLE dbo.StudentGuardians (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_StudentGuardians PRIMARY KEY,
    student_id BIGINT NOT NULL,
    guardian_id BIGINT NOT NULL,
    relationship NVARCHAR(50) NOT NULL,
    is_primary BIT NOT NULL CONSTRAINT DF_StudentGuardians_Primary DEFAULT 0,
    verified_at DATETIME2(0) NULL,
    verified_by BIGINT NULL,
    notes NVARCHAR(255) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_StudentGuardians_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT UQ_StudentGuardians UNIQUE (student_id, guardian_id),
    CONSTRAINT FK_StudentGuardians_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE CASCADE,
    CONSTRAINT FK_StudentGuardians_Guardian FOREIGN KEY (guardian_id) REFERENCES dbo.Guardians(id) ON DELETE CASCADE,
    CONSTRAINT FK_StudentGuardians_Verifier FOREIGN KEY (verified_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- 9. Leads
CREATE TABLE dbo.Leads (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Leads PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NULL,
    grade_level INT NULL CONSTRAINT CK_Leads_Grade CHECK (grade_level BETWEEN 6 AND 12),
    source VARCHAR(50) NOT NULL CONSTRAINT DF_Leads_Source DEFAULT 'WEBSITE'
        CONSTRAINT CK_Leads_Source CHECK (source IN ('WEBSITE', 'FACEBOOK', 'HOTLINE', 'REFERRAL', 'WALK_IN')),
    status VARCHAR(30) NOT NULL CONSTRAINT DF_Leads_Status DEFAULT 'NEW'
        CONSTRAINT CK_Leads_Status CHECK (status IN ('NEW', 'CONTACTED', 'CONSULTING', 'CONSULTED', 'ASSESSED', 'TEST_SCHEDULED', 'ENROLLED', 'LOST', 'CANCELLED')),
    assigned_to BIGINT NULL,
    notes NVARCHAR(MAX) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Leads_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Leads_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Leads_Staff FOREIGN KEY (assigned_to) REFERENCES dbo.Users(id) ON DELETE SET NULL
);
GO

-- 10. Consultations
CREATE TABLE dbo.Consultations (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Consultations PRIMARY KEY,
    lead_id BIGINT NOT NULL,
    staff_id BIGINT NOT NULL,
    notes NVARCHAR(MAX) NOT NULL,
    contacted_at DATETIME2(0) NOT NULL CONSTRAINT DF_Consultations_ContactedAt DEFAULT GETDATE(),
    next_appointment DATETIME2(0) NULL,
    CONSTRAINT FK_Consultations_Lead FOREIGN KEY (lead_id) REFERENCES dbo.Leads(id) ON DELETE CASCADE,
    CONSTRAINT FK_Consultations_Staff FOREIGN KEY (staff_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- 11. Subjects
CREATE TABLE dbo.Subjects (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Subjects PRIMARY KEY,
    code VARCHAR(30) NOT NULL CONSTRAINT UQ_Subjects_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Subjects_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Subjects_Status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Subjects_CreatedAt DEFAULT GETDATE()
);
GO

-- 12. Courses
CREATE TABLE dbo.Courses (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Courses PRIMARY KEY,
    subject_id BIGINT NOT NULL,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Courses_Code UNIQUE,
    name NVARCHAR(200) NOT NULL,
    grade_level INT NOT NULL CONSTRAINT CK_Courses_Grade CHECK (grade_level BETWEEN 6 AND 12),
    target_exam NVARCHAR(100) NULL,
    fee DECIMAL(18,2) NOT NULL CONSTRAINT CK_Courses_Fee CHECK (fee >= 0),
    duration_weeks INT NOT NULL CONSTRAINT CK_Courses_Duration CHECK (duration_weeks > 0),
    total_sessions INT NOT NULL CONSTRAINT CK_Courses_Sessions CHECK (total_sessions > 0),
    max_capacity INT NOT NULL CONSTRAINT DF_Courses_Capacity DEFAULT 15 CONSTRAINT CK_Courses_Capacity CHECK (max_capacity > 0),
    description NVARCHAR(MAX) NULL,
    image_url VARCHAR(500) NULL,
    is_featured BIT NOT NULL CONSTRAINT DF_Courses_Featured DEFAULT 0,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Courses_Status DEFAULT 'OPEN'
        CONSTRAINT CK_Courses_Status CHECK (status IN ('OPEN', 'CLOSED', 'ARCHIVED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Courses_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Courses_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Courses_Subject FOREIGN KEY (subject_id) REFERENCES dbo.Subjects(id) ON DELETE NO ACTION
);
GO

-- 13. Rooms
CREATE TABLE dbo.Rooms (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Rooms PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Rooms_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    capacity INT NOT NULL CONSTRAINT CK_Rooms_Capacity CHECK (capacity > 0),
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Rooms_Status DEFAULT 'AVAILABLE'
        CONSTRAINT CK_Rooms_Status CHECK (status IN ('AVAILABLE', 'OCCUPIED', 'MAINTENANCE')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Rooms_CreatedAt DEFAULT GETDATE()
);
GO

-- 14. Classes
CREATE TABLE dbo.Classes (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Classes PRIMARY KEY,
    course_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    room_id BIGINT NULL,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Classes_Code UNIQUE,
    name NVARCHAR(200) NOT NULL,
    capacity INT NOT NULL CONSTRAINT DF_Classes_Capacity DEFAULT 15 CONSTRAINT CK_Classes_Capacity CHECK (capacity > 0),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Classes_Status DEFAULT 'OPEN'
        CONSTRAINT CK_Classes_Status CHECK (status IN ('OPEN', 'ONGOING', 'COMPLETED', 'CANCELLED')),
    version INT NOT NULL CONSTRAINT DF_Classes_Version DEFAULT 0,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Classes_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Classes_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT CK_Classes_Dates CHECK (end_date >= start_date),
    CONSTRAINT FK_Classes_Course FOREIGN KEY (course_id) REFERENCES dbo.Courses(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Classes_Teacher FOREIGN KEY (teacher_id) REFERENCES dbo.Teachers(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Classes_Room FOREIGN KEY (room_id) REFERENCES dbo.Rooms(id) ON DELETE SET NULL
);
GO

-- 15. ClassSessions
CREATE TABLE dbo.ClassSessions (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_ClassSessions PRIMARY KEY,
    class_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    session_date DATE NOT NULL,
    start_at TIME(0) NOT NULL,
    end_at TIME(0) NOT NULL,
    title NVARCHAR(255) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_ClassSessions_Status DEFAULT 'SCHEDULED'
        CONSTRAINT CK_ClassSessions_Status CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_ClassSessions_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_ClassSessions_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT CK_ClassSessions_Time CHECK (end_at > start_at),
    CONSTRAINT FK_ClassSessions_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE CASCADE,
    CONSTRAINT FK_ClassSessions_Teacher FOREIGN KEY (teacher_id) REFERENCES dbo.Teachers(id) ON DELETE NO ACTION,
    CONSTRAINT FK_ClassSessions_Room FOREIGN KEY (room_id) REFERENCES dbo.Rooms(id) ON DELETE NO ACTION
);
GO

-- 16. RegistrationCartItems
CREATE TABLE dbo.RegistrationCartItems (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_RegistrationCartItems PRIMARY KEY,
    user_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    quantity INT NOT NULL CONSTRAINT DF_RegistrationCartItems_Quantity DEFAULT 1,
    notes NVARCHAR(500) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_RegistrationCartItems_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT UQ_RegistrationCartItems_User_Course UNIQUE (user_id, course_id),
    CONSTRAINT FK_RegistrationCartItems_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION,
    CONSTRAINT FK_RegistrationCartItems_Course FOREIGN KEY (course_id) REFERENCES dbo.Courses(id) ON DELETE CASCADE
);
GO

-- 17. Enrollments
CREATE TABLE dbo.Enrollments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Enrollments PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    enrolled_at DATETIME2(0) NOT NULL CONSTRAINT DF_Enrollments_EnrolledAt DEFAULT GETDATE(),
    start_date DATE NOT NULL,
    end_date DATE NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Enrollments_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Enrollments_Status CHECK (status IN ('ACTIVE', 'RESERVED', 'TRANSFERRED', 'DROPPED')),
    notes NVARCHAR(500) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Enrollments_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Enrollments_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Enrollments_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Enrollments_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE NO ACTION
);
GO

-- 18. Attendances
CREATE TABLE dbo.Attendances (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Attendances PRIMARY KEY,
    session_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    status VARCHAR(20) NOT NULL
        CONSTRAINT CK_Attendances_Status CHECK (status IN ('PRESENT', 'LATE', 'ABSENT_EXCUSED', 'ABSENT_UNEXCUSED')),
    remarks NVARCHAR(255) NULL,
    notes NVARCHAR(255) NULL,
    recorded_at DATETIME2(0) NOT NULL CONSTRAINT DF_Attendances_RecordedAt DEFAULT GETDATE(),
    recorded_by BIGINT NOT NULL,
    CONSTRAINT UQ_Attendances UNIQUE (session_id, student_id),
    CONSTRAINT FK_Attendances_Session FOREIGN KEY (session_id) REFERENCES dbo.ClassSessions(id) ON DELETE CASCADE,
    CONSTRAINT FK_Attendances_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Attendances_Recorder FOREIGN KEY (recorded_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- 19. TeachingJournals
CREATE TABLE dbo.TeachingJournals (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_TeachingJournals PRIMARY KEY,
    session_id BIGINT NOT NULL CONSTRAINT UQ_TeachingJournals_Session UNIQUE,
    content NVARCHAR(MAX) NOT NULL,
    homework NVARCHAR(MAX) NULL,
    teacher_remarks NVARCHAR(MAX) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_TeachingJournals_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_TeachingJournals_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_TeachingJournals_Session FOREIGN KEY (session_id) REFERENCES dbo.ClassSessions(id) ON DELETE CASCADE
);
GO

-- 20. Assessments
CREATE TABLE dbo.Assessments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Assessments PRIMARY KEY,
    class_id BIGINT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    name NVARCHAR(200) NULL,
    assessment_type VARCHAR(30) NOT NULL CONSTRAINT DF_Assessments_Type DEFAULT 'MID_TERM'
        CONSTRAINT CK_Assessments_Type CHECK (assessment_type IN ('ENTRANCE', '15_MIN', '1_PERIOD', 'MID_TERM', 'FINAL', 'TRIAL', 'QUIZ', 'HOMEWORK')),
    weight DECIMAL(4,2) NOT NULL CONSTRAINT DF_Assessments_Weight DEFAULT 1.00 CONSTRAINT CK_Assessments_Weight CHECK (weight > 0),
    max_score DECIMAL(5,2) NOT NULL CONSTRAINT DF_Assessments_MaxScore DEFAULT 10.00 CONSTRAINT CK_Assessments_MaxScore CHECK (max_score > 0),
    test_date DATE NOT NULL,
    description NVARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Assessments_Status DEFAULT 'DRAFT'
        CONSTRAINT CK_Assessments_Status CHECK (status IN ('DRAFT', 'PUBLISHED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Assessments_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Assessments_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Assessments_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE CASCADE
);
GO

-- 21. AssessmentScores
CREATE TABLE dbo.AssessmentScores (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_AssessmentScores PRIMARY KEY,
    assessment_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    score DECIMAL(5,2) NOT NULL CONSTRAINT CK_AssessmentScores_Score CHECK (score >= 0),
    remarks NVARCHAR(500) NULL,
    feedback NVARCHAR(500) NULL,
    graded_at DATETIME2(0) NOT NULL CONSTRAINT DF_AssessmentScores_GradedAt DEFAULT GETDATE(),
    graded_by BIGINT NOT NULL,
    CONSTRAINT UQ_AssessmentScores UNIQUE (assessment_id, student_id),
    CONSTRAINT FK_AssessmentScores_Assessment FOREIGN KEY (assessment_id) REFERENCES dbo.Assessments(id) ON DELETE CASCADE,
    CONSTRAINT FK_AssessmentScores_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION,
    CONSTRAINT FK_AssessmentScores_Grader FOREIGN KEY (graded_by) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- 22. TrialAssessments
CREATE TABLE dbo.TrialAssessments (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_TrialAssessments PRIMARY KEY,
    lead_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    test_date DATETIME2(0) NOT NULL,
    score DECIMAL(5,2) NULL,
    max_score DECIMAL(5,2) NOT NULL CONSTRAINT DF_TrialAssessments_MaxScore DEFAULT 10.00,
    evaluator_id BIGINT NOT NULL,
    evaluation_notes NVARCHAR(MAX) NULL,
    recommended_grade_level INT NULL,
    recommended_course_id BIGINT NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_TrialAssessments_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_TrialAssessments_Lead FOREIGN KEY (lead_id) REFERENCES dbo.Leads(id) ON DELETE CASCADE,
    CONSTRAINT FK_TrialAssessments_Subject FOREIGN KEY (subject_id) REFERENCES dbo.Subjects(id) ON DELETE NO ACTION,
    CONSTRAINT FK_TrialAssessments_Evaluator FOREIGN KEY (evaluator_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION,
    CONSTRAINT FK_TrialAssessments_RecCourse FOREIGN KEY (recommended_course_id) REFERENCES dbo.Courses(id) ON DELETE SET NULL
);
GO

-- 23. Discounts
CREATE TABLE dbo.Discounts (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Discounts PRIMARY KEY,
    code VARCHAR(50) NOT NULL CONSTRAINT UQ_Discounts_Code UNIQUE,
    name NVARCHAR(100) NOT NULL,
    discount_type VARCHAR(20) NOT NULL CONSTRAINT CK_Discounts_Type CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT')),
    value DECIMAL(18,2) NOT NULL CONSTRAINT CK_Discounts_Value CHECK (value > 0),
    min_invoice_amount DECIMAL(18,2) NULL CONSTRAINT DF_Discounts_MinInv DEFAULT 0.00,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    usage_limit INT NULL,
    used_count INT NOT NULL CONSTRAINT DF_Discounts_UsedCount DEFAULT 0,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Discounts_Status DEFAULT 'ACTIVE'
        CONSTRAINT CK_Discounts_Status CHECK (status IN ('ACTIVE', 'INACTIVE', 'EXPIRED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Discounts_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT CK_Discounts_Dates CHECK (valid_to >= valid_from)
);
GO

-- 24. Invoices
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
    version BIGINT NOT NULL CONSTRAINT DF_Invoices_Version DEFAULT 0,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Invoices_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Invoices_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Invoices_Enrollment FOREIGN KEY (enrollment_id) REFERENCES dbo.Enrollments(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Invoices_Student FOREIGN KEY (student_id) REFERENCES dbo.Students(id) ON DELETE NO ACTION
);
GO

-- 25. InvoiceItems
CREATE TABLE dbo.InvoiceItems (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_InvoiceItems PRIMARY KEY,
    invoice_id BIGINT NOT NULL,
    description NVARCHAR(255) NOT NULL,
    unit_price DECIMAL(18,2) NOT NULL CONSTRAINT CK_InvoiceItems_UnitPrice CHECK (unit_price >= 0),
    quantity INT NOT NULL CONSTRAINT DF_InvoiceItems_Qty DEFAULT 1 CONSTRAINT CK_InvoiceItems_Qty CHECK (quantity > 0),
    amount DECIMAL(18,2) NOT NULL CONSTRAINT CK_InvoiceItems_Amount CHECK (amount >= 0),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_InvoiceItems_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_InvoiceItems_Invoice FOREIGN KEY (invoice_id) REFERENCES dbo.Invoices(id) ON DELETE CASCADE
);
GO

-- 26. Payments
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

-- 27. Questions
CREATE TABLE dbo.Questions (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Questions PRIMARY KEY,
    author_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    class_id BIGINT NULL,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    image_url VARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL CONSTRAINT DF_Questions_Status DEFAULT 'OPEN'
        CONSTRAINT CK_Questions_Status CHECK (status IN ('OPEN', 'RESOLVED', 'CLOSED')),
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Questions_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Questions_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Questions_Author FOREIGN KEY (author_id) REFERENCES dbo.Users(id) ON DELETE CASCADE,
    CONSTRAINT FK_Questions_Subject FOREIGN KEY (subject_id) REFERENCES dbo.Subjects(id) ON DELETE NO ACTION,
    CONSTRAINT FK_Questions_Class FOREIGN KEY (class_id) REFERENCES dbo.Classes(id) ON DELETE SET NULL
);
GO

-- 28. Answers
CREATE TABLE dbo.Answers (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Answers PRIMARY KEY,
    question_id BIGINT NOT NULL,
    author_id BIGINT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    image_url VARCHAR(500) NULL,
    is_accepted BIT NOT NULL CONSTRAINT DF_Answers_Accepted DEFAULT 0,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Answers_CreatedAt DEFAULT GETDATE(),
    updated_at DATETIME2(0) NOT NULL CONSTRAINT DF_Answers_UpdatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Answers_Question FOREIGN KEY (question_id) REFERENCES dbo.Questions(id) ON DELETE CASCADE,
    CONSTRAINT FK_Answers_Author FOREIGN KEY (author_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
);
GO

-- 29. Notifications
CREATE TABLE dbo.Notifications (
    id BIGINT IDENTITY(1,1) CONSTRAINT PK_Notifications PRIMARY KEY,
    recipient_id BIGINT NOT NULL,
    title NVARCHAR(200) NOT NULL,
    message NVARCHAR(MAX) NOT NULL,
    type VARCHAR(50) NOT NULL CONSTRAINT CK_Notifications_Type CHECK (type IN ('ATTENDANCE_ALERT', 'EXAM_SCORE', 'TUITION_DUE', 'SYSTEM_ANNOUNCEMENT')),
    reference_url VARCHAR(255) NULL,
    is_read BIT NOT NULL CONSTRAINT DF_Notifications_IsRead DEFAULT 0,
    read_at DATETIME2(0) NULL,
    created_at DATETIME2(0) NOT NULL CONSTRAINT DF_Notifications_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT FK_Notifications_Recipient FOREIGN KEY (recipient_id) REFERENCES dbo.Users(id) ON DELETE CASCADE
);
GO

-- 30. SystemSettings
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

-- 31. AuditLogs
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
    CONSTRAINT FK_AuditLogs_Actor FOREIGN KEY (actor_id) REFERENCES dbo.Users(id) ON DELETE SET NULL
);
GO

-- Tối ưu hóa hiệu năng Indexes
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

PRINT N'Hoàn thành Bước 01: Tạo thành công 30 bảng và hệ thống chỉ mục Indexes!';
GO
