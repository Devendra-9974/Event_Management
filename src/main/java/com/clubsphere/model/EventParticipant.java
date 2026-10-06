package com.clubsphere.model;

public class EventParticipant {
    private int id;
    private int registrationId;
    private String participantName;
    private String studentId;
    private String email;
    private String phone;
    private boolean leader;

    public EventParticipant() {}

    public EventParticipant(String participantName, String studentId, String email, String phone, boolean leader) {
        this.participantName = participantName;
        this.studentId = studentId;
        this.email = email;
        this.phone = phone;
        this.leader = leader;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRegistrationId() { return registrationId; }
    public void setRegistrationId(int registrationId) { this.registrationId = registrationId; }

    public String getParticipantName() { return participantName; }
    public void setParticipantName(String participantName) { this.participantName = participantName; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public boolean isLeader() { return leader; }
    public void setLeader(boolean leader) { this.leader = leader; }
}
