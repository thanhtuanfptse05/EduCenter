package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class LeadListItemDTO implements Serializable {

    private Long id;
    private String name;
    private String phone;
    private String email;
    private Integer gradeLevel;
    private String source;
    private String status;
    private String notes;
    private Long assignedToId;
    private String assignedToName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeadListItemDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getFullName() { return name; }
    public void setFullName(String fullName) { this.name = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Integer getGradeLevel() { return gradeLevel; }
    public void setGradeLevel(Integer gradeLevel) { this.gradeLevel = gradeLevel; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Long getAssignedToId() { return assignedToId; }
    public void setAssignedToId(Long assignedToId) { this.assignedToId = assignedToId; }

    public String getAssignedToName() { return assignedToName; }
    public void setAssignedToName(String assignedToName) { this.assignedToName = assignedToName; }

    public String getAssignedStaffName() { return assignedToName; }
    public void setAssignedStaffName(String assignedStaffName) { this.assignedToName = assignedStaffName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getStatusBadgeClass() {
        if (status == null) return "badge-secondary";
        return switch (status) {
            case "NEW" -> "badge-primary";
            case "CONTACTED" -> "badge-info";
            case "ASSESSED" -> "badge-warning";
            case "CONSULTING" -> "badge-warning";
            case "ENROLLED" -> "badge-success";
            case "LOST" -> "badge-danger";
            default -> "badge-secondary";
        };
    }

    public String getStatusDisplayName() {
        if (status == null) return "Chưa xác định";
        return switch (status) {
            case "NEW" -> "Mới tiếp nhận";
            case "CONTACTED" -> "Đã liên hệ";
            case "ASSESSED" -> "Đã test đầu vào";
            case "CONSULTING" -> "Đang tư vấn";
            case "ENROLLED" -> "Đã ghi danh";
            case "LOST" -> "Hủy / Thất bại";
            default -> status;
        };
    }
}
