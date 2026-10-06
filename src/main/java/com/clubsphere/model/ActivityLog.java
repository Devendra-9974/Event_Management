package com.clubsphere.model;

import java.sql.Timestamp;

public class ActivityLog {
    private int id;
    private Integer userId;
    private String action;
    private String details;
    private String ipAddress;
    private Timestamp createdAt;

    // Derived
    private String userName;
    private String userRole;

    public ActivityLog() {}

    public ActivityLog(Integer userId, String action, String details, String ipAddress) {
        this.userId = userId;
        this.action = action;
        this.details = details;
        this.ipAddress = ipAddress;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }
}
