package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class StudentDetailDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private StudentAdminViewDTO student;
    private List<StudentGuardianLinkDTO> guardians = new ArrayList<>();
    private List<ClassAdminViewDTO> enrolledClasses = new ArrayList<>();

    public StudentDetailDTO() {}

    public StudentDetailDTO(StudentAdminViewDTO student, List<StudentGuardianLinkDTO> guardians, List<ClassAdminViewDTO> enrolledClasses) {
        this.student = student;
        this.guardians = (guardians != null) ? guardians : new ArrayList<>();
        this.enrolledClasses = (enrolledClasses != null) ? enrolledClasses : new ArrayList<>();
    }

    public StudentAdminViewDTO getStudent() { return student; }
    public void setStudent(StudentAdminViewDTO student) { this.student = student; }

    public List<StudentGuardianLinkDTO> getGuardians() { return guardians; }
    public void setGuardians(List<StudentGuardianLinkDTO> guardians) { this.guardians = guardians; }

    public List<ClassAdminViewDTO> getEnrolledClasses() { return enrolledClasses; }
    public void setEnrolledClasses(List<ClassAdminViewDTO> enrolledClasses) { this.enrolledClasses = enrolledClasses; }
}
