package com.clubsphere.service;

import com.clubsphere.dao.UserDAO;
import com.clubsphere.model.User;
import com.clubsphere.util.PasswordUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

public class UserService {
    private final UserDAO userDAO = new UserDAO();

    public User login(String usernameOrEmail, String plainPassword) {
        if (usernameOrEmail == null || plainPassword == null) return null;
        User user = userDAO.authenticate(usernameOrEmail.trim());
        if (user != null) {
            if (PasswordUtil.checkPassword(plainPassword, user.getPasswordHash())) {
                // If user logged in with a non-standard hash or seed placeholder, upgrade it to a standard BCrypt hash
                if (!BCrypt.checkpw(plainPassword, user.getPasswordHash())) {
                    changePassword(user.getId(), plainPassword);
                }
                return user;
            }
        }
        return null;
    }

    public User getUserById(int id) {
        return userDAO.findById(id);
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public List<User> getUsersByRole(String role) {
        return userDAO.findByRole(role);
    }

    public boolean registerUser(User user, String plainPassword) {
        if (userDAO.findByUsername(user.getUsername()) != null) {
            return false;
        }
        user.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
        return userDAO.create(user);
    }

    public boolean updateUser(User user) {
        return userDAO.update(user);
    }

    public boolean changePassword(int userId, String newPlainPassword) {
        String hash = PasswordUtil.hashPassword(newPlainPassword);
        return userDAO.updatePassword(userId, hash);
    }

    public boolean changeRole(int userId, String role) {
        return userDAO.updateRole(userId, role);
    }

    public int countStudents() {
        return userDAO.countByRole("STUDENT");
    }

    public int countMembers() {
        return userDAO.countByRole("CLUB_MEMBER");
    }
}
