<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${event.title} &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-4">
    <div class="row g-4">
        <!-- Event Details Column -->
        <div class="col-lg-8">
            <div class="card card-custom p-4 p-md-5 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="badge bg-primary bg-opacity-10 text-primary fs-6 fw-semibold">${event.clubName}</span>
                    <span class="badge ${event.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : 'badge-soft-warning'} fs-6">
                        ${event.status}
                    </span>
                </div>

                <h2 class="fw-bold text-dark mb-3">${event.title}</h2>
                <p class="lead text-secondary mb-4" style="white-space: pre-line;">${event.description}</p>

                <h5 class="fw-bold mb-3 border-bottom pb-2">Event Schedule & Logistics</h5>
                <div class="row g-3 mb-4">
                    <div class="col-sm-6">
                        <div class="p-3 bg-light rounded-3">
                            <div class="small text-muted"><i class="bi bi-calendar-check text-primary me-1"></i> Date & Time</div>
                            <div class="fw-bold">${event.eventDate}</div>
                            <div class="small text-secondary">${event.startTime} - ${event.endTime}</div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-3 bg-light rounded-3">
                            <div class="small text-muted"><i class="bi bi-geo-alt text-danger me-1"></i> Venue</div>
                            <div class="fw-bold">${event.venue}</div>
                            <div class="small text-secondary">Arya College Campus</div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-3 bg-light rounded-3">
                            <div class="small text-muted"><i class="bi bi-hourglass-split text-warning me-1"></i> Registration Deadline</div>
                            <div class="fw-bold">${event.registrationDeadline}</div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="p-3 bg-light rounded-3">
                            <div class="small text-muted"><i class="bi bi-people text-info me-1"></i> Capacity & Participation</div>
                            <div class="fw-bold">${event.registeredCount} / ${event.capacity} Registered</div>
                            <div class="small text-secondary">Allowed Format: <strong>${event.participationType}</strong></div>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${event.registeredByCurrentUser}">
                        <div class="alert alert-success d-flex align-items-center justify-content-between">
                            <div>
                                <i class="bi bi-check-circle-fill me-2 fs-5"></i>
                                <strong>You are confirmed for this event!</strong> (Ref: ${userRegistration.registrationNumber})
                            </div>
                            <a href="${pageContext.request.contextPath}/student/registrations" class="btn btn-outline-success btn-sm">View Ticket</a>
                        </div>
                    </c:when>
                    <c:when test="${event.status == 'REGISTRATION_OPEN'}">
                        <a href="${pageContext.request.contextPath}/event/register?eventId=${event.id}" class="btn btn-primary btn-lg fw-semibold w-100 shadow-sm py-3">
                            Proceed to Register <i class="bi bi-arrow-right ms-2"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-secondary text-center mb-0">
                            Registrations are currently closed for this event.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- QR Code & Quick Action Sidebar -->
        <div class="col-lg-4">
            <div class="card card-custom p-4 text-center mb-4">
                <h5 class="fw-bold mb-2">Instant Event QR Code</h5>
                <p class="text-muted small mb-3">Scan with your smartphone camera to access this registration page immediately.</p>
                <div class="qr-preview-box mb-3">
                    <img src="${pageContext.request.contextPath}/qr/${event.qrToken}" alt="Event Registration QR" class="img-fluid rounded" style="max-width: 220px;">
                    <div class="mt-2 text-muted small">Token: <code>${event.qrToken}</code></div>
                </div>
                <a href="${pageContext.request.contextPath}/qr/${event.qrToken}?download=true" class="btn btn-outline-secondary btn-sm w-100">
                    <i class="bi bi-download me-1"></i> Download Official QR Poster
                </a>
            </div>

            <div class="card card-custom p-4">
                <h6 class="fw-bold mb-3 text-secondary text-uppercase small">Organizing Club</h6>
                <div class="d-flex align-items-center gap-3 mb-3">
                    <div class="bg-primary text-white rounded-3 p-2 fw-bold fs-5" style="width: 44px; height: 44px; text-align: center;">
                        ${event.clubName.substring(0, 1)}
                    </div>
                    <div>
                        <div class="fw-bold">${event.clubName}</div>
                        <div class="small text-muted">${event.clubCategory}</div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/clubs?action=view&id=${event.clubId}" class="btn btn-light btn-sm w-100 border text-secondary fw-semibold">
                    View Club Profile
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
