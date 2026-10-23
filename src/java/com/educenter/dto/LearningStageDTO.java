package com.educenter.dto;

import java.io.Serializable;

/**
 * Data Transfer Object representing an ascending stage in the student learning roadmap pathway.
 */
public class LearningStageDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private int stageNumber;
    private String gradeRange;       // e.g. "Lớp 6–9 & Lớp 10", "Lớp 11", "Lớp 12 & ĐGNL", "Cột mốc Đích đến"
    private String title;            // e.g. "Xây dựng nền tảng học thuật vững chắc"
    private String description;      // Core outcome & educational methodology
    private String focusSubjects;    // Key focus areas / subjects
    private String badgeText;        // Stage tag e.g. "Nền tảng", "Tăng tốc", "Luyện đề", "Thành công"
    private boolean apexGoal;        // true if final achievement apex goal

    public LearningStageDTO() {}

    public LearningStageDTO(int stageNumber, String gradeRange, String title, String description, String focusSubjects, String badgeText, boolean apexGoal) {
        this.stageNumber = stageNumber;
        this.gradeRange = gradeRange;
        this.title = title;
        this.description = description;
        this.focusSubjects = focusSubjects;
        this.badgeText = badgeText;
        this.apexGoal = apexGoal;
    }

    public int getStageNumber() { return stageNumber; }
    public void setStageNumber(int stageNumber) { this.stageNumber = stageNumber; }

    public String getGradeRange() { return gradeRange; }
    public void setGradeRange(String gradeRange) { this.gradeRange = gradeRange; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getFocusSubjects() { return focusSubjects; }
    public void setFocusSubjects(String focusSubjects) { this.focusSubjects = focusSubjects; }

    public String getBadgeText() { return badgeText; }
    public void setBadgeText(String badgeText) { this.badgeText = badgeText; }

    public boolean isApexGoal() { return apexGoal; }
    public void setApexGoal(boolean apexGoal) { this.apexGoal = apexGoal; }
}
