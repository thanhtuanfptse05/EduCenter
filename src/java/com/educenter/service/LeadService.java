package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Lead;
import java.util.Map;

public interface LeadService {

    Map<String, Object> getLeadListPage(LeadFilterDTO filter);

    LeadDetailDTO getLeadDetail(Long leadId);

    Lead createLead(LeadCreateFormDTO form, UserPrincipalDTO creator);

    void updateLeadStatus(Long leadId, String newStatus, String notes, Long assignedToId, UserPrincipalDTO actor);

    void addConsultation(ConsultationFormDTO form, UserPrincipalDTO staff);

    Map<String, Long> getLeadStats();
}
