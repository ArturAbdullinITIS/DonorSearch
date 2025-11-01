package com.blooddonor.model;

import java.time.LocalDateTime;

public class Response {
    private Long id;
    private Long requestId;
    private Long donorId;
    private String message;
    private String status; // PENDING, ACCEPTED, REJECTED
    private LocalDateTime createdAt;

    private String donorName;
    private String donorPhone;
    private String donorBloodType;
    private String requestPatientName;

    public Response() {}

    public Response(Long requestId, Long donorId, String message) {
        this.requestId = requestId;
        this.donorId = donorId;
        this.message = message;
        this.status = "PENDING";
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getRequestId() { return requestId; }
    public void setRequestId(Long requestId) { this.requestId = requestId; }

    public Long getDonorId() { return donorId; }
    public void setDonorId(Long donorId) { this.donorId = donorId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getDonorName() { return donorName; }
    public void setDonorName(String donorName) { this.donorName = donorName; }

    public String getDonorPhone() { return donorPhone; }
    public void setDonorPhone(String donorPhone) { this.donorPhone = donorPhone; }

    public String getDonorBloodType() { return donorBloodType; }
    public void setDonorBloodType(String donorBloodType) {
        this.donorBloodType = donorBloodType;
    }

    public String getRequestPatientName() { return requestPatientName; }
    public void setRequestPatientName(String requestPatientName) {
        this.requestPatientName = requestPatientName;
    }
}
