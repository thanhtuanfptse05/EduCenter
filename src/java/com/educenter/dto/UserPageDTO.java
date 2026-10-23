package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Paginated wrapper DTO for administrative user management.
 */
public class UserPageDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<UserViewDTO> items = new ArrayList<>();
    private long totalRecords;
    private int currentPage;
    private int pageSize;
    private int totalPages;

    // Filters
    private String keyword;
    private String roleCode;
    private String status;

    // Summary statistics for KPI cards in header
    private long totalActive;
    private long totalLocked;
    private List<RoleOptionDTO> availableRoles = new ArrayList<>();
    public List<RoleOptionDTO> getAvailableRoles() { return availableRoles; }
    public void setAvailableRoles(List<RoleOptionDTO> roles) { availableRoles = roles; }

    public UserPageDTO() {
        this.currentPage = 1;
        this.pageSize = 10;
    }

    public UserPageDTO(List<UserViewDTO> items, long totalRecords, int currentPage, int pageSize,
                       String keyword, String roleCode, String status) {
        this.items = (items != null) ? items : new ArrayList<>();
        this.totalRecords = totalRecords;
        this.currentPage = Math.max(1, currentPage);
        this.pageSize = Math.max(1, pageSize);
        this.totalPages = (int) Math.ceil((double) totalRecords / this.pageSize);
        if (this.totalPages == 0) {
            this.totalPages = 1;
        }
        this.keyword = keyword;
        this.roleCode = roleCode;
        this.status = status;
    }

    public boolean hasPrevious() {
        return currentPage > 1;
    }

    public boolean hasNext() {
        return currentPage < totalPages;
    }

    // Getters and Setters

    public List<UserViewDTO> getItems() {
        return items;
    }

    public void setItems(List<UserViewDTO> items) {
        this.items = items;
    }

    public long getTotalRecords() {
        return totalRecords;
    }

    public void setTotalRecords(long totalRecords) {
        this.totalRecords = totalRecords;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public String getRoleCode() {
        return roleCode;
    }

    public void setRoleCode(String roleCode) {
        this.roleCode = roleCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getTotalActive() {
        return totalActive;
    }

    public void setTotalActive(long totalActive) {
        this.totalActive = totalActive;
    }

    public long getTotalLocked() {
        return totalLocked;
    }

    public void setTotalLocked(long totalLocked) {
        this.totalLocked = totalLocked;
    }
}
