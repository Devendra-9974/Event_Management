package com.clubsphere.service;

import com.clubsphere.dao.AnnouncementDAO;
import com.clubsphere.dao.NotificationDAO;
import com.clubsphere.model.Announcement;
import com.clubsphere.model.Notification;

import java.util.List;

public class NotificationService {
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final AnnouncementDAO announcementDAO = new AnnouncementDAO();

    public List<Notification> getUserNotifications(int userId) {
        return notificationDAO.findByUserId(userId);
    }

    public int getUnreadCount(int userId) {
        return notificationDAO.countUnreadByUserId(userId);
    }

    public boolean markAsRead(int notificationId, int userId) {
        return notificationDAO.markAsRead(notificationId, userId);
    }

    public boolean markAllAsRead(int userId) {
        return notificationDAO.markAllAsRead(userId);
    }

    public boolean sendNotification(Notification notification) {
        return notificationDAO.create(notification);
    }

    // Announcements
    public List<Announcement> getAnnouncementsByClub(int clubId) {
        return announcementDAO.findByClubId(clubId);
    }

    public List<Announcement> getPublicAnnouncements() {
        return announcementDAO.findPublicAnnouncements();
    }

    public boolean publishAnnouncement(Announcement announcement) {
        boolean created = announcementDAO.create(announcement);
        if (created) {
            // Broadcast notification to active users
            notificationDAO.notifyAllUsers(
                "Club Announcement: " + announcement.getTitle(),
                announcement.getContent(),
                "CLUB_ANNOUNCEMENT",
                announcement.getClubId(),
                null
            );
        }
        return created;
    }

    public boolean deleteAnnouncement(int id) {
        return announcementDAO.delete(id);
    }
}
