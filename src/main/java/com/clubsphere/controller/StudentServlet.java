package com.clubsphere.controller;

import com.clubsphere.model.Club;
import com.clubsphere.model.Event;
import com.clubsphere.model.Registration;
import com.clubsphere.model.User;
import com.clubsphere.service.ClubService;
import com.clubsphere.service.EventService;
import com.clubsphere.service.RegistrationService;
import com.clubsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/*")
public class StudentServlet extends HttpServlet {
    private final RegistrationService registrationService = new RegistrationService();
    private final EventService eventService = new EventService();
    private final ClubService clubService = new ClubService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            showDashboard(req, resp, currentUser);
        } else if (path.equals("/registrations")) {
            listRegistrations(req, resp, currentUser);
        } else if (path.equals("/profile")) {
            showProfile(req, resp, currentUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String path = req.getPathInfo();
        if ("/profile/update".equals(path)) {
            updateProfile(req, resp, currentUser);
        } else if ("/registration/cancel".equals(path)) {
            cancelRegistration(req, resp, currentUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<Registration> myRegistrations = registrationService.getUserRegistrations(user.getId());
        List<Event> upcomingEvents = eventService.getUpcomingEvents();
        List<Club> clubs = clubService.getAllClubs();

        req.setAttribute("registrations", myRegistrations);
        req.setAttribute("upcomingEvents", upcomingEvents);
        req.setAttribute("clubs", clubs);
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }

    private void listRegistrations(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<Registration> myRegistrations = registrationService.getUserRegistrations(user.getId());
        req.setAttribute("registrations", myRegistrations);
        req.getRequestDispatcher("/WEB-INF/views/student/registrations.jsp").forward(req, resp);
    }

    private void showProfile(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        User freshUser = userService.getUserById(user.getId());
        req.setAttribute("user", freshUser);
        req.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(req, resp);
    }

    private void updateProfile(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        currentUser.setFullName(req.getParameter("fullName"));
        currentUser.setEmail(req.getParameter("email"));
        currentUser.setPhone(req.getParameter("phone"));
        currentUser.setDepartment(req.getParameter("department"));
        currentUser.setYearOfStudy(req.getParameter("yearOfStudy"));

        userService.updateUser(currentUser);
        req.getSession().setAttribute("currentUser", currentUser);
        resp.sendRedirect(req.getContextPath() + "/student/profile?message=Profile+updated+successfully");
    }

    private void cancelRegistration(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        String regIdStr = req.getParameter("registrationId");
        if (regIdStr != null) {
            int regId = Integer.parseInt(regIdStr);
            registrationService.cancelRegistration(regId);
        }
        resp.sendRedirect(req.getContextPath() + "/student/registrations?message=Registration+cancelled");
    }
}
