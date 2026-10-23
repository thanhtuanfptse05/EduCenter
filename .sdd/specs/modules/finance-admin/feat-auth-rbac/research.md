# Implementation decisions

> **Artifact baseline: historical v1.** N?i dung/checkbox d??i ??y thu?c phi?n b?n tr??c; spec v2 hi?n h?nh l? [spec.md](spec.md). Ph?i c?p nh?t plan/tasks v? c?c h?p ??ng t??ng ?ng tr??c khi code v2; kh?ng d?ng tr?ng th?i Completed ho?c chi ti?t m?u thu?n ? ??y l?m b?ng ch?ng ?? ??t v2. H?p ??ng chung t?i [integration.md](../../../integration.md) v? th? t? tri?n khai t?i [implementation-order.md](../../../implementation-order.md).

- Use the approved Jakarta MVC/JPA/SQL Server stack. Existing repository has configuration only and no Java implementation to preserve.
- Use Hibernate 6.4 (Java 17 / JPA 3.1), Jakarta Tags 3 and Servlet 6. Existing Tags 2 libraries in allowedlib are incompatible with the requested tag URIs and are excluded from runtime packaging.
- Use persisted, hashed reset tokens and SMTP delivery, rather than a demo reset link or plaintext token in a log.
- Preserve database schema and supply an additive migration; never execute the repository's destructive full schema automatically.
- Ant remains the build tool. H2 MSSQLServer-mode tests validate mappings and transactions but do not substitute for SQL Server acceptance.
