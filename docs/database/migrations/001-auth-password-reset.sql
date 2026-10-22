-- Migration: 001-auth-password-reset.sql
-- Table: dbo.PasswordResetTokens for FR-004 password recovery workflow
-- Safe / Idempotent execution

USE EduCenterDB;
GO

IF OBJECT_ID(N'dbo.PasswordResetTokens', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.PasswordResetTokens (
        id BIGINT IDENTITY(1,1) CONSTRAINT PK_PasswordResetTokens PRIMARY KEY,
        user_id BIGINT NOT NULL,
        token_hash VARCHAR(64) NOT NULL CONSTRAINT UQ_PasswordResetTokens_Hash UNIQUE,
        expires_at DATETIME2(0) NOT NULL,
        created_at DATETIME2(0) NOT NULL CONSTRAINT DF_PasswordResetTokens_CreatedAt DEFAULT GETDATE(),
        consumed_at DATETIME2(0) NULL,
        CONSTRAINT FK_PasswordResetTokens_User FOREIGN KEY (user_id) REFERENCES dbo.Users(id) ON DELETE NO ACTION
    );

    CREATE NONCLUSTERED INDEX IX_PasswordResetTokens_User ON dbo.PasswordResetTokens(user_id, expires_at);
END
GO
