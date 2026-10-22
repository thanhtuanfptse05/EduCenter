package com.educenter.util;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Kiểm tra kết nối JPA & SQL Server")
class JPAConnectionTest {

    @AfterAll
    static void tearDown() {
        JPAUtil.close();
    }

    @Test
    @DisplayName("Kết nối thành công tới SQL Server EduCenterDB với tài khoản sa/123")
    void testDatabaseConnectionAndQuery() {
        assertDoesNotThrow(() -> {
            EntityManager em = JPAUtil.getEntityManager();
            assertNotNull(em, "EntityManager không được null");
            assertTrue(em.isOpen(), "EntityManager phải ở trạng thái mở");

            try {
                Long roleCount = em.createQuery("SELECT COUNT(r) FROM Role r", Long.class).getSingleResult();
                Long userCount = em.createQuery("SELECT COUNT(u) FROM User u", Long.class).getSingleResult();
                Long courseCount = em.createQuery("SELECT COUNT(c) FROM Course c", Long.class).getSingleResult();

                System.out.println("=== KẾT NỐI DB THÀNH CÔNG ===");
                System.out.println("Số lượng Vai trò (Roles): " + roleCount);
                System.out.println("Số lượng Người dùng (Users): " + userCount);
                System.out.println("Số lượng Khóa học (Courses): " + courseCount);

                assertTrue(roleCount >= 0);
                assertTrue(userCount >= 0);
                assertTrue(courseCount >= 0);
            } finally {
                em.close();
            }
        });
    }
}
