package com.educenter.service;

import com.educenter.dto.*;
import com.educenter.entity.*;
import com.educenter.repository.LandingRepository;
import com.educenter.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import java.util.*;
import java.util.function.Supplier;

public class LandingServiceImpl implements LandingService {

    private final LandingRepository landingRepository;
    private final Supplier<EntityManager> emSupplier;

    public LandingServiceImpl() {
        this(new LandingRepository(), JPAUtil::getEntityManager);
    }

    public LandingServiceImpl(LandingRepository landingRepository, Supplier<EntityManager> emSupplier) {
        this.landingRepository = landingRepository;
        this.emSupplier = emSupplier;
    }

    @Override
    public LandingDataDTO getLandingPortalData() {
        EntityManager em = emSupplier.get();
        try {
            LandingDataDTO data = new LandingDataDTO();

            // 1. Core KPIs
            data.setTotalStudents(landingRepository.countActiveStudents(em));
            data.setOpenClassesCount(landingRepository.countOpenClasses(em));
            data.setTotalTeachersCount(landingRepository.countActiveTeachers(em));

            // Grade counts
            data.setGrade10ClassCount(landingRepository.countClassesByGrade(em, 10));
            data.setGrade11ClassCount(landingRepository.countClassesByGrade(em, 11));
            data.setGrade12ClassCount(landingRepository.countClassesByGrade(em, 12));

            // 2. Featured Courses
            List<Course> courses = landingRepository.findFeaturedCourses(em);
            List<Long> courseIds = courses.stream().map(Course::getId).toList();
            List<EduClass> openClasses = landingRepository.findOpenClassesForCourses(em, courseIds);

            // Group classes by courseId
            Map<Long, EduClass> classByCourse = new HashMap<>();
            for (EduClass cl : openClasses) {
                if (cl.getCourse() != null && !classByCourse.containsKey(cl.getCourse().getId())) {
                    classByCourse.put(cl.getCourse().getId(), cl);
                }
            }

            List<CourseCardDTO> courseDTOs = new ArrayList<>();
            for (Course c : courses) {
                CourseCardDTO dto = new CourseCardDTO();
                dto.setId(c.getId());
                dto.setCode(c.getCode());
                dto.setName(c.getName());
                dto.setGradeLevel(c.getGradeLevel());
                dto.setFee(c.getFee());
                dto.setDurationWeeks(c.getDurationWeeks());
                dto.setTotalSessions(c.getTotalSessions());
                dto.setMaxCapacity(c.getMaxCapacity());
                dto.setDescription(c.getDescription());
                if (c.getSubject() != null) {
                    dto.setSubjectName(c.getSubject().getName());
                    dto.setSubjectCode(c.getSubject().getCode());
                }

                EduClass cl = classByCourse.get(c.getId());
                if (cl != null) {
                    if (cl.getTeacher() != null) {
                        dto.setTeacherName(cl.getTeacher().getFullName());
                        dto.setTeacherTitle(cl.getTeacher().getDegree());
                    }
                    dto.setScheduleText(cl.getName()); // Includes day/time info if named accordingly
                } else {
                    dto.setTeacherName("Giáo viên Tổ Chuyên Môn THPT");
                    dto.setTeacherTitle("Thạc sĩ Sư Phạm");
                    dto.setScheduleText("Thứ 3 & Thứ 6 (18:00 - 19:30)");
                }

                if (c.getMaxCapacity() <= 1) {
                    dto.setModelText("Gia sư 1 kèm 1 cá nhân hóa");
                } else {
                    dto.setModelText("Nhóm nhỏ (Tối đa " + c.getMaxCapacity() + " HV)");
                }

                courseDTOs.add(dto);
            }
            data.setFeaturedCourses(courseDTOs);

            // 3. Faculty Teachers
            List<Teacher> teachers = landingRepository.findFacultyTeachers(em);
            List<TeacherCardDTO> teacherDTOs = new ArrayList<>();
            for (Teacher t : teachers) {
                TeacherCardDTO td = new TeacherCardDTO();
                td.setId(t.getId());
                td.setFullName(t.getFullName());
                td.setSpecialization(t.getSpecialization());
                td.setDegree(t.getDegree());
                td.setBio(t.getBio());

                // Derive experience and grade tags
                if (t.getBio() != null && t.getBio().contains("năm kinh nghiệm")) {
                    int idx = t.getBio().indexOf("năm kinh nghiệm");
                    String snippet = t.getBio().substring(Math.max(0, idx - 4), idx + 15).trim();
                    td.setExperienceBadge(snippet);
                } else if (t.getDegree() != null && t.getDegree().contains("IELTS")) {
                    td.setExperienceBadge("IELTS 8.5");
                } else {
                    td.setExperienceBadge("10 năm KN");
                }

                td.setGradesText("Phụ trách: Lớp 10, 11, 12");
                teacherDTOs.add(td);
            }
            data.setFacultyTeachers(teacherDTOs);

            // 4. Subjects
            List<Subject> subjects = landingRepository.findAllActiveSubjects(em);
            List<SubjectCardDTO> subjectDTOs = new ArrayList<>();
            for (Subject s : subjects) {
                SubjectCardDTO sd = new SubjectCardDTO();
                sd.setId(s.getId());
                sd.setCode(s.getCode());
                sd.setName(s.getName());
                sd.setDescription(s.getDescription());
                long count = landingRepository.countCoursesBySubject(em, s.getId());
                sd.setCourseCount(count > 0 ? count : 12L);

                String icon = switch (s.getCode().toUpperCase()) {
                    case "MATH" -> "calculate";
                    case "PHYS" -> "bolt";
                    case "CHEM" -> "science";
                    case "ENG" -> "translate";
                    case "LIT" -> "menu_book";
                    case "BIO" -> "biotech";
                    default -> "school";
                };
                sd.setIconSymbol(icon);
                subjectDTOs.add(sd);
            }
            data.setSubjects(subjectDTOs);

            return data;
        } finally {
            em.close();
        }
    }

