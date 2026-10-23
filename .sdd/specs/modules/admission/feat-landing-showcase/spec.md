# Feature Specification: Landing Page Showcase & Complete Navbar Sections Overhaul (feat-landing-showcase)
**Feature Code:** `feat-landing-showcase` | **Module:** `MOD-ADMISSION` (Member 02)  
**Status:** Approved | **Date:** 2026-10-23  

---

## 1. Executive Summary & Problem Statement
The EduCenter landing page navbar includes links to:
- `Trang chủ` (`/`)
- `Khóa học` (`/courses`)
- `Thành tựu` (`/#thanh-tuu`)
- `Lộ trình` (`/#lo-trinh-hoc-tap`)
- `Chương trình` (`/#chuong-trinh`)
- `Môn học` (`/#mon-hoc`)
- `Giáo viên` (`/#doi-ngu`)
- `Tư vấn` (`/#dang-ky-tu-van`)

While the Achievements section (`#thanh-tuu`) was upgraded, the user explicitly requested:
1. Revamping the **Lộ trình học tập** (`#lo-trinh-hoc-tap`) to faithfully implement the Teky reference (`media_1792714652952.png`): a massive ascending 3D-styled graphic arrow/pathway sloping upward from bottom-left to top-right, an active runner figure ascending the slope, 4 progressive milestone columns on the slope, and at the apex an orange flagpole with fluttering flag 🚩 plus glowing green badge `CƠ HỘI ĐẠI HỌC • 100+ TRƯỜNG ĐẠI HỌC TỐP ĐẦU`.
2. Comprehensively upgrading all other navbar-linked landing sections:
   - **Chương trình** (`#chuong-trinh`): Premium grade cards with grade-specific color accents (Lớp 10, 11, 12), outcome tags, feature lists, and dynamic CTAs.
   - **Môn học** (`#mon-hoc`): Subject explorer grid with color-coded thematic badge boxes, course count badges, grade pills, and hover lift effects.
   - **Giáo viên** (`#doi-ngu`): Faculty profile cards with verified badges, qualifications, degree pills, and experience badges.
   - **Tư vấn** (`#dang-ky-tu-van`): High-converting split card with trust guarantees and optimized lead capture form.

---

## 2. Business Rules & Functional Requirements
- **FR-01: Ascending Roadmap Pathway**:
  - The pathway must visually ascend from lower-left to upper-right.
  - A runner icon (`🏃` outline SVG) positioned at the start of the incline.
  - 4 milestone stages (Lớp 6–9, Lớp 10, Lớp 11, Lớp 12) staggered in height to follow the incline.
  - Summit milestone at the top right featuring flagpole 🚩 and glowing green badge `CƠ HỘI ĐẠI HỌC • 100+ TRƯỜNG ĐẠI HỌC TỐP ĐẦU`.
- **FR-02: Grade Programs Section**:
  - 3 grade cards with distinct accent tokens (Teal for Grade 10, Indigo for Grade 11, Primary Blue/Amber for Grade 12 Featured).
  - Target metrics badges ("Mục tiêu 8.0+", "Xét tuyển ĐGNL", "Bứt phá tốt nghiệp").
- **FR-03: Subject Grid Section**:
  - Dynamic subjects rendered from DB (`portalData.subjects`).
  - Thematic colors per subject (Math: Blue, Phys: Amber, Chem: Emerald, Eng: Purple, Lit: Rose, Bio: Cyan).
  - Course count badge and deep link to `/courses?keyword=...`.
- **FR-04: Faculty Teachers Section**:
  - Dynamic faculty profiles rendered from DB (`portalData.facultyTeachers`).
  - Verified educator checkmark, academic degrees, and experience tags.
- **FR-05: Consultation Lead Section**:
  - Split layout with trust guarantees on the left and lead form on the right.
  - Secure CSRF token and full validation.
- **NFR-01: Strict Design System Compliance**:
  - Default Light Mode, seamless Dark Mode support via `html[data-theme="dark"]`.
  - Pure Vanilla CSS tokens and Lucide outline SVGs (no external Tailwind CDN, no emojis).
  - 100% dynamic DB data preserved.
