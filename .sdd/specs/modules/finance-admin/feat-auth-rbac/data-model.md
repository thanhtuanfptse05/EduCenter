# Auth persistence contract

> **Artifact baseline: historical v1.** N?i dung/checkbox d??i ??y thu?c phi?n b?n tr??c; spec v2 hi?n h?nh l? [spec.md](spec.md). Ph?i c?p nh?t plan/tasks v? c?c h?p ??ng t??ng ?ng tr??c khi code v2; kh?ng d?ng tr?ng th?i Completed ho?c chi ti?t m?u thu?n ? ??y l?m b?ng ch?ng ?? ??t v2. H?p ??ng chung t?i [integration.md](../../../integration.md) v? th? t? tri?n khai t?i [implementation-order.md](../../../implementation-order.md).

User, Role, UserRoles and AuditLog map exact snake_case columns in docs/database/EduCenter_Schema_SQLServer.sql; full_name, avatar_url, role name/description and audit values use nationalized text. UserRoles.assigned_at uses its SQL default.

PasswordResetTokens adds id BIGINT IDENTITY, user_id FK Users, token_hash VARCHAR(64) UNIQUE, expires_at/created_at/consumed_at DATETIME2. Consuming resets and password updates occur in the same transaction with user/token locks.
