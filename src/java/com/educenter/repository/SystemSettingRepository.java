package com.educenter.repository;

import com.educenter.entity.SystemSetting;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

/**
 * JPA Repository for SystemSetting entity (M12).
 */
public class SystemSettingRepository {

    public Optional<SystemSetting> findByKey(EntityManager em, String key) {
        if (key == null || key.trim().isEmpty()) {
            return Optional.empty();
        }
        TypedQuery<SystemSetting> query = em.createQuery(
                "SELECT s FROM SystemSetting s WHERE s.settingKey = :key",
                SystemSetting.class
        );
        query.setParameter("key", key.trim());
        try {
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public List<SystemSetting> findAll(EntityManager em) {
        return em.createQuery("SELECT s FROM SystemSetting s ORDER BY s.settingKey ASC", SystemSetting.class)
                .getResultList();
    }

    public void save(EntityManager em, SystemSetting setting) {
        em.persist(setting);
    }

    public SystemSetting update(EntityManager em, SystemSetting setting) {
        return em.merge(setting);
    }
}
