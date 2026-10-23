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
        try {
            TypedQuery<SystemSetting> query = em.createQuery(
                    "SELECT s FROM SystemSetting s WHERE s.settingKey = :key",
                    SystemSetting.class
            );
            if (query == null) {
                return Optional.empty();
            }
            query.setParameter("key", key.trim());
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    public String getValueByKey(EntityManager em, String key) {
        return findByKey(em, key).map(SystemSetting::getSettingValue).orElse(null);
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
