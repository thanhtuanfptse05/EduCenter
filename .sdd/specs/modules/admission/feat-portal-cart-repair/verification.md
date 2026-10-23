# Verification — portal/cart repair

Date: 2026-10-23. Scope: [locked spec](spec.md); [tasks](tasks.md).

## Automated evidence

| Check | Result | Evidence |
|---|---|---|
| Java 17 compilation + JUnit services/utilities | 50/50 passed | `scripts/verify.ps1`, generated `build/repair/unit.log` |
| SQL Server connection + HTTP/JSP/transactions | 11/11 passed | `scripts/verify.ps1 -Integration`, generated `build/repair/integration.log` |
| Browser public routes | 9 routes × 4 widths passed | `scripts/browser-check.py`, generated `build/repair/screenshots/browser-results.json` |
| Browser account workspace | Student dashboard/profile and admin dashboard/profile/user list at all 4 widths passed | isolated fixture browser run, same JSON |
| Themes/mobile/navigation | default light even with system dark, explicit dark persisted, public menu/internal drawer/Escape, hover contrast and home anchor targets passed | Chrome/Playwright |
| WAR package | `dist/EduCenter.war` built | Ant `verify`; runtime JARs included, test/JUnit tooling excluded |
| View/static checks | 23 JSP/fragments contain no Java scriptlets; discount/coupon/combo/originalFee scan clear in Java/public views | source scan |
| Owner exclusions | Profile main markup and both home showcase blocks match captured baseline exactly; direct reset link still returned/displayed by integration test | baseline comparison + HTTP reset test |

Read-only operational projections were additionally executed against all 5 existing classes in the configured application database. HTTP integration exercises all auth/catalog/cart JSPs, all five role dashboards, profile/logout/admin, 403/404/500, guest duplicate/notes/current fee, guest-to-account merge, consent/nonce confirmation replay with exactly one persisted Lead, session-bound receipt, stale password sessions, admin status/filter separation, escaped names and concurrent last-admin changes. The SQL fixture uses Unicode columns to match the real schema. A separate regression changes a previously loaded course in another transaction and verifies the checkout lock refreshes its fee. Error injection exists only in test support, never in the WAR.

SQL write tests create and dispose only `EduCenterRepairTest_<random>` databases. Configured EduCenterDB receives read-only connection/academic smoke checks; browser account mutations use a disposable fixture database. No financial records/schema are deleted. Existing historical image URLs redirect to one canonical binary.

## Browser evidence and environment

Widths: 360×900, 768×1024, 1024×900, 1440×1000. No document horizontal overflow or JavaScript page errors in checked public/internal views. Hero starts immediately after the 68px public header with 32px mobile/40px desktop padding. Screenshots are generated locally: `build/repair/screenshots/home-{width}.png` and `courses-dark-{width}.png`. Desktop/mobile screenshots were visually inspected; screenshots and local tool copies remain ignored build artifacts.

Local tools: OpenJDK 17; NetBeans 17 Ant; Tomcat 10.1/Jasper libraries; local Microsoft SQL Server; installed Google Chrome; Python Playwright. Windows computer-use UI was unavailable, so local headless Chrome was used for repeatable viewport/interaction verification. Tomcat test runner logs standard optional JVM module-open warnings; all assertions pass.

Reproduce account browser checks with a disposable database:

```powershell
.\scripts\verify.ps1 -Serve -Fixture -Port 18081
# In another terminal:
$env:EDUCENTER_TEST_URL = 'http://127.0.0.1:18081/EduCenter'
$env:EDUCENTER_TEST_ACCOUNTS = '1'
python scripts/browser-check.py
# Stop the fixture deterministically (Windows/Ant can terminate JVM hooks on Ctrl+C):
New-Item build/repair/stop-fixture-18081 -ItemType File -Force
```

## Scope and delivery

One canonical design document, shared public shell, current database projections, no public discounts, transaction-safe cart/receipt and repaired account/admin/error flows implement FR-001–FR-010. README, historical checklist notices and [.sdd/future-work.md](../../../../../.sdd/future-work.md) distinguish current implementation from future ERP modules (FR-011). FR-012 is covered by build/test evidence and the main-branch delivery below.

The three owner exclusions remain intentionally non-production: direct reset delivery, profile security/device demonstrations and home learning/parent demonstrations. No claim is made that all future academic/finance/guardian/reporting workflows are implemented.

Convergence: 32 functional/success/story criteria and 7 plan decisions assessed against current code, with 10 constitution constraint groups applied to the implemented scope. One MEDIUM partial finding on SC-002/FR-005 was appended as T026, implemented and verified: an unavailable course now shows its status instead of an amount excluded from the confirmation total. Its failed checkout retains the cart/draft and creates no extra Lead. Follow-up assessment found zero remaining missing/partial/contradicting/unrequested work; no empty convergence phase was appended.

Implementation revision `4bb5c0b` was committed and pushed to `origin/main`. The follow-up `feat(portal-cart): close convergence and record verification` commit contains T026, the read-only SQL regression and this completed verification record. Use this file's commit history for the final delivery revision. All 26 tasks are complete.
