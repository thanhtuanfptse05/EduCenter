package com.educenter.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class managing the application-wide JPA EntityManagerFactory.
 * Handles thread-safe lazy/eager initialization and clean shutdown.
 */
public final class JPAUtil {

    private static final Logger LOGGER = Logger.getLogger(JPAUtil.class.getName());
    private static final String PERSISTENCE_UNIT_NAME = "EduCenterPU";
    private static volatile EntityManagerFactory emf;

    private JPAUtil() {
        // Prevent instantiation
    }

    /**
     * Retrieves the singleton EntityManagerFactory.
     *
     * @return initialized EntityManagerFactory
     */
    public static EntityManagerFactory getEntityManagerFactory() {
        if (emf == null) {
            synchronized (JPAUtil.class) {
                if (emf == null) {
                    try {
                        LOGGER.info("Khởi tạo EntityManagerFactory cho persistence unit: " + PERSISTENCE_UNIT_NAME);
                        emf = Persistence.createEntityManagerFactory(PERSISTENCE_UNIT_NAME);
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Lỗi khởi tạo EntityManagerFactory: " + e.getMessage(), e);
                        throw new ExceptionInInitializerError("Không thể kết nối CSDL hoặc khởi tạo JPA: " + e.getMessage());
                    }
                }
            }
        }
        return emf;
    }

    /**
     * Creates a new EntityManager from the factory.
     *
     * @return newly created EntityManager
     */
    public static EntityManager getEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    /**
     * Safely closes the EntityManagerFactory upon application shutdown.
     */
    public static void close() {
        synchronized (JPAUtil.class) {
            if (emf != null && emf.isOpen()) {
                LOGGER.info("Đóng EntityManagerFactory");
                emf.close();
                emf = null;
            }
        }
    }
}
