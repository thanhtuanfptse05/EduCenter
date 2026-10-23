package com.educenter.service;

import com.educenter.dto.ClassEnrollmentOptionDTO;
import com.educenter.dto.EnrollmentFormDTO;
import com.educenter.dto.EnrollmentPageDTO;
import com.educenter.dto.EnrollmentViewDTO;
import com.educenter.entity.Student;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface EnrollmentService {

    /**
     * Tra cứu danh sách ghi danh phân trang kèm bộ lọc và các số liệu KPI.
     */
    EnrollmentPageDTO getEnrollmentsPaged(Long classId, String status, String keyword, int page, int pageSize);

    /**
     * Ghi danh học sinh vào lớp học (P0).
     * Ràng buộc BR02, BR03, BR04, BR07, BR12, FR-005:
     * - Lớp OPEN/ONGOING, ngày bắt đầu trong kỳ lớp.
     * - Chặn trùng lặp Enrollment ACTIVE/RESERVED trong cùng lớp.
     * - Kiểm soát sĩ số tối đa (capacity).
     * - Kiểm tra xung đột thời khóa biểu buổi học tương lai.
     * - Tạo Enrollment ACTIVE và sinh Invoice ban đầu UNPAID đồng thời trong một transaction.
     */
    EnrollmentViewDTO enrollStudent(EnrollmentFormDTO form, Long actorId);

    /**
     * Chuyển lớp cho học sinh (P1).
     * Đổi trạng thái Enrollment cũ sang TRANSFERRED, tạo Enrollment mới ACTIVE ở lớp đích.
     */
    void transferClass(Long enrollmentId, Long newClassId, LocalDate transferDate, String notes, Long actorId);

    /**
     * Bảo lưu học tập (P1).
     * Đổi trạng thái Enrollment sang RESERVED, giải phóng chỗ học trong lớp.
     */
    void reserveEnrollment(Long enrollmentId, String reason, Long actorId);

    /**
     * Phục hồi học tập sau bảo lưu (P1).
     * Kiểm tra lớp còn chỗ không, nếu còn chỗ đổi RESERVED -> ACTIVE.
     */
    void resumeEnrollment(Long enrollmentId, Long actorId);

    /**
     * Cập nhật trạng thái thôi học (DROPPED) hoặc hoàn thành (COMPLETED).
     */
    void updateEnrollmentStatus(Long enrollmentId, String newStatus, String reason, Long actorId);

    /**
     * Lấy chi tiết một ghi danh theo ID.
     */
    Optional<EnrollmentViewDTO> getEnrollmentById(Long id);

    /**
     * Danh sách lớp học mở cho form ghi danh.
     */
    List<ClassEnrollmentOptionDTO> getOpenClassOptions();

    /**
     * Danh sách học sinh hợp lệ cho form ghi danh.
     */
    List<Student> getActiveStudents();
}
