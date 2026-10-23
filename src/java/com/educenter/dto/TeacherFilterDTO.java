package com.educenter.dto;

import java.io.Serializable;

public class TeacherFilterDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String keyword;
    private String status = "ALL";
    private String sort = "newest";
    private int page = 1;
    private int pageSize = 10;

    public TeacherFilterDTO() {}

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSort() { return sort; }
    public void setSort(String sort) { this.sort = sort; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = Math.max(1, page); }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = Math.max(1, pageSize); }

    public int getOffset() {
        return (page - 1) * pageSize;
    }
}
