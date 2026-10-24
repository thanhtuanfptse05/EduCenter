package com.educenter.controller;

import com.educenter.dto.CartViewDTO;
import com.educenter.dto.UserPrincipalDTO;
import com.educenter.service.CartService;
import com.educenter.service.LandingService;
import com.educenter.service.SystemSettingService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("RoleAccessCartConsultationTest — Chỉ Học sinh và Phụ huynh được thao tác tư vấn và giỏ hàng")
public class RoleAccessCartConsultationTest {

    private LandingServlet landingServlet;
    private RegistrationCartServlet cartServlet;
    private Map<String, Object> sessionAttributes;
    private Map<String, Object> requestAttributes;
    private Map<String, String> requestParameters;
    private List<String> redirectedUrls;
    private int responseStatus;

    private HttpSession mockSession;
    private HttpServletRequest mockRequest;
    private HttpServletResponse mockResponse;

    private String currentServletPath = "/registration-cart";

    @BeforeEach
    void setUp() {
        sessionAttributes = new HashMap<>();
        requestAttributes = new HashMap<>();
        requestParameters = new HashMap<>();
        redirectedUrls = new ArrayList<>();
        responseStatus = 200;
        currentServletPath = "/registration-cart";

        // Valid CSRF token in session
        sessionAttributes.put("csrfToken", "valid-csrf-token");
        requestParameters.put("csrfToken", "valid-csrf-token");

        mockSession = (HttpSession) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{HttpSession.class},
                (proxy, method, args) -> {
                    String name = method.getName();
                    if ("getAttribute".equals(name)) return sessionAttributes.get(args[0]);
                    if ("setAttribute".equals(name)) { sessionAttributes.put((String) args[0], args[1]); return null; }
                    if ("removeAttribute".equals(name)) { sessionAttributes.remove(args[0]); return null; }
                    if ("getId".equals(name)) return "mock-session-id";
                    return null;
                }
        );

