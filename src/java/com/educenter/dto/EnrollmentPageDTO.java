package com.educenter.dto;

import com.educenter.entity.Student;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class EnrollmentPageDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<EnrollmentViewDTO> items = new ArrayList<>();
    private long totalRecords;
    private int currentPage;
    private int pageSize;
    private int totalPages;

    // Filters
    private Long classId;
    private String status;
    private String keyword;

    // KPI Counters
    private long totalActive;
    private long totalReserved;
    private long totalTransferred;
    private long totalDropped;

    // Options for forms/filters
    private List<ClassEnrollmentOptionDTO> classOptions = new ArrayList<>();
    private List<Student> studentOptions = new ArrayList<>();

    public EnrollmentPageDTO() {
        this.currentPage = 1;
        this.pageSize = 10;
    }

    public EnrollmentPageDTO(List<EnrollmentViewDTO> items, long totalRecords, int currentPage, int pageSize,
                             Long classId, String status, String keyword) {
        this.items = (items != null) ? items : new ArrayList<>();
        this.totalRecords = totalRecords;
        this.currentPage = Math.max(1, currentPage);
        this.pageSize = Math.max(1, pageSize);
        this.totalPages = (int) Math.ceil((double) totalRecords / this.pageSize);
        if (this.totalPages == 0) {
            this.totalPages = 1;
        }
        this.classId = classId;
        this.status = status;
        this.keyword = keyword;
    }

    public boolean hasPrevious() {
        return currentPage > 1;
    }

    public boolean hasNext() {
        return currentPage < totalPages;
    }

    public List<EnrollmentViewDTO> getItems() { return items; }
    public void setItems(List<EnrollmentViewDTO> items) { this.items = items; }

    public long getTotalRecords() { return totalRecords; }
    public void setTotalRecords(long totalRecords) { this.totalRecords = totalRecords; }

    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }

    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }

    public Long getClassId() { return classId; }
    public void setClassId(Long classId) { this.classId = classId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public long getTotalActive() { return totalActive; }
    public void setTotalActive(long totalActive) { this.totalActive = totalActive; }

    public long getTotalReserved() { return totalReserved; }
    public void setTotalReserved(long totalReserved) { this.totalReserved = totalReserved; }

    public long getTotalTransferred() { return totalTransferred; }
    public void setTotalTransferred(long totalTransferred) { this.totalTransferred = totalTransferred; }

    public long getTotalDropped() { return totalDropped; }
    public void setTotalDropped(long totalDropped) { this.totalDropped = totalDropped; }

    public List<ClassEnrollmentOptionDTO> getClassOptions() { return classOptions; }
    public void setClassOptions(List<ClassEnrollmentOptionDTO> classOptions) { this.classOptions = classOptions; }

    public List<Student> getStudentOptions() { return studentOptions; }
    public void setStudentOptions(List<Student> studentOptions) { this.studentOptions = studentOptions; }
}
