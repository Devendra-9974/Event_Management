package com.clubsphere.service;

import com.clubsphere.dao.NotificationDAO;
import com.clubsphere.dao.TaskDAO;
import com.clubsphere.model.Notification;
import com.clubsphere.model.Task;

import java.util.List;

public class TaskService {
    private final TaskDAO taskDAO = new TaskDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public List<Task> getTasksByClub(int clubId) {
        return taskDAO.findByClubId(clubId);
    }

    public List<Task> getTasksByAssignedUser(int userId) {
        return taskDAO.findByAssignedUser(userId);
    }

    public Task getTaskById(int id) {
        return taskDAO.findById(id);
    }

    public boolean createTask(Task task) {
        boolean created = taskDAO.create(task);
        if (created) {
            // Notify the assigned member
            Notification notif = new Notification(
                task.getAssignedToUserId(),
                "New Task Assigned: " + task.getTitle(),
                "You have been assigned a new task due by " + task.getDueDate() + " with priority " + task.getPriority() + ".",
                "TASK_ASSIGNED"
            );
            notif.setRelatedTaskId(task.getId());
            notif.setRelatedClubId(task.getClubId());
            notificationDAO.create(notif);
        }
        return created;
    }

    public boolean updateTaskStatus(int taskId, String status) {
        return taskDAO.updateStatus(taskId, status);
    }

    public boolean deleteTask(int taskId) {
        return taskDAO.delete(taskId);
    }
}
