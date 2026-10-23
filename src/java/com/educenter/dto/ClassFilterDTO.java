package com.educenter.dto;

import java.io.Serializable;

public class ClassFilterDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String keyword;
    private Long courseId;
    private String status;
    private int page = 1;
    private int pageSize = 10;

    public ClassFilterDTO() {}

    public ClassFilterDTO(String keyword, Long courseId, String status, int page, int pageSize) {
        this.keyword = keyword;
        this.courseId = courseId;
        this.status = status;
        this.page = page > 0 ? page : 1;
        this.pageSize = pageSize > 0 ? pageSize : 10;
    }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = page > 0 ? page : 1; }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize > 0 ? pageSize : 10; }
}
