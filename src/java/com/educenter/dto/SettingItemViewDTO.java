package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * DTO for displaying an individual system setting on administration cards.
 */
public class SettingItemViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String key;
    private String value;
    private String label;
    private String description;
    private String group;
    private String inputType;
    private String unit;
    private LocalDateTime updatedAt;
    private Long updatedBy;

    public SettingItemViewDTO() {}

    public SettingItemViewDTO(String key, String value, String label, String description,
                              String group, String inputType, String unit, LocalDateTime updatedAt, Long updatedBy) {
        this.key = key;
        this.value = value;
        this.label = label;
        this.description = description;
        this.group = group;
        this.inputType = inputType;
        this.unit = unit;
        this.updatedAt = updatedAt;
        this.updatedBy = updatedBy;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getInputType() {
        return inputType;
    }

    public void setInputType(String inputType) {
        this.inputType = inputType;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Long getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(Long updatedBy) {
        this.updatedBy = updatedBy;
    }
}
