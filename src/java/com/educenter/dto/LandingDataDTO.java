package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class LandingDataDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private long totalStudents;
    private long openClassesCount;
    private long totalTeachersCount;
    private String universityPassingRate = "98.6%";

    private long grade10ClassCount;
    private long grade11ClassCount;
    private long grade12ClassCount;

    private List<CourseCardDTO> featuredCourses = new ArrayList<>();
    private List<TeacherCardDTO> facultyTeachers = new ArrayList<>();
    private List<SubjectCardDTO> subjects = new ArrayList<>();

    public LandingDataDTO() {}

    public long getTotalStudents() { return totalStudents; }
    public void setTotalStudents(long totalStudents) { this.totalStudents = totalStudents; }

    public long getOpenClassesCount() { return openClassesCount; }
    public void setOpenClassesCount(long openClassesCount) { this.openClassesCount = openClassesCount; }

    public long getTotalTeachersCount() { return totalTeachersCount; }
    public void setTotalTeachersCount(long totalTeachersCount) { this.totalTeachersCount = totalTeachersCount; }

    public String getUniversityPassingRate() { return universityPassingRate; }
    public void setUniversityPassingRate(String universityPassingRate) { this.universityPassingRate = universityPassingRate; }

    public long getGrade10ClassCount() { return grade10ClassCount; }
    public void setGrade10ClassCount(long grade10ClassCount) { this.grade10ClassCount = grade10ClassCount; }

    public long getGrade11ClassCount() { return grade11ClassCount; }
    public void setGrade11ClassCount(long grade11ClassCount) { this.grade11ClassCount = grade11ClassCount; }

    public long getGrade12ClassCount() { return grade12ClassCount; }
    public void setGrade12ClassCount(long grade12ClassCount) { this.grade12ClassCount = grade12ClassCount; }

    public List<CourseCardDTO> getFeaturedCourses() { return featuredCourses; }
    public void setFeaturedCourses(List<CourseCardDTO> featuredCourses) { this.featuredCourses = featuredCourses; }

    public List<TeacherCardDTO> getFacultyTeachers() { return facultyTeachers; }
    public void setFacultyTeachers(List<TeacherCardDTO> facultyTeachers) { this.facultyTeachers = facultyTeachers; }

    public List<SubjectCardDTO> getSubjects() { return subjects; }
    public void setSubjects(List<SubjectCardDTO> subjects) { this.subjects = subjects; }
}
