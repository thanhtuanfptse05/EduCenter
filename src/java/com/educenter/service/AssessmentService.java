package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.EduClass;
import java.util.List;

public interface AssessmentService {

    List<EduClass> getTeacherClasses(Long teacherUserId, boolean isAdmin);

    List<AssessmentListItemDTO> getAssessments(Long teacherUserId, boolean isAdmin, Long classId, String status);

    AssessmentGradeViewDTO getGradeView(Long assessmentId, Long teacherUserId, boolean isAdmin);

    Long createAssessment(AssessmentFormDTO form, Long teacherUserId, boolean isAdmin);

    void saveScores(Long assessmentId, List<StudentScoreItemDTO> scoreItems, Long teacherUserId, boolean isAdmin);

    void publishAssessment(Long assessmentId, Long teacherUserId, boolean isAdmin);

    void reopenAssessment(Long assessmentId, Long actorUserId, boolean isAdmin, String reason);
}
