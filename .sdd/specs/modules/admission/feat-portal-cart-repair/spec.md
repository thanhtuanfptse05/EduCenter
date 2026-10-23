# Feature Specification: Public portal and registration repairs

> **Historical repair scope ? 2026-10-23.** T?i li?u v? ba ngo?i l? b?n d??i ghi l?i ph?m vi ??t repair c?. [Baseline ??c t? hi?n h?nh](../../../README.md) v? [D04](../../../decisions.md) y?u c?u d? li?u th?t, kh?ng demo helpers/reset link cho s?n ph?m. Kh?ng s?a ng??c k?t qu? verification c? v? kh?ng coi ngo?i l? c? l? mi?n tr? cho feature v2.

**Status:** Approved / Locked — owner request, 2026-10-23
**Version:** 1.0.0 | **Branch:** main

## User Scenarios & Testing

### User Story 1 — Consistent first impression (Priority: P1)

Visitors see a prominent, compact introduction and the same navigation across home, courses, detail, cart, confirmation, authentication and error screens.

**Independent Test:** Navigate these pages at 360, 768, 1024 and 1440 pixels in light/dark themes.

**Acceptance Scenarios:**
1. Home starts below navigation with 32–48px desktop / 24–32px mobile padding; headline and primary action appear in the first viewport.
2. Public pages reuse the same brand, links, actions, cart badge, mobile menu and theme behavior.
3. Signed-in users can still view public home/sections; dashboards use explicit dashboard routes.
4. Internal menus expose authorized routes and a working mobile drawer.

### User Story 2 — Reliable registration cart (Priority: P1)

Guests/account holders add unique courses, edit notes, remove/clear selections, sign in without losing them and obtain truthful registration receipts.

**Independent Test:** Guest selection → login → merged cart → edit/remove → confirmation → reload receipt.

**Acceptance Scenarios:**
1. Duplicate courses produce no duplicate rows and return an accurate message.
2. Guest selections survive session renewal, merge without duplicating account selections and are cleared only after successful persistence.
3. Current course fees/status are reloaded; closed/archived/missing courses cannot be submitted.
4. Confirmation creates one lead and clears the cart atomically. Validation/transaction failure retains cart/form. Repeated submission creates no extra lead.
5. Receipt reference/contact/grade/time come from the actual persisted submission in the current session; arbitrary URL codes cannot fabricate success.
6. Total equals the sum of listed fees. No coupon, discount field, combo discount, invented original price or promotional percentage remains.

### User Story 3 — Actual data and working controls (Priority: P1)

Users receive actual academic/account information and working administrative, search, error and session controls.

**Independent Test:** Empty results, missing teacher/schedule, closed course, status/role mutations, expired reset token and password changes across sessions.

**Acceptance Scenarios:**
1. Outside the three exclusions below, no fabricated count/rating/schedule/room/sĩ số/qualification/certification/network/security fact is displayed.
2. Search/filter/sort/pagination retain parameters; operational filters cover grades 6–12 and available backend subjects/grades.
3. Admin action status differs from filter status; user text is escaped by context; last-active-admin changes are serialized.
4. Password changes invalidate other sessions; no 30-day session is promised; actual token validity/time and the six-character minimum are reflected in UI.
5. Error pages contain no Java business code or exception disclosure; incident references are generated/logged server-side; recovery/search links work.

### Edge Cases

Empty carts; invalid/nonpositive IDs; missing/closed courses; changed fees; locked accounts on public routes; invalid CSRF; duplicate clicks/submissions; rollback; overlapping guest/account selections; concurrent additions; quotes/HTML in user text; external redirects; missing operational tables; unavailable database.

## Requirements

- **FR-001:** One shared public header/footer; role-aware, accessible internal shell; all visible navigation works.
- **FR-002:** Compact, prominent hero using existing tokens/local styling; preserve excluded showcase content.
- **FR-003:** Preserve/merge guest cart across login, serialize account-cart mutations and refresh fees/status from persistent course records.
- **FR-004:** Duplicate protection, note updates, removal, clearing and accurate shared cart counts.
- **FR-005:** Atomic/idempotent registration, retained drafts/errors and session-bound persisted receipts.
- **FR-006:** Remove discount/coupon/combo features/calculations from the implemented public flow; retain financial records/schema.
- **FR-007:** Replace invented backend/UI facts outside exclusions with actual queries or explicit empty/unavailable states; distinguish failures from empty results.
- **FR-008:** Repair admin forms/contextual escaping, last-admin concurrency, safe redirects and credential-session invalidation.
- **FR-009:** Actual reset status/time and consistent password hints, preserving excluded reset-link delivery.
- **FR-010:** No error-page scriptlets/exception disclosure; working search, links, themes and mobile menus.
- **FR-011:** Align specs/design/progress records; track unbuilt ERP modules honestly as separate future features.
- **FR-012:** Verify Java 17 compilation, service/HTTP/JSP regressions, SQL Server queries and browser layouts; commit/push validated changes to main.

### Owner exclusions — 2026-10-23

Preserve exactly these three existing groups requested by the owner:
1. Direct password-reset link display (AuthServlet + reset-link alert).
2. Profile 2FA/device/history demonstration content and demonstration actions.
3. Home progress/student/parent demonstration cards and displayed learning statistics.

These explicit instructions override generic cleanup rules for this repair only; they are not claimed as production implementations. Navigation/theme may be repaired around them. SMTP delivery, actual 2FA/device management and live home learning-showcase data are outside the acceptance gate.

### Key Entities

Course/Subject/Class/Teacher: actual academic information. Cart selection: unique course per session/account plus notes/current fee/availability. Lead/receipt: persisted submission contact, courses, total/time with session-scoped access. Account/credential fingerprint: current roles/status and credential version for revocation.

## Success Criteria

- **SC-001:** Guest → login → confirmation preserves valid unique selections; duplicate submission produces exactly one lead.
- **SC-002:** Totals match current listed fees in every scenario; zero public discount/coupon calculations or controls remain.
- **SC-003:** Same public navigation at four target widths without viewport overflow or dead links.
- **SC-004:** Repaired service/HTTP/JSP regressions pass; browser evidence and environmental limits are reported separately.
- **SC-005:** Scoped tasks have verification evidence, exclusions are preserved and unbuilt modules are separately tracked.

## Assumptions

This repairs implemented screens, not every remaining ten-week ERP module. Enrollment, finance, academic operations and full dashboards remain separately scoped features. Operational grades 6–12 and the five-role MVP follow SRS/constitution; marketing may focus on THPT without excluding lower grades. No financial data is deleted.
