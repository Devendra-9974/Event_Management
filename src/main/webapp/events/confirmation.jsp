<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Confirmed &bull; Arya College ClubSphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-6">
            <div class="card card-custom p-4 p-md-5 text-center shadow">
                
                <div class="d-inline-flex bg-success text-white rounded-circle p-3 mb-3 mx-auto shadow-sm">
                    <i class="bi bi-check-lg display-5"></i>
                </div>

                <h3 class="fw-bold text-dark mb-1">Registration Confirmed!</h3>
                <p class="text-muted small mb-4">Your pass for the event has been successfully reserved.</p>

                <div class="p-4 bg-light rounded-4 border text-start mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">
                        <span class="text-muted small">Pass Reference:</span>
                        <code class="fw-bold fs-6 text-primary">${registration.registrationNumber}</code>
                    </div>

                    <div class="mb-2">
                        <div class="small text-muted">Event</div>
                        <div class="fw-bold text-dark">${event.title}</div>
                    </div>

                    <div class="row g-2 mb-2 small text-secondary">
                        <div class="col-6">
                            <strong>Date:</strong> ${event.eventDate}
                        </div>
                        <div class="col-6">
                            <strong>Time:</strong> ${event.startTime} - ${event.endTime}
                        </div>
                    </div>

                    <div class="mb-2 small text-secondary">
                        <strong>Venue:</strong> ${event.venue}
                    </div>

                    <c:if test="${registration.registrationType == 'GROUP'}">
                        <div class="mt-3 pt-2 border-top small text-secondary">
                            <strong>Team Name:</strong> ${registration.groupName} (${registration.groupSize} Members)
                        </div>
                    </c:if>
                </div>

                <div class="d-flex gap-2 justify-content-center">
                    <a href="${pageContext.request.contextPath}/student/registrations" class="btn btn-primary fw-semibold px-4">
                        <i class="bi bi-ticket-detailed me-1"></i> My Registrations
                    </a>
                    <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-secondary px-4">
                        Browse More Events
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
