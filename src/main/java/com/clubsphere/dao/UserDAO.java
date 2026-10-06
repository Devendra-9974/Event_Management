package com.clubsphere.dao;

import com.clubsphere.model.User;
import com.clubsphere.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User authenticate(String usernameOrEmail) {
        String sql = "SELECT u.*, c.id AS managed_club_id, c.name AS managed_club_name " +
                     "FROM users u " +
                     "LEFT JOIN clubs c ON c.head_user_id = u.id " +
                     "WHERE (u.username = ? OR u.email = ?) AND u.status = 'ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserWithClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findById(int id) {
        String sql = "SELECT u.*, c.id AS managed_club_id, c.name AS managed_club_name " +
                     "FROM users u " +
                     "LEFT JOIN clubs c ON c.head_user_id = u.id " +
                     "WHERE u.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserWithClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public User findByUsername(String username) {
        String sql = "SELECT u.*, c.id AS managed_club_id, c.name AS managed_club_name " +
                     "FROM users u " +
                     "LEFT JOIN clubs c ON c.head_user_id = u.id " +
                     "WHERE u.username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUserWithClub(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, c.id AS managed_club_id, c.name AS managed_club_name " +
                     "FROM users u " +
                     "LEFT JOIN clubs c ON c.head_user_id = u.id " +
                     "ORDER BY u.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapUserWithClub(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> findByRole(String role) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT u.*, c.id AS managed_club_id, c.name AS managed_club_name " +
                     "FROM users u " +
                     "LEFT JOIN clubs c ON c.head_user_id = u.id " +
                     "WHERE u.role = ? ORDER BY u.full_name ASC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapUserWithClub(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(User user) {
        String sql = "INSERT INTO users (username, email, password_hash, full_name, role, student_id, phone, department, year_of_study, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getRole());
            ps.setString(6, user.getStudentId());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getDepartment());
            ps.setString(9, user.getYearOfStudy());
            ps.setString(10, user.getStatus() != null ? user.getStatus() : "ACTIVE");

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        user.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, department = ?, year_of_study = ?, status = ?, role = ? " +
                     "WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getDepartment());
            ps.setString(5, user.getYearOfStudy());
            ps.setString(6, user.getStatus());
            ps.setString(7, user.getRole());
            ps.setInt(8, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(int userId, String newHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRole(int userId, String role) {
        String sql = "UPDATE users SET role = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ? AND status = 'ACTIVE'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private User mapUserWithClub(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setRole(rs.getString("role"));
        u.setStudentId(rs.getString("student_id"));
        u.setPhone(rs.getString("phone"));
        u.setDepartment(rs.getString("department"));
        u.setYearOfStudy(rs.getString("year_of_study"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));

        int clubId = rs.getInt("managed_club_id");
        if (!rs.wasNull()) {
            u.setManagedClubId(clubId);
            u.setManagedClubName(rs.getString("managed_club_name"));
        }
        return u;
    }
}
