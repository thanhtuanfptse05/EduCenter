# Implementation decisions

- Use the approved Jakarta MVC/JPA/SQL Server stack. Existing repository has configuration only and no Java implementation to preserve.
- Use Hibernate 6.4 (Java 17 / JPA 3.1), Jakarta Tags 3 and Servlet 6. Existing Tags 2 libraries in allowedlib are incompatible with the requested tag URIs and are excluded from runtime packaging.
- Use persisted, hashed reset tokens and SMTP delivery, rather than a demo reset link or plaintext token in a log.
- Preserve database schema and supply an additive migration; never execute the repository's destructive full schema automatically.
- Ant remains the build tool. H2 MSSQLServer-mode tests validate mappings and transactions but do not substitute for SQL Server acceptance.
