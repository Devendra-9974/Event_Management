package com.clubsphere.dao;

import com.clubsphere.model.Club;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClubDAO {

    public List<Club> findAll() {
        List<Club> clubs = new ArrayList<>();
        String sql = "SELECT c.*, u.full_name AS head_name, u.email AS head_email, " +
                     "(SELECT COUNT(*) FROM club_members cm WHERE cm.club_id = c.id AND cm.status = 'ACTIVE') AS member_count, " +
                     "(SELECT COUNT(*) FROM events e WHERE e.club_id = c.id) AS event_count " +
                     "FROM clubs c " +
                     "LEFT JOIN users u ON c.head_user_id = u.id " +
                     "ORDER BY c.id ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                clubs.add(mapClub(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clubs;
    }

    public Club findById(int id) {
        String sql = "SELECT c.*, u.full_name AS head_name, u.email AS head_email, " +
                     "(SELECT COUNT(*) FROM club_members cm WHERE cm.club_id = c.id AND cm.status = 'ACTIVE') AS member_count, " +
                     "(SELECT COUNT(*) FROM events e WHERE e.club_id = c.id) AS event_count " +
                     "FROM clubs c " +
                     "LEFT JOIN users u ON c.head_user_id = u.id " +
                     "WHERE c.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Club findByCode(String code) {
        String sql = "SELECT c.*, u.full_name AS head_name, u.email AS head_email, " +
                     "(SELECT COUNT(*) FROM club_members cm WHERE cm.club_id = c.id AND cm.status = 'ACTIVE') AS member_count, " +
                     "(SELECT COUNT(*) FROM events e WHERE e.club_id = c.id) AS event_count " +
                     "FROM clubs c " +
                     "LEFT JOIN users u ON c.head_user_id = u.id " +
                     "WHERE c.club_code = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Club findByHeadUserId(int headUserId) {
        String sql = "SELECT c.*, u.full_name AS head_name, u.email AS head_email, " +
                     "(SELECT COUNT(*) FROM club_members cm WHERE cm.club_id = c.id AND cm.status = 'ACTIVE') AS member_count, " +
                     "(SELECT COUNT(*) FROM events e WHERE e.club_id = c.id) AS event_count " +
                     "FROM clubs c " +
                     "LEFT JOIN users u ON c.head_user_id = u.id " +
                     "WHERE c.head_user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, headUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Club club) {
        String sql = "INSERT INTO clubs (club_code, name, category, description, head_user_id, faculty_advisor, contact_email, contact_phone, meeting_venue, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, club.getClubCode());
            ps.setString(2, club.getName());
            ps.setString(3, club.getCategory());
            ps.setString(4, club.getDescription());
            if (club.getHeadUserId() != null && club.getHeadUserId() > 0) {
                ps.setInt(5, club.getHeadUserId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setString(6, club.getFacultyAdvisor());
            ps.setString(7, club.getContactEmail());
            ps.setString(8, club.getContactPhone());
            ps.setString(9, club.getMeetingVenue());
            ps.setString(10, club.getStatus() != null ? club.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        club.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Club club) {
        String sql = "UPDATE clubs SET name = ?, category = ?, description = ?, head_user_id = ?, faculty_advisor = ?, " +
                     "contact_email = ?, contact_phone = ?, meeting_venue = ?, status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, club.getName());
            ps.setString(2, club.getCategory());
            ps.setString(3, club.getDescription());
            if (club.getHeadUserId() != null && club.getHeadUserId() > 0) {
                ps.setInt(4, club.getHeadUserId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, club.getFacultyAdvisor());
            ps.setString(6, club.getContactEmail());
            ps.setString(7, club.getContactPhone());
            ps.setString(8, club.getMeetingVenue());
            ps.setString(9, club.getStatus());
            ps.setInt(10, club.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int clubId, String status) {
        String sql = "UPDATE clubs SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignHead(int clubId, Integer headUserId) {
        String sql = "UPDATE clubs SET head_user_id = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (headUserId != null && headUserId > 0) {
                ps.setInt(1, headUserId);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setInt(2, clubId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotalClubs() {
        String sql = "SELECT COUNT(*) FROM clubs WHERE status = 'ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Club> searchClubs(String keyword, String category) {
        List<Club> clubs = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, u.full_name AS head_name, u.email AS head_email, " +
            "(SELECT COUNT(*) FROM club_members cm WHERE cm.club_id = c.id AND cm.status = 'ACTIVE') AS member_count, " +
            "(SELECT COUNT(*) FROM events e WHERE e.club_id = c.id) AS event_count " +
            "FROM clubs c " +
            "LEFT JOIN users u ON c.head_user_id = u.id WHERE 1=1 ");

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.name LIKE ? OR c.description LIKE ? OR c.club_code LIKE ?) ");
            String term = "%" + keyword.trim() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }
        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("ALL")) {
            sql.append("AND c.category = ? ");
            params.add(category.trim());
        }
        sql.append("ORDER BY c.name ASC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    clubs.add(mapClub(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return clubs;
    }

    private Club mapClub(ResultSet rs) throws SQLException {
        Club c = new Club();
        c.setId(rs.getInt("id"));
        c.setClubCode(rs.getString("club_code"));
        c.setName(rs.getString("name"));
        c.setCategory(rs.getString("category"));
        c.setDescription(rs.getString("description"));
        c.setLogoUrl(rs.getString("logo_url"));
        int headId = rs.getInt("head_user_id");
        if (!rs.wasNull()) {
            c.setHeadUserId(headId);
        }
        c.setFacultyAdvisor(rs.getString("faculty_advisor"));
        c.setContactEmail(rs.getString("contact_email"));
        c.setContactPhone(rs.getString("contact_phone"));
        c.setMeetingVenue(rs.getString("meeting_venue"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));

        c.setHeadUserName(rs.getString("head_name"));
        c.setHeadUserEmail(rs.getString("head_email"));
        c.setMemberCount(rs.getInt("member_count"));
        c.setEventCount(rs.getInt("event_count"));
        return c;
    }
}
