package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.*;
import com.educenter.util.JPAUtil;
import com.educenter.util.ValidationUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.function.Supplier;

public class CartServiceImpl implements CartService {
    public static final String SESSION_CART_KEY = "REGISTRATION_CART";
    public static final String CHECKOUT_TOKEN = "CHECKOUT_TOKEN";
    public static final String RECEIPT_KEY = "LAST_REGISTRATION_RECEIPT";
    private final CourseRepository courseRepository;
    private final RegistrationCartRepository cartRepository;
    private final UserRepository userRepository;
    private final LeadRepository leadRepository;
    private final Supplier<EntityManager> emSupplier;

    public CartServiceImpl() {
        this(new CourseRepository(), new RegistrationCartRepository(), new UserRepository(), new LeadRepository(), JPAUtil::getEntityManager);
    }
    public CartServiceImpl(CourseRepository courses, RegistrationCartRepository carts, UserRepository users,
                           LeadRepository leads, Supplier<EntityManager> emSupplier) {
        courseRepository = courses; cartRepository = carts; userRepository = users;
        leadRepository = leads; this.emSupplier = emSupplier;
    }

    @Override
    public CartViewDTO getCart(HttpSession session, Long userId) {
        synchronized (lock(session)) {
            List<CartItemDTO> guest = guestItems(session);
            if (userId == null && guest.isEmpty()) return new CartViewDTO();
            EntityManager em = emSupplier.get();
            try {
                if (userId != null) requireUser(em, userId, false);
                return loadCart(em, guest, userId, false);
            } finally { em.close(); }
        }
    }

    @Override
    public void mergeGuestCart(HttpSession session, Long userId) {
        if (userId == null) return;
        synchronized (lock(session)) {
            List<CartItemDTO> guest = guestItems(session);
            if (guest.isEmpty()) return;
            EntityManager em = emSupplier.get(); EntityTransaction tx = em.getTransaction();
            try {
                tx.begin(); User user = requireUser(em, userId, true);
                merge(em, user, guest); tx.commit();
                session.removeAttribute(SESSION_CART_KEY);
            } catch (RuntimeException e) { rollback(tx); throw e; } finally { em.close(); }
        }
    }

    @Override
    public boolean addToCart(HttpSession session, Long userId, Long courseId, String notes) {
        requireId(courseId); String cleanNotes = validateNotes(notes);
        synchronized (lock(session)) {
            EntityManager em = emSupplier.get(); EntityTransaction tx = em.getTransaction();
            try {
                tx.begin(); User user = userId == null ? null : requireUser(em, userId, true);
                Course course = openCourse(em, courseId, true);
                if (user != null) {
                    merge(em, user, guestItems(session));
                    boolean added = cartRepository.findByUserAndCourse(em, userId, courseId).isEmpty();
                    if (added) cartRepository.save(em, new RegistrationCartItem(user, course, cleanNotes));
                    tx.commit(); clearGuest(session); invalidateCheckout(session); return added;
                }
                List<CartItemDTO> guest = guestItems(session);
                boolean added = guest.stream().noneMatch(i -> courseId.equals(i.getCourseId()));
                if (added) guest.add(map(course, cleanNotes));
                tx.commit(); putGuest(session, guest); invalidateCheckout(session); return added;
            } catch (RuntimeException e) { rollback(tx); throw e; } finally { em.close(); }
        }
    }

