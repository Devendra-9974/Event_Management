package com.clubsphere.controller;

import com.clubsphere.model.Event;
import com.clubsphere.model.EventParticipant;
import com.clubsphere.model.Registration;
import com.clubsphere.model.User;
import com.clubsphere.service.EventService;
import com.clubsphere.service.RegistrationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/event/register")
public class RegistrationServlet extends HttpServlet {
    private final EventService eventService = new EventService();
    private final RegistrationService registrationService = new RegistrationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            String returnUrl = req.getRequestURI();
            if (req.getQueryString() != null) returnUrl += "?" + req.getQueryString();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please+login+to+register+for+events.&redirect=" + returnUrl);
            return;
        }

        // Support lookup by eventId or qr token
        String eventIdStr = req.getParameter("eventId");
        String token = req.getParameter("token");
        Event event = null;

        if (token != null && !token.trim().isEmpty()) {
            event = eventService.getEventByQrToken(token.trim());
        } else if (eventIdStr != null && !eventIdStr.trim().isEmpty()) {
            try {
                int eventId = Integer.parseInt(eventIdStr.trim());
                event = eventService.getEventById(eventId);
            } catch (NumberFormatException ignored) {}
        }

        if (event == null) {
            req.setAttribute("errorMessage", "The requested event was not found or the registration link has expired.");
            req.getRequestDispatcher("/events/list.jsp").forward(req, resp);
            return;
        }

        // Check if user already registered
        boolean alreadyRegistered = registrationService.isRegistered(event.getId(), currentUser.getId());
        if (alreadyRegistered) {
            Registration existingReg = registrationService.getRegistration(currentUser.getId(), event.getId());
            req.setAttribute("registration", existingReg);
            req.setAttribute("event", event);
            req.setAttribute("message", "You are already registered for this event.");
            req.getRequestDispatcher("/events/confirmation.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("event", event);
        req.setAttribute("currentUser", currentUser);
        req.getRequestDispatcher("/events/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String eventIdStr = req.getParameter("eventId");
        String regType = req.getParameter("registrationType"); // INDIVIDUAL or GROUP
        String groupName = req.getParameter("groupName");
        String specialRequirements = req.getParameter("specialRequirements");

        int eventId = 0;
        try {
            eventId = Integer.parseInt(eventIdStr);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        Event event = eventService.getEventById(eventId);
        if (event == null) {
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        Registration reg = new Registration();
        reg.setEventId(eventId);
        reg.setUserId(currentUser.getId());
        reg.setSpecialRequirements(specialRequirements);

        List<EventParticipant> participants = new ArrayList<>();

        if ("GROUP".equalsIgnoreCase(regType)) {
            reg.setRegistrationType("GROUP");
            reg.setGroupName(groupName != null && !groupName.trim().isEmpty() ? groupName.trim() : "Team " + currentUser.getFullName());

            // Add leader as participant 1
            participants.add(new EventParticipant(currentUser.getFullName(), currentUser.getStudentId(), currentUser.getEmail(), currentUser.getPhone(), true));

            // Extract teammate dynamic inputs
            String[] memberNames = req.getParameterValues("memberName[]");
            String[] memberIds = req.getParameterValues("memberId[]");
            String[] memberEmails = req.getParameterValues("memberEmail[]");
            String[] memberPhones = req.getParameterValues("memberPhone[]");

            if (memberNames != null) {
                for (int i = 0; i < memberNames.length; i++) {
                    if (memberNames[i] != null && !memberNames[i].trim().isEmpty()) {
                        String id = (memberIds != null && i < memberIds.length) ? memberIds[i] : "";
                        String email = (memberEmails != null && i < memberEmails.length) ? memberEmails[i] : "";
                        String phone = (memberPhones != null && i < memberPhones.length) ? memberPhones[i] : "";
                        participants.add(new EventParticipant(memberNames[i].trim(), id.trim(), email.trim(), phone.trim(), false));
                    }
                }
            }
            reg.setGroupSize(participants.size());
        } else {
            reg.setRegistrationType("INDIVIDUAL");
            reg.setGroupSize(1);
            participants.add(new EventParticipant(currentUser.getFullName(), currentUser.getStudentId(), currentUser.getEmail(), currentUser.getPhone(), true));
        }

        RegistrationService.RegistrationResult result = registrationService.registerForEvent(reg, participants);

        if (result.success()) {
            req.setAttribute("registration", reg);
            req.setAttribute("event", event);
            req.setAttribute("successMessage", "Event registration completed successfully!");
            req.getRequestDispatcher("/events/confirmation.jsp").forward(req, resp);
        } else {
            req.setAttribute("errorMessage", result.message());
            req.setAttribute("event", event);
            req.setAttribute("currentUser", currentUser);
            req.getRequestDispatcher("/events/register.jsp").forward(req, resp);
        }
    }
}
