package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Subject;
import java.util.List;

public interface AcademicProgramService {

    // === Subject Management (M04 / UC11 / ADM-05) ===

    List<SubjectAdminViewDTO> getSubjectAdminList();

    SubjectFormDTO getSubjectForm(Long id);

    void saveSubject(SubjectFormDTO dto, Long actorId, String actorEmail, String ipAddress);

    void toggleSubjectStatus(Long subjectId, Long actorId, String actorEmail, String ipAddress);

    List<Subject> getActiveSubjects();

    // === Course Management (M04 / UC11 / ADM-04, ADM-05) ===

    List<CourseAdminViewDTO> getCourseAdminList(CourseFilterDTO filter);

    long countCourseAdminList(CourseFilterDTO filter);

    CourseAdminStatsDTO getCourseAdminStats();

    CourseFormDTO getCourseForm(Long id);

    void saveCourse(CourseFormDTO dto, Long actorId, String actorEmail, String ipAddress);

    void updateCourseStatus(Long courseId, String newStatus, Long actorId, String actorEmail, String ipAddress);
}