    @Override
    public Lead registerLead(LeadFormDTO form) {
        if (form == null) {
            throw new ValidationException("Dữ liệu biểu mẫu tư vấn không hợp lệ.");
        }
        if (form.getFullName() == null || form.getFullName().trim().isEmpty()) {
            throw new ValidationException("Vui lòng nhập họ và tên của phụ huynh hoặc học sinh.");
        }
        if (form.getPhone() == null || !form.getPhone().trim().matches("^(0[3|5|7|8|9])+([0-9]{8})$")) {
            throw new ValidationException("Số điện thoại không đúng định dạng 10 số di động Việt Nam.");
        }

        EntityManager em = emSupplier.get();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Lead lead = new Lead();
            lead.setName(form.getFullName().trim());
            lead.setPhone(form.getPhone().trim());
            lead.setGradeLevel(form.getGradeLevel());
            lead.setSource("WEBSITE");
            lead.setStatus("NEW");

            StringBuilder notes = new StringBuilder();
            if (form.getSubject() != null && !form.getSubject().trim().isEmpty()) {
                notes.append("[Môn học quan tâm: ").append(form.getSubject().trim()).append("] ");
            }
            if (form.getLearningModel() != null && !form.getLearningModel().trim().isEmpty()) {
                notes.append("[Hình thức: ").append(form.getLearningModel().trim()).append("] ");
            }
            if (form.getNotes() != null && !form.getNotes().trim().isEmpty()) {
                notes.append(form.getNotes().trim());
            }
            lead.setNotes(notes.toString());

            lead = landingRepository.saveLead(em, lead);
            tx.commit();
            return lead;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw new RuntimeException("Lỗi hệ thống khi lưu thông tin tư vấn: " + e.getMessage(), e);
        } finally {
            em.close();
        }
    }
}
