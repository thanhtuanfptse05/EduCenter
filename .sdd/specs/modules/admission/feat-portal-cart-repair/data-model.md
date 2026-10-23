# Data model

No destructive migration. Existing Course/Subject/EduClass/Teacher/User/Role/Lead/RegistrationCartItem remain.

CartItemDTO adds availability; current fee from Course. CartViewDTO holds items, totalCourses, totalFee and formatted total only. CourseDetailDTO has no originalFee/discount. RegistrationReceiptDTO holds actual Lead ID/code/name/phone/grade/createdAt and derives display strings; never accepted from arbitrary URL values.

Session state: guest course IDs/notes; currentUser; credential fingerprint; checkout nonce and confirmed receipt. Cart edits invalidate the checkout nonce after success. Confirmation consumes it only after successful commit; repeated POST resolves to existing receipt. Login renews session and preserves cart intent before merging. No password/hash is exposed to JSP.

Repository projections: actual enrollment counts, linked room name and session start/end values. Unknown academic details remain absent. ADMIN role/user row locks serialize administration and account cart writes.
