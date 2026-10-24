package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.AssessmentRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AssessmentServiceImpl implements AssessmentService {

    private static final Logger LOGGER = Logger.getLogger(AssessmentServiceImpl.class.getName());

    private final AssessmentRepository assessmentRepository;

    public AssessmentServiceImpl() {
        this.assessmentRepository = new AssessmentRepository();
    }

    public AssessmentServiceImpl(AssessmentRepository repository) {
        this.assessmentRepository = repository;
    }

    protected EntityManager getEntityManager() {
        return JPAUtil.getEntityManager();
    }

    @Override
    public List<EduClass> getTeacherClasses(Long teacherUserId, boolean isAdmin) {
        EntityManager em = getEntityManager();
        try {
            return assessmentRepository.findClassesByTeacher(em, teacherUserId, isAdmin);
        } finally {
            em.close();
        }
    }

    @Override
    public List<AssessmentListItemDTO> getAssessments(Long teacherUserId, boolean isAdmin, Long classId, String status) {
        EntityManager em = getEntityManager();
        try {
            return assessmentRepository.findAssessments(em, teacherUserId, isAdmin, classId, status);
        } finally {
            em.close();
        }
    }

    @Override
    public AssessmentGradeViewDTO getGradeView(Long assessmentId, Long teacherUserId, boolean isAdmin) {
        if (assessmentId == null || assessmentId <= 0) {
            throw new ValidationException("Mã bài kiểm tra không hợp lệ.");
        }

        EntityManager em = getEntityManager();
        try {
            Assessment a = assessmentRepository.findAssessmentById(em, assessmentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy bài kiểm tra ID: " + assessmentId));

            checkTeacherPermission(a.getEduClass(), teacherUserId, isAdmin);

            List<Student> students = assessmentRepository.findActiveStudentsInClass(em, a.getEduClass().getId());
            List<AssessmentScore> existingScores = assessmentRepository.findScoresByAssessmentId(em, assessmentId);

            Map<Long, AssessmentScore> scoreMap = new HashMap<>();
            for (AssessmentScore s : existingScores) {
                scoreMap.put(s.getStudent().getId(), s);
            }

            List<StudentScoreItemDTO> studentItems = new ArrayList<>();
            BigDecimal sum = BigDecimal.ZERO;
            int countGraded = 0;

            for (Student st : students) {
                StudentScoreItemDTO item = new StudentScoreItemDTO();
                item.setStudentId(st.getId());
                item.setStudentCode(st.getCode());
                item.setStudentName(st.getFullName());
                item.setStudentPhone(st.getPhone());

                AssessmentScore score = scoreMap.get(st.getId());
                if (score != null) {
                    item.setScoreId(score.getId());
                    item.setScore(score.getScore());
                    item.setRemarks(score.getRemarks());
                    sum = sum.add(score.getScore());
                    countGraded++;
                }
                studentItems.add(item);
            }

            AssessmentGradeViewDTO dto = new AssessmentGradeViewDTO();
            dto.setAssessmentId(a.getId());
            dto.setTitle(a.getTitle());
            dto.setAssessmentType(a.getAssessmentType());
            dto.setMaxScore(a.getMaxScore());
            dto.setWeight(a.getWeight());
            dto.setTestDate(a.getTestDate());
            dto.setStatus(a.getStatus());

            dto.setClassId(a.getEduClass().getId());
            dto.setClassCode(a.getEduClass().getCode());
            dto.setClassName(a.getEduClass().getName());
            if (a.getEduClass().getCourse() != null && a.getEduClass().getCourse().getSubject() != null) {
                dto.setSubjectName(a.getEduClass().getCourse().getSubject().getName());
            }

            dto.setStudents(studentItems);
            dto.setTotalStudents(students.size());
            dto.setGradedCount(countGraded);
            if (countGraded > 0) {
                dto.setAverageScore(sum.divide(BigDecimal.valueOf(countGraded), 2, RoundingMode.HALF_UP));
            }

            return dto;
        } finally {
            em.close();
        }
    }

    @Override
    public Long createAssessment(AssessmentFormDTO form, Long teacherUserId, boolean isAdmin) {
        if (form == null || form.getClassId() == null) {
            throw new ValidationException("Thông tin bài kiểm tra không hợp lệ.");
        }
        if (form.getTitle() == null || form.getTitle().trim().length() < 3 || form.getTitle().trim().length() > 200) {
            throw new ValidationException("Tiêu đề bài kiểm tra phải từ 3 đến 200 ký tự.");
        }
        if (form.getMaxScore() == null || form.getMaxScore().compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException("Thang điểm tối đa (max_score) phải lớn hơn 0 (BR09).");
        }
        if (form.getWeight() == null || form.getWeight().compareTo(BigDecimal.ZERO) <= 0) {
            throw new ValidationException("Trọng số bài kiểm tra (weight) phải lớn hơn 0 (BR09).");
        }
        if (form.getTestDate() == null) {
            form.setTestDate(LocalDate.now());
        }

        String type = form.getAssessmentType();
        if (type == null || type.isBlank()) {
            type = "15_MIN";
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            EduClass eduClass = em.find(EduClass.class, form.getClassId());
            if (eduClass == null) {
                throw new ValidationException("Không tìm thấy lớp học có ID: " + form.getClassId());
            }

            checkTeacherPermission(eduClass, teacherUserId, isAdmin);

            Assessment assessment = new Assessment();
            assessment.setEduClass(eduClass);
            assessment.setTitle(form.getTitle().trim());
            assessment.setAssessmentType(type.toUpperCase());
            assessment.setMaxScore(form.getMaxScore());
            assessment.setWeight(form.getWeight());
            assessment.setTestDate(form.getTestDate());
            assessment.setStatus("DRAFT");
            assessment.setCreatedAt(LocalDateTime.now());
            assessment.setUpdatedAt(LocalDateTime.now());

            assessmentRepository.saveAssessment(em, assessment);

            tx.commit();
            LOGGER.info("Tạo bài kiểm tra thành công: " + assessment.getTitle() + " cho lớp " + eduClass.getCode());
            return assessment.getId();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi tạo bài kiểm tra: " + e.getMessage(), e);
            throw new ValidationException("Không thể tạo bài kiểm tra: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public void saveScores(Long assessmentId, List<StudentScoreItemDTO> scoreItems, Long teacherUserId, boolean isAdmin) {
        if (assessmentId == null || assessmentId <= 0) {
            throw new ValidationException("Mã bài kiểm tra không hợp lệ.");
        }
        if (scoreItems == null) {
            return;
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Assessment a = assessmentRepository.findAssessmentById(em, assessmentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy bài kiểm tra ID: " + assessmentId));

            checkTeacherPermission(a.getEduClass(), teacherUserId, isAdmin);

            boolean wasPublished = "PUBLISHED".equals(a.getStatus());
            a.setUpdatedAt(LocalDateTime.now());
            assessmentRepository.updateAssessment(em, a);

            // B01: Lấy danh sách học viên hợp lệ thuộc lớp học
            List<Student> classStudents = assessmentRepository.findActiveStudentsInClass(em, a.getEduClass().getId());
            Set<Long> validStudentIds = new HashSet<>();
            for (Student st : classStudents) {
                validStudentIds.add(st.getId());
            }

            User grader = em.find(User.class, teacherUserId);

            for (StudentScoreItemDTO item : scoreItems) {
                if (item.getStudentId() == null) continue;

                // B01: Chặn nếu học viên gửi lên không thuộc lớp
                if (!validStudentIds.contains(item.getStudentId())) {
                    throw new ValidationException("Học viên (ID: " + item.getStudentId() + ") không thuộc danh sách lớp học " + a.getEduClass().getCode() + "!");
                }

                Optional<AssessmentScore> opt = assessmentRepository.findScore(em, assessmentId, item.getStudentId());

                if (item.getScore() != null) {
                    if (item.getScore().compareTo(BigDecimal.ZERO) < 0 || item.getScore().compareTo(a.getMaxScore()) > 0) {
                        throw new ValidationException("Điểm số của học viên (Mã ID: " + item.getStudentId() + ") phải từ 0 đến " + a.getMaxScore() + " (BR09).");
                    }

                    Student st = em.find(Student.class, item.getStudentId());
                    if (st == null) continue;

                    if (opt.isPresent()) {
                        AssessmentScore existing = opt.get();
                        existing.setScore(item.getScore());
                        existing.setRemarks(item.getRemarks());
                        existing.setGradedBy(grader);
                        existing.setGradedAt(LocalDateTime.now());
                        assessmentRepository.updateScore(em, existing);
                    } else {
                        AssessmentScore newScore = new AssessmentScore();
                        newScore.setAssessment(a);
                        newScore.setStudent(st);
                        newScore.setScore(item.getScore());
                        newScore.setRemarks(item.getRemarks());
                        newScore.setGradedBy(grader);
                        newScore.setGradedAt(LocalDateTime.now());
                        assessmentRepository.saveScore(em, newScore);
                    }
                } else {
                    // B03: Xóa điểm khi người dùng xóa trắng ô điểm
                    if (opt.isPresent()) {
                        assessmentRepository.deleteScore(em, opt.get());
                    }
                }
            }

            a.setUpdatedAt(LocalDateTime.now());
            assessmentRepository.updateAssessment(em, a);

            tx.commit();
            LOGGER.info("Lưu bảng điểm thành công cho bài kiểm tra: " + a.getTitle());
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi lưu bảng điểm: " + e.getMessage(), e);
            throw new ValidationException("Lỗi lưu điểm: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public void publishAssessment(Long assessmentId, Long teacherUserId, boolean isAdmin) {
        if (assessmentId == null || assessmentId <= 0) {
            throw new ValidationException("Mã bài kiểm tra không hợp lệ.");
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Assessment a = assessmentRepository.findAssessmentById(em, assessmentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy bài kiểm tra ID: " + assessmentId));

            checkTeacherPermission(a.getEduClass(), teacherUserId, isAdmin);

            List<AssessmentScore> scores = assessmentRepository.findScoresByAssessmentId(em, assessmentId);
            if (scores == null || scores.isEmpty()) {
                throw new ValidationException("Không thể công bố bài kiểm tra chưa có bất kỳ điểm số nào (BR11).");
            }

            a.setStatus("PUBLISHED");
            a.setUpdatedAt(LocalDateTime.now());
            assessmentRepository.updateAssessment(em, a);

            // B12: Ghi nhận Audit Log nghiệp vụ khi công bố điểm
            AuditLog audit = new AuditLog(teacherUserId, "PUBLISH_ASSESSMENT", "Assessment", a.getId(),
                    "{\"status\":\"DRAFT\"}",
                    "{\"status\":\"PUBLISHED\",\"scoresCount\":" + scores.size() + "}",
                    null);
            em.persist(audit);

            tx.commit();
            LOGGER.info("Công bố bài kiểm tra thành công: " + a.getTitle());
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi công bố điểm: " + e.getMessage(), e);
            throw new ValidationException("Không thể công bố điểm: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    @Override
    public void reopenAssessment(Long assessmentId, Long actorUserId, boolean isAdmin, String reason) {
        if (!isAdmin) {
            throw new ValidationException("Chỉ quản trị viên (Admin) mới có quyền mở lại bài kiểm tra đã công bố.");
        }
        if (reason == null || reason.trim().length() < 3) {
            throw new ValidationException("Vui lòng nhập lý do mở lại bài kiểm tra (tối thiểu 3 ký tự).");
        }

        EntityManager em = getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Assessment a = assessmentRepository.findAssessmentById(em, assessmentId)
                    .orElseThrow(() -> new ValidationException("Không tìm thấy bài kiểm tra ID: " + assessmentId));

            checkTeacherPermission(a.getEduClass(), actorUserId, isAdmin);

            a.setStatus("DRAFT");
            a.setUpdatedAt(LocalDateTime.now());
            assessmentRepository.updateAssessment(em, a);

            // B12: Ghi nhận Audit Log nghiệp vụ khi mở lại bài kiểm tra (BR18)
            String sanitizedReason = reason.replace("\"", "\\\"").trim();
            AuditLog audit = new AuditLog(actorUserId, "REOPEN_ASSESSMENT", "Assessment", a.getId(),
                    "{\"status\":\"PUBLISHED\"}",
                    "{\"status\":\"DRAFT\",\"reason\":\"" + sanitizedReason + "\"}",
                    null);
            em.persist(audit);

            tx.commit();
            LOGGER.info("Admin mở lại bài kiểm tra " + a.getTitle() + " sang DRAFT với lý do: " + reason);
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            if (e instanceof ValidationException) throw (ValidationException) e;
            LOGGER.log(Level.SEVERE, "Lỗi mở lại bài kiểm tra: " + e.getMessage(), e);
            throw new ValidationException("Không thể mở lại bài kiểm tra: " + e.getMessage());
        } finally {
            em.close();
        }
    }

    private void checkTeacherPermission(EduClass eduClass, Long teacherUserId, boolean isAdmin) {
        if (isAdmin || teacherUserId == null) {
            return;
        }
        if (eduClass.getTeacher() == null || eduClass.getTeacher().getUser() == null
                || !eduClass.getTeacher().getUser().getId().equals(teacherUserId)) {
            throw new ValidationException("Bạn không được phân công phụ trách giảng dạy lớp " + eduClass.getCode() + " (BR18).");
        }
    }
}
