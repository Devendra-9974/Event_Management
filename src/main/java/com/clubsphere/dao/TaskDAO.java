package com.clubsphere.dao;

import com.clubsphere.model.Task;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDAO {

    public List<Task> findByClubId(int clubId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, c.name AS club_name, e.title AS event_title, " +
                     "u1.full_name AS assigned_to_name, u1.email AS assigned_to_email, u2.full_name AS assigned_by_name " +
                     "FROM tasks t " +
                     "JOIN clubs c ON t.club_id = c.id " +
                     "LEFT JOIN events e ON t.event_id = e.id " +
                     "JOIN users u1 ON t.assigned_to_user_id = u1.id " +
                     "JOIN users u2 ON t.assigned_by_user_id = u2.id " +
                     "WHERE t.club_id = ? " +
                     "ORDER BY t.due_date ASC, t.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Task> findByAssignedUser(int userId) {
        List<Task> list = new ArrayList<>();
        String sql = "SELECT t.*, c.name AS club_name, e.title AS event_title, " +
                     "u1.full_name AS assigned_to_name, u1.email AS assigned_to_email, u2.full_name AS assigned_by_name " +
                     "FROM tasks t " +
                     "JOIN clubs c ON t.club_id = c.id " +
                     "LEFT JOIN events e ON t.event_id = e.id " +
                     "JOIN users u1 ON t.assigned_to_user_id = u1.id " +
                     "JOIN users u2 ON t.assigned_by_user_id = u2.id " +
                     "WHERE t.assigned_to_user_id = ? " +
                     "ORDER BY t.due_date ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTask(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Task findById(int id) {
        String sql = "SELECT t.*, c.name AS club_name, e.title AS event_title, " +
                     "u1.full_name AS assigned_to_name, u1.email AS assigned_to_email, u2.full_name AS assigned_by_name " +
                     "FROM tasks t " +
                     "JOIN clubs c ON t.club_id = c.id " +
                     "LEFT JOIN events e ON t.event_id = e.id " +
                     "JOIN users u1 ON t.assigned_to_user_id = u1.id " +
                     "JOIN users u2 ON t.assigned_by_user_id = u2.id " +
                     "WHERE t.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapTask(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Task task) {
        String sql = "INSERT INTO tasks (club_id, event_id, title, description, assigned_to_user_id, " +
                     "assigned_by_user_id, due_date, priority, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, task.getClubId());
            if (task.getEventId() != null && task.getEventId() > 0) {
                ps.setInt(2, task.getEventId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, task.getTitle());
            ps.setString(4, task.getDescription());
            ps.setInt(5, task.getAssignedToUserId());
            ps.setInt(6, task.getAssignedByUserId());
            ps.setDate(7, task.getDueDate());
            ps.setString(8, task.getPriority() != null ? task.getPriority() : "MEDIUM");
            ps.setString(9, task.getStatus() != null ? task.getStatus() : "PENDING");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        task.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int taskId, String status) {
        String sql = "UPDATE tasks SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int taskId) {
        String sql = "DELETE FROM tasks WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Task mapTask(ResultSet rs) throws SQLException {
        Task t = new Task();
        t.setId(rs.getInt("id"));
        t.setClubId(rs.getInt("club_id"));
        int evtId = rs.getInt("event_id");
        if (!rs.wasNull()) {
            t.setEventId(evtId);
        }
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setAssignedToUserId(rs.getInt("assigned_to_user_id"));
        t.setAssignedByUserId(rs.getInt("assigned_by_user_id"));
        t.setDueDate(rs.getDate("due_date"));
        t.setPriority(rs.getString("priority"));
        t.setStatus(rs.getString("status"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setUpdatedAt(rs.getTimestamp("updated_at"));

        t.setClubName(rs.getString("club_name"));
        t.setEventTitle(rs.getString("event_title"));
        t.setAssignedToName(rs.getString("assigned_to_name"));
        t.setAssignedToEmail(rs.getString("assigned_to_email"));
        t.setAssignedByName(rs.getString("assigned_by_name"));
        return t;
    }
}
