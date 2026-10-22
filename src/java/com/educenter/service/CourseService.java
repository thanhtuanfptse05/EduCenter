package com.educenter.service;

import com.educenter.dto.CourseDetailDTO;
import com.educenter.dto.CourseFilterDTO;
import com.educenter.dto.CoursePageDTO;
import com.educenter.dto.SubjectCardDTO;
import java.util.List;

public interface CourseService {

    /**
     * Retrieve paginated and filtered course catalog list with metadata.
     */
    CoursePageDTO getCourseCatalog(CourseFilterDTO filter);

    /**
     * Retrieve detailed course information, open classes and related suggestions.
     */
    CourseDetailDTO getCourseDetail(Long courseId);

    /**
     * Retrieve active academic subjects with course count for catalog filters.
     */
    List<SubjectCardDTO> getActiveSubjects();
}
