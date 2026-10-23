package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class RoomDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private Integer capacity;
    private String status;
    private LocalDateTime createdAt;
    private long activeClassesCount = 0;

    public RoomDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public long getActiveClassesCount() { return activeClassesCount; }
    public void setActiveClassesCount(long activeClassesCount) { this.activeClassesCount = activeClassesCount; }
}
