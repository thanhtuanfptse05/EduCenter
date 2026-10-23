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
                dto.setImageUrl(c.getImageUrl());
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
                    dto.setScheduleText(cl.getStartDate() == null ? null : "Dự kiến khai giảng: " + cl.getStartDate().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")));
                } else {
                    dto.setTeacherName("Chưa phân công giáo viên");
                    dto.setTeacherTitle(null);
                    dto.setScheduleText("Lịch học chưa được công bố");
                }

                if (c.getMaxCapacity() != null && c.getMaxCapacity() <= 1) {
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

                if (t.getBio() != null) {
                    java.util.regex.Matcher experience = java.util.regex.Pattern.compile("[0-9]+[+]?[ ]+năm kinh nghiệm").matcher(t.getBio());
                    if (experience.find()) td.setExperienceBadge(experience.group());
                }

                if (t.getUser() != null) {
                    td.setPhotoUrl(t.getUser().getAvatarUrl());
                }
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
                sd.setCourseCount(count);
                sd.setImageUrl(landingRepository.findRepresentativeImageBySubject(em, s.getId()));

                String icon = switch (s.getCode().toUpperCase()) {
                    case "MATH", "MAT" -> "calculate";
                    case "PHYS", "PHY" -> "bolt";
                    case "CHEM", "CHE" -> "science";
                    case "ENG" -> "translate";
                    case "LIT" -> "menu_book";
                    case "BIO" -> "biotech";
                    default -> "school";
                };
                sd.setIconSymbol(icon);
                subjectDTOs.add(sd);
            }
            data.setSubjects(subjectDTOs);

            // 5. Academic Honors & Awards Showcase (feat-landing-showcase)
            List<AchievementAwardDTO> awards = new ArrayList<>();
            awards.add(new AchievementAwardDTO(
                "AW-01",
                "Top 10 Đơn vị Bồi dưỡng & Luyện thi Xuất sắc",
                "Hiệp hội Phát triển Giáo dục & Tri thức Trẻ Việt Nam",
                "2025",
                "Vinh danh đơn vị đào tạo tiêu biểu có phương pháp sư phạm cá nhân hóa và quản trị học vụ số hóa minh bạch.",
                "Học Thuật Xuất Sắc",
                "trophy"
            ));
            awards.add(new AchievementAwardDTO(
                "AW-02",
                "Đối tác Luyện thi ĐGNL & Khảo thí Chuẩn mực",
                "Mạng lưới Khảo thí & Hợp tác Giáo dục Đại học",
                "2024 - 2025",
                "Chứng nhận ngân hàng đề thi chuẩn hóa và tỷ lệ học viên đạt điểm cao xét tuyển sớm vào các trường ĐH tốp đầu.",
                "Khảo Thí Chuẩn Mực",
                "award"
            ));
            awards.add(new AchievementAwardDTO(
                "AW-03",
                "Sáng kiến EdTech Quản trị Cổng Phụ Huynh Minh Bạch",
                "Vietnam EdTech Awards 2024",
                "2024",
                "Giải pháp Cổng Phụ Huynh kết nối điểm số, nhật ký từng buổi và biên lai điện tử minh bạch theo thời gian thực.",
                "Chuyển Đổi Số",
                "shield-check"
            ));
            awards.add(new AchievementAwardDTO(
                "AW-04",
                "Top 50 Trung tâm Bồi dưỡng Kiến thức Uy tín Toàn quốc",
                "Diễn đàn Giáo dục Đổi mới Sáng tạo Quốc gia",
                "2023 - 2024",
                "Ghi nhận đóng góp xuất sắc giúp hơn 50.000 lượt học sinh THPT bứt phá học lực và đỗ nguyện vọng 1.",
                "Uy Tín Toàn Quốc",
                "star"
            ));
            awards.add(new AchievementAwardDTO(
                "AW-05",
                "Biểu tượng Vàng Vì Sự nghiệp Ươm mầm Tài năng Trẻ",
                "Quỹ Hỗ trợ Phát triển Giáo dục Phổ thông",
                "2025",
                "Đóng góp bền bỉ trong công tác khuyến học, bồi dưỡng học sinh giỏi môn Toán, KHTN và Tiếng Anh các khối 6-12.",
                "Khuyến Học",
                "medal"
            ));
            data.setAchievementAwards(awards);

            // 6. Ascending Learning Roadmap Pathway Stages (feat-landing-showcase)
            List<LearningStageDTO> stages = new ArrayList<>();
            stages.add(new LearningStageDTO(
                1,
                "Lớp 6–9 & Lớp 10",
                "Xây dựng nền tảng học thuật vững chắc",
                "Củng cố kiến thức chuyển cấp, hình thành phương pháp tư duy logic và làm quen chương trình GDPT mới hiệu quả.",
                "Toán nền tảng • Ngữ văn tư duy • Tiếng Anh giao tiếp & ngữ pháp",
                "Chặng 1: Nền tảng",
                false
            ));
            stages.add(new LearningStageDTO(
                2,
                "Lớp 11",
                "Bứt phá năng lực & Nâng cao điểm số học bạ",
                "Chuyên sâu các dạng bài tập phân hóa cao, lấp đầy mọi lỗ hổng kiến thức và tối ưu hóa điểm số trung bình học kỳ.",
                "Toán 11 nâng cao • Lý / Hóa / Sinh chuyên sâu • Bứt phá học bạ",
                "Chặng 2: Tăng tốc",
                false
            ));
            stages.add(new LearningStageDTO(
                3,
                "Lớp 12 & Ôn thi ĐGNL",
                "Luyện đề thực chiến & Tối ưu kỹ năng phòng thi",
                "Tổng ôn toàn diện trọng tâm kiến thức thi tốt nghiệp, rèn phản xạ làm bài trắc nghiệm nhanh và chiến thuật tránh bẫy đề thi.",
                "Tổng ôn THPT Quốc Gia • ĐGNL ĐHQG / ĐGTD Bách Khoa • Phản xạ phòng thi",
                "Chặng 3: Về đích",
                false
            ));
            stages.add(new LearningStageDTO(
                4,
                "Cột mốc Đích đến",
                "Cánh cửa Đại học Tốp đầu & Cơ hội học bổng",
                "Đỗ Nguyện vọng 1 các trường Đại học trọng điểm (ĐHQG, Ngoại thương, Bách Khoa, Y Hà Nội...), sở hữu chứng chỉ quốc tế và học bổng giá trị cao.",
                "Đại học Trọng điểm • Cơ hội Du học & Học bổng • Chứng chỉ IELTS / SAT",
                "Đích Đến Thành Công",
                true
            ));
            data.setLearningStages(stages);

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
        if (!com.educenter.util.ValidationUtil.isValidFullName(form.getFullName())) {
            throw new ValidationException("Vui lòng nhập họ và tên của phụ huynh hoặc học sinh.");
        }
        if (!com.educenter.util.ValidationUtil.isValidPhone(form.getPhone(), true)) {
            throw new ValidationException("Số điện thoại không đúng định dạng 10 số di động Việt Nam.");
        }

        if (form.getGradeLevel() != null && (form.getGradeLevel() < 6 || form.getGradeLevel() > 12))
            throw new ValidationException("Khối lớp phải từ 6 đến 12.");
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
