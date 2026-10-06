package com.clubsphere.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Registration {
    private int id;
    private String registrationNumber;
    private int eventId;
    private int userId;
    private String registrationType; // INDIVIDUAL, GROUP
    private String groupName;
    private int groupSize;
    private String status; // PENDING, CONFIRMED, CANCELLED
    private Timestamp registeredAt;
    private String specialRequirements;

    // Derived fields
    private String eventTitle;
    private String clubName;
    private String eventDate;
    private String eventVenue;
    private String eventStartTime;
    private String studentName;
    private String studentEmail;
    private String studentPhone;
    private String studentIdCode;

    // Participant details for group registrations
    private List<EventParticipant> participants = new ArrayList<>();

    public Registration() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRegistrationType() { return registrationType; }
    public void setRegistrationType(String registrationType) { this.registrationType = registrationType; }

    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }

    public int getGroupSize() { return groupSize; }
    public void setGroupSize(int groupSize) { this.groupSize = groupSize; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(Timestamp registeredAt) { this.registeredAt = registeredAt; }

    public String getSpecialRequirements() { return specialRequirements; }
    public void setSpecialRequirements(String specialRequirements) { this.specialRequirements = specialRequirements; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }

    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }

    public String getEventVenue() { return eventVenue; }
    public void setEventVenue(String eventVenue) { this.eventVenue = eventVenue; }

    public String getEventStartTime() { return eventStartTime; }
    public void setEventStartTime(String eventStartTime) { this.eventStartTime = eventStartTime; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }

    public String getStudentIdCode() { return studentIdCode; }
    public void setStudentIdCode(String studentIdCode) { this.studentIdCode = studentIdCode; }

    public List<EventParticipant> getParticipants() { return participants; }
    public void setParticipants(List<EventParticipant> participants) { this.participants = participants; }
}
