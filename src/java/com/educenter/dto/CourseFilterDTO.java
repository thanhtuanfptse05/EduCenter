package com.educenter.dto;

import java.io.Serializable;
import java.math.BigDecimal;

public class CourseFilterDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String keyword;
    private Long subjectId;
    private Integer gradeLevel;
    private String feeRange; // "all", "under_2m", "2m_3m5", "over_3m5"
    private BigDecimal minFee;
    private BigDecimal maxFee;
    private String sort = "newest"; // "newest", "fee_asc", "fee_desc", "name_asc"
    private String status = "open"; // "all", "open", "soon"
    private int page = 1;
    private int pageSize = 9;

    public CourseFilterDTO() {}

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public Long getSubjectId() { return subjectId; }
    public void setSubjectId(Long subjectId) { this.subjectId = subjectId; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getFeeRange() { return feeRange; }
    public void setFeeRange(String feeRange) {
        this.feeRange = feeRange;
        if ("under_2m".equalsIgnoreCase(feeRange)) {
            this.minFee = null;
            this.maxFee = new BigDecimal("2000000");
        } else if ("2m_3m5".equalsIgnoreCase(feeRange)) {
            this.minFee = new BigDecimal("2000000");
            this.maxFee = new BigDecimal("3500000");
        } else if ("over_3m5".equalsIgnoreCase(feeRange)) {
            this.minFee = new BigDecimal("3500000");
            this.maxFee = null;
        } else {
            this.minFee = null;
            this.maxFee = null;
        }
    }

    public BigDecimal getMinFee() { return minFee; }
    public void setMinFee(BigDecimal minFee) { this.minFee = minFee; }

    public BigDecimal getMaxFee() { return maxFee; }
    public void setMaxFee(BigDecimal maxFee) { this.maxFee = maxFee; }

    public String getSort() { return sort; }
    public void setSort(String sort) {
        if (sort != null && !sort.trim().isEmpty()) {
            this.sort = sort.trim();
        }
    }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getPage() { return page; }
    public void setPage(int page) {
        this.page = Math.max(1, page);
    }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) {
        this.pageSize = (pageSize > 0) ? pageSize : 9;
    }

    public int getOffset() {
        return (page - 1) * pageSize;
    }
}
