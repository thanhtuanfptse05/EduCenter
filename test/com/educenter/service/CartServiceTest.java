package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.LeadRepository;
import com.educenter.repository.RegistrationCartRepository;
import com.educenter.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("CartService — Course Cart Operations, Combo Discounts & Lead Conversion Tests")
public class CartServiceTest {

    private CartService cartService;
    private MockCourseRepository mockCourseRepo;
    private MockRegistrationCartRepository mockCartRepo;
    private MockUserRepository mockUserRepo;
    private MockLeadRepository mockLeadRepo;

    static class MockCourseRepository extends CourseRepository {
        Map<Long, Course> store = new HashMap<>();

        @Override
        public Optional<Course> findById(EntityManager em, Long id) {
            return Optional.ofNullable(store.get(id));
        }
    }

    static class MockRegistrationCartRepository extends RegistrationCartRepository {
        List<RegistrationCartItem> items = new ArrayList<>();

        @Override
        public List<RegistrationCartItem> findByUserId(EntityManager em, Long userId) {
            return items.stream().filter(i -> i.getUser() != null && i.getUser().getId().equals(userId)).toList();
        }

        @Override
        public Optional<RegistrationCartItem> findByUserAndCourse(EntityManager em, Long userId, Long courseId) {
            return items.stream()
                    .filter(i -> i.getUser().getId().equals(userId) && i.getCourse().getId().equals(courseId))
                    .findFirst();
        }

        @Override
        public RegistrationCartItem save(EntityManager em, RegistrationCartItem item) {
            if (item.getId() == null) {
                item.setId((long) (items.size() + 1));
                items.add(item);
            }
            return item;
        }

        @Override
        public void deleteByUserAndCourse(EntityManager em, Long userId, Long courseId) {
            items.removeIf(i -> i.getUser().getId().equals(userId) && i.getCourse().getId().equals(courseId));
        }

        @Override
        public void clearByUserId(EntityManager em, Long userId) {
            items.removeIf(i -> i.getUser().getId().equals(userId));
        }
    }

    static class MockUserRepository extends UserRepository {
        Map<Long, User> users = new HashMap<>();

        @Override
        public Optional<User> findById(EntityManager em, Long id) {
            return Optional.ofNullable(users.get(id));
        }
    }

    static class MockLeadRepository extends LeadRepository {
        List<Lead> leads = new ArrayList<>();
        long genId = 89L;

        @Override
        public Lead save(EntityManager em, Lead lead) {
            lead.setId(genId++);
            leads.add(lead);
            return lead;
        }
    }

    static class MockHttpSession implements HttpSession {
        private final Map<String, Object> attributes = new HashMap<>();

        @Override public Object getAttribute(String name) { return attributes.get(name); }
        @Override public void setAttribute(String name, Object value) { attributes.put(name, value); }
        @Override public void removeAttribute(String name) { attributes.remove(name); }

        @Override public long getCreationTime() { return 0; }
        @Override public String getId() { return "mock-session"; }
        @Override public long getLastAccessedTime() { return 0; }
        @Override public jakarta.servlet.ServletContext getServletContext() { return null; }
        @Override public void setMaxInactiveInterval(int interval) {}
        @Override public int getMaxInactiveInterval() { return 0; }
        @Override public Enumeration<String> getAttributeNames() { return Collections.enumeration(attributes.keySet()); }
        @Override public void invalidate() { attributes.clear(); }
        @Override public boolean isNew() { return false; }
    }

    @BeforeEach
    void setUp() {
        mockCourseRepo = new MockCourseRepository();
        mockCartRepo = new MockRegistrationCartRepository();
        mockUserRepo = new MockUserRepository();
        mockLeadRepo = new MockLeadRepository();

        Subject s1 = new Subject();
        s1.setId(1L);
        s1.setCode("MAT");
        s1.setName("Toán học");

        Subject s2 = new Subject();
        s2.setId(2L);
        s2.setCode("PHY");
        s2.setName("Vật lý");

        Course c1 = new Course();
        c1.setId(1L);
        c1.setCode("MAT12-LT01");
        c1.setName("Toán 12 Ôn Thi Tốt Nghiệp THPT");
        c1.setGradeLevel(12);
        c1.setSubject(s1);
        c1.setFee(new BigDecimal("3600000"));
        c1.setStatus("OPEN");
        mockCourseRepo.store.put(1L, c1);

        Course c2 = new Course();
        c2.setId(2L);
        c2.setCode("PHY12-CD03");
        c2.setName("Vật Lý 12 Chuyên Đề Điện Xoay Chiều");
        c2.setGradeLevel(12);
        c2.setSubject(s2);
        c2.setFee(new BigDecimal("3200000"));
        c2.setStatus("OPEN");
        mockCourseRepo.store.put(2L, c2);

        User user = new User();
        user.setId(10L);
        user.setFullName("Nguyễn Văn Tuấn");
        user.setPhone("0912345678");
        user.setEmail("tuan.nguyen@example.com");
        mockUserRepo.users.put(10L, user);

        EntityTransaction mockTx = (EntityTransaction) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{EntityTransaction.class},
                (proxy, method, args) -> {
                    if ("isActive".equals(method.getName())) return true;
                    return null;
                }
        );

