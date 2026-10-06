<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Hub &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="stu-dash"/>
    </jsp:include>

    <main class="main-content">
        <!-- Student Welcome Banner -->
        <div class="card card-custom p-4 p-md-5 mb-4 border-0 text-white shadow-sm" style="background: linear-gradient(135deg, #1e3a8a 0%, #2563eb 100%);">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <span class="badge bg-white text-primary fw-bold mb-2">Student Dashboard</span>
                    <h2 class="fw-bold mb-2">Welcome, ${sessionScope.currentUser.fullName}!</h2>
                    <p class="lead opacity-75 mb-3" style="font-size: 1.05rem;">
                        Explore 26 campus clubs, join high-impact hackathons, participate in cultural events, and keep track of your event tickets.
                    </p>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/events" class="btn btn-light fw-semibold text-primary px-3">
                            <i class="bi bi-compass me-1"></i> Browse Upcoming Events
                        </a>
                        <a href="${pageContext.request.contextPath}/student/registrations" class="btn btn-outline-light fw-semibold px-3">
                            <i class="bi bi-ticket-perforated me-1"></i> My Passes (${registrations.size()})
                        </a>
                    </div>
                </div>
                <div class="col-md-4 text-md-end d-none d-md-block">
                    <div class="bg-white bg-opacity-10 p-3 rounded-4 border border-white border-opacity-25 text-center">
                        <div class="small text-uppercase opacity-75">Student ID</div>
                        <div class="h4 fw-bold mb-1">${sessionScope.currentUser.studentId}</div>
                        <div class="small opacity-75">${sessionScope.currentUser.department}</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row g-3 mb-4">
            <div class="col-sm-4">
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="bi bi-ticket-detailed-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${registrations.size()}</h4>
                        <span class="text-muted small">My Registrations</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="bi bi-calendar-event-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${upcomingEvents.size()}</h4>
                        <span class="text-muted small">Upcoming Events</span>
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="bi bi-collection-fill"></i></div>
                    <div>
                        <h4 class="fw-bold mb-0">${clubs.size()}</h4>
                        <span class="text-muted small">College Clubs</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- My Recent Registrations -->
            <div class="col-lg-7">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">My Active Event Registrations</h5>
                        <a href="${pageContext.request.contextPath}/student/registrations" class="small fw-semibold text-primary">All Registrations &rarr;</a>
                    </div>
                    <c:choose>
                        <c:when test="${empty registrations}">
                            <div class="text-center py-4 text-muted">
                                <i class="bi bi-ticket-perforated fs-1 mb-2"></i>
                                <p>You haven't registered for any events yet.</p>
                                <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-sm">Find Events to Join</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="r" items="${registrations}" begin="0" end="3">
                                    <div class="p-3 bg-light rounded-3 border d-flex justify-content-between align-items-center">
                                        <div>
                                            <div class="fw-bold text-dark">${r.eventTitle}</div>
                                            <div class="small text-muted">
                                                <code>${r.registrationNumber}</code> &bull; ${r.clubName} &bull; ${r.eventDate}
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge ${r.status == 'CONFIRMED' ? 'badge-soft-success' : 'badge-soft-danger'} mb-1 d-inline-block">
                                                ${r.status}
                                            </span>
                                            <div class="small text-muted">${r.registrationType}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Featured Upcoming Events -->
            <div class="col-lg-5">
                <div class="card card-custom p-4 h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="fw-bold mb-0">Upcoming Events</h5>
                        <a href="${pageContext.request.contextPath}/events" class="small fw-semibold text-primary">Browse All &rarr;</a>
                    </div>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="e" items="${upcomingEvents}" begin="0" end="3">
                            <div class="p-3 bg-light rounded-3 border">
                                <div class="d-flex justify-content-between align-items-start mb-1">
                                    <strong class="text-dark small">${e.title}</strong>
                                    <span class="badge bg-light text-primary border small">${e.clubName}</span>
                                </div>
                                <div class="small text-secondary mb-2">${e.eventDate} &bull; ${e.venue}</div>
                                <a href="${pageContext.request.contextPath}/events?action=view&id=${e.id}" class="btn btn-outline-primary btn-sm py-0 w-100">
                                    View / Register
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
