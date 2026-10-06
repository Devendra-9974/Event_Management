package com.clubsphere.model;

import java.sql.Date;
import java.sql.Timestamp;

public class ClubMember {
    private int id;
    private int clubId;
    private int userId;
    private String memberRole; // MEMBER, COORDINATOR, VICE_HEAD
    private Date joinedDate;
    private String status; // ACTIVE, INACTIVE, REMOVED
    private String notes;
    private Timestamp createdAt;

    // Derived User info
    private String userName;
    private String userEmail;
    private String studentId;
    private String department;
    private String phone;
    private String clubName;

    public ClubMember() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getClubId() { return clubId; }
    public void setClubId(int clubId) { this.clubId = clubId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getMemberRole() { return memberRole; }
    public void setMemberRole(String memberRole) { this.memberRole = memberRole; }

    public Date getJoinedDate() { return joinedDate; }
    public void setJoinedDate(Date joinedDate) { this.joinedDate = joinedDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getClubName() { return clubName; }
    public void setClubName(String clubName) { this.clubName = clubName; }
}
