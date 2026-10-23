package com.educenter.service;

import com.educenter.dto.SubjectCardDTO;
import com.educenter.entity.Subject;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.PortalReferenceRepository;
import com.educenter.repository.SubjectRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/** Reference data for a single request, always loaded through repositories. */
public class PortalReferenceService {
    public record Data(List<SubjectCardDTO> subjects, List<Integer> grades, Map<String, String> contact) { }

    public Data getData() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            List<SubjectCardDTO> subjects = new ArrayList<>();
            for (Subject subject : new SubjectRepository().findAllActive(em)) {
                SubjectCardDTO dto = new SubjectCardDTO();
                dto.setId(subject.getId()); dto.setCode(subject.getCode()); dto.setName(subject.getName());
                subjects.add(dto);
            }
            return new Data(subjects, new CourseRepository().findAvailableGrades(em),
                    new PortalReferenceRepository().findContactSettings(em));
        } finally { em.close(); }
    }
}
