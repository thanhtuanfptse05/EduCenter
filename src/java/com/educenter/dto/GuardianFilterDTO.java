package com.educenter.dto;

import java.io.Serializable;

public class GuardianFilterDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String keyword;
    private String status = "ALL"; // ALL, ACTIVE, INACTIVE
    private String verification = "ALL"; // ALL, VERIFIED, UNVERIFIED
    private int page = 1;
    private int pageSize = 10;

    public GuardianFilterDTO() {}

    public GuardianFilterDTO(String keyword, String status, String verification, int page, int pageSize) {
        this.keyword = keyword;
        this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "ALL";
        this.verification = (verification != null && !verification.trim().isEmpty()) ? verification.trim() : "ALL";
        this.page = Math.max(1, page);
        this.pageSize = (pageSize > 0) ? pageSize : 10;
    }

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getStatus() { return status; }
    public void setStatus(String status) {
        this.status = (status != null && !status.trim().isEmpty()) ? status.trim() : "ALL";
    }

    public String getVerification() { return verification; }
    public void setVerification(String verification) {
        this.verification = (verification != null && !verification.trim().isEmpty()) ? verification.trim() : "ALL";
    }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = Math.max(1, page); }

    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = (pageSize > 0) ? pageSize : 10; }

    public int getOffset() { return (page - 1) * pageSize; }
}
