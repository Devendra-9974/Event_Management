package com.clubsphere.service;

import com.clubsphere.dao.EventDAO;
import com.clubsphere.dao.NotificationDAO;
import com.clubsphere.dao.RegistrationDAO;
import com.clubsphere.model.Event;
import com.clubsphere.model.EventParticipant;
import com.clubsphere.model.Notification;
import com.clubsphere.model.Registration;

import java.util.List;
import java.util.UUID;

public class RegistrationService {
    private final RegistrationDAO registrationDAO = new RegistrationDAO();
    private final EventDAO eventDAO = new EventDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public record RegistrationResult(boolean success, String message, Registration registration) {}

    public RegistrationResult registerForEvent(Registration registration, List<EventParticipant> participants) {
        Event event = eventDAO.findById(registration.getEventId());
        if (event == null) {
            return new RegistrationResult(false, "Event not found.", null);
        }

        if ("CANCELLED".equalsIgnoreCase(event.getStatus())) {
            return new RegistrationResult(false, "This event has been cancelled.", null);
        }

        if ("COMPLETED".equalsIgnoreCase(event.getStatus()) || "REGISTRATION_CLOSED".equalsIgnoreCase(event.getStatus())) {
            return new RegistrationResult(false, "Registrations are closed for this event.", null);
        }

        // Deadline check
        if (event.getRegistrationDeadline() != null && System.currentTimeMillis() > event.getRegistrationDeadline().getTime()) {
            return new RegistrationResult(false, "Registration deadline has already passed.", null);
        }

        // Capacity check
        if (event.getCapacity() > 0 && event.getRegisteredCount() >= event.getCapacity()) {
            return new RegistrationResult(false, "Event capacity has been reached.", null);
        }

        // Duplicate registration check
        if (registrationDAO.isUserRegistered(event.getId(), registration.getUserId())) {
            return new RegistrationResult(false, "You are already registered for this event.", null);
        }

        // Generate registration number
        String regNum = "REG-" + System.currentTimeMillis() % 1000000 + "-" + UUID.randomUUID().toString().substring(0, 4).toUpperCase();
        registration.setRegistrationNumber(regNum);
        registration.setStatus("CONFIRMED");

        boolean created = registrationDAO.createRegistrationWithParticipants(registration, participants);
        if (created) {
            // Trigger confirmation notification to the student
            Notification notif = new Notification(
                registration.getUserId(),
                "Registration Confirmed: " + event.getTitle(),
                "Your registration (" + regNum + ") has been confirmed for " + event.getTitle() + " at " + event.getVenue() + ".",
                "REGISTRATION_CONFIRMED"
            );
            notif.setRelatedEventId(event.getId());
            notif.setRelatedClubId(event.getClubId());
            notificationDAO.create(notif);

            return new RegistrationResult(true, "Registration successful!", registration);
        } else {
            return new RegistrationResult(false, "Registration could not be completed. Please try again.", null);
        }
    }

    public boolean isRegistered(int eventId, int userId) {
        return registrationDAO.isUserRegistered(eventId, userId);
    }

    public List<Registration> getUserRegistrations(int userId) {
        return registrationDAO.findByUserId(userId);
    }

    public List<Registration> getEventRegistrations(int eventId) {
        return registrationDAO.findByEventId(eventId);
    }

    public List<Registration> getClubRegistrations(int clubId) {
        return registrationDAO.findByClubId(clubId);
    }

    public List<Registration> getAllRegistrations() {
        return registrationDAO.findAll();
    }

    public Registration getRegistration(int userId, int eventId) {
        return registrationDAO.findByUserAndEvent(userId, eventId);
    }

    public boolean cancelRegistration(int registrationId) {
        return registrationDAO.updateStatus(registrationId, "CANCELLED");
    }

    public int countTotalRegistrations() {
        return registrationDAO.countTotalRegistrations();
    }
}
