package com.educenter.dto;

import java.io.Serializable;

public class StudentFilterDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String keyword;
    private Integer gradeLevel;
    private String status = "ALL"; // ALL, STUDYING, RESERVED, DROPPED, GRADUATED
    private int page = 1;
    private int pageSize = 10;

    public StudentFilterDTO() {}

    public StudentFilterDTO(String keyword, Integer gradeLevel, String status, int page, int pageSize) {
        this.keyword = keyword;
        this.gradeLevel = gradeLevel;
        this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "ALL";
        this.page = Math.max(1, page);
        this.pageSize = (pageSize > 0) ? pageSize : 10;
    }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getStatus() { return status; }
    public void setStatus(String status) {
        this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "ALL";
    }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = Math.max(1, page); }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = (pageSize > 0) ? pageSize : 10; }

    public int getOffset() { return (page - 1) * pageSize; }
}
