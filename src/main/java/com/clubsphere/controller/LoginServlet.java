package com.clubsphere.controller;

import com.clubsphere.model.Club;
import com.clubsphere.model.User;
import com.clubsphere.service.ClubService;
import com.clubsphere.service.NotificationService;
import com.clubsphere.service.ReportService;
import com.clubsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final ClubService clubService = new ClubService();
    private final NotificationService notificationService = new NotificationService();
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            redirectToDashboard(user, req, resp);
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("username");
        String password = req.getParameter("password");

        if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Please provide both username/email and password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = userService.login(usernameOrEmail.trim(), password.trim());
        if (user == null) {
            req.setAttribute("errorMessage", "Invalid username/email or password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // If user is CLUB_HEAD, find their managed club
        if ("CLUB_HEAD".equalsIgnoreCase(user.getRole())) {
            Club managedClub = clubService.getClubByHeadUserId(user.getId());
            if (managedClub != null) {
                user.setManagedClubId(managedClub.getId());
                user.setManagedClubName(managedClub.getName());
            }
        }

        // Start session
        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);
        session.setAttribute("unreadCount", notificationService.getUnreadCount(user.getId()));

        // Audit log
        reportService.logActivity(user.getId(), "LOGIN", "User logged in with role " + user.getRole(), req.getRemoteAddr());

        redirectToDashboard(user, req, resp);
    }

    private void redirectToDashboard(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String role = user.getRole();
        if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if ("CLUB_HEAD".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/club-head/dashboard");
        } else if ("CLUB_MEMBER".equalsIgnoreCase(role)) {
            resp.sendRedirect(req.getContextPath() + "/club-member/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}
