# Verification guide

1. Java 17 and local SQL Server configured for EduCenterDB. Tomcat 10.1/Jakarta Tags 3 available. Disable automatic DDL.
2. Run scripts/verify.ps1 to compile/test/package using Ant (document exact local tools in verification.md).
3. Guest: add two courses, duplicate one, edit notes, remove/clear; badge and total match. Confirm validates unavailable/changed course records and has no discount.
4. Add as guest, sign in, verify unique merged account cart. Logout/login and verify persistence without another user's selections.
5. Submit confirmation twice; one persisted lead and same session receipt. Invalid form preserves all choices. Direct success URL without a receipt redirects.
6. Exercise admin status/roles, names with quotes, last-admin protection and password-change revocation across two sessions. Reset timing follows actual expiry.
7. Inspect home/catalog/cart/auth/errors at 360/768/1024/1440 and both themes; navbar remains identical, hero is compact, all menus/links work.
8. Preserve the three excluded content groups; record remaining future modules separately. Review git diff, run convergence and push validated changes to main.
