<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty event ? 'Edit Event' : 'Create Event'} &bull; ${club.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/components/sidebar.jsp">
        <jsp:param name="active" value="head-events"/>
    </jsp:include>

    <main class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">${not empty event ? 'Edit Event Details' : 'Create New Event for ' += club.name}</h3>
                <p class="text-muted small mb-0">Fill out schedule, venue, capacity, and participation rules</p>
            </div>
            <a href="${pageContext.request.contextPath}/club-head/events" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Back to Events
            </a>
        </div>

        <div class="card card-custom p-4 p-md-5">
            <form action="${pageContext.request.contextPath}/club-head/event/save" method="post">
                <c:if test="${not empty event}">
                    <input type="hidden" name="id" value="${event.id}">
                </c:if>

                <div class="row g-3 mb-3">
                    <div class="col-md-8">
                        <label class="form-label small fw-semibold text-secondary">Event Title</label>
                        <input type="text" name="title" class="form-control" placeholder="e.g. Annual Code Hunt 2026" value="${event.title}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Event Type</label>
                        <select name="eventType" class="form-select" required>
                            <option value="HACKATHON" ${event.eventType == 'HACKATHON' ? 'selected' : ''}>Hackathon</option>
                            <option value="WORKSHOP" ${event.eventType == 'WORKSHOP' ? 'selected' : ''}>Workshop</option>
                            <option value="COMPETITION" ${event.eventType == 'COMPETITION' ? 'selected' : ''}>Competition</option>
                            <option value="CULTURAL" ${event.eventType == 'CULTURAL' ? 'selected' : ''}>Cultural</option>
                            <option value="SEMINAR" ${event.eventType == 'SEMINAR' ? 'selected' : ''}>Seminar</option>
                            <option value="SPORTS" ${event.eventType == 'SPORTS' ? 'selected' : ''}>Sports</option>
                            <option value="OTHER" ${event.eventType == 'OTHER' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-secondary">Event Description & Rules</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="Detail the agenda, prerequisites, prizes, and rules..." required>${event.description}</textarea>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Event Date</label>
                        <input type="date" name="eventDate" class="form-control" value="${event.eventDate}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Start Time</label>
                        <input type="time" name="startTime" class="form-control" value="${event.startTime != null ? event.startTime.toString().substring(0, 5) : '09:00'}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">End Time</label>
                        <input type="time" name="endTime" class="form-control" value="${event.endTime != null ? event.endTime.toString().substring(0, 5) : '17:00'}" required>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Campus Venue / Room</label>
                        <input type="text" name="venue" class="form-control" placeholder="e.g. Arya Main Auditorium" value="${event.venue}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Registration Deadline</label>
                        <input type="datetime-local" name="registrationDeadline" class="form-control" value="${event.registrationDeadline != null ? event.registrationDeadline.toString().replace(' ', 'T').substring(0, 16) : '2026-11-10T23:59'}" required>
                    </div>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Max Capacity</label>
                        <input type="number" name="capacity" class="form-control" min="1" value="${event.capacity != null ? event.capacity : 100}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Participation Mode</label>
                        <select name="participationType" class="form-select" required>
                            <option value="INDIVIDUAL" ${event.participationType == 'INDIVIDUAL' ? 'selected' : ''}>Individual Only</option>
                            <option value="GROUP" ${event.participationType == 'GROUP' ? 'selected' : ''}>Group / Teams Only</option>
                            <option value="BOTH" ${event.participationType == 'BOTH' ? 'selected' : ''}>Both Allowed</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Registration Status</label>
                        <select name="status" class="form-select">
                            <option value="REGISTRATION_OPEN" ${event.status == 'REGISTRATION_OPEN' ? 'selected' : ''}>REGISTRATION_OPEN</option>
                            <option value="REGISTRATION_CLOSED" ${event.status == 'REGISTRATION_CLOSED' ? 'selected' : ''}>REGISTRATION_CLOSED</option>
                            <option value="UPCOMING" ${event.status == 'UPCOMING' ? 'selected' : ''}>UPCOMING</option>
                            <option value="COMPLETED" ${event.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                            <option value="CANCELLED" ${event.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                        </select>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary fw-semibold px-4">
                        <i class="bi bi-save me-1"></i> Save Event
                    </button>
                    <a href="${pageContext.request.contextPath}/club-head/events" class="btn btn-outline-secondary">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
