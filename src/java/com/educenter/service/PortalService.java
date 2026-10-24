package com.educenter.service;

import com.educenter.dto.*;
import java.time.LocalDate;
import java.util.List;

/**
 * Service managing Student and Parent Portal data workflows and strict actor authorization.
 */
public interface PortalService {

    /**
     * Retrieves student dashboard summary for the logged-in student.
     *
     * @param userId current student user ID
     * @return summary DTO, or empty state container if profile is pending
     */
    StudentDashboardSummaryDTO getStudentDashboard(Long userId);

    /**
     * Retrieves schedule / timetable for the logged-in student.
     *
     * @param userId current student user ID
     * @param fromDate start date (inclusive)
     * @param toDate end date (inclusive)
     * @return list of session DTOs
     */
    List<PortalScheduleItemDTO> getStudentSchedule(Long userId, LocalDate fromDate, LocalDate toDate);

    /**
     * Retrieves published scores and progress report for the logged-in student.
     *
     * @param userId current student user ID
     * @return list of published score DTOs
     */
    List<PortalScoreItemDTO> getStudentProgress(Long userId);

    /**
     * Retrieves parent dashboard summary for the logged-in guardian and the selected child.
     *
     * @param guardianUserId current guardian user ID
     * @param selectedChildId student ID of the selected child (optional, defaults to primary/first)
     * @return parent dashboard DTO
     */
    ParentDashboardSummaryDTO getParentDashboard(Long guardianUserId, Long selectedChildId);

    /**
     * Retrieves detailed study and progress report of a specific child for a guardian.
     * Validates active verification between guardian and student before returning data.
     *
     * @param guardianUserId current guardian user ID
     * @param childStudentId target child student ID
     * @return student summary DTO of the child
     * @throws ValidationException if access is unauthorized or relationship unverified
     */
    StudentDashboardSummaryDTO getChildDetail(Long guardianUserId, Long childStudentId);

    /**
     * Retrieves timetable / schedule of a specific child for a guardian.
     * Validates active verification between guardian and student before returning schedule.
     *
     * @param guardianUserId current guardian user ID
     * @param childStudentId target child student ID
     * @param fromDate start date (inclusive)
     * @param toDate end date (inclusive)
     * @return list of session DTOs for the child
     * @throws ValidationException if access is unauthorized or relationship unverified
     */
    List<PortalScheduleItemDTO> getChildSchedule(Long guardianUserId, Long childStudentId, LocalDate fromDate, LocalDate toDate);
}
