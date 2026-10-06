package com.clubsphere.controller;

import com.clubsphere.model.Club;
import com.clubsphere.model.Event;
import com.clubsphere.model.Registration;
import com.clubsphere.model.User;
import com.clubsphere.service.ClubService;
import com.clubsphere.service.EventService;
import com.clubsphere.service.RegistrationService;
import com.clubsphere.service.ReportService;
import com.clubsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final ClubService clubService = new ClubService();
    private final EventService eventService = new EventService();
    private final RegistrationService registrationService = new RegistrationService();
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            showDashboard(req, resp);
        } else if (path.equals("/clubs")) {
            listClubs(req, resp);
        } else if (path.equals("/club/create")) {
            showCreateClubForm(req, resp);
        } else if (path.equals("/club/edit")) {
            showEditClubForm(req, resp);
        } else if (path.equals("/users")) {
            listUsers(req, resp);
        } else if (path.equals("/events")) {
            listEvents(req, resp);
        } else if (path.equals("/registrations")) {
            listRegistrations(req, resp);
        } else if (path.equals("/reports")) {
            showReports(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/club/save".equals(path)) {
            saveClub(req, resp);
        } else if ("/club/toggle-status".equals(path)) {
            toggleClubStatus(req, resp);
        } else if ("/user/change-role".equals(path)) {
            changeUserRole(req, resp);
        } else if ("/user/create".equals(path)) {
            createUser(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Integer> stats = reportService.getOverallStats();
        List<Club> allClubs = clubService.getAllClubs();
        List<Event> upcomingEvents = eventService.getUpcomingEvents();
        List<Registration> recentRegistrations = registrationService.getAllRegistrations();
        if (recentRegistrations.size() > 10) {
            recentRegistrations = recentRegistrations.subList(0, 10);
        }

        req.setAttribute("stats", stats);
        req.setAttribute("clubs", allClubs);
        req.setAttribute("upcomingEvents", upcomingEvents);
        req.setAttribute("recentRegistrations", recentRegistrations);
        req.setAttribute("recentActivities", reportService.getRecentActivities(8));
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void listClubs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Club> clubs = clubService.getAllClubs();
        List<User> eligibleHeads = userService.getUsersByRole("CLUB_HEAD");
        req.setAttribute("clubs", clubs);
        req.setAttribute("eligibleHeads", eligibleHeads);
        req.getRequestDispatcher("/WEB-INF/views/admin/clubs.jsp").forward(req, resp);
    }

    private void showCreateClubForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<User> eligibleHeads = userService.getUsersByRole("CLUB_HEAD");
        req.setAttribute("eligibleHeads", eligibleHeads);
        req.getRequestDispatcher("/WEB-INF/views/admin/club-form.jsp").forward(req, resp);
    }

    private void showEditClubForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Club club = clubService.getClubById(id);
                req.setAttribute("club", club);
                req.setAttribute("eligibleHeads", userService.getUsersByRole("CLUB_HEAD"));
                req.getRequestDispatcher("/WEB-INF/views/admin/club-form.jsp").forward(req, resp);
                return;
            } catch (NumberFormatException ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/clubs");
    }

    private void saveClub(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String code = req.getParameter("clubCode");
        String name = req.getParameter("name");
        String category = req.getParameter("category");
        String desc = req.getParameter("description");
        String headIdStr = req.getParameter("headUserId");
        String advisor = req.getParameter("facultyAdvisor");
        String email = req.getParameter("contactEmail");
        String phone = req.getParameter("contactPhone");
        String venue = req.getParameter("meetingVenue");
        String status = req.getParameter("status");

        Integer headUserId = null;
        if (headIdStr != null && !headIdStr.isEmpty()) {
            try { headUserId = Integer.parseInt(headIdStr); } catch (NumberFormatException ignored) {}
        }

        Club club = new Club();
        club.setClubCode(code);
        club.setName(name);
        club.setCategory(category);
        club.setDescription(desc);
        club.setHeadUserId(headUserId);
        club.setFacultyAdvisor(advisor);
        club.setContactEmail(email);
        club.setContactPhone(phone);
        club.setMeetingVenue(venue);
        club.setStatus(status != null ? status : "ACTIVE");

        if (idStr != null && !idStr.isEmpty()) {
            club.setId(Integer.parseInt(idStr));
            clubService.updateClub(club);
        } else {
            clubService.createClub(club);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/clubs?message=Club+saved+successfully");
    }

    private void toggleClubStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        String currentStatus = req.getParameter("currentStatus");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            String newStatus = "ACTIVE".equalsIgnoreCase(currentStatus) ? "INACTIVE" : "ACTIVE";
            clubService.updateStatus(id, newStatus);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/clubs?message=Club+status+updated");
    }

    private void listUsers(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String roleFilter = req.getParameter("role");
        List<User> users;
        if (roleFilter != null && !roleFilter.isEmpty() && !roleFilter.equalsIgnoreCase("ALL")) {
            users = userService.getUsersByRole(roleFilter);
        } else {
            users = userService.getAllUsers();
        }
        req.setAttribute("users", users);
        req.setAttribute("selectedRole", roleFilter);
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    private void changeUserRole(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userIdStr = req.getParameter("userId");
        String newRole = req.getParameter("newRole");
        if (userIdStr != null && newRole != null) {
            int uid = Integer.parseInt(userIdStr);
            userService.changeRole(uid, newRole);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=User+role+updated+successfully");
    }

    private void createUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String role = req.getParameter("role");
        String studentId = req.getParameter("studentId");
        String phone = req.getParameter("phone");
        String department = req.getParameter("department");

        User u = new User();
        u.setUsername(username);
        u.setEmail(email);
        u.setFullName(fullName);
        u.setRole(role);
        u.setStudentId(studentId);
        u.setPhone(phone);
        u.setDepartment(department);
        u.setStatus("ACTIVE");

        userService.registerUser(u, password);
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=User+created+successfully");
    }

    private void listEvents(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Event> events = eventService.getAllEvents();
        req.setAttribute("events", events);
        req.getRequestDispatcher("/WEB-INF/views/admin/events.jsp").forward(req, resp);
    }

    private void listRegistrations(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Registration> registrations = registrationService.getAllRegistrations();
        req.setAttribute("registrations", registrations);
        req.getRequestDispatcher("/WEB-INF/views/admin/registrations.jsp").forward(req, resp);
    }

    private void showReports(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("overallStats", reportService.getOverallStats());
        req.setAttribute("clubStats", reportService.getClubWiseStats());
        req.setAttribute("recentActivities", reportService.getRecentActivities(25));
        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }
}
