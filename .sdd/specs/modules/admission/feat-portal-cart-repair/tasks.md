# Tasks: Portal and cart repairs

Input: spec.md, plan.md, research.md, data-model.md, contracts/http.md, quickstart.md.

## Phase 1: Setup
- [x] T001 Lock repair scope/exclusions and canonical design in spec.md and ../../../../../design.md.
- [x] T002 Supply reproducible isolated verification/build tooling in scripts/verify.ps1 and build.xml.

## Phase 2: Foundations
- [x] T003 Add real academic projections and shared reference data in src/java/com/educenter/repository/CourseRepository.java and LandingRepository.java.
- [x] T004 Add public cart/reference-data handling and safe server-side errors in src/java/com/educenter/filter/ and util/.

## Phase 3: US1 — Shared navigation and first impression
Goal: consistent shell, compact hero. Independent test: every public route, four widths, both themes.
- [x] T005 [US1] Unify public navigation/footer in web/WEB-INF/views/common/public-header.jspf and public-footer.jspf with web/assets/css/public-shell.css and web/assets/js/public-shell.js.
- [x] T006 [US1] Repair home route/hero spacing and public composition in src/java/com/educenter/controller/LandingServlet.java and web/WEB-INF/views/common/landing.jsp and web/assets/css/portal.css.
- [x] T007 [US1] Adopt shared shell on auth/errors and authorized mobile internal navigation in web/WEB-INF/views/common/header.jspf and sidebar.jspf and auth/.

## Phase 4: US2 — Reliable cart without discounts
Goal: guest/account persistence, truthful totals/receipts. Independent test: guest → login → account cart → confirmation replay.
- [x] T008 [US2] Add meaningful cart regressions in test/com/educenter/service/CartServiceTest.java before changing behavior.
- [x] T009 [US2] Remove all discounts and move sums into service in src/java/com/educenter/dto/CartViewDTO.java and service/CartServiceImpl.java and dto/CourseDetailDTO.java.
- [x] T010 [US2] Repair merge, current records, account locks, duplicates and editable notes in src/java/com/educenter/service/CartServiceImpl.java and repository/RegistrationCartRepository.java.
- [x] T011 [US2] Preserve guest intent through session renewal in src/java/com/educenter/controller/AuthServlet.java.
- [x] T012 [US2] Make confirmation atomic/idempotent and issue actual session receipts in src/java/com/educenter/controller/RegistrationCartServlet.java and PublicCourseServlet.java and dto/RegistrationReceiptDTO.java.
- [x] T013 [US2] Repair all cart/catalog/confirmation JSP controls, totals, availability, drafts and URLs in web/WEB-INF/views/public/.

## Phase 5: US3 — Actual data and functional controls
Goal: no invented facts outside exclusions, safe account/admin/error controls. Independent test: actual/empty data and protected mutations.
- [x] T014 [US3] Replace fabricated service academic values in src/java/com/educenter/service/LandingServiceImpl.java and CourseServiceImpl.java.
- [x] T015 [US3] Remove non-excluded fake UI facts and align backend grades/subjects in web/WEB-INF/views/auth/ and public/ and common/.
- [x] T016 [US3] Repair admin status/context escaping/concurrency in web/WEB-INF/views/admin/user-list.jsp and src/java/com/educenter/service/UserServiceImpl.java and repository/RoleRepository.java.
- [x] T017 [US3] Revoke stale credential sessions and validate safe redirects in src/java/com/educenter/filter/AuthenticationFilter.java and util/RouteUtil.java and controller/AuthServlet.java.
- [x] T018 [US3] Expose actual reset validity/time and consistent hints in src/java/com/educenter/service/AuthServiceImpl.java and controller/AuthServlet.java and web/WEB-INF/views/auth/reset-password.jsp.
- [x] T019 [US3] Remove error scriptlets/leaks and repair search/links in web/WEB-INF/views/common/500.jsp and 404.jsp and src/java/com/educenter/filter/.
- [x] T020 [US3] Add regression coverage for repaired admin/session/reset/HTTP/JSP flows in test/com/educenter/.

## Phase 6: Verification and delivery
- [x] T021 Verify compilation, unit/HTTP/JSP/SQL Server checks using scripts/verify.ps1; record evidence in verification.md.
- [x] T022 Verify browser hero/navbar/cart/responsive/themes and preserve excluded snippets; record evidence in verification.md.
- [x] T023 Consolidate duplicate assets/references and align old progress/future modules in README.md and .sdd/shared_context.md.
- [x] T024 Run speckit-converge against spec.md/plan.md/tasks.md and implement remaining scoped tasks.
- [x] T025 Commit and push validated changes to main; record revision in verification.md.

## Dependencies and implementation strategy
Setup → foundations → US1 → US2 → US3 → validation/convergence/delivery. Test cart regressions before cart edits. US1 CSS and US2 service tests can be prepared independently; use sequential implementation here to avoid shared-file conflicts. Deliver all three stories, not only the navigation MVP.

## Phase 7: Convergence

- [x] T026 Clarify unavailable-course summary/fee exclusion on registration-confirm.jsp and cover closed-course HTTP rejection with retained cart/draft per SC-002, FR-005 and US2/AC3 (partial, MEDIUM).
