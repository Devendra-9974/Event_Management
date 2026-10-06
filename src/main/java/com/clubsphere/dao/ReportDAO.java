package com.clubsphere.dao;

import com.clubsphere.model.ActivityLog;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    public void logActivity(Integer userId, String action, String details, String ipAddress) {
        String sql = "INSERT INTO activity_logs (user_id, action, details, ip_address) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId != null && userId > 0) ps.setInt(1, userId);
            else ps.setNull(1, Types.INTEGER);
            ps.setString(2, action);
            ps.setString(3, details);
            ps.setString(4, ipAddress);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<ActivityLog> getRecentActivities(int limit) {
        List<ActivityLog> list = new ArrayList<>();
        String sql = "SELECT al.*, u.full_name, u.role " +
                     "FROM activity_logs al " +
                     "LEFT JOIN users u ON al.user_id = u.id " +
                     "ORDER BY al.created_at DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ActivityLog log = new ActivityLog();
                    log.setId(rs.getInt("id"));
                    int uId = rs.getInt("user_id");
                    if (!rs.wasNull()) log.setUserId(uId);
                    log.setAction(rs.getString("action"));
                    log.setDetails(rs.getString("details"));
                    log.setIpAddress(rs.getString("ip_address"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    log.setUserName(rs.getString("full_name"));
                    log.setUserRole(rs.getString("role"));
                    list.add(log);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Integer> getOverallStats() {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM clubs WHERE status = 'ACTIVE') AS total_clubs, " +
                     "(SELECT COUNT(*) FROM users WHERE role = 'STUDENT') AS total_students, " +
                     "(SELECT COUNT(*) FROM users WHERE role = 'CLUB_MEMBER') AS total_members, " +
                     "(SELECT COUNT(*) FROM events) AS total_events, " +
                     "(SELECT COUNT(*) FROM events WHERE event_date >= CURDATE() AND status != 'CANCELLED') AS upcoming_events, " +
                     "(SELECT COUNT(*) FROM registrations WHERE status != 'CANCELLED') AS total_registrations";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                map.put("totalClubs", rs.getInt("total_clubs"));
                map.put("totalStudents", rs.getInt("total_students"));
                map.put("totalMembers", rs.getInt("total_members"));
                map.put("totalEvents", rs.getInt("total_events"));
                map.put("upcomingEvents", rs.getInt("upcoming_events"));
                map.put("totalRegistrations", rs.getInt("total_registrations"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<Map<String, Object>> getClubWiseStats() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT c.id, c.club_code, c.name, c.category, " +
                     "(SELECT COUNT(*) FROM club_members cm WHERE cm.club_id = c.id AND cm.status = 'ACTIVE') AS members_count, " +
                     "(SELECT COUNT(*) FROM events e WHERE e.club_id = c.id) AS events_count, " +
                     "(SELECT COUNT(*) FROM registrations r JOIN events e ON r.event_id = e.id WHERE e.club_id = c.id AND r.status != 'CANCELLED') AS registrations_count " +
                     "FROM clubs c ORDER BY events_count DESC, members_count DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("clubId", rs.getInt("id"));
                row.put("clubCode", rs.getString("club_code"));
                row.put("clubName", rs.getString("name"));
                row.put("category", rs.getString("category"));
                row.put("membersCount", rs.getInt("members_count"));
                row.put("eventsCount", rs.getInt("events_count"));
                row.put("registrationsCount", rs.getInt("registrations_count"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, Object> getClubSpecificStats(int clubId) {
        Map<String, Object> map = new HashMap<>();
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM club_members WHERE club_id = ? AND status = 'ACTIVE') AS total_members, " +
                     "(SELECT COUNT(*) FROM events WHERE club_id = ?) AS total_events, " +
                     "(SELECT COUNT(*) FROM events WHERE club_id = ? AND event_date >= CURDATE() AND status != 'CANCELLED') AS upcoming_events, " +
                     "(SELECT COUNT(*) FROM registrations r JOIN events e ON r.event_id = e.id WHERE e.club_id = ? AND r.status != 'CANCELLED') AS total_registrations, " +
                     "(SELECT COUNT(*) FROM tasks WHERE club_id = ?) AS total_tasks, " +
                     "(SELECT COUNT(*) FROM tasks WHERE club_id = ? AND status = 'COMPLETED') AS completed_tasks";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setInt(2, clubId);
            ps.setInt(3, clubId);
            ps.setInt(4, clubId);
            ps.setInt(5, clubId);
            ps.setInt(6, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    map.put("totalMembers", rs.getInt("total_members"));
                    map.put("totalEvents", rs.getInt("total_events"));
                    map.put("upcomingEvents", rs.getInt("upcoming_events"));
                    map.put("totalRegistrations", rs.getInt("total_registrations"));
                    map.put("totalTasks", rs.getInt("total_tasks"));
                    map.put("completedTasks", rs.getInt("completed_tasks"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
}
