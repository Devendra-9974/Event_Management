package com.clubsphere.controller;

import com.clubsphere.model.Notification;
import com.clubsphere.model.User;
import com.clubsphere.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/notifications/*")
public class NotificationServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getPathInfo();
        if ("/mark-all-read".equals(path)) {
            notificationService.markAllAsRead(currentUser.getId());
            session.setAttribute("unreadCount", 0);
            resp.sendRedirect(req.getContextPath() + "/notifications");
            return;
        }

        List<Notification> notifications = notificationService.getUserNotifications(currentUser.getId());
        req.setAttribute("notifications", notifications);
        req.getRequestDispatcher("/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String notifIdStr = req.getParameter("id");
        if (notifIdStr != null) {
            try {
                int id = Integer.parseInt(notifIdStr);
                notificationService.markAsRead(id, currentUser.getId());
                int unread = notificationService.getUnreadCount(currentUser.getId());
                session.setAttribute("unreadCount", unread);
                resp.getWriter().write("{\"success\":true, \"unread\":" + unread + "}");
                return;
            } catch (Exception ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/notifications");
    }
}
