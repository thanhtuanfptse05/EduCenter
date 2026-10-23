package com.educenter.support;

import com.educenter.entity.*;
import com.educenter.util.JPAUtil;
import com.educenter.util.PasswordUtil;
import jakarta.persistence.*;
import java.util.*;

/** Disposable SQL Server database. No test writes go to the configured application database. */
public final class SqlServerFixture implements AutoCloseable {
    public final String database = "EduCenterRepairTest_" + UUID.randomUUID().toString().replace("-", "").substring(0, 12);
    public final EntityManagerFactory factory;
    private final EntityManagerFactory adminFactory;
    public long courseOne, courseTwo, studentId, adminOne, adminTwo;
    public static final String PASSWORD = "VerificationPass17";

    public SqlServerFixture() throws Exception {
        // Hibernate masks credentials returned by getProperties(); read configuration directly.
        Map<String, Object> properties = new HashMap<>();
        javax.xml.parsers.DocumentBuilderFactory parser = javax.xml.parsers.DocumentBuilderFactory.newInstance();
        parser.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        try (java.io.InputStream input = SqlServerFixture.class.getClassLoader().getResourceAsStream("META-INF/persistence.xml")) {
            org.w3c.dom.NodeList entries = parser.newDocumentBuilder().parse(input).getElementsByTagName("property");
            for (int i = 0; i < entries.getLength(); i++) {
                org.w3c.dom.Element entry = (org.w3c.dom.Element) entries.item(i);
                properties.put(entry.getAttribute("name"), entry.getAttribute("value"));
            }
        }
        for (String key : List.of("url", "user", "password")) {
            String value = System.getProperty("jakarta.persistence.jdbc." + key);
            if (value == null) value = System.getenv("EDUCENTER_DB_" + key.toUpperCase(Locale.ROOT));
            if (value != null && !value.isBlank()) properties.put("jakarta.persistence.jdbc." + key, value);
        }
        JPAUtil.close();
        properties.put("hibernate.hbm2ddl.auto", "none");
        properties.put("hibernate.show_sql", "false");
        properties.put("hibernate.connection.autocommit", "true");
        properties.put("hibernate.allow_update_outside_transaction", "true");
        adminFactory = Persistence.createEntityManagerFactory("EduCenterPU", properties);
        ddl("CREATE DATABASE [" + database + "]");
        String url = properties.get("jakarta.persistence.jdbc.url").toString();
        if (!url.toLowerCase(Locale.ROOT).contains("databasename=")) throw new IllegalStateException("SQL Server URL must specify databaseName");
        url = url.replaceAll("(?i)databaseName=[^;]+", "databaseName=" + database);
        properties.put("jakarta.persistence.jdbc.url", url);
        properties.put("hibernate.hbm2ddl.auto", "create-drop");
        properties.put("hibernate.use_nationalized_character_data", "true");
        properties.put("hibernate.connection.autocommit", "false");
        properties.put("hibernate.allow_update_outside_transaction", "false");
        factory = Persistence.createEntityManagerFactory("EduCenterPU", properties);
        java.lang.reflect.Field field = JPAUtil.class.getDeclaredField("emf"); field.setAccessible(true); field.set(null, factory);
        seed();
    }

    private void ddl(String sql) {
        EntityManager em = adminFactory.createEntityManager();
        try { em.createNativeQuery(sql).executeUpdate(); } finally { em.close(); }
    }

    private void seed() {
        EntityManager em = factory.createEntityManager();
        try {
            em.getTransaction().begin();
            Map<String, Role> roles = new HashMap<>();
            for (String code : List.of("ADMIN", "STAFF", "TEACHER", "STUDENT", "PARENT")) {
                Role role = new Role(code, code, "Verification"); em.persist(role); roles.put(code, role);
            }
            User student = account(em, roles.get("STUDENT"), "student@verification.invalid", "O'Brien <em>Học viên</em>"); studentId = student.getId();
            adminOne = account(em, roles.get("ADMIN"), "admin@verification.invalid", "Quản trị kiểm thử").getId();
            adminTwo = account(em, roles.get("ADMIN"), "other@verification.invalid", "Quản trị thứ hai").getId();
            account(em, roles.get("PARENT"), "parent@verification.invalid", "Phụ huynh kiểm thử");
            account(em, roles.get("STAFF"), "staff@verification.invalid", "Học vụ kiểm thử");
            User teacherUser = account(em, roles.get("TEACHER"), "teacher@verification.invalid", "Giáo viên kiểm thử");
            Subject subject = new Subject(); subject.setCode("VERIFY"); subject.setName("Môn kiểm thử"); subject.setStatus("ACTIVE"); em.persist(subject);
            Course first = course(em, subject, "VERIFY-ONE", 12, "1000000"); courseOne = first.getId();
            Course second = course(em, subject, "VERIFY-TWO", 9, "2000000"); courseTwo = second.getId();
            em.persist(new RegistrationCartItem(student, second, "Lựa chọn đã lưu"));
            em.createNativeQuery("CREATE TABLE dbo.SystemSettings (setting_key varchar(100) PRIMARY KEY, setting_value nvarchar(max))").executeUpdate();
            em.createNativeQuery("CREATE TABLE dbo.Rooms (id bigint PRIMARY KEY, name nvarchar(100))").executeUpdate();
            em.createNativeQuery("ALTER TABLE dbo.Classes ADD room_id bigint NULL").executeUpdate();
            em.createNativeQuery("CREATE TABLE dbo.Enrollments (class_id bigint NOT NULL, status varchar(30))").executeUpdate();
            em.createNativeQuery("CREATE TABLE dbo.ClassSessions (class_id bigint NOT NULL, session_date date, start_at time, end_at time, status varchar(30))").executeUpdate();
            em.getTransaction().commit();
        } finally { em.close(); }
    }

    private User account(EntityManager em, Role role, String email, String name) {
        User user = new User(email, PasswordUtil.hashPassword(PASSWORD), name, "ACTIVE");
        user.setPhone("0912345678"); user.getRoles().add(role); em.persist(user); em.flush(); return user;
    }
    private Course course(EntityManager em, Subject subject, String code, int grade, String fee) {
        Course course = new Course(); course.setSubject(subject); course.setCode(code); course.setName("Khóa " + code);
        course.setGradeLevel(grade); course.setFee(new java.math.BigDecimal(fee)); course.setTotalSessions(12);
        course.setDurationWeeks(6); course.setMaxCapacity(15); course.setStatus("OPEN"); course.setIsFeatured(true);
        course.setDescription("Nội dung thực tế của dữ liệu kiểm thử."); em.persist(course); em.flush(); return course;
    }

    public long count(String jpql) {
        EntityManager em = factory.createEntityManager();
        try { return em.createQuery(jpql, Long.class).getSingleResult(); } finally { em.close(); }
    }

    @Override public void close() {
        JPAUtil.close();
        if (factory.isOpen()) factory.close();
        if (!database.matches("EduCenterRepairTest_[0-9a-f]{12}")) throw new IllegalStateException("Refusing unexpected test database cleanup");
        ddl("ALTER DATABASE [" + database + "] SET SINGLE_USER WITH ROLLBACK IMMEDIATE");
        ddl("DROP DATABASE [" + database + "]"); adminFactory.close();
    }
}
