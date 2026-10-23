package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

public class TeachingJournalDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private Long sessionId;
    private String content;
    private String homework;
    private String teacherRemarks;
    private LocalDateTime updatedAt;

    public TeachingJournalDTO() {}

    public TeachingJournalDTO(Long id, Long sessionId, String content, String homework, String teacherRemarks, LocalDateTime updatedAt) {
        this.id = id;
        this.sessionId = sessionId;
        this.content = content;
        this.homework = homework;
        this.teacherRemarks = teacherRemarks;
        this.updatedAt = updatedAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getSessionId() { return sessionId; }
    public void setSessionId(Long sessionId) { this.sessionId = sessionId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getHomework() { return homework; }
    public void setHomework(String homework) { this.homework = homework; }

    public String getTeacherRemarks() { return teacherRemarks; }
    public void setTeacherRemarks(String teacherRemarks) { this.teacherRemarks = teacherRemarks; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
