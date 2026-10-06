package com.clubsphere.model;

import java.sql.Timestamp;

public class Club {
    private int id;
    private String clubCode;
    private String name;
    private String category;
    private String description;
    private String logoUrl;
    private Integer headUserId;
    private String facultyAdvisor;
    private String contactEmail;
    private String contactPhone;
    private String meetingVenue;
    private String status; // ACTIVE, INACTIVE
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Derived fields
    private String headUserName;
    private String headUserEmail;
    private int memberCount;
    private int eventCount;

    public Club() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getClubCode() { return clubCode; }
    public void setClubCode(String clubCode) { this.clubCode = clubCode; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }

    public Integer getHeadUserId() { return headUserId; }
    public void setHeadUserId(Integer headUserId) { this.headUserId = headUserId; }

    public String getFacultyAdvisor() { return facultyAdvisor; }
    public void setFacultyAdvisor(String facultyAdvisor) { this.facultyAdvisor = facultyAdvisor; }

    public String getContactEmail() { return contactEmail; }
    public void setContactEmail(String contactEmail) { this.contactEmail = contactEmail; }

    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }

    public String getMeetingVenue() { return meetingVenue; }
    public void setMeetingVenue(String meetingVenue) { this.meetingVenue = meetingVenue; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getHeadUserName() { return headUserName; }
    public void setHeadUserName(String headUserName) { this.headUserName = headUserName; }

    public String getHeadUserEmail() { return headUserEmail; }
    public void setHeadUserEmail(String headUserEmail) { this.headUserEmail = headUserEmail; }

    public int getMemberCount() { return memberCount; }
    public void setMemberCount(int memberCount) { this.memberCount = memberCount; }

    public int getEventCount() { return eventCount; }
    public void setEventCount(int eventCount) { this.eventCount = eventCount; }
}
