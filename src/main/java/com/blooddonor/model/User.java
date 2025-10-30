package com.blooddonor.model;

import java.time.LocalDateTime;

public class User {
    private Long id;
    private String login;
    private String passwordHash;
    private String email;
    private String phone;
    private String city;
    private String fullName;
    private LocalDateTime createdAt;
    private boolean isActive;

    public User() {}

    public User(Long id, String login, String passwordHash, String email,
                String phone, String city, String fullName,
                LocalDateTime createdAt, boolean isActive) {
        this.id = id;
        this.login = login;
        this.passwordHash = passwordHash;
        this.email = email;
        this.phone = phone;
        this.city = city;
        this.fullName = fullName;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public Boolean getActive() {
        return isActive;
    }
}