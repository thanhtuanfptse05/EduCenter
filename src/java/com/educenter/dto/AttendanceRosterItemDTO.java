package com.educenter.dto;

import java.io.Serializable;

public class AttendanceRosterItemDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long studentId;
    private String studentCode;
    private String studentName;
    private String studentPhone;
    private String attendanceStatus; // PRESENT, LATE, ABSENT_EXCUSED, ABSENT_UNEXCUSED
    private String remarks;

    public AttendanceRosterItemDTO() {}

    public AttendanceRosterItemDTO(Long studentId, String studentCode, String studentName, String studentPhone, String attendanceStatus, String remarks) {
        this.studentId = studentId;
        this.studentCode = studentCode;
        this.studentName = studentName;
        this.studentPhone = studentPhone;
        this.attendanceStatus = attendanceStatus;
        this.remarks = remarks;
    }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public String getStudentCode() { return studentCode; }
    public void setStudentCode(String studentCode) { this.studentCode = studentCode; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }

    public String getAttendanceStatus() { return attendanceStatus; }
    public void setAttendanceStatus(String attendanceStatus) { this.attendanceStatus = attendanceStatus; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
}
