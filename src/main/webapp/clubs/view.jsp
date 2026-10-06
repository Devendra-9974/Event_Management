<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${club.name} &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-4">
    <!-- Club Header Card -->
    <div class="card card-custom p-4 p-md-5 mb-4 border-0 bg-white shadow-sm">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start gap-4">
            <div class="d-flex align-items-start gap-4">
                <div class="bg-primary text-white rounded-4 p-4 fw-bold display-6 d-flex align-items-center justify-content-center shadow-sm" style="width: 80px; height: 80px;">
                    ${club.name.substring(0, 1)}
                </div>
                <div>
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <span class="badge bg-primary bg-opacity-10 text-primary fw-semibold">${club.clubCode}</span>
                        <span class="badge bg-secondary bg-opacity-10 text-secondary fw-semibold">${club.category}</span>
                        <span class="badge ${club.status == 'ACTIVE' ? 'badge-soft-success' : 'badge-soft-danger'}">${club.status}</span>
                    </div>
                    <h2 class="fw-bold mb-2 text-dark">${club.name}</h2>
                    <p class="text-muted mb-3">${club.description}</p>
                    <div class="d-flex flex-wrap gap-4 text-secondary small">
                        <div><i class="bi bi-geo-alt-fill text-danger me-1"></i> ${club.meetingVenue}</div>
                        <div><i class="bi bi-envelope-fill text-primary me-1"></i> ${club.contactEmail}</div>
                        <div><i class="bi bi-telephone-fill text-success me-1"></i> ${club.contactPhone}</div>
                    </div>
                </div>
            </div>

            <div class="bg-light p-3 rounded-3 border text-center align-self-stretch align-self-md-auto" style="min-width: 200px;">
                <div class="small text-muted mb-1">Faculty Advisor</div>
                <div class="fw-bold text-dark mb-2">${club.facultyAdvisor}</div>
                <div class="small text-muted mb-1">Club Head Lead</div>
                <div class="fw-bold text-primary">${not empty club.headUserName ? club.headUserName : 'Not Assigned'}</div>
            </div>
        </div>
    </div>

    <!-- Navigation Tabs -->
    <ul class="nav nav-tabs mb-4 border-bottom" id="clubTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active fw-semibold" id="events-tab" data-bs-toggle="tab" data-bs-target="#events-content" type="button">
                <i class="bi bi-calendar-event me-1"></i> Club Events (${events.size()})
            </button>
        </li>
        <li class="nav-item">
            <button class="nav-link fw-semibold" id="members-tab" data-bs-toggle="tab" data-bs-target="#members-content" type="button">
                <i class="bi bi-people me-1"></i> Active Members (${members.size()})
            </button>
        </li>
    </ul>

    <!-- Tab Contents -->
    <div class="tab-content" id="clubTabsContent">
        <!-- Events Tab -->
        <div class="tab-pane fade show active" id="events-content" role="tabpanel">
            <c:choose>
                <c:when test="${empty events}">
                    <div class="card card-custom p-5 text-center text-muted">
                        <i class="bi bi-calendar-x fs-1 mb-2"></i>
                        <h5>No events currently scheduled for this club.</h5>
                        <p class="small">Check back soon or explore other active clubs.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="e" items="${events}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card card-custom h-100 p-4 d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge bg-light text-secondary border">${e.eventType}</span>
                                        <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : 'badge-soft-warning'}">${e.status}</span>
                                    </div>
                                    <h5 class="fw-bold mb-2 text-dark">${e.title}</h5>
                                    <p class="text-muted small mb-3 flex-grow-1">${e.description}</p>
                                    <div class="small text-secondary mb-3">
                                        <div><i class="bi bi-calendar-date me-2 text-primary"></i> ${e.eventDate} (${e.startTime} - ${e.endTime})</div>
                                        <div><i class="bi bi-geo-alt me-2 text-danger"></i> ${e.venue}</div>
                                        <div><i class="bi bi-people me-2 text-info"></i> Capacity: ${e.registeredCount} / ${e.capacity}</div>
                                    </div>
                                    <div class="d-flex gap-2 mt-auto">
                                        <a href="${pageContext.request.contextPath}/events?action=view&id=${e.id}" class="btn btn-outline-primary btn-sm w-100 fw-semibold">View Details</a>
                                        <a href="${pageContext.request.contextPath}/event/register?eventId=${e.id}" class="btn btn-primary btn-sm w-100 fw-semibold">Register</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Members Tab -->
        <div class="tab-pane fade" id="members-content" role="tabpanel">
            <div class="card card-custom p-0 overflow-hidden">
                <table class="table table-custom mb-0">
                    <thead>
                        <tr>
                            <th>Member Name</th>
                            <th>Student ID</th>
                            <th>Department</th>
                            <th>Role in Club</th>
                            <th>Joined Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${members}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-light text-primary rounded-circle fw-bold p-2 small border" style="width: 32px; height: 32px; text-align: center; line-height: 14px;">
                                            ${m.userName.substring(0, 1)}
                                        </div>
                                        <div>
                                            <div class="fw-bold">${m.userName}</div>
                                            <div class="text-muted small">${m.userEmail}</div>
                                        </div>
                                    </div>
                                </td>
                                <td><code>${m.studentId}</code></td>
                                <td>${m.department}</td>
                                <td><span class="badge ${m.memberRole == 'COORDINATOR' ? 'bg-primary' : 'bg-secondary'}">${m.memberRole}</span></td>
                                <td>${m.joinedDate}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
