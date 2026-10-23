package com.educenter.dto;

import java.io.Serializable;

/**
 * DTO carrying form inputs when updating system configuration in ADM-19.
 */
public class SystemSettingsFormDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private String centerName;
    private String centerHotline;
    private String centerEmail;
    private String centerAddress;
    private Integer maxClassCapacityDefault;
    private Integer tuitionDueDays;
    private Boolean admissionsOpen;

    public SystemSettingsFormDTO() {}

    public String getCenterName() {
        return centerName;
    }

    public void setCenterName(String centerName) {
        this.centerName = centerName;
    }

    public String getCenterHotline() {
        return centerHotline;
    }

    public void setCenterHotline(String centerHotline) {
        this.centerHotline = centerHotline;
    }

    public String getCenterEmail() {
        return centerEmail;
    }

    public void setCenterEmail(String centerEmail) {
        this.centerEmail = centerEmail;
    }

    public String getCenterAddress() {
        return centerAddress;
    }

    public void setCenterAddress(String centerAddress) {
        this.centerAddress = centerAddress;
    }

    public Integer getMaxClassCapacityDefault() {
        return maxClassCapacityDefault;
    }

    public void setMaxClassCapacityDefault(Integer maxClassCapacityDefault) {
        this.maxClassCapacityDefault = maxClassCapacityDefault;
    }

    public Integer getTuitionDueDays() {
        return tuitionDueDays;
    }

    public void setTuitionDueDays(Integer tuitionDueDays) {
        this.tuitionDueDays = tuitionDueDays;
    }

    public Boolean getAdmissionsOpen() {
        return admissionsOpen;
    }

    public void setAdmissionsOpen(Boolean admissionsOpen) {
        this.admissionsOpen = admissionsOpen;
    }
}
