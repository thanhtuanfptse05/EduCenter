# Technical Plan: Landing Page Showcase & Interactive Achievements Pathway (feat-landing-showcase)
**Status:** Approved | **Feature:** `feat-landing-showcase`  
**Spec Reference:** [spec.md](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/.sdd/specs/modules/admission/feat-landing-showcase/spec.md)  
**Target Module:** `MOD-ADMISSION` (M01 – Public Website & Landing Showcase)  
**Owner:** Member 02  

---

## 1. Architecture Overview

Tính năng này tuân thủ chuẩn kiến trúc MVC phân tầng của EduCenter, mở rộng dữ liệu hiển thị qua `LandingService` và tối ưu tầng hiển thị JSP/CSS/JS mà không phá vỡ bất kỳ Business Rules nào:

```text
Browser Client (Phụ huynh / Học sinh / Khách)
      │
      ├──> [EncodingFilter] (Force UTF-8)
      │
      ▼
LandingServlet (GET /)
      │
      ├──> LandingService.getLandingPortalData()
      │       │
      │       ├──> Truy vấn CSDL thật (Students, Classes, Teachers, Featured Courses, Subjects)
      │       └──> Cung cấp DTO danh mục Giải thưởng (Awards) & Lộ trình học thuật (Roadmap Stages)
      │
      ▼
LandingDataDTO (Được đính kèm vào request.setAttribute("portalData", ...))
      │
      ▼
JSP View: web/WEB-INF/views/common/landing.jsp
      │
      ├──> [Section 02]: Hero Section hiện tại
      ├──> [Section 02B]: Khối Thành tựu & Giải thưởng Danh giá (Awards Showcase Carousel với drag/swipe)
      ├──> [Section 02C]: Khối Thống kê Thành tựu & Con số Ấn tượng (High-Contrast Academic Metrics Banner)
      ├──> [Section 03A]: Khối Hành trình Bứt phá Năng lực & Chinh phục Đại học (Ascending Roadmap Pathway)
      └──> Các section tiếp theo (Chương trình, Môn học, Khóa học nổi bật, Giáo viên, Form tư vấn...)
      │
      ├──> CSS: web/assets/css/portal.css (Design tokens, Light mode mặc định, Dark mode đồng bộ)
      └──> JS: web/assets/js/portal-carousel.js (Vanilla Drag & Touch Swipe Slider Controller)
```

---

## 2. Component & DTO Design

### 2.1 DTOs (`com.educenter.dto`)
1. **`AchievementAwardDTO`**:
   - `String id`: Mã định danh giải thưởng (e.g., `AW-01`, `AW-02`).
   - `String title`: Tên giải thưởng / danh hiệu (e.g., *"Top 10 Đơn vị Bồi dưỡng & Luyện thi Xuất sắc"*).
   - `String organization`: Tổ chức trao giải / công nhận (e.g., *"Hiệp hội Giáo dục & Phát triển Tri thức Việt Nam"*).
   - `String year`: Năm vinh danh (e.g., *"2025"*, *"2024"*).
   - `String description`: Nội dung vinh danh và ý nghĩa học thuật.
   - `String badgeType`: Loại huy hiệu (`national`, `accreditation`, `innovation`, `partnership`).
   - `String iconType`: Định danh icon SVG Lucide (Cúp `trophy`, Huân chương `award`, Ngôi sao `star`, Huy hiệu `shield-check`).

2. **`LearningStageDTO`**:
   - `int stageNumber`: Thứ tự chặng (1, 2, 3, 4).
   - `String gradeRange`: Độ tuổi hoặc khối lớp (e.g., *"Lớp 6–9 & Lớp 10"*, *"Lớp 11"*, *"Lớp 12 & Ôn thi ĐGNL"*, *"Cột mốc Đích đến"*).
   - `String title`: Tiêu đề chặng (e.g., *"Xây dựng nền tảng học thuật vững chắc"*, *"Bứt phá năng lực & Nâng cao điểm số"*).
   - `String description`: Mục tiêu đào tạo và kết quả cần đạt.
   - `String focusSubjects`: Môn học và kỹ năng trọng điểm của chặng.
   - `String badgeText`: Nhãn giai đoạn (e.g., *"Nền tảng"*, *"Tăng tốc"*, *"Về đích"*, *"Thành công"*).
   - `boolean apexGoal`: Đánh dấu là đích đến đỉnh cao (Cờ đích / Cơ hội Đại học Tốp đầu).

