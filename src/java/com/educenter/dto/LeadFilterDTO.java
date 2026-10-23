package com.educenter.dto;

import java.io.Serializable;

public class LeadFilterDTO implements Serializable {

    private String keyword;
    private String status;
    private String source;
    private Integer gradeLevel;
    private Long assignedToId;
    private int page = 1;
    private int pageSize = 10;

    public LeadFilterDTO() {}

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public Long getAssignedToId() { return assignedToId; }
    public void setAssignedToId(Long assignedToId) { this.assignedToId = assignedToId; }

    public int getPage() { return page <= 0 ? 1 : page; }
    public void setPage(int page) { this.page = page; }

    public int getPageSize() { return pageSize <= 0 ? 10 : pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
}
