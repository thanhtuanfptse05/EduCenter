package com.educenter.service;

import com.educenter.dto.LandingDataDTO;
import com.educenter.dto.LeadFormDTO;
import com.educenter.entity.Lead;

public interface LandingService {

    /**
     * Retrieve all real-world database metrics, featured courses, faculty teachers,
     * and subject statistics for the public landing portal.
     */
    LandingDataDTO getLandingPortalData();

    /**
     * Process and persist CRM consultation lead from public landing form.
     */
    Lead registerLead(LeadFormDTO form);
}
