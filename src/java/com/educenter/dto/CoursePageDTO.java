package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class CoursePageDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<CourseCardDTO> items = new ArrayList<>();
    private int currentPage = 1;
    private int pageSize = 9;
    private long totalRecords = 0L;
    private int totalPages = 1;
    private CourseFilterDTO filter;

    public CoursePageDTO() {}

    public CoursePageDTO(List<CourseCardDTO> items, int currentPage, int pageSize, long totalRecords, CourseFilterDTO filter) {
        this.items = (items != null) ? items : new ArrayList<>();
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalRecords = totalRecords;
        this.totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (this.totalPages < 1) {
            this.totalPages = 1;
        }
        this.filter = filter;
    }

    public List<CourseCardDTO> getItems() { return items; }
    public void setItems(List<CourseCardDTO> items) { this.items = items; }

    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }

    public long getTotalRecords() { return totalRecords; }
    public void setTotalRecords(long totalRecords) { this.totalRecords = totalRecords; }

    public int getTotalPages() { return totalPages; }
    public void setTotalPages(int totalPages) { this.totalPages = totalPages; }

    public CourseFilterDTO getFilter() { return filter; }
    public void setFilter(CourseFilterDTO filter) { this.filter = filter; }

    public boolean isHasPrevious() { return currentPage > 1; }
    public boolean isHasNext() { return currentPage < totalPages; }
}
