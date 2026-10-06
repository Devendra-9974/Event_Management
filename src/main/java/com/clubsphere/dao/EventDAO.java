package com.clubsphere.dao;

import com.clubsphere.model.Event;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public List<Event> findAll() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, c.name AS club_name, c.category AS club_category, u.full_name AS creator_name " +
                     "FROM events e " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON e.created_by_user_id = u.id " +
                     "ORDER BY e.event_date ASC, e.start_time ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> findUpcoming() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, c.name AS club_name, c.category AS club_category, u.full_name AS creator_name " +
                     "FROM events e " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON e.created_by_user_id = u.id " +
                     "WHERE e.event_date >= CURDATE() AND e.status != 'CANCELLED' " +
                     "ORDER BY e.event_date ASC, e.start_time ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapEvent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Event> findByClubId(int clubId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT e.*, c.name AS club_name, c.category AS club_category, u.full_name AS creator_name " +
                     "FROM events e " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON e.created_by_user_id = u.id " +
                     "WHERE e.club_id = ? " +
                     "ORDER BY e.event_date DESC, e.start_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Event findById(int id) {
        String sql = "SELECT e.*, c.name AS club_name, c.category AS club_category, u.full_name AS creator_name " +
                     "FROM events e " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON e.created_by_user_id = u.id " +
                     "WHERE e.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapEvent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Event findByQrToken(String token) {
        String sql = "SELECT e.*, c.name AS club_name, c.category AS club_category, u.full_name AS creator_name " +
                     "FROM events e " +
                     "JOIN clubs c ON e.club_id = c.id " +
                     "JOIN users u ON e.created_by_user_id = u.id " +
                     "WHERE e.qr_token = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapEvent(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Event event) {
        String sql = "INSERT INTO events (title, club_id, description, event_date, start_time, end_time, venue, " +
                     "registration_deadline, capacity, registered_count, event_type, participation_type, status, qr_token, created_by_user_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, event.getTitle());
            ps.setInt(2, event.getClubId());
            ps.setString(3, event.getDescription());
            ps.setDate(4, event.getEventDate());
            ps.setTime(5, event.getStartTime());
            ps.setTime(6, event.getEndTime());
            ps.setString(7, event.getVenue());
            ps.setTimestamp(8, event.getRegistrationDeadline());
            ps.setInt(9, event.getCapacity());
            ps.setInt(10, 0);
            ps.setString(11, event.getEventType());
            ps.setString(12, event.getParticipationType());
            ps.setString(13, event.getStatus());
            ps.setString(14, event.getQrToken());
            ps.setInt(15, event.getCreatedByUserId());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        event.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Event event) {
        String sql = "UPDATE events SET title = ?, description = ?, event_date = ?, start_time = ?, end_time = ?, " +
                     "venue = ?, registration_deadline = ?, capacity = ?, event_type = ?, participation_type = ?, status = ? " +
                     "WHERE id = ? AND club_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, event.getTitle());
            ps.setString(2, event.getDescription());
            ps.setDate(3, event.getEventDate());
            ps.setTime(4, event.getStartTime());
            ps.setTime(5, event.getEndTime());
            ps.setString(6, event.getVenue());
            ps.setTimestamp(7, event.getRegistrationDeadline());
            ps.setInt(8, event.getCapacity());
            ps.setString(9, event.getEventType());
            ps.setString(10, event.getParticipationType());
            ps.setString(11, event.getStatus());
            ps.setInt(12, event.getId());
            ps.setInt(13, event.getClubId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int eventId, String status) {
        String sql = "UPDATE events SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean incrementRegisteredCount(Connection conn, int eventId, int increment) throws SQLException {
        String sql = "UPDATE events SET registered_count = registered_count + ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, increment);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countTotalEvents() {
        String sql = "SELECT COUNT(*) FROM events";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countUpcomingEvents() {
        String sql = "SELECT COUNT(*) FROM events WHERE event_date >= CURDATE() AND status != 'CANCELLED'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Event> searchEvents(String keyword, Integer clubId, String eventType, String status) {
        List<Event> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT e.*, c.name AS club_name, c.category AS club_category, u.full_name AS creator_name " +
            "FROM events e " +
            "JOIN clubs c ON e.club_id = c.id " +
            "JOIN users u ON e.created_by_user_id = u.id WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (e.title LIKE ? OR e.description LIKE ? OR e.venue LIKE ?) ");
            String term = "%" + keyword.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (clubId != null && clubId > 0) {
            sql.append("AND e.club_id = ? ");
            params.add(clubId);
        }
        if (eventType != null && !eventType.trim().isEmpty() && !eventType.equalsIgnoreCase("ALL")) {
            sql.append("AND e.event_type = ? ");
            params.add(eventType.trim());
        }
        if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("ALL")) {
            sql.append("AND e.status = ? ");
            params.add(status.trim());
        }
        sql.append("ORDER BY e.event_date ASC, e.start_time ASC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEvent(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Event mapEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setClubId(rs.getInt("club_id"));
        e.setDescription(rs.getString("description"));
        e.setEventDate(rs.getDate("event_date"));
        e.setStartTime(rs.getTime("start_time"));
        e.setEndTime(rs.getTime("end_time"));
        e.setVenue(rs.getString("venue"));
        e.setRegistrationDeadline(rs.getTimestamp("registration_deadline"));
        e.setCapacity(rs.getInt("capacity"));
        e.setRegisteredCount(rs.getInt("registered_count"));
        e.setEventType(rs.getString("event_type"));
        e.setParticipationType(rs.getString("participation_type"));
        e.setStatus(rs.getString("status"));
        e.setQrToken(rs.getString("qr_token"));
        e.setBannerUrl(rs.getString("banner_url"));
        e.setCreatedByUserId(rs.getInt("created_by_user_id"));
        e.setCreatedAt(rs.getTimestamp("created_at"));
        e.setUpdatedAt(rs.getTimestamp("updated_at"));

        e.setClubName(rs.getString("club_name"));
        e.setClubCategory(rs.getString("club_category"));
        e.setCreatedByName(rs.getString("creator_name"));
        return e;
    }
}
