package com.clubsphere.dao;

import com.clubsphere.model.EventParticipant;
import com.clubsphere.model.Registration;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegistrationDAO {

    public boolean createRegistrationWithParticipants(Registration reg, List<EventParticipant> participants) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert into registrations
            String sqlReg = "INSERT INTO registrations (registration_number, event_id, user_id, registration_type, " +
                            "group_name, group_size, status, special_requirements) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sqlReg, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, reg.getRegistrationNumber());
                ps.setInt(2, reg.getEventId());
                ps.setInt(3, reg.getUserId());
                ps.setString(4, reg.getRegistrationType());
                ps.setString(5, reg.getGroupName());
                ps.setInt(6, reg.getGroupSize());
                ps.setString(7, reg.getStatus() != null ? reg.getStatus() : "CONFIRMED");
                ps.setString(8, reg.getSpecialRequirements());

                int affected = ps.executeUpdate();
                if (affected <= 0) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        reg.setId(rs.getInt(1));
                    }
                }
            }

            // 2. Insert into event_participants if available
            if (participants != null && !participants.isEmpty()) {
                String sqlPart = "INSERT INTO event_participants (registration_id, participant_name, student_id, email, phone, is_leader) " +
                                 "VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sqlPart)) {
                    for (EventParticipant p : participants) {
                        ps.setInt(1, reg.getId());
                        ps.setString(2, p.getParticipantName());
                        ps.setString(3, p.getStudentId());
                        ps.setString(4, p.getEmail());
                        ps.setString(5, p.getPhone());
                        ps.setBoolean(6, p.isLeader());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // 3. Increment registered_count on event
            String sqlInc = "UPDATE events SET registered_count = registered_count + 1 WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sqlInc)) {
                ps.setInt(1, reg.getEventId());
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean isUserRegistered(int eventId, int userId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE event_id = ? AND user_id = ? AND status != 'CANCELLED'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Registration findByUserAndEvent(int userId, int eventId) {
        String sql = "SELECT r.*, e.title AS event_title, c.name AS club_name, e.event_date, e.venue, e.start_time, " +
                     "u.full_name, u.email, u.phone, u.student_id " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.user_id = ? AND r.event_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Registration reg = mapRegistration(rs);
                    reg.setParticipants(findParticipantsByRegistrationId(reg.getId()));
                    return reg;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Registration> findByUserId(int userId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title AS event_title, c.name AS club_name, e.event_date, e.venue, e.start_time, " +
                     "u.full_name, u.email, u.phone, u.student_id " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.user_id = ? " +
                     "ORDER BY r.registered_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRegistration(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Registration> findByEventId(int eventId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title AS event_title, c.name AS club_name, e.event_date, e.venue, e.start_time, " +
                     "u.full_name, u.email, u.phone, u.student_id " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.event_id = ? " +
                     "ORDER BY r.registered_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Registration r = mapRegistration(rs);
                    r.setParticipants(findParticipantsByRegistrationId(r.getId()));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Registration> findByClubId(int clubId) {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title AS event_title, c.name AS club_name, e.event_date, e.venue, e.start_time, " +
                     "u.full_name, u.email, u.phone, u.student_id " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE e.club_id = ? " +
                     "ORDER BY r.registered_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRegistration(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Registration> findAll() {
        List<Registration> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title AS event_title, c.name AS club_name, e.event_date, e.venue, e.start_time, " +
                     "u.full_name, u.email, u.phone, u.student_id " +
                     "FROM registrations r " +
                     "JOIN events e ON r.event_id = e.id " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON r.user_id = u.id " +
                     "ORDER BY r.registered_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRegistration(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventParticipant> findParticipantsByRegistrationId(int registrationId) {
        List<EventParticipant> list = new ArrayList<>();
        String sql = "SELECT * FROM event_participants WHERE registration_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, registrationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EventParticipant ep = new EventParticipant();
                    ep.setId(rs.getInt("id"));
                    ep.setRegistrationId(rs.getInt("registration_id"));
                    ep.setParticipantName(rs.getString("participant_name"));
                    ep.setStudentId(rs.getString("student_id"));
                    ep.setEmail(rs.getString("email"));
                    ep.setPhone(rs.getString("phone"));
                    ep.setLeader(rs.getBoolean("is_leader"));
                    list.add(ep);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int registrationId, String status) {
        String sql = "UPDATE registrations SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, registrationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotalRegistrations() {
        String sql = "SELECT COUNT(*) FROM registrations WHERE status != 'CANCELLED'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Registration mapRegistration(ResultSet rs) throws SQLException {
        Registration r = new Registration();
        r.setId(rs.getInt("id"));
        r.setRegistrationNumber(rs.getString("registration_number"));
        r.setEventId(rs.getInt("event_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setRegistrationType(rs.getString("registration_type"));
        r.setGroupName(rs.getString("group_name"));
        r.setGroupSize(rs.getInt("group_size"));
        r.setStatus(rs.getString("status"));
        r.setRegisteredAt(rs.getTimestamp("registered_at"));
        r.setSpecialRequirements(rs.getString("special_requirements"));

        r.setEventTitle(rs.getString("event_title"));
        r.setClubName(rs.getString("club_name"));
        r.setEventDate(rs.getString("event_date"));
        r.setEventVenue(rs.getString("venue"));
        r.setEventStartTime(rs.getString("start_time"));
        r.setStudentName(rs.getString("full_name"));
        r.setStudentEmail(rs.getString("email"));
        r.setStudentPhone(rs.getString("phone"));
        r.setStudentIdCode(rs.getString("student_id"));
        return r;
    }
}
