package com.clubsphere.service;

import com.clubsphere.dao.ReportDAO;
import com.clubsphere.model.ActivityLog;

import java.util.List;
import java.util.Map;

public class ReportService {
    private final ReportDAO reportDAO = new ReportDAO();

    public void logActivity(Integer userId, String action, String details, String ipAddress) {
        reportDAO.logActivity(userId, action, details, ipAddress);
    }

    public List<ActivityLog> getRecentActivities(int limit) {
        return reportDAO.getRecentActivities(limit);
    }

    public Map<String, Integer> getOverallStats() {
        return reportDAO.getOverallStats();
    }

    public List<Map<String, Object>> getClubWiseStats() {
        return reportDAO.getClubWiseStats();
    }

    public Map<String, Object> getClubSpecificStats(int clubId) {
        return reportDAO.getClubSpecificStats(clubId);
    }
}