        EntityManager mockEm = (EntityManager) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{EntityManager.class},
                (proxy, method, args) -> {
                    if ("isOpen".equals(method.getName())) return true;
                    if ("close".equals(method.getName())) return null;
                    if ("getTransaction".equals(method.getName())) return mockTx;
                    return null;
                }
        );

        cartService = new CartServiceImpl(mockCourseRepo, mockCartRepo, mockUserRepo, mockLeadRepo, () -> mockEm);
    }

    @Test
    @DisplayName("Guest user can add course to session cart without duplicate")
    void testGuestAddToCartNoDuplicate() {
        HttpSession session = new MockHttpSession();

        cartService.addToCart(session, null, 1L, "Lịch tối thứ 2");
        CartViewDTO cart1 = cartService.getCart(session, null);
        assertEquals(1, cart1.getTotalCourses());
        assertEquals(new BigDecimal("3600000"), cart1.getTotalFee());

        // Add the same course again with updated note
        cartService.addToCart(session, null, 1L, "Lịch tối thứ 5");
        CartViewDTO cart2 = cartService.getCart(session, null);
        assertEquals(1, cart2.getTotalCourses(), "Should not duplicate course item");
        assertEquals("Lịch tối thứ 5", cart2.getItems().get(0).getNotes());
    }

    @Test
    @DisplayName("Combo discount applies 10% when 2 or more courses are in cart")
    void testComboDiscountTwoCourses() {
        HttpSession session = new MockHttpSession();
        cartService.addToCart(session, null, 1L, null);
        cartService.addToCart(session, null, 2L, null);

        CartViewDTO cart = cartService.getCart(session, null);
        assertEquals(2, cart.getTotalCourses());
        assertEquals(new BigDecimal("6800000"), cart.getTotalFee());
        // 10% discount on 6,800,000 = 680,000
        assertEquals(new BigDecimal("680000"), cart.getDiscount());
        assertEquals(new BigDecimal("6120000"), cart.getFinalFee());
    }

    @Test
    @DisplayName("removeFromCart removes selected course and updates total")
    void testRemoveFromCart() {
        HttpSession session = new MockHttpSession();
        cartService.addToCart(session, null, 1L, null);
        cartService.addToCart(session, null, 2L, null);

        cartService.removeFromCart(session, null, 1L);
        CartViewDTO cart = cartService.getCart(session, null);

        assertEquals(1, cart.getTotalCourses());
        assertEquals(2L, cart.getItems().get(0).getCourseId());
        assertEquals(new BigDecimal("3200000"), cart.getTotalFee());
        assertEquals(BigDecimal.ZERO, cart.getDiscount(), "No combo discount for 1 course");
        assertEquals(new BigDecimal("3200000"), cart.getFinalFee());
    }

    @Test
    @DisplayName("confirmRegistration creates Lead, clears cart and returns LEAD code")
    void testConfirmRegistrationSuccess() {
        HttpSession session = new MockHttpSession();
        cartService.addToCart(session, null, 1L, null);
        cartService.addToCart(session, null, 2L, null);

        RegistrationCheckoutDTO checkout = new RegistrationCheckoutDTO();
        checkout.setFullName("Nguyễn Văn Tuấn");
        checkout.setPhoneNumber("0912345678");
        checkout.setEmail("tuan@example.com");
        checkout.setGradeLevel(12);
        checkout.setSchoolName("THPT Chuyên Hà Nội - Amsterdam");
        checkout.setTargetGoals(List.of("Thi tốt nghiệp THPT", "ĐGNL ĐHQG"));
        checkout.setNotes("Muốn thi thử đầu vào sớm");
        checkout.setConsentChecked(true);

        String leadCode = cartService.confirmRegistration(session, null, checkout);

        assertNotNull(leadCode);
        assertTrue(leadCode.startsWith("LEAD-"));
        assertEquals(1, mockLeadRepo.leads.size());
        assertEquals("Nguyễn Văn Tuấn", mockLeadRepo.leads.get(0).getName());
        assertEquals("0912345678", mockLeadRepo.leads.get(0).getPhone());

        // Verify cart is cleared
        CartViewDTO emptyCart = cartService.getCart(session, null);
        assertTrue(emptyCart.isEmpty());
    }

    @Test
    @DisplayName("confirmRegistration throws ValidationException when cart is empty")
    void testConfirmRegistrationEmptyCart() {
        HttpSession session = new MockHttpSession();
        RegistrationCheckoutDTO checkout = new RegistrationCheckoutDTO();
        checkout.setFullName("Nguyễn Văn Tuấn");
        checkout.setPhoneNumber("0912345678");
        checkout.setGradeLevel(12);
        checkout.setConsentChecked(true);

        assertThrows(ValidationException.class, () -> cartService.confirmRegistration(session, null, checkout));
    }

    @Test
    @DisplayName("confirmRegistration throws ValidationException on invalid phone format")
    void testConfirmRegistrationInvalidPhone() {
        HttpSession session = new MockHttpSession();
        cartService.addToCart(session, null, 1L, null);

        RegistrationCheckoutDTO checkout = new RegistrationCheckoutDTO();
        checkout.setFullName("Nguyễn Văn Tuấn");
        checkout.setPhoneNumber("123456");
        checkout.setGradeLevel(12);
        checkout.setConsentChecked(true);

        assertThrows(ValidationException.class, () -> cartService.confirmRegistration(session, null, checkout));
    }

    @Test
    @DisplayName("confirmRegistration throws ValidationException when consent is not checked")
    void testConfirmRegistrationNoConsent() {
        HttpSession session = new MockHttpSession();
        cartService.addToCart(session, null, 1L, null);

        RegistrationCheckoutDTO checkout = new RegistrationCheckoutDTO();
        checkout.setFullName("Nguyễn Văn Tuấn");
        checkout.setPhoneNumber("0912345678");
        checkout.setGradeLevel(12);
        checkout.setConsentChecked(false);

        assertThrows(ValidationException.class, () -> cartService.confirmRegistration(session, null, checkout));
    }
}
