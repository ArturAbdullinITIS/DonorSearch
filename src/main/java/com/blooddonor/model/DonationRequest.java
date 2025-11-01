package com.blooddonor.model;

import java.time.LocalDateTime;

public class DonationRequest {
    private Long id;
    private Long authorId;
    private String patientName;
    private String bloodTypeNeeded;
    private String rhFactorNeeded;
    private String city;
    private String hospital;
    private String urgencyLevel; // LOW, MEDIUM, HIGH, CRITICAL
    private String description;
    private String contactInfo;
    private String status; // ACTIVE, CLOSED, FULFILLED
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String authorName;
    private int responsesCount;

    public DonationRequest() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getAuthorId() { return authorId; }
    public void setAuthorId(Long authorId) { this.authorId = authorId; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getBloodTypeNeeded() { return bloodTypeNeeded; }
    public void setBloodTypeNeeded(String bloodTypeNeeded) {
        this.bloodTypeNeeded = bloodTypeNeeded;
    }

    public String getRhFactorNeeded() { return rhFactorNeeded; }
    public void setRhFactorNeeded(String rhFactorNeeded) {
        this.rhFactorNeeded = rhFactorNeeded;
    }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getHospital() { return hospital; }
    public void setHospital(String hospital) { this.hospital = hospital; }

    public String getUrgencyLevel() { return urgencyLevel; }
    public void setUrgencyLevel(String urgencyLevel) {
        this.urgencyLevel = urgencyLevel;
    }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }

    public int getResponsesCount() { return responsesCount; }
    public void setResponsesCount(int responsesCount) {
        this.responsesCount = responsesCount;
    }

    public String getFullBloodTypeNeeded() {
        return bloodTypeNeeded + " " + (rhFactorNeeded.equals("POSITIVE") ? "+" : "-");
    }

    public String getUrgencyBadgeClass() {
        switch (urgencyLevel) {
            case "CRITICAL": return "badge-danger";
            case "HIGH": return "badge-warning";
            case "MEDIUM": return "badge-info";
            default: return "badge-secondary";
        }
    }
}
