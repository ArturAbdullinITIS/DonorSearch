package com.blooddonor.model;

import java.time.LocalDate;

public class DonorProfile {
    private Long id;
    private Long userId;
    private String bloodType; // A, B, AB, O
    private String rhFactor; // POSITIVE, NEGATIVE
    private LocalDate lastDonationDate;
    private boolean readyToDonate;
    private String additionalInfo;

    private String userName;
    private String userCity;
    private String userPhone;

    public DonorProfile() {}

    public DonorProfile(Long userId, String bloodType, String rhFactor) {
        this.userId = userId;
        this.bloodType = bloodType;
        this.rhFactor = rhFactor;
        this.readyToDonate = true;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public String getBloodType() { return bloodType; }
    public void setBloodType(String bloodType) { this.bloodType = bloodType; }

    public String getRhFactor() { return rhFactor; }
    public void setRhFactor(String rhFactor) { this.rhFactor = rhFactor; }

    public LocalDate getLastDonationDate() { return lastDonationDate; }
    public void setLastDonationDate(LocalDate lastDonationDate) {
        this.lastDonationDate = lastDonationDate;
    }

    public boolean isReadyToDonate() { return readyToDonate; }
    public void setReadyToDonate(boolean readyToDonate) {
        this.readyToDonate = readyToDonate;
    }

    public String getAdditionalInfo() { return additionalInfo; }
    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserCity() { return userCity; }
    public void setUserCity(String userCity) { this.userCity = userCity; }

    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }

    public String getFullBloodType() {
        return bloodType + " " + (rhFactor.equals("POSITIVE") ? "+" : "-");
    }
}
