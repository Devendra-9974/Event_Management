<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Events &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-4">
    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
        <div>
            <h2 class="fw-bold mb-1">Browse College Events</h2>
            <p class="text-muted mb-0">Discover workshops, hackathons, and cultural fests across all 26 Arya clubs</p>
        </div>
    </div>

    <!-- Search / Filter -->
    <div class="card card-custom p-3 mb-4">
        <form action="${pageContext.request.contextPath}/events" method="get" class="row g-2 align-items-center">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted"><i class="bi bi-search"></i></span>
                    <input type="text" name="search" class="form-control border-start-0" placeholder="Search event title or venue..." value="${keyword}">
                </div>
            </div>
            <div class="col-md-3">
                <select name="clubId" class="form-select">
                    <option value="">All Clubs</option>
                    <c:forEach var="c" items="${allClubs}">
                        <option value="${c.id}" ${selectedClubId == c.id ? 'selected' : ''}>${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3">
                <select name="type" class="form-select">
                    <option value="ALL">All Event Types</option>
                    <option value="HACKATHON" ${selectedType == 'HACKATHON' ? 'selected' : ''}>Hackathons</option>
                    <option value="WORKSHOP" ${selectedType == 'WORKSHOP' ? 'selected' : ''}>Workshops</option>
                    <option value="COMPETITION" ${selectedType == 'COMPETITION' ? 'selected' : ''}>Competitions</option>
                    <option value="CULTURAL" ${selectedType == 'CULTURAL' ? 'selected' : ''}>Cultural</option>
                    <option value="SEMINAR" ${selectedType == 'SEMINAR' ? 'selected' : ''}>Seminars</option>
                </select>
            </div>
            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary w-100 fw-semibold">Filter</button>
                <c:if test="${not empty keyword or not empty selectedClubId or not empty selectedType}">
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-secondary"><i class="bi bi-arrow-counterclockwise"></i></a>
                </c:if>
            </div>
        </form>
    </div>

    <!-- Events Cards -->
    <div class="row g-4">
        <c:choose>
            <c:when test="${empty events}">
                <div class="col-12">
                    <div class="card card-custom p-5 text-center text-muted">
                        <i class="bi bi-calendar-x fs-1 mb-2"></i>
                        <h5>No events found matching your criteria.</h5>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="e" items="${events}">
                    <div class="col-md-6 col-lg-4">
                        <div class="card card-custom h-100 d-flex flex-column">
                            <div class="p-4 flex-grow-1">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <span class="badge bg-light text-primary border fw-semibold">${e.clubName}</span>
                                    <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : 'badge-soft-warning'}">
                                        ${e.status}
                                    </span>
                                </div>
                                <h5 class="fw-bold text-dark mb-2">${e.title}</h5>
                                <p class="text-muted small mb-3">
                                    <c:choose>
                                        <c:when test="${e.description.length() > 100}">
                                            ${e.description.substring(0, 100)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${e.description}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <div class="small text-secondary mb-3">
                                    <div><i class="bi bi-calendar3 me-2 text-primary"></i> ${e.eventDate} (${e.startTime} - ${e.endTime})</div>
                                    <div><i class="bi bi-geo-alt-fill me-2 text-danger"></i> ${e.venue}</div>
                                    <div><i class="bi bi-people-fill me-2 text-info"></i> Format: <strong>${e.participationType}</strong></div>
                                </div>
                            </div>
                            <div class="card-footer bg-white border-top p-3 d-flex justify-content-between align-items-center">
                                <a href="${pageContext.request.contextPath}/events?action=view&id=${e.id}" class="btn btn-outline-secondary btn-sm fw-semibold">
                                    Details
                                </a>
                                <c:choose>
                                    <c:when test="${e.registeredByCurrentUser}">
                                        <span class="badge badge-soft-success py-2 px-3"><i class="bi bi-check2-circle me-1"></i> Registered</span>
                                    </c:when>
                                    <c:when test="${e.status == 'REGISTRATION_OPEN'}">
                                        <a href="${pageContext.request.contextPath}/event/register?eventId=${e.id}" class="btn btn-primary btn-sm fw-semibold px-3">
                                            Register Now
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-secondary btn-sm" disabled>Closed</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