3. **Mở rộng `LandingDataDTO`**:
   - Thêm `List<AchievementAwardDTO> achievementAwards = new ArrayList<>()`.
   - Thêm `List<LearningStageDTO> learningStages = new ArrayList<>()`.
   - Thêm getters / setters chuẩn Java Bean.

### 2.2 Service Layer (`LandingServiceImpl`)
- Trong `getLandingPortalData()`:
  - Khởi tạo và nạp dữ liệu chuẩn mực cho `achievementAwards` và `learningStages`.
  - Kết nối dữ liệu đếm thực tế từ CSDL (`totalStudents`, `openClassesCount`, `totalTeachersCount`) cho dải thẻ số liệu thống kê.

---

## 3. UI/UX & Interaction Design

### 3.1 Khối Thành tựu & Giải thưởng Danh giá (Awards Carousel)
- Bố cục:
  - Header: Thẻ Tagline *"Khẳng Định Uy Tín Giáo Dục"*, Tiêu đề `h2` lớn *"Thành tựu & Giải thưởng Danh giá"*, đoạn giới thiệu ngắn.
  - Phía bên phải tiêu đề: Cặp nút điều hướng Trái / Phải (`.carousel-btn-prev`, `.carousel-btn-next`) có icon Lucide SVG (`chevron-left`, `chevron-right`).
  - Container trượt: `.awards-carousel-viewport` chứa `.awards-carousel-track`.
  - Mỗi thẻ giải thưởng `.award-card`:
    - Biểu tượng Cúp/Huy chương mạ vàng tinh tế dạng Outline SVG Lucide nằm trong vòng tròn nổi bật.
    - Tiêu đề giải thưởng in đậm rõ ràng.
    - Tổ chức vinh danh & năm trao giải.
    - Đoạn tóm tắt thành tích đóng góp cho sự nghiệp giáo dục.
  - Phía dưới track: Thanh chỉ mục chấm tròn `.carousel-dots` tương tác trực tiếp.

### 3.2 Khối Dải Con số Ấn tượng (High-Contrast Academic Metrics Banner)
- Bố cục 5 cột thẻ (hoặc responsive wrap):
  - Nền thẻ tối tương phản cao hoặc gradient tinh tế theo Design Token, bo góc `var(--radius-lg)`.
  - Mỗi thẻ gồm:
    * Icon SVG outline đồng nhất (Trường học, Bản đồ chi nhánh, Sách mở, Mũ cử nhân, Cúp vàng).
    * Giá trị số lớn đậm chất ERP: `10+`, `30+`, `50.000+`, `98.6%`, `1.200+` (kết hợp số liệu thực tế từ DB).
    * Nhãn mô tả chính và dòng diễn giải súc tích.

### 3.3 Khối Hành trình Bứt phá Năng lực & Chinh phục Đại học (Ascending Roadmap)
- Thiết kế sơ đồ mũi tên tiến lên (Ascending trajectory arrow graphic):
  - Đường nét mũi tên lớn vát dốc từ trái sang phải, tạo cảm giác động lực tăng trưởng mạnh mẽ và mục tiêu vươn cao.
  - 4 Chặng (Roadmap Stages) nằm dọc theo chiều dốc của mũi tên:
    - Chặng 1 (Lớp 6–9 & Lớp 10): Nền tảng học thuật & Thích nghi.
    - Chặng 2 (Lớp 11): Tăng tốc & Nâng cao điểm số học bạ.
    - Chặng 3 (Lớp 12 & ĐGNL): Luyện đề thực chiến & Tối ưu kỹ năng phòng thi.
    - Chặng 4 (Đích đến): Cờ vinh quang — Cánh cửa Đại học Tốp đầu & Cơ hội học bổng.
  - Responsive: Trên màn hình di động (<768px), sơ đồ tự động dàn đều theo dạng thẻ dọc liên kết (vertical step progression) hoặc scrollable horizontal track với hiệu ứng vuốt mượt mà.

