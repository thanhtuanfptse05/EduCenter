package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class SubjectAdminViewDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private String description;
    private String status;
    private long totalCourses;
    private long openCourses;
    private LocalDateTime createdAt;

    public SubjectAdminViewDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public long getTotalCourses() { return totalCourses; }
    public void setTotalCourses(long totalCourses) { this.totalCourses = totalCourses; }

    public long getOpenCourses() { return openCourses; }
    public void setOpenCourses(long openCourses) { this.openCourses = openCourses; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
