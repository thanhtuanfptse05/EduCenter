package com.educenter.listener;

import com.educenter.util.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

/**
 * Lifecycle listener ensuring JPA EntityManagerFactory and database connection pools
 * are cleanly closed on application shutdown to prevent memory leaks.
 */
@WebListener
public class ApplicationLifecycle implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(ApplicationLifecycle.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("EduCenter Web Application initialized successfully.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("EduCenter Web Application shutting down. Closing JPA resources.");
        JPAUtil.close();
    }
}
