package com.clubsphere.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Event {
    private int id;
    private String title;
    private int clubId;
    private String description;
    private Date eventDate;
    private Time startTime;
    private Time endTime;
    private String venue;
    private Timestamp registrationDeadline;
    private int capacity;
    private int registeredCount;
    private String eventType; // WORKSHOP, SEMINAR, COMPETITION, CULTURAL, TECHNICAL, SPORTS, HACKATHON, EXHIBITION, OTHER
    private String participationType; // INDIVIDUAL, GROUP, BOTH
    private String status; // UPCOMING, REGISTRATION_OPEN, REGISTRATION_CLOSED, COMPLETED, CANCELLED
    private String qrToken;
    private String bannerUrl;
    private int createdByUserId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Derived Club & Creator details
    private String clubName;
    private String clubCategory;
    private String createdByName;
    private boolean isRegisteredByCurrentUser;
    private String userRegistrationStatus;

    public Event() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getClubId() { return clubId; }
    public void setClubId(int clubId) { this.clubId = clubId; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }

    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public Timestamp getRegistrationDeadline() { return registrationDeadline; }
    public void setRegistrationDeadline(Timestamp registrationDeadline) { this.registrationDeadline = registrationDeadline; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public int getRegisteredCount() { return registeredCount; }
    public void setRegisteredCount(int registeredCount) { this.registeredCount = registeredCount; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public String getParticipationType() { return participationType; }
    public void setParticipationType(String participationType) { this.participationType = participationType; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getQrToken() { return qrToken; }
    public void setQrToken(String qrToken) { this.qrToken = qrToken; }

    public String getBannerUrl() { return bannerUrl; }
    public void setBannerUrl(String bannerUrl) { this.bannerUrl = bannerUrl; }

    public int getCreatedByUserId() { return createdByUserId; }
    public void setCreatedByUserId(int createdByUserId) { this.createdByUserId = createdByUserId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getClubCategory() { return clubCategory; }
    public void setClubCategory(String clubCategory) { this.clubCategory = clubCategory; }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }

    public boolean isRegisteredByCurrentUser() { return isRegisteredByCurrentUser; }
    public void setRegisteredByCurrentUser(boolean registeredByCurrentUser) { isRegisteredByCurrentUser = registeredByCurrentUser; }

    public String getUserRegistrationStatus() { return userRegistrationStatus; }
    public void setUserRegistrationStatus(String userRegistrationStatus) { this.userRegistrationStatus = userRegistrationStatus; }
}
