# Technical Plan: Course Catalog & Registration Cart (feat-course-catalog)

> **Artifact baseline: historical v1.** N?i dung/checkbox d??i ??y thu?c phi?n b?n tr??c; spec v2 hi?n h?nh l? [spec.md](spec.md). Ph?i c?p nh?t plan/tasks v? c?c h?p ??ng t??ng ?ng tr??c khi code v2; kh?ng d?ng tr?ng th?i Completed ho?c chi ti?t m?u thu?n ? ??y l?m b?ng ch?ng ?? ??t v2. H?p ??ng chung t?i [integration.md](../../../integration.md) v? th? t? tri?n khai t?i [implementation-order.md](../../../implementation-order.md).

**Status:** Approved | **Feature:** `feat-course-catalog`  
**Spec Reference:** [spec.md](file:///d:/wd%20c%20sang%20d/Documents/NetBeansProjects/EduCenter/.sdd/specs/modules/admission/feat-course-catalog/spec.md)  
**Target Module:** `MOD-ADMISSION` (M01 – Public Website & Course Catalog)  
**Owner:** Member 02  

---

## 1. Architecture Overview

Module này tuân thủ nghiêm ngặt mô hình phân tầng chuẩn của EduCenter:
```text
Browser Client (Guest / Student / Parent)
      │
      ├──> [EncodingFilter] (Force UTF-8)
      ├──> [CsrfFilter] (Validate mutating POSTs)
      │
      ▼
Controller Servlets (PRG Pattern)
  ├── PublicCourseServlet (/courses, /courses/detail)
  └── RegistrationCartServlet (/registration-cart, /registration-cart/add, /registration-cart/remove, /registration/confirm)
      │
      ▼
Service Layer (Business Logic & Transactions)
  ├── CourseService (Search, Filter, Detail, Related Courses)
  └── CartService (Add, Remove, Calculate Total, Sync Session to DB, Lead Conversion)
      │
      ▼
Repository Layer (JPA EntityManager & JPQL - NO raw JDBC)
  ├── CourseRepository
  ├── SubjectRepository
  ├── RegistrationCartRepository
  └── LeadRepository
      │
      ▼
JPA Entities (Hibernate ORM) <──> SQL Server (EduCenterDB)
```

---

## 2. Component Design

### 2.1 JPA Entities
* **`RegistrationCartItem` (`dbo.RegistrationCartItems`):**
  * `@Entity @Table(name = "RegistrationCartItems")`
  * `@Id @GeneratedValue(strategy = GenerationType.IDENTITY) Long id;`
  * `@ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "user_id") User user;`
  * `@ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "course_id") Course course;`
  * `@Column(name = "quantity") Integer quantity;`
  * `@Column(name = "notes") String notes;`
  * `@Column(name = "created_at") LocalDateTime createdAt;`

### 2.2 DTOs (Data Transfer Objects)
* **`CourseFilterDTO`**:
  * `String keyword`, `Long subjectId`, `Integer gradeLevel`, `BigDecimal minFee`, `BigDecimal maxFee`, `String sort`, `int page`, `int pageSize`.
* **`CoursePageDTO`**:
  * `List<CourseCardDTO> items`, `int currentPage`, `int pageSize`, `long totalRecords`, `int totalPages`, `CourseFilterDTO filter`.
* **`CourseDetailDTO`**:
  * Thông tin khóa học, môn học, giáo viên phụ trách, danh sách lớp học đang mở tuyển sinh, danh sách 3-4 khóa học tương tự.
* **`CartItemDTO`**:
  * `Long courseId`, `String courseCode`, `String courseName`, `String subjectName`, `Integer gradeLevel`, `BigDecimal fee`, `String notes`.
* **`CartViewDTO`**:
  * `List<CartItemDTO> items`, `BigDecimal totalFee`, `int totalCourses`.

### 2.3 Repository Design (`com.educenter.repository`)
* **`CourseRepository`**:
  * `CoursePageDTO searchCourses(EntityManager em, CourseFilterDTO filter)`: Xây dựng JPQL động có bound parameters để tính tổng bản ghi và lấy danh sách theo trang.
  * `Optional<Course> findByIdWithDetails(EntityManager em, Long id)`: `SELECT c FROM Course c JOIN FETCH c.subject LEFT JOIN FETCH c.classes WHERE c.id = :id`
  * `List<Course> findRelatedCourses(EntityManager em, Long subjectId, Integer gradeLevel, Long excludeCourseId, int limit)`
* **`RegistrationCartRepository`**:
  * `List<RegistrationCartItem> findByUserId(EntityManager em, Long userId)`
  * `Optional<RegistrationCartItem> findByUserAndCourse(EntityManager em, Long userId, Long courseId)`
  * `void save(EntityManager em, RegistrationCartItem item)`
  * `void delete(EntityManager em, Long id)`
  * `void clearByUserId(EntityManager em, Long userId)`

### 2.4 Service Design (`com.educenter.service`)
* **`CourseService`**:
  * `CoursePageDTO getCourseCatalog(CourseFilterDTO filter)`
  * `CourseDetailDTO getCourseDetail(Long courseId)`
* **`CartService`**:
  * `CartViewDTO getCart(HttpSession session, Long userId)`
  * `void addToCart(HttpSession session, Long userId, Long courseId, String notes)`
  * `void removeFromCart(HttpSession session, Long userId, Long courseId)`
  * `String confirmRegistration(HttpSession session, Long userId, RegistrationCheckoutDTO checkoutDTO)` (Tạo Lead chuyển vào CRM, làm trống giỏ hàng)

---

## 3. Controller & View Mapping

| Endpoint | Method | Controller | Action / Flow | View / Target |
|---|---|---|---|---|
| `/courses` | `GET` | `PublicCourseServlet` | Parse query params, gọi `courseService.getCourseCatalog()` | `/WEB-INF/views/public/course-list.jsp` |
| `/courses/detail` | `GET` | `PublicCourseServlet` | Parse `id`, gọi `courseService.getCourseDetail()` | `/WEB-INF/views/public/course-detail.jsp` |
| `/registration-cart` | `GET` | `RegistrationCartServlet` | Lấy dữ liệu giỏ hàng, hiển thị danh sách khóa học & tổng phí | `/WEB-INF/views/public/registration-cart.jsp` |
| `/registration-cart/add` | `POST` | `RegistrationCartServlet` | Thêm khóa học vào giỏ, PRG redirect về `/registration-cart` | Redirect `/registration-cart` |
| `/registration-cart/remove` | `POST` | `RegistrationCartServlet` | Xóa khóa học khỏi giỏ, PRG redirect về `/registration-cart` | Redirect `/registration-cart` |
| `/registration/confirm` | `GET` | `RegistrationCartServlet` | Hiển thị form điền thông tin học viên/phụ huynh xác nhận | `/WEB-INF/views/public/registration-confirm.jsp` |
| `/registration/confirm` | `POST` | `RegistrationCartServlet` | Lưu Lead, clear giỏ, redirect `/consultation/success` | Redirect `/consultation/success` |
| `/consultation/success` | `GET` | `PublicCourseServlet` | Hiển thị mã tiếp nhận hồ sơ tuyển sinh thành công | `/WEB-INF/views/public/consultation-success.jsp` |

---

## 4. UI/UX Rules & Design System Compliance

* **Default Light Mode:** Sử dụng `tokens.css` và `head.jspf`. Mặc định sáng, lưu toggle vào `localStorage`.
* **Icons:** Sử dụng các icon Lucide SVG inline (`BookOpen`, `Clock`, `Users`, `GraduationCap`, `ShoppingCart`, `Trash2`, `ArrowRight`, `Search`, `SlidersHorizontal`).
* **Format Tiền:** Dùng `<fmt:formatNumber value="${item.fee}" pattern="#,##0" /> VNĐ`.
* **Zero Hardcoding:** Mọi thẻ khóa học và số liệu sĩ số / học phí hiển thị từ CSDL. Empty state được xử lý khi không có kết quả tìm kiếm hoặc giỏ hàng trống.

---

## 5. Verification & Testing Strategy

* **Unit Testing (JUnit 5):**
  * `CourseServiceTest`: Kiểm tra tìm kiếm theo từ khóa, lọc theo môn học, lọc theo khối lớp, sắp xếp theo học phí.
  * `CartServiceTest`: Kiểm tra thêm khóa học vào giỏ, không nhân bản khi thêm trùng, xóa khỏi giỏ, tính tổng học phí chính xác, kiểm tra giỏ rỗng.
* **Build Verification:**
  * Chạy `ant compile` đảm bảo `BUILD SUCCESSFUL`.
  * Chạy toàn bộ test suite đảm bảo 100% test pass.
