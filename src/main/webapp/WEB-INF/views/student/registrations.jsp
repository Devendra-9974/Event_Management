<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Registrations &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="stu-regs"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">My Event Registration Passes</h3>
                <p class="text-muted small mb-0">Review confirmed event bookings, group teammates, and campus venue details</p>
            </div>
            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-sm fw-semibold">
                <i class="bi bi-plus-circle me-1"></i> Explore More Events
            </a>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <c:choose>
                <c:when test="${empty registrations}">
                    <div class="col-12">
                        <div class="card card-custom p-5 text-center text-muted">
                            <i class="bi bi-ticket-perforated fs-1 mb-2"></i>
                            <h5>You don't have any event tickets or registrations yet.</h5>
                            <p class="small">Browse active hackathons, workshops, and fests organized by our 26 clubs!</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-sm align-self-center">Browse Events</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="r" items="${registrations}">
                        <div class="col-md-6">
                            <div class="card card-custom p-4 h-100 border">
                                <div class="d-flex justify-content-between align-items-start mb-3 border-bottom pb-3">
                                    <div>
                                        <span class="badge bg-light text-primary border small mb-1">${r.clubName}</span>
                                        <h5 class="fw-bold text-dark mb-0">${r.eventTitle}</h5>
                                    </div>
                                    <span class="badge ${r.status == 'CONFIRMED' ? 'badge-soft-success' : 'badge-soft-danger'}">
                                        ${r.status}
                                    </span>
                                </div>

                                <div class="row g-2 small text-secondary mb-3">
                                    <div class="col-6">
                                        <strong>Pass Ref:</strong> <code>${r.registrationNumber}</code>
                                    </div>
                                    <div class="col-6">
                                        <strong>Format:</strong> <span class="badge ${r.registrationType == 'GROUP' ? 'bg-info' : 'bg-secondary'}">${r.registrationType}</span>
                                    </div>
                                    <div class="col-6">
                                        <i class="bi bi-calendar3 me-1 text-primary"></i> ${r.eventDate}
                                    </div>
                                    <div class="col-6">
                                        <i class="bi bi-geo-alt me-1 text-danger"></i> ${r.eventVenue}
                                    </div>
                                </div>

                                <c:if test="${r.registrationType == 'GROUP'}">
                                    <div class="p-3 bg-light rounded-3 mb-3 small">
                                        <div class="fw-bold text-dark mb-1">
                                            <i class="bi bi-people-fill text-primary me-1"></i> Team: ${r.groupName} (${r.groupSize} Members)
                                        </div>
                                        <div class="text-muted">Registered with designated team participants.</div>
                                    </div>
                                </c:if>

                                <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                                    <span class="text-muted small">Booked on: ${r.registeredAt}</span>
                                    <c:if test="${r.status == 'CONFIRMED'}">
                                        <form action="${pageContext.request.contextPath}/student/registration/cancel" method="post" onsubmit="return confirm('Cancel this event registration pass?');">
                                            <input type="hidden" name="registrationId" value="${r.id}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm">Cancel Booking</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
