# HTTP contract

> **Artifact baseline: historical v1.** N?i dung/checkbox d??i ??y thu?c phi?n b?n tr??c; spec v2 hi?n h?nh l? [spec.md](../spec.md). Ph?i c?p nh?t plan/tasks v? c?c h?p ??ng t??ng ?ng tr??c khi code v2; kh?ng d?ng tr?ng th?i Completed ho?c chi ti?t m?u thu?n ? ??y l?m b?ng ch?ng ?? ??t v2. H?p ??ng chung t?i [integration.md](../../../../integration.md) v? th? t? tri?n khai t?i [implementation-order.md](../../../../implementation-order.md).

GET auth routes render protected JSPs. POST /login, /register, /forgot-password, /reset-password, /profile, /logout and /admin/users[/status|/roles] require CSRF and redirect after validation or success. Passwords never enter flash state. /profile action=password changes credentials; default action updates profile. Admin action=status or roles changes one target user.

Protected role prefixes require login and corresponding role, ADMIN can access all five. /profile requires any active principal. Missing login redirects to /login?redirect_url=encoded-local-path. Wrong role returns HTTP 403 and the shared error page. Invalid CSRF returns HTTP 403 without mutation. Unhandled errors render a safe 500 page.