    @Override
    public void updateNotes(HttpSession session, Long userId, Long courseId, String notes) {
        requireId(courseId); String clean = validateNotes(notes);
        synchronized (lock(session)) {
            if (userId == null) {
                List<CartItemDTO> guest = guestItems(session);
                CartItemDTO item = guest.stream().filter(i -> courseId.equals(i.getCourseId())).findFirst()
                        .orElseThrow(() -> new ValidationException("Khóa học không có trong danh sách đăng ký."));
                item.setNotes(clean); putGuest(session, guest); invalidateCheckout(session); return;
            }
            EntityManager em = emSupplier.get(); EntityTransaction tx = em.getTransaction();
            try {
                tx.begin(); User user = requireUser(em, userId, true); merge(em, user, guestItems(session));
                RegistrationCartItem item = cartRepository.findByUserAndCourse(em, userId, courseId)
                        .orElseThrow(() -> new ValidationException("Khóa học không có trong danh sách đăng ký."));
                item.setNotes(clean); cartRepository.save(em, item); tx.commit();
                clearGuest(session); invalidateCheckout(session);
            } catch (RuntimeException e) { rollback(tx); throw e; } finally { em.close(); }
        }
    }

    @Override
    public void removeFromCart(HttpSession session, Long userId, Long courseId) {
        requireId(courseId);
        synchronized (lock(session)) {
            if (userId != null) {
                EntityManager em = emSupplier.get(); EntityTransaction tx = em.getTransaction();
                try {
                    tx.begin(); requireUser(em, userId, true);
                    cartRepository.deleteByUserAndCourse(em, userId, courseId); tx.commit();
                } catch (RuntimeException e) { rollback(tx); throw e; } finally { em.close(); }
            }
            List<CartItemDTO> guest = guestItems(session); guest.removeIf(i -> courseId.equals(i.getCourseId()));
            putGuest(session, guest); invalidateCheckout(session);
        }
    }

    @Override
    public void clearCart(HttpSession session, Long userId) {
        synchronized (lock(session)) {
            if (userId != null) {
                EntityManager em = emSupplier.get(); EntityTransaction tx = em.getTransaction();
                try {
                    tx.begin(); requireUser(em, userId, true); cartRepository.clearByUserId(em, userId); tx.commit();
                } catch (RuntimeException e) { rollback(tx); throw e; } finally { em.close(); }
            }
            clearGuest(session); invalidateCheckout(session);
        }
    }

    @Override
    public String confirmRegistration(HttpSession session, Long userId, RegistrationCheckoutDTO checkout) {
        if (session == null || checkout == null) throw new ValidationException("Phiên đăng ký không hợp lệ.");
        synchronized (session) {
            String token = checkout.getSubmissionToken();
            RegistrationReceiptDTO previous = (RegistrationReceiptDTO) session.getAttribute(RECEIPT_KEY);
            if (previous != null && token != null && token.equals(session.getAttribute("LAST_SUBMISSION_TOKEN"))) return previous.getCode();
            if (token == null || !token.equals(session.getAttribute(CHECKOUT_TOKEN)))
                throw new ValidationException("Thông tin đăng ký đã thay đổi. Vui lòng kiểm tra và xác nhận lại.");
            validateCheckout(checkout);
            EntityManager em = emSupplier.get(); EntityTransaction tx = em.getTransaction();
            try {
                tx.begin(); if (userId != null) requireUser(em, userId, true);
                CartViewDTO cart = loadCart(em, guestItems(session), userId, true);
                if (cart.isEmpty()) throw new ValidationException("Danh sách đăng ký đang trống.");
                if (!cart.isCheckoutReady()) throw new ValidationException("Có khóa học đã ngừng tuyển sinh. Vui lòng cập nhật danh sách đăng ký.");
                Lead lead = new Lead(); lead.setName(checkout.getFullName().trim());
                lead.setPhone(checkout.getPhoneNumber().trim().replaceAll("[\\s.-]", ""));
                lead.setEmail(checkout.getEmail() == null || checkout.getEmail().isBlank() ? null : ValidationUtil.normalizeEmail(checkout.getEmail()));
                lead.setGradeLevel(checkout.getGradeLevel()); lead.setSource("WEBSITE"); lead.setStatus("NEW");
                LocalDateTime now = LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")); lead.setCreatedAt(now); lead.setUpdatedAt(now);
                StringBuilder notes = new StringBuilder("ĐĂNG KÝ KHÓA HỌC TRỰC TUYẾN\n");
                if (checkout.getSchoolName() != null && !checkout.getSchoolName().isBlank()) notes.append("Trường: ").append(checkout.getSchoolName().trim()).append('\n');
                if (!checkout.getTargetGoals().isEmpty()) notes.append("Mục tiêu: ").append(String.join(", ", checkout.getTargetGoals())).append('\n');
                if (checkout.getNotes() != null && !checkout.getNotes().isBlank()) notes.append("Nguyện vọng: ").append(checkout.getNotes().trim()).append('\n');
                for (CartItemDTO item : cart.getItems()) {
                    notes.append('[').append(item.getCourseCode()).append("] ").append(item.getCourseName()).append(" · ").append(item.getFormattedFee());
                    if (item.getNotes() != null && !item.getNotes().isBlank()) notes.append("; ").append(item.getNotes());
                    notes.append('\n');
                }
                notes.append("Tổng học phí niêm yết: ").append(cart.getFormattedTotalFee()); lead.setNotes(notes.toString());
                lead = leadRepository.save(em, lead);
                if (userId != null) cartRepository.clearByUserId(em, userId);
                tx.commit();
                RegistrationReceiptDTO receipt = new RegistrationReceiptDTO(lead);
                session.setAttribute(RECEIPT_KEY, receipt); session.setAttribute("LAST_SUBMISSION_TOKEN", token);
                clearGuest(session); session.removeAttribute(CHECKOUT_TOKEN); session.removeAttribute("CHECKOUT_FORM_DRAFT");
                return receipt.getCode();
            } catch (RuntimeException e) { rollback(tx); throw e; } finally { em.close(); }
        }
    }

