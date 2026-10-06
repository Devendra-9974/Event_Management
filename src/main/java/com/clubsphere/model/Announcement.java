package com.clubsphere.model;

import java.sql.Timestamp;

public class Announcement {
    private int id;
    private int clubId;
    private int createdByUserId;
    private String title;
    private String content;
    private String priority; // NORMAL, IMPORTANT, URGENT
    private String targetRole; // ALL, MEMBERS_ONLY
    private Timestamp createdAt;

    // Derived fields
    private String clubName;
    private String createdByName;

    public Announcement() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getClubId() { return clubId; }
    public void setClubId(int clubId) { this.clubId = clubId; }

    public int getCreatedByUserId() { return createdByUserId; }
    public void setCreatedByUserId(int createdByUserId) { this.createdByUserId = createdByUserId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getTargetRole() { return targetRole; }
    public void setTargetRole(String targetRole) { this.targetRole = targetRole; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
}
