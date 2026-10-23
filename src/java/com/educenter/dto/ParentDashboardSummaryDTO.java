package com.educenter.dto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * DTO providing comprehensive summary for Parent Dashboard (PAR-01).
 */
public class ParentDashboardSummaryDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long guardianId;
    private String guardianName;
    private String guardianPhone;
    private List<ChildGuardianViewDTO> verifiedChildren = new ArrayList<>();
    private Long selectedChildId;
    private StudentDashboardSummaryDTO selectedChildSummary;

    public ParentDashboardSummaryDTO() {}

    public Long getGuardianId() { return guardianId; }
    public void setGuardianId(Long guardianId) { this.guardianId = guardianId; }

    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }

    public String getGuardianPhone() { return guardianPhone; }
    public void setGuardianPhone(String guardianPhone) { this.guardianPhone = guardianPhone; }

    public List<ChildGuardianViewDTO> getVerifiedChildren() { return verifiedChildren; }
    public void setVerifiedChildren(List<ChildGuardianViewDTO> verifiedChildren) { this.verifiedChildren = verifiedChildren; }

    public Long getSelectedChildId() { return selectedChildId; }
    public void setSelectedChildId(Long selectedChildId) { this.selectedChildId = selectedChildId; }

    public StudentDashboardSummaryDTO getSelectedChildSummary() { return selectedChildSummary; }
    public void setSelectedChildSummary(StudentDashboardSummaryDTO selectedChildSummary) { this.selectedChildSummary = selectedChildSummary; }

    public boolean hasChildren() {
        return verifiedChildren != null && !verifiedChildren.isEmpty();
    }
}
