package com.educenter.service;

import com.educenter.dto.AttendanceRosterItemDTO;
import com.educenter.dto.AttendanceSessionViewDTO;
import com.educenter.dto.TeachingJournalDTO;
import java.time.LocalDate;
import java.util.List;

public interface AttendanceService {

    /**
     * Lấy danh sách các buổi học mà giáo viên phụ trách (hoặc tất cả nếu là Admin).
     */
    List<AttendanceSessionViewDTO> getTeacherSessions(Long teacherUserId, LocalDate sessionDate, boolean isAdmin);

    /**
     * Lấy chi tiết buổi học và roster danh sách học viên để điểm danh.
     */
    AttendanceSessionViewDTO getSessionAttendance(Long sessionId, Long teacherUserId, boolean isAdmin);

    /**
     * Lưu kết quả điểm danh cho danh sách học viên.
     */
    void saveAttendance(Long sessionId, List<AttendanceRosterItemDTO> rosterItems, Long actorUserId, boolean isAdmin);

    /**
     * Chốt hoàn tất điểm danh và kết thúc buổi học (chuyển sang COMPLETED).
     */
    void completeSessionAttendance(Long sessionId, Long actorUserId, boolean isAdmin);

    /**
     * Lấy nhật ký giảng dạy của buổi học.
     */
    TeachingJournalDTO getTeachingJournal(Long sessionId, Long teacherUserId, boolean isAdmin);

    /**
     * Lưu nhật ký giảng dạy (nội dung, bài tập, nhận xét).
     */
    void saveTeachingJournal(Long sessionId, String content, String homework, String remarks, Long actorUserId, boolean isAdmin);
}
