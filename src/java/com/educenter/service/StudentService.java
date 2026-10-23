package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Guardian;
import com.educenter.entity.Student;
import com.educenter.entity.User;
import java.util.List;

public interface StudentService {

    // --- Student Operations ---
    StudentStatsDTO getStudentStats();

    List<StudentAdminViewDTO> getStudents(StudentFilterDTO filter);

    long countStudents(StudentFilterDTO filter);

    StudentDetailDTO getStudentDetail(Long studentId);

    StudentFormDTO getStudentForEdit(Long studentId);

    Student saveStudent(StudentFormDTO form, Long actorId, String ipAddress);

    void updateStudentStatus(Long studentId, String newStatus, Long actorId, String ipAddress);

    void linkStudentUser(Long studentId, Long userId, Long actorId, String ipAddress);

    void unlinkStudentUser(Long studentId, Long actorId, String ipAddress);

    List<User> getAvailableStudentUsers(Long currentStudentId);

    // --- Guardian Operations ---
    List<GuardianAdminViewDTO> getGuardians(GuardianFilterDTO filter);

    long countGuardians(GuardianFilterDTO filter);

    GuardianFormDTO getGuardianForEdit(Long guardianId);

    Guardian saveGuardian(GuardianFormDTO form, Long actorId, String ipAddress);

    void updateGuardianStatus(Long guardianId, String newStatus, Long actorId, String ipAddress);

    List<User> getAvailableParentUsers(Long currentGuardianId);

    // --- Linkage & Verification (BR15) ---
    void linkGuardianToStudent(Long studentId, Long guardianId, String relationship, boolean isPrimary, Long actorId, String ipAddress);

    void unlinkGuardianFromStudent(Long linkId, Long actorId, String ipAddress);

    void verifyGuardianLink(Long linkId, String notes, Long actorId, String ipAddress);

    void revokeGuardianLink(Long linkId, String reason, Long actorId, String ipAddress);

    List<Guardian> searchAvailableGuardiansForStudent(Long studentId, String keyword);
}