        RequestDispatcher mockDispatcher = (RequestDispatcher) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{RequestDispatcher.class},
                (proxy, method, args) -> null
        );

        mockRequest = (HttpServletRequest) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{HttpServletRequest.class},
                (proxy, method, args) -> {
                    String name = method.getName();
                    if ("getSession".equals(name)) return mockSession;
                    if ("getServletPath".equals(name)) return currentServletPath;
                    if ("getParameter".equals(name)) return requestParameters.get(args[0]);
                    if ("getParameterValues".equals(name)) {
                        String v = requestParameters.get(args[0]);
                        return v != null ? new String[]{v} : null;
                    }
                    if ("getAttribute".equals(name)) return requestAttributes.get(args[0]);
                    if ("setAttribute".equals(name)) { requestAttributes.put((String) args[0], args[1]); return null; }
                    if ("getContextPath".equals(name)) return "/EduCenter";
                    if ("getRequestDispatcher".equals(name)) return mockDispatcher;
                    return null;
                }
        );

        mockResponse = (HttpServletResponse) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{HttpServletResponse.class},
                (proxy, method, args) -> {
                    String name = method.getName();
                    if ("sendRedirect".equals(name)) {
                        redirectedUrls.add((String) args[0]);
                        return null;
                    }
                    if ("setStatus".equals(name) || "sendError".equals(name)) {
                        responseStatus = (int) args[0];
                        return null;
                    }
                    return null;
                }
        );

        landingServlet = new LandingServlet();
        cartServlet = new RegistrationCartServlet();

        // Stub cartService
        CartService mockCartService = (CartService) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{CartService.class},
                (proxy, method, args) -> {
                    if ("getCart".equals(method.getName())) {
                        return new CartViewDTO();
                    }
                    if ("addToCart".equals(method.getName())) {
                        return true;
                    }
                    return null;
                }
        );
        cartServlet.setCartService(mockCartService);

        SystemSettingService mockSettingService = (SystemSettingService) Proxy.newProxyInstance(
                getClass().getClassLoader(),
                new Class<?>[]{SystemSettingService.class},
                (proxy, method, args) -> {
                    if ("isAdmissionsOpen".equals(method.getName())) return true;
                    return null;
                }
        );
        cartServlet.setSystemSettingService(mockSettingService);
    }

    private UserPrincipalDTO createUser(String role) {
        return new UserPrincipalDTO(100L, role.toLowerCase() + "@educenter.vn", "Nguyễn Văn " + role, "0912345678", null, "ACTIVE", Set.of(role));
    }

    // ==========================================
    // 1. Consultation Tests (/dang-ky-tu-van)
    // ==========================================

    @Test
    @DisplayName("Khách vãng lai gửi tư vấn hợp lệ được tiếp tục xử lý")
    void testGuestConsultation_Allowed() throws Exception {
        setRequestPath(mockRequest, "/dang-ky-tu-van");
        requestParameters.put("fullName", "Khách Hàng Mới");
        requestParameters.put("phone", "0987654321");

        landingServlet.doPost(mockRequest, mockResponse);

        // Does not show role error
        assertNotEquals("Tính năng đăng ký tư vấn chỉ dành cho tài khoản Học sinh hoặc Phụ huynh.", sessionAttributes.get("alertMessage"));
    }

    @Test
    @DisplayName("Tài khoản Học sinh hoặc Phụ huynh gửi tư vấn được chấp nhận")
    void testStudentParentConsultation_Allowed() throws Exception {
        setRequestPath(mockRequest, "/dang-ky-tu-van");
        sessionAttributes.put("currentUser", createUser("STUDENT"));
        requestParameters.put("fullName", "Em Học Sinh");
        requestParameters.put("phone", "0987654321");

        landingServlet.doPost(mockRequest, mockResponse);

        assertNotEquals("Tính năng đăng ký tư vấn chỉ dành cho tài khoản Học sinh hoặc Phụ huynh.", sessionAttributes.get("alertMessage"));
    }

    @Test
    @DisplayName("Tài khoản Giáo viên, Quản trị viên, Nhân viên gửi tư vấn bị chặn và báo lỗi rõ ràng")
    void testInternalRolesConsultation_Blocked() throws Exception {
        setRequestPath(mockRequest, "/dang-ky-tu-van");

        for (String role : List.of("TEACHER", "ADMIN", "STAFF")) {
            sessionAttributes.put("currentUser", createUser(role));
            redirectedUrls.clear();

            landingServlet.doPost(mockRequest, mockResponse);

            assertEquals("error", sessionAttributes.get("alertType"));
            assertEquals("Tính năng đăng ký tư vấn chỉ dành cho tài khoản Học sinh hoặc Phụ huynh.", sessionAttributes.get("alertMessage"));
            assertTrue(redirectedUrls.contains("/EduCenter/#dang-ky-tu-van"));
        }
    }

    // ==========================================
    // 2. Cart Operations Tests (/registration-cart/*)
    // ==========================================

    @Test
    @DisplayName("Khách vãng lai và Học sinh/Phụ huynh được thêm khóa học vào giỏ hàng")
    void testAddToCart_CustomerAndGuest_Allowed() throws Exception {
        setRequestPath(mockRequest, "/registration-cart/add");
        requestParameters.put("courseId", "1");

        // 1. Guest
        cartServlet.doPost(mockRequest, mockResponse);
        assertTrue(redirectedUrls.contains("/EduCenter/registration-cart"));

        // 2. Student
        redirectedUrls.clear();
        sessionAttributes.put("currentUser", createUser("STUDENT"));
        cartServlet.doPost(mockRequest, mockResponse);
        assertTrue(redirectedUrls.contains("/EduCenter/registration-cart"));

        // 3. Parent
        redirectedUrls.clear();
        sessionAttributes.put("currentUser", createUser("PARENT"));
        cartServlet.doPost(mockRequest, mockResponse);
        assertTrue(redirectedUrls.contains("/EduCenter/registration-cart"));
    }

    @Test
    @DisplayName("Tài khoản nội bộ (TEACHER, ADMIN, STAFF) thêm giỏ hàng bị từ chối")
    void testAddToCart_InternalRoles_Blocked() throws Exception {
        setRequestPath(mockRequest, "/registration-cart/add");
        requestParameters.put("courseId", "1");

        for (String role : List.of("TEACHER", "ADMIN", "STAFF")) {
            sessionAttributes.put("currentUser", createUser(role));
            redirectedUrls.clear();

            cartServlet.doPost(mockRequest, mockResponse);

            assertEquals("Tính năng giỏ hàng và đăng ký khóa học chỉ dành cho tài khoản Phụ huynh hoặc Học sinh.", sessionAttributes.get("flash_error"));
            assertTrue(redirectedUrls.contains("/EduCenter/courses"));
        }
    }

    // ==========================================
    // 3. Confirmation / Checkout Tests (/registration/confirm)
    // ==========================================

    @Test
    @DisplayName("Khách vãng lai truy cập bước chốt thanh toán (/registration/confirm) bị yêu cầu đăng nhập")
    void testCheckout_GuestRequiresLogin() throws Exception {
        setRequestPath(mockRequest, "/registration/confirm");

        // GET /registration/confirm
        cartServlet.doGet(mockRequest, mockResponse);

        assertEquals("Vui lòng đăng nhập bằng tài khoản Học sinh hoặc Phụ huynh để xác nhận đăng ký khóa học.", sessionAttributes.get("flash_warning"));
        assertTrue(redirectedUrls.get(0).contains("/login?redirect_url="));

        // POST /registration/confirm
        redirectedUrls.clear();
        cartServlet.doPost(mockRequest, mockResponse);
        assertEquals("Vui lòng đăng nhập tài khoản Học sinh hoặc Phụ huynh để hoàn tất bước đăng ký và thanh toán.", sessionAttributes.get("flash_warning"));
        assertTrue(redirectedUrls.get(0).contains("/login?redirect_url="));
    }

    @Test
    @DisplayName("Tài khoản nội bộ truy cập bước chốt thanh toán bị chặn và chuyển về giỏ hàng")
    void testCheckout_InternalRoles_Blocked() throws Exception {
        setRequestPath(mockRequest, "/registration/confirm");

        for (String role : List.of("TEACHER", "ADMIN", "STAFF")) {
            sessionAttributes.put("currentUser", createUser(role));
            redirectedUrls.clear();

            // GET
            cartServlet.doGet(mockRequest, mockResponse);
            assertEquals("Tính năng chốt đăng ký và thanh toán chỉ dành cho tài khoản Phụ huynh hoặc Học sinh.", sessionAttributes.get("flash_error"));
            assertTrue(redirectedUrls.contains("/EduCenter/registration-cart"));

            // POST
            redirectedUrls.clear();
            cartServlet.doPost(mockRequest, mockResponse);
            assertEquals("Tính năng giỏ hàng và đăng ký khóa học chỉ dành cho tài khoản Phụ huynh hoặc Học sinh.", sessionAttributes.get("flash_error"));
            assertTrue(redirectedUrls.contains("/EduCenter/registration-cart"));
        }
    }

    private void setRequestPath(HttpServletRequest req, String path) {
        this.currentServletPath = path;
    }
}
