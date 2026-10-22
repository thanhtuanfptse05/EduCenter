# Auth persistence contract

User, Role, UserRoles and AuditLog map exact snake_case columns in docs/database/EduCenter_Schema_SQLServer.sql; full_name, avatar_url, role name/description and audit values use nationalized text. UserRoles.assigned_at uses its SQL default.

PasswordResetTokens adds id BIGINT IDENTITY, user_id FK Users, token_hash VARCHAR(64) UNIQUE, expires_at/created_at/consumed_at DATETIME2. Consuming resets and password updates occur in the same transaction with user/token locks.
