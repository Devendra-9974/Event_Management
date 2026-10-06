package com.clubsphere.controller;

import com.clubsphere.model.Club;
import com.clubsphere.model.Event;
import com.clubsphere.model.Registration;
import com.clubsphere.model.User;
import com.clubsphere.service.ClubService;
import com.clubsphere.service.EventService;
import com.clubsphere.service.RegistrationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/events")
public class EventServlet extends HttpServlet {
    private final EventService eventService = new EventService();
    private final ClubService clubService = new ClubService();
    private final RegistrationService registrationService = new RegistrationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "view":
                viewEventDetails(req, resp);
                break;
            case "list":
            default:
                listEvents(req, resp);
                break;
        }
    }

    private void listEvents(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("search");
        String eventType = req.getParameter("type");
        String clubIdStr = req.getParameter("clubId");
        Integer clubId = null;
        if (clubIdStr != null && !clubIdStr.isEmpty()) {
            try { clubId = Integer.parseInt(clubIdStr); } catch (NumberFormatException ignored) {}
        }

        List<Event> events = eventService.searchEvents(keyword, clubId, eventType, "ALL");
        List<Club> allClubs = clubService.getAllClubs();

        // Check registration status for logged in student
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            for (Event e : events) {
                e.setRegisteredByCurrentUser(registrationService.isRegistered(e.getId(), user.getId()));
            }
        }

        req.setAttribute("events", events);
        req.setAttribute("allClubs", allClubs);
        req.setAttribute("selectedClubId", clubId);
        req.setAttribute("selectedType", eventType);
        req.setAttribute("keyword", keyword);
        req.getRequestDispatcher("/events/list.jsp").forward(req, resp);
    }

    private void viewEventDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        try {
            int eventId = Integer.parseInt(idStr);
            Event event = eventService.getEventById(eventId);
            if (event == null) {
                resp.sendRedirect(req.getContextPath() + "/events");
                return;
            }

            HttpSession session = req.getSession(false);
            if (session != null && session.getAttribute("currentUser") != null) {
                User user = (User) session.getAttribute("currentUser");
                boolean isReg = registrationService.isRegistered(eventId, user.getId());
                event.setRegisteredByCurrentUser(isReg);
                if (isReg) {
                    Registration reg = registrationService.getRegistration(user.getId(), eventId);
                    req.setAttribute("userRegistration", reg);
                }
            }

            req.setAttribute("event", event);
            req.getRequestDispatcher("/events/view.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/events");
        }
    }
}
