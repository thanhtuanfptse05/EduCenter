package com.educenter.service;

import com.educenter.dto.*;
import java.time.LocalDate;
import java.util.List;

public interface ClassTimetableService {

    // KPI thống kê
    ClassAdminStatsDTO getClassStats();

    // Quản lý phòng học
    List<RoomDTO> getAllRooms();
    List<RoomDTO> getAvailableRooms();
    RoomDTO getRoomById(Long id);
    RoomDTO createRoom(RoomFormDTO form, Long actorUserId);
    RoomDTO updateRoom(RoomFormDTO form, Long actorUserId);

    // Quản lý lớp học
    List<ClassAdminViewDTO> getClasses(ClassFilterDTO filter);
    long countClasses(ClassFilterDTO filter);
    ClassDetailDTO getClassDetail(Long id);
    ClassFormDTO getClassForm(Long id);
    Long createClass(ClassFormDTO form, Long actorUserId);
    void updateClass(ClassFormDTO form, Long actorUserId);
    void changeClassStatus(Long classId, String newStatus, Long actorUserId);

    // Lịch học & sinh lịch tự động
    List<ClassSessionDTO> getClassSessions(Long classId);
    int generateSchedule(ScheduleGeneratorDTO dto, Long actorUserId);
    TimetableGridDTO getTimetableWeek(LocalDate weekStartDate);
}