### 3.4 Bộ điều khiển Kéo / Trượt (Vanilla Drag & Touch Swipe Engine)
- Triển khai trong `web/assets/js/portal-carousel.js` (và nạp vào `landing.jsp`):
  - Sử dụng con trỏ chuột:
    * `cursor: grab;` khi hover, `cursor: grabbing;` khi kéo.
    * Lắng nghe `mousedown`: lưu vị trí `startX = e.pageX - slider.offsetLeft`, `scrollLeft = slider.scrollLeft`.
    * Lắng nghe `mousemove`: tính `walk = (x - startX) * 1.5; slider.scrollLeft = scrollLeft - walk;`.
    * Lắng nghe `mouseup`, `mouseleave`: kết thúc thao tác kéo, snap vào thẻ gần nhất.
    * Xử lý click: Ngăn chặn click nhầm vào thẻ khi người dùng đang thực hiện động tác kéo (`Math.abs(walk) > 5`).
  - Sử dụng cảm ứng màn hình di động:
    * Lắng nghe `touchstart`, `touchmove`, `touchend`.
  - Đồng bộ nút bấm Prev/Next và Pagination Dots:
    * Lắng nghe sự kiện `scroll` (với `requestAnimationFrame` debounce) để cập nhật chấm tròn active và ẩn/hiện độ mờ nút mũi tên.

---

## 4. File Modification Plan

| File | Hành động | Mục đích |
|---|---|---|
| `src/java/com/educenter/dto/AchievementAwardDTO.java` | Tạo mới | DTO chứa dữ liệu giải thưởng, danh hiệu |
| `src/java/com/educenter/dto/LearningStageDTO.java` | Tạo mới | DTO chứa các chặng lộ trình học tập |
| `src/java/com/educenter/dto/LandingDataDTO.java` | Cập nhật | Bổ sung danh sách `achievementAwards` và `learningStages` |
| `src/java/com/educenter/service/LandingServiceImpl.java` | Cập nhật | Cung cấp dữ liệu thành tựu và lộ trình chuẩn hóa trong `getLandingPortalData()` |
| `web/assets/js/portal-carousel.js` | Tạo mới | Script xử lý hiệu ứng kéo thả chuột và vuốt cảm ứng mượt mà |
| `web/assets/css/portal.css` | Cập nhật | Thêm CSS styles cho Carousel, Metrics Banner, Ascending Roadmap |
| `web/WEB-INF/views/common/landing.jsp` | Cập nhật | Nhúng Section 02B (Awards), Section 02C (Metrics), Section 03A (Roadmap) và nạp script |

---

## 5. Verification & Testing Guide
1. **Kiểm thử giao diện (UI Review):**
   - Kiểm tra Light mode (mặc định) và Dark mode (khi bấm chuyển đổi trong topbar).
   - Kiểm tra hiển thị responsive tại các kích thước 360px (Mobile), 768px (Tablet), 1024px (Laptop), 1440px (Desktop).
2. **Kiểm thử tương tác kéo/trượt (Interaction Validation):**
   - Dùng chuột nhấn kéo qua lại xem thẻ có trượt theo mượt mà không.
   - Thử nghiệm trên cảm ứng điện thoại (vuốt ngang).
   - Bấm nút Next/Prev xem có trượt đúng một khoảng thẻ và cập nhật chấm tròn không.
3. **Kiểm tra biên dịch & tính toàn vẹn (Build Verification):**
   - Chạy lệnh Ant clean & compile để đảm bảo 0 lỗi biên dịch Java.
