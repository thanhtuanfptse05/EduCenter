package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Teacher;
import java.util.List;

public interface TeacherManagementService {

    TeacherAdminStatsDTO getAdminStats();

    List<TeacherAdminViewDTO> getTeachers(TeacherFilterDTO filter);

    long countTeachers(TeacherFilterDTO filter);

    List<AvailableTeacherUserDTO> getAvailableTeacherUsers();

    TeacherFormDTO getTeacherForEdit(Long id);

    Teacher saveTeacher(TeacherFormDTO form, Long actorId, String ipAddress);

    void updateStatus(Long teacherId, String newStatus, Long actorId, String ipAddress);
}
