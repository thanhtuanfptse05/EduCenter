# HTTP contract

GET auth routes render protected JSPs. POST /login, /register, /forgot-password, /reset-password, /profile, /logout and /admin/users[/status|/roles] require CSRF and redirect after validation or success. Passwords never enter flash state. /profile action=password changes credentials; default action updates profile. Admin action=status or roles changes one target user.

Protected role prefixes require login and corresponding role, ADMIN can access all five. /profile requires any active principal. Missing login redirects to /login?redirect_url=encoded-local-path. Wrong role returns HTTP 403 and the shared error page. Invalid CSRF returns HTTP 403 without mutation. Unhandled errors render a safe 500 page.
