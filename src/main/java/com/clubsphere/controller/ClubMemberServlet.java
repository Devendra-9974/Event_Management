package com.clubsphere.controller;

import com.clubsphere.model.ClubMember;
import com.clubsphere.model.Event;
import com.clubsphere.model.Task;
import com.clubsphere.model.User;
import com.clubsphere.service.ClubService;
import com.clubsphere.service.EventService;
import com.clubsphere.service.NotificationService;
import com.clubsphere.service.TaskService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/club-member/*")
public class ClubMemberServlet extends HttpServlet {
    private final ClubService clubService = new ClubService();
    private final EventService eventService = new EventService();
    private final TaskService taskService = new TaskService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            showDashboard(req, resp, currentUser);
        } else if (path.equals("/tasks")) {
            listTasks(req, resp, currentUser);
        } else if (path.equals("/events")) {
            listEvents(req, resp, currentUser);
        } else if (path.equals("/announcements")) {
            listAnnouncements(req, resp, currentUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/club-member/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");

        String path = req.getPathInfo();
        if ("/task/update-status".equals(path)) {
            String taskIdStr = req.getParameter("taskId");
            String status = req.getParameter("status");
            if (taskIdStr != null && status != null) {
                int taskId = Integer.parseInt(taskIdStr);
                Task task = taskService.getTaskById(taskId);
                // Ensure task is assigned to this member
                if (task != null && task.getAssignedToUserId() == currentUser.getId()) {
                    taskService.updateTaskStatus(taskId, status);
                }
            }
            resp.sendRedirect(req.getContextPath() + "/club-member/tasks?message=Task+updated+successfully");
        } else {
            resp.sendRedirect(req.getContextPath() + "/club-member/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<ClubMember> memberClubs = clubService.getUserClubs(user.getId());
        List<Task> tasks = taskService.getTasksByAssignedUser(user.getId());
        List<Event> upcomingEvents = eventService.getUpcomingEvents();

        req.setAttribute("memberClubs", memberClubs);
        req.setAttribute("tasks", tasks);
        req.setAttribute("upcomingEvents", upcomingEvents);
        req.getRequestDispatcher("/WEB-INF/views/club-member/dashboard.jsp").forward(req, resp);
    }

    private void listTasks(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<Task> tasks = taskService.getTasksByAssignedUser(user.getId());
        req.setAttribute("tasks", tasks);
        req.getRequestDispatcher("/WEB-INF/views/club-member/tasks.jsp").forward(req, resp);
    }

    private void listEvents(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        List<Event> events = eventService.getUpcomingEvents();
        req.setAttribute("events", events);
        req.getRequestDispatcher("/WEB-INF/views/club-member/events.jsp").forward(req, resp);
    }

    private void listAnnouncements(HttpServletRequest req, HttpServletResponse resp, User user) throws ServletException, IOException {
        req.setAttribute("announcements", notificationService.getPublicAnnouncements());
        req.getRequestDispatcher("/WEB-INF/views/club-member/announcements.jsp").forward(req, resp);
    }
}
