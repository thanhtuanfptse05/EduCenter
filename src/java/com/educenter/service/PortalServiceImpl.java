package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.Guardian;
import com.educenter.entity.Student;
import com.educenter.repository.PortalRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.logging.Logger;

/**
 * Implementation of PortalService providing isolated and validated data access for students and parents.
 */
public class PortalServiceImpl implements PortalService {

    private static final Logger LOGGER = Logger.getLogger(PortalServiceImpl.class.getName());

    private final PortalRepository portalRepository;
    private final Supplier<EntityManager> entityManagerSupplier;

    public PortalServiceImpl() {
        this(new PortalRepository(), JPAUtil::getEntityManager);
    }

    public PortalServiceImpl(PortalRepository portalRepository) {
        this(portalRepository, JPAUtil::getEntityManager);
    }

    public PortalServiceImpl(PortalRepository portalRepository, Supplier<EntityManager> entityManagerSupplier) {
        this.portalRepository = (portalRepository != null) ? portalRepository : new PortalRepository();
        this.entityManagerSupplier = (entityManagerSupplier != null) ? entityManagerSupplier : JPAUtil::getEntityManager;
    }

    @Override
    public StudentDashboardSummaryDTO getStudentDashboard(Long userId) {
        if (userId == null) {
            throw new ValidationException("Mã tài khoản người dùng không hợp lệ.");
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<Student> studentOpt = portalRepository.findStudentByUserId(em, userId);
            if (studentOpt.isEmpty()) {
                // Profile pending empty state
                return new StudentDashboardSummaryDTO();
            }
            return buildStudentSummary(em, studentOpt.get());
        } finally {
            em.close();
        }
    }

    @Override
    public List<PortalScheduleItemDTO> getStudentSchedule(Long userId, LocalDate fromDate, LocalDate toDate) {
        if (userId == null) {
            throw new ValidationException("Mã tài khoản người dùng không hợp lệ.");
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<Student> studentOpt = portalRepository.findStudentByUserId(em, userId);
            if (studentOpt.isEmpty()) {
                return List.of();
            }

            LocalDate start = fromDate != null ? fromDate : LocalDate.now().with(DayOfWeek.MONDAY);
            LocalDate end = toDate != null ? toDate : start.plusDays(13); // Default 2 weeks

            return portalRepository.findScheduleByStudentId(em, studentOpt.get().getId(), start, end);
        } finally {
            em.close();
        }
    }

    @Override
    public List<PortalScoreItemDTO> getStudentProgress(Long userId) {
        if (userId == null) {
            throw new ValidationException("Mã tài khoản người dùng không hợp lệ.");
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<Student> studentOpt = portalRepository.findStudentByUserId(em, userId);
            if (studentOpt.isEmpty()) {
                return List.of();
            }
            return portalRepository.findPublishedScoresByStudentId(em, studentOpt.get().getId());
        } finally {
            em.close();
        }
    }

    @Override
    public ParentDashboardSummaryDTO getParentDashboard(Long guardianUserId, Long selectedChildId) {
        if (guardianUserId == null) {
            throw new ValidationException("Mã tài khoản phụ huynh không hợp lệ.");
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            Optional<Guardian> guardianOpt = portalRepository.findGuardianByUserId(em, guardianUserId);
            ParentDashboardSummaryDTO dto = new ParentDashboardSummaryDTO();
            if (guardianOpt.isPresent()) {
                Guardian g = guardianOpt.get();
                dto.setGuardianId(g.getId());
                dto.setGuardianName(g.getFullName());
                dto.setGuardianPhone(g.getPhone());
            }

            List<ChildGuardianViewDTO> verifiedChildren = portalRepository.findVerifiedChildrenByGuardianUserId(em, guardianUserId);
            dto.setVerifiedChildren(verifiedChildren);

            if (verifiedChildren.isEmpty()) {
                return dto;
            }

            // Determine active child
            Long targetChildId = selectedChildId;
            boolean targetValid = false;
            if (targetChildId != null) {
                for (ChildGuardianViewDTO c : verifiedChildren) {
                    if (c.getId().equals(targetChildId)) {
                        targetValid = true;
                        break;
                    }
                }
            }

            if (!targetValid) {
                targetChildId = verifiedChildren.get(0).getId();
            }
            dto.setSelectedChildId(targetChildId);

            Student targetStudent = em.find(Student.class, targetChildId);
            if (targetStudent != null) {
                dto.setSelectedChildSummary(buildStudentSummary(em, targetStudent));
            }
            return dto;
        } finally {
            em.close();
        }
    }

