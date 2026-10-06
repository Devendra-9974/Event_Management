<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-dash"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Administrative Overview</h3>
                <p class="text-muted small mb-0">Central command for Arya College of Engineering & IT clubs and activities</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/club/create" class="btn btn-primary btn-sm fw-semibold">
                    <i class="bi bi-plus-lg me-1"></i> Add New Club
                </a>
            </div>
        </div>

        <!-- Metric Stat Cards -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-collection-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalClubs}</h4>
                        <span class="text-muted small">Total Active Clubs</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="bi bi-mortarboard-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalStudents}</h4>
                        <span class="text-muted small">Registered Students</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-people-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalMembers}</h4>
                        <span class="text-muted small">Club Core Members</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="bi bi-calendar2-check-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.upcomingEvents} / ${stats.totalEvents}</h4>
                        <span class="text-muted small">Upcoming / Total Events</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Overview Grid -->
        <div class="row g-4 mb-4">
            <!-- Clubs Snapshot -->
            <div class="col-lg-7">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">College Clubs (26 Total)</h5>
                        <a href="${pageContext.request.contextPath}/admin/clubs" class="small fw-semibold text-primary">View All &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-custom align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Club Name</th>
                                    <th>Category</th>
                                    <th>Club Head</th>
                                    <th>Members</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${clubs}" begin="0" end="5">
                                    <tr>
                                        <td>
                                            <div class="fw-bold text-dark">${c.name}</div>
                                            <code class="small text-muted">${c.clubCode}</code>
                                        </td>
                                        <td><span class="badge bg-light text-secondary border">${c.category}</span></td>
                                        <td>${not empty c.headUserName ? c.headUserName : '<span class=\"text-muted small\">None</span>'}</td>
                                        <td>${c.memberCount}</td>
                                        <td><span class="badge ${c.status == 'ACTIVE' ? 'badge-soft-success' : 'badge-soft-danger'}">${c.status}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Recent System Activities -->
            <div class="col-lg-5">
                <div class="card card-custom p-4 h-100">
                    <h5 class="fw-bold mb-3">Recent System Audit Logs</h5>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="act" items="${recentActivities}">
                            <div class="d-flex gap-3 align-items-start border-bottom pb-2">
                                <div class="bg-light p-2 rounded-circle text-primary mt-1">
                                    <i class="bi bi-activity"></i>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between">
                                        <strong class="small text-dark">${act.action}</strong>
                                        <span class="text-muted small" style="font-size: 0.72rem;">${act.createdAt}</span>
                                    </div>
                                    <div class="text-secondary small">${act.details}</div>
                                    <div class="text-muted small" style="font-size: 0.75rem;">By: ${not empty act.userName ? act.userName : 'System'} (${act.userRole})</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Upcoming Events & Recent Registrations -->
        <div class="row g-4">
            <div class="col-lg-6">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Upcoming Events</h5>
                        <a href="${pageContext.request.contextPath}/admin/events" class="small fw-semibold text-primary">View All &rarr;</a>
                    </div>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="e" items="${upcomingEvents}">
                            <div class="p-3 bg-light rounded-3 d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="fw-bold text-dark">${e.title}</div>
                                    <div class="small text-muted">${e.clubName} &bull; ${e.eventDate}</div>
                                </div>
                                <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : 'badge-soft-warning'}">
                                    ${e.registeredCount} / ${e.capacity} Registered
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Recent Event Registrations</h5>
                        <a href="${pageContext.request.contextPath}/admin/registrations" class="small fw-semibold text-primary">View All &rarr;</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-custom align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Pass No</th>
                                    <th>Student</th>
                                    <th>Event</th>
                                    <th>Type</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${recentRegistrations}">
                                    <tr>
                                        <td><code>${r.registrationNumber}</code></td>
                                        <td>
                                            <div class="fw-semibold small">${r.studentName}</div>
                                            <div class="text-muted small" style="font-size: 0.75rem;">${r.studentIdCode}</div>
                                        </td>
                                        <td class="small">${r.eventTitle}</td>
                                        <td><span class="badge ${r.registrationType == 'GROUP' ? 'bg-info' : 'bg-secondary'}">${r.registrationType}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
