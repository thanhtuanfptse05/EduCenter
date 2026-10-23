# Research and decisions

- Navbar differences are caused by independent home and catalog fragments. Reuse one public fragment/CSS; no new UI stack.
- Hero has fixed-header offset plus 100px top padding. Reserve header once and use 32–48px section spacing, stronger hierarchy and existing imagery/showcase.
- Login invalidates guest session before merge. Preserve only cart intent across renewal; synchronize explicitly on login, not on GET. Guest rollback must preserve selections.
- Public fees must be current DB values; remove both invented anchor pricing and combo discount. Service computes totals, DTO formats data.
- Receipt fallback fabricates success. Issue a session-bound receipt after commit and gate repeated checkout by a submission key.
- Existing operational SQL tables supply class/session/room/enrollment facts; absent rows are unknown, never synthetic.
- Owner exclusions are deliberate scope constraints. They are preserved, documented and checked, rather than silently changed.
- No technology unknowns remain; existing code/schema are primary evidence. No external recommendations are needed.
