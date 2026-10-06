package com.clubsphere.dao;

import com.clubsphere.model.Announcement;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    public List<Announcement> findByClubId(int clubId) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, c.name AS club_name, u.full_name AS creator_name " +
                     "FROM announcements a " +
                     "JOIN clubs c ON a.club_id = c.id " +
                     "JOIN users u ON a.created_by_user_id = u.id " +
                     "WHERE a.club_id = ? " +
                     "ORDER BY a.created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAnnouncement(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Announcement> findPublicAnnouncements() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT a.*, c.name AS club_name, u.full_name AS creator_name " +
                     "FROM announcements a " +
                     "JOIN clubs c ON a.club_id = c.id " +
                     "JOIN users u ON a.created_by_user_id = u.id " +
                     "WHERE a.target_role = 'ALL' " +
                     "ORDER BY a.created_at DESC LIMIT 20";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapAnnouncement(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(Announcement announcement) {
        String sql = "INSERT INTO announcements (club_id, created_by_user_id, title, content, priority, target_role) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, announcement.getClubId());
            ps.setInt(2, announcement.getCreatedByUserId());
            ps.setString(3, announcement.getTitle());
            ps.setString(4, announcement.getContent());
            ps.setString(5, announcement.getPriority() != null ? announcement.getPriority() : "NORMAL");
            ps.setString(6, announcement.getTargetRole() != null ? announcement.getTargetRole() : "ALL");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        announcement.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM announcements WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Announcement mapAnnouncement(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setId(rs.getInt("id"));
        a.setClubId(rs.getInt("club_id"));
        a.setCreatedByUserId(rs.getInt("created_by_user_id"));
        a.setTitle(rs.getString("title"));
        a.setContent(rs.getString("content"));
        a.setPriority(rs.getString("priority"));
        a.setTargetRole(rs.getString("target_role"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setClubName(rs.getString("club_name"));
        a.setCreatedByName(rs.getString("creator_name"));
        return a;
    }
}