    private CartViewDTO loadCart(EntityManager em, List<CartItemDTO> guest, Long userId, boolean forUpdate) {
        Map<Long, CartItemDTO> items = new TreeMap<>();
        if (userId != null) for (RegistrationCartItem item : cartRepository.findByUserId(em, userId))
            items.put(item.getCourse().getId(), map(item.getCourse(), item.getNotes()));
        for (CartItemDTO item : guest) items.putIfAbsent(item.getCourseId(), item);
        List<CartItemDTO> current = new ArrayList<>(); BigDecimal total = BigDecimal.ZERO;
        for (CartItemDTO intent : items.values()) {
            Optional<Course> found = forUpdate ? courseRepository.findByIdForUpdate(em, intent.getCourseId()) : courseRepository.findById(em, intent.getCourseId());
            CartItemDTO item;
            if (found.isPresent()) item = map(found.get(), intent.getNotes());
            else {
                item = new CartItemDTO(); item.setCourseId(intent.getCourseId()); item.setCourseName(intent.getCourseName());
                item.setCourseCode(intent.getCourseCode()); item.setNotes(intent.getNotes()); item.setAvailable(false); item.setFee(BigDecimal.ZERO);
            }
            current.add(item); if (item.isAvailable()) total = total.add(item.getFee());
        }
        return new CartViewDTO(current, total);
    }

