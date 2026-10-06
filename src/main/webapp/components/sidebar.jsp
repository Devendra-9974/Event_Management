<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="sidebar d-none d-md-block">
    <div class="mb-4 px-2">
        <h6 class="text-uppercase text-muted fw-bold small mb-2" style="font-size: 0.72rem; letter-spacing: 0.8px;">Navigation</h6>
    </div>

    <!-- Admin Menu -->
    <c:if test="${sessionScope.currentUser.role == 'ADMIN'}">
        <nav class="nav flex-column mb-4">
            <span class="text-xs text-uppercase fw-bold text-muted px-3 mb-1">Admin Control</span>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-custom ${param.active == 'admin-dash' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/admin/clubs" class="nav-link-custom ${param.active == 'admin-clubs' ? 'active' : ''}">
                <i class="bi bi-collection"></i> Manage 26 Clubs
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-custom ${param.active == 'admin-users' ? 'active' : ''}">
                <i class="bi bi-people"></i> Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/admin/events" class="nav-link-custom ${param.active == 'admin-events' ? 'active' : ''}">
                <i class="bi bi-calendar-check"></i> Monitor Events
            </a>
            <a href="${pageContext.request.contextPath}/admin/registrations" class="nav-link-custom ${param.active == 'admin-regs' ? 'active' : ''}">
                <i class="bi bi-card-checklist"></i> Registrations
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link-custom ${param.active == 'admin-reports' ? 'active' : ''}">
                <i class="bi bi-graph-up-arrow"></i> Reports & Analytics
            </a>
        </nav>
    </c:if>

    <!-- Club Head Menu -->
    <c:if test="${sessionScope.currentUser.role == 'CLUB_HEAD'}">
        <nav class="nav flex-column mb-4">
            <span class="text-xs text-uppercase fw-bold text-muted px-3 mb-1">Club Management</span>
            <a href="${pageContext.request.contextPath}/club-head/dashboard" class="nav-link-custom ${param.active == 'head-dash' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i> Club Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/club-head/members" class="nav-link-custom ${param.active == 'head-members' ? 'active' : ''}">
                <i class="bi bi-people-fill"></i> Club Members
            </a>
            <a href="${pageContext.request.contextPath}/club-head/events" class="nav-link-custom ${param.active == 'head-events' ? 'active' : ''}">
                <i class="bi bi-calendar-event"></i> Manage Events
            </a>
            <a href="${pageContext.request.contextPath}/club-head/registrations" class="nav-link-custom ${param.active == 'head-regs' ? 'active' : ''}">
                <i class="bi bi-pass"></i> Registrations
            </a>
            <a href="${pageContext.request.contextPath}/club-head/tasks" class="nav-link-custom ${param.active == 'head-tasks' ? 'active' : ''}">
                <i class="bi bi-check2-square"></i> Assign & Track Tasks
            </a>
            <a href="${pageContext.request.contextPath}/club-head/announcements" class="nav-link-custom ${param.active == 'head-announce' ? 'active' : ''}">
                <i class="bi bi-megaphone"></i> Announcements
            </a>
            <a href="${pageContext.request.contextPath}/club-head/reports" class="nav-link-custom ${param.active == 'head-reports' ? 'active' : ''}">
                <i class="bi bi-bar-chart"></i> Club Analytics
            </a>
        </nav>
    </c:if>

    <!-- Club Member Menu -->
    <c:if test="${sessionScope.currentUser.role == 'CLUB_MEMBER'}">
        <nav class="nav flex-column mb-4">
            <span class="text-xs text-uppercase fw-bold text-muted px-3 mb-1">Member Workspace</span>
            <a href="${pageContext.request.contextPath}/club-member/dashboard" class="nav-link-custom ${param.active == 'mem-dash' ? 'active' : ''}">
                <i class="bi bi-columns-gap"></i> Workspace
            </a>
            <a href="${pageContext.request.contextPath}/club-member/tasks" class="nav-link-custom ${param.active == 'mem-tasks' ? 'active' : ''}">
                <i class="bi bi-list-task"></i> My Assigned Tasks
            </a>
            <a href="${pageContext.request.contextPath}/club-member/events" class="nav-link-custom ${param.active == 'mem-events' ? 'active' : ''}">
                <i class="bi bi-calendar2-week"></i> Club Events
            </a>
            <a href="${pageContext.request.contextPath}/club-member/announcements" class="nav-link-custom ${param.active == 'mem-announce' ? 'active' : ''}">
                <i class="bi bi-broadcast"></i> Announcements
            </a>
        </nav>
    </c:if>

    <!-- Student / Common Menu -->
    <nav class="nav flex-column">
        <span class="text-xs text-uppercase fw-bold text-muted px-3 mb-1">Student Portal</span>
        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link-custom ${param.active == 'stu-dash' ? 'active' : ''}">
            <i class="bi bi-grid-1x2"></i> Student Hub
        </a>
        <a href="${pageContext.request.contextPath}/clubs" class="nav-link-custom ${param.active == 'stu-clubs' ? 'active' : ''}">
            <i class="bi bi-compass"></i> Explore All Clubs
        </a>
        <a href="${pageContext.request.contextPath}/events" class="nav-link-custom ${param.active == 'stu-events' ? 'active' : ''}">
            <i class="bi bi-ticket-detailed"></i> Browse Events
        </a>
        <a href="${pageContext.request.contextPath}/student/registrations" class="nav-link-custom ${param.active == 'stu-regs' ? 'active' : ''}">
            <i class="bi bi-receipt"></i> Registration History
        </a>
        <a href="${pageContext.request.contextPath}/student/profile" class="nav-link-custom ${param.active == 'stu-prof' ? 'active' : ''}">
            <i class="bi bi-person-lines-fill"></i> My Profile
        </a>
    </nav>
</div>
