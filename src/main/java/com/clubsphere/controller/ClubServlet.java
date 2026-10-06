package com.clubsphere.controller;

import com.clubsphere.model.Club;
import com.clubsphere.model.ClubMember;
import com.clubsphere.model.Event;
import com.clubsphere.model.User;
import com.clubsphere.service.ClubService;
import com.clubsphere.service.EventService;
import com.clubsphere.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/clubs")
public class ClubServlet extends HttpServlet {
    private final ClubService clubService = new ClubService();
    private final EventService eventService = new EventService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "explore";

        switch (action) {
            case "view":
                viewClubDetails(req, resp);
                break;
            case "explore":
            default:
                exploreClubs(req, resp);
                break;
        }
    }

    private void exploreClubs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("search");
        String category = req.getParameter("category");

        List<Club> clubs = clubService.searchClubs(keyword, category);
        req.setAttribute("clubs", clubs);
        req.setAttribute("keyword", keyword);
        req.setAttribute("category", category);
        req.setAttribute("totalCount", clubs.size());
        req.getRequestDispatcher("/clubs/explore.jsp").forward(req, resp);
    }

    private void viewClubDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/clubs");
            return;
        }

        try {
            int clubId = Integer.parseInt(idStr);
            Club club = clubService.getClubById(clubId);
            if (club == null) {
                resp.sendRedirect(req.getContextPath() + "/clubs");
                return;
            }

            List<ClubMember> members = clubService.getClubMembers(clubId);
            List<Event> clubEvents = eventService.getEventsByClub(clubId);

            // Check if user is a member
            HttpSession session = req.getSession(false);
            boolean isMember = false;
            if (session != null && session.getAttribute("currentUser") != null) {
                User user = (User) session.getAttribute("currentUser");
                isMember = clubService.isMemberOfClub(user.getId(), clubId);
            }

            req.setAttribute("club", club);
            req.setAttribute("members", members);
            req.setAttribute("events", clubEvents);
            req.setAttribute("isMember", isMember);
            req.getRequestDispatcher("/clubs/view.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/clubs");
        }
    }
}
