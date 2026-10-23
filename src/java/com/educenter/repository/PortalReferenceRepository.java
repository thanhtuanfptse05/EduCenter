package com.educenter.repository;

import jakarta.persistence.EntityManager;
import java.util.LinkedHashMap;
import java.util.Map;

public class PortalReferenceRepository {
    public Map<String, String> findContactSettings(EntityManager em) {
        Map<String, String> result = new LinkedHashMap<>();
        for (Object value : em.createNativeQuery("SELECT setting_key, setting_value FROM dbo.SystemSettings "
                + "WHERE setting_key IN ('center_name','center_address','center_phone','center_email',"
                + "'contact_address','contact_phone','contact_email','hotline','address','email')").getResultList()) {
            Object[] row = (Object[]) value;
            result.put(row[0].toString(), row[1].toString());
        }
        return result;
    }
}
