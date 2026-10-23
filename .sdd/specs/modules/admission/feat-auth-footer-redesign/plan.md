# Implementation Plan: Cải tiến Giao diện Xác thực & Footer Dùng chung (feat-auth-footer-redesign)

## 1. Architecture & Component Structure

### Architecture Diagram
```
                     Browser (Public / Auth User)
                                 │
                 ┌───────────────┴───────────────┐
                 │                               │
        GET/POST /login, /register,       Any Public Page
        /forgot-password, /reset-pass     (Landing, Catalog, Cart)
                 │                               │
                 ▼                               ▼
            AuthServlet                     Various Servlets
                 │                               │
                 ▼                               ▼
    ┌─────────────────────────┐     ┌─────────────────────────┐
    │     JSP Auth Views      │     │    Public JSP Views     │
    │  - login.jsp            │     │  - landing.jsp          │
    │  - register.jsp         │     │  - course-list.jsp      │
    │  - forgot-password.jsp  │     │  - registration-cart.jsp│
    │  - reset-password.jsp   │     └────────────┬────────────┘
    └────────────┬────────────┘                  │
                 │                               │
                 └───────────────┬───────────────┘
                                 │
                                 ▼
                     Included Shared Partials:
                   - /common/head.jspf (auth.css link)
                   - /common/public-header.jspf
                   - /common/public-footer.jspf (Redesigned Enterprise 4-Col Footer)
                                 │
                                 ▼
                      CSS & Client Interaction:
                   - /assets/css/auth.css (Tokens, 2-Col Split, Centered Card)
                   - /assets/css/public-shell.css (Modern multi-col footer)
                   - /assets/js/auth.js (Password toggle, strength, match, countdown)
```

## 2. Affected Files & Artifacts

1. **`web/assets/css/auth.css`**:
   - Refine and polish CSS classes to match the design aesthetics (clean typography, subtle borders, shadows, responsive breakpoints).
2. **`web/assets/css/public-shell.css`**:
   - Upgrade `.site-footer` and `.site-footer-grid` for modern 4-column enterprise layout, brand emblem, contact cards, badges, and bottom legal bar.
3. **`web/assets/js/auth.js`**:
   - Ensure event listeners for password reveal, strength bar calculation, role segmented buttons, match checks, and countdown timer integrate seamlessly with redesigned markup.
4. **`web/WEB-INF/views/common/head.jspf`**:
   - Include `<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/auth.css">` so auth styling is always available on all pages where needed.
5. **`web/WEB-INF/views/auth/login.jsp`**:
   - Implement the 2-column split design with clean CSRF form on the left (excluding fake RBAC demo buttons and Google SSO) and academic showcase on the right.
6. **`web/WEB-INF/views/auth/register.jsp`**:
   - Implement the 2-column registration layout with 2-option role selector (`STUDENT` / `PARENT`), real form fields, password strength & checklist, and right column trust showcase.
7. **`web/WEB-INF/views/auth/forgot-password.jsp`**:
   - Implement centered card with lock emblem, email input, bot shield element, PRJ301 evaluator note if `demo_reset_link` exists, and link back to login.
8. **`web/WEB-INF/views/auth/reset-password.jsp`**:
   - Implement centered card with 15-minute countdown timer, valid/expired state conditional rendering, new password strength meter, match indicator, and revoke session option.
9. **`web/WEB-INF/views/common/public-footer.jspf`**:
   - Redesign shared footer with 4 rich navigation columns, contact info, accreditation badges, and copyright/status bar.

## 3. Implementation Phases

- **Phase 1 (Stylesheets & Script Refinements):**
  - Verify and extend `auth.css` and `public-shell.css` with exact tokens and utility classes.
  - Link `auth.css` in `head.jspf`.
  - Check `auth.js` helper functions.
- **Phase 2 (Shared Footer Upgrade):**
  - Rewrite `public-footer.jspf` to feature multi-column navigation, brand accreditation, and responsive structure.
- **Phase 3 (Auth Views Redesign):**
  - Redesign `login.jsp`, `register.jsp`, `forgot-password.jsp`, `reset-password.jsp`.
  - Maintain 100% parameter compatibility with `AuthServlet.java` (`email`, `password`, `fullName`, `phone`, `roleCode`, `token`, `newPassword`, `confirmNewPassword`, `csrfToken`, `redirect_url`).
- **Phase 4 (Validation & Verification):**
  - Run Ant `verify` target to compile and execute all 50+ JUnit 5 test cases.
  - Review browser DOM and check responsive rendering.
  - Commit and push to `main`.
