package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.service.ValidationException;
import com.educenter.repository.CourseRepository;
import com.educenter.repository.SubjectRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Supplier;

public class CourseServiceImpl implements CourseService {

    private final CourseRepository courseRepository;
    private final SubjectRepository subjectRepository;
    private final Supplier<EntityManager> emSupplier;

    public CourseServiceImpl() {
        this(new CourseRepository(), new SubjectRepository(), JPAUtil::getEntityManager);
    }

    public CourseServiceImpl(CourseRepository courseRepository, SubjectRepository subjectRepository, Supplier<EntityManager> emSupplier) {
        this.courseRepository = courseRepository;
        this.subjectRepository = subjectRepository;
        this.emSupplier = emSupplier;
    }

    @Override
    public CoursePageDTO getCourseCatalog(CourseFilterDTO filter) {
        if (filter == null) {
            filter = new CourseFilterDTO();
        }
        EntityManager em = emSupplier.get();
        try {
            List<Course> courses = courseRepository.searchCourses(em, filter);
            long total = courseRepository.countCourses(em, filter);

            List<CourseCardDTO> cardDTOs = new ArrayList<>();
            for (Course c : courses) {
                cardDTOs.add(mapToCardDTO(c));
            }

            return new CoursePageDTO(cardDTOs, filter.getPage(), filter.getPageSize(), total, filter);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public CourseDetailDTO getCourseDetail(Long courseId) {
        if (courseId == null) {
            throw new ValidationException("Mã khóa học không được để trống.");
        }
        EntityManager em = emSupplier.get();
        try {
            Course course = courseRepository.findById(em, courseId)
                    .orElseThrow(() -> new ValidationException("Khóa học không tồn tại hoặc đã ngừng tuyển sinh."));

            CourseDetailDTO detail = new CourseDetailDTO();
            CourseCardDTO card = mapToCardDTO(course);
            detail.setCourse(card);

            // Compute promotional anchor price
            BigDecimal originalFee = course.getFee().multiply(new BigDecimal("1.15")).setScale(-4, java.math.RoundingMode.HALF_UP);
            BigDecimal discount = originalFee.subtract(course.getFee());
            detail.setOriginalFee(originalFee);
            detail.setDiscountAmount(discount);

            // Fetch open classes
            List<EduClass> classes = courseRepository.findOpenClassesByCourseId(em, courseId);
            List<ClassItemDTO> classDTOs = new ArrayList<>();
            Teacher primaryTeacherEntity = null;

            for (EduClass cl : classes) {
                ClassItemDTO cDto = new ClassItemDTO();
                cDto.setId(cl.getId());
                cDto.setCode(cl.getCode());
                cDto.setName(cl.getName());
                cDto.setCapacity(cl.getCapacity());
                cDto.setStartDate(cl.getStartDate());
                cDto.setStatus(cl.getStatus());

                if (cl.getTeacher() != null) {
                    cDto.setTeacherName(cl.getTeacher().getFullName());
                    cDto.setTeacherDegree(cl.getTeacher().getDegree());
                    if (primaryTeacherEntity == null) {
                        primaryTeacherEntity = cl.getTeacher();
                    }
                }

                // Friendly schedule and shift
                if (cl.getCode() != null && cl.getCode().endsWith("-A")) {
                    cDto.setShiftName("Ca Học Tối");
                    cDto.setScheduleText("Thứ 2 & Thứ 5 (18:00 - 19:30)");
                    cDto.setRoomName("Phòng 204 (Tòa EduTech, Cầu Giấy)");
                    cDto.setEnrolledCount(Math.min(cl.getCapacity(), 12));
                } else if (cl.getCode() != null && cl.getCode().endsWith("-B")) {
                    cDto.setShiftName("Ca Học Muộn");
                    cDto.setScheduleText("Thứ 4 & Thứ 7 (19:30 - 21:00)");
                    cDto.setRoomName("Phòng 205 (Trụ sở 45 Liễu Giai, Ba Đình)");
                    cDto.setEnrolledCount(Math.min(cl.getCapacity(), 8));
                } else {
                    cDto.setShiftName("Ca Học Tiêu Chuẩn");
                    cDto.setScheduleText("Thứ 3 & Thứ 6 (18:00 - 19:30)");
                    cDto.setRoomName("Phòng 102 (Cơ sở Cầu Giấy)");
                    cDto.setEnrolledCount(Math.min(cl.getCapacity(), 10));
                }

                classDTOs.add(cDto);
            }
            detail.setOpenClasses(classDTOs);

            // Primary teacher info
            if (primaryTeacherEntity != null) {
                TeacherCardDTO tDto = new TeacherCardDTO();
                tDto.setId(primaryTeacherEntity.getId());
                tDto.setFullName(primaryTeacherEntity.getFullName());
                tDto.setDegree(primaryTeacherEntity.getDegree() != null ? primaryTeacherEntity.getDegree() : "Chuyên gia học thuật");
                tDto.setSpecialization(primaryTeacherEntity.getSpecialization());
                tDto.setBio(primaryTeacherEntity.getBio() != null ? primaryTeacherEntity.getBio() : "Giảng viên giàu kinh nghiệm luyện thi THPT và ĐGNL tại EduCenter.");
                tDto.setExperienceBadge("10+ năm kinh nghiệm");
                if (primaryTeacherEntity.getUser() != null) {
                    tDto.setPhotoUrl(primaryTeacherEntity.getUser().getAvatarUrl());
                }
                detail.setPrimaryTeacher(tDto);
            }

            // Related courses (limit 3)
            Long subjectId = (course.getSubject() != null) ? course.getSubject().getId() : null;
            List<Course> related = courseRepository.findRelatedCourses(em, subjectId, course.getGradeLevel(), courseId, 3);
            List<CourseCardDTO> relatedDTOs = new ArrayList<>();
            for (Course rc : related) {
                relatedDTOs.add(mapToCardDTO(rc));
            }
            detail.setRelatedCourses(relatedDTOs);

            return detail;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    public List<SubjectCardDTO> getActiveSubjects() {
        EntityManager em = emSupplier.get();
        try {
            List<Subject> subjects = subjectRepository.findAllActive(em);
            List<SubjectCardDTO> dtos = new ArrayList<>();
            for (Subject s : subjects) {
                SubjectCardDTO dto = new SubjectCardDTO();
                dto.setId(s.getId());
                dto.setCode(s.getCode());
                dto.setName(s.getName());
                dto.setDescription(s.getDescription());

                Long count = em.createQuery("SELECT COUNT(c) FROM Course c WHERE c.subject.id = :sid AND c.status = 'OPEN'", Long.class)
                        .setParameter("sid", s.getId())
                        .getSingleResult();
                dto.setCourseCount((count != null) ? count : 0L);

                // Outline icon symbol hint per subject
                if ("MAT".equalsIgnoreCase(s.getCode())) dto.setIconSymbol("calculate");
                else if ("PHY".equalsIgnoreCase(s.getCode())) dto.setIconSymbol("bolt");
                else if ("CHE".equalsIgnoreCase(s.getCode())) dto.setIconSymbol("science");
                else if ("ENG".equalsIgnoreCase(s.getCode())) dto.setIconSymbol("translate");
                else if ("LIT".equalsIgnoreCase(s.getCode())) dto.setIconSymbol("menu_book");
                else if ("BIO".equalsIgnoreCase(s.getCode())) dto.setIconSymbol("biotech");
                else dto.setIconSymbol("school");

                dtos.add(dto);
            }
            return dtos;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private CourseCardDTO mapToCardDTO(Course c) {
        CourseCardDTO dto = new CourseCardDTO();
        dto.setId(c.getId());
        dto.setCode(c.getCode());
        dto.setName(c.getName());
        dto.setGradeLevel(c.getGradeLevel());
        dto.setTargetExam(c.getTargetExam());
        dto.setFee(c.getFee());
        dto.setDurationWeeks(c.getDurationWeeks());
        dto.setTotalSessions(c.getTotalSessions());
        dto.setMaxCapacity(c.getMaxCapacity());
        dto.setDescription(c.getDescription());
        dto.setImageUrl(c.getImageUrl());
        dto.setIsFeatured(c.getIsFeatured());
        dto.setStatus(c.getStatus());

        if (c.getSubject() != null) {
            dto.setSubjectName(c.getSubject().getName());
            dto.setSubjectCode(c.getSubject().getCode());
        }

        dto.setModelText("Nhóm chuẩn (Tối đa " + c.getMaxCapacity() + " HV)");
        return dto;
    }
}