    @Override
    public StudentDashboardSummaryDTO getChildDetail(Long guardianUserId, Long childStudentId) {
        if (guardianUserId == null || childStudentId == null) {
            throw new ValidationException("Dữ liệu tra cứu học sinh không hợp lệ.");
        }
        EntityManager em = entityManagerSupplier.get();
        try {
            boolean authorized = portalRepository.isGuardianOfStudent(em, guardianUserId, childStudentId);
            if (!authorized) {
                LOGGER.warning("Cảnh báo bảo mật: Phụ huynh UserID " + guardianUserId + " cố tình truy cập học sinh ID " + childStudentId + " không được phân quyền!");
                throw new ValidationException("Bạn không có quyền truy cập hồ sơ học sinh này hoặc quan hệ giám hộ chưa được xác minh.");
            }

            Student child = em.find(Student.class, childStudentId);
            if (child == null) {
                throw new ValidationException("Không tìm thấy thông tin học sinh.");
            }
            return buildStudentSummary(em, child);
        } finally {
            em.close();
        }
    }

    private StudentDashboardSummaryDTO buildStudentSummary(EntityManager em, Student student) {
        StudentDashboardSummaryDTO summary = new StudentDashboardSummaryDTO();
        summary.setStudentId(student.getId());
        summary.setStudentName(student.getFullName());
        summary.setStudentCode(student.getCode());
        summary.setGradeLevel(student.getGradeLevel());
        summary.setSchool(student.getSchool());

        // Enrolled classes
        List<ClassItemDTO> enrolledClasses = portalRepository.findEnrolledClassesByStudentId(em, student.getId());
        summary.setEnrolledClasses(enrolledClasses);
        summary.setEnrolledClassCount(enrolledClasses.size());

        // Upcoming schedule
        List<PortalScheduleItemDTO> upcoming = portalRepository.findUpcomingSessionsByStudentId(em, student.getId(), 5);
        summary.setUpcomingSessions(upcoming);

        // Published scores
        List<PortalScoreItemDTO> scores = portalRepository.findPublishedScoresByStudentId(em, student.getId());
        summary.setRecentScores(scores);

        // Calculate average score (B02: Normalized to 10-scale and weighted)
        if (!scores.isEmpty()) {
            BigDecimal totalWeightedScore = BigDecimal.ZERO;
            BigDecimal totalWeight = BigDecimal.ZERO;
            for (PortalScoreItemDTO s : scores) {
                if (s.getScore() != null) {
                    BigDecimal maxScore = (s.getMaxScore() != null && s.getMaxScore().compareTo(BigDecimal.ZERO) > 0)
                            ? s.getMaxScore() : BigDecimal.TEN;
                    BigDecimal weight = (s.getWeight() != null && s.getWeight().compareTo(BigDecimal.ZERO) > 0)
                            ? s.getWeight() : BigDecimal.ONE;

                    // normScore = (score / maxScore) * 10
                    BigDecimal normScore = s.getScore().divide(maxScore, 4, RoundingMode.HALF_UP).multiply(BigDecimal.TEN);
                    totalWeightedScore = totalWeightedScore.add(normScore.multiply(weight));
                    totalWeight = totalWeight.add(weight);
                }
            }
            if (totalWeight.compareTo(BigDecimal.ZERO) > 0) {
                summary.setAverageScore(totalWeightedScore.divide(totalWeight, 2, RoundingMode.HALF_UP));
            }
        }

        // Attendance stats
        PortalAttendanceSummaryDTO attendance = portalRepository.getAttendanceStatsByStudentId(em, student.getId());
        summary.setAttendanceSummary(attendance);

        return summary;
    }
}
