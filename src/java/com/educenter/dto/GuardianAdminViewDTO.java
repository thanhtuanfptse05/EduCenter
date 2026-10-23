package com.educenter.dto;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class GuardianAdminViewDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    private Long id;
    private String code;
    private Long userId;
    private String userEmail;
    private String userStatus;
    private String fullName;
    private String phone;
    private String email;
    private String occupation;
    private String address;
    private String status; // ACTIVE, INACTIVE
    private LocalDateTime createdAt;
    private long childrenCount = 0;
    private long verifiedChildrenCount = 0;
    private List<StudentGuardianLinkDTO> children = new ArrayList<>();

    public GuardianAdminViewDTO() {}

    public Long getId() { return id; }
    public void setId(Long id) {
        this.id = id;
        this.code = "PH" + String.format("%04d", id != null ? id : 0);
    }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getUserStatus() { return userStatus; }
    public void setUserStatus(String userStatus) { this.userStatus = userStatus; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOccupation() { return occupation; }
    public void setOccupation(String occupation) { this.occupation = occupation; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public long getChildrenCount() { return childrenCount; }
    public void setChildrenCount(long childrenCount) { this.childrenCount = childrenCount; }

    public long getVerifiedChildrenCount() { return verifiedChildrenCount; }
    public void setVerifiedChildrenCount(long verifiedChildrenCount) { this.verifiedChildrenCount = verifiedChildrenCount; }

    public List<StudentGuardianLinkDTO> getChildren() { return children; }
    public void setChildren(List<StudentGuardianLinkDTO> children) {
        this.children = (children != null) ? children : new ArrayList<>();
    }
}
