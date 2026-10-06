<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics &bull; Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="admin-reports"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Reports & Analytics</h3>
                <p class="text-muted small mb-0">Cross-club performance, participation, and operational metrics</p>
            </div>
            <button onclick="window.print()" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-printer me-1"></i> Print / Export Report
            </button>
        </div>

        <!-- Metric Stat Cards -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-collection-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${overallStats.totalClubs}</h4>
                        <span class="text-muted small">Total Active Clubs</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="bi bi-mortarboard-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${overallStats.totalStudents}</h4>
                        <span class="text-muted small">Total Students</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-ticket-perforated-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${overallStats.totalRegistrations}</h4>
                        <span class="text-muted small">Total Registrations</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-6 col-lg-3">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="bi bi-calendar-event-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${overallStats.totalEvents}</h4>
                        <span class="text-muted small">Total Events Hosted</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Club Performance Breakdown Table -->
        <div class="card card-custom p-4 mb-4">
            <h5 class="fw-bold mb-3">Club-Wise Performance Breakdown (All 26 Clubs)</h5>
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Club Code</th>
                            <th>Club Name</th>
                            <th>Category</th>
                            <th>Core Members</th>
                            <th>Events Hosted</th>
                            <th>Total Registrations</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="cs" items="${clubStats}">
                            <tr>
                                <td><code>${cs.clubCode}</code></td>
                                <td class="fw-bold text-dark">${cs.clubName}</td>
                                <td><span class="badge bg-light text-secondary border">${cs.category}</span></td>
                                <td><span class="fw-bold">${cs.membersCount}</span></td>
                                <td><span class="fw-bold">${cs.eventsCount}</span></td>
                                <td><span class="badge badge-soft-primary px-3 py-1 fs-6">${cs.registrationsCount}</span></td>
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
