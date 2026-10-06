package com.clubsphere.controller;

import com.clubsphere.model.User;
import com.clubsphere.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("currentUser");
            if (user != null) {
                reportService.logActivity(user.getId(), "LOGOUT", "User logged out successfully", req.getRemoteAddr());
            }
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp?message=You+have+been+logged+out+successfully.");
    }
}
