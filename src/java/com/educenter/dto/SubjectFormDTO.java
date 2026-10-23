package com.educenter.dto;

import java.io.Serializable;

public class SubjectFormDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private String name;
    private String description;
    private String status = "ACTIVE";

    public SubjectFormDTO() {}

    public SubjectFormDTO(Long id, String code, String name, String description, String status) {
        this.id = id;
        this.code = code;
        this.name = name;
        this.description = description;
        this.status = status;
    }

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
}
