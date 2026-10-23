package com.educenter.dto;

import java.io.Serializable;

/**
 * Data Transfer Object representing academic awards, national honors,
 * and educational accreditations for EduCenter showcase.
 */
public class AchievementAwardDTO implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String title;
    private String organization;
    private String year;
    private String description;
    private String badgeType; // e.g. "national", "accreditation", "innovation", "partnership"
    private String iconType;  // e.g. "trophy", "award", "star", "shield-check"

    public AchievementAwardDTO() {}

    public AchievementAwardDTO(String id, String title, String organization, String year, String description, String badgeType, String iconType) {
        this.id = id;
        this.title = title;
        this.organization = organization;
        this.year = year;
        this.description = description;
        this.badgeType = badgeType;
        this.iconType = iconType;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getOrganization() { return organization; }
    public void setOrganization(String organization) { this.organization = organization; }

    public String getYear() { return year; }
    public void setYear(String year) { this.year = year; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getBadgeType() { return badgeType; }
    public void setBadgeType(String badgeType) { this.badgeType = badgeType; }

    public String getIconType() { return iconType; }
    public void setIconType(String iconType) { this.iconType = iconType; }
}
