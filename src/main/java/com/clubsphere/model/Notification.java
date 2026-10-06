package com.clubsphere.model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private int userId;
    private String title;
    private String message;
    private String type; // EVENT_CREATED, REGISTRATION_CONFIRMED, EVENT_REMINDER, EVENT_CANCELLED, DEADLINE_ALERT, TASK_ASSIGNED, CLUB_ANNOUNCEMENT, GENERAL
    private Integer relatedEventId;
    private Integer relatedTaskId;
    private Integer relatedClubId;
    private boolean read;
    private Timestamp createdAt;

    public Notification() {}

    public Notification(int userId, String title, String message, String type) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.type = type;
        this.read = false;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Integer getRelatedEventId() { return relatedEventId; }
    public void setRelatedEventId(Integer relatedEventId) { this.relatedEventId = relatedEventId; }

    public Integer getRelatedTaskId() { return relatedTaskId; }
    public void setRelatedTaskId(Integer relatedTaskId) { this.relatedTaskId = relatedTaskId; }

    public Integer getRelatedClubId() { return relatedClubId; }
    public void setRelatedClubId(Integer relatedClubId) { this.relatedClubId = relatedClubId; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
