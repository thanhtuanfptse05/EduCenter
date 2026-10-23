package com.educenter.controller;

import com.educenter.entity.User;
import com.educenter.service.UserServiceImpl;
import com.educenter.support.*;
import jakarta.persistence.EntityManager;
import java.net.*;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.*;
import java.util.regex.*;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

@Tag("sqlserver")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class PortalFlowTest {
    static SqlServerFixture database;
    static LocalServer server;
    static String base;
    static HttpClient guest;
    static String checkoutToken;
    static String checkoutCsrf;
    static Map<String, String> submitted;

    @BeforeAll static void start() throws Exception {
        database = new SqlServerFixture(); server = new LocalServer(0, true); base = server.baseUrl(); guest = client();
    }
    @AfterAll static void stop() throws Exception {
        try { if (server != null) server.close(); } finally { if (database != null) database.close(); }
    }
    static HttpClient client() {
        return HttpClient.newBuilder().cookieHandler(new CookieManager(null, CookiePolicy.ACCEPT_ALL))
                .followRedirects(HttpClient.Redirect.NEVER).connectTimeout(Duration.ofSeconds(15)).build();
    }
    static HttpResponse<String> get(HttpClient client, String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create(base + path)).timeout(Duration.ofSeconds(60)).GET().build(), HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }
    static HttpResponse<String> post(HttpClient client, String path, Map<String, String> values) throws Exception {
        String body = values.entrySet().stream().map(e -> encode(e.getKey()) + "=" + encode(e.getValue())).collect(java.util.stream.Collectors.joining("&"));
        return client.send(HttpRequest.newBuilder(URI.create(base + path)).timeout(Duration.ofSeconds(60))
                .header("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                .POST(HttpRequest.BodyPublishers.ofString(body)).build(), HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }
    static String encode(String value) { return URLEncoder.encode(value, StandardCharsets.UTF_8); }
    static String input(String html, String name) {
        Matcher found = Pattern.compile("name=\"" + name + "\"[^>]*value=\"([^\"]*)\"").matcher(html);
        assertTrue(found.find(), "Missing form field: " + name); return found.group(1);
    }
    static String csrf(HttpClient client, String path) throws Exception { return input(get(client, path).body(), "csrfToken"); }
    static HttpResponse<String> login(HttpClient client, String email, String password) throws Exception {
        return post(client, "/login", Map.of("csrfToken", csrf(client, "/login"), "email", email, "password", password, "redirect_url", "/registration-cart"));
    }

    @Test @Order(1) void publicPagesRenderWithOneSharedNavbarAndRealEmptyStates() throws Exception {
        for (String path : List.of("/", "/courses", "/courses/detail?id=" + database.courseOne, "/registration-cart", "/login", "/register", "/forgot-password", "/reset-password?token=" + "0".repeat(64))) {
            HttpResponse<String> response = get(guest, path); assertEquals(200, response.statusCode(), path);
            assertEquals(1, response.body().split("data-shared-public-header", -1).length - 1, path);
            assertFalse(response.body().contains("3.850+")); assertFalse(response.body().contains("98.2%"));
            assertFalse(response.body().contains("getOriginalFee"));
        }
        assertEquals(404, get(guest, "/unknown-page").statusCode());
        assertEquals(302, get(guest, "/consultation/success?code=LEAD-2026-001").statusCode());
        assertEquals(403, post(guest, "/registration-cart/add", Map.of("courseId", "1")).statusCode());
        assertEquals(301, get(guest, "/assets/images/courses/classroom-hero.jpg").statusCode());
        assertEquals(301, get(guest, "/assets/images/teachers/teacher-nam.jpg").statusCode());
        assertEquals(200, get(guest, "/assets/images/courses/classroom.jpg").statusCode());
        HttpResponse<String> failure = get(guest, "/__verification/error");
        assertEquals(500, failure.statusCode());
        assertTrue(failure.body().contains("EC-"));
        assertFalse(failure.body().contains("PRIVATE_VERIFICATION_SENTINEL"));
    }

    @Test @Order(2) void guestCartRendersDuplicatesNotesAndCurrentPrices() throws Exception {
        String token = csrf(guest, "/courses");
        assertEquals(302, post(guest, "/registration-cart/add", Map.of("csrfToken", token, "courseId", "" + database.courseOne)).statusCode());
        assertEquals(302, post(guest, "/registration-cart/add", Map.of("csrfToken", token, "courseId", "" + database.courseOne)).statusCode());
        assertEquals(200, get(guest, "/registration-cart").statusCode());
        assertEquals(302, post(guest, "/registration-cart/update", Map.of("csrfToken", token, "courseId", "" + database.courseOne, "notes", "Ưu tiên <em>buổi tối</em>")).statusCode());
        assertTrue(get(guest, "/registration-cart").body().contains("Ưu tiên &lt;em&gt;buổi tối&lt;/em&gt;"));
        EntityManager em = database.factory.createEntityManager();
        try { em.getTransaction().begin(); em.createQuery("UPDATE Course c SET c.fee = 1100000 WHERE c.id = :id").setParameter("id", database.courseOne).executeUpdate(); em.getTransaction().commit(); } finally { em.close(); }
        assertTrue(get(guest, "/registration-cart").body().contains("1.100.000"));
    }

    @Test @Order(3) void loginRenewsSessionAndMergesExistingAccountCart() throws Exception {
        HttpResponse<String> response = login(guest, "student@verification.invalid", SqlServerFixture.PASSWORD);
        assertEquals(302, response.statusCode()); assertEquals("/EduCenter/registration-cart", response.headers().firstValue("Location").orElseThrow());
        String html = get(guest, "/registration-cart").body(); assertTrue(html.contains("VERIFY-ONE")); assertTrue(html.contains("VERIFY-TWO"));
        assertTrue(html.contains("3.100.000")); assertFalse(html.toLowerCase(Locale.ROOT).contains("combo"));
        assertEquals(2, database.count("SELECT COUNT(i) FROM RegistrationCartItem i"));
        assertTrue(get(guest, "/").body().contains("Vững kiến thức"));
        assertEquals(403, get(guest, "/admin/users").statusCode());
        assertEquals(200, get(guest, "/profile").statusCode()); assertEquals(200, get(guest, "/logout").statusCode());
        assertEquals(200, get(guest, "/student/dashboard").statusCode());
    }

    @Test @Order(4) void confirmationCreatesOnePersistedSessionBoundReceipt() throws Exception {
        String html = get(guest, "/registration/confirm").body(); checkoutToken = input(html, "submissionToken"); checkoutCsrf = input(html, "csrfToken");
        submitted = new HashMap<>(Map.of("csrfToken", checkoutCsrf, "submissionToken", checkoutToken, "fullName", "Học viên kiểm thử", "phoneNumber", "0912345678", "gradeLevel", "12", "consentCheck", "true"));
        assertEquals(302, post(guest, "/registration/confirm", submitted).statusCode());
        assertEquals(302, post(guest, "/registration/confirm", submitted).statusCode());
        assertEquals(1, database.count("SELECT COUNT(l) FROM Lead l")); assertEquals(0, database.count("SELECT COUNT(i) FROM RegistrationCartItem i"));
        String receipt = get(guest, "/consultation/success").body(); assertTrue(receipt.contains("Học viên kiểm thử")); assertTrue(receipt.contains("Thời điểm tiếp nhận"));
        assertFalse(receipt.contains("Vừa xong")); assertEquals(302, get(client(), "/consultation/success").statusCode());
    }

    @Test @Order(5) void resetUsesActualTokenAndRevokesBothOldSessions() throws Exception {
        HttpClient second = client(); assertEquals(302, login(second, "student@verification.invalid", SqlServerFixture.PASSWORD).statusCode());
        HttpClient recovery = client(); String token = csrf(recovery, "/forgot-password");
        post(recovery, "/forgot-password", Map.of("csrfToken", token, "email", "student@verification.invalid"));
        String html = get(recovery, "/forgot-password").body(); Matcher reset = Pattern.compile("reset-password\\?token=([a-f0-9]{64})").matcher(html); assertTrue(reset.find());
        String raw = reset.group(1); String form = get(recovery, "/reset-password?token=" + raw).body(); assertTrue(form.contains("data-reset-seconds="));
        assertEquals(302, post(recovery, "/reset-password", Map.of("csrfToken", input(form, "csrfToken"), "token", raw, "newPassword", "ChangedVerificationPass17", "confirmNewPassword", "ChangedVerificationPass17")).statusCode());
        assertEquals(302, get(guest, "/profile").statusCode()); assertEquals(302, get(second, "/profile").statusCode());
        assertFalse(get(recovery, "/reset-password?token=" + raw).body().contains("data-reset-form"));
        assertEquals(302, login(recovery, "student@verification.invalid", "ChangedVerificationPass17").statusCode());
    }

    @Test @Order(6) void adminStatusIsDistinctFromFilterAndNamesAreContextEscaped() throws Exception {
        HttpClient admin = client(); assertEquals(302, login(admin, "admin@verification.invalid", SqlServerFixture.PASSWORD).statusCode());
        HttpResponse<String> listing = get(admin, "/admin/users"); assertEquals(200, listing.statusCode());
        assertTrue(listing.body().contains("data-role-editor")); assertFalse(listing.body().contains("data-user-name=\"O'Brien <em>"));
        String token = input(listing.body(), "csrfToken");
        post(admin, "/admin/users/status", Map.of("csrfToken", token, "userId", "" + database.studentId, "status", "ACTIVE", "actionStatus", "LOCKED"));
        EntityManager em = database.factory.createEntityManager();
        try { assertEquals("LOCKED", em.find(User.class, database.studentId).getStatus()); } finally { em.close(); }
        post(admin, "/admin/users/status", Map.of("csrfToken", token, "userId", "" + database.studentId, "status", "LOCKED", "actionStatus", "ACTIVE"));
        em = database.factory.createEntityManager(); try { assertEquals("ACTIVE", em.find(User.class, database.studentId).getStatus()); } finally { em.close(); }
        assertEquals(2, database.count("SELECT COUNT(a) FROM AuditLog a"));
        for (String account : List.of("staff", "teacher", "parent")) {
            HttpClient role = client(); assertEquals(302, login(role, account + "@verification.invalid", SqlServerFixture.PASSWORD).statusCode());
            assertEquals(200, get(role, "/" + (account.equals("staff") ? "staff/leads" : account + "/dashboard")).statusCode());
        }
    }

    @Test @Order(7) void simultaneousAdminDemotionsKeepOneActiveAdmin() throws Exception {
        var pool = java.util.concurrent.Executors.newFixedThreadPool(2);
        try {
            var first = pool.submit(() -> demote(database.adminOne, database.adminTwo));
            var second = pool.submit(() -> demote(database.adminTwo, database.adminOne));
            assertNotEquals(first.get(20, java.util.concurrent.TimeUnit.SECONDS), second.get(20, java.util.concurrent.TimeUnit.SECONDS));
            assertEquals(1, database.count("SELECT COUNT(DISTINCT u) FROM User u JOIN u.roles r WHERE r.code='ADMIN' AND u.status='ACTIVE'"));
        } finally { pool.shutdownNow(); }
    }
    private boolean demote(long actor, long target) {
        try { new UserServiceImpl().assignRoles(actor, target, Set.of("STUDENT"), "127.0.0.1"); return true; }
        catch (com.educenter.service.AuthorizationException | com.educenter.service.ValidationException expected) { return false; }
    }

    @Test @Order(8) void checkoutLockRefreshesAlreadyLoadedCourse() {
        EntityManager first = database.factory.createEntityManager();
        EntityManager second = database.factory.createEntityManager();
        try {
            var loaded = first.find(com.educenter.entity.Course.class, database.courseOne);
            var changedFee = loaded.getFee().add(java.math.BigDecimal.ONE);
            second.getTransaction().begin();
            second.createQuery("UPDATE Course c SET c.fee=:fee WHERE c.id=:id")
                    .setParameter("fee", changedFee).setParameter("id", database.courseOne).executeUpdate();
            second.getTransaction().commit();
            first.getTransaction().begin();
            var current = new com.educenter.repository.CourseRepository().findByIdForUpdate(first, database.courseOne).orElseThrow();
            assertEquals(0, changedFee.compareTo(current.getFee()));
            first.getTransaction().commit();
        } finally {
            if (first.getTransaction().isActive()) first.getTransaction().rollback();
            first.close(); second.close();
        }
    }
}
