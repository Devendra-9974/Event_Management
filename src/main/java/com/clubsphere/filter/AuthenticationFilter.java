package com.clubsphere.filter;

import com.clubsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Robust authentication and Role-Based Access Control (RBAC) filter.
 * Prevents unauthorized URL-tampering and protects sensitive views.
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String contextPath = httpRequest.getContextPath();
        String uri = httpRequest.getRequestURI();
        String path = uri.substring(contextPath.length());

        // Whitelist public assets and endpoints
        boolean isPublicResource = path.startsWith("/css/") ||
                                   path.startsWith("/js/") ||
                                   path.startsWith("/images/") ||
                                   path.startsWith("/uploads/") ||
                                   path.equals("/") ||
                                   path.equals("/index.jsp") ||
                                   path.equals("/login") ||
                                   path.equals("/login.jsp") ||
                                   path.equals("/logout") ||
                                   path.equals("/register") ||
                                   path.startsWith("/clubs") ||
                                   path.startsWith("/events") ||
                                   path.startsWith("/qr/");

        HttpSession session = httpRequest.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // If trying to access protected areas while not logged in
        if (!isPublicResource && currentUser == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=Please+login+to+continue");
            return;
        }

        // Role-based authorization rules
        if (currentUser != null) {
            String role = currentUser.getRole();

            // 1. Admin area protection
            if (path.startsWith("/admin/") || path.startsWith("/admin")) {
                if (!"ADMIN".equalsIgnoreCase(role)) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin privileges required.");
                    return;
                }
            }

            // 2. Club Head area protection
            if (path.startsWith("/club-head/") || path.startsWith("/club-head")) {
                if (!"CLUB_HEAD".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Club Head privileges required.");
                    return;
                }
            }

            // 3. Club Member area protection
            if (path.startsWith("/club-member/") || path.startsWith("/club-member")) {
                if (!"CLUB_MEMBER".equalsIgnoreCase(role) && !"CLUB_HEAD".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Club Member privileges required.");
                    return;
                }
            }

            // 4. Student area protection
            if (path.startsWith("/student/") || path.startsWith("/student")) {
                // Students and above can access student dashboard/registrations
                if (currentUser == null) {
                    httpResponse.sendRedirect(contextPath + "/login.jsp");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
