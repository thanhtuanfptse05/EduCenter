package com.educenter.dto;

import com.educenter.entity.Lead;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public final class RegistrationReceiptDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private final String code;
    private final String fullName;
    private final String phone;
    private final Integer gradeLevel;
    private final LocalDateTime submittedAt;

    public RegistrationReceiptDTO(Lead lead) {
        submittedAt = lead.getCreatedAt();
        code = "LEAD-" + submittedAt.getYear() + "-" + String.format("%03d", lead.getId());
        fullName = lead.getName(); phone = lead.getPhone(); gradeLevel = lead.getGradeLevel();
    }
    public String getCode() { return code; }
    public String getFullName() { return fullName; }
    public String getPhone() { return phone; }
    public Integer getGradeLevel() { return gradeLevel; }
    public LocalDateTime getSubmittedAt() { return submittedAt; }
    public String getFormattedSubmittedAt() { return submittedAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")); }
}
