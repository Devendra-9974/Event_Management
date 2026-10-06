package com.clubsphere.service;

import com.clubsphere.dao.EventDAO;
import com.clubsphere.model.Event;

import java.util.List;
import java.util.UUID;

public class EventService {
    private final EventDAO eventDAO = new EventDAO();

    public List<Event> getAllEvents() {
        return eventDAO.findAll();
    }

    public List<Event> getUpcomingEvents() {
        return eventDAO.findUpcoming();
    }

    public List<Event> getEventsByClub(int clubId) {
        return eventDAO.findByClubId(clubId);
    }

    public Event getEventById(int id) {
        return eventDAO.findById(id);
    }

    public Event getEventByQrToken(String token) {
        return eventDAO.findByQrToken(token);
    }

    public boolean createEvent(Event event) {
        // Validation rules
        if (event.getRegistrationDeadline() != null && event.getEventDate() != null) {
            long deadlineMillis = event.getRegistrationDeadline().getTime();
            long eventDateMillis = event.getEventDate().getTime();
            if (deadlineMillis > eventDateMillis + 86400000L) { // Allow up to end of event day
                // Deadline cannot be far past event
            }
        }
        if (event.getCapacity() <= 0) {
            event.setCapacity(50);
        }
        if (event.getQrToken() == null || event.getQrToken().trim().isEmpty()) {
            event.setQrToken("QR_" + UUID.randomUUID().toString().replace("-", "").substring(0, 16).toUpperCase());
        }
        return eventDAO.create(event);
    }

    public boolean updateEvent(Event event) {
        return eventDAO.update(event);
    }

    public boolean updateStatus(int eventId, String status) {
        return eventDAO.updateStatus(eventId, status);
    }

    public List<Event> searchEvents(String keyword, Integer clubId, String eventType, String status) {
        return eventDAO.searchEvents(keyword, clubId, eventType, status);
    }

    public int countTotalEvents() {
        return eventDAO.countTotalEvents();
    }

    public int countUpcomingEvents() {
        return eventDAO.countUpcomingEvents();
    }
}
