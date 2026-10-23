# Implementation Plan: Portal and cart repairs

Date: 2026-10-23 | Branch: main | Spec: [spec.md](spec.md)

## Summary
Repair current screens and cart integrity; preserve the three owner exclusions. Reuse one public layout, compact hero, repository-backed academic facts and one undiscounted fee total. Keep future ERP modules separate.

## Technical Context
Java 17, Jakarta Servlet 6/JSP 3.1/Tags 3, JPA 3.1/Hibernate 6.4, SQL Server, Ant/NetBeans. Existing libraries remain authoritative; embedded Tomcat/Jasper may be used as test tooling. JUnit 5 plus HTTP/JSP and browser verification. No new frontend framework.

## Constitution Check
Pass: Java/Jakarta/JPA stack, service-owned transactions, protected JSP/JSTL, five-role service/filter authorization, exact BigDecimal money, no deletion of financial records, local tokens/default light. Explicit owner exclusions override generic mock cleanup only in the three named groups. No schema-changing startup; read settings from environment/system properties with local configuration compatibility. Recheck after implementation.

## Project Structure
- src/java/com/educenter/{controller,filter,service,repository,dto,util,entity}
- web/WEB-INF/views/{common,public,auth,admin}
- web/assets/{css,js,images}
- test/com/educenter/{service,controller,util}
- scripts/verify.ps1 and optional local embedded-server test runner

## Design and implementation
1. Shared public header/footer and local public-shell.css/public-shell.js, loaded globally once from head. Preserve internal shell for profile/admin/dashboard; role-aware drawer. Landing servlet distinguishes public home from explicit dashboard paths.
2. Retain only course IDs/notes as cart intent; refresh course records for every view/confirmation. Account mutations lock user row; guest state is removed after DB commit. Explicit guest merge at successful login after copying cart across session renewal. Duplicate additions report no change. Notes update via separate POST.
3. CartService performs sums using BigDecimal; DTOs carry values only. Remove discount/original-fee fields and every promotion in public JSPs. Recheck course OPEN status at checkout. Persist lead, clear DB cart in one transaction; clear guest state only after commit. Session submission key and receipt prevent double creation; receipt access cannot be supplied by URL alone.
4. Query actual class enrollment counts, rooms and recurring-session descriptions through repository projections where tables exist. Map missing data to neutral unavailable text, never invented schedules/teachers/counts. Remove fake marketing KPIs/security/network facts outside exclusions.
5. Session credential fingerprint invalidates stale sessions across protected and authenticated public requests. Lock ADMIN role then actor/target consistently for admin mutations. Contextual escaping uses data attributes rather than interpolated JS. Separate actionStatus/filter status. Render role filters/edit choices from persisted canonical roles. Safe redirects remain local, context-correct and role-authorized. Token inspection provides validity/expiry without changing direct-link delivery.
6. Error filter/controller produces incident ID and logs exception; JSP shows safe recovery/search. Canonical footer settings resolve once server-side. Dynamic grades/subjects; URLs use c:url/c:param and preserve filters.
7. Consolidate identical image binaries; retain lightweight redirects for historical database URLs and owner-excluded markup before deleting duplicates. Remove unreferenced legacy catalog/cart CSS. Keep one design source; amend historical completion claims with a linked repair/future-work record.

## Validation
Meaningful regressions cover session renewal/merge, duplicates, stale fees/closed courses, removal/notes, rollback, idempotent receipt, admin form/context encoding, concurrent admin/account changes and session revocation. Render every JSP through Tomcat/Jasper, exercise guest/account HTTP flows and actual SQL Server selects. Browser inspect 360/768/1024/1440 in light/dark. Ant WAR must build and smoke test. Verify excluded snippets remain unchanged; do not mark future modules implemented.
