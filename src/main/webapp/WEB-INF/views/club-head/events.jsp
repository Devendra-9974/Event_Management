<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events &bull; ${club.name}</title>
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
                <h3 class="fw-bold mb-1">${club.name} Events</h3>
                <p class="text-muted small mb-0">Create, edit, cancel events, and generate QR code registration passes</p>
            </div>
            <a href="${pageContext.request.contextPath}/club-head/event/create" class="btn btn-primary btn-sm fw-semibold">
                <i class="bi bi-plus-circle me-1"></i> Create New Event
            </a>
        </div>

        <c:if test="${not empty param.message}">
            <div class="alert alert-success py-2 small alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-1"></i> ${param.message}
                <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card card-custom p-0 overflow-hidden">
            <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Title & Type</th>
                            <th>Date & Time</th>
                            <th>Venue</th>
                            <th>Deadline</th>
                            <th>Capacity</th>
                            <th>Status</th>
                            <th>QR Code</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="e" items="${events}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${e.title}</div>
                                    <span class="badge bg-light text-secondary border small">${e.eventType} &bull; ${e.participationType}</span>
                                </td>
                                <td>
                                    <div class="fw-semibold small">${e.eventDate}</div>
                                    <div class="text-muted small">${e.startTime} - ${e.endTime}</div>
                                </td>
                                <td class="small text-secondary">${e.venue}</td>
                                <td class="small text-danger">${e.registrationDeadline}</td>
                                <td>
                                    <span class="fw-bold">${e.registeredCount} / ${e.capacity}</span>
                                </td>
                                <td>
                                    <span class="badge ${e.status == 'REGISTRATION_OPEN' ? 'badge-soft-success' : (e.status == 'CANCELLED' ? 'badge-soft-danger' : 'badge-soft-warning')}">
                                        ${e.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/club-head/event/qr?id=${e.id}" class="btn btn-sm btn-outline-primary">
                                        <i class="bi bi-qr-code me-1"></i> QR
                                    </a>
                                </td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <a href="${pageContext.request.contextPath}/club-head/event/edit?id=${e.id}" class="btn btn-sm btn-outline-secondary" title="Edit Event">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <c:if test="${e.status != 'CANCELLED'}">
                                            <form action="${pageContext.request.contextPath}/club-head/event/cancel" method="post" onsubmit="return confirm('Cancel this event?');" class="d-inline">
                                                <input type="hidden" name="id" value="${e.id}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancel Event">
                                                    <i class="bi bi-x-circle"></i>
                                                </button>
                                            </form>
                                        </c:if>
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
