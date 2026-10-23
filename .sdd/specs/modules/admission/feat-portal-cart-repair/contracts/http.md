# HTTP and view contracts

- GET /, /index: public home for guests and signed-in users, common public header/footer and actual cart count.
- GET /courses and /courses/detail?id=: bound filters/current academic data; closed/archived detail disables additions.
- GET /registration-cart: current item status/fees, editable notes, sum only; empty state.
- POST /registration-cart/{add,update,remove,clear}: CSRF, validated IDs/notes, active actor when signed in, PRG; duplicates do not multiply rows.
- GET /registration/confirm: populated draft and submission nonce; redirects empty cart.
- POST /registration/confirm: CSRF + nonce, current availability/fee validation, atomic lead/cart transaction; retains form on failure, same receipt on replay.
- GET /consultation/success: receipt from session matching submitted code if present; otherwise redirect, never fallback code.
- GET/POST authentication/profile: same public navigation for auth; internal role shell for profile. Existing direct reset-link and profile mock sections preserved.
- POST admin status uses actionStatus; status remains filter-only. Role modal reads escaped data attributes.
- Error responses retain HTTP status, safe user text and logged incident reference. Search goes to /courses?keyword=.
- All mutating routes require CSRF. Public requests with an authenticated account refresh status/credential validity before account cart access.
