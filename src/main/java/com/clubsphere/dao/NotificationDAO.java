package com.clubsphere.dao;

import com.clubsphere.model.Notification;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public List<Notification> findByUserId(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 50";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapNotification(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countUnreadByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean create(Notification n) {
        String sql = "INSERT INTO notifications (user_id, title, message, type, related_event_id, related_task_id, related_club_id, is_read) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, n.getUserId());
            ps.setString(2, n.getTitle());
            ps.setString(3, n.getMessage());
            ps.setString(4, n.getType());
            if (n.getRelatedEventId() != null && n.getRelatedEventId() > 0) ps.setInt(5, n.getRelatedEventId());
            else ps.setNull(5, Types.INTEGER);
            if (n.getRelatedTaskId() != null && n.getRelatedTaskId() > 0) ps.setInt(6, n.getRelatedTaskId());
            else ps.setNull(6, Types.INTEGER);
            if (n.getRelatedClubId() != null && n.getRelatedClubId() > 0) ps.setInt(7, n.getRelatedClubId());
            else ps.setNull(7, Types.INTEGER);
            ps.setBoolean(8, n.isRead());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        n.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markAsRead(int notificationId, int userId) {
        String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void notifyAllUsers(String title, String message, String type, Integer clubId, Integer eventId) {
        String sqlUsers = "SELECT id FROM users WHERE status = 'ACTIVE'";
        String sqlInsert = "INSERT INTO notifications (user_id, title, message, type, related_club_id, related_event_id, is_read) " +
                           "VALUES (?, ?, ?, ?, ?, ?, FALSE)";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sqlUsers);
             PreparedStatement ps = conn.prepareStatement(sqlInsert)) {

            while (rs.next()) {
                int uid = rs.getInt("id");
                ps.setInt(1, uid);
                ps.setString(2, title);
                ps.setString(3, message);
                ps.setString(4, type);
                if (clubId != null) ps.setInt(5, clubId); else ps.setNull(5, Types.INTEGER);
                if (eventId != null) ps.setInt(6, eventId); else ps.setNull(6, Types.INTEGER);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Notification mapNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getInt("id"));
        n.setUserId(rs.getInt("user_id"));
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setType(rs.getString("type"));
        int evtId = rs.getInt("related_event_id");
        if (!rs.wasNull()) n.setRelatedEventId(evtId);
        int tId = rs.getInt("related_task_id");
        if (!rs.wasNull()) n.setRelatedTaskId(tId);
        int cId = rs.getInt("related_club_id");
        if (!rs.wasNull()) n.setRelatedClubId(cId);
        n.setRead(rs.getBoolean("is_read"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        return n;
    }
}
