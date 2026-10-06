package com.clubsphere.controller;

import com.clubsphere.model.*;
import com.clubsphere.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

@WebServlet("/club-head/*")
public class ClubHeadServlet extends HttpServlet {
    private final ClubService clubService = new ClubService();
    private final EventService eventService = new EventService();
    private final RegistrationService registrationService = new RegistrationService();
    private final TaskService taskService = new TaskService();
    private final NotificationService notificationService = new NotificationService();
    private final UserService userService = new UserService();
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        Club managedClub = getManagedClub(currentUser);
        if (managedClub == null) {
            req.setAttribute("errorMessage", "No active club assigned to your account. Please contact the administrator.");
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
            return;
        }

        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            showDashboard(req, resp, managedClub, currentUser);
        } else if (path.equals("/members")) {
            listMembers(req, resp, managedClub);
        } else if (path.equals("/events")) {
            listEvents(req, resp, managedClub);
        } else if (path.equals("/event/create")) {
            showCreateEventForm(req, resp, managedClub);
        } else if (path.equals("/event/edit")) {
            showEditEventForm(req, resp, managedClub);
        } else if (path.equals("/event/qr")) {
            showEventQR(req, resp, managedClub);
        } else if (path.equals("/tasks")) {
            listTasks(req, resp, managedClub);
        } else if (path.equals("/announcements")) {
            listAnnouncements(req, resp, managedClub);
        } else if (path.equals("/registrations")) {
            listRegistrations(req, resp, managedClub);
        } else if (path.equals("/reports")) {
            showReports(req, resp, managedClub);
        } else {
            resp.sendRedirect(req.getContextPath() + "/club-head/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        Club managedClub = getManagedClub(currentUser);
        if (managedClub == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = req.getPathInfo();
        if ("/event/save".equals(path)) {
            saveEvent(req, resp, managedClub, currentUser);
        } else if ("/event/cancel".equals(path)) {
            cancelEvent(req, resp, managedClub);
        } else if ("/member/add".equals(path)) {
            addMember(req, resp, managedClub);
        } else if ("/member/remove".equals(path)) {
            removeMember(req, resp, managedClub);
        } else if ("/task/create".equals(path)) {
            createTask(req, resp, managedClub, currentUser);
        } else if ("/task/update-status".equals(path)) {
            updateTaskStatus(req, resp, managedClub);
        } else if ("/announcement/create".equals(path)) {
            createAnnouncement(req, resp, managedClub, currentUser);
        } else if ("/profile/update".equals(path)) {
            updateClubProfile(req, resp, managedClub);
        } else {
            resp.sendRedirect(req.getContextPath() + "/club-head/dashboard");
        }
    }

    private Club getManagedClub(User user) {
        if (user.getManagedClubId() != null) {
            return clubService.getClubById(user.getManagedClubId());
        }
        Club c = clubService.getClubByHeadUserId(user.getId());
        if (c != null) {
            user.setManagedClubId(c.getId());
            user.setManagedClubName(c.getName());
        }
        return c;
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, Club club, User currentUser)
            throws ServletException, IOException {
        Map<String, Object> stats = reportService.getClubSpecificStats(club.getId());
        List<Event> upcomingEvents = eventService.getEventsByClub(club.getId());
        List<ClubMember> members = clubService.getClubMembers(club.getId());
        List<Task> tasks = taskService.getTasksByClub(club.getId());
        List<Announcement> announcements = notificationService.getAnnouncementsByClub(club.getId());

        req.setAttribute("club", club);
        req.setAttribute("stats", stats);
        req.setAttribute("events", upcomingEvents);
        req.setAttribute("members", members);
        req.setAttribute("tasks", tasks);
        req.setAttribute("announcements", announcements);
        req.getRequestDispatcher("/WEB-INF/views/club-head/dashboard.jsp").forward(req, resp);
    }

    private void listMembers(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        List<ClubMember> members = clubService.getClubMembers(club.getId());
        List<User> allStudents = userService.getUsersByRole("STUDENT");
        req.setAttribute("club", club);
        req.setAttribute("members", members);
        req.setAttribute("availableStudents", allStudents);
        req.getRequestDispatcher("/WEB-INF/views/club-head/members.jsp").forward(req, resp);
    }

    private void addMember(HttpServletRequest req, HttpServletResponse resp, Club club) throws IOException {
        String studentIdStr = req.getParameter("userId");
        String role = req.getParameter("memberRole");
        String notes = req.getParameter("notes");
        if (studentIdStr != null) {
            int uid = Integer.parseInt(studentIdStr);
            clubService.addMember(club.getId(), uid, role, notes);
            // Upgrade role to CLUB_MEMBER if currently STUDENT
            User target = userService.getUserById(uid);
            if (target != null && "STUDENT".equalsIgnoreCase(target.getRole())) {
                userService.changeRole(uid, "CLUB_MEMBER");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/members?message=Member+added+successfully");
    }

    private void removeMember(HttpServletRequest req, HttpServletResponse resp, Club club) throws IOException {
        String userIdStr = req.getParameter("userId");
        if (userIdStr != null) {
            int uid = Integer.parseInt(userIdStr);
            clubService.removeMember(club.getId(), uid);
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/members?message=Member+removed+successfully");
    }

    private void listEvents(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        List<Event> events = eventService.getEventsByClub(club.getId());
        req.setAttribute("club", club);
        req.setAttribute("events", events);
        req.getRequestDispatcher("/WEB-INF/views/club-head/events.jsp").forward(req, resp);
    }

    private void showCreateEventForm(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        req.setAttribute("club", club);
        req.getRequestDispatcher("/WEB-INF/views/club-head/event-form.jsp").forward(req, resp);
    }

    private void showEditEventForm(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        String eventIdStr = req.getParameter("id");
        if (eventIdStr != null) {
            Event event = eventService.getEventById(Integer.parseInt(eventIdStr));
            if (event != null && event.getClubId() == club.getId()) {
                req.setAttribute("event", event);
                req.setAttribute("club", club);
                req.getRequestDispatcher("/WEB-INF/views/club-head/event-form.jsp").forward(req, resp);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/events");
    }

    private void saveEvent(HttpServletRequest req, HttpServletResponse resp, Club club, User currentUser) throws IOException {
        String eventIdStr = req.getParameter("id");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String dateStr = req.getParameter("eventDate");
        String startTimeStr = req.getParameter("startTime") + ":00";
        String endTimeStr = req.getParameter("endTime") + ":00";
        String venue = req.getParameter("venue");
        String deadlineStr = req.getParameter("registrationDeadline");
        String capacityStr = req.getParameter("capacity");
        String eventType = req.getParameter("eventType");
        String participationType = req.getParameter("participationType");
        String status = req.getParameter("status");

        Event event = new Event();
        event.setClubId(club.getId());
        event.setTitle(title);
        event.setDescription(description);
        event.setEventDate(Date.valueOf(dateStr));
        event.setStartTime(Time.valueOf(startTimeStr));
        event.setEndTime(Time.valueOf(endTimeStr));
        event.setVenue(venue);
        event.setRegistrationDeadline(Timestamp.valueOf(deadlineStr.replace("T", " ") + ":00"));
        event.setCapacity(Integer.parseInt(capacityStr));
        event.setEventType(eventType);
        event.setParticipationType(participationType);
        event.setStatus(status != null ? status : "REGISTRATION_OPEN");
        event.setCreatedByUserId(currentUser.getId());

        if (eventIdStr != null && !eventIdStr.isEmpty()) {
            event.setId(Integer.parseInt(eventIdStr));
            eventService.updateEvent(event);
        } else {
            eventService.createEvent(event);
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/events?message=Event+saved+successfully");
    }

    private void cancelEvent(HttpServletRequest req, HttpServletResponse resp, Club club) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Event evt = eventService.getEventById(id);
            if (evt != null && evt.getClubId() == club.getId()) {
                eventService.updateStatus(id, "CANCELLED");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/events?message=Event+cancelled");
    }

    private void showEventQR(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            Event event = eventService.getEventById(Integer.parseInt(idStr));
            if (event != null && event.getClubId() == club.getId()) {
                req.setAttribute("event", event);
                req.setAttribute("club", club);
                req.getRequestDispatcher("/WEB-INF/views/club-head/event-qr.jsp").forward(req, resp);
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/events");
    }

    private void listTasks(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        List<Task> tasks = taskService.getTasksByClub(club.getId());
        List<ClubMember> members = clubService.getClubMembers(club.getId());
        List<Event> events = eventService.getEventsByClub(club.getId());

        req.setAttribute("club", club);
        req.setAttribute("tasks", tasks);
        req.setAttribute("members", members);
        req.setAttribute("events", events);
        req.getRequestDispatcher("/WEB-INF/views/club-head/tasks.jsp").forward(req, resp);
    }

    private void createTask(HttpServletRequest req, HttpServletResponse resp, Club club, User currentUser) throws IOException {
        String title = req.getParameter("title");
        String desc = req.getParameter("description");
        String assignedToStr = req.getParameter("assignedToUserId");
        String eventIdStr = req.getParameter("eventId");
        String dueDateStr = req.getParameter("dueDate");
        String priority = req.getParameter("priority");

        Task t = new Task();
        t.setClubId(club.getId());
        t.setTitle(title);
        t.setDescription(desc);
        t.setAssignedToUserId(Integer.parseInt(assignedToStr));
        t.setAssignedByUserId(currentUser.getId());
        if (eventIdStr != null && !eventIdStr.isEmpty()) {
            t.setEventId(Integer.parseInt(eventIdStr));
        }
        t.setDueDate(Date.valueOf(dueDateStr));
        t.setPriority(priority != null ? priority : "MEDIUM");
        t.setStatus("PENDING");

        taskService.createTask(t);
        resp.sendRedirect(req.getContextPath() + "/club-head/tasks?message=Task+assigned+successfully");
    }

    private void updateTaskStatus(HttpServletRequest req, HttpServletResponse resp, Club club) throws IOException {
        String taskIdStr = req.getParameter("taskId");
        String status = req.getParameter("status");
        if (taskIdStr != null && status != null) {
            taskService.updateTaskStatus(Integer.parseInt(taskIdStr), status);
        }
        resp.sendRedirect(req.getContextPath() + "/club-head/tasks?message=Task+status+updated");
    }

    private void listAnnouncements(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        List<Announcement> announcements = notificationService.getAnnouncementsByClub(club.getId());
        req.setAttribute("club", club);
        req.setAttribute("announcements", announcements);
        req.getRequestDispatcher("/WEB-INF/views/club-head/announcements.jsp").forward(req, resp);
    }

    private void createAnnouncement(HttpServletRequest req, HttpServletResponse resp, Club club, User currentUser) throws IOException {
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String priority = req.getParameter("priority");
        String targetRole = req.getParameter("targetRole");

        Announcement a = new Announcement();
        a.setClubId(club.getId());
        a.setCreatedByUserId(currentUser.getId());
        a.setTitle(title);
        a.setContent(content);
        a.setPriority(priority != null ? priority : "NORMAL");
        a.setTargetRole(targetRole != null ? targetRole : "ALL");

        notificationService.publishAnnouncement(a);
        resp.sendRedirect(req.getContextPath() + "/club-head/announcements?message=Announcement+published");
    }

    private void listRegistrations(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        List<Registration> registrations = registrationService.getClubRegistrations(club.getId());
        req.setAttribute("club", club);
        req.setAttribute("registrations", registrations);
        req.getRequestDispatcher("/WEB-INF/views/club-head/registrations.jsp").forward(req, resp);
    }

    private void showReports(HttpServletRequest req, HttpServletResponse resp, Club club) throws ServletException, IOException {
        Map<String, Object> stats = reportService.getClubSpecificStats(club.getId());
        List<Event> events = eventService.getEventsByClub(club.getId());
        List<Registration> registrations = registrationService.getClubRegistrations(club.getId());
        req.setAttribute("club", club);
        req.setAttribute("stats", stats);
        req.setAttribute("events", events);
        req.setAttribute("registrations", registrations);
        req.getRequestDispatcher("/WEB-INF/views/club-head/reports.jsp").forward(req, resp);
    }

    private void updateClubProfile(HttpServletRequest req, HttpServletResponse resp, Club club) throws IOException {
        club.setDescription(req.getParameter("description"));
        club.setContactEmail(req.getParameter("contactEmail"));
        club.setContactPhone(req.getParameter("contactPhone"));
        club.setMeetingVenue(req.getParameter("meetingVenue"));
        club.setFacultyAdvisor(req.getParameter("facultyAdvisor"));

        clubService.updateClub(club);
        resp.sendRedirect(req.getContextPath() + "/club-head/dashboard?message=Club+profile+updated");
    }
}
