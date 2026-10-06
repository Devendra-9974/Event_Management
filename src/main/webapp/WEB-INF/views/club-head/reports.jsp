<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club Analytics &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-reports"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">${club.name} Analytics</h3>
                <p class="text-muted small mb-0">Engagement overview, event turnover, and task completion rates</p>
            </div>
            <button onclick="window.print()" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-printer me-1"></i> Print Report
            </button>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-people-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalMembers}</h4>
                        <span class="text-muted small">Total Members</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="bi bi-calendar2-week-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalEvents}</h4>
                        <span class="text-muted small">Events Hosted</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-ticket-perforated-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.totalRegistrations}</h4>
                        <span class="text-muted small">Total Registrations</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="bi bi-check2-circle"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${stats.completedTasks} / ${stats.totalTasks}</h4>
                        <span class="text-muted small">Tasks Completed</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="card card-custom p-4 mb-4">
            <h5 class="fw-bold mb-3">Event Participation Statistics</h5>
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Event Name</th>
                            <th>Date</th>
                            <th>Venue</th>
                            <th>Capacity</th>
                            <th>Attendance / Registered</th>
                            <th>Occupancy Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${events}">
                            <tr>
                                <td class="fw-bold text-dark">${e.title}</td>
                                <td class="small text-secondary">${e.eventDate}</td>
                                <td class="small text-secondary">${e.venue}</td>
                                <td>${e.capacity}</td>
                                <td><span class="fw-bold text-primary">${e.registeredCount}</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px;">
                                            <div class="progress-bar bg-primary" style="width: ${(e.registeredCount / e.capacity) * 100}%"></div>
                                        </div>
                                        <span class="small text-muted">${Math.round((e.registeredCount * 100.0) / e.capacity)}%</span>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
