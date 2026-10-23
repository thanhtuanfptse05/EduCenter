package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Grouped settings container for rendering clean cards on ADM-19 screen.
 */
public class SystemSettingsGroupedDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<SettingItemViewDTO> centerInfo = new ArrayList<>();
    private List<SettingItemViewDTO> academicRules = new ArrayList<>();
    private List<SettingItemViewDTO> financeRules = new ArrayList<>();
    private boolean admissionsOpen = true;

    public SystemSettingsGroupedDTO() {}

    public List<SettingItemViewDTO> getCenterInfo() {
        return centerInfo;
    }

    public void setCenterInfo(List<SettingItemViewDTO> centerInfo) {
        this.centerInfo = centerInfo;
    }

    public List<SettingItemViewDTO> getAcademicRules() {
        return academicRules;
    }

    public void setAcademicRules(List<SettingItemViewDTO> academicRules) {
        this.academicRules = academicRules;
    }

    public List<SettingItemViewDTO> getFinanceRules() {
        return financeRules;
    }

    public void setFinanceRules(List<SettingItemViewDTO> financeRules) {
        this.financeRules = financeRules;
    }

    public boolean isAdmissionsOpen() {
        return admissionsOpen;
    }

    public void setAdmissionsOpen(boolean admissionsOpen) {
        this.admissionsOpen = admissionsOpen;
    }
}
