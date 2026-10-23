package com.educenter.entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "TeachingJournals")
public class TeachingJournal implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id", nullable = false, unique = true)
    private ClassSession classSession;

    @Column(name = "content", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String content;

    @Column(name = "homework", columnDefinition = "NVARCHAR(MAX)")
    private String homework;

    @Column(name = "teacher_remarks", columnDefinition = "NVARCHAR(MAX)")
    private String teacherRemarks;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    public TeachingJournal() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public ClassSession getClassSession() { return classSession; }
    public void setClassSession(ClassSession classSession) { this.classSession = classSession; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getHomework() { return homework; }
    public void setHomework(String homework) { this.homework = homework; }

    public String getTeacherRemarks() { return teacherRemarks; }
    public void setTeacherRemarks(String teacherRemarks) { this.teacherRemarks = teacherRemarks; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
