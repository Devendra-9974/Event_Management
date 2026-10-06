package com.clubsphere.dao;

import com.clubsphere.model.ClubMember;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClubMemberDAO {

    public List<ClubMember> findByClubId(int clubId) {
        List<ClubMember> members = new ArrayList<>();
        String sql = "SELECT cm.*, u.full_name, u.email, u.student_id, u.department, u.phone, c.name AS club_name " +
                     "FROM club_members cm " +
                     "JOIN users u ON cm.user_id = u.id " +
                     "JOIN clubs c ON cm.club_id = c.id " +
                     "WHERE cm.club_id = ? AND cm.status = 'ACTIVE' " +
                     "ORDER BY cm.member_role DESC, u.full_name ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    members.add(mapClubMember(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members;
    }

    public List<ClubMember> findByUserId(int userId) {
        List<ClubMember> list = new ArrayList<>();
        String sql = "SELECT cm.*, u.full_name, u.email, u.student_id, u.department, u.phone, c.name AS club_name " +
                     "FROM club_members cm " +
                     "JOIN users u ON cm.user_id = u.id " +
                     "JOIN clubs c ON cm.club_id = c.id " +
                     "WHERE cm.user_id = ? AND cm.status = 'ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapClubMember(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isMemberOfClub(int userId, int clubId) {
        String sql = "SELECT COUNT(*) FROM club_members WHERE user_id = ? AND club_id = ? AND status = 'ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addMember(int clubId, int userId, String memberRole, String notes) {
        String sql = "INSERT INTO club_members (club_id, user_id, member_role, joined_date, status, notes) " +
                     "VALUES (?, ?, ?, CURDATE(), 'ACTIVE', ?) " +
                     "ON DUPLICATE KEY UPDATE status = 'ACTIVE', member_role = VALUES(member_role), notes = VALUES(notes)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setInt(2, userId);
            ps.setString(3, memberRole != null ? memberRole : "MEMBER");
            ps.setString(4, notes);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeMember(int clubId, int userId) {
        String sql = "UPDATE club_members SET status = 'REMOVED' WHERE club_id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotalMembers() {
        String sql = "SELECT COUNT(*) FROM club_members WHERE status = 'ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private ClubMember mapClubMember(ResultSet rs) throws SQLException {
        ClubMember m = new ClubMember();
        m.setId(rs.getInt("id"));
        m.setClubId(rs.getInt("club_id"));
        m.setUserId(rs.getInt("user_id"));
        m.setMemberRole(rs.getString("member_role"));
        m.setJoinedDate(rs.getDate("joined_date"));
        m.setStatus(rs.getString("status"));
        m.setNotes(rs.getString("notes"));
        m.setCreatedAt(rs.getTimestamp("created_at"));

        m.setUserName(rs.getString("full_name"));
        m.setUserEmail(rs.getString("email"));
        m.setStudentId(rs.getString("student_id"));
        m.setDepartment(rs.getString("department"));
        m.setPhone(rs.getString("phone"));
        m.setClubName(rs.getString("club_name"));
        return m;
    }
}
