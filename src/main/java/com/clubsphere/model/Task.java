package com.clubsphere.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int id;
    private int clubId;
    private Integer eventId;
    private String title;
    private String description;
    private int assignedToUserId;
    private int assignedByUserId;
    private Date dueDate;
    private String priority; // LOW, MEDIUM, HIGH, URGENT
    private String status; // PENDING, IN_PROGRESS, COMPLETED
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Derived fields
    private String clubName;
    private String eventTitle;
    private String assignedToName;
    private String assignedToEmail;
    private String assignedByName;

    public Task() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getClubId() { return clubId; }
    public void setClubId(int clubId) { this.clubId = clubId; }

    public Integer getEventId() { return eventId; }
    public void setEventId(Integer eventId) { this.eventId = eventId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getAssignedToUserId() { return assignedToUserId; }
    public void setAssignedToUserId(int assignedToUserId) { this.assignedToUserId = assignedToUserId; }

    public int getAssignedByUserId() { return assignedByUserId; }
    public void setAssignedByUserId(int assignedByUserId) { this.assignedByUserId = assignedByUserId; }

    public Date getDueDate() { return dueDate; }
    public void setDueDate(Date dueDate) { this.dueDate = dueDate; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public String getAssignedToName() { return assignedToName; }
    public void setAssignedToName(String assignedToName) { this.assignedToName = assignedToName; }

    public String getAssignedToEmail() { return assignedToEmail; }
    public void setAssignedToEmail(String assignedToEmail) { this.assignedToEmail = assignedToEmail; }

    public String getAssignedByName() { return assignedByName; }
    public void setAssignedByName(String assignedByName) { this.assignedByName = assignedByName; }
}