    private void merge(EntityManager em, User user, List<CartItemDTO> guest) {
        for (CartItemDTO item : guest.stream().sorted(Comparator.comparing(CartItemDTO::getCourseId)).toList()) {
            if (cartRepository.findByUserAndCourse(em, user.getId(), item.getCourseId()).isEmpty()) {
                Course course = courseRepository.findByIdForUpdate(em, item.getCourseId())
                        .orElseThrow(() -> new ValidationException("Một khóa học trong giỏ khách không còn tồn tại. Vui lòng xóa lựa chọn đó trước."));
                cartRepository.save(em, new RegistrationCartItem(user, course, item.getNotes()));
            }
        }
    }
    private User requireUser(EntityManager em, Long id, boolean lock) {
        User user = (lock ? userRepository.findByIdWithLock(em, id) : userRepository.findById(em, id))
                .orElseThrow(() -> new AuthorizationException("Tài khoản không còn tồn tại."));
        if (!user.isActive()) throw new AuthorizationException("Tài khoản không còn hoạt động.");
        return user;
    }
    private Course openCourse(EntityManager em, Long id, boolean lock) {
        Course course = (lock ? courseRepository.findByIdForUpdate(em, id) : courseRepository.findById(em, id))
                .orElseThrow(() -> new ValidationException("Không tìm thấy khóa học."));
        if (!"OPEN".equalsIgnoreCase(course.getStatus()) || course.getFee() == null || course.getFee().signum() < 0)
            throw new ValidationException("Khóa học hiện không mở đăng ký hoặc chưa công bố học phí.");
        return course;
    }
    private CartItemDTO map(Course course, String notes) {
        CartItemDTO item = new CartItemDTO(); item.setCourseId(course.getId()); item.setCourseCode(course.getCode());
        item.setCourseName(course.getName()); item.setGradeLevel(course.getGradeLevel()); item.setFee(course.getFee());
        item.setTotalSessions(course.getTotalSessions()); item.setMaxCapacity(course.getMaxCapacity());
        item.setImageUrl(course.getImageUrl()); item.setNotes(notes);
        item.setAvailable("OPEN".equalsIgnoreCase(course.getStatus()) && course.getFee() != null && course.getFee().signum() >= 0);
        if (course.getSubject() != null) { item.setSubjectName(course.getSubject().getName()); item.setSubjectCode(course.getSubject().getCode()); }
        return item;
    }
    @SuppressWarnings("unchecked")
    private List<CartItemDTO> guestItems(HttpSession session) {
        Object value = session == null ? null : session.getAttribute(SESSION_CART_KEY);
        return value instanceof List<?> ? new ArrayList<>((List<CartItemDTO>) value) : new ArrayList<>();
    }
    private Object lock(HttpSession session) { return session == null ? this : session; }
    private void putGuest(HttpSession session, List<CartItemDTO> items) { if (session != null) session.setAttribute(SESSION_CART_KEY, items); }
    private void clearGuest(HttpSession session) { if (session != null) session.removeAttribute(SESSION_CART_KEY); }
    private void invalidateCheckout(HttpSession session) { if (session != null) session.removeAttribute(CHECKOUT_TOKEN); }
    private void requireId(Long id) { if (id == null || id <= 0) throw new ValidationException("Mã khóa học không hợp lệ."); }
    private String validateNotes(String notes) {
        if (notes != null && notes.length() > 500) throw new ValidationException("Ghi chú không được vượt quá 500 ký tự.");
        return notes == null || notes.isBlank() ? null : notes.trim();
    }
    private void validateCheckout(RegistrationCheckoutDTO form) {
        if (!ValidationUtil.isValidFullName(form.getFullName())) throw new ValidationException("Họ tên phải có từ 2 đến 150 ký tự.");
        if (!ValidationUtil.isValidPhone(form.getPhoneNumber(), true)) throw new ValidationException("Số điện thoại không đúng định dạng Việt Nam.");
        if (form.getEmail() != null && !form.getEmail().isBlank() && !ValidationUtil.isValidEmail(form.getEmail())) throw new ValidationException("Email không hợp lệ.");
        if (form.getGradeLevel() == null || form.getGradeLevel() < 6 || form.getGradeLevel() > 12) throw new ValidationException("Khối lớp phải từ 6 đến 12.");
        if (!form.isConsentChecked()) throw new ValidationException("Vui lòng đồng ý để trung tâm liên hệ tư vấn.");
        if (form.getSchoolName() != null && form.getSchoolName().length() > 200 || form.getNotes() != null && form.getNotes().length() > 2000)
            throw new ValidationException("Thông tin trường hoặc ghi chú quá dài.");
        if (form.getTargetGoals().size() > 10 || form.getTargetGoals().stream().anyMatch(g -> g == null || g.length() > 150)) throw new ValidationException("Mục tiêu đăng ký không hợp lệ.");
    }
    private void rollback(EntityTransaction tx) { if (tx.isActive()) tx.rollback(); }
}
