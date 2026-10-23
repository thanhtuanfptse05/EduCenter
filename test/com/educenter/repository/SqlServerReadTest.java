package com.educenter.repository;

import com.educenter.service.LandingServiceImpl;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/** Read-only smoke test of operational projections against the configured SQL Server schema. */
@Tag("sqlserver")
class SqlServerReadTest {
    @Test void academicProjectionsUseTheActualSchema() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            var repository = new CourseRepository();
            var ids = em.createQuery("SELECT c.id FROM EduClass c ORDER BY c.id", Long.class).getResultList();
            if (ids.isEmpty()) {
                assertThrows(NoResultException.class, () -> repository.findClassFacts(em, -1L));
            } else {
                for (Long id : ids) assertTrue(repository.findClassFacts(em, id).enrolledCount() >= 0);
            }
            assertNotNull(repository.findAvailableGrades(em));
            var portal = new LandingServiceImpl().getLandingPortalData();
            assertTrue(portal.getOpenClassesCount() >= 0);
            assertTrue(portal.getTotalStudents() >= 0);
            System.out.println("Read-only academic projections checked: " + ids.size() + " classes.");
        } finally { em.close(); JPAUtil.close(); }
    }
}
